//
//  Route.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// Screens pushed onto the navigation stack from Home.
enum Route: Hashable {
    case translate
    case memory
    case learn
    case grammar
    case rule(id: String)
    case progress
    case profile
    case settings
    case beyond
    case debrief
    case briefing
}

extension Route {
    /// Title and building issue for the placeholder shown until the screen exists.
    var placeholder: (title: String, issue: Int) {
        switch self {
        case .translate: ("Translate", 31)
        case .memory: ("Memory", 32)
        case .learn: ("Learn", 34)
        case .grammar: ("Grammar", 36)
        case .rule(let id): (MockRules.rule(id: id)?.title ?? "Rule", 37)
        case .progress: ("Progress", 41)
        case .profile: ("Profile", 42)
        case .settings: ("Settings", 43)
        case .beyond: ("Beyond the app", 44)
        case .debrief: ("Debrief", 39)
        case .briefing: ("Briefing", 40)
        }
    }
}

/// Screens presented full-screen over everything else.
enum FullScreenRoute: Hashable, Identifiable {
    case conversation(Scenario.ID)
    case activity(Activity.ID)
    /// Replaying onboarding from Settings. First-run onboarding is shown by `RootView`.
    case onboarding

    var id: Self { self }
}
