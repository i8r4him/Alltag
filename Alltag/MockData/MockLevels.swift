//
//  MockLevels.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The grammar topics per level. Every A1 topic is a full rule, in the order
/// the rules open. Above A1 the list is still the prototype's (`LEVELS`):
/// topics with a `ruleID` have a full rule in `MockRules`, the others are
/// listed only. A topic with a rule is never listed as solved: only the
/// learner solves it, and the rules of a level open in order.
enum MockLevels {
    static func topics(for level: Level) -> [GrammarTopic] {
        topicsByLevel[level] ?? []
    }

    /// Rules worth a look because of the learner's mistakes, with why.
    static let focus: [(ruleID: String, reason: String)] = [
        ("weil", "Came up in 4 of your last 6 conversations"),
        ("seit", "3 times in Messages this week")
    ]

    static let topicsByLevel: [Level: [GrammarTopic]] = [
        .a1: MockRules.a1.map { GrammarTopic(title: $0.title, ruleID: $0.id, status: .new) },
        .a2: [
            GrammarTopic(title: "Talking about the past", ruleID: "perfekt", status: .new),
            GrammarTopic(title: "„seit“ or „für“?", ruleID: "seit", status: .mistake),
            GrammarTopic(title: "The dative", status: .learning),
            GrammarTopic(title: "Separable verbs", status: .solved),
            GrammarTopic(title: "Comparing things", status: .solved)
        ],
        .b1: [
            GrammarTopic(title: "Verb at the end after weil, wenn, dass", ruleID: "weil", status: .mistake),
            GrammarTopic(title: "Relative clauses", status: .learning),
            GrammarTopic(title: "Polite wishes with würde & hätte", status: .learning),
            GrammarTopic(title: "The simple past in stories", status: .new),
            GrammarTopic(title: "The genitive", status: .new)
        ],
        .b2: [
            GrammarTopic(title: "When the action matters more than who", ruleID: "passiv", status: .new),
            GrammarTopic(title: "Reported speech", status: .new),
            GrammarTopic(title: "Verbs with fixed prepositions", status: .new),
            GrammarTopic(title: "Two-part connectors", status: .new),
            GrammarTopic(title: "Participles as adjectives", status: .new)
        ],
        .c1: [
            GrammarTopic(title: "Formal style: verbs become nouns", ruleID: "nominal", status: .new),
            GrammarTopic(title: "Extended participle phrases", status: .new),
            GrammarTopic(title: "Modal particles: doch, ja, mal", status: .new),
            GrammarTopic(title: "Alternatives to the passive", status: .new),
            GrammarTopic(title: "Subjective modal verbs", status: .new)
        ]
    ]
}
