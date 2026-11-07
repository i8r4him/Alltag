//
//  AppStateTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Testing
@testable import Alltag

@Suite("App state and navigation")
@MainActor
struct AppStateTests {
    @Test("Opening screens pushes them in order; popping to root returns Home")
    func pushAndPop() {
        let state = AppState()
        state.open(.grammar)
        state.open(.rule(id: "weil"))
        #expect(state.path == [.grammar, .rule(id: "weil")])

        state.popToRoot()
        #expect(state.path.isEmpty)
    }

    @Test("Presenting a flow covers the screen; dismissing removes it")
    func fullScreen() {
        let state = AppState()
        state.present(.conversation(.dentist))
        #expect(state.fullScreen == .conversation(.dentist))

        state.dismissFullScreen()
        #expect(state.fullScreen == nil)
    }

    @Test("Motion is reduced when either the system or the in-app toggle asks for it",
          arguments: [(false, false, false), (true, false, true), (false, true, true), (true, true, true)])
    func reduceMotion(system: Bool, inApp: Bool, expected: Bool) {
        let state = AppState(settings: AppSettings(defaults: .ephemeral()))
        state.settings.reduceMotion = inApp
        #expect(state.reducesMotion(system: system) == expected)
    }

    @Test("Onboarding is needed until a profile has completed it")
    func onboardingGate() {
        #expect(AppState.needsOnboarding([]))
        #expect(AppState.needsOnboarding([UserProfile(name: "Mara")]))
        #expect(!AppState.needsOnboarding([UserProfile(name: "Mara", hasCompletedOnboarding: true)]))
    }
}
