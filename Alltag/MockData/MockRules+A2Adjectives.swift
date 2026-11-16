//
//  MockRules+A2Adjectives.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The A2 rules, part 5: adjective endings and comparing.
extension MockRules {
    static let a2AdjectiveDer = GrammarRule(
        id: "a2-adjektiv-der", level: .a2, title: "der neue, den neuen: adjectives after der",
        place: "In a clothes shop", systemImage: "tshirt",
        german: "Ich nehme den schwarzen Pullover, nicht den grauen.",
        english: "I'll take the black jumper, not the grey one.",
        tiles: [Tile(text: "Ich nehme"), Tile(text: "den", role: .key), Tile(text: "schwarzen", role: .end),
                Tile(text: "Pullover, nicht"), Tile(text: "den", role: .key), Tile(text: "grauen.", role: .end)],
        notice: "After der, die, das the adjective only takes -e or -en. „den“ is the accusative, so -en: den schwarzen Pullover.",
        rule: "After der, die and das the article shows the case, so the adjective only takes -e or -en: "
            + "-e for one thing in the nominative, and for die and das in the accusative. Everywhere else -en.",
        visual: RuleVisual(
            source: Part(systemImage: "tshirt.fill", german: "der schwarze Pullover", marked: "schwarze",
                         role: "Who? What?", name: "Nominative"),
            target: Part(systemImage: "bag.fill", german: "den schwarzen Pullover", marked: "schwarzen",
                         role: "What?", name: "Accusative"),
            sentence: "Der schwarze Pullover. Ich nehme den schwarzen Pullover.",
            columns: ["masc.", "fem.", "neut.", "plural"],
            rows: [
                Row(label: "Nom.", cells: ["der neue", "die neue", "das neue", "die neuen"], marked: [3]),
                Row(label: "Akk.", cells: ["den neuen", "die neue", "das neue", "die neuen"], marked: [0, 3]),
                Row(label: "Dat.", cells: ["dem neuen", "der neuen", "dem neuen", "den neuen"], marked: [0, 1, 2, 3])
            ]
        ),
        exam: [
            .gap(.easy, "Der ___ Kollege heißt Max.", hint: "neu", options: ["neue", "neuen", "neuer"], answer: 0,
                 why: "One person in the nominative after der: -e, der neue Kollege."),
            .gap(.medium, "Ich wohne in dem ___ Haus neben der ___ Kirche.", prompt: "Fill both gaps.", hint: "alt · groß",
                 options: ["alten … großen", "alte … große", "alten … große"], answer: 0,
                 why: "Both are in the dative after the article, and the dative always takes -en."),
            .build("Do you see the red car?", prompt: "Build the question. One tile is left over.",
                   words: ["rote", "das", "Siehst", "roten", "Auto", "du"],
                   answers: ["Siehst du das rote Auto"],
                   why: "das Auto stays das in the accusative, so the adjective takes -e: das rote Auto.")
        ]
    )

