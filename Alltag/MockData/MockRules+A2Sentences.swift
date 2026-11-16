//
//  MockRules+A2Sentences.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The A2 rules, part 3: linking sentences, and where the verb goes after the link.
extension MockRules {
    static let a2AndBut = GrammarRule(
        id: "a2-und-aber", level: .a2, title: "und, aber, oder, denn: nothing moves",
        place: "Message from a friend", systemImage: "message",
        german: "Ich komme später, denn mein Bus hat Verspätung.",
        english: "I'll be late, because my bus is delayed.",
        tiles: [Tile(text: "Ich komme später,"), Tile(text: "denn", role: .key), Tile(text: "mein Bus"),
                Tile(text: "hat", role: .verb), Tile(text: "Verspätung.")],
        notice: "„denn“ doesn't count as a position. After it the sentence starts as usual: the subject, then the verb.",
        rule: "und, aber, oder and denn link two sentences and stand at position 0: after them, nothing moves.",
        visual: RuleVisual(
            source: Part(systemImage: "0.circle.fill", german: "aber", marked: "aber", role: "Position 0: the link"),
            target: Part(systemImage: "2.circle.fill", german: "habe", marked: "habe", role: "Position 2: the verb, as always"),
            sentence: "Ich will kommen, aber ich habe keine Zeit.",
            columns: ["0", "1", "2", "…"],
            rows: [
                Row(label: "and", cells: ["und", "ich", "komme", "mit"], marked: [2]),
                Row(label: "but", cells: ["aber", "ich", "habe", "keine Zeit"], marked: [2]),
                Row(label: "or", cells: ["oder", "wir", "gehen", "ins Kino"], marked: [2]),
                Row(label: "because", cells: ["denn", "ich", "bin", "müde"], marked: [2])
            ]
        ),
        exam: [
            .gap(.easy, prompt: "Which sentence is right?",
                 options: ["Ich bleibe zu Hause, denn ich bin krank.", "Ich bleibe zu Hause, denn bin ich krank.",
                           "Ich bleibe zu Hause, denn ich krank bin."], answer: 0,
                 why: "After denn nothing moves: the subject, then the verb. Ich bin krank."),
            .gap(.medium, "Ich esse kein Fleisch, ___ ich mag es nicht, ___ ich esse gern Fisch.", prompt: "Fill both gaps.",
                 options: ["denn … aber", "aber … denn", "oder … und"], answer: 0,
                 why: "denn gives the reason, and aber turns the sentence round. After both, the order stays the same."),
            .build("I'd like to come, but I have to work.",
                   words: ["arbeiten", "aber", "ich", "möchte", "Ich", "kommen,", "muss", "arbeite"],
                   answers: ["Ich möchte kommen, aber ich muss arbeiten"],
                   why: "aber is at position 0, so after it the order is as usual: ich muss. The second verb goes to the end.")
        ]
    )

    static let a2Therefore = GrammarRule(
        id: "a2-deshalb", level: .a2, title: "deshalb, trotzdem, dann: the verb comes next",
        place: "Email from work", systemImage: "at",
        german: "Der Zug fällt aus, deshalb komme ich zu spät.",
        english: "The train is cancelled, so I'll be late.",
        tiles: [Tile(text: "Der Zug fällt aus,"), Tile(text: "deshalb", role: .key), Tile(text: "komme", role: .verb),
                Tile(text: "ich zu spät.")],
        notice: "„deshalb“ takes position 1, so the verb follows straight away and „ich“ moves behind it.",
        rule: "deshalb, trotzdem, dann and danach take position 1: the verb comes right after them, and the subject behind it.",
        visual: RuleVisual(
            source: Part(systemImage: "1.circle.fill", german: "deshalb", marked: "deshalb", role: "Position 1"),
            target: Part(systemImage: "2.circle.fill", german: "bleibe", marked: "bleibe", role: "Position 2: the verb"),
            sentence: "Ich bin krank, deshalb bleibe ich zu Hause.",
            columns: ["1", "2", "3", "…"],
            rows: [
                Row(label: "so", cells: ["deshalb", "bleibe", "ich", "zu Hause"], marked: [1]),
                Row(label: "anyway", cells: ["trotzdem", "gehe", "ich", "zur Arbeit"], marked: [1]),
                Row(label: "then", cells: ["dann", "trinke", "ich", "einen Tee"], marked: [1])
            ]
        ),
        exam: [
            .gap(.easy, "Es regnet, deshalb ___ den Bus.", options: ["ich nehme", "nehme ich", "ich nehmen"], answer: 1,
                 why: "deshalb takes position 1, so the verb comes next: nehme ich."),
            .gap(.medium, "Ich bin sehr müde. ___ gehe ich heute ins Fitnessstudio.", options: ["Trotzdem", "Deshalb", "Denn"],
                 answer: 0,
                 why: "Being tired is a reason not to go, but you go anyway: trotzdem. „Denn“ couldn't stand right before the verb."),
            .build("First I'll eat, then I'll call you.",
                   words: ["dann", "ich", "Zuerst", "an", "rufe", "ich,", "anrufe", "dich", "esse"],
                   answers: ["Zuerst esse ich, dann rufe ich dich an"],
                   why: "dann takes position 1, so the verb comes next: rufe ich. „anrufen“ still splits, and „an“ goes to the end.")
        ]
    )

