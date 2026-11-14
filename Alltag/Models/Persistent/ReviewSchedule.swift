//
//  ReviewSchedule.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 14.11.26.
//

import Foundation

/// When something in Memory comes back: a right answer makes it stronger and
/// sends it further away, a wrong one makes it weaker and brings it back at
/// once. Pure, with the date passed in, so Fix your mistakes and Memory's
/// review can share it.
enum ReviewSchedule {
    /// Days until the next review after a right answer, by the strength reached (1…`MemoryItem.maxStrength`).
    static let intervals = [1, 3, 7, 14]

    /// Where an answer leaves an item.
    struct Step: Equatable {
        let strength: Int
        let nextReview: Date

        /// Known well enough to leave the stack. It stays in Memory.
        var isLearned: Bool { strength >= MemoryItem.maxStrength }
    }

    static func step(from strength: Int, wasRight: Bool, at date: Date, calendar: Calendar = .current) -> Step {
        // Wrong: one step back, and due again straight away (the next round).
        guard wasRight else { return Step(strength: min(max(strength - 1, 0), MemoryItem.maxStrength), nextReview: date) }
        let reached = min(max(strength, 0) + 1, MemoryItem.maxStrength)
        let days = intervals[min(reached, intervals.count) - 1]
        // From the start of that day, so "tomorrow" means any time tomorrow.
        let day = calendar.startOfDay(for: date)
        let next = calendar.date(byAdding: .day, value: days, to: day) ?? date.addingTimeInterval(Double(days) * 86_400)
        return Step(strength: reached, nextReview: next)
    }

    /// Whole days from `date` until `next`: 0 today, 1 tomorrow.
    static func days(until next: Date, from date: Date, calendar: Calendar = .current) -> Int {
        max(calendar.dateComponents([.day], from: calendar.startOfDay(for: date), to: calendar.startOfDay(for: next)).day ?? 0, 0)
    }
}

extension MemoryItem {
    /// Known well enough to leave the stack of things to fix.
    var isLearned: Bool { strength >= Self.maxStrength }

    /// Takes an answer: moves the strength and the next review.
    @discardableResult
    func review(wasRight: Bool, at date: Date = .now, calendar: Calendar = .current) -> ReviewSchedule.Step {
        let step = ReviewSchedule.step(from: strength, wasRight: wasRight, at: date, calendar: calendar)
        strength = step.strength
        nextReview = step.nextReview
        return step
    }
}
