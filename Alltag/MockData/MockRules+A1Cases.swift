//
//  MockRules+A1Cases.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The A1 rules, part 4: the dative and the prepositions. The accusative is
/// in `MockRules+Accusative.swift`.
extension MockRules {
    static let dative = GrammarRule(
        id: "dativ", level: .a1, title: "The dative: dem, der, den",
        place: "At the hotel reception", systemImage: "key",
        german: "Ich gebe dem Gast den Schlüssel.",
        english: "I give the guest the key.",
        tiles: [Tile(text: "Ich"), Tile(text: "gebe", role: .verb), Tile(text: "dem", role: .end), Tile(text: "Gast"),
                Tile(text: "den Schlüssel.")],
        notice: "The key is what I give: accusative. The guest is the one who gets it: dative, „dem Gast“.",
        rule: "The person who gets something or is helped takes the dative: der and das become dem, die becomes der, "
            + "and the plural takes den and an -n on the noun.",
        visual: RuleVisual(
            source: Part(systemImage: "figure.stand", german: "die Frau", role: "Who does it?", name: "Nominative"),
            verb: "hilft",
            target: Part(systemImage: "figure.walk", german: "dem Mann", marked: "dem", role: "To whom?", name: "Dative"),
            sentence: "Die Frau hilft dem Mann.",
            columns: ["masc.", "fem.", "neut.", "plural"],
            rows: [
                Row(label: "Who does it?", cells: ["der\nein", "die\neine", "das\nein", "die\n–"]),
                Row(label: "To whom?", cells: ["dem\neinem", "der\neiner", "dem\neinem", "den … -n\n–"], marked: [0, 1, 2, 3])
            ]
        ),
        exam: [
            .gap(.easy, "Ich helfe ___ Mann.", hint: "der Mann", options: ["den", "dem", "der"], answer: 1,
                 why: "„helfen“ takes the dative, and der becomes dem: Ich helfe dem Mann."),
            .gap(.medium, "Das Auto gehört ___ Frau, und das Fahrrad gehört ___ Kind.", prompt: "Fill both gaps.",
                 hint: "die Frau · das Kind", options: ["der … dem", "die … das", "dem … der"], answer: 0,
                 why: "„gehören“ takes the dative: die becomes der, and das becomes dem."),
            .build("I give the children a ball.", prompt: "Build the sentence. Two tiles are left over.",
                   words: ["einen Ball", "den", "Ich", "Kindern", "gebe", "die", "Kinder"],
                   answers: ["Ich gebe den Kindern einen Ball"],
                   why: "The children get the ball: dative. In the plural that is „den“ and an extra -n: den Kindern.")
        ]
    )

    static let whereDative = GrammarRule(
        id: "wo-dativ", level: .a1, title: "Wo? in, an, auf with the dative",
        place: "Looking for the phone", systemImage: "iphone",
        german: "Wo ist mein Handy? — Es liegt auf dem Tisch.",
        english: "Where is my phone? — It's on the table.",
        tiles: [Tile(text: "Es liegt"), Tile(text: "auf", role: .key), Tile(text: "dem", role: .end), Tile(text: "Tisch.")],
        notice: "The question is „Wo?“, so the place takes the dative: „auf dem Tisch“.",
        rule: "After in, an, auf, unter, über, vor, hinter, neben and zwischen, a place that answers „Wo?“ takes the dative. "
            + "in dem becomes im, and an dem becomes am.",
        visual: RuleVisual(
            source: Part(systemImage: "iphone", german: "das Handy", role: "What?"),
            verb: "liegt auf",
            target: Part(systemImage: "table.furniture.fill", german: "dem Tisch", marked: "dem", role: "Wo?", name: "Dative"),
            sentence: "Das Handy liegt auf dem Tisch.",
            columns: ["masc.", "fem.", "neut."],
            rows: [
                Row(label: "in", cells: ["im Park", "in der Küche", "im Kino"], marked: [0, 1, 2]),
                Row(label: "an", cells: ["am Bahnhof", "an der Wand", "am Fenster"], marked: [0, 1, 2]),
                Row(label: "auf", cells: ["auf dem Tisch", "auf der Straße", "auf dem Sofa"], marked: [0, 1, 2])
            ]
        ),
        exam: [
            .gap(.easy, "Die Milch ist ___ Kühlschrank.", hint: "der Kühlschrank", options: ["im", "in der", "in den"], answer: 0,
                 why: "Wo? takes the dative: in dem Kühlschrank, and in dem is shortened to im."),
            .gap(.medium, "Die Kinder spielen ___ Park, und die Mutter wartet ___ Haltestelle.", prompt: "Fill both gaps.",
                 hint: "der Park · die Haltestelle", options: ["im … an der", "in der … am", "im … am"], answer: 0,
                 why: "der Park → in dem = im Park. die Haltestelle → an der Haltestelle; am is only for der and das."),
            .build("The keys are on the table in the kitchen.",
                   words: ["in der", "Die Schlüssel", "Küche", "auf dem", "liegen", "Tisch", "auf den"],
                   answers: ["Die Schlüssel liegen auf dem Tisch in der Küche", "Die Schlüssel liegen in der Küche auf dem Tisch"],
                   why: "Both places answer „Wo?“: auf dem Tisch, in der Küche. „auf den“ would be the accusative.")
        ]
    )

