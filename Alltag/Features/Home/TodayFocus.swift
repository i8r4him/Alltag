//
//  TodayFocus.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 13.11.26.
//

import Foundation

/// The one thing to do today, as the Focus card shows it: one everyday
/// situation to role-play with the live voice. It changes every day.
struct TodayFocus: Equatable {
    let title: String
    let line: String
    let systemImage: String
    let route: FullScreenRoute
    /// A saved session with this title today means the Focus is done.
    let sessionTitle: String

    /// Whether one of today's saved sessions is this Focus.
    func isDone(in sessions: [SessionRecord], on date: Date = .now, calendar: Calendar = .current) -> Bool {
        sessions.contains { $0.title == sessionTitle && calendar.isDate($0.date, inSameDayAs: date) }
    }

    /// Today's Focus: the situation of the day.
    static func make(on date: Date = .now, calendar: Calendar = .current) -> TodayFocus {
        let situation = SituationCatalogue.focus(on: date, calendar: calendar)
        let title = String(localized: situation.title)
        return TodayFocus(title: title, line: String(localized: situation.detail), systemImage: situation.systemImage,
                          route: .situation(situation.id), sessionTitle: title)
    }
}
