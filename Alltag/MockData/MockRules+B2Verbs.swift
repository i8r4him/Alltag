//
//  MockRules+B2Verbs.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The B2 rules, part 5: what verbs take, and the past tenses.
extension MockRules {
    static let b2VerbCases = GrammarRule(
        id: "b2-verb-kasus", level: .b2, title: "Verbs with the dative, the accusative or both",
        place: "At the doctor's", systemImage: "stethoscope",
        german: "Der Arzt hat mir geraten, mehr Wasser zu trinken.",
        english: "The doctor advised me to drink more water.",
        tiles: [Tile(text: "Der Arzt hat"), Tile(text: "mir", role: .end), Tile(text: "geraten,", role: .key),
                Tile(text: "mehr Wasser zu trinken.")],
        notice: "„raten“ takes the dative: the doctor advises „mir“, not „mich“.",
        rule: "Most verbs take the accusative. Some take only the dative: helfen, danken, gefallen, gehören, gratulieren, raten, "
            + "antworten, passen. Giving verbs take both: jemandem etwas geben, schicken, zeigen, erklären.",
        visual: RuleVisual(
            source: Part(systemImage: "person.fill", german: "Ich helfe dir.", marked: "dir", role: "dative only"),
            target: Part(systemImage: "gift.fill", german: "Ich gebe dir das Buch.", marked: "das Buch", role: "dative + accusative"),
            sentence: "Ich helfe dir. Ich gebe dir das Buch.",
            columns: ["takes", "example"],
            rows: [
                Row(label: "fragen, anrufen", cells: ["accusative", "Ich frage dich."]),
                Row(label: "helfen, danken", cells: ["dative", "Ich danke dir."], marked: [0]),
                Row(label: "geben, zeigen", cells: ["dative + accusative", "Ich zeige dir den Weg."])
            ],
            isLinked: false
        ),
        exam: [
            .gap(.easy, "Kannst du ___ helfen?", options: ["mich", "mir", "ich"], answer: 1,
                 why: "helfen takes the dative: mir."),
            .gap(.medium, "Ich rufe ___ morgen an und gratuliere ___ zum Geburtstag.", prompt: "Fill both gaps.", hint: "er",
                 options: ["ihn … ihm", "ihm … ihn", "ihm … ihm"], answer: 0,
                 why: "anrufen takes the accusative: ihn. gratulieren takes the dative: ihm."),
            .build("The jacket doesn't fit me, but it suits you.",
                   words: ["mir", "Die Jacke", "nicht,", "dir", "passt", "aber sie steht", "mich"],
                   answers: ["Die Jacke passt mir nicht, aber sie steht dir"],
                   why: "passen and stehen (to suit) both take the dative: mir, dir.")
        ]
    )

