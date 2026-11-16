//
//  MockLevels.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The grammar topics per level. Every A1 and A2 topic is a full rule, in the
/// order the rules open. Above A2 the list is still the prototype's (`LEVELS`):
/// topics with a `ruleID` have a full rule in `MockRules`, the others are
/// listed only. A topic with a rule is never listed as solved: only the
/// learner solves it, and the rules of a level open in order.
enum MockLevels {
    static func topics(for level: Level) -> [GrammarTopic] {
        topicsByLevel[level] ?? []
    }

    static let topicsByLevel: [Level: [GrammarTopic]] = [
        .a1: MockRules.a1.map { GrammarTopic(title: $0.title, ruleID: $0.id, status: .new) },
        .a2: MockRules.a2.map { GrammarTopic(title: $0.title, ruleID: $0.id, status: .new) },
        .b1: MockRules.b1.map { GrammarTopic(title: $0.title, ruleID: $0.id, status: .new) },
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
