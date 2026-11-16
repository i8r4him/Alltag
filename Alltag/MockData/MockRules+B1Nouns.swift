//
//  MockRules+B1Nouns.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The B1 rules, part 6: the genitive, prepositions of time and nouns that
/// add -n.
extension MockRules {
    static let b1Genitive = GrammarRule(
        id: "b1-genitiv", level: .b1, title: "The genitive: des Vaters, der Mutter",
        place: "Letter from an office", systemImage: "envelope",
        german: "Bitte geben Sie die Nummer des Vertrags an.",
        english: "Please give the number of the contract.",
        tiles: [Tile(text: "Bitte geben Sie die Nummer"), Tile(text: "des", role: .key), Tile(text: "Vertrags", role: .end),
                Tile(text: "an.")],
        notice: "„des Vertrags“: the number belongs to the contract. Masculine and neuter nouns add -s or -es.",
        rule: "The genitive says whose or of what: des for masculine and neuter, with -s or -es on the noun, "
            + "and der for feminine and plural. In speech, von + dative often takes its place.",
        visual: RuleVisual(
            source: Part(systemImage: "car.fill", german: "das Auto", role: "What?"),
            target: Part(systemImage: "figure.stand", german: "des Vaters", marked: "des Vaters", role: "Whose?",
                         name: "Genitive"),
            sentence: "das Auto des Vaters",
            columns: ["masc.", "fem.", "neut.", "plural"],
            rows: [
                Row(label: "Who does it?", cells: ["der\nMann", "die\nFrau", "das\nKind", "die\nLeute"]),
                Row(label: "Whose?", cells: ["des\nMannes", "der\nFrau", "des\nKindes", "der\nLeute"], marked: [0, 1, 2, 3])
            ]
        ),
        exam: [
            .gap(.easy, "Das ist das Auto ___ Nachbarin.", hint: "die Nachbarin", options: ["der", "des", "die"], answer: 0,
                 why: "Feminine nouns take der in the genitive: der Nachbarin."),
            .gap(.medium, "Am Ende ___ ___ gibt es ein Fest.", prompt: "Fill both gaps.", hint: "der Monat",
                 options: ["des … Monats", "der … Monat", "des … Monat"], answer: 0,
                 why: "Masculine takes des, and the noun adds -s as well: des Monats."),
            .build("The name of the street is long.", prompt: "Build the sentence. Two tiles are left over.",
                   words: ["lang", "des Straßes", "Der Name", "die Straße", "ist", "der Straße"],
                   answers: ["Der Name der Straße ist lang"],
                   why: "die Straße is feminine, so its genitive is der Straße, with no ending on the noun.")
        ]
    )

    static let b1GenitivePrepositions = GrammarRule(
        id: "b1-genitiv-praepositionen", level: .b1, title: "wegen, trotz, innerhalb, außerhalb",
        place: "Station announcement", systemImage: "tram",
        german: "Wegen eines Unfalls hat der Zug zwanzig Minuten Verspätung.",
        english: "Because of an accident, the train is twenty minutes late.",
        tiles: [Tile(text: "Wegen", role: .key), Tile(text: "eines Unfalls", role: .end), Tile(text: "hat", role: .verb),
                Tile(text: "der Zug zwanzig Minuten Verspätung.")],
        notice: "„wegen“ takes the genitive: „ein Unfall“ becomes „eines Unfalls“.",
        rule: "wegen, trotz, während, innerhalb and außerhalb take the genitive. "
            + "In speech you will often hear wegen and trotz with the dative.",
        visual: RuleVisual(
            source: Part(systemImage: "cloud.rain.fill", german: "trotz des Regens", marked: "des Regens", role: "it rains"),
            target: Part(systemImage: "figure.walk", german: "gehen wir spazieren", role: "we go anyway"),
            sentence: "Trotz des Regens gehen wir spazieren.",
            columns: ["masc.", "fem.", "plural"],
            rows: [
                Row(label: "wegen", cells: ["des Streiks", "der Baustelle", "der Preise"], marked: [0]),
                Row(label: "trotz", cells: ["des Regens", "der Kälte", "der Kosten"], marked: [0]),
                Row(label: "innerhalb", cells: ["eines Monats", "einer Woche", "der Ferien"], marked: [0]),
                Row(label: "außerhalb", cells: ["des Ortes", "der Stadt", "der Geschäftszeiten"], marked: [0])
            ]
        ),
        exam: [
            .gap(.easy, "Wegen ___ Streiks fällt der Unterricht aus.", hint: "der Streik", options: ["des", "dem", "der"], answer: 0,
                 why: "wegen takes the genitive. der Streik is masculine: des Streiks."),
            .gap(.medium, "Trotz ___ Kälte gehen wir ___ der Stadt spazieren.", prompt: "Fill both gaps.",
                 hint: "die Kälte · outside the town", options: ["der … außerhalb", "die … außerhalb", "der … innerhalb"],
                 answer: 0, why: "trotz takes the genitive: die Kälte becomes der Kälte. Outside the town is außerhalb, "
                     + "also with the genitive."),
            .build("Despite the rain, the match takes place.", prompt: "Build the sentence. Two tiles are left over.",
                   words: ["das Spiel", "dem Regen", "statt", "Trotz", "findet", "Wegen", "des Regens"],
                   answers: ["Trotz des Regens findet das Spiel statt"],
                   why: "trotz takes the genitive: des Regens. It fills position 1, so the verb comes next: findet das Spiel statt.")
        ]
    )

