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
        #expect(detail.hasSuffix("· rehearse 5 min"))
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

    @Test("Every tile opens a conversation")
    func everyEventHasAScenario() async throws {
        let events = try await MockCalendarService(now: { now }).upcomingEvents()
        #expect(events.allSatisfy { $0.scenario != nil })
        #expect(events.map(\.rehearsalMinutes) == [5, 4, 4])
    }
}
