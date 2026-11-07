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
/// Onboarding answers are stored as raw strings for now; typed accessors
/// arrive with the enums in #14 (`Goal`, `Level`, `NativeLanguage`, …).
@Model
final class UserProfile {
    var name: String = ""
    var nativeLanguage: String = ""
    var goal: String = ""
    var level: String = ""
    var dailyMinutes: Int = 10
    var nudgeTime: String = ""
    var interests: [String] = []
    var learningSince: Date = Date.now
    var hasCompletedOnboarding: Bool = false

    init(
        name: String,
        nativeLanguage: String = "",
        goal: String = "",
        level: String = "",
        dailyMinutes: Int = 10,
        nudgeTime: String = "",
        interests: [String] = [],
        learningSince: Date = .now,
        hasCompletedOnboarding: Bool = false
    ) {
        self.name = name
        self.nativeLanguage = nativeLanguage
        self.goal = goal
        self.level = level
        self.dailyMinutes = dailyMinutes
        self.nudgeTime = nudgeTime
        self.interests = interests
        self.learningSince = learningSince
        self.hasCompletedOnboarding = hasCompletedOnboarding
    }
}
