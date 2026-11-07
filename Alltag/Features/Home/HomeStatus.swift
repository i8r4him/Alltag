//
//  HomeStatus.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import SwiftUI

/// The numbers behind Home's entry cards, computed from the learner's data.
struct HomeStatus: Equatable {
    var savedThisWeek: Int
    var dueForReview: Int
    var level: Level
    var mistakeRules: Int

    init(savedThisWeek: Int, dueForReview: Int, level: Level, mistakeRules: Int) {
        self.savedThisWeek = savedThisWeek
        self.dueForReview = dueForReview
        self.level = level
        self.mistakeRules = mistakeRules
    }

    init(translations: [SavedTranslation], memoryItems: [MemoryItem], level: Level,
         now: Date = .now, calendar: Calendar = .current) {
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: now) ?? now
        savedThisWeek = translations.filter { $0.savedAt > weekAgo }.count
        dueForReview = memoryItems.filter { $0.isDue(at: now) }.count
        self.level = level
        mistakeRules = Self.rulesWithMistakes()
    }

    /// Grammar topics where the learner made a mistake, across all levels.
    static func rulesWithMistakes() -> Int {
        Level.selectable.flatMap { MockLevels.topics(for: $0) }.filter { $0.status == .mistake }.count
    }

    // MARK: Status lines

    var translate: Text {
        savedThisWeek > 0
            ? Text("^[\(savedThisWeek) phrase](inflect: true) saved this week")
            : Text("English ⇄ German")
    }

    /// The Learn screen offers four moments (#34).
    var learn: Text { Text("4 short moments") }

    var memory: Text {
        dueForReview > 0 ? Text("\(dueForReview) ready to review") : Text("All caught up")
    }

    var progress: Text { Text("\(level.title) · steadily rising") }
}
