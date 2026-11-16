//
//  MockRules+B1Verbs.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The B1 rules, part 3: verbs and what they take.
extension MockRules {
    static let b1PrefixVerbs = GrammarRule(
        id: "b1-trennbar-untrennbar", level: .b1, title: "Separable or not: anrufen, bekommen",
        place: "Message from a friend", systemImage: "message",
        german: "Ich rufe dich heute Abend an. Hast du meine Nachricht bekommen?",
        english: "I'll call you this evening. Did you get my message?",
        tiles: [Tile(text: "Ich"), Tile(text: "rufe", role: .verb), Tile(text: "dich heute Abend"), Tile(text: "an.", role: .end),
                Tile(text: "Hast du meine Nachricht"), Tile(text: "bekommen?", role: .key)],
        notice: "„an“ splits off from „anrufen“. „be-“ never splits, and „bekommen“ takes no ge- in the participle.",
        rule: "Stressed prefixes like an-, auf-, ein- and mit- split off and go to the end. be-, emp-, ent-, er-, ge-, "
            + "miss-, ver- and zer- never split, and their participle has no ge-.",
        visual: RuleVisual(
            source: Part(systemImage: "scissors", german: "an | rufen", marked: "an", role: "splits off"),
            target: Part(systemImage: "link", german: "verstehen", marked: "ver", role: "stays together"),
            sentence: "anrufen splits, verstehen stays together.",
            columns: ["in a sentence", "participle"],
            rows: [
                Row(label: "anrufen", cells: ["ruft … an", "angerufen"], marked: [0]),
                Row(label: "aufstehen", cells: ["steht … auf", "aufgestanden"], marked: [0]),
                Row(label: "verstehen", cells: ["versteht", "verstanden"], marked: [1]),
                Row(label: "bekommen", cells: ["bekommt", "bekommen"], marked: [1])
            ],
            isLinked: false
        ),
        exam: [
            .gap(.easy, "Ich habe deine Frage nicht ___.", hint: "verstehen",
                 options: ["verstanden", "geverstanden", "verstehen"], answer: 0,
                 why: "ver- never splits and takes no ge-: verstanden."),
            .gap(.medium, "Ich ___ dich am Bahnhof ab, und du ___ das Taxi.", prompt: "Fill both gaps.",
                 hint: "abholen · bezahlen", options: ["hole … bezahlst", "hole … zahlst be", "abhole … bezahlst"], answer: 0,
                 why: "ab- is stressed and splits: ich hole dich ab. be- never splits: du bezahlst."),
            .build("I got up early and received a letter.",
                   words: ["bekommen", "Ich bin früh", "gebekommen", "und habe", "aufgestanden", "einen Brief"],
                   answers: ["Ich bin früh aufgestanden und habe einen Brief bekommen"],
                   why: "auf- splits, so ge- goes between: aufgestanden. be- never splits and takes no ge-: bekommen.")
        ]
    )

    static let b1ReflexiveDative = GrammarRule(
        id: "b1-reflexiv-dativ", level: .b1, title: "Reflexive in the dative: Ich wasche mir die Hände",
        place: "Before dinner", systemImage: "fork.knife",
        german: "Wasch dir bitte die Hände, das Essen ist fertig.",
        english: "Please wash your hands, dinner's ready.",
        tiles: [Tile(text: "Wasch"), Tile(text: "dir", role: .key), Tile(text: "bitte"), Tile(text: "die Hände,", role: .end),
                Tile(text: "das Essen ist fertig.")],
        notice: "The hands are what you wash, so „sich“ moves to the dative: „dir“, not „dich“.",
        rule: "When a reflexive verb already has an object, the reflexive pronoun takes the dative: "
            + "mich becomes mir and dich becomes dir. The others stay the same.",
        visual: RuleVisual(
            source: Part(systemImage: "figure.stand", german: "Ich wasche mich.", marked: "mich", role: "no other object"),
            target: Part(systemImage: "hands.sparkles.fill", german: "Ich wasche mir die Hände.", marked: "mir",
                         role: "with an object"),
            sentence: "Ich wasche mich. Ich wasche mir die Hände.",
            columns: ["ich", "du", "er · sie · es", "wir · ihr"],
            rows: [
                Row(label: "alone", cells: ["mich", "dich", "sich", "uns\neuch"]),
                Row(label: "+ object", cells: ["mir", "dir", "sich", "uns\neuch"], marked: [0, 1])
            ],
            isLinked: false
        ),
        exam: [
            .gap(.easy, "Ich kämme ___ die Haare.", options: ["mich", "mir", "mein"], answer: 1,
                 why: "die Haare is the object, so the reflexive pronoun takes the dative: mir."),
            .gap(.medium, "Hast du ___ schon angezogen? Dann zieh ___ noch die Jacke an.", prompt: "Fill both gaps.",
                 options: ["dich … dir", "dir … dich", "dich … dich"], answer: 0,
                 why: "„sich anziehen“ alone takes dich. With an object, die Jacke, it becomes dir."),
            .build("I'd like to buy myself a new bike.",
                   words: ["kaufen", "mich", "Ich möchte", "ein neues Fahrrad", "mir"],
                   answers: ["Ich möchte mir ein neues Fahrrad kaufen"],
                   why: "The bike is what you buy, so the reflexive pronoun is in the dative: mir.")
        ]
    )

