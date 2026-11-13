//
//  TodayFocus.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 13.11.26.
//

import Foundation

/// The one thing to do today, as the Focus card shows it. It changes every day.
struct TodayFocus: Equatable {
    /// What the Focus can be. The maintainer is choosing one (see `FocusCard`'s switcher).
    enum Kind: Int, CaseIterable {
        /// One everyday situation to role-play with the live voice.
        case situation
        /// One topic to talk about for 60 seconds.
        case topic
        /// The learner's latest mistake, to fix.
        case mistake
    }

    let title: String
    let line: String
    /// German text is shown as it is; the rest is UI text already resolved.
    var isGerman = false
    let systemImage: String
    let buttonTitle: LocalizedStringResource
    let buttonImage: String
    let route: FullScreenRoute
    /// A saved session with this title today means the Focus is done.
    let sessionTitle: String?

    static func == (lhs: TodayFocus, rhs: TodayFocus) -> Bool {
        lhs.title == rhs.title && lhs.route == rhs.route
    }

    /// Whether one of today's saved sessions is this Focus.
    func isDone(in sessions: [SessionRecord], on date: Date = .now, calendar: Calendar = .current) -> Bool {
        guard let sessionTitle else { return false }
        return sessions.contains { $0.title == sessionTitle && calendar.isDate($0.date, inSameDayAs: date) }
    }

    /// Today's Focus of `kind`. A mistake needs one to have been saved; without, it is the situation.
    static func make(_ kind: Kind, level: Level, latestMistake: MemoryItem? = nil,
                     on date: Date = .now, calendar: Calendar = .current) -> TodayFocus {
        switch kind {
        case .situation:
            return situation(on: date, calendar: calendar)
        case .topic:
            let topic = TalkTopics.daily(for: level, on: date, calendar: calendar)
            return TodayFocus(title: topic.title, line: topic.question, isGerman: true, systemImage: "timer",
                              buttonTitle: "Talk for 60 seconds", buttonImage: "waveform",
                              route: .sixtySeconds(topic: topic.id),
                              sessionTitle: String(localized: "60 seconds · \(topic.title)"))
        case .mistake:
            guard let mistake = latestMistake, !mistake.mistakeOriginal.isEmpty else {
                return situation(on: date, calendar: calendar)
            }
            return TodayFocus(title: String(localized: "Fix one mistake"), line: "„\(mistake.mistakeOriginal)“",
                              systemImage: "pencil.and.outline", buttonTitle: "Fix it", buttonImage: "checkmark",
                              route: .activity(.mistakes), sessionTitle: nil)
        }
    }

    private static func situation(on date: Date, calendar: Calendar) -> TodayFocus {
        let situation = SituationCatalogue.focus(on: date, calendar: calendar)
        let title = String(localized: situation.title)
        return TodayFocus(title: title, line: String(localized: situation.detail), systemImage: situation.systemImage,
                          buttonTitle: "Start talking", buttonImage: "waveform",
                          route: .situation(situation.id), sessionTitle: title)
    }
}
