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

    /// The rate actually used: everything is slow when the learner prefers slower speech.
    func adjusted(prefersSlower: Bool) -> SpeechRate {
        prefersSlower ? .slow : self
    }
}

/// Speaks German text aloud.
protocol VoiceService: AnyObject {
    var isSpeaking: Bool { get }
    /// Settings · Slower speech by default.
    var prefersSlowerSpeech: Bool { get set }
    /// Speaks `text` and returns when it has finished (or was stopped).
    func speak(_ text: String, rate: SpeechRate) async
    func stop()
}

/// Records what would be spoken, without making a sound. For previews and tests.
@Observable
final class MockVoiceService: VoiceService {
    private(set) var spoken: [(text: String, rate: SpeechRate)] = []
    private(set) var isSpeaking = false
    var prefersSlowerSpeech = false
    private let duration: Duration

    init(duration: Duration = .zero) {
        self.duration = duration
    }

    func speak(_ text: String, rate: SpeechRate) async {
        spoken.append((text, rate.adjusted(prefersSlower: prefersSlowerSpeech)))
        isSpeaking = true
        try? await Task.sleep(for: duration)
        isSpeaking = false
    }

    func stop() {
        isSpeaking = false
    }
}
