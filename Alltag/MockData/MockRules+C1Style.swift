//
//  MockRules+C1Style.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The C1 rules, part 5: formal written style. Verbs become nouns, a noun and
/// a verb say one thing, and a noun is described before and after it.
extension MockRules {
    static let c1Nominal = GrammarRule(
        id: "c1-nominalisierung", level: .c1, title: "Formal style: verbs become nouns",
        place: "News headline", systemImage: "newspaper",
        german: "Nach der Erhöhung der Mieten protestierten Tausende.",
        english: "After the rent increase, thousands protested.",
        tiles: [Tile(text: "Nach", role: .key), Tile(text: "der Erhöhung", role: .verb), Tile(text: "der Mieten", role: .end),
                Tile(text: "protestierten Tausende.")],
        notice: "Spoken German says „Nachdem die Mieten erhöht worden waren …“. The news packs the whole clause into a noun.",
        rule: "Formal German turns a clause into a noun: the verb becomes a noun (erhöhen → die Erhöhung), "
            + "what it was about becomes a genitive, and the connector becomes a preposition (weil → wegen).",
        visual: RuleVisual(
            source: Part(systemImage: "text.bubble", german: "weil die Preise steigen", marked: "weil", role: "spoken",
                         name: "a clause"),
            target: Part(systemImage: "newspaper", german: "wegen des Anstiegs der Preise", marked: "wegen", role: "written",
                         name: "a noun"),
            sentence: "Weil die Preise steigen. Wegen des Anstiegs der Preise.",
            columns: ["verb", "noun"],
            rows: [
                Row(label: "-ung", cells: ["erhöhen", "die Erhöhung"], marked: [1]),
                Row(label: "the stem", cells: ["ansteigen", "der Anstieg"], marked: [1]),
                Row(label: "-e", cells: ["suchen", "die Suche"], marked: [1]),
                Row(label: "the infinitive", cells: ["reisen", "das Reisen"], marked: [1]),
                Row(label: "connector", cells: ["weil, nachdem", "wegen, nach"], marked: [1])
            ]
        ),
        exam: [
            .gap(.easy, "Nach ___ des Vertrags zog sie aus.", hint: "kündigen",
                 options: ["die Kündigung", "der Kündigung", "dem Kündigen"], answer: 1,
                 why: "kündigen becomes die Kündigung, and nach takes the dative: nach der Kündigung."),
            .gap(.medium, "Weil die Kosten gestiegen sind, …", prompt: "Which is the formal version?",
                 options: ["Wegen dem Steigen die Kosten", "Wegen der Anstieg der Kosten", "Wegen des Anstiegs der Kosten"],
                 answer: 2,
                 why: "weil becomes wegen + genitive: des Anstiegs. The old subject, die Kosten, becomes a genitive too: der Kosten."),
            .build("Formal: „Bevor man den Vertrag unterschreibt, …“", prompt: "Build the formal version. Two tiles are left over.",
                   words: ["Bevor", "der Unterzeichnung", "Vor", "dem Vertrag", "des Vertrags"],
                   answers: ["Vor der Unterzeichnung des Vertrags"],
                   why: "bevor becomes vor + dative. unterschreiben becomes the formal noun die Unterzeichnung, "
                    + "and the contract follows in the genitive.")
        ]
    )

