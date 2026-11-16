//
//  MockRules+B1Past.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The B1 rules, part 1: telling what happened, and when.
extension MockRules {
    static let b1SimplePast = GrammarRule(
        id: "b1-praeteritum", level: .b1, title: "The simple past: war, hatte, ging",
        place: "Message from a colleague", systemImage: "message",
        german: "Gestern war ich krank und konnte nicht kommen.",
        english: "Yesterday I was ill and couldn't come.",
        tiles: [Tile(text: "Gestern"), Tile(text: "war", role: .verb), Tile(text: "ich krank und"),
                Tile(text: "konnte", role: .verb), Tile(text: "nicht kommen.")],
        notice: "In speech, sein, haben and the modal verbs take the simple past: „war“ and „konnte“, not „bin gewesen“.",
        rule: "The simple past tells stories and reports. Regular verbs add -te (machte), irregular verbs change "
            + "their vowel (ging, kam). ich and er have the same form.",
        visual: RuleVisual(
            source: Part(systemImage: "clock.fill", german: "ich mache", role: "now"),
            target: Part(systemImage: "book.closed.fill", german: "ich machte", marked: "te", role: "in a story"),
            sentence: "ich mache, ich machte",
            columns: ["ich · er", "du", "wir · sie"],
            rows: [
                Row(label: "machen", cells: ["machte", "machtest", "machten"], marked: [0]),
                Row(label: "sein", cells: ["war", "warst", "waren"], marked: [0]),
                Row(label: "haben", cells: ["hatte", "hattest", "hatten"], marked: [0]),
                Row(label: "gehen", cells: ["ging", "gingst", "gingen"], marked: [0]),
                Row(label: "können", cells: ["konnte", "konntest", "konnten"], marked: [0])
            ]
        ),
        exam: [
            .gap(.easy, "Letztes Jahr ___ wir in Spanien.", hint: "sein", options: ["waren", "wart", "war"], answer: 0,
                 why: "wir takes -en in the simple past too: wir waren."),
            .gap(.medium, "Als Kind ___ ich keinen Hund, aber ich ___ immer einen haben.", prompt: "Fill both gaps.",
                 hint: "haben · wollen", options: ["hatte … wollte", "hattet … wolltet", "habte … wollte"], answer: 0,
                 why: "haben becomes hatte, wollen becomes wollte. ich has no ending of its own: ich hatte, ich wollte."),
            .build("Yesterday we went to the cinema and saw a film.",
                   words: ["sahen", "Gestern", "ins Kino", "wir", "gehten", "und", "gingen", "einen Film"],
                   answers: ["Gestern gingen wir ins Kino und sahen einen Film"],
                   why: "gehen is irregular: ging, not gehte. sehen becomes sah, so wir sahen.")
        ]
    )

    static let b1PastPerfect = GrammarRule(
        id: "b1-plusquamperfekt", level: .b1, title: "The past perfect: hatte gemacht, war gegangen",
        place: "At the station", systemImage: "tram",
        german: "Als ich ankam, war der Zug schon abgefahren.",
        english: "When I arrived, the train had already left.",
        tiles: [Tile(text: "Als ich ankam,"), Tile(text: "war", role: .verb), Tile(text: "der Zug schon"),
                Tile(text: "abgefahren.", role: .end)],
        notice: "Two things in the past: the train left first, so that part takes „war … abgefahren“.",
        rule: "For what happened before something else in the past, put haben or sein in the simple past "
            + "and the participle at the end: hatte gemacht, war gegangen.",
        visual: RuleVisual(
            source: Part(systemImage: "tram.fill", german: "Der Zug war abgefahren.", marked: "war", role: "first"),
            target: Part(systemImage: "figure.walk", german: "Ich kam an.", role: "then"),
            sentence: "Der Zug war abgefahren. Dann kam ich an.",
            columns: ["Perfekt", "past perfect"],
            rows: [
                Row(label: "machen", cells: ["hat gemacht", "hatte gemacht"], marked: [1]),
                Row(label: "essen", cells: ["hat gegessen", "hatte gegessen"], marked: [1]),
                Row(label: "gehen", cells: ["ist gegangen", "war gegangen"], marked: [1]),
                Row(label: "ankommen", cells: ["ist angekommen", "war angekommen"], marked: [1])
            ]
        ),
        exam: [
            .gap(.easy, "Wir ___ das Essen schon bestellt, als du kamst.", options: ["hatten", "waren", "wurden"], answer: 0,
                 why: "bestellen takes haben. Before another past event, haben goes into the simple past: wir hatten bestellt."),
            .gap(.medium, "Er ___ den Schlüssel vergessen, deshalb ___ er nicht ins Haus.", prompt: "Fill both gaps.",
                 hint: "haben · können", options: ["hatte … konnte", "war … konnte", "hatte … kann"], answer: 0,
                 why: "First he forgot the key: hatte vergessen. After that, in the past, he couldn't get in: konnte."),
            .build("When we arrived, the film had already started.",
                   words: ["schon", "Als wir ankamen,", "war", "der Film", "angefangen", "hatte"],
                   answers: ["Als wir ankamen, hatte der Film schon angefangen"],
                   why: "anfangen takes haben: der Film hat angefangen. Before our arriving, hat becomes hatte. "
                       + "After the als-clause, the verb comes first.")
        ]
    )

