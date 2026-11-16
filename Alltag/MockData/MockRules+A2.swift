//
//  MockRules+A2.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The twenty A2 rules in the order they are learnt and open. They have the
/// A1 shape (one line of rule, a picture with a tiny table, three short
/// real-life sentences and an exam) and live in the `MockRules+A2….swift`
/// files. Their IDs start with "a2-". Written for the app.
extension MockRules {
    static let a2: [GrammarRule] = [
        a2PerfectHaben, a2Participle, a2PerfectSein, a2SimplePast,
        a2Pronouns, a2DativeVerbs, a2TwoObjects, a2Reflexive,
        a2AndBut, a2Therefore, a2VerbAtEnd,
        a2WhereWhereTo, a2ToAtFrom, a2HereThere,
        a2AdjectiveDer, a2AdjectiveEin, a2Comparative,
        a2Particles, a2Compounds, a2Endings
    ]
}
