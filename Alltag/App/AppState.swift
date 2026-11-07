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
    /// The navigation stack below Home.
    var path: [Route] = []
    /// The screen currently covering everything, if any.
    var fullScreen: FullScreenRoute?
    /// In-app Reduce Motion toggle (Settings), on top of the system setting.
    var reduceMotion = false

    /// Pushes a screen.
    func open(_ route: Route) {
        path.append(route)
    }

    /// Returns to Home.
    func popToRoot() {
        path.removeAll()
    }

    /// Presents a full-screen flow such as a conversation.
    func present(_ route: FullScreenRoute) {
        fullScreen = route
    }

    func dismissFullScreen() {
        fullScreen = nil
    }

    /// Whether motion should be reduced, combining the system setting with the in-app toggle.
    func reducesMotion(system: Bool) -> Bool {
        system || reduceMotion
    }

    /// First-run onboarding is needed until a profile has completed it.
    static func needsOnboarding(_ profiles: [UserProfile]) -> Bool {
        !profiles.contains { $0.hasCompletedOnboarding }
    }
}
