//
//  Streak.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 09.11.26.
//

import Foundation

/// Days in a row with learning activity.
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
}
