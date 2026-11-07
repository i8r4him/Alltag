//
//  BriefingModel.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import Observation

/// The spoken briefing: playing it, and which learning words it contains.
@Observable
final class BriefingModel {
    let briefing: Briefing
    private(set) var isPlaying = false

    private let voice: any VoiceService

    init(briefing: Briefing = MockBriefing.briefing, services: AppServices) {
        self.briefing = briefing
        voice = services.voice
    }

    /// Plays the transcript, or stops it.
    func togglePlay() async {
        if isPlaying {
            voice.stop()
            isPlaying = false
            return
        }
        isPlaying = true
        await voice.speak(briefing.transcript, rate: .normal)
        isPlaying = false
    }

    func stop() {
        guard isPlaying else { return }
        voice.stop()
        isPlaying = false
    }

    /// The transcript with each learning word marked, so the view can highlight it.
    static func highlighted(_ transcript: String, words: [String]) -> AttributedString {
        var text = AttributedString(transcript)
        for word in words {
            var searchStart = text.startIndex
            while let range = text[searchStart...].range(of: word) {
                text[range].inlinePresentationIntent = .stronglyEmphasized
                searchStart = range.upperBound
            }
        }
        return text
    }

    /// The Memory entry for each briefing word, e.g. "Bescheid sagen" for "Bescheid".
    /// Falls back to the word itself when it isn't in Memory.
    static func memoryLabels(for words: [String], in items: [MemoryItem]) -> [String] {
        words.map { word in
            items.first { $0.word == word }?.word
                ?? items.first { $0.word.localizedStandardContains(word) }?.word
                ?? word
        }
    }
}
