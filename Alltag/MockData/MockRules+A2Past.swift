//
//  MockRules+A2Past.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The A2 rules, part 1: talking about the past.
extension MockRules {
    static let a2PerfectHaben = GrammarRule(
        id: "a2-perfekt-haben", level: .a2, title: "The past with haben: ich habe … gemacht",
        place: "Monday at work", systemImage: "briefcase",
        german: "Am Wochenende habe ich meine Eltern besucht.",
        english: "At the weekend I visited my parents.",
        tiles: [Tile(text: "Am Wochenende"), Tile(text: "habe", role: .verb), Tile(text: "ich meine Eltern"),
                Tile(text: "besucht.", role: .end)],
        notice: "„habe“ sits in position 2, and „besucht“ waits at the very end. Together they say it is over.",
        rule: "To talk about the past, put haben in position 2 and the participle at the very end. Most verbs take haben.",
        visual: RuleVisual(
            source: Part(systemImage: "2.circle.fill", german: "habe", marked: "habe", role: "Position 2: haben"),
            target: Part(systemImage: "arrow.right.to.line", german: "gekocht", marked: "gekocht", role: "The end: the participle"),
            sentence: "Ich habe gestern gekocht.",
            columns: ["1", "2", "…", "end"],
            rows: [
                Row(label: "Subject first", cells: ["Ich", "habe", "gestern", "gekocht"], marked: [1, 3]),
                Row(label: "Time first", cells: ["Gestern", "habe", "ich", "gekocht"], marked: [1, 3]),
                Row(label: "Question", cells: ["Was", "hast", "du", "gekocht?"], marked: [1, 3])
            ]
        ),
        exam: [
            .gap(.easy, "Du ___ gestern lange gearbeitet.", options: ["habe", "hast", "hat"], answer: 1,
                 why: "haben changes with the person, and du takes hast: Du hast … gearbeitet."),
            .gap(.medium, "Wir ___ am Samstag Pizza ___.", prompt: "Fill both gaps.", hint: "essen",
                 options: ["haben … gegessen", "haben … essen", "gegessen … haben"], answer: 0,
                 why: "haben takes position 2 and the participle goes to the very end: Wir haben … gegessen."),
            .build("What did you buy yesterday?",
                   words: ["gekauft", "du", "Was", "gestern", "kaufst", "hast"],
                   answers: ["Was hast du gestern gekauft"],
                   why: "The question word takes position 1, „hast“ position 2, and the participle „gekauft“ the end.")
        ]
    )

    static let a2Participle = GrammarRule(
        id: "a2-partizip", level: .a2, title: "The participle: gemacht or geschrieben",
        place: "Message from a friend", systemImage: "message",
        german: "Ich habe dir ein Foto geschickt und eine Karte geschrieben.",
        english: "I've sent you a photo and written a card.",
        tiles: [Tile(text: "Ich habe dir ein Foto"), Tile(text: "geschickt", role: .end), Tile(text: "und eine Karte"),
                Tile(text: "geschrieben.", role: .end)],
        notice: "„schicken“ is regular: ge-schick-t. „schreiben“ is not: ge-schrieb-en, with a new vowel.",
        rule: "Regular verbs take ge- and -t (gemacht), irregular verbs ge- and -en, often with a new vowel (geschrieben). "
            + "Separable verbs put ge- after the prefix, and be-, ver- and -ieren take no ge-.",
        visual: RuleVisual(
            source: Part(systemImage: "hammer.fill", german: "machen", role: "the verb"),
            target: Part(systemImage: "checkmark.circle.fill", german: "gemacht", marked: "ge", role: "the participle"),
            sentence: "machen, gemacht",
            columns: ["verb", "participle"],
            rows: [
                Row(label: "regular", cells: ["machen", "gemacht"], marked: [1]),
                Row(label: "irregular", cells: ["schreiben", "geschrieben"], marked: [1]),
                Row(label: "separable", cells: ["einkaufen", "eingekauft"], marked: [1]),
                Row(label: "be- · ver-", cells: ["bezahlen", "bezahlt"], marked: [1]),
                Row(label: "-ieren", cells: ["telefonieren", "telefoniert"], marked: [1])
            ]
        ),
        exam: [
            .gap(.easy, "Wir haben gestern Fußball ___.", hint: "spielen", options: ["gespielt", "gespielen", "spielt"], answer: 0,
                 why: "„spielen“ is regular: ge- and -t, gespielt."),
            .gap(.medium, "Ich habe im Supermarkt ___ und mit Karte ___.", prompt: "Fill both gaps.", hint: "einkaufen · bezahlen",
                 options: ["eingekauft … bezahlt", "geeinkauft … gebezahlt", "eingekauft … gebezahlt"], answer: 0,
                 why: "A separable verb puts ge- after its prefix: eingekauft. A verb with be- takes no ge-: bezahlt."),
            .build("I read the book and understood it.", prompt: "Build the sentence. Two tiles are left over.",
                   words: ["verstanden", "Ich", "gelest", "und", "habe", "das Buch", "geverstanden", "gelesen"],
                   answers: ["Ich habe das Buch gelesen und verstanden"],
                   why: "„lesen“ is irregular: gelesen. „verstehen“ starts with ver-, so it takes no ge-: verstanden.")
        ]
    )

