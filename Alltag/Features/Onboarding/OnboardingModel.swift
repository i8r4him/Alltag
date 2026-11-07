//
//  OnboardingModel.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import Observation
import SwiftData

/// State of the onboarding flow: the current step and every answer.
@Observable
final class OnboardingModel {
    enum Step: Int, CaseIterable, Comparable {
        case welcome
        case name
        case why
        case level
        case dailyTime
        case interests
        case permissions
        case summary

        static func < (lhs: Step, rhs: Step) -> Bool { lhs.rawValue < rhs.rawValue }
    }

    /// Steps between Welcome and Summary, one progress segment each.
    static let segmentCount = Step.allCases.count - 2

    private(set) var step: Step = .welcome
    /// Direction of the last step change, for the transition.
    private(set) var isMovingForward = true

    // Answers
    var name = ""
    var nativeLanguage: NativeLanguage = .english
    var goal: Goal = .livingHere
    var level: Level = .b1
    var dailyTime: DailyTime = .ten
    var nudgeTime: NudgeTime = .evening
    var interests: Set<Interest> = Interest.defaultSelection
    var allowsCalendar = false
    var allowsNotifications = false
    var usesKeyboard = false

    init() {}

    /// Starts from an existing profile, e.g. when replaying onboarding from Settings.
    init(profile: UserProfile) {
        name = profile.name
        nativeLanguage = profile.nativeLanguage
        goal = profile.goal
        level = profile.level
        dailyTime = profile.dailyTime
        nudgeTime = profile.nudgeTime
        interests = profile.interests
    }

    var trimmedName: String { name.trimmingCharacters(in: .whitespacesAndNewlines) }

    /// The back button, progress segments and Skip show between Welcome and Summary.
    var showsTopBar: Bool { step != .welcome && step != .summary }

    /// Filled progress segments: one per step after Welcome.
    var completedSegments: Int { min(step.rawValue, Self.segmentCount) }

    /// Whether the main button is enabled. The name is required.
    var canContinue: Bool { step != .name || !trimmedName.isEmpty }

    var isLastStep: Bool { step == Step.allCases.last }

    var continueTitle: LocalizedStringResource {
        switch step {
        case .welcome: "Get started"
        case .summary: "Start learning"
        default: "Continue"
        }
    }

    /// Moves to the next step. Returns `true` when the flow is finished and
    /// the profile should be saved.
    @discardableResult
    func advance() -> Bool {
        guard canContinue else { return false }
        guard let next = Step(rawValue: step.rawValue + 1) else { return true }
        isMovingForward = true
        step = next
        return false
    }

    func goBack() {
        guard let previous = Step(rawValue: step.rawValue - 1) else { return }
        isMovingForward = false
        step = previous
    }

    /// Writes the answers to `existing`, or inserts a new profile, and marks
    /// onboarding as completed.
    @discardableResult
    func save(in context: ModelContext, existing: UserProfile?) -> UserProfile {
        let profile = existing ?? UserProfile(name: trimmedName)
        if existing == nil { context.insert(profile) }
        profile.name = trimmedName
        profile.nativeLanguage = nativeLanguage
        profile.goal = goal
        profile.level = level
        profile.dailyTime = dailyTime
        profile.nudgeTime = nudgeTime
        profile.interests = interests
        profile.hasCompletedOnboarding = true
        try? context.save()
        return profile
    }
}
