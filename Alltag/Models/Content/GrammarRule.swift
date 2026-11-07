//
//  GrammarRule.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// A grammar rule taught from a real-life example, with a word-order task.
struct GrammarRule: Identifiable, Hashable, Sendable {
    /// A word tile in the "Notice" section.
    struct Tile: Hashable, Sendable {
        enum Role: Hashable, Sendable {
            case plain
            /// The key word that triggers the rule (outlined).
            case key
            /// The conjugated verb (accent tint).
            case verb
            /// The part that goes to the end (accent tint).
            case end
        }

        let text: String
        var role: Role = .plain
    }

    /// A slot in the pattern bar of "The rule".
    struct PatternSlot: Hashable, Sendable {
        enum Emphasis: Hashable, Sendable {
            case none
            case verb
            case end
        }

        let label: String
        var emphasis: Emphasis = .none
    }

    /// A mistake the learner made that this rule fixes.
    struct LearnerMistake: Hashable, Sendable {
        let wrong: String
        let right: String
        /// e.g. "Messages · 3 times this week".
        let source: String
    }

    /// Identifier, e.g. "weil".
    let id: String
    let level: Level
    let title: String
    /// Where the example was heard, e.g. "Station announcement".
    let place: String
    let systemImage: String
    let german: String
    let english: String
    let tiles: [Tile]
    let notice: String
    let rule: String
    let pattern: [PatternSlot]
    var yourMistake: LearnerMistake?
    /// Instruction for the word-order task.
    let taskPrompt: String
    /// Tiles to arrange, in shuffled order.
    let taskWords: [String]
    /// Accepted answers (words joined by single spaces).
    let taskAnswers: [String]

    /// Whether `words`, joined in order, is an accepted answer.
    func isCorrect(_ words: [String]) -> Bool {
        taskAnswers.contains(words.joined(separator: " "))
    }
}

/// A grammar topic in the Grammar list. Only some topics have a full rule.
struct GrammarTopic: Hashable, Sendable {
    enum Status: Hashable, Sendable {
        case solved
        case learning
        case mistake
        case new
    }

    let title: String
    /// The full rule, if one exists.
    var ruleID: String?
    let status: Status
}
