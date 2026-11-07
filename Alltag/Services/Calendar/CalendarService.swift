//
//  CalendarService.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// An upcoming event the learner can rehearse.
struct CalendarEvent: Identifiable, Hashable, Sendable {
    let id: String
    let title: String
    let start: Date
    let systemImage: String
    /// The conversation to rehearse for this event, if there is one.
    var scenario: Scenario.ID?
}

/// Reads upcoming events from the learner's calendar.
protocol CalendarService: AnyObject {
    var authorizationStatus: PermissionStatus { get }
    func requestAccess() async -> PermissionStatus
    /// Upcoming events, soonest first.
    func upcomingEvents() async throws -> [CalendarEvent]
}

/// The prototype's "Coming up" events: dentist tomorrow, train on Friday,
/// returning a package on Saturday. The live service uses EventKit (#51).
@Observable
final class MockCalendarService: CalendarService {
    private(set) var authorizationStatus: PermissionStatus
    private let now: () -> Date

    init(authorizationStatus: PermissionStatus = .notDetermined, now: @escaping () -> Date = { .now }) {
        self.authorizationStatus = authorizationStatus
        self.now = now
    }

    func requestAccess() async -> PermissionStatus {
        authorizationStatus = .granted
        return authorizationStatus
    }

    func upcomingEvents() async throws -> [CalendarEvent] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: now())
        let dentist = calendar.date(byAdding: DateComponents(day: 1, hour: 10), to: today) ?? today
        // Each event is on the next matching weekday after the one before, so
        // the order is always dentist → train → package, as in the prototype.
        func next(weekday: Int, hour: Int, minute: Int, after date: Date) -> Date {
            let match = DateComponents(hour: hour, minute: minute, weekday: weekday)
            return calendar.nextDate(after: date, matching: match, matchingPolicy: .nextTime) ?? date
        }
        let train = next(weekday: 6, hour: 9, minute: 12, after: dentist)
        let package = next(weekday: 7, hour: 11, minute: 0, after: train)

        return [
            CalendarEvent(id: "dentist", title: "Dentist", start: dentist,
                          systemImage: "cross.case", scenario: .dentist),
            CalendarEvent(id: "train", title: "Train to Munich", start: train,
                          systemImage: "tram", scenario: .station),
            CalendarEvent(id: "package", title: "Return package", start: package,
                          systemImage: "shippingbox", scenario: .postOffice)
        ].sorted { $0.start < $1.start }
    }
}
