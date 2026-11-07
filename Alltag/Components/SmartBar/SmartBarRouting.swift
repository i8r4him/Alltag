//
//  SmartBarRouting.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The screens that show the Smart Bar. Each has its own placeholder and
/// decides what sending text does.
enum SmartBarContext: Hashable, Sendable {
    case home
    case memory
    case learn
    case progress
    case grammar

    var placeholder: LocalizedStringResource {
        switch self {
        case .home, .grammar: "Ask, translate or practise anything…"
        case .memory: "Find or add a word…"
        case .learn: "Ask for a 2-minute challenge…"
        case .progress: "Ask about your progress…"
        }
    }
}

/// Something the learner did in the Smart Bar.
enum SmartBarAction: Hashable, Sendable {
    /// The send button or Return, with the typed text.
    case submit(String)
    /// The mic button (empty field).
    case speak
    case translateChip(String)
    case practiseSpeakingChip
    case fixMistakeChip
    case reviewWordsChip
}

/// Where a Smart Bar action leads.
enum SmartBarDestination: Hashable, Sendable {
    case push(Route)
    case present(FullScreenRoute)
    /// Filter the current list (Memory).
    case search(String)
}

enum SmartBarRouting {
    /// The scenario the mic and "Practise speaking" open (Today's Focus).
    static let defaultScenario: Scenario.ID = .dentist

    static func destination(for action: SmartBarAction, in context: SmartBarContext) -> SmartBarDestination {
        switch action {
        case .submit(let text):
            let text = text.trimmingCharacters(in: .whitespacesAndNewlines)
            return context == .memory ? .search(text) : .push(.translate(text: text))
        case .translateChip(let text):
            let text = text.trimmingCharacters(in: .whitespacesAndNewlines)
            return .push(.translate(text: text.isEmpty ? nil : text))
        case .speak, .practiseSpeakingChip:
            return .present(.conversation(defaultScenario))
        case .fixMistakeChip:
            return .present(.activity(.mistakes))
        case .reviewWordsChip:
            return .present(.activity(.recall))
        }
    }
}
