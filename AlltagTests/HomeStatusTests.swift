//
//  HomeStatusTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import Testing
@testable import Alltag

@Suite("Home status")
@MainActor
struct HomeStatusTests {
    let now = Calendar.current.date(from: DateComponents(year: 2026, month: 11, day: 7, hour: 19)) ?? .now

    @Test("Translations saved in the last seven days are counted")
    func savedThisWeek() {
        let translations = [
            SavedTranslation(english: "a", german: "a", savedAt: now.addingTimeInterval(-3_600)),
            SavedTranslation(english: "b", german: "b", savedAt: now.addingTimeInterval(-6 * 86_400)),
            SavedTranslation(english: "c", german: "c", savedAt: now.addingTimeInterval(-8 * 86_400))
        ]
        let status = HomeStatus(translations: translations, memoryItems: [], level: .b1, now: now)
        #expect(status.savedThisWeek == 2)
    }

    @Test("The prototype's sample data gives 6 words to review and 2 rules worth a look")
    func sampleData() {
        let status = HomeStatus(translations: [], memoryItems: MockMemoryItems.make(now: now), level: .b1, now: now)
        #expect(status.dueForReview == 6)
        #expect(status.mistakeRules == 2)
        #expect(status.level == .b1)
    }

    @Test("Only mistakes made while writing count as writing mistakes")
    func writingMistakes() {
        // The sample data has two mistakes: one from Messages, one from a conversation.
        #expect(FromYourDay.writingMistakes(in: MockMemoryItems.make(now: now)) == 1)
    }
}
