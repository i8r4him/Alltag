//
//  AppStateTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import CoreGraphics
import Testing
@testable import Alltag

@Suite("App state and navigation")
@MainActor
struct AppStateTests {
    @Test("Opening screens pushes them in order; popping to root returns to the tab's root")
    func pushAndPop() {
        let state = AppState()
        state.open(.grammar)
        state.open(.rule(id: "weil"))
        #expect(state.path == [.grammar, .rule(id: "weil")])

        state.popToRoot()
        #expect(state.path.isEmpty)
    }

    @Test("Each tab keeps its own stack")
    func stackPerTab() {
        let state = AppState()
        state.open(.profile)
        state.tab = .learn
        #expect(state.path.isEmpty)
        state.open(.grammar)

        state.tab = .today
        #expect(state.path == [.profile])
        #expect(state.paths[.learn] == [.grammar])
    }

    @Test("Tabs start at their own screens; Today shows Home")
    func roots() {
        let state = AppState()
        #expect(state.root(of: .today) == nil)
        #expect(state.root(of: .learn) == .learn)
        #expect(state.root(of: .memory) == .memory())
    }

    @Test("Presenting a flow covers the screen; dismissing removes it")
    func fullScreen() {
        let state = AppState()
        state.present(.conversation(.dentist))
        #expect(state.fullScreen == .conversation(.dentist))

        state.dismissFullScreen()
        #expect(state.fullScreen == nil)
    }

    @Test("Talking from Today's orb draws the conversation over the tabs, not as a cover")
    func talkFromOrb() {
        let state = AppState()
        state.talk(from: OrbLaunch(frame: CGRect(x: 80, y: 120, width: 230, height: 230)))
        #expect(state.fullScreen == .conversation(.freeTalk))
        #expect(state.talksOverTabs)

        // Ending it sends the orb back first; the conversation closes once it is there.
        state.dismissFullScreen()
        #expect(state.isOrbReturning)
        #expect(state.fullScreen == .conversation(.freeTalk))
        state.finishOrbReturn()
        #expect(!state.isOrbReturning)
        #expect(state.fullScreen == nil)
        #expect(!state.talksOverTabs)

        // Without the orb (Reduce Motion) or from anywhere else, it is an ordinary cover.
        state.talk(from: nil)
        #expect(!state.talksOverTabs)
        state.present(.conversation(.freeTalk))
        #expect(!state.talksOverTabs)
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