    static let b1TimePrepositions = GrammarRule(
        id: "b1-zeitpraepositionen", level: .b1, title: "vor, nach, seit, ab, bis: time",
        place: "Sign on a shop door", systemImage: "storefront",
        german: "Ab Montag haben wir bis 19 Uhr geöffnet.",
        english: "From Monday we're open until 7 pm.",
        tiles: [Tile(text: "Ab", role: .key), Tile(text: "Montag"), Tile(text: "haben", role: .verb), Tile(text: "wir"),
                Tile(text: "bis", role: .key), Tile(text: "19 Uhr geöffnet.")],
        notice: "„ab“ is where it starts, „bis“ where it ends. Neither needs an article here.",
        rule: "vor, nach and seit take the dative: vor einer Woche, nach dem Essen. ab and bis say where a time starts "
            + "and ends, and für takes the accusative: für eine Woche.",
        visual: RuleVisual(
            source: Part(systemImage: "calendar", german: "ab Montag", marked: "ab", role: "it starts"),
            target: Part(systemImage: "calendar.badge.clock", german: "bis Freitag", marked: "bis", role: "it ends"),
            sentence: "ab Montag bis Freitag",
            columns: ["means", "for example"],
            rows: [
                Row(label: "vor", cells: ["ago · before", "vor einem Jahr"], marked: [1]),
                Row(label: "nach", cells: ["after", "nach dem Essen"], marked: [1]),
                Row(label: "seit", cells: ["since, still now", "seit einer Woche"], marked: [1]),
                Row(label: "ab", cells: ["from … on", "ab nächster Woche"]),
                Row(label: "für", cells: ["a planned stretch", "für zwei Wochen"])
            ]
        ),
        exam: [
            .gap(.easy, "Ich habe ihn ___ zwei Jahren kennengelernt.", options: ["vor", "seit", "für"], answer: 0,
                 why: "Two years ago, and it's over: vor + dative. seit would mean it is still going on."),
            .gap(.medium, "Wir wohnen hier ___ ___ Jahr.", prompt: "Fill both gaps.", hint: "das Jahr · still true",
                 options: ["seit … einem", "vor … einem", "seit … ein"], answer: 0,
                 why: "Still true now: seit, and seit takes the dative: seit einem Jahr."),
            .build("After work I'm going shopping until 8 pm.", prompt: "Build the sentence. Two tiles are left over.",
                   words: ["einkaufen", "Vor", "der Arbeit", "gehe", "Nach", "bis 20 Uhr", "die Arbeit", "ich"],
                   answers: ["Nach der Arbeit gehe ich bis 20 Uhr einkaufen"],
                   why: "nach takes the dative: nach der Arbeit. It fills position 1, so the verb comes next: gehe ich.")
        ]
    )

    static let b1NDeclension = GrammarRule(
        id: "b1-n-deklination", level: .b1, title: "Nouns that add -n: den Kollegen",
        place: "A colleague at work", systemImage: "briefcase",
        german: "Hast du den neuen Kollegen schon kennengelernt?",
        english: "Have you met the new colleague yet?",
        tiles: [Tile(text: "Hast du"), Tile(text: "den neuen"), Tile(text: "Kollegen", role: .end), Tile(text: "schon kennengelernt?")],
        notice: "It's „der Kollege“, but here he is the object: „den Kollegen“, with -n on the noun too.",
        rule: "Some masculine nouns, mostly people and animals ending in -e, and a few like Student, Mensch "
            + "and Herr, add -n or -en in every case but the nominative.",
        visual: RuleVisual(
            source: Part(systemImage: "person.fill", german: "der Kollege", role: "Who does it?", name: "Nominative"),
            verb: "ich frage",
            target: Part(systemImage: "person.fill", german: "den Kollegen", marked: "en", role: "Whom?", name: "Accusative"),
            sentence: "der Kollege. Ich frage den Kollegen.",
            columns: ["Nom.", "Akk.", "Dat.", "Gen."],
            rows: [
                Row(label: "der Kollege", cells: ["Kollege", "Kollegen", "Kollegen", "Kollegen"], marked: [1, 2, 3]),
                Row(label: "der Student", cells: ["Student", "Studenten", "Studenten", "Studenten"], marked: [1, 2, 3]),
                Row(label: "der Mensch", cells: ["Mensch", "Menschen", "Menschen", "Menschen"], marked: [1, 2, 3]),
                Row(label: "der Herr", cells: ["Herr", "Herrn", "Herrn", "Herrn"], marked: [1, 2, 3])
            ]
        ),
        exam: [
            .gap(.easy, "Ich habe gestern einen ___ getroffen.", hint: "der Student",
                 options: ["Studenten", "Student", "Studente"], answer: 0,
                 why: "Student is one of these nouns: as an object it adds -en, einen Studenten."),
            .gap(.medium, "Kannst du ___ ___ helfen?", prompt: "Fill both gaps.", hint: "der Nachbar",
                 options: ["dem … Nachbarn", "dem … Nachbar", "den … Nachbarn"], answer: 0,
                 why: "helfen takes the dative: dem. Nachbar adds -n in every case but the nominative: dem Nachbarn."),
            .build("I'm writing Mr Schmidt a letter.", prompt: "Build the sentence. Two tiles are left over.",
                   words: ["einen Brief", "Herr Schmidt", "Ich schreibe", "einem Brief", "Herrn Schmidt"],
                   answers: ["Ich schreibe Herrn Schmidt einen Brief"],
                   why: "Mr Schmidt gets the letter, so he is in the dative, and Herr becomes Herrn. "
                       + "The letter is what you write: einen Brief.")
        ]
    )
}
