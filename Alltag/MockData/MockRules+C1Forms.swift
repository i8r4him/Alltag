//
//  MockRules+C1Forms.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The C1 rules, part 2: adjective endings after article words, and the
/// passive: without a subject, where it isn't possible, and without werden.
extension MockRules {
    static let c1ArticleWords = GrammarRule(
        id: "c1-artikelwoerter", level: .c1, title: "alle neuen, viele neue: endings after article words",
        place: "Shop window", systemImage: "storefront",
        german: "Alle neuen Kunden bekommen zehn Prozent Rabatt.",
        english: "All new customers get ten per cent off.",
        tiles: [Tile(text: "Alle", role: .key), Tile(text: "neuen", role: .end), Tile(text: "Kunden"),
                Tile(text: "bekommen zehn Prozent Rabatt.")],
        notice: "„alle“ works like „die“, so the adjective takes -en. After „viele“ it would be „viele neue Kunden“.",
        rule: "After alle, beide, keine and sämtliche, the adjective ends in -en, as after die. After viele, einige, "
            + "mehrere, wenige and numbers, it takes the ending die would have: viele neue, vieler neuer.",
        visual: RuleVisual(
            source: Part(systemImage: "person.3.fill", german: "alle neuen Kunden", marked: "neuen", role: "like die"),
            target: Part(systemImage: "person.2.fill", german: "viele neue Kunden", marked: "neue",
                         role: "shows the case itself"),
            sentence: "alle neuen Kunden, viele neue Kunden",
            columns: ["alle …", "viele …"],
            rows: [
                Row(label: "Nominative", cells: ["alle neuen", "viele neue"], marked: [1]),
                Row(label: "Accusative", cells: ["alle neuen", "viele neue"], marked: [1]),
                Row(label: "Dative", cells: ["allen neuen", "vielen neuen"]),
                Row(label: "Genitive", cells: ["aller neuen", "vieler neuer"], marked: [1])
            ],
            isLinked: false
        ),
        exam: [
            .gap(.easy, "Wir haben leider keine ___ Nachrichten.", hint: "neu", options: ["neue", "neuen", "neuer"], answer: 1,
                 why: "In the plural, keine works like die: the adjective takes -en, keine neuen Nachrichten."),
            .gap(.medium, "Mehrere ___ Gäste kamen zu spät, aber alle ___ Gäste blieben bis zum Ende.",
                 prompt: "Fill both gaps.", hint: "wichtig",
                 options: ["wichtigen … wichtige", "wichtige … wichtigen", "wichtigen … wichtigen"], answer: 1,
                 why: "mehrere has no article ending, so the adjective shows the case: mehrere wichtige. "
                    + "alle works like die: alle wichtigen."),
            .build("The prices of many old flats have gone up.",
                   words: ["Die Preise", "vieler", "alten", "alter", "Wohnungen", "sind", "gestiegen"],
                   answers: ["Die Preise vieler alter Wohnungen sind gestiegen"],
                   why: "In the genitive plural, vieler takes the -er die would have (der), and so does the adjective: "
                    + "vieler alter Wohnungen.")
        ]
    )

