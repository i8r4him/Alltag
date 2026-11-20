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
    var allowsNotifications = false
    var usesKeyboard = false

    // Level step: the one-question placement test
    /// Whether the placement question replaces the level list.
    private(set) var isPlacing = false
    /// The answer picked in the placement test, if any.
    private(set) var placementAnswer: PlacementQuestion.Answer?

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
        allowsNotifications = profile.remindersEnabled
        usesKeyboard = profile.learnsFromKeyboard
    }

    var trimmedName: String { name.trimmingCharacters(in: .whitespacesAndNewlines) }

    /// How many of the "Learn from your day" permissions are allowed.
    var allowedCount: Int {
        [allowsNotifications, usesKeyboard].filter { $0 }.count
    }

    /// Toggles an interest on or off.
    func toggle(_ interest: Interest) {
        if interests.contains(interest) {
            interests.remove(interest)
        } else {
            interests.insert(interest)
        }
    }

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
        resetPlacement()
        return false
    }

    func goBack() {
        guard let previous = Step(rawValue: step.rawValue - 1) else { return }
        isMovingForward = false
        step = previous
        resetPlacement()
    }

    /// Schedules the daily reminder at the chosen time if notifications were allowed.
    func scheduleReminder(with notifications: any NotificationService) async throws {
        guard allowsNotifications else { return }
        try await notifications.scheduleDailyNudge(at: nudgeTime)
    }

    /// Shows the placement question instead of the level list.
    func startPlacement() {
        placementAnswer = nil
        isPlacing = true
    }

    /// Picks a placement answer, which sets the level.
    func choosePlacement(_ answer: PlacementQuestion.Answer) {
        placementAnswer = answer
        level = answer.level
    }

    private func resetPlacement() {
        isPlacing = false
        placementAnswer = nil
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
        // As in the prototype: notifications switch on reminders and the morning briefing.
        profile.learnsFromKeyboard = usesKeyboard
        profile.remindersEnabled = allowsNotifications
        profile.morningBriefingEnabled = allowsNotifications
        profile.hasCompletedOnboarding = true
        try? context.save()
        return profile
    }
}