    static let a2VerbAtEnd = GrammarRule(
        id: "a2-nebensatz", level: .a2, title: "weil, dass, wenn: the verb goes to the end",
        place: "At the doctor's", systemImage: "stethoscope",
        german: "Ich rufe an, weil ich einen Termin brauche.",
        english: "I'm calling because I need an appointment.",
        tiles: [Tile(text: "Ich rufe an,"), Tile(text: "weil", role: .key), Tile(text: "ich einen Termin"),
                Tile(text: "brauche.", role: .end)],
        notice: "After „weil“, the verb „brauche“ waits until the very end.",
        rule: "After weil, dass and wenn, the verb goes to the very end. A comma comes before them.",
        visual: RuleVisual(
            source: Part(systemImage: "link", german: "weil", marked: "weil", role: "the link"),
            target: Part(systemImage: "arrow.right.to.line", german: "bin", marked: "bin", role: "The end: the verb"),
            sentence: "Ich bleibe zu Hause, weil ich krank bin.",
            columns: ["link", "…", "end"],
            rows: [
                Row(label: "because", cells: ["weil", "ich krank", "bin"], marked: [2]),
                Row(label: "that", cells: ["dass", "du heute", "kommst"], marked: [2]),
                Row(label: "if, when", cells: ["wenn", "es", "regnet"], marked: [2])
            ]
        ),
        exam: [
            .gap(.easy, prompt: "Which sentence is right?",
                 options: ["Ich weiß, dass du müde bist.", "Ich weiß, dass du bist müde.", "Ich weiß, dass bist du müde."], answer: 0,
                 why: "After dass the verb goes to the very end: … dass du müde bist."),
            .gap(.medium, "Ich komme mit, ___ ich Zeit ___.", prompt: "Fill both gaps.",
                 options: ["wenn … habe", "wenn … hat", "denn … habe"], answer: 0,
                 why: "wenn sends the verb to the end: wenn ich Zeit habe. After denn the verb would come right after ich."),
            .build("I think the shop closes at eight.", prompt: "Build the sentence. Two tiles are left over.",
                   words: ["zu", "der Laden", "Ich glaube,", "zumacht", "um acht", "macht", "dass"],
                   answers: ["Ich glaube, dass der Laden um acht zumacht"],
                   why: "After dass the verb goes to the end, and a separable verb joins up again there: zumacht.")
        ]
    )

    static let a2Particles = GrammarRule(
        id: "a2-partikeln", level: .a2, title: "denn, mal, doch: small words that make it friendly",
        place: "At a friend's door", systemImage: "door.left.hand.open",
        german: "Was machst du denn hier? Komm doch mal rein!",
        english: "What are you doing here? Do come in!",
        tiles: [Tile(text: "Was machst du"), Tile(text: "denn", role: .key), Tile(text: "hier? Komm"),
                Tile(text: "doch", role: .key), Tile(text: "mal", role: .key), Tile(text: "rein!")],
        notice: "Leave out „denn“, „doch“ and „mal“ and the meaning stays. They make the question curious and the invitation warm.",
        rule: "denn makes a question sound interested, mal makes a request casual, and doch makes it warmer. "
            + "As an answer, „Doch!“ says yes to a question with nicht.",
        visual: RuleVisual(
            source: Part(systemImage: "bubble.left.fill", german: "Komm rein!", role: "plain, a bit strict"),
            target: Part(systemImage: "face.smiling", german: "Komm doch mal rein!", marked: "doch mal", role: "warm and friendly"),
            sentence: "Komm rein! Komm doch mal rein!",
            columns: ["used in", "example"],
            rows: [
                Row(label: "denn", cells: ["questions", "Wie heißt du denn?"], marked: [1]),
                Row(label: "mal", cells: ["requests", "Warte mal!"], marked: [1]),
                Row(label: "doch", cells: ["requests, advice", "Setz dich doch!"], marked: [1]),
                Row(label: "Doch!", cells: ["answers", "Kommst du nicht? — Doch!"], marked: [1])
            ]
        ),
        exam: [
            .gap(.easy, "Kommst du nicht mit? — ___, ich komme mit!", options: ["Doch", "Ja", "Nein"], answer: 0,
                 why: "The question has nicht. To say yes to it, German says „Doch!“."),
            .gap(.medium, "Wie spät ist es ___? — Keine Ahnung. Schau ___ auf dein Handy!", prompt: "Fill both gaps.",
                 options: ["denn … mal", "mal … denn", "doch … denn"], answer: 0,
                 why: "denn goes in questions and makes them sound interested. mal makes a request casual."),
            .build("Do wait a moment!", prompt: "Build the sentence. Two tiles are left over.",
                   words: ["mal", "Wartest", "einen Moment", "doch", "denn", "Warte"],
                   answers: ["Warte doch mal einen Moment"],
                   why: "doch and mal often come together, doch first. denn only goes in questions.")
        ]
    )
}