    static let fixedPrepositions = GrammarRule(
        id: "praepositionen", level: .a1, title: "mit, zu, für, ohne: prepositions with a fixed case",
        place: "Message from a friend", systemImage: "message",
        german: "Ich komme mit dem Bus, aber ohne meinen Bruder.",
        english: "I'm coming by bus, but without my brother.",
        tiles: [Tile(text: "Ich komme"), Tile(text: "mit", role: .key), Tile(text: "dem Bus", role: .end), Tile(text: "aber"),
                Tile(text: "ohne", role: .key), Tile(text: "meinen Bruder", role: .end)],
        notice: "„mit“ always takes the dative: „dem Bus“. „ohne“ always takes the accusative: „meinen Bruder“.",
        rule: "Some prepositions always take the same case. Dative: aus, bei, mit, nach, seit, von, zu. "
            + "Accusative: für, ohne, durch, gegen, um.",
        visual: RuleVisual(
            source: Part(systemImage: "bus.fill", german: "mit dem Bus", marked: "dem", role: "mit + dative"),
            target: Part(systemImage: "gift.fill", german: "für den Freund", marked: "den", role: "für + accusative"),
            sentence: "Mit dem Bus. Für den Freund.",
            columns: ["masc.", "fem.", "neut."],
            rows: [
                Row(label: "mit · bei · von", cells: ["dem", "der", "dem"], marked: [0, 1, 2]),
                Row(label: "zu", cells: ["zum", "zur", "zum"], marked: [0, 1, 2]),
                Row(label: "für · ohne", cells: ["den", "die", "das"], marked: [0])
            ],
            isLinked: false
        ),
        exam: [
            .gap(.easy, "Ich fahre mit ___ Auto.", hint: "das Auto", options: ["das", "dem", "den"], answer: 1,
                 why: "„mit“ always takes the dative, and das becomes dem: mit dem Auto."),
            .gap(.medium, "Das Geschenk ist ___ Vater, und ich gehe jetzt ___ Arzt.", prompt: "Fill both gaps.",
                 hint: "der Vater · der Arzt", options: ["für den … zum", "für dem … zum", "für den … zu den"], answer: 0,
                 why: "„für“ takes the accusative: für den Vater. „zu“ takes the dative: zu dem Arzt, shortened to zum."),
            .build("After work I go to the doctor without my husband.",
                   words: ["zum Arzt", "gehe", "Nach der Arbeit", "ohne", "ich", "meinen Mann", "meinem Mann"],
                   answers: ["Nach der Arbeit gehe ich ohne meinen Mann zum Arzt", "Nach der Arbeit gehe ich zum Arzt ohne meinen Mann"],
                   why: "„ohne“ takes the accusative: ohne meinen Mann. „meinem“ is the dative, which „mit“ would take.")
        ]
    )

    static let timePrepositions = GrammarRule(
        id: "zeit", level: .a1, title: "Time: um, am, im",
        place: "At the doctor's reception", systemImage: "calendar",
        german: "Ihr Termin ist am Montag um 9 Uhr.",
        english: "Your appointment is on Monday at 9 o'clock.",
        tiles: [Tile(text: "Ihr Termin ist"), Tile(text: "am", role: .key), Tile(text: "Montag"), Tile(text: "um", role: .key),
                Tile(text: "9 Uhr.")],
        notice: "Days take „am“, and clock times take „um“.",
        rule: "um for clock times, am for days and parts of the day, im for months and seasons. von … bis gives a span.",
        visual: RuleVisual(
            source: Part(systemImage: "clock.fill", german: "um 9 Uhr", marked: "um", role: "a clock time"),
            target: Part(systemImage: "calendar", german: "am Montag", marked: "am", role: "a day"),
            sentence: "Um 9 Uhr. Am Montag.",
            columns: ["for", "example"],
            rows: [
                Row(label: "um", cells: ["clock times", "um 9 Uhr"], marked: [1]),
                Row(label: "am", cells: ["days, parts of the day", "am Montag, am Abend"], marked: [1]),
                Row(label: "im", cells: ["months, seasons", "im Mai, im Winter"], marked: [1]),
                Row(label: "von … bis", cells: ["a span", "von 8 bis 12 Uhr"], marked: [1])
            ],
            isLinked: false
        ),
        exam: [
            .gap(.easy, "Der Kurs beginnt ___ 18 Uhr.", options: ["am", "um", "im"], answer: 1,
                 why: "A clock time takes um: um 18 Uhr."),
            .gap(.medium, "___ Sommer fahren wir ___ Wochenende oft an den See.", prompt: "Fill both gaps.",
                 options: ["Im … am", "Am … im", "Um … am"], answer: 0,
                 why: "Seasons take im: im Sommer. Days take am, and so does the weekend: am Wochenende."),
            .build("On Friday I work from eight to four.", prompt: "Build the sentence. Start with the day. One tile is left over.",
                   words: ["bis vier", "ich", "Am Freitag", "von acht", "arbeite", "Im Freitag"],
                   answers: ["Am Freitag arbeite ich von acht bis vier"],
                   why: "A day takes am: am Freitag. It is in position 1, so the verb follows and then „ich“.")
        ]
    )
}
