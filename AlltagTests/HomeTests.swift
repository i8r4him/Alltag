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

    @Test("Big numbers are written in full below 1,000, then short where the language has it")
    func bigNumbers() {
        let english = Locale(identifier: "en_GB"), german = Locale(identifier: "de_DE")
        #expect(BigNumber.style(for: 999, locale: english).format(999) == "999")
        #expect(BigNumber.style(for: 1_250, locale: english).format(1_250) == "1.2k")
        #expect(BigNumber.style(for: 12_480, locale: english).format(12_480) == "12k")
        #expect(BigNumber.style(for: 1_250, locale: german).format(1_250) == "1250")
    }
}
