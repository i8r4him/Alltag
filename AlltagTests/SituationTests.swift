//
//  SituationTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 12.11.26.
//

import Foundation
import SwiftData
import Testing
@testable import Alltag

@MainActor
struct SituationTests {
    @Test("Every situation has its own id and something in every category")
    func catalogue() {
        let all = SituationCatalogue.all
        #expect(Set(all.map(\.id)).count == all.count)
        for category in Situation.Category.allCases where category != .other {
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

    @Test("The Focus situation changes every day, reaches every situation, and isn't among the suggestions")
    func focus() throws {
        let calendar = Calendar(identifier: .gregorian)
        let start = try #require(calendar.date(from: DateComponents(year: 2026, month: 11, day: 13)))
        let days = try (0..<SituationCatalogue.all.count).map { try #require(calendar.date(byAdding: .day, value: $0, to: start)) }
        let focuses = days.map { SituationCatalogue.focus(on: $0, calendar: calendar) }

        #expect(Set(focuses.map(\.id)).count == SituationCatalogue.all.count)
        for day in days {
            let suggestions = SituationCatalogue.suggestions(on: day, calendar: calendar)
            #expect(suggestions.count == 4)
            #expect(!suggestions.contains(SituationCatalogue.focus(on: day, calendar: calendar)))
        }
    }

    @Test("Today's Focus is the situation of the day, and done once its session is saved today")
    func todayFocus() throws {
        let calendar = Calendar(identifier: .gregorian)
        let today = try #require(calendar.date(from: DateComponents(year: 2026, month: 11, day: 13, hour: 9)))
        let yesterday = try #require(calendar.date(byAdding: .day, value: -1, to: today))

        let focus = TodayFocus.make(on: today, calendar: calendar)
        let expected = SituationCatalogue.focus(on: today, calendar: calendar)
        #expect(focus.route == .situation(expected.id))
        #expect(focus.title == String(localized: expected.title))
        #expect(focus != TodayFocus.make(on: yesterday, calendar: calendar))

        let done = SessionRecord(kind: .conversation, title: focus.title, date: today)
        let old = SessionRecord(kind: .conversation, title: focus.title, date: yesterday)
        let other = SessionRecord(kind: .conversation, title: "Just talk", date: today)
        #expect(focus.isDone(in: [done], on: today, calendar: calendar))
        #expect(!focus.isDone(in: [old, other], on: today, calendar: calendar))
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

    @Test("A situation the learner added is found by its id and tells the voice what they want")
    func custom() throws {
        let container = try AlltagStore.makeContainer(inMemory: true)
        let own = CustomSituation(title: "  At the vet ", detail: "Explain that my cat isn't eating 100%", category: .health)
        container.mainContext.insert(own)

        #expect(own.title == "At the vet")
        let situation = try #require(SituationCatalogue.situation(id: own.situationID, in: container.mainContext))
        #expect(situation.isCustom)
        #expect(situation.category == .health)
        #expect(String(localized: situation.title) == "At the vet")
        #expect(String(localized: situation.detail) == "Explain that my cat isn't eating 100%")
        #expect(SituationCatalogue.situation(id: "doctor", in: container.mainContext)?.isCustom == false)

        let context = RealtimeConversationContext(scenario: situation.scenario, level: .b1, slowerSpeech: false)
        #expect(context.instructions.contains("At the vet"))
        #expect(context.instructions.contains("my cat isn't eating"))
    }
}
