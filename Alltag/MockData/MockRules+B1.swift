//
//  MockRules+B1.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The B1 rules in the order they are learnt and open. They have the A1
/// shape: one line of rule, a picture with a tiny table, three real-life
/// sentences and an exam of three questions. Written for the app, not taken
/// from a textbook. The rules themselves are in the `MockRules+B1….swift`
/// files, their sentences in `RealLifeSentences+B1.swift`.
extension MockRules {
    static let b1: [GrammarRule] = [
        // Telling what happened, and when.
        b1SimplePast, b1PastPerfect, b1WennAls, b1TimeClauses,
        // Clauses inside a sentence.
        b1IndirectQuestions, b1RelativeClauses, b1RelativeClausesDative,
        // Verbs and what they take.
        b1PrefixVerbs, b1ReflexiveDative, b1PlaceVerbs, b1PrepositionVerbs, b1DaWoWords,
        // A second verb at the end.
        b1ZuInfinitive, b1BareInfinitive, b1Purpose, b1Lassen,
        // werden.
        b1Future, b1Passive, b1Subjunctive, b1UsesOfWerden,
        // Nouns and prepositions.
        b1Genitive, b1GenitivePrepositions, b1TimePrepositions, b1NDeclension,
        // Adjectives.
        b1AdjectiveNoArticle, b1AdjectiveNouns, b1Superlative, b1PresentParticiple,
        // Linking two ideas.
        b1TwoPartConnectors, b1JeDesto
    ]
}
