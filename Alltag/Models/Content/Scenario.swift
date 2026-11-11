//
//  Scenario.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// A real-life conversation to rehearse, e.g. moving a dentist appointment.
struct Scenario: Identifiable, Hashable, Sendable {
    enum ID: String, Hashable, CaseIterable, Sendable {
        case dentist
        case postOffice
        case station
        /// Talking about anything with the companion, no role-play (the orb on Today).
        case freeTalk
    }

    let id: ID
    let title: String
    /// e.g. "German · B1 · phone call".
    let meta: String
    let goal: String
    /// Shown in the summary when the conversation is finished.
    let completion: String
    /// Phrases saved to Memory when the conversation ends.
    let savedPhrases: [SavedPhrase]
    let systemImage: String
    /// The scripted conversation (simulated until the companion is live).
    let script: [ConversationLine]

    /// A normal conversation about anything, with no script: live voice only.
    var isFreeTalk: Bool { id == .freeTalk }

    /// Number of learner turns in the script.
    var learnerTurns: Int { script.filter { $0.speaker == .learner }.count }
}

/// A phrase from a conversation that is saved to Memory.
struct SavedPhrase: Hashable, Sendable {
    let german: String
    let english: String
}

/// One line of a conversation.
struct ConversationLine: Hashable, Sendable {
    enum Speaker: Hashable, Sendable {
        case companion
        case learner
    }

    let speaker: Speaker
    let german: String
    let english: String
    /// Feedback on a learner line.
    var feedback: Feedback?
}

/// Feedback the companion gives on something the learner said.
struct Feedback: Hashable, Sendable {
    enum Kind: Hashable, Sendable {
        /// Correct and natural (green check).
        case good
        /// A mistake with its correction (coral).
        case fix
        /// A neutral tip (grey info).
        case note
    }

    let kind: Kind
    let title: String
    let note: String
    /// For a fix: the learner's sentence, corrected.
    var correction: String?
}
