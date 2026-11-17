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

    static func row(_ german: String, _ meaning: LocalizedStringResource,
                    symbol: String? = nil, marked: String? = nil, key: String? = nil) -> Row {
        Row(german: german, meaning: meaning, systemImage: symbol, marked: marked, key: key)
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
                row("Ich fahre mit dem Bus zur Arbeit.", "mit: how you go, or who with", symbol: "bus.fill", marked: "mit dem", key: "dat"),
                row("Heute Abend bin ich bei meiner Schwester.", "bei: at someone's place", symbol: "house.fill",
                    marked: "bei meiner", key: "dat"),
                row("Ich muss morgen zum Arzt.", "zu: to a person or place. zum is zu dem", symbol: "cross.case.fill",
                    marked: "zum", key: "dat"),
                row("Ich komme gerade von der Arbeit.", "von: from a person or place", symbol: "briefcase.fill",
                    marked: "von der", key: "dat"),
                row("Seit einem Jahr wohne ich in Köln.", "seit: since, and still true", symbol: "calendar",
                    marked: "Seit einem", key: "dat"),
                row("aus · bei · mit · nach · seit · von · zu", "The seven to learn together", symbol: "list.bullet", key: "dat")
            ], key: "dat", picture: RuleVisual(
                source: RuleVisual.Part(systemImage: "figure.stand", german: "Ich fahre", role: "Wer?"),
                verb: "mit",
                target: RuleVisual.Part(systemImage: "bus.fill", german: "dem Bus", marked: "dem", role: "Womit?", name: "Dativ"),
                sentence: "Ich fahre mit dem Bus.", columns: [], rows: []
            )),
            Part(title: "Always accusative", rows: [
                row("Die Blumen sind für dich.", "für: for someone", symbol: "gift.fill", marked: "für dich", key: "akk"),
                row("Ich fahre ohne meinen Mann in den Urlaub.", "ohne: without", symbol: "suitcase.rolling.fill",
                    marked: "ohne meinen", key: "akk"),
                row("Wir laufen durch den Park.", "durch: through", symbol: "tree.fill", marked: "durch den", key: "akk"),
                row("Der Supermarkt ist gleich um die Ecke.", "um: around. With a time: um 8 Uhr", symbol: "cart.fill",
                    marked: "um die", key: "akk"),
                row("durch · für · gegen · ohne · um", "The five to learn together", symbol: "list.bullet", key: "akk")
            ], key: "akk", picture: RuleVisual(
                source: RuleVisual.Part(systemImage: "gift.fill", german: "die Blumen", role: "Was?"),
                verb: "für",
                target: RuleVisual.Part(systemImage: "person.fill", german: "dich", marked: "dich", role: "Für wen?", name: "Akkusativ"),
                sentence: "Die Blumen sind für dich.", columns: [], rows: []
            )),
            Part(title: "Where? or Where to?", rows: [
                row("Ich bin in der Küche.", "You stay in a place: dative", symbol: "mappin.and.ellipse", marked: "in der", key: "wo"),
                row("Ich gehe in die Küche.", "You move to a place: accusative", symbol: "figure.walk", marked: "in die", key: "wohin"),
                row("Das Handy liegt auf dem Tisch.", "liegen: it stays there", symbol: "iphone", marked: "auf dem", key: "wo"),
                row("Ich lege das Handy auf den Tisch.", "legen: you put it there", symbol: "hand.point.down.fill",
                    marked: "auf den", key: "wohin"),
                row("an · auf · hinter · in · neben · über · unter · vor · zwischen", "These nine work this way",
                    symbol: "list.bullet")
            ], picture: RuleVisual(
                source: RuleVisual.Part(systemImage: "mappin.and.ellipse", german: "in der Küche", marked: "der",
                                        role: "Wo?", name: "Dativ"),
                target: RuleVisual.Part(systemImage: "figure.walk", german: "in die Küche", marked: "die",
                                        role: "Wohin?", name: "Akkusativ"),
                sentence: "Wo? In der Küche. Wohin? In die Küche.", columns: [], rows: [], isLinked: false
            ))
        ],
        keys: [
            Key(id: "dat", systemImage: "d.circle.fill", german: "Dativ", meaning: "Always after aus, bei, mit, nach, seit, von, zu"),
            Key(id: "akk", systemImage: "a.circle.fill", german: "Akkusativ", meaning: "Always after durch, für, gegen, ohne, um"),
            Key(id: "wo", systemImage: "mappin.circle.fill", german: "Wo?", meaning: "You stay in a place: dative"),
            Key(id: "wohin", systemImage: "arrow.right.circle.fill", german: "Wohin?", meaning: "You move to a place: accusative")
        ]
    )
}