    static let b2VerbPrepositions = GrammarRule(
        id: "b2-verb-praeposition", level: .b2, title: "Verbs with a fixed preposition",
        place: "Job interview", systemImage: "briefcase",
        german: "Ich interessiere mich sehr für diese Stelle.",
        english: "I'm very interested in this position.",
        tiles: [Tile(text: "Ich"), Tile(text: "interessiere mich", role: .verb), Tile(text: "sehr"), Tile(text: "für", role: .key),
                Tile(text: "diese Stelle.", role: .end)],
        notice: "„sich interessieren“ always goes with „für“ + accusative. Learn the verb and its preposition together.",
        rule: "Many verbs come with a fixed preposition and case: warten auf + accusative, denken an + accusative, "
            + "teilnehmen an + dative, sich kümmern um + accusative. Ask about things with wo(r) + preposition: Worauf wartest du?",
        visual: RuleVisual(
            source: Part(systemImage: "hourglass", german: "warten auf", marked: "auf", role: "verb + preposition"),
            target: Part(systemImage: "bus.fill", german: "auf den Bus", marked: "den", role: "+ accusative", name: "Accusative"),
            sentence: "Ich warte auf den Bus.",
            columns: ["case", "example"],
            rows: [
                Row(label: "warten auf", cells: ["accusative", "auf den Bus"]),
                Row(label: "denken an", cells: ["accusative", "an meine Mutter"]),
                Row(label: "teilnehmen an", cells: ["dative", "an dem Kurs"], marked: [0]),
                Row(label: "sprechen mit", cells: ["dative", "mit dem Chef"], marked: [0]),
                Row(label: "sich kümmern um", cells: ["accusative", "um die Kinder"])
            ]
        ),
        exam: [
            .gap(.easy, "Ich warte schon seit einer Stunde ___ dich.", options: ["auf", "für", "an"], answer: 0,
                 why: "The verb is „warten auf“ + accusative: auf dich."),
            .gap(.medium, "Er denkt oft ___ seine Kindheit und träumt ___ einem Haus am Meer.", prompt: "Fill both gaps.",
                 options: ["an … von", "auf … über", "an … an"], answer: 0,
                 why: "„denken an“ + accusative: an seine Kindheit. „träumen von“ + dative: von einem Haus."),
            .build("We're looking forward to the holidays.", prompt: "Build the sentence. Two tiles are left over.",
                   words: ["über die Ferien", "uns", "Wir", "auf die Ferien", "freuen", "an die Ferien"],
                   answers: ["Wir freuen uns auf die Ferien"],
                   why: "„sich freuen auf“ is for something still to come. „sich freuen über“ is for something that's already here.")
        ]
    )

    static let b2NounPrepositions = GrammarRule(
        id: "b2-nomen-praeposition", level: .b2, title: "Nouns and adjectives with a fixed preposition",
        place: "Feedback at work", systemImage: "hand.thumbsup",
        german: "Wir sind sehr zufrieden mit Ihrer Arbeit.",
        english: "We're very happy with your work.",
        tiles: [Tile(text: "Wir sind sehr"), Tile(text: "zufrieden", role: .verb), Tile(text: "mit", role: .key),
                Tile(text: "Ihrer Arbeit.", role: .end)],
        notice: "„zufrieden“ always takes „mit“ + dative.",
        rule: "Many adjectives and nouns have a fixed preposition too: stolz auf, zufrieden mit, Angst vor, Lust auf, Interesse an. "
            + "A noun doesn't always keep its verb's: sich interessieren für, but das Interesse an.",
        visual: RuleVisual(
            source: Part(systemImage: "star.fill", german: "stolz auf", marked: "auf", role: "adjective + preposition"),
            target: Part(systemImage: "person.2.fill", german: "auf meine Kinder", marked: "meine", role: "+ accusative",
                         name: "Accusative"),
            sentence: "Ich bin stolz auf meine Kinder.",
            columns: ["case", "example"],
            rows: [
                Row(label: "stolz auf", cells: ["accusative", "stolz auf dich"]),
                Row(label: "zufrieden mit", cells: ["dative", "zufrieden mit dem Ergebnis"], marked: [0]),
                Row(label: "Angst vor", cells: ["dative", "Angst vor Hunden"], marked: [0]),
                Row(label: "Lust auf", cells: ["accusative", "Lust auf Pizza"]),
                Row(label: "Interesse an", cells: ["dative", "Interesse an Kunst"], marked: [0])
            ]
        ),
        exam: [
            .gap(.easy, "Hast du Lust ___ einen Kaffee?", options: ["auf", "für", "an"], answer: 0,
                 why: "„Lust haben auf“ + accusative: Lust auf einen Kaffee."),
            .gap(.medium, "Sie ist verheiratet ___ einem Italiener und hat Angst ___ dem Fliegen.", prompt: "Fill both gaps.",
                 options: ["mit … vor", "an … vor", "mit … von"], answer: 0,
                 why: "„verheiratet mit“ and „Angst vor“ both take the dative."),
            .build("My son is afraid of dogs.", prompt: "Build the sentence. Two tiles are left over.",
                   words: ["vor Hunden", "Angst", "Mein Sohn", "für Hunde", "hat", "von Hunden"],
                   answers: ["Mein Sohn hat Angst vor Hunden"],
                   why: "The noun is „Angst vor“ + dative. „von“ and „für“ don't go with Angst.")
        ]
    )