    static let c1FunctionVerbs = GrammarRule(
        id: "c1-funktionsverben", level: .c1, title: "in Kraft treten: a noun and a verb as one",
        place: "News on the radio", systemImage: "radio",
        german: "Das neue Gesetz tritt am 1. Januar in Kraft.",
        english: "The new law comes into force on 1 January.",
        tiles: [Tile(text: "Das neue Gesetz"), Tile(text: "tritt", role: .verb), Tile(text: "am 1. Januar"),
                Tile(text: "in Kraft", role: .end)],
        notice: "„in Kraft treten“ is one idea: to become valid. The noun carries the meaning, and „tritt“ only does the grammar.",
        rule: "A noun and an almost empty verb say one thing, more formally: zur Verfügung stellen (provide). "
            + "Many come in pairs, active and passive: zur Sprache bringen (mention) and zur Sprache kommen (be mentioned).",
        visual: RuleVisual(
            source: Part(systemImage: "text.bubble", german: "Das wird diskutiert.", marked: "wird diskutiert",
                         role: "a passive"),
            verb: "=",
            target: Part(systemImage: "person.3.fill", german: "Das steht zur Diskussion.", marked: "zur Diskussion",
                         role: "noun + verb"),
            sentence: "Das wird diskutiert. Das steht zur Diskussion.",
            columns: ["active", "passive meaning"],
            rows: [
                Row(label: "mention", cells: ["zur Sprache\nbringen", "zur Sprache\nkommen"], marked: [1]),
                Row(label: "discuss", cells: ["zur Diskussion\nstellen", "zur Diskussion\nstehen"], marked: [1]),
                Row(label: "consider", cells: ["in Betracht\nziehen", "in Betracht\nkommen"], marked: [1]),
                Row(label: "apply", cells: ["anwenden", "Anwendung\nfinden"], marked: [1])
            ]
        ),
        exam: [
            .gap(.easy, "Die Firma stellt allen Mitarbeitern einen Laptop zur ___.",
                 options: ["Verwendung", "Verfügung", "Vorstellung"], answer: 1,
                 why: "zur Verfügung stellen means to provide. The noun is fixed: no other one fits."),
            .gap(.medium, "Die Methode ___ in vielen Schulen schon Anwendung, aber eine Pflicht ___ nicht in Frage.",
                 prompt: "Fill both gaps.", options: ["macht … steht", "findet … kommt", "hat … kommt"], answer: 1,
                 why: "Anwendung finden means it is used, and in Frage kommen means it is possible. "
                    + "The verbs are fixed: no other verb works."),
            .build("The topic wasn't mentioned in the meeting.", prompt: "Build the sentence. Two tiles are left over.",
                   words: ["Das Thema", "brachte", "kam", "in der Sitzung", "nicht", "zum Ausdruck", "zur Sprache"],
                   answers: ["Das Thema kam in der Sitzung nicht zur Sprache"],
                   why: "zur Sprache kommen has a passive meaning: it was mentioned. zur Sprache bringen is the active one: "
                    + "someone mentions it. nicht goes before the fixed noun.")
        ]
    )

    static let c1Attributes = GrammarRule(
        id: "c1-attribute", level: .c1, title: "die seit Monaten geplante Reform: before and after the noun",
        place: "News headline", systemImage: "newspaper",
        german: "Die seit Monaten geplante Reform der Rente wurde gestoppt.",
        english: "The pension reform, planned for months, has been stopped.",
        tiles: [Tile(text: "Die"), Tile(text: "seit Monaten geplante", role: .key), Tile(text: "Reform", role: .verb),
                Tile(text: "der Rente", role: .end), Tile(text: "wurde gestoppt.")],
        notice: "Everything between „Die“ and „Reform“ describes the reform: one that has been planned for months. "
            + "After the noun, „der Rente“ says what it reforms.",
        rule: "A noun can be described on both sides. Before it, between article and noun: adjectives and whole participle "
            + "phrases. After it: a genitive, a preposition phrase or a relative clause.",
        visual: RuleVisual(
            source: Part(systemImage: "arrow.right.to.line", german: "die gestern gekaufte Jacke", marked: "gestern gekaufte",
                         role: "before the noun"),
            target: Part(systemImage: "arrow.left.to.line", german: "die Jacke, die ich gestern kaufte",
                         marked: "die ich gestern kaufte", role: "after the noun"),
            sentence: "die gestern gekaufte Jacke, die Jacke, die ich gestern kaufte",
            columns: ["before the noun", "after the noun"],
            rows: [
                Row(label: "adjective", cells: ["der neue Plan", "–"], marked: [0]),
                Row(label: "participle", cells: ["der heute\nvorgestellte Plan", "–"], marked: [0]),
                Row(label: "genitive", cells: ["–", "der Plan\nder Stadt"], marked: [1]),
                Row(label: "preposition", cells: ["–", "der Plan\nfür 2030"], marked: [1]),
                Row(label: "relative clause", cells: ["–", "der Plan, den\nwir kennen"], marked: [1])
            ],
            isLinked: false
        ),
        exam: [
            .gap(.easy, "Die ___ Gäste warteten im Foyer.", hint: "gerade angekommen",
                 options: ["gerade angekommene", "gerade angekommenen", "angekommenen gerade"], answer: 1,
                 why: "The participle takes the adjective ending, -en after die in the plural, and its own words go before it."),
            .gap(.medium, "Die Firma, die vor zehn Jahren gegründet wurde, …", prompt: "Which says the same?",
                 options: ["Die gegründete vor zehn Jahren Firma", "Die vor zehn Jahren gründende Firma",
                           "Die vor zehn Jahren gegründete Firma"], answer: 2,
                 why: "The relative clause moves before the noun: its words first, the participle last. "
                    + "The firm was founded, so it's the past participle, not the present one (gründend)."),
            .build("the children playing in the garden", prompt: "Build the phrase. Two tiles are left over.",
                   words: ["die", "gespielten", "im Garten", "spielende", "spielenden", "Kinder"],
                   answers: ["die im Garten spielenden Kinder"],
                   why: "The children are doing the playing, so it's the present participle: spielend, "
                    + "with -en after die in the plural. Its words, im Garten, go in front of it.")
        ]
    )
}
