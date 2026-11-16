//
//  MockRules+B2Clauses.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The B2 rules, part 9: subordinate clauses of time, reason, result,
/// condition and means, and the infinitive with or without zu.
extension MockRules {
    static let b2Time = GrammarRule(
        id: "b2-temporal", level: .b2, title: "Time clauses: als, während, nachdem, sobald",
        place: "Telling a story", systemImage: "book",
        german: "Nachdem wir gegessen hatten, gingen wir spazieren.",
        english: "After we had eaten, we went for a walk.",
        tiles: [Tile(text: "Nachdem", role: .key), Tile(text: "wir"), Tile(text: "gegessen hatten,", role: .end),
                Tile(text: "gingen", role: .verb), Tile(text: "wir spazieren.")],
        notice: "„nachdem“ needs the tense before: „hatten gegessen“ happened before „gingen“.",
        rule: "als: once in the past. wenn: every time, or in the future. während: at the same time. bevor: before. "
            + "nachdem: after, with the tense one step back (hatte gegessen, ging). sobald: as soon as. bis: until.",
        visual: RuleVisual(
            source: Part(systemImage: "fork.knife", german: "nachdem wir gegessen hatten", marked: "hatten", role: "first"),
            target: Part(systemImage: "figure.walk", german: "gingen wir spazieren", marked: "gingen", role: "then"),
            sentence: "Nachdem wir gegessen hatten, gingen wir spazieren.",
            columns: ["means", "example"],
            rows: [
                Row(label: "als", cells: ["once, in the past", "Als ich klein war, …"]),
                Row(label: "wenn", cells: ["every time", "Wenn es regnet, …"]),
                Row(label: "während", cells: ["at the same time", "Während er kocht, …"]),
                Row(label: "nachdem", cells: ["after: a tense back", "Nachdem ich gegessen hatte, …"], marked: [0]),
                Row(label: "sobald", cells: ["as soon as", "Sobald du da bist, …"])
            ]
        ),
        exam: [
            .gap(.easy, "___ ich ein Kind war, wohnten wir in Hamburg.", options: ["Als", "Wenn", "Wann"], answer: 0,
                 why: "One time in the past, here a whole childhood: als. wenn is for every time."),
            .gap(.medium, "Ruf mich an, ___ du angekommen bist. ___ du auf mich wartest, kannst du einen Kaffee trinken.",
                 prompt: "Fill both gaps.", options: ["sobald … Während", "als … Während", "sobald … Bevor"], answer: 0,
                 why: "As soon as you've arrived: sobald. At the same time as you wait: während."),
            .build("Before I start work, I drink a coffee.",
                   words: ["mit der Arbeit", "trinke", "Bevor", "einen Kaffee", "ich", "anfange,", "ich", "Nachdem"],
                   answers: ["Bevor ich mit der Arbeit anfange, trinke ich einen Kaffee"],
                   why: "After bevor the verb goes to the end. The whole clause is position 1, so the main clause starts with its verb.")
        ]
    )