    static let b2PastForms = GrammarRule(
        id: "b2-vergangenheit-formen", level: .b2, title: "Forming the past: ging, hatte gemacht",
        place: "Reading a novel", systemImage: "book",
        german: "Als wir ankamen, hatte der Film schon angefangen.",
        english: "When we arrived, the film had already started.",
        tiles: [Tile(text: "Als wir"), Tile(text: "ankamen,", role: .verb), Tile(text: "hatte", role: .verb),
                Tile(text: "der Film schon"), Tile(text: "angefangen.", role: .end)],
        notice: "„ankamen“ is the Präteritum. „hatte angefangen“ is the Plusquamperfekt: it happened even earlier.",
        rule: "Regular verbs take -te: machte, gemacht. Irregular verbs change their vowel: ging, gegangen; fand, gefunden. "
            + "Mixed verbs do both: brachte, gebracht; dachte, gedacht. Plusquamperfekt: hatte or war + participle.",
        visual: RuleVisual(
            source: Part(systemImage: "1.circle.fill", german: "hatte angefangen", marked: "hatte", role: "earlier"),
            target: Part(systemImage: "2.circle.fill", german: "wir kamen an", marked: "kamen", role: "then"),
            sentence: "Der Film hatte angefangen. Dann kamen wir an.",
            columns: ["Präteritum", "Perfekt"],
            rows: [
                Row(label: "machen", cells: ["machte", "hat gemacht"]),
                Row(label: "gehen", cells: ["ging", "ist gegangen"], marked: [0]),
                Row(label: "finden", cells: ["fand", "hat gefunden"], marked: [0]),
                Row(label: "bringen", cells: ["brachte", "hat gebracht"], marked: [0]),
                Row(label: "denken", cells: ["dachte", "hat gedacht"], marked: [0])
            ]
        ),
        exam: [
            .gap(.easy, "Gestern ___ ich lange im Büro.", hint: "bleiben", options: ["blieb", "bleibte", "geblieben"], answer: 0,
                 why: "bleiben is irregular: the simple past is blieb."),
            .gap(.medium, "Nachdem er ___ ___, ging er ins Bett.", prompt: "Fill both gaps.", hint: "essen",
                 options: ["gegessen … hatte", "gegessen … war", "gegesst … hatte"], answer: 0,
                 why: "Plusquamperfekt: hatte + participle. essen takes haben, and its participle is gegessen."),
            .build("She thought of her brother and brought him a cake.",
                   words: ["brachte", "Sie", "an ihren Bruder", "ihm einen Kuchen", "dachte", "und", "denkte"],
                   answers: ["Sie dachte an ihren Bruder und brachte ihm einen Kuchen"],
                   why: "denken and bringen are mixed verbs: the vowel changes and they take -te: dachte, brachte.")
        ]
    )

