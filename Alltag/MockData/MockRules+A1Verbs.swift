//
//  MockRules+A1Verbs.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The A1 rules, part 3: verbs that do more than take an ending.
extension MockRules {
    static let vowelChange = GrammarRule(
        id: "vokalwechsel", level: .a1, title: "Verbs that change their vowel",
        place: "At lunch", systemImage: "fork.knife",
        german: "Ich esse einen Salat. Was isst du?",
        english: "I'm having a salad. What are you having?",
        tiles: [Tile(text: "Ich"), Tile(text: "esse", role: .verb), Tile(text: "einen Salat. Was"),
                Tile(text: "isst", role: .verb), Tile(text: "du?")],
        notice: "„ich esse“, but „du isst“: with du the e turns into i.",
        rule: "Some verbs change their vowel with du and er/sie/es only: e becomes i or ie, and a becomes ä.",
        visual: RuleVisual(
            source: Part(systemImage: "person.fill", german: "ich fahre", marked: "a", role: "I drive"),
            target: Part(systemImage: "car.fill", german: "er fährt", marked: "ä", role: "he drives"),
            sentence: "Ich fahre. Er fährt.",
            columns: ["ich", "du", "er · sie · es"],
            rows: [
                Row(label: "sprechen", cells: ["spreche", "sprichst", "spricht"], marked: [1, 2]),
                Row(label: "essen", cells: ["esse", "isst", "isst"], marked: [1, 2]),
                Row(label: "lesen", cells: ["lese", "liest", "liest"], marked: [1, 2]),
                Row(label: "sehen", cells: ["sehe", "siehst", "sieht"], marked: [1, 2]),
                Row(label: "fahren", cells: ["fahre", "fährst", "fährt"], marked: [1, 2]),
                Row(label: "schlafen", cells: ["schlafe", "schläfst", "schläft"], marked: [1, 2])
            ]
        ),
        exam: [
            .gap(.easy, "Er ___ gut Deutsch.", hint: "sprechen", options: ["sprecht", "spricht", "sprechen"], answer: 1,
                 why: "With er the e of sprechen becomes i: er spricht."),
            .gap(.medium, "Du ___ nach Köln, und wir ___ nach Bonn.", prompt: "Fill both gaps.", hint: "fahren",
                 options: ["fährst … fähren", "fahrst … fahren", "fährst … fahren"], answer: 2,
                 why: "Only du and er/sie/es change: du fährst. wir keeps the a: wir fahren."),
            .build("Maria reads a book and the children sleep.",
                   words: ["schlafen", "Maria", "ein Buch", "und", "liest", "die Kinder", "lest"],
                   answers: ["Maria liest ein Buch und die Kinder schlafen"],
                   why: "Maria = sie, so e becomes ie: sie liest. „lest“ goes with ihr. Several children keep the a: schlafen.")
        ]
    )

    static let modalVerbs = GrammarRule(
        id: "modalverben", level: .a1, title: "Modal verbs: können, müssen, wollen",
        place: "At the doctor's", systemImage: "stethoscope",
        german: "Sie müssen viel Wasser trinken.",
        english: "You must drink a lot of water.",
        tiles: [Tile(text: "Sie"), Tile(text: "müssen", role: .verb), Tile(text: "viel Wasser"), Tile(text: "trinken", role: .end)],
        notice: "„müssen“ sits in position 2. The action, „trinken“, waits at the very end and doesn't change.",
        rule: "können, müssen, wollen, dürfen and sollen take position 2 and change with the person. "
            + "The other verb goes to the end as an infinitive.",
        visual: RuleVisual(
            source: Part(systemImage: "2.circle.fill", german: "kann", marked: "kann", role: "Position 2: the modal verb"),
            target: Part(systemImage: "arrow.right.to.line", german: "schwimmen", marked: "schwimmen", role: "The end: the infinitive"),
            sentence: "Ich kann gut schwimmen.",
            columns: ["ich · er", "du", "wir · sie"],
            rows: [
                Row(label: "können", cells: ["kann", "kannst", "können"], marked: [0]),
                Row(label: "müssen", cells: ["muss", "musst", "müssen"], marked: [0]),
                Row(label: "wollen", cells: ["will", "willst", "wollen"], marked: [0]),
                Row(label: "dürfen", cells: ["darf", "darfst", "dürfen"], marked: [0]),
                Row(label: "sollen", cells: ["soll", "sollst", "sollen"], marked: [0])
            ]
        ),
        exam: [
            .gap(.easy, "Ich ___ heute lange arbeiten.", hint: "müssen", options: ["muss", "musst", "müssen"], answer: 0,
                 why: "ich and er/sie/es have no ending with modal verbs: ich muss."),
            .gap(.medium, "Hier ___ man nicht ___.", prompt: "Fill both gaps.", hint: "dürfen · parken",
                 options: ["darf … parken", "dürft … parkt", "darf … parkt"], answer: 0,
                 why: "man is like er: man darf. The second verb stays an infinitive at the end: parken."),
            .build("On Saturday I want to visit my sister.", prompt: "Build the sentence. Start with the day. One tile is left over.",
                   words: ["besuchen", "ich", "Am Samstag", "will", "meine Schwester", "besuche"],
                   answers: ["Am Samstag will ich meine Schwester besuchen"],
                   why: "„will“ is in position 2, so „ich“ follows it. The action goes to the end as an infinitive: besuchen.")
        ]
    )