    static let b1WennAls = GrammarRule(
        id: "b1-wenn-als", level: .b1, title: "wenn or als?",
        place: "Looking at old photos", systemImage: "photo",
        german: "Als ich klein war, wohnten wir in Köln.",
        english: "When I was little, we lived in Cologne.",
        tiles: [Tile(text: "Als", role: .key), Tile(text: "ich klein"), Tile(text: "war,", role: .end),
                Tile(text: "wohnten", role: .verb), Tile(text: "wir in Köln.")],
        notice: "Being little happened once, in the past, so it is „als“. The verb of the als-clause goes to the end.",
        rule: "als is for one time or one stretch in the past. wenn is for every time it happened, and for now and the future.",
        visual: RuleVisual(
            source: Part(systemImage: "1.circle.fill", german: "als", marked: "als", role: "once, in the past"),
            target: Part(systemImage: "arrow.triangle.2.circlepath", german: "wenn", marked: "wenn",
                         role: "every time, or now and later"),
            sentence: "als: once, in the past. wenn: every time, or now and later.",
            columns: ["once", "every time"],
            rows: [
                Row(label: "past", cells: ["als", "wenn"], marked: [0]),
                Row(label: "now · future", cells: ["wenn", "wenn"])
            ],
            isLinked: false
        ),
        exam: [
            .gap(.easy, "___ ich 18 war, machte ich den Führerschein.", options: ["Als", "Wenn", "Wann"], answer: 0,
                 why: "Being 18 happened once, in the past: als."),
            .gap(.medium, "___ ich nach Hause komme, koche ich immer Tee. Aber ___ ich gestern kam, war kein Tee da.",
                 prompt: "Fill both gaps.", options: ["Wenn … als", "Als … wenn", "Wenn … wenn"], answer: 0,
                 why: "Every time, now: wenn. Yesterday, once, in the past: als."),
            .build("When I saw him at the station yesterday, I was very happy.",
                   words: ["war", "Wenn", "ich ihn gestern", "sehr froh", "Als", "sah,", "am Bahnhof", "ich"],
                   answers: ["Als ich ihn gestern am Bahnhof sah, war ich sehr froh"],
                   why: "Yesterday happened once, so it is „als“, with its verb at the end. "
                       + "The main clause then starts with its verb: war ich.")
        ]
    )

    static let b1TimeClauses = GrammarRule(
        id: "b1-zeitsaetze", level: .b1, title: "bevor, nachdem, während, seit",
        place: "Instructions for the washing machine", systemImage: "doc.text",
        german: "Bevor Sie die Maschine starten, schließen Sie bitte die Tür.",
        english: "Before you start the machine, please close the door.",
        tiles: [Tile(text: "Bevor", role: .key), Tile(text: "Sie die Maschine"), Tile(text: "starten,", role: .end),
                Tile(text: "schließen", role: .verb), Tile(text: "Sie bitte die Tür.")],
        notice: "„Bevor“ sends its verb to the end. The main clause then starts with its own verb: „schließen Sie“.",
        rule: "bevor: the other part comes first. nachdem: this part came first, in an earlier tense. "
            + "während: at the same time. seit: since then, and still now.",
        visual: RuleVisual(
            source: Part(systemImage: "fork.knife", german: "nachdem ich gegessen habe", marked: "nachdem", role: "first"),
            target: Part(systemImage: "figure.walk", german: "gehe ich spazieren", role: "then"),
            sentence: "Nachdem ich gegessen habe, gehe ich spazieren.",
            columns: ["when?", "for example"],
            rows: [
                Row(label: "bevor", cells: ["before", "bevor ich gehe"]),
                Row(label: "nachdem", cells: ["after", "nachdem ich\ngegessen habe"], marked: [1]),
                Row(label: "während", cells: ["at the same time", "während ich esse"]),
                Row(label: "seit", cells: ["since, still now", "seit ich hier bin"])
            ]
        ),
        exam: [
            .gap(.easy, "Ich putze mir die Zähne, ___ ich ins Bett gehe.", options: ["bevor", "nachdem", "seit"], answer: 0,
                 why: "Teeth first, bed second: bevor ich ins Bett gehe."),
            .gap(.medium, "___ er in Berlin ___, spricht er viel besser Deutsch.", prompt: "Fill both gaps.", hint: "wohnen",
                 options: ["Seit … wohnt", "Nachdem … wohnt", "Seit … gewohnt hat"], answer: 0,
                 why: "It started in the past and is still true: seit, with the present tense."),
            .build("After I had eaten, I went for a walk.",
                   words: ["ging", "Nachdem", "spazieren", "ich", "hatte,", "Bevor", "gegessen", "ich"],
                   answers: ["Nachdem ich gegessen hatte, ging ich spazieren"],
                   why: "Eating came first: nachdem, with the past perfect for the earlier part. "
                       + "Then the main clause starts with its verb: ging ich.")
        ]
    )
}
