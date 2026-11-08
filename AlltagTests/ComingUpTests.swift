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

    @Test("Tomorrow's event is marked and shows its time and rehearsal length")
    func tomorrow() async throws {
        let events = try await MockCalendarService(now: { now }).upcomingEvents()
        let dentist = try #require(events.first)

        #expect(ComingUp.isTomorrow(dentist, now: now))
        let detail = String(localized: ComingUp.detail(for: dentist, now: now))
        #expect(detail.hasSuffix("· 5 min"))
        #expect(detail.hasPrefix(dentist.start.formatted(.dateTime.hour().minute())))
    }

    @Test("Later events show weekday, time and length, and aren't marked tomorrow")
    func later() async throws {
        let events = try await MockCalendarService(now: { now }).upcomingEvents()
        let train = try #require(events.first { $0.id == "train" })

        #expect(!ComingUp.isTomorrow(train, now: now))
        let detail = String(localized: ComingUp.detail(for: train, now: now))
        #expect(detail == "\(train.start.formatted(.dateTime.weekday(.abbreviated).hour().minute())) · 4 min")
    }

    @Test("Tiles say when the event starts, in hours within a day, otherwise in days",
          arguments: [(0.5, "Starts soon"), (14.5, "Starts in 14h"), (23.9, "Starts in 23h"), (24.0, "Starts in 1d"),
                      (150.0, "Starts in 6d")])
    func startsIn(hours: Double, expected: String) {
        let event = CalendarEvent(id: "e", title: "Dentist", start: now.addingTimeInterval(hours * 3_600),
                                  systemImage: "cross.case", scenario: .dentist)
        #expect(String(localized: ComingUp.startsIn(event, now: now)) == expected)
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