    static let a2AdjectiveEin = GrammarRule(
        id: "a2-adjektiv-ein", level: .a2, title: "ein neuer, ein neues: adjectives after ein",
        place: "A flat advert", systemImage: "house",
        german: "Die Wohnung hat eine große Küche und einen kleinen Balkon.",
        english: "The flat has a big kitchen and a small balcony.",
        tiles: [Tile(text: "Die Wohnung hat eine"), Tile(text: "große", role: .end), Tile(text: "Küche und"),
                Tile(text: "einen", role: .key), Tile(text: "kleinen", role: .end), Tile(text: "Balkon.")],
        notice: "„einen“ already shows the accusative, so the adjective takes -en. After „eine“ it takes -e.",
        rule: "Where ein has no ending, the adjective shows the article: ein neuer Laptop (der), ein neues Handy (das). "
            + "After eine it takes -e, after einen and in the dative -en.",
        visual: RuleVisual(
            source: Part(systemImage: "laptopcomputer", german: "der neue Laptop", marked: "der", role: "the article shows it"),
            target: Part(systemImage: "laptopcomputer", german: "ein neuer Laptop", marked: "neuer", role: "the adjective shows it"),
            sentence: "der neue Laptop, ein neuer Laptop",
            columns: ["masc.", "fem.", "neut."],
            rows: [
                Row(label: "Nom.", cells: ["ein neuer", "eine neue", "ein neues"], marked: [0, 2]),
                Row(label: "Akk.", cells: ["einen neuen", "eine neue", "ein neues"], marked: [2]),
                Row(label: "Dat.", cells: ["einem neuen", "einer neuen", "einem neuen"])
            ],
            isLinked: false
        ),
        exam: [
            .gap(.easy, "Das ist ein ___ Problem.", hint: "das Problem · groß", options: ["großes", "große", "großer"], answer: 0,
                 why: "ein has no ending here, so the adjective shows das: ein großes Problem."),
            .gap(.medium, "Ich suche einen ___ Job in einem ___ Team.", prompt: "Fill both gaps.", hint: "neu · nett",
                 options: ["neuen … netten", "neuer … nettem", "neuen … nettes"], answer: 0,
                 why: "einen is the accusative of der: -en. After einem, in the dative, it is always -en."),
            .build("I have a new boss and a nice colleague.",
                   words: ["eine", "neuer", "Chef", "Ich", "nette", "einen", "Kollegin", "habe", "und", "neuen"],
                   answers: ["Ich habe einen neuen Chef und eine nette Kollegin"],
                   why: "der Chef in the accusative: einen neuen Chef. die Kollegin keeps -e: eine nette Kollegin.")
        ]
    )

    static let a2Comparative = GrammarRule(
        id: "a2-komparativ", level: .a2, title: "schneller als, am schnellsten: comparing",
        place: "Railway app", systemImage: "tram",
        german: "Der ICE ist schneller als der Regionalzug, aber teurer.",
        english: "The ICE is faster than the regional train, but more expensive.",
        tiles: [Tile(text: "Der ICE ist"), Tile(text: "schneller", role: .end), Tile(text: "als", role: .key),
                Tile(text: "der Regionalzug, aber"), Tile(text: "teurer.", role: .end)],
        notice: "Add -er to compare, and „als“ means than. „teuer“ drops an e: teurer.",
        rule: "More: -er + als (schneller als). The same: so … wie (so schnell wie). The most: am …-sten (am schnellsten). "
            + "Short words often take an umlaut: alt, älter, am ältesten.",
        visual: RuleVisual(
            source: Part(systemImage: "bicycle", german: "schnell", role: "fast"),
            target: Part(systemImage: "car.fill", german: "schneller", marked: "er", role: "faster"),
            sentence: "Das Auto ist schneller als das Fahrrad.",
            columns: ["more", "the most"],
            rows: [
                Row(label: "schnell", cells: ["schneller", "am schnellsten"]),
                Row(label: "alt", cells: ["älter", "am ältesten"]),
                Row(label: "groß", cells: ["größer", "am größten"]),
                Row(label: "gut", cells: ["besser", "am besten"], marked: [0, 1]),
                Row(label: "gern", cells: ["lieber", "am liebsten"], marked: [0, 1]),
                Row(label: "viel", cells: ["mehr", "am meisten"], marked: [0, 1])
            ]
        ),
        exam: [
            .gap(.easy, "Berlin ist größer ___ München.", options: ["als", "wie", "dann"], answer: 0,
                 why: "After the -er form, than is als: größer als."),
            .gap(.medium, "Ich trinke ___ Tee als Kaffee, aber Wasser trinke ich am ___.", prompt: "Fill both gaps.", hint: "gern",
                 options: ["lieber … liebsten", "gerner … gernsten", "lieber … meisten"], answer: 0,
                 why: "gern doesn't follow the pattern: gern, lieber, am liebsten."),
            .build("My brother is as tall as me, but older.",
                   words: ["wie", "älter", "so", "Mein Bruder", "aber", "als", "groß", "ich,", "ist"],
                   answers: ["Mein Bruder ist so groß wie ich, aber älter"],
                   why: "The same takes so … wie: so groß wie ich. alt takes an umlaut: älter.")
        ]
    )
}
