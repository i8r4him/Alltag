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
    /// Memory, optionally filtered to one kind (e.g. words from your day)
    /// or searching for a word (e.g. from Siri).
    case memory(kind: MemoryKind? = nil, search: String? = nil)
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