    static let c1PassiveNoSubject = GrammarRule(
        id: "c1-passiv-ohne-subjekt", level: .c1, title: "Hier wird gelacht: the passive without a subject",
        place: "Sign in the library", systemImage: "books.vertical",
        german: "Hier wird nicht telefoniert.",
        english: "No phone calls here.",
        tiles: [Tile(text: "Hier"), Tile(text: "wird", role: .verb), Tile(text: "nicht"), Tile(text: "telefoniert", role: .end)],
        notice: "There is no subject: nothing „is phoned“. The passive just says what happens, or doesn't, here.",
        rule: "Verbs without an object have a passive too. It has no subject, so werden is always singular (wird), "
            + "and when nothing else takes position 1, „es“ fills it.",
        visual: RuleVisual(
            source: Part(systemImage: "music.note", german: "Hier wird getanzt.", marked: "wird", role: "something in position 1"),
            target: Part(systemImage: "figure.dance", german: "Es wird getanzt.", marked: "Es", role: "nothing else: es"),
            sentence: "Hier wird getanzt. Es wird getanzt.",
            columns: ["position 1", "verb", "rest"],
            rows: [
                Row(label: "a place", cells: ["Hier", "wird", "getanzt."], marked: [1]),
                Row(label: "a time", cells: ["Sonntags", "wird", "nicht gearbeitet."], marked: [1]),
                Row(label: "nothing", cells: ["Es", "wird", "gefeiert."], marked: [0, 1])
            ],
            isLinked: false
        ),
        exam: [
            .gap(.easy, "Am Sonntag ___ in Deutschland nicht gearbeitet.", options: ["werden", "wird", "ist"], answer: 1,
                 why: "There is no subject, so werden stays singular: wird."),
            .gap(.medium, prompt: "Which sentence is right?",
                 options: ["Im Büro wird es viel gelacht.", "Im Büro werden viel gelacht.", "Im Büro wird viel gelacht."],
                 answer: 2,
                 why: "„es“ only fills an empty position 1. Once „Im Büro“ takes it, es disappears, and wird stays singular."),
            .build("Was there dancing at the wedding?", prompt: "Build the question. Two tiles are left over.",
                   words: ["Wurden", "auf der Hochzeit", "es", "Wurde", "getanzt"],
                   answers: ["Wurde auf der Hochzeit getanzt"],
                   why: "A yes/no question starts with the verb, so no es is needed. With no subject, werden stays singular: wurde.")
        ]
    )

    static let c1PassiveLimits = GrammarRule(
        id: "c1-passiv-grenzen", level: .c1, title: "When there is no passive",
        place: "Letter from an office", systemImage: "envelope",
        german: "Der Brief wurde verschickt. Sie haben ihn gestern bekommen.",
        english: "The letter was sent. You received it yesterday.",
        tiles: [Tile(text: "Der Brief"), Tile(text: "wurde", role: .verb), Tile(text: "verschickt.", role: .end),
                Tile(text: "Sie haben ihn gestern"), Tile(text: "bekommen", role: .key)],
        notice: "Sending is something someone does, so it has a passive. Receiving just happens to you: "
            + "„Der Brief wurde bekommen“ is impossible.",
        rule: "Only actions someone does have a passive. Not bekommen, erhalten, haben, besitzen, kennen, wissen, "
            + "kosten or enthalten, not reflexive verbs (sich freuen), and not verbs that take sein (ankommen).",
        visual: RuleVisual(
            source: Part(systemImage: "hammer.fill", german: "Das Haus wird gebaut.", marked: "wird gebaut",
                         role: "an action", name: "passive"),
            target: Part(systemImage: "house.fill", german: "Er hat ein Haus.", role: "a state", name: "no passive"),
            sentence: "Das Haus wird gebaut. Er hat ein Haus: no passive.",
            columns: ["verb", "passive"],
            rows: [
                Row(label: "an action", cells: ["schreiben", "wird geschrieben"], marked: [1]),
                Row(label: "getting, having", cells: ["bekommen, haben", "–"]),
                Row(label: "knowing, costing", cells: ["kennen, kosten", "–"]),
                Row(label: "reflexive", cells: ["sich freuen", "–"]),
                Row(label: "with sein", cells: ["ankommen", "–"])
            ],
            isLinked: false
        ),
        exam: [
            .gap(.easy, prompt: "Which sentence is possible?",
                 options: ["Das Paket wurde gestern bekommen.", "Das Paket wurde gestern geliefert.",
                           "Das Paket wurde gestern angekommen."], answer: 1,
                 why: "Delivering is an action. bekommen is receiving, and ankommen takes sein: neither has a passive."),
            .gap(.medium, "Man kennt den Täter.", prompt: "Say it without „man“.",
                 options: ["Der Täter wird gekannt.", "Den Täter kennt man.", "Der Täter ist bekannt."], answer: 2,
                 why: "kennen is a state, not an action, so it has no passive. German uses sein + adjective instead. "
                    + "„Den Täter kennt man“ is right too, but it still says man."),
            .build("The flat costs 900 euros and was renovated last year.", prompt: "Build the sentence. Two tiles are left over.",
                   words: ["Die Wohnung", "wird", "kostet", "900 Euro", "und", "gekostet", "wurde", "letztes Jahr", "renoviert"],
                   answers: ["Die Wohnung kostet 900 Euro und wurde letztes Jahr renoviert"],
                   why: "kosten is a measure, not an action, so it stays active. Renovating is an action: wurde renoviert.")
        ]
    )