    static let b1PlaceVerbs = GrammarRule(
        id: "b1-stellen-stehen", level: .b1, title: "stellen or stehen, legen or liegen",
        place: "Moving in", systemImage: "shippingbox",
        german: "Stell die Lampe bitte auf den Tisch. Jetzt steht sie auf dem Tisch.",
        english: "Please put the lamp on the table. Now it's standing on the table.",
        tiles: [Tile(text: "Stell", role: .verb), Tile(text: "die Lampe bitte"), Tile(text: "auf den Tisch.", role: .key),
                Tile(text: "Jetzt"), Tile(text: "steht", role: .verb), Tile(text: "sie"), Tile(text: "auf dem Tisch.", role: .end)],
        notice: "„stellen“ is the movement: „Wohin?“ with the accusative. „stehen“ is the result: „Wo?“ with the dative.",
        rule: "stellen, legen, setzen and hängen move something: Wohin? + accusative. "
            + "stehen, liegen, sitzen and hängen say where it is: Wo? + dative.",
        visual: RuleVisual(
            source: Part(systemImage: "hand.point.right.fill", german: "auf den Tisch", marked: "den", role: "Wohin?",
                         name: "Accusative"),
            target: Part(systemImage: "lamp.desk.fill", german: "auf dem Tisch", marked: "dem", role: "Wo?", name: "Dative"),
            sentence: "Ich stelle die Lampe auf den Tisch. Jetzt steht sie auf dem Tisch.",
            columns: ["Wohin?", "Wo?"],
            rows: [
                Row(label: "upright", cells: ["stellen", "stehen"]),
                Row(label: "lying flat", cells: ["legen", "liegen"]),
                Row(label: "sitting", cells: ["setzen", "sitzen"]),
                Row(label: "hanging", cells: ["hängen", "hängen"], marked: [0, 1])
            ]
        ),
        exam: [
            .gap(.easy, "Das Buch ___ auf dem Sofa.", options: ["liegt", "legt", "stellt"], answer: 0,
                 why: "„auf dem Sofa“ answers Wo?, so it takes the place verb: liegt."),
            .gap(.medium, "Ich ___ die Flaschen in ___ Kühlschrank.", prompt: "Fill both gaps.", hint: "der Kühlschrank",
                 options: ["stelle … den", "stehe … dem", "stelle … dem"], answer: 0,
                 why: "Putting them there is a movement, Wohin?: stellen, with the accusative: in den Kühlschrank."),
            .build("She put the keys on the table and sat down on the sofa.",
                   prompt: "Build the sentence. Two tiles are left over.",
                   words: ["auf dem Sofa", "Sie legte", "auf das Sofa", "und setzte sich", "auf dem Tisch", "die Schlüssel",
                           "auf den Tisch"],
                   answers: ["Sie legte die Schlüssel auf den Tisch und setzte sich auf das Sofa"],
                   why: "legen and sich setzen are movements, Wohin?, so both take the accusative: auf den Tisch, auf das Sofa.")
        ]
    )

