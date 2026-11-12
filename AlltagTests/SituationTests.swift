//
//  SituationTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 12.11.26.
//

import Foundation
import Testing
@testable import Alltag

@MainActor
struct SituationTests {
    @Test("Every situation has its own id and something in every category")
    func catalogue() {
        let all = SituationCatalogue.all
        #expect(Set(all.map(\.id)).count == all.count)
        for category in Situation.Category.allCases {
            #expect(!SituationCatalogue.situations(in: category).isEmpty)
        }
        #expect(all.allSatisfy { !$0.role.isEmpty && !$0.aim.isEmpty })
        #expect(SituationCatalogue.situation(id: "doctor")?.category == .health)
        #expect(SituationCatalogue.situation(id: "nowhere") == nil)
    }

    @Test("Today suggests four different situations, and other ones the next day")
    func suggestions() throws {
        let calendar = Calendar(identifier: .gregorian)
        let today = try #require(calendar.date(from: DateComponents(year: 2026, month: 11, day: 12)))
        let tomorrow = try #require(calendar.date(byAdding: .day, value: 1, to: today))

        let first = SituationCatalogue.suggestions(on: today, calendar: calendar)
        #expect(first.count == 4)
        #expect(Set(first.map(\.id)).count == 4)
        #expect(first == SituationCatalogue.suggestions(on: today, calendar: calendar))
        #expect(first != SituationCatalogue.suggestions(on: tomorrow, calendar: calendar))
    }

    @Test("A situation becomes a live-only conversation that tells the voice its role")
    func conversation() throws {
        let situation = try #require(SituationCatalogue.situation(id: "landlord"))
        let scenario = situation.scenario

        #expect(scenario.id == .situation)
        #expect(scenario.isLiveOnly)
        #expect(!scenario.isFreeTalk)
        #expect(scenario.savedPhrases.isEmpty)

        let context = RealtimeConversationContext(scenario: scenario, level: .a2, slowerSpeech: false)
        #expect(context.isLiveOnly)
        #expect(context.instructions.contains(situation.role))
        #expect(context.instructions.contains(situation.aim))
        #expect(context.instructions.contains("A2"))
    }
}
