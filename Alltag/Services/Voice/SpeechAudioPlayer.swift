//
//  SpeechAudioPlayer.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import AVFoundation

/// Plays one spoken sentence and returns when it has finished or was stopped.
protocol SpeechAudioPlayer: AnyObject {
    func play(_ url: URL, rate: SpeechRate) async throws
    func stop()
}

/// Plays the cloud voice's audio with `AVAudioPlayer`. "Slowly" lowers the rate, which keeps
/// the pitch, so the voice sounds the same, only slower.
final class SystemSpeechAudioPlayer: NSObject, SpeechAudioPlayer {
    /// How much slower "Slowly" is, like the iPhone voice's 0.7.
    static let slowRate: Float = 0.75

    private var player: AVAudioPlayer?
    private var continuation: CheckedContinuation<Void, Never>?

    func play(_ url: URL, rate: SpeechRate) async throws {
        stop()
        try await Self.prepareSession()
        let player = try AVAudioPlayer(contentsOf: url)
        player.delegate = self
        player.enableRate = true
        player.rate = rate == .slow ? Self.slowRate : 1
        self.player = player
        await withCheckedContinuation { continuation in
            self.continuation = continuation
            if !player.play() { finish() }
        }
    }

    func stop() {
        player?.stop()
        player = nil
        finish()
    }

    /// The learner asked to hear it, so it plays with the silent switch on. A conversation or
    /// a recording that holds the microphone keeps its own session, so it isn't interrupted.
    /// Away from the main thread: setting the session can block for a moment.
    nonisolated private static func prepareSession() async throws {
        try await Task.detached {
            let session = AVAudioSession.sharedInstance()
            guard session.category != .playAndRecord else { return }
            try session.setCategory(.playback, mode: .spokenAudio, options: [.duckOthers])
            try session.setActive(true)
        }.value
    }

    private func finish() {
        continuation?.resume()
        continuation = nil
    }

    /// Ends the wait only for the sentence that is still playing, not a newer one.
    private func finish(_ finished: ObjectIdentifier) {
        guard let player, ObjectIdentifier(player) == finished else { return }
        self.player = nil
        finish()
    }
}

extension SystemSpeechAudioPlayer: AVAudioPlayerDelegate {
    nonisolated func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        let finished = ObjectIdentifier(player)
        Task { @MainActor in self.finish(finished) }
    }

    nonisolated func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: (any Error)?) {
        let finished = ObjectIdentifier(player)
        Task { @MainActor in self.finish(finished) }
    }
}
