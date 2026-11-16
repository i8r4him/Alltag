//
//  MockRules+C1.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The C1 rules, in the shape of the A1 rules: one line of rule, a picture
/// with a tiny table, and an exam of an easy, a medium and a hard question.
/// Only the rules that are new at C1; those shared with B2 are in B2. Their
/// IDs start with "c1-". Written for the app, in its own words.
extension MockRules {
    /// The C1 rules in the order they are learnt and open: verbs and tenses,
    /// the passive, prepositions, linking ideas, then formal and spoken style.
    static let c1: [GrammarRule] = [
        c1Tenses, c1PastGuess, c1Claims, c1PrefixVerbs, c1GenitiveVerbs, c1ArticleWords,
        c1PassiveNoSubject, c1PassiveLimits, c1PassiveAlternatives,
        c1PlacePrepositions, c1PrepositionMeanings, c1SourcePrepositions, c1MeaningPrepositions,
        c1TimeLinks, c1ReasonLinks, c1MeansLinks,
        c1Nominal, c1FunctionVerbs, c1Attributes, c1FocusParticles, c1InformationOrder, c1SpokenGerman
    ]
}
