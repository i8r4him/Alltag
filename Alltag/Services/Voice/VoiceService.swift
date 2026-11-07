//
//  VoiceService.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// How fast German is spoken.
enum SpeechRate: Equatable, Sendable {
    case normal
    /// For "Slowly" buttons and the Slower speech setting.
    case slow
}

/// Speaks German text aloud.
protocol VoiceService: AnyObject {
    var isSpeaking: Bool { get }
    /// Speaks `text` and returns when it has finished (or was stopped).
    func speak(_ text: String, rate: SpeechRate) async
    func stop()
}

/// Records what would be spoken, without making a sound. For previews and tests.
@Observable
final class MockVoiceService: VoiceService {
    private(set) var spoken: [(text: String, rate: SpeechRate)] = []
    private(set) var isSpeaking = false
    private let duration: Duration

    init(duration: Duration = .zero) {
        self.duration = duration
    }

    func speak(_ text: String, rate: SpeechRate) async {
        spoken.append((text, rate))
        isSpeaking = true
        try? await Task.sleep(for: duration)
        isSpeaking = false
    }

    func stop() {
        isSpeaking = false
    }
}
