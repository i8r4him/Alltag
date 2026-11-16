//
//  MockRules+A2Words.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The A2 rules, part 6: how German builds words, and what a word's end says about its article.
extension MockRules {
    static let a2Compounds = GrammarRule(
        id: "a2-komposita", level: .a2, title: "Compound nouns: the last word decides",
        place: "At the station", systemImage: "tram",
        german: "Der Fahrkartenautomat ist leider kaputt.",
        english: "The ticket machine is out of order, unfortunately.",
        tiles: [Tile(text: "Der", role: .key), Tile(text: "Fahrkartenautomat", role: .end), Tile(text: "ist leider kaputt.")],
        notice: "die Fahrkarte + der Automat = der Fahrkartenautomat. The last word gives the article.",
        rule: "German joins nouns into one word. The last one says what it is and gives the article; the ones before describe it. "
            + "Sometimes an -s- or -n- joins them: der Arbeitsplatz.",
        visual: RuleVisual(
            source: Part(systemImage: "house.fill", german: "das Haus", role: "what kind?"),
            verb: "+ die Tür",
            target: Part(systemImage: "door.left.hand.closed", german: "die Haustür", marked: "die", role: "what it is"),
            sentence: "das Haus und die Tür: die Haustür",
            columns: ["+", "="],
            rows: [
                Row(label: "das Haus", cells: ["die Tür", "die Haustür"], marked: [1]),
                Row(label: "der Kaffee", cells: ["die Tasse", "die Kaffeetasse"], marked: [1]),
                Row(label: "die Küche", cells: ["der Tisch", "der Küchentisch"], marked: [1]),
                Row(label: "die Arbeit", cells: ["der Platz", "der Arbeitsplatz"], marked: [1])
            ]
        ),
        exam: [
            .gap(.easy, "___ Kinderzimmer ist oben.", hint: "die Kinder + das Zimmer", options: ["Das", "Die", "Der"], answer: 0,
                 why: "The last word gives the article: das Zimmer, so das Kinderzimmer."),
            .gap(.medium, "Ich brauche ___ Fahrkarte und ___ Stadtplan.", prompt: "Fill both gaps.",
                 hint: "die Fahrt + die Karte · die Stadt + der Plan", options: ["eine … einen", "einen … eine", "eine … eine"],
                 answer: 0,
                 why: "Fahrkarte ends in die Karte: eine. Stadtplan ends in der Plan, which takes einen in the accusative."),
            .build("The bus stop is in front of the town hall.", prompt: "Build the sentence. Two tiles are left over.",
                   words: ["dem", "Bushaltestelle", "Der", "ist", "Rathaus", "vor", "der", "Die"],
                   answers: ["Die Bushaltestelle ist vor dem Rathaus"],
                   why: "die Haltestelle makes die Bushaltestelle, and das Haus makes das Rathaus: vor dem Rathaus, Wo?, dative.")
        ]
    )

    static let a2Endings = GrammarRule(
        id: "a2-endungen", level: .a2, title: "-ung, -chen, -in: endings that tell the article",
        place: "In the German course", systemImage: "graduationcap",
        german: "Die Lehrerin erklärt die Übung noch einmal.",
        english: "The teacher explains the exercise once more.",
        tiles: [Tile(text: "Die", role: .key), Tile(text: "Lehrerin", role: .end), Tile(text: "erklärt"),
                Tile(text: "die", role: .key), Tile(text: "Übung", role: .end), Tile(text: "noch einmal.")],
        notice: "Both endings give the article away: -in is a woman, so die. And -ung is always die.",
        rule: "Some endings tell you the article. die: -ung, -heit, -keit, -ion and -in for a woman. "
            + "das: -chen for something small, and a verb used as a noun (das Essen). der: -er for a person who does something.",
        visual: RuleVisual(
            source: Part(systemImage: "person.fill", german: "der Lehrer", marked: "der", role: "a man who teaches"),
            verb: "+ -in",
            target: Part(systemImage: "person.fill", german: "die Lehrerin", marked: "die", role: "a woman who teaches"),
            sentence: "der Lehrer, die Lehrerin",
            columns: ["endings", "example"],
            rows: [
                Row(label: "die", cells: ["-ung · -heit · -keit · -ion · -in", "die Zeitung"], marked: [0]),
                Row(label: "das", cells: ["-chen · a verb as a noun", "das Brötchen"], marked: [0]),
                Row(label: "der", cells: ["-er for a person", "der Fahrer"], marked: [0])
            ]
        ),
        exam: [
            .gap(.easy, "___ Zeitung liegt auf dem Tisch.", options: ["Die", "Der", "Das"], answer: 0,
                 why: "-ung is always die: die Zeitung."),
            .gap(.medium, "___ Mädchen fragt ___ Verkäuferin.", prompt: "Fill both gaps.",
                 options: ["Das … die", "Die … die", "Das … der"], answer: 0,
                 why: "-chen is always das, even for a girl: das Mädchen. -in is a woman, die, and die stays die in the accusative."),
            .build("The little house has heating.", prompt: "Build the sentence. Two tiles are left over.",
                   words: ["Heizung", "Die", "eine", "hat", "Häuschen", "einen", "Das"],
                   answers: ["Das Häuschen hat eine Heizung"],
                   why: "-chen makes a thing small and always takes das: das Häuschen. -ung is always die, so eine Heizung.")
        ]
    )
}
