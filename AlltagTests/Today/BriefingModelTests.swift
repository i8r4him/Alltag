//
//  BriefingModelTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import Testing
@testable import Alltag

@Suite("Briefing")
@MainActor
struct BriefingModelTests {
    @Test("Every learning word in the transcript is highlighted, and nothing else")
    func highlighting() {
        let briefing = MockBriefing.briefing
        let text = BriefingModel.highlighted(briefing.transcript, words: briefing.words)
        let highlighted = text.runs
            .filter { $0.inlinePresentationIntent == .stronglyEmphasized }
            .map { String(text[$0.range].characters) }
        #expect(Set(highlighted) == Set(briefing.words))
        #expect(highlighted.count == briefing.words.count)
    }

    @Test("A word that appears twice is highlighted twice")
    func repeatedWord() {
        let text = BriefingModel.highlighted("unterwegs und wieder unterwegs", words: ["unterwegs"])
        let count = text.runs.filter { $0.inlinePresentationIntent == .stronglyEmphasized }.count
        #expect(count == 2)
    }

    @Test("Chips show the Memory entry for each word, or the word itself")
    func memoryLabels() {
        let items = MockMemoryItems.make()
        let labels = BriefingModel.memoryLabels(for: ["Bescheid", "Feierabend", "Fernweh"], in: items)
        #expect(labels == ["Bescheid sagen", "Feierabend", "Fernweh"])
    }

    @Test("Play speaks the transcript; playing again stops")
    func play() async {
        let voice = MockVoiceService()
        let services = AppServices(speech: MockSpeechService(), voice: voice,
                                   translation: MockTranslationService(delay: .zero),
                                   companion: MockCompanionService(thinkingTime: .zero),
                                   calendar: MockCalendarService(), notifications: MockNotificationService())
        let model = BriefingModel(services: services)
        await model.togglePlay()
        #expect(voice.spoken.map(\.text) == [MockBriefing.briefing.transcript])
        #expect(!model.isPlaying)
    }
}