    static let separableVerbs = GrammarRule(
        id: "trennbar", level: .a1, title: "Separable verbs: the prefix goes to the end",
        place: "Station announcement", systemImage: "tram",
        german: "Der Zug nach Hamburg fährt um 9 Uhr ab.",
        english: "The train to Hamburg leaves at 9 o'clock.",
        tiles: [Tile(text: "Der Zug nach Hamburg"), Tile(text: "fährt", role: .verb), Tile(text: "um 9 Uhr"),
                Tile(text: "ab", role: .end)],
        notice: "The verb is „abfahren“. In the sentence it splits: „fährt“ in position 2 and „ab“ at the end.",
        rule: "A separable verb splits in a main clause: the verb part takes position 2, and the prefix goes to the very end.",
        visual: RuleVisual(
            source: Part(systemImage: "2.circle.fill", german: "rufe", marked: "rufe", role: "Position 2: the verb"),
            target: Part(systemImage: "arrow.right.to.line", german: "an", marked: "an", role: "The end: the prefix"),
            sentence: "Ich rufe dich morgen an.",
            columns: ["means", "in a sentence"],
            rows: [
                Row(label: "anrufen", cells: ["to call", "Ich rufe dich an."], marked: [1]),
                Row(label: "aufstehen", cells: ["to get up", "Ich stehe um 7 Uhr auf."], marked: [1]),
                Row(label: "einkaufen", cells: ["to shop", "Wir kaufen heute ein."], marked: [1]),
                Row(label: "mitkommen", cells: ["to come along", "Kommst du mit?"], marked: [1]),
                Row(label: "fernsehen", cells: ["to watch TV", "Er sieht am Abend fern."], marked: [1])
            ]
        ),
        exam: [
            .gap(.easy, "Ich stehe um 6 Uhr ___.", options: ["an", "auf", "aus"], answer: 1,
                 why: "The verb is „aufstehen“, to get up. Its prefix goes to the end: Ich stehe … auf."),
            .gap(.medium, "Wir ___ am Samstag im Supermarkt ___.", prompt: "Fill both gaps.", hint: "einkaufen",
                 options: ["einkaufen … ein", "kaufen … ein", "ein … kaufen"], answer: 1,
                 why: "The verb part stands in position 2 and the prefix at the end: Wir kaufen … ein."),
            .build("Tomorrow I'll call my mother.", prompt: "Build the sentence. Start with the day. One tile is left over.",
                   words: ["an", "ich", "Morgen", "meine Mutter", "rufe", "anrufe"],
                   answers: ["Morgen rufe ich meine Mutter an"],
                   why: "„anrufen“ splits: „rufe“ takes position 2 behind „Morgen“, and „an“ closes the sentence.")
        ]
    )

    static let imperative = GrammarRule(
        id: "imperativ", level: .a1, title: "The imperative: asking and telling",
        place: "At the town hall", systemImage: "building.columns",
        german: "Nehmen Sie bitte Platz und warten Sie einen Moment.",
        english: "Please take a seat and wait a moment.",
        tiles: [Tile(text: "Nehmen", role: .verb), Tile(text: "Sie bitte Platz und"), Tile(text: "warten", role: .verb),
                Tile(text: "Sie einen Moment.")],
        notice: "The verb comes first. With „Sie“ the pronoun stays, right behind the verb.",
        rule: "To ask or tell someone, put the verb first. Sie keeps its pronoun: Kommen Sie! "
            + "du drops -st and the pronoun: Komm! ihr drops only the pronoun: Kommt!",
        visual: RuleVisual(
            source: Part(systemImage: "person.fill", german: "Komm!", role: "to a friend (du)"),
            target: Part(systemImage: "person.crop.circle.badge.checkmark", german: "Kommen Sie!", marked: "Sie", role: "polite (Sie)"),
            sentence: "Komm! Kommen Sie!",
            columns: ["du", "ihr", "Sie"],
            rows: [
                Row(label: "kommen", cells: ["Komm!", "Kommt!", "Kommen Sie!"]),
                Row(label: "warten", cells: ["Warte!", "Wartet!", "Warten Sie!"]),
                Row(label: "nehmen", cells: ["Nimm!", "Nehmt!", "Nehmen Sie!"], marked: [0]),
                Row(label: "sein", cells: ["Sei!", "Seid!", "Seien Sie!"], marked: [0, 1, 2])
            ],
            isLinked: false
        ),
        exam: [
            .gap(.easy, "___ Sie bitte hier!", hint: "warten", options: ["Wartest", "Warten", "Warte"], answer: 1,
                 why: "With Sie the verb keeps -en and the pronoun follows it: Warten Sie!"),
            .gap(.medium, "___ bitte das Fenster ___!", prompt: "You say it to a friend. Fill both gaps.", hint: "aufmachen",
                 options: ["Machst … auf", "Mach … auf", "Aufmach … bitte"], answer: 1,
                 why: "For du the verb loses -st and the pronoun: Mach! The prefix of „aufmachen“ still goes to the end."),
            .build("Please be quiet and read the text.", prompt: "You say it to several children. One tile is left over.",
                   words: ["lest", "leise", "Seid", "bitte", "und", "den Text", "Sei"],
                   answers: ["Seid bitte leise und lest den Text"],
                   why: "Several children are ihr: Seid! and Lest! „Sei“ is for one child.")
        ]
    )
}
