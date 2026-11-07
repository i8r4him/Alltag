//
//  Briefing.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The 60-second spoken briefing built from the learner's words.
struct Briefing: Hashable, Sendable {
    let title: String
    let transcript: String
    /// Learning words used in the transcript, highlighted in the UI.
    let words: [String]
}

/// A moment from the learner's day to debrief, with suggested phrases.
struct Debrief: Hashable, Sendable {
    /// e.g. "Lunch at the bakery".
    let event: String
    /// e.g. "12:40".
    let time: String
    /// What the learner wanted to say (sample input).
    let sampleInput: String
    let phrases: [Example]
    let grammarTip: String
    /// Phrasebook group the phrases are saved to.
    let phrasebookPlace: String
    let phrasebookSymbol: String

    struct Example: Hashable, Sendable {
        let german: String
        let english: String
    }
}

/// The one-question placement test in onboarding.
struct PlacementQuestion: Hashable, Sendable {
    struct Answer: Hashable, Sendable {
        let german: String
        let level: Level
    }

    let question: String
    let instruction: String
    let answers: [Answer]
}
