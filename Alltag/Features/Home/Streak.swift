//
//  Streak.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 09.11.26.
//

import Foundation

/// One day in the streak's week.
struct StreakDay: Identifiable, Equatable {
    let date: Date
    let practised: Bool
    var id: Date { date }
}

/// Days in a row with practice: the days with at least one `PracticeSession`.
enum Streak {
    /// Consecutive days with activity, counting back from today, or from
    /// yesterday when there's nothing yet today (the streak isn't lost until
    /// a whole day is missed).
    static func days(activity: [Date], today: Date = .now, calendar: Calendar = .current) -> Int {
        let days = Set(activity.map { calendar.startOfDay(for: $0) })
        var day = calendar.startOfDay(for: today)
        if !days.contains(day) {
            guard let yesterday = calendar.date(byAdding: .day, value: -1, to: day) else { return 0 }
            day = yesterday
        }
        var count = 0
        while days.contains(day) {
            count += 1
            guard let previous = calendar.date(byAdding: .day, value: -1, to: day) else { break }
            day = previous
        }
        return count
    }

    /// The last seven days, oldest first and ending today, with whether the
    /// learner practised on each.
    static func week(activity: [Date], today: Date = .now, calendar: Calendar = .current) -> [StreakDay] {
        let days = Set(activity.map { calendar.startOfDay(for: $0) })
        let start = calendar.startOfDay(for: today)
        return (0..<7).reversed().compactMap { offset in
            calendar.date(byAdding: .day, value: -offset, to: start)
                .map { StreakDay(date: $0, practised: days.contains($0)) }
        }
    }
}
