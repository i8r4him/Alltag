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

    /// A question with a gap, or several, and options to pick from.
    static func gap(_ difficulty: Difficulty, _ sentence: String? = nil, prompt: String = "Fill the gap.",
                    hint: String? = nil, options: [String], answer: Int, why: String) -> ExamQuestion {
        ExamQuestion(difficulty: difficulty, prompt: prompt, sentence: sentence, hint: hint,
                     kind: .choice(options: options, answer: answer), explanation: why)
    }

    /// The hard question: say `english` in German with tiles, with one or two tiles too many.
    static func build(_ english: String, prompt: String = "Build the sentence. One tile is left over.",
                      words: [String], answers: [String], why: String) -> ExamQuestion {
        ExamQuestion(difficulty: .hard, prompt: prompt, sentence: english,
                     kind: .build(words: words, answers: answers), explanation: why)
    }
}

extension GrammarRule {
    /// Rules with an exam are solved by passing it; the others still use "Try it".
    var hasExam: Bool { !exam.isEmpty }
}
