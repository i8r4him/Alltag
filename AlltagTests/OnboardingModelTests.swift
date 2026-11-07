//
//  OnboardingModelTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import SwiftData
import Testing
@testable import Alltag

@Suite("Onboarding model")
@MainActor
struct OnboardingModelTests {
    @Test("Starts on Welcome without the top bar")
    func start() {
        let model = OnboardingModel()
        #expect(model.step == .welcome)
        #expect(!model.showsTopBar)
        #expect(model.completedSegments == 0)
        #expect(String(localized: model.continueTitle) == "Get started")
    }

    @Test("The name step needs a name before continuing")
    func nameIsRequired() {
        let model = OnboardingModel()
        model.advance()
        #expect(model.step == .name)
        #expect(!model.canContinue)

        model.name = "   "
        #expect(!model.canContinue)
        #expect(model.advance() == false)
        #expect(model.step == .name)

        model.name = " Mara "
        #expect(model.canContinue)
        model.advance()
        #expect(model.step == .why)
    }

    @Test("Each step fills one more of the six segments; the top bar shows on steps 1–6")
    func progress() {
        let model = OnboardingModel()
        model.name = "Mara"
        for expected in 1...6 {
            model.advance()
            #expect(model.completedSegments == expected)
            #expect(model.showsTopBar)
        }
        model.advance()
        #expect(model.step == .summary)
        #expect(!model.showsTopBar)
        #expect(String(localized: model.continueTitle) == "Start learning")
    }

    @Test("The last step finishes instead of moving on")
    func finishes() {
        let model = OnboardingModel()
        model.name = "Mara"
        var finished = false
        for _ in OnboardingModel.Step.allCases {
            finished = model.advance()
        }
        #expect(finished)
        #expect(model.step == .summary)
    }

    @Test("Back moves one step and remembers the direction; it stops at Welcome")
    func back() {
        let model = OnboardingModel()
        model.name = "Mara"
        model.advance()
        model.advance()
        model.goBack()
        #expect(model.step == .name)
        #expect(!model.isMovingForward)

        model.goBack()
        model.goBack()
        #expect(model.step == .welcome)
    }

    @Test("The placement question replaces the level list and picking an answer sets the level")
    func placement() throws {
        let model = OnboardingModel()
        model.level = .c1
        model.startPlacement()
        #expect(model.isPlacing)
        #expect(model.placementAnswer == nil)

        let b2 = try #require(MockPlacement.question.answers.first { $0.level == .b2 })
        model.choosePlacement(b2)
        #expect(model.level == .b2)
        #expect(model.placementAnswer == b2)
        #expect(String(localized: MockPlacement.confirmation(for: .b2)).hasPrefix("Sounds like B2."))
    }

    @Test("Leaving the level step resets the placement question but keeps the level", arguments: [true, false])
    func placementResets(forward: Bool) throws {
        let model = OnboardingModel()
        model.name = "Mara"
        for _ in 0..<3 { model.advance() }
        #expect(model.step == .level)
        model.startPlacement()
        model.choosePlacement(try #require(MockPlacement.question.answers.first))

        if forward { model.advance() } else { model.goBack() }
        #expect(!model.isPlacing)
        #expect(model.placementAnswer == nil)
        #expect(model.level == .a2)
    }

    @Test("Saving creates a completed profile with every answer")
    func savesNewProfile() throws {
        let container = try AlltagStore.makeContainer(inMemory: true)
        let model = OnboardingModel()
        model.name = "  Mara "
        model.nativeLanguage = .arabic
        model.goal = .work
        model.level = .a2
        model.dailyTime = .twenty
        model.nudgeTime = .morning
        model.interests = [.music]

        model.save(in: container.mainContext, existing: nil)

        let profile = try #require(try container.mainContext.fetch(FetchDescriptor<UserProfile>()).first)
        #expect(profile.name == "Mara")
        #expect(profile.nativeLanguage == .arabic)
        #expect(profile.goal == .work)
        #expect(profile.level == .a2)
        #expect(profile.dailyTime == .twenty)
        #expect(profile.nudgeTime == .morning)
        #expect(profile.interests == [.music])
        #expect(profile.hasCompletedOnboarding)
        #expect(!AppState.needsOnboarding([profile]))
    }

    @Test("Replaying onboarding starts from and updates the existing profile")
    func replayUpdatesProfile() throws {
        let container = try AlltagStore.makeContainer(inMemory: true)
        let existing = UserProfile(name: "Mara", level: .b1, hasCompletedOnboarding: true)
        container.mainContext.insert(existing)

        let model = OnboardingModel(profile: existing)
        #expect(model.name == "Mara")
        #expect(model.level == .b1)

        model.level = .b2
        model.save(in: container.mainContext, existing: existing)

        let profiles = try container.mainContext.fetch(FetchDescriptor<UserProfile>())
        #expect(profiles.count == 1)
        #expect(profiles.first?.level == .b2)
    }
}
