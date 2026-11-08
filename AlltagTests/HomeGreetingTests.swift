//
//  HomeGreetingTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import Testing
@testable import Alltag

@Suite("Home greeting")
@MainActor
struct HomeGreetingTests {
    @Test("The part of day follows the hour",
          arguments: [(0, HomeGreeting.PartOfDay.evening), (4, .evening), (5, .morning), (11, .morning),
                      (12, .afternoon), (17, .afternoon), (18, .evening), (23, .evening)])
    func partOfDay(hour: Int, expected: HomeGreeting.PartOfDay) {
        #expect(HomeGreeting.PartOfDay(hour: hour) == expected)
    }

    @Test("The greeting includes the name, or leaves it out when there is none")
    func title() {
        #expect(String(localized: HomeGreeting.title(for: .evening, name: " Mara ")) == "Good evening, Mara")
        #expect(String(localized: HomeGreeting.title(for: .morning, name: "Mara")) == "Good morning, Mara")
        #expect(String(localized: HomeGreeting.title(for: .afternoon, name: "")) == "Good afternoon")
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
        #expect(HomeGreeting.newReadingWords(in: items, on: now) == 2)
    }

    @Test("The sample data gives the prototype's 3 new words")
    func sampleData() {
        let now = Date.now
        #expect(HomeGreeting.newReadingWords(in: MockMemoryItems.make(now: now), on: now) == 3)
    }
}
