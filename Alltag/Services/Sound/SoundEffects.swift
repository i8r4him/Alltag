//
//  SoundEffects.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 11.11.26.
//

import AVFoundation
import OSLog

/// Short sounds in the app's own voice. They follow the silent switch, like
/// keyboard clicks, and never interrupt music or a podcast.
@MainActor
enum SoundEffects {
    enum Sound: String {
        /// A soft two-note chime: the conversation starts, time to focus.
        case focus
    }

    private static var player: AVAudioPlayer?
    private static let logger = Logger(subsystem: "i8r4him.Alltag", category: "Sound")

    static func play(_ sound: Sound) {
        guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: "wav") else {
            logger.error("Missing sound \(sound.rawValue, privacy: .public)")
            return
        }
        do {
            // Ambient: mixes with other audio and stays quiet when the phone is on silent.
            try AVAudioSession.sharedInstance().setCategory(.ambient)
            let player = try AVAudioPlayer(contentsOf: url)
            player.volume = 0.6
            player.play()
            self.player = player
        } catch {
            logger.error("Couldn't play \(sound.rawValue, privacy: .public): \(error.localizedDescription, privacy: .public)")
        }
    }
}
