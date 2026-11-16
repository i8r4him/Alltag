//
//  RuleExam.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// One question of a rule's exam. An exam has three: easy, medium and hard.
struct ExamQuestion: Identifiable, Hashable, Sendable {
    enum Difficulty: Int, CaseIterable, Hashable, Sendable {
        case easy
        case medium
        case hard
    }

    enum Kind: Hashable, Sendable {
        /// Pick one of the options; `answer` is the index of the right one.
        case choice(options: [String], answer: Int)
        /// Build the sentence from tiles. Some tiles may be left over; `answers`
        /// are the accepted sentences, words joined by single spaces.
        case build(words: [String], answers: [String])
    }

    let difficulty: Difficulty
    /// What to do, e.g. "Fill the gap."
    let prompt: String
    /// The sentence the question is about: German with a gap, or English to say in German.
    var sentence: String?
    /// A small help under the question, e.g. the nouns with their articles.
    var hint: String?
    let kind: Kind
    /// Why the right answer is right, shown after checking.
    let explanation: String

    var id: Difficulty { difficulty }
}

extension GrammarRule {
    /// Rules with an exam are solved by passing it; the others still use "Try it".
    var hasExam: Bool { !exam.isEmpty }
}
