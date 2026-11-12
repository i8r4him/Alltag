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
        /// Only for the learner's own situations that fit nowhere else.
        case other

        var id: String { rawValue }

        /// The artwork of a learner's own situation in this category.
        var systemImage: String {
            switch self {
            case .health: "cross.case.fill"
            case .authorities: "building.columns.fill"
            case .home: "house.fill"
            case .work: "briefcase.fill"
            case .outAndAbout: "figure.walk"
            case .other: "bubble.left.and.text.bubble.right.fill"
            }
        }

        var title: LocalizedStringResource {
            switch self {
            case .health: "Health"
            case .authorities: "Offices and paperwork"
            case .home: "Home"
            case .work: "Work"
            case .outAndAbout: "Out and about"
            case .other: "Other"
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
    /// Added by the learner (see `CustomSituation`).
    var isCustom = false

    /// The learner's own words as display text. There is no catalog entry for them, so they are shown as typed.
    static func verbatim(_ text: String) -> LocalizedStringResource {
        LocalizedStringResource(String.LocalizationValue(text))
    }

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
