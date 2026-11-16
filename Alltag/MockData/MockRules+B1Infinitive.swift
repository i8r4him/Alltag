//
//  MockRules+B1Infinitive.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The B1 rules, part 4: a second verb at the end, with or without zu.
extension MockRules {
    static let b1ZuInfinitive = GrammarRule(
        id: "b1-zu-infinitiv", level: .b1, title: "The infinitive with zu",
        place: "Email from work", systemImage: "at",
        german: "Ich habe vergessen, Ihnen die Datei zu schicken.",
        english: "I forgot to send you the file.",
        tiles: [Tile(text: "Ich habe vergessen,"), Tile(text: "Ihnen die Datei"), Tile(text: "zu", role: .key),
                Tile(text: "schicken.", role: .end)],
        notice: "After „vergessen“ the second verb goes to the end with „zu“.",
        rule: "After many verbs and phrases, like vergessen, versuchen, anfangen, Lust haben and es ist wichtig, "
            + "the second verb goes to the end with zu. In a separable verb, zu goes in the middle: anzurufen.",
        visual: RuleVisual(
            source: Part(systemImage: "figure.walk", german: "Ich versuche,", role: "the first verb"),
            target: Part(systemImage: "arrow.right.to.line", german: "pünktlich zu sein", marked: "zu sein",
                         role: "the end: zu + infinitive"),
            sentence: "Ich versuche, pünktlich zu sein.",
            columns: ["with zu"],
            rows: [
                Row(label: "machen", cells: ["zu machen"]),
                Row(label: "sein", cells: ["zu sein"]),
                Row(label: "anrufen", cells: ["anzurufen"], marked: [0]),
                Row(label: "aufstehen", cells: ["aufzustehen"], marked: [0])
            ]
        ),
        exam: [
            .gap(.easy, "Ich habe keine Lust, heute ___.", hint: "kochen", options: ["zu kochen", "kochen", "zu koche"], answer: 0,
                 why: "After „Lust haben“ the verb goes to the end with zu: zu kochen."),
            .gap(.medium, "Vergiss nicht, deine Mutter ___!", hint: "anrufen", options: ["anzurufen", "zu anrufen", "anrufen zu"],
                 answer: 0, why: "anrufen is separable, so zu goes in the middle: anzurufen."),
            .build("It's important to get up early every day.", prompt: "Build the sentence. Two tiles are left over.",
                   words: ["früh", "aufstehen", "Es ist", "jeden Tag", "zu aufstehen", "wichtig,", "aufzustehen"],
                   answers: ["Es ist wichtig, jeden Tag früh aufzustehen"],
                   why: "„Es ist wichtig“ takes zu, and in aufstehen zu goes between the prefix and the verb: aufzustehen.")
        ]
    )

    static let b1BareInfinitive = GrammarRule(
        id: "b1-ohne-zu", level: .b1, title: "No zu: Wir gehen schwimmen",
        place: "Planning the weekend", systemImage: "calendar",
        german: "Am Samstag gehen wir schwimmen. Kommst du mit?",
        english: "On Saturday we're going swimming. Are you coming?",
        tiles: [Tile(text: "Am Samstag"), Tile(text: "gehen", role: .verb), Tile(text: "wir"), Tile(text: "schwimmen.", role: .end),
                Tile(text: "Kommst du mit?")],
        notice: "No zu after „gehen“: „wir gehen schwimmen“, just like „wir können schwimmen“.",
        rule: "After the modal verbs, werden and lassen, and after gehen, bleiben, hören, sehen and lernen, "
            + "the second verb goes to the end without zu.",
        visual: RuleVisual(
            source: Part(systemImage: "figure.walk", german: "Wir gehen", role: "the first verb"),
            target: Part(systemImage: "figure.pool.swim", german: "schwimmen", marked: "schwimmen", role: "no zu"),
            sentence: "Wir gehen schwimmen.",
            columns: ["for example"],
            rows: [
                Row(label: "modal verbs", cells: ["Ich muss arbeiten."]),
                Row(label: "gehen", cells: ["Wir gehen essen."], marked: [0]),
                Row(label: "bleiben", cells: ["Er bleibt sitzen."], marked: [0]),
                Row(label: "hören · sehen", cells: ["Ich höre ihn singen."], marked: [0]),
                Row(label: "lernen", cells: ["Sie lernt schwimmen."], marked: [0])
            ]
        ),
        exam: [
            .gap(.easy, "Heute Abend gehen wir ___.", hint: "essen", options: ["essen", "zu essen", "gegessen"], answer: 0,
                 why: "After gehen the second verb has no zu: wir gehen essen."),
            .gap(.medium, "Ich habe vergessen, Brot ___, also gehe ich jetzt ___.", prompt: "Fill both gaps.",
                 hint: "kaufen · einkaufen", options: ["zu kaufen … einkaufen", "kaufen … einzukaufen", "zu kaufen … einzukaufen"],
                 answer: 0, why: "vergessen takes zu: zu kaufen. gehen doesn't: ich gehe einkaufen."),
            .build("I hear the neighbours singing every evening.", prompt: "Build the sentence. Two tiles are left over.",
                   words: ["singt", "die Nachbarn", "Ich höre", "zu singen", "jeden Abend", "singen"],
                   answers: ["Ich höre die Nachbarn jeden Abend singen"],
                   why: "After hören the second verb goes to the end as a plain infinitive, without zu: singen.")
        ]
    )

