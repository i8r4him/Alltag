//
//  MockRules+A1Nouns.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The A1 rules, part 2: nouns and the small words in front of them.
extension MockRules {
    static let articles = GrammarRule(
        id: "artikel", level: .a1, title: "der, die, das and ein, eine",
        place: "In a furniture shop", systemImage: "sofa",
        german: "Das ist ein Tisch. Der Tisch kostet 80 Euro.",
        english: "That is a table. The table costs 80 euros.",
        tiles: [Tile(text: "Das ist"), Tile(text: "ein", role: .key), Tile(text: "Tisch."), Tile(text: "Der", role: .key),
                Tile(text: "Tisch kostet 80 Euro.")],
        notice: "New in the conversation: „ein Tisch“. Now both know which one is meant: „der Tisch“.",
        rule: "Every noun is der, die or das. Use ein or eine for something new, and der, die, das for something already known.",
        visual: RuleVisual(
            source: Part(systemImage: "sparkles", german: "ein Tisch", marked: "ein", role: "new: a table"),
            target: Part(systemImage: "table.furniture.fill", german: "der Tisch", marked: "der", role: "known: the table"),
            sentence: "Ein Tisch. Der Tisch.",
            columns: ["masc.", "fem.", "neut."],
            rows: [
                Row(label: "the", cells: ["der", "die", "das"]),
                Row(label: "a", cells: ["ein", "eine", "ein"]),
                Row(label: "not a", cells: ["kein", "keine", "kein"])
            ]
        ),
        exam: [
            .gap(.easy, "Das ist ___ Lampe.", hint: "die Lampe", options: ["ein", "eine", "der"], answer: 1,
                 why: "„die Lampe“ is feminine, so it is „eine Lampe“."),
            .gap(.medium, "Dort steht ___ Auto. ___ Auto ist neu.", prompt: "Fill both gaps.", hint: "das Auto",
                 options: ["das … Ein", "ein … Das", "eine … Die"], answer: 1,
                 why: "The first time the car is new to the listener: ein Auto. After that it is known: das Auto."),
            .build("That is not a book, that is a newspaper.",
                   words: ["eine", "Das ist", "kein", "Zeitung", "das ist", "Buch", "keine"],
                   answers: ["Das ist kein Buch das ist eine Zeitung"],
                   why: "„das Buch“ takes kein without an ending. „die Zeitung“ is feminine: eine Zeitung.")
        ]
    )

    static let plural = GrammarRule(
        id: "plural", level: .a1, title: "The plural: always die",
        place: "At the market", systemImage: "basket",
        german: "Zwei Äpfel und drei Tomaten, bitte.",
        english: "Two apples and three tomatoes, please.",
        tiles: [Tile(text: "Zwei"), Tile(text: "Äpfel", role: .key), Tile(text: "und drei"), Tile(text: "Tomaten", role: .key),
                Tile(text: "bitte.")],
        notice: "der Apfel → die Äpfel, die Tomate → die Tomaten. Each plural has its own ending.",
        rule: "In the plural every noun takes die. The ending differs from noun to noun, so learn each noun with its plural.",
        visual: RuleVisual(
            source: Part(systemImage: "book.closed.fill", german: "das Buch", role: "one"),
            target: Part(systemImage: "books.vertical.fill", german: "die Bücher", marked: "die", role: "several"),
            sentence: "Das Buch, die Bücher.",
            columns: ["one", "several"],
            rows: [
                Row(label: "-e", cells: ["der Tisch", "die Tische"], marked: [1]),
                Row(label: "-er", cells: ["das Kind", "die Kinder"], marked: [1]),
                Row(label: "-n", cells: ["die Lampe", "die Lampen"], marked: [1]),
                Row(label: "-s", cells: ["das Auto", "die Autos"], marked: [1]),
                Row(label: "umlaut", cells: ["der Apfel", "die Äpfel"], marked: [1]),
                Row(label: "no change", cells: ["der Lehrer", "die Lehrer"], marked: [1])
            ]
        ),
        exam: [
            .gap(.easy, "Das sind ___ Kinder von Frau Demir.", options: ["das", "der", "die"], answer: 2,
                 why: "It is „das Kind“, but every plural takes die: die Kinder."),
            .gap(.medium, "Ich brauche zwei ___ und drei ___.", prompt: "Fill both gaps.", hint: "der Stuhl · die Lampe",
                 options: ["Stuhle … Lampen", "Stühle … Lampen", "Stühle … Lampes"], answer: 1,
                 why: "der Stuhl → die Stühle, with an umlaut. Nouns in -e add -n: die Lampen."),
            .build("The children have two cats and three dogs.",
                   words: ["Hunde", "zwei", "Die Kinder", "Katzen", "haben", "und", "drei", "Hunden"],
                   answers: ["Die Kinder haben zwei Katzen und drei Hunde"],
                   why: "die Katze → die Katzen, but der Hund → die Hunde. The -n of „Hunden“ belongs to the dative.")
        ]
    )