    static let b2ReasonContrast = GrammarRule(
        id: "b2-kausal-konzessiv", level: .b2, title: "Reasons and contrasts: da, obwohl, trotzdem",
        place: "Message to a colleague", systemImage: "message",
        german: "Ich gehe heute ins Büro, obwohl ich erkältet bin.",
        english: "I'm going to the office today although I have a cold.",
        tiles: [Tile(text: "Ich gehe heute ins Büro,"), Tile(text: "obwohl", role: .key), Tile(text: "ich erkältet"),
                Tile(text: "bin.", role: .end)],
        notice: "„obwohl“ brings a contrast: you'd expect the opposite. Its verb goes to the end.",
        rule: "A reason: weil and da (verb last), denn (nothing moves), deshalb (verb next). A contrast: obwohl (verb last), "
            + "trotzdem (verb next): Ich bin erkältet, trotzdem gehe ich ins Büro.",
        visual: RuleVisual(
            source: Part(systemImage: "thermometer.medium", german: "Ich bin erkältet,", role: "the problem"),
            target: Part(systemImage: "briefcase.fill", german: "trotzdem gehe ich", marked: "trotzdem", role: "it happens anyway"),
            sentence: "Ich bin erkältet, trotzdem gehe ich.",
            columns: ["reason", "contrast"],
            rows: [
                Row(label: "verb last", cells: ["weil, da", "obwohl"], marked: [1]),
                Row(label: "verb next", cells: ["deshalb, darum", "trotzdem"], marked: [1]),
                Row(label: "nothing moves", cells: ["denn", "aber"]),
                Row(label: "+ genitive", cells: ["wegen", "trotz"])
            ]
        ),
        exam: [
            .gap(.easy, "Er hat den Job bekommen, ___ er keine Erfahrung hat.", options: ["obwohl", "weil", "denn"], answer: 0,
                 why: "No experience, yet he got the job: a contrast, obwohl."),
            .gap(.medium, "Das Wetter war schlecht. ___ sind wir ans Meer gefahren, ___ wir Urlaub hatten.", prompt: "Fill both gaps.",
                 options: ["Trotzdem … weil", "Obwohl … weil", "Trotzdem … denn"], answer: 0,
                 why: "trotzdem takes position 1, so the verb comes next. weil sends its verb to the end; after denn nothing moves."),
            .build("Although the flat is small, we're taking it.",
                   words: ["nehmen", "Obwohl", "sie", "die Wohnung", "ist,", "klein", "wir", "Trotzdem"],
                   answers: ["Obwohl die Wohnung klein ist, nehmen wir sie"],
                   why: "After obwohl the verb goes to the end. The clause is position 1, so the main clause starts with its verb.")
        ]
    )

    static let b2Result = GrammarRule(
        id: "b2-konsekutiv", level: .b2, title: "Results: sodass, so …, dass",
        place: "Weather warning", systemImage: "snowflake",
        german: "Es hat so stark geschneit, dass die Schulen geschlossen bleiben.",
        english: "It snowed so heavily that the schools are staying closed.",
        tiles: [Tile(text: "Es hat"), Tile(text: "so", role: .key), Tile(text: "stark geschneit,"), Tile(text: "dass", role: .key),
                Tile(text: "die Schulen geschlossen"), Tile(text: "bleiben.", role: .end)],
        notice: "„so“ goes before the adjective, „dass“ starts the result, and its verb goes to the end.",
        rule: "A result: sodass, or so + adjective …, dass, with the verb at the end. Too much for a result: zu + adjective, "
            + "um … zu: Er ist zu müde, um zu fahren.",
        visual: RuleVisual(
            source: Part(systemImage: "snowflake", german: "so viel Schnee,", marked: "so", role: "the cause"),
            target: Part(systemImage: "xmark.circle.fill", german: "dass die Schule ausfällt", marked: "dass", role: "the result"),
            sentence: "So viel Schnee, dass die Schule ausfällt.",
            columns: ["the verb", "example"],
            rows: [
                Row(label: "sodass", cells: ["last", "…, sodass wir zu spät kamen."]),
                Row(label: "so …, dass", cells: ["last", "so müde, dass ich einschlief"]),
                Row(label: "deshalb, also", cells: ["next", "…, also bleiben wir hier."]),
                Row(label: "zu …, um zu", cells: ["infinitive", "zu müde, um zu fahren"])
            ]
        ),
        exam: [
            .gap(.easy, "Der Zug hatte Verspätung, ___ ich den Anschluss verpasst habe.", options: ["sodass", "obwohl", "damit"],
                 answer: 0,
                 why: "Missing the connection is the result of the delay: sodass."),
            .gap(.medium, "Die Musik war ___ laut, ___ wir nichts verstanden haben.", prompt: "Fill both gaps.",
                 options: ["so … dass", "zu … um", "so … als"], answer: 0,
                 why: "so + adjective, then dass with the result: so laut, dass …"),
            .build("He is too tired to drive.", prompt: "Build the sentence. Two tiles are left over.",
                   words: ["um", "Er ist", "so müde,", "zu fahren", "zu müde,", "fahren"],
                   answers: ["Er ist zu müde, um zu fahren"],
                   why: "Too much to do something: zu + adjective, then um … zu + infinitive.")
        ]
    )

