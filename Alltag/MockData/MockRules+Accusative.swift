//
//  MockRules+Accusative.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The first rule in the new shape: one line of rule, a picture of what it
/// means with a tiny table, and an exam of three questions. Written for the
/// app; the other rules follow once this one is approved.
extension MockRules {
    static let accusative = GrammarRule(
        id: "akkusativ", level: .a1, title: "The accusative: der becomes den",
        place: "At the bakery", systemImage: "storefront",
        german: "Ich nehme den Apfelkuchen, bitte.", english: "I'll take the apple cake, please.",
        tiles: [Tile(text: "Ich"), Tile(text: "nehme", role: .key), Tile(text: "den", role: .end),
                Tile(text: "Apfelkuchen"), Tile(text: "bitte")],
        notice: "It is „der Apfelkuchen“. Here the cake is what you take, so „der“ becomes „den“.",
        rule: "The person or thing the action is done to takes the accusative. "
            + "Only masculine changes: der → den, ein → einen.",
        pattern: [Slot(label: "Subject"), Slot(label: "Verb", emphasis: .verb), Slot(label: "den / einen …", emphasis: .end)],
        taskPrompt: "Say: \"Today I'll have a salad and a soup.\"",
        taskWords: ["einen", "Suppe", "nehme", "Heute", "und", "ich", "Salat", "eine"],
        taskAnswers: accusativeSentences,
        visual: accusativeVisual,
        exam: accusativeExam
    )

    private static let accusativeSentences = [
        "Heute nehme ich einen Salat und eine Suppe",
        "Heute nehme ich eine Suppe und einen Salat"
    ]

    private static let accusativeVisual = RuleVisual(
        from: RuleVisual.Part(systemImage: "figure.stand", german: "der Mann",
                              role: "Who does it?", name: "Nominative"),
        verb: "trinkt",
        to: RuleVisual.Part(systemImage: "cup.and.saucer.fill", german: "den Kaffee", marked: "den",
                            role: "What?", name: "Accusative"),
        sentence: "Der Mann trinkt den Kaffee.",
        columns: ["masc.", "fem.", "neut.", "plural"],
        rows: [
            RuleVisual.Row(label: "Who does it?", cells: ["der\nein", "die\neine", "das\nein", "die\n–"]),
            RuleVisual.Row(label: "What?", cells: ["den\neinen", "die\neine", "das\nein", "die\n–"], marked: [0])
        ]
    )

    private static let accusativeExam = [
        ExamQuestion(
            difficulty: .easy, prompt: "Fill the gap.",
            sentence: "Ich trinke ___ Kaffee.", hint: "der Kaffee",
            kind: .choice(options: ["der", "den", "dem"], answer: 1),
            explanation: "The coffee is what you drink, so it takes the accusative. „der Kaffee“ is masculine: der → den."
        ),
        ExamQuestion(
            difficulty: .medium, prompt: "Fill both gaps.",
            sentence: "Wir brauchen ___ Lampe und ___ Tisch.", hint: "die Lampe · der Tisch",
            kind: .choice(options: ["eine … ein", "einen … einen", "eine … einen"], answer: 2),
            explanation: "Both are things you need, but only masculine changes. "
                + "„die Lampe“ keeps „eine“, „der Tisch“ takes „einen“."
        ),
        ExamQuestion(
            difficulty: .hard, prompt: "Build the sentence. One tile is left over.",
            sentence: "Today I'll have a salad and a soup.",
            kind: .build(words: ["eine", "Salat", "nehme", "ein", "Heute", "und", "ich", "Suppe", "einen"],
                         answers: accusativeSentences),
            explanation: "„der Salat“ is masculine, so it is „einen Salat“. „die Suppe“ keeps „eine“. "
                + "And with „Heute“ first, the verb is still second."
        )
    ]
}
