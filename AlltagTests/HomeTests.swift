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

    @Test("Only mistakes made while writing count as writing mistakes")
    func writingMistakes() {
        // The sample data has two mistakes: one from Messages, one from a conversation.
        #expect(FromYourDay.writingMistakes(in: MockMemoryItems.make(now: now)) == 1)
    }
}
