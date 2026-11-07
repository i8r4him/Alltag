//
//  UserProfile.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import SwiftData

/// The learner's profile, created at the end of onboarding.
///
/// Enums are stored as raw values (CloudKit-friendly, usable in predicates)
/// and exposed through typed properties.
@Model
final class UserProfile {
    var name: String = ""
    var nativeLanguageRaw: String = NativeLanguage.english.rawValue
    var goalRaw: String = Goal.livingHere.rawValue
    var levelRaw: String = Level.a1.rawValue
    var dailyMinutes: Int = DailyTime.ten.rawValue
    var nudgeTimeRaw: String = NudgeTime.evening.rawValue
    var interestsRaw: [String] = []
    var learningSince: Date = Date.now
    var hasCompletedOnboarding: Bool = false

    // Settings · Learn from my day and Reminders. Set from the onboarding
    // permissions step and changed in Settings.
    var learnsFromCalendar: Bool = false
    var learnsFromKeyboard: Bool = false
    var remindersEnabled: Bool = false
    var morningBriefingEnabled: Bool = false

    init(
        name: String,
        nativeLanguage: NativeLanguage = .english,
        goal: Goal = .livingHere,
        level: Level = .a1,
        dailyTime: DailyTime = .ten,
        nudgeTime: NudgeTime = .evening,
        interests: Set<Interest> = [],
        learningSince: Date = .now,
        hasCompletedOnboarding: Bool = false
    ) {
        self.name = name
        self.nativeLanguageRaw = nativeLanguage.rawValue
        self.goalRaw = goal.rawValue
        self.levelRaw = level.rawValue
        self.dailyMinutes = dailyTime.rawValue
        self.nudgeTimeRaw = nudgeTime.rawValue
        self.interestsRaw = Self.sortedRaw(interests)
        self.learningSince = learningSince
        self.hasCompletedOnboarding = hasCompletedOnboarding
    }

    var nativeLanguage: NativeLanguage {
        get { NativeLanguage(rawValue: nativeLanguageRaw) ?? .other }
        set { nativeLanguageRaw = newValue.rawValue }
    }

    var goal: Goal {
        get { Goal(rawValue: goalRaw) ?? .livingHere }
        set { goalRaw = newValue.rawValue }
    }

    var level: Level {
        get { Level(rawValue: levelRaw) ?? .a1 }
        set { levelRaw = newValue.rawValue }
    }

    var dailyTime: DailyTime {
        get { DailyTime(rawValue: dailyMinutes) ?? .ten }
        set { dailyMinutes = newValue.rawValue }
    }

    var nudgeTime: NudgeTime {
        get { NudgeTime(rawValue: nudgeTimeRaw) ?? .evening }
        set { nudgeTimeRaw = newValue.rawValue }
    }

    var interests: Set<Interest> {
        get { Set(interestsRaw.compactMap(Interest.init(rawValue:))) }
        set { interestsRaw = Self.sortedRaw(newValue) }
    }

    /// Stored in `Interest.allCases` order so the array is stable.
    private static func sortedRaw(_ interests: Set<Interest>) -> [String] {
        Interest.allCases.filter(interests.contains).map(\.rawValue)
    }
}