    static let b2Condition = GrammarRule(
        id: "b2-konditional", level: .b2, title: "Conditions and contrasts: falls, sofern, während",
        place: "Email from a hotel", systemImage: "bed.double",
        german: "Falls Sie später ankommen, geben Sie uns bitte Bescheid.",
        english: "If you arrive later, please let us know.",
        tiles: [Tile(text: "Falls", role: .key), Tile(text: "Sie später"), Tile(text: "ankommen,", role: .end),
                Tile(text: "geben", role: .verb), Tile(text: "Sie uns bitte Bescheid.")],
        notice: "„falls“ is a condition that may or may not happen. Its verb goes to the end, and the main clause starts with its verb.",
        rule: "Conditions: wenn, falls (in case), sofern (provided that), es sei denn (unless). "
            + "A contrast between two things: während or wohingegen, verb last: Ich trinke Tee, während er Kaffee trinkt.",
        visual: RuleVisual(
            source: Part(systemImage: "cloud.rain.fill", german: "Falls es regnet,", marked: "Falls", role: "the condition"),
            target: Part(systemImage: "umbrella.fill", german: "nimm einen Schirm mit", role: "what follows"),
            sentence: "Falls es regnet, nimm einen Schirm mit.",
            columns: ["means", "example"],
            rows: [
                Row(label: "falls", cells: ["in case", "falls es regnet"]),
                Row(label: "sofern", cells: ["provided that", "sofern du Zeit hast"]),
                Row(label: "es sei denn", cells: ["unless", "…, es sei denn, es regnet."], marked: [1]),
                Row(label: "während", cells: ["whereas", "während er Tee trinkt"])
            ]
        ),
        exam: [
            .gap(.easy, "___ du Hilfe brauchst, ruf mich an.", options: ["Falls", "Obwohl", "Während"], answer: 0,
                 why: "In case you need help: falls."),
            .gap(.medium, "Mein Bruder liebt die Berge, ___ ich lieber ans Meer ___.", prompt: "Fill both gaps.",
                 options: ["während … fahre", "falls … fahre", "während … fahren"], answer: 0,
                 why: "Two things set against each other: während, with the verb at the end, fahre for ich."),
            .build("We'll come tomorrow, unless it rains.",
                   words: ["regnet", "Wir kommen", "es sei denn,", "morgen,", "es", "falls"],
                   answers: ["Wir kommen morgen, es sei denn, es regnet"],
                   why: "After „es sei denn,“ the clause keeps main-clause order: es regnet.")
        ]
    )

    static let b2Means = GrammarRule(
        id: "b2-modalsatz", level: .b2, title: "How: indem, dadurch, dass",
        place: "Tips on a website", systemImage: "lightbulb",
        german: "Sie können Energie sparen, indem Sie die Heizung nachts herunterdrehen.",
        english: "You can save energy by turning the heating down at night.",
        tiles: [Tile(text: "Sie können Energie sparen,"), Tile(text: "indem", role: .key), Tile(text: "Sie die Heizung nachts"),
                Tile(text: "herunterdrehen.", role: .end)],
        notice: "„indem“ says how you do it. In English that's „by …ing“.",
        rule: "indem, or dadurch …, dass, says how something is done, with the verb at the end. "
            + "It answers Wie? With dadurch …, dass, dadurch stays in the main clause: Ich lerne dadurch, dass ich übe.",
        visual: RuleVisual(
            source: Part(systemImage: "lightbulb.fill", german: "indem Sie das Licht ausmachen", marked: "indem", role: "how?"),
            target: Part(systemImage: "leaf.fill", german: "Energie sparen", role: "the goal reached"),
            sentence: "Energie sparen, indem Sie das Licht ausmachen.",
            columns: ["the verb", "example"],
            rows: [
                Row(label: "indem", cells: ["last", "…, indem ich übe."], marked: [0]),
                Row(label: "dadurch, dass", cells: ["last", "Ich lerne dadurch, dass ich übe."], marked: [0]),
                Row(label: "so, dadurch", cells: ["next", "Ich übe, dadurch lerne ich."])
            ]
        ),
        exam: [
            .gap(.easy, "Man lernt eine Sprache, ___ man viel spricht.", options: ["indem", "damit", "obwohl"], answer: 0,
                 why: "How you learn: by speaking a lot, indem."),
            .gap(.medium, "Er hat abgenommen, ___ er jeden Tag zur Arbeit ___ ist.", prompt: "Fill both gaps.",
                 options: ["indem … gelaufen", "damit … gelaufen", "indem … laufen"], answer: 0,
                 why: "How he lost weight: indem. The Perfekt of laufen in the clause: gelaufen ist."),
            .build("You can help me by tidying up.", prompt: "Build the sentence. Two tiles are left over.",
                   words: ["aufräumst", "Du kannst", "indem", "damit", "mir helfen,", "du", "räumst auf"],
                   answers: ["Du kannst mir helfen, indem du aufräumst"],
                   why: "After indem the verb goes to the end, and a separable verb stays in one piece there: aufräumst.")
        ]
    )

