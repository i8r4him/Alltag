//
//  SystemSpeechService.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import AVFoundation
import OSLog
import Speech

/// German speech recognition on device with `SpeechAnalyzer` and `SpeechTranscriber`.
///
/// The first time, it asks for microphone and speech recognition access and
/// downloads the German model if it isn't installed. Audio never leaves the device.
@Observable
final class SystemSpeechService: SpeechService {
    private(set) var authorizationStatus: PermissionStatus
    @ObservationIgnored private var session: ListeningSession?
    @ObservationIgnored private let locale: Locale

    init(locale: Locale = Locale(identifier: "de-DE")) {
        self.locale = locale
        authorizationStatus = Self.currentStatus
    }

    private static var currentStatus: PermissionStatus {
        let microphone = AVAudioApplication.shared.recordPermission
        let speech = SFSpeechRecognizer.authorizationStatus()
        if microphone == .granted, speech == .authorized { return .granted }
        if microphone == .denied || speech == .denied || speech == .restricted { return .denied }
        return .notDetermined
    }

    func requestAuthorization() async -> PermissionStatus {
        let microphone = await AVAudioApplication.requestRecordPermission()
        let speech = await withCheckedContinuation { (continuation: CheckedContinuation<SFSpeechRecognizerAuthorizationStatus, Never>) in
            SFSpeechRecognizer.requestAuthorization { @Sendable status in continuation.resume(returning: status) }
        }
        authorizationStatus = microphone && speech == .authorized ? .granted : .denied
        return authorizationStatus
    }

    func listen(expected: String) -> AsyncThrowingStream<String, any Error> {
        stopListening()
        let session = ListeningSession(locale: locale)
        self.session = session
        let (stream, continuation) = AsyncThrowingStream.makeStream(of: String.self)
        let task = Task {
            do {
                if authorizationStatus != .granted, await requestAuthorization() != .granted {
                    throw SpeechError.notAuthorized
                }
                try await session.run { continuation.yield($0) }
                continuation.finish()
            } catch {
                continuation.finish(throwing: error)
            }
        }
        continuation.onTermination = { _ in
            task.cancel()
            Task { await session.stop() }
        }
        return stream
    }

    func stopListening() {
        guard let session else { return }
        self.session = nil
        Task { await session.stop() }
    }
}

/// One listening turn: microphone → analyzer → transcript.
private actor ListeningSession {
    private let locale: Locale
    private var analyzer: SpeechAnalyzer?
    private var microphone: Microphone?
    private var input: AsyncStream<AnalyzerInput>.Continuation?
    private var isStopped = false
    private let logger = Logger(subsystem: "Alltag", category: "Speech")

    init(locale: Locale) {
        self.locale = locale
    }

    /// Listens until `stop()`, calling `onText` with the transcript so far.
    func run(onText: @Sendable (String) -> Void) async throws {
        guard SpeechTranscriber.isAvailable,
              let supported = await SpeechTranscriber.supportedLocale(equivalentTo: locale) else {
            throw SpeechError.unsupported
        }
        let transcriber = SpeechTranscriber(locale: supported, transcriptionOptions: [],
                                            reportingOptions: [.volatileResults], attributeOptions: [])
        if let request = try await AssetInventory.assetInstallationRequest(supporting: [transcriber]) {
            logger.info("Downloading the speech model for \(supported.identifier, privacy: .public)")
            try await request.downloadAndInstall()
        }
        guard let format = await SpeechAnalyzer.bestAvailableAudioFormat(compatibleWith: [transcriber]) else {
            throw SpeechError.unsupported
        }
        guard !isStopped else { return }

        let (stream, input) = AsyncStream.makeStream(of: AnalyzerInput.self)
        let analyzer = SpeechAnalyzer(modules: [transcriber])
        try await analyzer.start(inputSequence: stream)
        let microphone = try Microphone(format: format) { input.yield(AnalyzerInput(buffer: $0)) }
        self.analyzer = analyzer
        self.input = input
        self.microphone = microphone
        guard !isStopped else { return await stop() }

        var finalized = ""
        for try await result in transcriber.results {
            let text = String(result.text.characters)
            if result.isFinal {
                finalized += text
                onText(Self.trimmed(finalized))
            } else {
                onText(Self.trimmed(finalized + text))
            }
        }
    }

    /// Stops the microphone and lets the analyzer finish the last words.
    func stop() async {
        isStopped = true
        microphone?.stop()
        microphone = nil
        input?.finish()
        input = nil
        try? await analyzer?.finalizeAndFinishThroughEndOfInput()
        analyzer = nil
    }

    private static func trimmed(_ text: String) -> String {
        text.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}

/// The microphone, converted to the analyzer's audio format.
///
/// Its tap runs on the audio thread, so it lives outside the main actor.
nonisolated private final class Microphone: @unchecked Sendable {
    private let engine = AVAudioEngine()

    init(format: AVAudioFormat, onBuffer: @escaping @Sendable (AVAudioPCMBuffer) -> Void) throws {
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.playAndRecord, mode: .measurement, options: [.duckOthers, .defaultToSpeaker])
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

        let inputNode = engine.inputNode
        let inputFormat = inputNode.outputFormat(forBus: 0)
        guard let converter = AVAudioConverter(from: inputFormat, to: format) else { throw SpeechError.unsupported }
        let ratio = format.sampleRate / inputFormat.sampleRate

        // iOS 27 deprecates `installTap(onBus:bufferSize:format:block:)` for a throwing variant.
        // The 27.2 SDK doesn't refine that one for Swift yet, so it's called by its imported
        // name (the `error: ()` is how the importer spells the thrown error). Switch to the
        // refined name once the SDK has it.
        try inputNode.__installTap(onBus: 0, bufferSize: 4096, format: inputFormat, error: ()) { @Sendable buffer, _ in
            let capacity = AVAudioFrameCount((Double(buffer.frameLength) * ratio).rounded(.up))
            guard let converted = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: capacity) else { return }
            var isConsumed = false
            var error: NSError?
            converter.convert(to: converted, error: &error) { _, status in
                if isConsumed {
                    status.pointee = .noDataNow
                    return nil
                }
                isConsumed = true
                status.pointee = .haveData
                return buffer
            }
            if error == nil, converted.frameLength > 0 { onBuffer(converted) }
        }
        engine.prepare()
        try engine.start()
    }

    func stop() {
        engine.inputNode.removeTap(onBus: 0)
        engine.stop()
    }
}
