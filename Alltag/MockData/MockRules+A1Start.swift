//
//  MockRules+A1Start.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The A1 rules, part 1: the people, the first verbs and the place of the
/// verb. Every A1 rule has the same shape: one line of rule, a picture with a
/// tiny table, and an exam of three questions. Written for the app.
extension MockRules {
    static let pronouns = GrammarRule(
        id: "pronomen", level: .a1, title: "ich, du, er, sie: personal pronouns",
        place: "Meeting a neighbour", systemImage: "hand.wave",
        german: "Ich bin Tom, und das ist Lena. Sie kommt aus Wien.",
        english: "I'm Tom, and this is Lena. She comes from Vienna.",
        tiles: [Tile(text: "Ich", role: .key), Tile(text: "bin Tom."), Tile(text: "Sie", role: .key),
                Tile(text: "kommt aus Wien.")],
        notice: "„Ich“ is the speaker. „Sie“ stands for Lena, so her name isn't said twice.",
        rule: "A pronoun stands for a person or a thing: ich, du, er, sie, es for one, and wir, ihr, sie for several. "
            + "„Sie“ with a capital S is the polite you.",
        visual: RuleVisual(
            source: Part(systemImage: "person.fill", german: "ich", role: "one person"),
            target: Part(systemImage: "person.3.fill", german: "wir", role: "several people"),
            sentence: "ich, wir",
            columns: ["one", "several"],
            rows: [
                Row(label: "the speaker", cells: ["ich", "wir"]),
                Row(label: "spoken to", cells: ["du", "ihr"]),
                Row(label: "spoken about", cells: ["er · sie · es", "sie"]),
                Row(label: "polite", cells: ["Sie", "Sie"], marked: [0, 1])
            ],
            isLinked: false
        ),
        exam: [
            .gap(.easy, "___ heiße Anna.", options: ["Ich", "Du", "Er"], answer: 0,
                 why: "„heiße“ is the form for the speaker: ich heiße."),
            .gap(.medium, "Das ist meine Lampe. ___ ist neu.", hint: "die Lampe", options: ["Es", "Sie", "Er"], answer: 1,
                 why: "A thing takes the pronoun of its article, not „es“: die Lampe → sie."),
            .build("The table is new and it is big.",
                   words: ["er", "ist", "Der Tisch", "neu", "und", "ist", "es", "groß"],
                   answers: ["Der Tisch ist neu und er ist groß"],
                   why: "It is „der Tisch“, so the pronoun is „er“. „es“ is only for das-nouns.")
        ]
    )

    static let seinHaben = GrammarRule(
        id: "sein-haben", level: .a1, title: "sein, haben and möchte",
        place: "At a party", systemImage: "party.popper",
        german: "Ich bin Sara. Ich habe Durst und möchte ein Wasser.",
        english: "I'm Sara. I'm thirsty and would like a water.",
        tiles: [Tile(text: "Ich"), Tile(text: "bin", role: .verb), Tile(text: "Sara."), Tile(text: "Ich"),
                Tile(text: "habe", role: .verb), Tile(text: "Durst und"), Tile(text: "möchte", role: .verb),
                Tile(text: "ein Wasser.")],
        notice: "German says „Ich habe Durst“: you have thirst, you are not thirsty.",
        rule: "sein says who or what someone is, haben says what someone has, and möchte says what someone would like. "
            + "All three are irregular, so their forms have to be learnt.",
        visual: RuleVisual(
            source: Part(systemImage: "person.fill", german: "ich bin", marked: "bin", role: "who I am"),
            target: Part(systemImage: "bag.fill", german: "ich habe", marked: "habe", role: "what I have"),
            sentence: "ich bin, ich habe",
            columns: ["sein", "haben", "möchte"],
            rows: [
                Row(label: "ich", cells: ["bin", "habe", "möchte"]),
                Row(label: "du", cells: ["bist", "hast", "möchtest"]),
                Row(label: "er · sie · es", cells: ["ist", "hat", "möchte"]),
                Row(label: "wir", cells: ["sind", "haben", "möchten"]),
                Row(label: "ihr", cells: ["seid", "habt", "möchtet"]),
                Row(label: "sie · Sie", cells: ["sind", "haben", "möchten"])
            ],
            isLinked: false
        ),
        exam: [
            .gap(.easy, "Wir ___ aus Syrien.", options: ["sind", "seid", "bist"], answer: 0,
                 why: "wir sind. „seid“ goes with ihr and „bist“ with du."),
            .gap(.medium, "Ich ___ 24 Jahre alt und ___ zwei Brüder.", prompt: "Fill both gaps.",
                 options: ["habe … bin", "bin … habe", "bin … bin"], answer: 1,
                 why: "Age uses sein in German: ich bin 24 Jahre alt. Brothers are something you have: ich habe."),
            .build("We are hungry and would like two pizzas.",
                   words: ["möchten", "Hunger", "Wir", "sind", "und", "haben", "zwei Pizzas"],
                   answers: ["Wir haben Hunger und möchten zwei Pizzas"],
                   why: "Hunger is something you have: wir haben Hunger. And wir takes „möchten“.")
        ]
    )

