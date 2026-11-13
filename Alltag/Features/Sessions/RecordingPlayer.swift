//
//  RecordingPlayer.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 12.11.26.
//

import AVFoundation
import OSLog

/// Plays a session's recording: one button, play or stop.
@Observable
final class RecordingPlayer {
    private(set) var isPlaying = false
    @ObservationIgnored private let engine = Engine()
    @ObservationIgnored private var task: Task<Void, Never>?
    @ObservationIgnored private let logger = Logger(subsystem: "i8r4him.Alltag", category: "Sound")

    func toggle(_ url: URL) {
        if isPlaying {
            stop()
            return
        }
        isPlaying = true
        task = Task { [weak self, engine, logger] in
            do {
                try await engine.play(url)
                // The player has no async "finished"; look until it stops.
                while await engine.isPlaying, !Task.isCancelled {
                    try? await Task.sleep(for: .milliseconds(250))
                }
            } catch {
                logger.error("Couldn't play a recording: \(error.localizedDescription, privacy: .public)")
            }
            if !Task.isCancelled { self?.isPlaying = false }
        }
    }

    func stop() {
        task?.cancel()
        task = nil
        isPlaying = false
        Task { [engine] in await engine.stop() }
    }

    /// Owns the audio player away from the main thread: starting playback
    /// activates the audio session, which can block for a moment.
    private actor Engine {
        private var player: AVAudioPlayer?

        var isPlaying: Bool { player?.isPlaying ?? false }

        func play(_ url: URL) throws {
            // The learner asked to hear it, so it plays even with the silent switch on.
            try AVAudioSession.sharedInstance().setCategory(.playback)
            let player = try AVAudioPlayer(contentsOf: url)
            player.play()
            self.player = player
        }

        func stop() {
            player?.stop()
            player = nil
        }
    }
}