    static let b1Purpose = GrammarRule(
        id: "b1-um-zu-damit", level: .b1, title: "um … zu or damit",
        place: "At the language school", systemImage: "graduationcap",
        german: "Ich lerne Deutsch, um in Deutschland zu arbeiten.",
        english: "I'm learning German so that I can work in Germany.",
        tiles: [Tile(text: "Ich lerne Deutsch,"), Tile(text: "um", role: .key), Tile(text: "in Deutschland"),
                Tile(text: "zu arbeiten.", role: .end)],
        notice: "The one who learns is the one who will work, so it's „um … zu“, with no second subject.",
        rule: "For a goal, use um … zu when both parts have the same subject. "
            + "With a different subject, use damit and a clause with the verb at the end.",
        visual: RuleVisual(
            source: Part(systemImage: "person.fill", german: "um … zu", marked: "um", role: "the same person"),
            target: Part(systemImage: "person.2.fill", german: "damit", marked: "damit", role: "another person"),
            sentence: "The same person: um … zu. Another person: damit.",
            columns: ["for example"],
            rows: [
                Row(label: "um … zu", cells: ["Ich spare, um ein Auto\nzu kaufen."], marked: [0]),
                Row(label: "damit", cells: ["Ich spare, damit mein Sohn\nstudieren kann."])
            ],
            isLinked: false
        ),
        exam: [
            .gap(.easy, "Ich gehe zur Bank, ___ Geld zu holen.", options: ["um", "damit", "für"], answer: 0,
                 why: "The same person, and zu at the end: um … zu."),
            .gap(.medium, "Ich spreche langsam, ___ du mich ___.", prompt: "Fill both gaps.", hint: "verstehen",
                 options: ["damit … verstehst", "um … zu verstehen", "damit … verstehen"], answer: 0,
                 why: "I speak, but you understand: two different people, so damit, with the verb at the end: verstehst."),
            .build("We're saving to buy a flat.", prompt: "Build the sentence. Two tiles are left over.",
                   words: ["zu kaufen", "damit", "Wir sparen,", "eine Wohnung", "kaufen", "um"],
                   answers: ["Wir sparen, um eine Wohnung zu kaufen"],
                   why: "We save and we buy: the same people, so um … zu, with zu kaufen at the end.")
        ]
    )

    static let b1Lassen = GrammarRule(
        id: "b1-lassen", level: .b1, title: "lassen: having something done",
        place: "At the hairdresser's", systemImage: "scissors",
        german: "Ich lasse mir morgen die Haare schneiden.",
        english: "I'm getting my hair cut tomorrow.",
        tiles: [Tile(text: "Ich"), Tile(text: "lasse", role: .verb), Tile(text: "mir morgen die Haare"),
                Tile(text: "schneiden.", role: .end)],
        notice: "You don't cut your hair yourself, someone else does. The action goes to the end, without zu.",
        rule: "lassen + infinitive says that someone else does it for you, or that you let it happen: "
            + "Ich lasse das Auto reparieren. Lass mich helfen!",
        visual: RuleVisual(
            source: Part(systemImage: "person.fill", german: "Ich lasse", marked: "lasse", role: "I have it done"),
            target: Part(systemImage: "wrench.and.screwdriver.fill", german: "das Auto reparieren", marked: "reparieren",
                         role: "someone else does it"),
            sentence: "Ich lasse das Auto reparieren.",
            columns: ["now", "simple past"],
            rows: [
                Row(label: "ich", cells: ["lasse", "ließ"]),
                Row(label: "du", cells: ["lässt", "ließt"], marked: [0]),
                Row(label: "er · sie · es", cells: ["lässt", "ließ"], marked: [0]),
                Row(label: "wir · sie", cells: ["lassen", "ließen"])
            ]
        ),
        exam: [
            .gap(.easy, "Er ___ sein Fahrrad reparieren.", options: ["lässt", "lasst", "lasse"], answer: 0,
                 why: "With er the a of lassen becomes ä: er lässt."),
            .gap(.medium, "Wir ___ die Wohnung ___.", prompt: "Fill both gaps.", hint: "streichen: to paint",
                 options: ["lassen … streichen", "lassen … zu streichen", "lässt … streichen"], answer: 0,
                 why: "wir takes lassen, and the action goes to the end without zu: streichen."),
            .build("I'm having my car repaired tomorrow.", prompt: "Build the sentence. Two tiles are left over.",
                   words: ["reparieren", "mein Auto", "Ich", "repariert", "morgen", "zu", "lasse"],
                   answers: ["Ich lasse morgen mein Auto reparieren", "Ich lasse mein Auto morgen reparieren"],
                   why: "lassen takes position 2, and the action goes to the end as a plain infinitive, without zu: reparieren.")
        ]
    )
}
