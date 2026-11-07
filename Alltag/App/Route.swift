//
//  Route.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// Screens pushed onto the navigation stack from Home.
enum Route: Hashable {
    /// Translate, optionally pre-filled (e.g. from the Smart Bar).
    case translate(text: String? = nil)
    /// Memory, optionally filtered to one kind (e.g. words from your day).
    case memory(kind: MemoryKind? = nil)
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
    var placeholder: (title: LocalizedStringResource, issue: Int) {
        switch self {
        case .translate: ("Translate", 31)
        case .memory: ("Memory", 32)
        case .learn: ("Learn", 34)
        case .grammar: ("Grammar", 36)
        case .rule: ("Rule", 37)
        case .progress: ("Progress", 41)
        case .profile: ("Profile", 42)
        case .settings: ("Settings", 43)
        case .beyond: ("Beyond the app", 44)
        case .debrief: ("Debrief", 39)
        case .briefing: ("Briefing", 40)
        }
    }

    /// The Smart Bar shown on this screen, if any.
    var smartBarContext: SmartBarContext? {
        switch self {
        case .memory: .memory
        case .learn: .learn
        case .progress: .progress
        case .grammar: .grammar
        default: nil
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