    static let negation = GrammarRule(
        id: "negation", level: .a1, title: "nicht or kein",
        place: "Message from a friend", systemImage: "message",
        german: "Ich habe heute keine Zeit. Ich komme nicht.",
        english: "I have no time today. I'm not coming.",
        tiles: [Tile(text: "Ich habe heute"), Tile(text: "keine", role: .key), Tile(text: "Zeit."), Tile(text: "Ich komme"),
                Tile(text: "nicht", role: .key)],
        notice: "„keine“ stands in front of the noun „Zeit“. „nicht“ says no to the verb „komme“.",
        rule: "kein negates a noun that would take ein or no article. nicht negates everything else: "
            + "verbs, adjectives, and nouns with der, die, das or mein.",
        visual: RuleVisual(
            source: Part(systemImage: "cup.and.saucer.fill", german: "kein Kaffee", marked: "kein", role: "no + noun"),
            target: Part(systemImage: "moon.zzz.fill", german: "nicht müde", marked: "nicht", role: "not + the rest"),
            sentence: "Kein Kaffee. Nicht müde.",
            columns: ["yes", "no"],
            rows: [
                Row(label: "ein + noun", cells: ["ein Auto", "kein Auto"], marked: [1]),
                Row(label: "noun alone", cells: ["Zeit", "keine Zeit"], marked: [1]),
                Row(label: "verb", cells: ["Ich komme.", "Ich komme nicht."], marked: [1]),
                Row(label: "adjective", cells: ["Das ist teuer.", "Das ist nicht teuer."], marked: [1]),
                Row(label: "der · mein", cells: ["Das ist mein Auto.", "Das ist nicht mein Auto."], marked: [1])
            ],
            isLinked: false
        ),
        exam: [
            .gap(.easy, "Ich habe ___ Auto.", hint: "das Auto", options: ["nicht", "kein", "keine"], answer: 1,
                 why: "„Auto“ is a noun that would take ein: ein Auto → kein Auto."),
            .gap(.medium, "Er arbeitet heute ___, aber er hat ___ Zeit.", prompt: "Fill both gaps.",
                 options: ["nicht … keine", "kein … nicht", "nicht … nicht"], answer: 0,
                 why: "„arbeitet“ is a verb: nicht. „Zeit“ is a noun without an article: keine Zeit."),
            .build("I am not tired, but I have no time.",
                   words: ["keine", "Ich bin", "müde", "aber", "nicht", "ich habe", "Zeit", "kein"],
                   answers: ["Ich bin nicht müde aber ich habe keine Zeit"],
                   why: "„müde“ is an adjective: nicht müde. „die Zeit“ is feminine, so it is keine, not kein.")
        ]
    )

