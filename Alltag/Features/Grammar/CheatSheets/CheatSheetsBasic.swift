//
//  CheatSheetsBasic.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension CheatSheet {
    /// Every sheet, A1 to C1. Three per level.
    static let all: [CheatSheet] = [
        wordOrder, presentTense, negation,
        past, cases, prepositions,
        verbAtTheEnd, relativeClauses, politeWishes,
        passive, verbsWithPrepositions, connectors,
        formalStyle, particles, passiveAlternatives
    ]

    static func row(_ german: String, _ meaning: LocalizedStringResource) -> Row {
        Row(german: german, meaning: meaning)
    }

    // MARK: A1

    static let wordOrder = CheatSheet(
        id: "word-order", level: .a1, label: "Verb 2", title: "Word order",
        summary: "In a main clause the verb is always second. Whatever comes first, the subject moves behind it.",
        systemImage: "arrow.left.arrow.right",
        parts: [
            Part(title: "Statements", rows: [
                row("Ich trinke heute Kaffee.", "The subject first"),
                row("Heute trinke ich Kaffee.", "Time first: the subject moves behind the verb"),
                row("Im Büro trinke ich Kaffee.", "Place first: the same")
            ]),
            Part(title: "Questions", rows: [
                row("Trinkst du Kaffee?", "Yes or no: the verb first"),
                row("Was trinkst du?", "A question word, then the verb")
            ])
        ]
    )

    static let presentTense = CheatSheet(
        id: "present-tense", level: .a1, label: "ich · du · er", title: "Present tense",
        summary: "Take the infinitive, drop -en and add the ending for the person.",
        systemImage: "person.2",
        parts: [
            Part(title: "lernen", rows: [
                row("ich lerne", "I learn"),
                row("du lernst", "you learn (friends, family)"),
                row("er · sie · es lernt", "he, she, it learns"),
                row("wir lernen", "we learn"),
                row("ihr lernt", "you learn (a group)"),
                row("sie · Sie lernen", "they learn · you learn (polite)")
            ]),
            Part(title: "Learn these by heart", rows: [
                row("ich bin · du bist · er ist", "sein, to be"),
                row("ich habe · du hast · er hat", "haben, to have")
            ])
        ]
    )

    static let negation = CheatSheet(
        id: "negation", level: .a1, label: "nicht · kein", title: "Saying no",
        summary: "kein stands for a noun with ein or no article. nicht is for everything else.",
        systemImage: "nosign",
        parts: [
            Part(title: "kein", rows: [
                row("Ich habe kein Auto.", "ein Auto becomes kein Auto"),
                row("Ich trinke keinen Kaffee.", "kein takes the endings of ein"),
                row("Wir haben keine Zeit.", "no article becomes keine")
            ]),
            Part(title: "nicht", rows: [
                row("Ich komme heute nicht.", "nicht near the end of the sentence"),
                row("Das ist nicht mein Auto.", "before what you say no to"),
                row("Das Essen ist nicht gut.", "before an adjective")
            ])
        ]
    )

    // MARK: A2

    static let past = CheatSheet(
        id: "past", level: .a2, label: "haben · sein", title: "Talking about the past",
        summary: "haben or sein in position 2, the participle at the very end.",
        systemImage: "clock.arrow.circlepath",
        parts: [
            Part(title: "haben or sein", rows: [
                row("Ich habe gekocht.", "Most verbs take haben"),
                row("Ich bin nach Berlin gefahren.", "Moving from A to B takes sein"),
                row("Sie ist eingeschlafen.", "A change of state takes sein"),
                row("Ich bin zu Hause geblieben.", "bleiben and sein take sein")
            ]),
            Part(title: "The participle", rows: [
                row("machen → gemacht", "Regular: ge- … -t"),
                row("fahren → gefahren", "Irregular: ge- … -en"),
                row("einkaufen → eingekauft", "Separable: ge- in the middle"),
                row("telefonieren → telefoniert", "-ieren and be-, ver-, er-: no ge-")
            ])
        ]
    )

    static let cases = CheatSheet(
        id: "cases", level: .a2, label: "Akk · Dat", title: "Cases",
        summary: "Who or what you act on is accusative. Who you give to or do something for is dative.",
        systemImage: "square.stack.3d.up",
        parts: [
            Part(title: "Accusative: wen? was?", rows: [
                row("den · die · das · die", "Only der changes: der becomes den"),
                row("einen · eine · ein", "ein: the same pattern"),
                row("Ich sehe den Mann.", "I see the man")
            ]),
            Part(title: "Dative: wem?", rows: [
                row("dem · der · dem · den", "Masculine, feminine, neuter, plural"),
                row("einem · einer · einem", "ein in the dative"),
                row("mit den Kindern", "The plural adds -n")
            ]),
            Part(title: "Pronouns", rows: [
                row("mich · dich · ihn · sie · uns", "Accusative: me, you, him, her, us"),
                row("mir · dir · ihm · ihr · uns", "Dative: to me, to you, to him, to her, to us")
            ])
        ]
    )

    static let prepositions = CheatSheet(
        id: "prepositions", level: .a2, label: "mit · für · in", title: "Prepositions and cases",
        summary: "Each preposition decides the case of the noun after it.",
        systemImage: "mappin.and.ellipse",
        parts: [
            Part(title: "Always dative", rows: [
                row("aus · bei · mit · nach · seit · von · zu", "from, at, with, after, since, from, to"),
                row("Ich fahre mit dem Bus.", "I'm going by bus."),
                row("zum · zur · beim · vom", "Short for zu dem, zu der, bei dem, von dem")
            ]),
            Part(title: "Always accusative", rows: [
                row("durch · für · gegen · ohne · um", "through, for, against, without, around"),
                row("Das ist für dich.", "This is for you.")
            ]),
            Part(title: "Where? or Where to?", rows: [
                row("Ich bin in der Küche.", "Where: dative"),
                row("Ich gehe in die Küche.", "Where to: accusative"),
                row("an · auf · hinter · in · neben · über · unter · vor · zwischen", "These nine work this way")
            ])
        ]
    )
}