    static let b1PrepositionVerbs = GrammarRule(
        id: "b1-verb-praeposition", level: .b1, title: "Verbs with prepositions: warten auf",
        place: "At the bus stop", systemImage: "bus.fill",
        german: "Ich warte schon seit zehn Minuten auf den Bus.",
        english: "I've been waiting for the bus for ten minutes.",
        tiles: [Tile(text: "Ich"), Tile(text: "warte", role: .verb), Tile(text: "schon seit zehn Minuten"),
                Tile(text: "auf", role: .key), Tile(text: "den Bus.", role: .end)],
        notice: "English waits „for“, German waits „auf“. And here auf takes the accusative: „auf den Bus“.",
        rule: "Many verbs take a fixed preposition with a fixed case. Learn them as a pair: "
            + "warten auf + accusative, träumen von + dative.",
        visual: RuleVisual(
            source: Part(systemImage: "figure.stand", german: "warten", role: "the verb"),
            target: Part(systemImage: "bus.fill", german: "auf den Bus", marked: "auf", role: "its preposition"),
            sentence: "warten auf den Bus",
            columns: ["with", "case"],
            rows: [
                Row(label: "warten", cells: ["auf", "Akk."]),
                Row(label: "denken", cells: ["an", "Akk."]),
                Row(label: "sich interessieren", cells: ["für", "Akk."]),
                Row(label: "träumen", cells: ["von", "Dat."], marked: [1]),
                Row(label: "Angst haben", cells: ["vor", "Dat."], marked: [1])
            ]
        ),
        exam: [
            .gap(.easy, "Ich interessiere mich ___ Musik.", options: ["für", "auf", "an"], answer: 0,
                 why: "sich interessieren always takes für."),
            .gap(.medium, "Sie denkt oft ___ Urlaub.", hint: "der Urlaub",
                 options: ["an den", "an dem", "von den"], answer: 0,
                 why: "denken takes an with the accusative: an den Urlaub."),
            .build("We're looking forward to the weekend.", prompt: "Build the sentence. Two tiles are left over.",
                   words: ["das Wochenende", "freuen", "über", "Wir", "dem Wochenende", "uns", "auf"],
                   answers: ["Wir freuen uns auf das Wochenende"],
                   why: "Looking forward to something still to come is „sich freuen auf“, with the accusative. "
                       + "„sich freuen über“ is for something that has already happened.")
        ]
    )

    static let b1DaWoWords = GrammarRule(
        id: "b1-da-wo", level: .b1, title: "da- and wo- words: dafür, worauf",
        place: "Message from a friend", systemImage: "message",
        german: "Worauf wartest du? — Auf die Pizza. Ich warte schon lange darauf.",
        english: "What are you waiting for? — The pizza. I've been waiting for it for ages.",
        tiles: [Tile(text: "Worauf", role: .key), Tile(text: "wartest du? — Auf die Pizza. Ich warte schon lange"),
                Tile(text: "darauf.", role: .key)],
        notice: "For a thing, „auf was?“ becomes „worauf?“, and „auf sie“ becomes „darauf“.",
        rule: "For things, a preposition joins wo- in a question and da- in an answer: worauf, darauf. "
            + "Before a vowel, add -r-. For people, keep the preposition: auf wen? auf ihn.",
        visual: RuleVisual(
            source: Part(systemImage: "questionmark.bubble.fill", german: "Worauf wartest du?", marked: "Worauf",
                         role: "a question about a thing"),
            target: Part(systemImage: "text.bubble.fill", german: "Ich warte darauf.", marked: "darauf", role: "the answer"),
            sentence: "Worauf wartest du? Ich warte darauf.",
            columns: ["question", "answer", "a person"],
            rows: [
                Row(label: "auf", cells: ["worauf", "darauf", "auf wen"], marked: [0, 1]),
                Row(label: "für", cells: ["wofür", "dafür", "für wen"]),
                Row(label: "mit", cells: ["womit", "damit", "mit wem"]),
                Row(label: "über", cells: ["worüber", "darüber", "über wen"], marked: [0, 1])
            ],
            isLinked: false
        ),
        exam: [
            .gap(.easy, "___ interessierst du dich? — Für Fußball.", options: ["Wofür", "Dafür", "Für wen"], answer: 0,
                 why: "A question about a thing: wo + für = wofür."),
            .gap(.medium, "Erinnerst du dich an den Urlaub? — Ja, ich erinnere mich gern ___.",
                 options: ["daran", "an ihn", "woran"], answer: 0,
                 why: "der Urlaub is a thing, so „an ihn“ becomes „daran“. an starts with a vowel, so it takes -r-."),
            .build("I think about it all the time.", prompt: "Build the sentence. Two tiles are left over.",
                   words: ["daran", "an es", "Ich denke", "darum", "die ganze Zeit"],
                   answers: ["Ich denke die ganze Zeit daran"],
                   why: "denken takes an. For a thing, an + es becomes daran, with -r- before the vowel.")
        ]
    )
}