    static let b2Infinitive = GrammarRule(
        id: "b2-infinitiv", level: .b2, title: "The infinitive with or without zu",
        place: "Message from a friend", systemImage: "message",
        german: "Ich habe vergessen, dich anzurufen. Kann ich dich später anrufen?",
        english: "I forgot to call you. Can I call you later?",
        tiles: [Tile(text: "Ich habe vergessen, dich"), Tile(text: "anzurufen.", role: .end), Tile(text: "Kann", role: .verb),
                Tile(text: "ich dich später"), Tile(text: "anrufen?", role: .key)],
        notice: "After „vergessen“ the infinitive takes „zu“. After „kann“ it doesn't.",
        rule: "No zu after modal verbs, werden, lassen, bleiben, gehen and lernen. zu after most other verbs (versuchen, "
            + "vergessen, anfangen), after nouns (Lust, Zeit) and adjectives (Es ist schwer, …). "
            + "Separable verbs take it inside: anzurufen.",
        visual: RuleVisual(
            source: Part(systemImage: "2.circle.fill", german: "Ich kann kommen.", role: "modal verb: no zu"),
            target: Part(systemImage: "arrow.right.to.line", german: "Ich versuche zu kommen.", marked: "zu", role: "other verbs: zu"),
            sentence: "Ich kann kommen. Ich versuche zu kommen.",
            columns: ["zu?", "example"],
            rows: [
                Row(label: "können, gehen", cells: ["no", "Ich gehe einkaufen."]),
                Row(label: "versuchen", cells: ["yes", "Ich versuche zu schlafen."], marked: [0]),
                Row(label: "Lust, Zeit", cells: ["yes", "Hast du Lust zu tanzen?"], marked: [0]),
                Row(label: "anrufen", cells: ["inside", "anzurufen"], marked: [1])
            ],
            isLinked: false
        ),
        exam: [
            .gap(.easy, "Ich habe keine Zeit, heute ___.", options: ["zu kochen", "kochen", "gekocht"], answer: 0,
                 why: "After a noun like Zeit, the infinitive takes zu."),
            .gap(.medium, "Er lernt Gitarre ___ und versucht, jeden Tag ___.", prompt: "Fill both gaps.",
                 options: ["spielen … zu üben", "zu spielen … üben", "zu spielen … zu üben"], answer: 0,
                 why: "lernen takes no zu: spielen lernen. versuchen takes zu: zu üben."),
            .build("It's hard to get up early.", prompt: "Build the sentence. Two tiles are left over.",
                   words: ["schwer,", "aufzustehen", "Es ist", "zu aufstehen", "früh", "aufstehen"],
                   answers: ["Es ist schwer, früh aufzustehen"],
                   why: "After an adjective like schwer, the infinitive takes zu. aufstehen is separable, so zu goes inside: aufzustehen.")
        ]
    )
}