    static let presentTense = GrammarRule(
        id: "praesens", level: .a1, title: "Present tense: the ending follows the person",
        place: "In the German course", systemImage: "graduationcap",
        german: "Ich wohne in Köln, und Marta wohnt in Bonn.",
        english: "I live in Cologne, and Marta lives in Bonn.",
        tiles: [Tile(text: "Ich"), Tile(text: "wohne", role: .verb), Tile(text: "in Köln, und Marta"),
                Tile(text: "wohnt", role: .verb), Tile(text: "in Bonn.")],
        notice: "The same verb with two endings: „ich wohne“, but „Marta wohnt“.",
        rule: "Take -en off the verb and add the ending for the person: ich -e, du -st, er/sie/es -t, wir -en, ihr -t, sie/Sie -en.",
        visual: RuleVisual(
            source: Part(systemImage: "person.fill", german: "ich wohne", marked: "e", role: "I live"),
            target: Part(systemImage: "person.2.fill", german: "wir wohnen", marked: "en", role: "we live"),
            sentence: "ich wohne, wir wohnen",
            columns: ["wohnen", "ending"],
            rows: [
                Row(label: "ich", cells: ["wohne", "-e"], marked: [1]),
                Row(label: "du", cells: ["wohnst", "-st"], marked: [1]),
                Row(label: "er · sie · es", cells: ["wohnt", "-t"], marked: [1]),
                Row(label: "wir", cells: ["wohnen", "-en"], marked: [1]),
                Row(label: "ihr", cells: ["wohnt", "-t"], marked: [1]),
                Row(label: "sie · Sie", cells: ["wohnen", "-en"], marked: [1])
            ],
            isLinked: false
        ),
        exam: [
            .gap(.easy, "Du ___ sehr gut Deutsch.", hint: "lernen", options: ["lerne", "lernst", "lernt"], answer: 1,
                 why: "du takes -st: du lernst."),
            .gap(.medium, "Mein Bruder ___ in Berlin, aber meine Eltern ___ in Ankara.", prompt: "Fill both gaps.",
                 hint: "wohnen", options: ["wohnt … wohnen", "wohnen … wohnt", "wohnt … wohnt"], answer: 0,
                 why: "One person (mein Bruder = er) takes -t. Several people (meine Eltern = sie) take -en."),
            .build("Anna works in Hamburg and learns German.",
                   words: ["lernt", "Anna", "arbeitet", "Deutsch", "in Hamburg", "und", "arbeitest"],
                   answers: ["Anna arbeitet in Hamburg und lernt Deutsch"],
                   why: "Anna = sie, so the ending is -t. After t or d an extra e makes it easy to say: sie arbeitet.")
        ]
    )

    static let verbSecondVisual = RuleVisual(
        source: Part(systemImage: "1.circle.fill", german: "Heute", role: "Position 1"),
        target: Part(systemImage: "2.circle.fill", german: "trinke", marked: "trinke", role: "Position 2: the verb"),
        sentence: "Heute trinke ich einen Tee.",
        columns: ["1", "2", "3", "…"],
        rows: [
            Row(label: "Subject first", cells: ["Ich", "trinke", "heute", "einen Tee"], marked: [1]),
            Row(label: "Time first", cells: ["Heute", "trinke", "ich", "einen Tee"], marked: [1])
        ]
    )

    static let verbSecondExam: [ExamQuestion] = [
        .gap(.easy, prompt: "Which sentence is right?",
             options: ["Morgen ich gehe ins Kino.", "Morgen gehe ich ins Kino.", "Morgen ins Kino ich gehe."], answer: 1,
             why: "„Morgen“ takes position 1, so the verb „gehe“ comes next and „ich“ moves behind it."),
        .gap(.medium, "Am Wochenende ___ ___ meine Eltern.", prompt: "Fill both gaps.",
             options: ["ich besuche", "besuche ich", "besuchen ich"], answer: 1,
             why: "„Am Wochenende“ is in position 1. The verb is second, in the form for ich: besuche ich."),
        .build("In the evening we cook together.", prompt: "Build the sentence. Start with the time. One tile is left over.",
               words: ["wir", "zusammen", "Am Abend", "kochen", "kocht"],
               answers: ["Am Abend kochen wir zusammen"],
               why: "The time is in position 1, so the verb comes second and „wir“ third. And wir takes -en: kochen.")
    ]