    static let a2PerfectSein = GrammarRule(
        id: "a2-perfekt-sein", level: .a2, title: "The past with sein: ich bin gefahren",
        place: "Holiday photos", systemImage: "airplane",
        german: "Letztes Jahr sind wir nach Spanien geflogen.",
        english: "Last year we flew to Spain.",
        tiles: [Tile(text: "Letztes Jahr"), Tile(text: "sind", role: .verb), Tile(text: "wir nach Spanien"),
                Tile(text: "geflogen.", role: .end)],
        notice: "Flying takes you from A to B, so the past takes „sind“, not „haben“.",
        rule: "Verbs that move from A to B or change a state take sein: gehen, fahren, kommen, aufstehen, einschlafen. "
            + "So do sein and bleiben.",
        visual: RuleVisual(
            source: Part(systemImage: "house.fill", german: "von Köln", role: "from A"),
            verb: "bin gefahren",
            target: Part(systemImage: "building.2.fill", german: "nach Berlin", role: "to B"),
            sentence: "Ich bin von Köln nach Berlin gefahren.",
            columns: ["er · sie · es", "participle"],
            rows: [
                Row(label: "gehen", cells: ["ist", "gegangen"], marked: [0]),
                Row(label: "fahren", cells: ["ist", "gefahren"], marked: [0]),
                Row(label: "kommen", cells: ["ist", "gekommen"], marked: [0]),
                Row(label: "aufstehen", cells: ["ist", "aufgestanden"], marked: [0]),
                Row(label: "einschlafen", cells: ["ist", "eingeschlafen"], marked: [0]),
                Row(label: "bleiben", cells: ["ist", "geblieben"], marked: [0])
            ]
        ),
        exam: [
            .gap(.easy, "Ich ___ mit dem Zug nach Hamburg gefahren.", options: ["habe", "bin", "ist"], answer: 1,
                 why: "Going from A to B takes sein, and ich takes bin."),
            .gap(.medium, "Er ___ um 6 Uhr aufgestanden und ___ einen Kaffee getrunken.", prompt: "Fill both gaps.",
                 options: ["ist … hat", "hat … ist", "ist … ist"], answer: 0,
                 why: "Getting up changes a state, so it takes sein: er ist aufgestanden. Drinking goes nowhere: er hat getrunken."),
            .build("Yesterday we stayed at home.",
                   words: ["zu Hause", "haben", "Gestern", "geblieben", "wir", "sind"],
                   answers: ["Gestern sind wir zu Hause geblieben"],
                   why: "„bleiben“ moves nowhere, but it takes sein all the same: wir sind geblieben.")
        ]
    )

    static let a2SimplePast = GrammarRule(
        id: "a2-praeteritum", level: .a2, title: "war, hatte, konnte: the short past",
        place: "A colleague at work", systemImage: "briefcase",
        german: "Ich war gestern krank und konnte nicht kommen.",
        english: "I was ill yesterday and couldn't come.",
        tiles: [Tile(text: "Ich"), Tile(text: "war", role: .verb), Tile(text: "gestern krank und"),
                Tile(text: "konnte", role: .verb), Tile(text: "nicht"), Tile(text: "kommen.", role: .end)],
        notice: "Nobody says „ich bin krank gewesen“ here. With sein, haben and the modal verbs, the short past is usual.",
        rule: "With sein, haben and the modal verbs, use the short past even when you speak: war, hatte, konnte, musste, wollte. "
            + "Other verbs take the past with haben or sein.",
        visual: RuleVisual(
            source: Part(systemImage: "clock.fill", german: "ich bin", marked: "bin", role: "now"),
            target: Part(systemImage: "clock.arrow.circlepath", german: "ich war", marked: "war", role: "before"),
            sentence: "ich bin, ich war",
            columns: ["sein", "haben", "können", "müssen"],
            rows: [
                Row(label: "ich · er · sie · es", cells: ["war", "hatte", "konnte", "musste"]),
                Row(label: "du", cells: ["warst", "hattest", "konntest", "musstest"]),
                Row(label: "wir · sie · Sie", cells: ["waren", "hatten", "konnten", "mussten"]),
                Row(label: "ihr", cells: ["wart", "hattet", "konntet", "musstet"])
            ]
        ),
        exam: [
            .gap(.easy, "Wo ___ du gestern Abend?", options: ["warst", "war", "wart"], answer: 0,
                 why: "du takes -st in the short past too: du warst."),
            .gap(.medium, "Wir ___ keine Zeit und ___ lange arbeiten.", prompt: "Fill both gaps.", hint: "haben · müssen",
                 options: ["hatten … mussten", "hatten … müssten", "haben … mussten"], answer: 0,
                 why: "Both are in the past: wir hatten, wir mussten. „müssten“ with ü means „would have to“."),
            .build("Yesterday I was at the doctor's and couldn't work.",
                   words: ["konnte", "Gestern", "beim Arzt", "war", "nicht", "arbeiten", "ich", "und", "kann"],
                   answers: ["Gestern war ich beim Arzt und konnte nicht arbeiten"],
                   why: "sein and können take the short past: war, konnte. „kann“ is the present.")
        ]
    )
}
