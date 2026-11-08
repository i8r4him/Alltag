//
//  HomeTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import Testing
@testable import Alltag

@Suite("Today")
@MainActor
struct HomeTests {
    let now = Calendar.current.date(from: DateComponents(year: 2026, month: 11, day: 7, hour: 19)) ?? .now

    @Test("The prototype's sample data gives 2 rules worth a look")
    func rulesWorthALook() {
        #expect(GrammarCard.rulesWithMistakes() == 2)
    }

    @Test("New words count only today's words from reading")
    func newReadingWords() throws {
        let now = try #require(Calendar.current.date(from: DateComponents(year: 2026, month: 11, day: 7, hour: 19)))
        let yesterday = now.addingTimeInterval(-86_400)
        let items = [
            MemoryItem(word: "a", meaning: "a", kind: .fromYourDay, source: .safari, createdAt: now),
            MemoryItem(word: "b", meaning: "b", kind: .fromYourDay, source: .safari, createdAt: now),
            MemoryItem(word: "c", meaning: "c", kind: .fromYourDay, source: .safari, createdAt: yesterday),
            MemoryItem(word: "d", meaning: "d", kind: .fromYourDay, source: .camera, createdAt: now),
            MemoryItem(word: "e", meaning: "e", kind: .saved, source: .safari, createdAt: now)
        ]
        #expect(FromYourDay.newReadingWords(in: items, on: now) == 2)
    }

    @Test("The sample data gives 3 new words from Safari")
    func sampleNewWords() {
        let now = Date.now
        #expect(FromYourDay.newReadingWords(in: MockMemoryItems.make(now: now), on: now) == 3)
    }

    @Test("Only mistakes made while writing count as writing mistakes")
    func writingMistakes() {
        // The sample data has two mistakes: one from Messages, one from a conversation.
        #expect(FromYourDay.writingMistakes(in: MockMemoryItems.make(now: now)) == 1)
    }
}