    static let possessives = GrammarRule(
        id: "possessiv", level: .a1, title: "mein, dein, sein, ihr: whose is it?",
        place: "Showing a photo", systemImage: "photo",
        german: "Das ist meine Schwester, und das ist ihr Mann.",
        english: "This is my sister, and this is her husband.",
        tiles: [Tile(text: "Das ist"), Tile(text: "meine", role: .key), Tile(text: "Schwester, und das ist"),
                Tile(text: "ihr", role: .key), Tile(text: "Mann.")],
        notice: "„meine“ ends in -e because „Schwester“ is feminine. „ihr“ means her: the husband of my sister.",
        rule: "mein, dein, sein, ihr, unser, euer say whose something is. They take the endings of ein: "
            + "mein Bruder, meine Schwester, meine Eltern.",
        visual: RuleVisual(
            source: Part(systemImage: "person.fill", german: "ich", role: "the owner"),
            target: Part(systemImage: "key.fill", german: "mein Schlüssel", marked: "mein", role: "my key"),
            sentence: "Ich, mein Schlüssel.",
            columns: ["der · das", "die · plural"],
            rows: [
                Row(label: "ich", cells: ["mein", "meine"]),
                Row(label: "du", cells: ["dein", "deine"]),
                Row(label: "er · es", cells: ["sein", "seine"], marked: [0, 1]),
                Row(label: "sie", cells: ["ihr", "ihre"], marked: [0, 1]),
                Row(label: "wir", cells: ["unser", "unsere"]),
                Row(label: "ihr", cells: ["euer", "eure"]),
                Row(label: "sie · Sie", cells: ["ihr · Ihr", "ihre · Ihre"])
            ]
        ),
        exam: [
            .gap(.easy, "Das ist ___ Bruder.", hint: "ich · der Bruder", options: ["mein", "meine", "meinen"], answer: 0,
                 why: "„der Bruder“ takes the form without an ending, like ein: mein Bruder."),
            .gap(.medium, "Das ist Herr Yilmaz, und das ist ___ Frau.", options: ["ihre", "seine", "sein"], answer: 1,
                 why: "Herr Yilmaz is er, so the word is sein. „die Frau“ is feminine, so it adds -e: seine Frau."),
            .build("Maria and her brother visit their parents.",
                   words: ["ihre", "besuchen", "Maria", "Eltern", "und", "ihr", "Bruder", "seine"],
                   answers: ["Maria und ihr Bruder besuchen ihre Eltern"],
                   why: "Maria is sie: ihr Bruder. The parents belong to both of them: ihre Eltern. „seine“ would need a he.")
        ]
    )

    static let whichThis = GrammarRule(
        id: "welcher-dieser", level: .a1, title: "welcher and dieser",
        place: "In a clothes shop", systemImage: "tshirt",
        german: "Welche Jacke möchten Sie? — Diese hier, bitte.",
        english: "Which jacket would you like? — This one, please.",
        tiles: [Tile(text: "Welche", role: .key), Tile(text: "Jacke möchten Sie?"), Tile(text: "Diese", role: .key),
                Tile(text: "hier, bitte.")],
        notice: "„Welche“ asks which one. „Diese“ points at one. Both end like „die“, because it is „die Jacke“.",
        rule: "welch- asks which one of several, and dies- points at one. Both take the ending of der, die, das.",
        visual: RuleVisual(
            source: Part(systemImage: "questionmark.circle.fill", german: "Welcher Bus?", marked: "Welcher", role: "asks: which one?"),
            target: Part(systemImage: "bus.fill", german: "Dieser Bus.", marked: "Dieser", role: "points: this one"),
            sentence: "Welcher Bus? Dieser Bus.",
            columns: ["masc.", "fem.", "neut.", "plural"],
            rows: [
                Row(label: "the", cells: ["der", "die", "das", "die"]),
                Row(label: "which", cells: ["welcher", "welche", "welches", "welche"], marked: [0, 1, 2, 3]),
                Row(label: "this", cells: ["dieser", "diese", "dieses", "diese"], marked: [0, 1, 2, 3])
            ]
        ),
        exam: [
            .gap(.easy, "___ Buch ist das?", hint: "das Buch", options: ["Welcher", "Welche", "Welches"], answer: 2,
                 why: "„das Buch“ is neuter, and das gives -es: welches Buch."),
            .gap(.medium, "___ Bus fährt zum Bahnhof? — ___ Bus dort.", prompt: "Fill both gaps.", hint: "der Bus",
                 options: ["Welcher … Dieser", "Welche … Diese", "Welches … Dieser"], answer: 0,
                 why: "„der Bus“ is masculine, and der gives -er in both words: welcher Bus, dieser Bus."),
            .build("This lamp is nice, but which table is cheap?",
                   words: ["ist", "Diese", "Tisch", "schön", "aber", "welcher", "Lampe", "ist", "billig", "welche"],
                   answers: ["Diese Lampe ist schön aber welcher Tisch ist billig"],
                   why: "die Lampe → diese Lampe. der Tisch → welcher Tisch; „welche“ would fit a die-noun.")
        ]
    )
}
