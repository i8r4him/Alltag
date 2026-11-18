//
//  AppState.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Observation
import SwiftUI

/// App-wide UI state: navigation and in-app settings that affect every screen.
/// Persistent data (profile, memory, …) lives in SwiftData, not here.
@Observable
final class AppState {
    /// The selected tab.
    var tab: AppTab = .today
    /// Each tab's navigation stack, above its root.
    var paths: [AppTab: [Route]] = [:]
    /// Each tab's root screen when it differs from `AppTab.root`,
    /// e.g. Memory opened with a search from Siri.
    private(set) var roots: [AppTab: Route] = [:]
    /// The screen currently covering everything, if any.
    var fullScreen: FullScreenRoute?
    /// Today's orb, when the learner tapped it to start the conversation now covering everything.
    private(set) var orbLaunch: OrbLaunch?
    /// Device settings (Reduce motion, Slower speech, …), persisted.
    let settings: AppSettings

    init(settings: AppSettings = AppSettings()) {
        self.settings = settings
    }

    /// The selected tab's navigation stack.
    var path: [Route] {
        get { paths[tab] ?? [] }
        set { paths[tab] = newValue }
    }

    /// The root screen of `tab`, or `nil` for Home.
    func root(of tab: AppTab) -> Route? {
        roots[tab] ?? tab.root
    }

    /// Pushes a screen onto the selected tab.
    func open(_ route: Route) {
        path.append(route)
    }

    /// Returns to the selected tab's root.
    func popToRoot() {
        path.removeAll()
    }

    /// Shows a screen from anywhere (Siri, Shortcuts, widgets): closes any
    /// full-screen flow, selects the screen's tab and opens it there.
    func show(_ route: Route) {
        fullScreen = nil
        if let rootTab = route.rootTab {
            roots[rootTab] = route
            paths[rootTab] = []
            tab = rootTab
        } else {
            tab = route.homeTab
            paths[tab] = [route]
        }
    }

    /// Presents a full-screen flow such as a conversation.
    func present(_ route: FullScreenRoute) {
        orbLaunch = nil
        fullScreen = route
    }

    /// Starts today's conversation from Today's orb. With `launch`, the orb carries the learner
    /// there, and the conversation is drawn over the tabs instead of slid up as a cover
    /// (see `talksOverTabs`), so it can fade in around the orb.
    func talk(from launch: OrbLaunch?) {
        orbLaunch = launch
        fullScreen = .conversation(.freeTalk)
    }

    /// Today's conversation, started from the orb, is drawn over the tabs rather than as a cover.
    var talksOverTabs: Bool {
        orbLaunch != nil && fullScreen == .conversation(.freeTalk)
    }

    func dismissFullScreen() {
        guard talksOverTabs else {
            fullScreen = nil
            return
        }
        withAnimation(.easeOut(duration: 0.3)) { fullScreen = nil }
    }

    /// Whether motion should be reduced, combining the system setting with the in-app toggle.
    func reducesMotion(system: Bool) -> Bool {
        system || settings.reduceMotion
    }

    /// First-run onboarding is needed until a profile has completed it.
    static func needsOnboarding(_ profiles: [UserProfile]) -> Bool {
        !profiles.contains { $0.hasCompletedOnboarding }
    }
}
