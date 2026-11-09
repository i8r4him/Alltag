//
//  ComingUpTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import Testing
@testable import Alltag

@Suite("Coming up")
@MainActor
struct ComingUpTests {
    /// Saturday 7 Nov 2026, 19:00.
    let now = Calendar.current.date(from: DateComponents(year: 2026, month: 11, day: 7, hour: 19)) ?? .now

    @Test("Tomorrow's event says Tomorrow; later ones their weekday")
    func day() async throws {
        let events = try await MockCalendarService(now: { now }).upcomingEvents()
        let dentist = try #require(events.first)
        let train = try #require(events.first { $0.id == "train" })

        #expect(ComingUp.isTomorrow(dentist, now: now))
        #expect(ComingUp.day(of: dentist, now: now) == "Tomorrow")
        #expect(!ComingUp.isTomorrow(train, now: now))
        #expect(ComingUp.day(of: train, now: now) == train.start.formatted(.dateTime.weekday(.wide)))
    }

    @Test("The list groups events by day, earliest first")
    func days() {
        let morning = CalendarEvent(id: "a", title: "A", start: now.addingTimeInterval(15 * 3_600), systemImage: "a")
        let evening = CalendarEvent(id: "b", title: "B", start: now.addingTimeInterval(24 * 3_600), systemImage: "b")
        let later = CalendarEvent(id: "c", title: "C", start: now.addingTimeInterval(72 * 3_600), systemImage: "c")
        let groups = ComingUp.days([later, evening, morning])
        #expect(groups.map { $0.events.map(\.id) } == [["a", "b"], ["c"]])
    }

    @Test("Every tile opens a conversation")
    func everyEventHasAScenario() async throws {
        let events = try await MockCalendarService(now: { now }).upcomingEvents()
        #expect(events.allSatisfy { $0.scenario != nil })
        #expect(events.map(\.rehearsalMinutes) == [5, 4, 4])
    }
}