    static let b2DoubleInfinitive = GrammarRule(
        id: "b2-perfekt-modal", level: .b2, title: "Perfekt with two infinitives: habe gehen müssen",
        place: "Message from a friend", systemImage: "message",
        german: "Tut mir leid, ich habe gestern länger arbeiten müssen.",
        english: "Sorry, I had to work late yesterday.",
        tiles: [Tile(text: "Tut mir leid, ich"), Tile(text: "habe", role: .verb), Tile(text: "gestern länger"),
                Tile(text: "arbeiten müssen.", role: .end)],
        notice: "No „gemusst“: with another verb, the modal verb stays an infinitive at the end: „arbeiten müssen“.",
        rule: "A modal verb with another verb takes its Perfekt with haben and two infinitives at the end: ich habe gehen müssen. "
            + "lassen works the same way. In a dass-clause, habe goes before the two: dass ich habe gehen müssen.",
        visual: RuleVisual(
            source: Part(systemImage: "2.circle.fill", german: "habe", marked: "habe", role: "Position 2"),
            target: Part(systemImage: "arrow.right.to.line", german: "gehen müssen", marked: "müssen", role: "The end: two infinitives"),
            sentence: "Ich habe gehen müssen.",
            columns: ["alone", "with a verb"],
            rows: [
                Row(label: "müssen", cells: ["habe gemusst", "habe gehen müssen"], marked: [1]),
                Row(label: "können", cells: ["habe gekonnt", "habe kommen können"], marked: [1]),
                Row(label: "lassen", cells: ["habe gelassen", "habe reparieren lassen"], marked: [1]),
                Row(label: "after dass", cells: ["dass ich es gemusst habe", "dass ich habe gehen müssen"], marked: [1])
            ]
        ),
        exam: [
            .gap(.easy, "Ich habe gestern nicht kommen ___.", options: ["gekonnt", "können", "gekommen"], answer: 1,
                 why: "With another verb, können stays an infinitive in the Perfekt: kommen können."),
            .gap(.medium, "Er hat sein Auto reparieren ___, weil er es nicht selbst hat reparieren ___.", prompt: "Fill both gaps.",
                 options: ["lassen … können", "gelassen … gekonnt", "lassen … gekonnt"], answer: 0,
                 why: "With another verb, lassen and können stay infinitives. In the weil-clause „hat“ goes before the two."),
            .build("I had to wait for an hour.",
                   words: ["müssen", "Ich", "warten", "eine Stunde", "habe", "gemusst"],
                   answers: ["Ich habe eine Stunde warten müssen"],
                   why: "With warten, the modal verb stays an infinitive: warten müssen, not gemusst.")
        ]
    )

    static let b2PastUse = GrammarRule(
        id: "b2-vergangenheit", level: .b2, title: "Which past to use",
        place: "Newspaper article", systemImage: "newspaper",
        german: "Der Bürgermeister eröffnete gestern das neue Schwimmbad.",
        english: "Yesterday the mayor opened the new swimming pool.",
        tiles: [Tile(text: "Der Bürgermeister"), Tile(text: "eröffnete", role: .verb), Tile(text: "gestern das neue Schwimmbad.")],
        notice: "The news is written, so it uses the Präteritum: „eröffnete“. Telling a friend, you'd say „hat eröffnet“.",
        rule: "Speaking: the Perfekt, except sein, haben and the modal verbs, which use the Präteritum (war, hatte, musste). "
            + "Writing stories and reports: the Präteritum. For what happened before that: the Plusquamperfekt.",
        visual: RuleVisual(
            source: Part(systemImage: "bubble.left.fill", german: "hat eröffnet", marked: "hat", role: "spoken"),
            target: Part(systemImage: "newspaper.fill", german: "eröffnete", marked: "eröffnete", role: "written"),
            sentence: "Spoken: hat eröffnet. Written: eröffnete.",
            columns: ["spoken", "written"],
            rows: [
                Row(label: "most verbs", cells: ["ich habe gelesen", "ich las"]),
                Row(label: "sein, haben", cells: ["ich war, ich hatte", "ich war, ich hatte"], marked: [0]),
                Row(label: "modal verbs", cells: ["ich musste", "ich musste"], marked: [0])
            ],
            isLinked: false
        ),
        exam: [
            .gap(.easy, "Wo ___ du gestern? Ich habe dich angerufen.", options: ["warst", "bist", "wärst"], answer: 0,
                 why: "Even in speech, sein uses the Präteritum: Wo warst du?"),
            .gap(.medium, "Gestern ___ ich keine Zeit, deshalb bin ich nicht ___.", prompt: "You're telling a friend. Fill both gaps.",
                 options: ["hatte … gekommen", "hatte … kam", "habe … gekommen"], answer: 0,
                 why: "haben uses the Präteritum even in speech: hatte. kommen uses the Perfekt: bin gekommen."),
            .build("When I arrived, everyone had already left.", prompt: "Build it as in a story. One tile is left over.",
                   words: ["waren", "Als", "schon gegangen", "ich", "alle", "ankam,", "hatten"],
                   answers: ["Als ich ankam, waren alle schon gegangen"],
                   why: "They left before I arrived: Plusquamperfekt. gehen takes sein, so waren … gegangen.")
        ]
    )
}