    static let yesNoQuestions = GrammarRule(
        id: "ja-nein-frage", level: .a1, title: "Yes/no questions: the verb comes first",
        place: "On the phone", systemImage: "phone",
        german: "Haben Sie morgen Zeit? — Ja, um zehn.",
        english: "Do you have time tomorrow? — Yes, at ten.",
        tiles: [Tile(text: "Haben", role: .verb), Tile(text: "Sie"), Tile(text: "morgen Zeit?")],
        notice: "There is no question word. The verb „Haben“ opens the question, and the answer is ja or nein.",
        rule: "For a question you answer with ja or nein, put the verb first and the subject right behind it.",
        visual: RuleVisual(
            source: Part(systemImage: "text.bubble.fill", german: "Du kommst.", role: "you say it"),
            target: Part(systemImage: "questionmark.bubble.fill", german: "Kommst du?", marked: "Kommst", role: "you ask it"),
            sentence: "Du kommst. Kommst du?",
            columns: ["1", "2", "…"],
            rows: [
                Row(label: "Statement", cells: ["Du", "kommst", "heute."], marked: [1]),
                Row(label: "Question", cells: ["Kommst", "du", "heute?"], marked: [0])
            ]
        ),
        exam: [
            .gap(.easy, prompt: "Which one is a yes/no question?",
                 options: ["Wo wohnst du?", "Wohnst du in Berlin?", "Du wohnst in Berlin."], answer: 1,
                 why: "It starts with the verb „Wohnst“ and you can answer it with ja or nein."),
            .gap(.medium, "___ ___ einen Moment Zeit?", prompt: "Fill both gaps.",
                 options: ["Sie haben", "Haben Sie", "Hat Sie"], answer: 1,
                 why: "The verb comes first, and Sie takes „haben“, not „hat“: Haben Sie …?"),
            .build("Do your children already speak German?",
                   words: ["schon", "deine Kinder", "Sprechen", "Deutsch", "Spricht"],
                   answers: ["Sprechen deine Kinder schon Deutsch"],
                   why: "The verb opens the question. „deine Kinder“ are several, so it is „sprechen“, not „spricht“.")
        ]
    )

    static let wQuestions = GrammarRule(
        id: "w-frage", level: .a1, title: "W-questions: wer, was, wo, wann",
        place: "At the station", systemImage: "tram",
        german: "Wann fährt der nächste Zug nach Leipzig?",
        english: "When does the next train to Leipzig leave?",
        tiles: [Tile(text: "Wann", role: .key), Tile(text: "fährt", role: .verb), Tile(text: "der nächste Zug"),
                Tile(text: "nach Leipzig?")],
        notice: "The question word takes position 1, and the verb stays in position 2.",
        rule: "A W-question starts with the question word. The verb comes second, and the subject follows it.",
        visual: RuleVisual(
            source: Part(systemImage: "questionmark.circle.fill", german: "Wo", role: "Position 1: the question word"),
            target: Part(systemImage: "2.circle.fill", german: "wohnst", marked: "wohnst", role: "Position 2: the verb"),
            sentence: "Wo wohnst du?",
            columns: ["asks for", "example"],
            rows: [
                Row(label: "wer", cells: ["a person", "Wer ist das?"]),
                Row(label: "was", cells: ["a thing", "Was ist das?"]),
                Row(label: "wo", cells: ["a place", "Wo wohnst du?"]),
                Row(label: "woher", cells: ["from where", "Woher kommst du?"]),
                Row(label: "wohin", cells: ["to where", "Wohin gehst du?"]),
                Row(label: "wann", cells: ["a time", "Wann kommst du?"]),
                Row(label: "wie", cells: ["how", "Wie heißt du?"])
            ]
        ),
        exam: [
            .gap(.easy, "___ heißt du? — Ich heiße Omar.", options: ["Wie", "Wer", "Was"], answer: 0,
                 why: "German asks how you are called: Wie heißt du?"),
            .gap(.medium, "___ wohnst du, und ___ kommst du? — In Mainz, aber ich komme aus Ghana.", prompt: "Fill both gaps.",
                 options: ["Wo … woher", "Woher … wo", "Wohin … wo"], answer: 0,
                 why: "„wo“ asks for the place you are in (in Mainz). „woher“ asks where you come from (aus Ghana)."),
            .build("When does the German course start on Monday?", prompt: "Build the sentence. Two tiles are left over.",
                   words: ["am Montag", "beginnt", "Wann", "der Deutschkurs", "Wenn", "beginnen"],
                   answers: ["Wann beginnt der Deutschkurs am Montag", "Wann beginnt am Montag der Deutschkurs"],
                   why: "„Wann“ asks for a time; „wenn“ means if. The verb is second, and one course takes -t: beginnt.")
        ]
    )
}
