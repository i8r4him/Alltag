//
//  Situation.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 12.11.26.
//

import Foundation

/// An everyday situation to train with the live voice: who the companion
/// plays, and what the learner is trying to get done.
struct Situation: Identifiable, Hashable, Sendable {
    enum Category: String, CaseIterable, Identifiable, Sendable {
        case health, authorities, home, work, outAndAbout

        var id: String { rawValue }

        var title: LocalizedStringResource {
            switch self {
            case .health: "Health"
            case .authorities: "Offices and paperwork"
            case .home: "Home"
            case .work: "Work"
            case .outAndAbout: "Out and about"
            }
        }
    }

    let id: String
    let category: Category
    /// "At the doctor".
    let title: LocalizedStringResource
    /// What the learner does there: "Describe what's wrong".
    let detail: LocalizedStringResource
    let systemImage: String
    /// For the voice model, in English: who it plays.
    let role: String
    /// For the voice model, in English: what the learner wants to achieve.
    let aim: String

    static func == (lhs: Situation, rhs: Situation) -> Bool { lhs.id == rhs.id }
    func hash(into hasher: inout Hasher) { hasher.combine(id) }

    /// The conversation for this situation. It has no script: the live voice plays the other person.
    var scenario: Scenario {
        Scenario(id: .situation,
                 title: String(localized: title),
                 meta: String(localized: detail),
                 goal: String(localized: "Goal: \(String(localized: detail))"),
                 completion: String(localized: "You practised: \(String(localized: title))."),
                 savedPhrases: [],
                 systemImage: systemImage,
                 script: [],
                 role: role,
                 aim: aim)
    }
}
