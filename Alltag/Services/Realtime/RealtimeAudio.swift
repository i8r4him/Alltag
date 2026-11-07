//
//  RealtimeAudio.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import AVFoundation

protocol RealtimeAudio: AnyObject {
    var hasPlayback: Bool { get }
    func requestPermission() async -> Bool
    func start() throws -> AsyncThrowingStream<Data, any Error>
    func play(_ data: Data, item: String, onPlayed: @escaping @MainActor @Sendable () -> Void) throws
    func interrupt() -> (item: String, milliseconds: Int)?
    func stop()
}

/// One voice-processing audio engine for microphone input and companion playback.
final class SystemRealtimeAudio: RealtimeAudio {
    nonisolated static let sampleRate = 24_000
    private let engine = AVAudioEngine()
    private let player = AVAudioPlayerNode()
    private var input: AsyncThrowingStream<Data, any Error>.Continuation?
    private var observers: [any NSObjectProtocol] = []
    private var hasTap = false
    private var isActive = false
    private var item: String?
    private var framesScheduled: AVAudioFramePosition = 0
    private var pendingBuffers = 0
    private var playbackGeneration = 0
    private var playbackFormat: AVAudioFormat?
    private var onPlaybackDrained: (@MainActor @Sendable () -> Void)?
    var hasPlayback: Bool { pendingBuffers > 0 }

    func requestPermission() async -> Bool {
        await AVAudioApplication.requestRecordPermission()
    }

