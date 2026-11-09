//
//  StreakTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 09.11.26.
//

import Foundation
import Testing
@testable import Alltag

@Suite("Streak")
struct StreakTests {
    let calendar = Calendar(identifier: .gregorian)
    var today: Date { calendar.date(from: DateComponents(year: 2026, month: 11, day: 9, hour: 18)) ?? .now }

    private func daysAgo(_ days: Int, hour: Int = 9) -> Date {
        let day = calendar.date(byAdding: .day, value: -days, to: today) ?? today
        return calendar.date(bySettingHour: hour, minute: 0, second: 0, of: day) ?? day
    }

    @Test("Counts consecutive days back from today, once per day")
    func consecutive() {
        let activity = [daysAgo(0), daysAgo(0, hour: 20), daysAgo(1), daysAgo(2), daysAgo(4)]
        #expect(Streak.days(activity: activity, today: today, calendar: calendar) == 3)
    }

    @Test("Nothing yet today keeps yesterday's streak")
    func fromYesterday() {
        let activity = [daysAgo(1), daysAgo(2)]
        #expect(Streak.days(activity: activity, today: today, calendar: calendar) == 2)
    }

    @Test("A missed day ends the streak", arguments: [[Int](), [2, 3], [5]])
    func broken(days: [Int]) {
        #expect(Streak.days(activity: days.map { daysAgo($0) }, today: today, calendar: calendar) == 0)
    }
}
