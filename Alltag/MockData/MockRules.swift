//
//  MockRules.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The grammar rules. The A1 and B1 rules have the new shape (one line of
/// rule, a picture with a tiny table, an exam): the twenty A1 rules are in the
/// `MockRules+A1….swift` files and `MockRules+Accusative.swift`, in the order
/// `a1` lists them. The twenty A2 rules have the same shape and are listed in
/// `MockRules+A2.swift`. The rules above A2 are still the prototype's (`RULES`).
enum MockRules {
    typealias Tile = GrammarRule.Tile
    typealias Slot = GrammarRule.PatternSlot
    typealias Mistake = GrammarRule.LearnerMistake
    typealias Part = RuleVisual.Part
    typealias Row = RuleVisual.Row

    /// The A1 rules in the order they are learnt and open.
    static let a1: [GrammarRule] = [
        pronouns, seinHaben, presentTense, verbSecond, yesNoQuestions, wQuestions, articles, plural, negation,
        accusative, vowelChange, modalVerbs, separableVerbs, imperative, possessives, dative, whereDative,
        fixedPrepositions, timePrepositions, whichThis
    ]

    static let all: [GrammarRule] = a1 + a2 + b1 + b2 + c1

    static func rule(id: String) -> GrammarRule? {
        all.first { $0.id == id }
    }

    static let verbSecond = GrammarRule(
        id: "v2", level: .a1, title: "The verb is always second",
        place: "At the café", systemImage: "cup.and.saucer",
        german: "Heute trinke ich einen Cappuccino.", english: "Today I'm having a cappuccino.",
        tiles: [Tile(text: "Heute", role: .key), Tile(text: "trinke", role: .verb), Tile(text: "ich"), Tile(text: "einen Cappuccino")],
        notice: "„Heute“ takes the first spot, so „ich“ has to move behind the verb.",
        rule: "In a main clause, the conjugated verb sits in position 2. Whatever comes first — time, place, object — "
            + "the subject moves behind the verb.",
        pattern: [Slot(label: "Position 1"), Slot(label: "Verb", emphasis: .verb), Slot(label: "Subject"), Slot(label: "Rest")],
        taskPrompt: "Start with „Morgen“:",
        taskWords: ["ich", "Morgen", "nach Berlin", "fahre"],
        taskAnswers: ["Morgen fahre ich nach Berlin"],
        visual: verbSecondVisual,
        exam: verbSecondExam
    )

    static let seit = GrammarRule(
        id: "seit", level: .a2, title: "„seit“ or „für“?",
        place: "Meeting a neighbour", systemImage: "house",
        german: "Seit wann wohnst du hier? — Seit drei Jahren.",
        english: "How long have you lived here? — For three years.",
        tiles: [Tile(text: "Seit", role: .key), Tile(text: "drei"), Tile(text: "Jahren", role: .end)],
        notice: "It started three years ago and is still true. „Jahren“ takes the dative -n.",
        rule: "„seit“ + dative for something that began in the past and continues now. "
            + "„für“ for a planned, closed stretch of time.",
        pattern: [Slot(label: "seit", emphasis: .verb), Slot(label: "+ dative", emphasis: .end), Slot(label: "still true")],
        yourMistake: Mistake(wrong: "Ich wohne hier für drei Jahren.", right: "Ich wohne hier seit drei Jahren.",
                             source: "Messages · 3 times this week"),
        taskPrompt: "Say: \"I have been learning German for two years.\"",
        taskWords: ["seit", "lerne", "zwei Jahren", "Ich", "Deutsch"],
        taskAnswers: ["Ich lerne seit zwei Jahren Deutsch", "Ich lerne Deutsch seit zwei Jahren"]
    )
}