    func start() throws -> AsyncThrowingStream<Data, any Error> {
        let session = AVAudioSession.sharedInstance()
        try session.setCategory(.playAndRecord, mode: .voiceChat, options: [.defaultToSpeaker, .allowBluetoothHFP])
        try session.setActive(true)
        isActive = true
        try engine.inputNode.setVoiceProcessingEnabled(true)

        let sampleRate = Double(Self.sampleRate)
        guard let pcm = AVAudioFormat(commonFormat: .pcmFormatInt16, sampleRate: sampleRate, channels: 1, interleaved: true),
              let playback = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1) else {
            throw RealtimeServiceError.unavailable
        }
        playbackFormat = playback
        engine.attach(player)
        try engine.connectNode(player, to: engine.mainMixerNode, format: playback)
        let (stream, continuation) = AsyncThrowingStream.makeStream(of: Data.self, bufferingPolicy: .bufferingOldest(128))
        input = continuation
        try startEngine(recordingIn: pcm, continuation: continuation)
        watchAudioChanges(session: session, recordingIn: pcm, continuation: continuation)
        return stream
    }

    func play(_ data: Data, item: String, onPlayed: @escaping @MainActor @Sendable () -> Void) throws {
        let sampleSize = MemoryLayout<Int16>.size
        let frames = data.count / sampleSize
        guard frames > 0, data.count.isMultiple(of: sampleSize),
              let playbackFormat, let buffer = AVAudioPCMBuffer(pcmFormat: playbackFormat, frameCapacity: AVAudioFrameCount(frames)),
              let samples = buffer.floatChannelData?[0] else { throw RealtimeServiceError.unexpectedResponse }
        buffer.frameLength = AVAudioFrameCount(frames)
        data.withUnsafeBytes { (bytes: UnsafeRawBufferPointer) in
            for frame in 0..<frames {
                let sample = bytes.loadUnaligned(fromByteOffset: frame * sampleSize, as: Int16.self)
                samples[frame] = Float(Int16(littleEndian: sample)) / 32_768
            }
        }

        if self.item != item {
            clearPlayback()
            self.item = item
        }
        pendingBuffers += 1
        framesScheduled += AVAudioFramePosition(frames)
        onPlaybackDrained = onPlayed
        let generation = playbackGeneration
        player.scheduleBuffer(buffer, completionCallbackType: .dataPlayedBack) { @Sendable [weak self] _ in
            Task { @MainActor [weak self] in
                guard let self, self.playbackGeneration == generation else { return }
                self.pendingBuffers -= 1
                if !self.hasPlayback {
                    self.onPlaybackDrained = nil
                    onPlayed()
                }
            }
        }
        if !player.isPlaying { try player.playAudio() }
    }

    func interrupt() -> (item: String, milliseconds: Int)? {
        guard let item, hasPlayback else { return nil }
        let sampleTime = player.lastRenderTime.flatMap { player.playerTime(forNodeTime: $0)?.sampleTime } ?? 0
        let played = max(0, min(sampleTime, framesScheduled))
        clearPlayback()
        return (item, Int(played * 1_000 / AVAudioFramePosition(Self.sampleRate)))
    }

    func stop() {
        input?.finish()
        input = nil
        for observer in observers { NotificationCenter.default.removeObserver(observer) }
        observers.removeAll()
        guard isActive else { return }
        clearPlayback()
        removeTap()
        engine.stop()
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        isActive = false
    }

    private func clearPlayback() {
        playbackGeneration += 1
        pendingBuffers = 0
        framesScheduled = 0
        item = nil
        onPlaybackDrained = nil
        player.stop()
    }

    private func removeTap() {
        guard hasTap else { return }
        engine.inputNode.removeTap(onBus: 0)
        hasTap = false
    }

    private func startEngine(recordingIn format: AVAudioFormat, continuation: AsyncThrowingStream<Data, any Error>.Continuation) throws {
        let microphone = engine.inputNode
        if !microphone.isVoiceProcessingEnabled { try microphone.setVoiceProcessingEnabled(true) }
        try Self.installTap(on: microphone, outputFormat: format, continuation: continuation)
        hasTap = true
        engine.prepare()
        try engine.start()
    }

    private func restartEngine(recordingIn format: AVAudioFormat) {
        guard let input, !engine.isRunning else { return }
        // A route change can invalidate queued playback and the tap's hardware format.
        let onPlaybackDrained = self.onPlaybackDrained
        clearPlayback()
        removeTap()
        do {
            try startEngine(recordingIn: format, continuation: input)
            onPlaybackDrained?()
        } catch {
            input.finish(throwing: error)
        }
    }

    private func watchAudioChanges(
        session: AVAudioSession,
        recordingIn format: AVAudioFormat,
        continuation: AsyncThrowingStream<Data, any Error>.Continuation
    ) {
        let centre = NotificationCenter.default
        observers = [
            centre.addObserver(forName: .AVAudioEngineConfigurationChange, object: engine, queue: nil) { @Sendable [weak self] _ in
                Task { @MainActor [weak self] in self?.restartEngine(recordingIn: format) }
            },
            centre.addObserver(forName: AVAudioSession.interruptionNotification, object: session, queue: nil) { @Sendable _ in
                continuation.finish(throwing: RealtimeServiceError.unavailable)
            }
        ]
    }

    nonisolated private static func installTap(
        on microphone: AVAudioInputNode,
        outputFormat: AVAudioFormat,
        continuation: AsyncThrowingStream<Data, any Error>.Continuation
    ) throws {
        let format = microphone.outputFormat(forBus: 0)
        guard format.sampleRate > 0, format.channelCount > 0,
              let converter = AVAudioConverter(from: format, to: outputFormat) else {
            throw RealtimeServiceError.unavailable
        }
        let ratio = outputFormat.sampleRate / format.sampleRate
        // The iOS 27 SDK imports the throwing tap installer under this name.
        try microphone.__installTap(onBus: 0, bufferSize: 2_048, format: format, error: ()) { @Sendable buffer, _ in
            let capacity = AVAudioFrameCount((Double(buffer.frameLength) * ratio).rounded(.up))
            guard let pcm = AVAudioPCMBuffer(pcmFormat: outputFormat, frameCapacity: capacity) else { return }
            var consumed = false
            var error: NSError?
            converter.convert(to: pcm, error: &error) { _, status in
                status.pointee = consumed ? .noDataNow : .haveData
                guard !consumed else { return nil }
                consumed = true
                return buffer
            }
            guard error == nil, let samples = pcm.int16ChannelData?[0] else {
                continuation.finish(throwing: RealtimeServiceError.unavailable)
                return
            }
            guard pcm.frameLength > 0 else { return }
            let data = Data(bytes: samples, count: Int(pcm.frameLength) * MemoryLayout<Int16>.size)
            if case .dropped = continuation.yield(data) {
                continuation.finish(throwing: RealtimeServiceError.unavailable)
            }
        }
    }
}
