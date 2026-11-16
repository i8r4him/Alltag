//
//  CheatSheetsAdvanced.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension CheatSheet {
    // MARK: B1

    static let verbAtTheEnd = CheatSheet(
        id: "verb-at-the-end", level: .b1, label: "weil · dass", title: "Verb at the end",
        summary: "After weil, dass, wenn, ob and similar words, the conjugated verb goes to the end of the clause.",
        systemImage: "arrow.right.to.line",
        parts: [
            Part(title: "The verb goes to the end", rows: [
                row("…, weil ich müde bin.", "because"),
                row("…, dass du kommst.", "that"),
                row("…, wenn es regnet.", "if, when"),
                row("…, ob er Zeit hat.", "whether"),
                row("…, obwohl es spät ist.", "although")
            ]),
            Part(title: "The verb stays second", rows: [
                row("…, denn ich bin müde.", "denn also means because"),
                row("…, deshalb bleibe ich zu Hause.", "After deshalb the verb comes next")
            ])
        ]
    )

    static let relativeClauses = CheatSheet(
        id: "relative-clauses", level: .b1, label: "der · den · dem", title: "Relative clauses",
        summary: "The pronoun takes the gender of the noun and the case of its role in the clause. The verb goes to the end.",
        systemImage: "link",
        parts: [
            Part(title: "Who or which", rows: [
                row("der Mann, der hier wohnt", "Subject: like the article"),
                row("der Mann, den ich kenne", "Accusative"),
                row("der Mann, dem ich helfe", "Dative"),
                row("die Leute, denen ich helfe", "Dative plural: denen"),
                row("die Frau, mit der ich arbeite", "The preposition comes first")
            ])
        ]
    )

    static let politeWishes = CheatSheet(
        id: "polite-wishes", level: .b1, label: "würde · hätte", title: "Polite wishes",
        summary: "würde, hätte, wäre and könnte make a request softer, or talk about what isn't real.",
        systemImage: "hand.wave",
        parts: [
            Part(title: "Asking politely", rows: [
                row("Ich hätte gern einen Kaffee.", "I'd like a coffee."),
                row("Könnten Sie mir helfen?", "Could you help me?"),
                row("Würden Sie das Fenster öffnen?", "Would you open the window?")
            ]),
            Part(title: "If only", rows: [
                row("Ich würde gern kommen.", "würde + infinitive at the end"),
                row("Wenn ich Zeit hätte, …", "If I had time, …"),
                row("Das wäre schön.", "That would be nice.")
            ])
        ]
    )

    // MARK: B2

    static let passive = CheatSheet(
        id: "passive", level: .b2, label: "werden + Partizip", title: "The passive",
        summary: "werden in position 2, the participle at the end. Add von + dative only if the doer matters.",
        systemImage: "gearshape.2",
        parts: [
            Part(title: "Tenses", rows: [
                row("Die Heizung wird repariert.", "Present"),
                row("Die Heizung wurde repariert.", "Past"),
                row("Die Heizung ist repariert worden.", "Perfect: worden, not geworden"),
                row("Die Heizung muss repariert werden.", "With a modal verb")
            ]),
            Part(title: "The doer", rows: [
                row("… vom Hausmeister repariert.", "von + dative")
            ])
        ]
    )

    static let verbsWithPrepositions = CheatSheet(
        id: "verbs-with-prepositions", level: .b2, label: "warten auf", title: "Verbs with prepositions",
        summary: "Many verbs come with a fixed preposition. Learn them as one piece, with the case.",
        systemImage: "puzzlepiece",
        parts: [
            Part(title: "Common pairs", rows: [
                row("warten auf + Akk", "to wait for"),
                row("sich freuen auf + Akk", "to look forward to"),
                row("sich freuen über + Akk", "to be pleased about"),
                row("denken an + Akk", "to think of"),
                row("teilnehmen an + Dat", "to take part in"),
                row("sich kümmern um + Akk", "to take care of")
            ]),
            Part(title: "Asking and pointing back", rows: [
                row("Worauf wartest du? — Darauf.", "Things: wo- and da-"),
                row("Auf wen wartest du? — Auf ihn.", "People: the preposition + a pronoun")
            ])
        ]
    )

    static let connectors = CheatSheet(
        id: "connectors", level: .b2, label: "weder … noch", title: "Two-part connectors",
        summary: "Pairs that link two ideas in one sentence.",
        systemImage: "point.3.connected.trianglepath.dotted",
        parts: [
            Part(title: "Pairs", rows: [
                row("sowohl … als auch", "both … and"),
                row("weder … noch", "neither … nor"),
                row("entweder … oder", "either … or"),
                row("nicht nur … sondern auch", "not only … but also"),
                row("zwar … aber", "admittedly … but"),
                row("je … desto", "the more … the more")
            ]),
            Part(title: "Example", rows: [
                row("Je früher wir losfahren, desto besser.", "The earlier we leave, the better.")
            ])
        ]
    )

    // MARK: C1

    static let formalStyle = CheatSheet(
        id: "formal-style", level: .c1, label: "die Erhöhung", title: "Formal style",
        summary: "Formal German turns verbs into nouns and links them with the genitive. Typical for news, offices and contracts.",
        systemImage: "doc.text",
        parts: [
            Part(title: "Verb to noun", rows: [
                row("erhöhen → die Erhöhung", "-ung is feminine"),
                row("entscheiden → die Entscheidung", "to decide"),
                row("abfahren → die Abfahrt", "Some change their form")
            ]),
            Part(title: "Clause to phrase", rows: [
                row("nachdem die Mieten erhöht wurden → nach der Erhöhung der Mieten", "nachdem becomes nach + dative"),
                row("weil gestreikt wird → wegen des Streiks", "weil becomes wegen + genitive"),
                row("wenn es regnet → bei Regen", "wenn becomes bei + dative"),
                row("obwohl es regnet → trotz des Regens", "obwohl becomes trotz + genitive")
            ])
        ]
    )

    static let particles = CheatSheet(
        id: "particles", level: .c1, label: "doch · ja · mal", title: "Modal particles",
        summary: "Small words that add a tone: friendlier, surprised or more natural. They don't change the facts.",
        systemImage: "bubble.left.and.text.bubble.right",
        parts: [
            Part(title: "Tone", rows: [
                row("Komm doch mit!", "doch: a friendly push"),
                row("Das ist ja toll!", "ja: surprise, or “as you know”"),
                row("Kannst du mal helfen?", "mal: makes a request softer"),
                row("Was ist denn los?", "denn: real interest in a question"),
                row("Das ist halt so.", "halt: that's just how it is"),
                row("Er ist wohl krank.", "wohl: probably")
            ])
        ]
    )

    static let passiveAlternatives = CheatSheet(
        id: "passive-alternatives", level: .c1, label: "lässt sich", title: "Alternatives to the passive",
        summary: "Other ways to say what can or must be done, without werden.",
        systemImage: "arrow.triangle.branch",
        parts: [
            Part(title: "Can be done", rows: [
                row("Das lässt sich ändern.", "sich lassen + infinitive"),
                row("Das Problem ist lösbar.", "-bar: can be done"),
                row("Der Fehler ist leicht zu finden.", "sein + zu: can be done")
            ]),
            Part(title: "Must be done", rows: [
                row("Der Antrag ist bis Montag einzureichen.", "sein + zu: must be done"),
                row("Die Rechnung ist sofort zu bezahlen.", "Typical for letters and rules")
            ])
        ]
    )
}