    static let c1PassiveAlternatives = GrammarRule(
        id: "c1-passiv-ersatz", level: .c1, title: "die zu verkaufenden Bücher: passive meaning without werden",
        place: "Second-hand bookshop", systemImage: "books.vertical",
        german: "Die zu verkaufenden Bücher stehen links im Regal.",
        english: "The books for sale are on the shelf on the left.",
        tiles: [Tile(text: "Die"), Tile(text: "zu verkaufenden", role: .key), Tile(text: "Bücher", role: .end),
                Tile(text: "stehen links im Regal.")],
        notice: "„die zu verkaufenden Bücher“ are books that are to be sold. zu + present participle packs "
            + "a passive with a must or a can in front of the noun.",
        rule: "Passive meaning without werden: sein + zu (Das ist zu prüfen: must or can be checked), sich lassen "
            + "(Das lässt sich prüfen), -bar (prüfbar), and zu + present participle before a noun (die zu prüfende Akte).",
        visual: RuleVisual(
            source: Part(systemImage: "doc.text", german: "Das muss geprüft werden.", marked: "geprüft werden",
                         role: "with werden"),
            verb: "=",
            target: Part(systemImage: "doc.text.magnifyingglass", german: "Das ist zu prüfen.", marked: "ist zu",
                         role: "without werden"),
            sentence: "Das muss geprüft werden. Das ist zu prüfen.",
            columns: ["example", "means"],
            rows: [
                Row(label: "sein + zu", cells: ["ist zu prüfen", "must or can be"], marked: [0]),
                Row(label: "sich lassen", cells: ["lässt sich prüfen", "can be"], marked: [0]),
                Row(label: "-bar", cells: ["ist prüfbar", "can be"], marked: [0]),
                Row(label: "zu + participle", cells: ["die zu prüfende\nAkte", "that must be"], marked: [0])
            ]
        ),
        exam: [
            .gap(.easy, "Das Fenster ___ sich nicht öffnen.", options: ["ist", "wird", "lässt"], answer: 2,
                 why: "sich lassen + infinitive means it can be done: the window can't be opened."),
            .gap(.medium, "Die ___ Rechnungen liegen auf dem Tisch. Sie ___ bis Freitag zu bezahlen.", prompt: "Fill both gaps.",
                 options: ["zu bezahlende … müssen", "zu bezahlenden … sind", "bezahlenden … werden"], answer: 1,
                 why: "Before the noun: zu + present participle with the adjective ending, -en after die in the plural. "
                    + "As the verb: sein + zu."),
            .build("This problem can't be solved easily.", prompt: "Build the sentence. Two tiles are left over.",
                   words: ["Dieses Problem", "ist", "lässt sich", "nicht leicht", "gelöst", "lösen"],
                   answers: ["Dieses Problem lässt sich nicht leicht lösen"],
                   why: "sich lassen takes a plain infinitive at the end: lässt sich … lösen. "
                    + "With „ist“ you'd need zu: ist nicht leicht zu lösen.")
        ]
    )
}
