//
//  MockRules+B1Clauses.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The B1 rules, part 2: clauses inside a sentence, and the connectors that
/// link two ideas.
extension MockRules {
    static let b1IndirectQuestions = GrammarRule(
        id: "b1-indirekte-frage", level: .b1, title: "Indirect questions: Wissen Sie, wo …?",
        place: "At the town hall", systemImage: "building.columns",
        german: "Können Sie mir sagen, wo das Bürgeramt ist?",
        english: "Can you tell me where the citizens' office is?",
        tiles: [Tile(text: "Können Sie mir sagen,"), Tile(text: "wo", role: .key), Tile(text: "das Bürgeramt"),
                Tile(text: "ist?", role: .end)],
        notice: "The direct question is „Wo ist das Bürgeramt?“. Inside the polite sentence, „ist“ moves to the end.",
        rule: "A question inside a sentence keeps its question word, or takes ob for a yes/no question, "
            + "and its verb goes to the end. It sounds more polite.",
        visual: RuleVisual(
            source: Part(systemImage: "questionmark.bubble.fill", german: "Wo ist der Bahnhof?", marked: "ist", role: "direct"),
            target: Part(systemImage: "text.bubble.fill", german: "Wissen Sie, wo der Bahnhof ist?", marked: "ist",
                         role: "polite, inside a sentence"),
            sentence: "Wo ist der Bahnhof? Wissen Sie, wo der Bahnhof ist?",
            columns: ["direct", "inside a sentence"],
            rows: [
                Row(label: "W-question", cells: ["Wann kommt er?", "…, wann er kommt"], marked: [1]),
                Row(label: "yes / no", cells: ["Kommt er?", "…, ob er kommt"], marked: [1])
            ]
        ),
        exam: [
            .gap(.easy, "Weißt du, ___?", hint: "Wann beginnt der Film?",
                 options: ["wann beginnt der Film", "wann der Film beginnt", "der Film wann beginnt"], answer: 1,
                 why: "Inside the sentence the verb goes to the end: wann der Film beginnt."),
            .gap(.medium, "Ich möchte wissen, ___ Sie am Montag ___.", prompt: "Fill both gaps.", hint: "Haben Sie am Montag Zeit?",
                 options: ["ob … Zeit haben", "wenn … Zeit haben", "ob … haben Zeit"], answer: 0,
                 why: "A yes/no question takes ob, not wenn, and its verb goes to the end: ob Sie am Montag Zeit haben."),
            .build("Can you tell me how much the ticket costs?",
                   words: ["kostet", "Können Sie mir sagen,", "ob", "die Fahrkarte", "wie viel"],
                   answers: ["Können Sie mir sagen, wie viel die Fahrkarte kostet"],
                   why: "The question word „wie viel“ stays, and „kostet“ goes to the end. „ob“ is only for yes/no questions.")
        ]
    )

    static let b1RelativeClauses = GrammarRule(
        id: "b1-relativsatz", level: .b1, title: "Relative clauses: der Mann, der …",
        place: "Looking for a flat", systemImage: "house",
        german: "Ich suche eine Wohnung, die einen Balkon hat.",
        english: "I'm looking for a flat that has a balcony.",
        tiles: [Tile(text: "Ich suche eine Wohnung,"), Tile(text: "die", role: .key), Tile(text: "einen Balkon"),
                Tile(text: "hat.", role: .end)],
        notice: "„die“ points back to „die Wohnung“. In the relative clause the verb goes to the end.",
        rule: "A relative clause describes a noun. Its pronoun takes the noun's gender and its own role in the clause: "
            + "der, die, das, plural die, and den for a masculine object.",
        visual: RuleVisual(
            source: Part(systemImage: "figure.stand", german: "der Mann", role: "the noun"),
            target: Part(systemImage: "text.bubble.fill", german: "den ich kenne", marked: "den", role: "described"),
            sentence: "der Mann, den ich kenne",
            columns: ["masc.", "fem.", "neut.", "plural"],
            rows: [
                Row(label: "Who does it?", cells: ["der", "die", "das", "die"]),
                Row(label: "What? Whom?", cells: ["den", "die", "das", "die"], marked: [0])
            ]
        ),
        exam: [
            .gap(.easy, "Das ist der Kollege, ___ aus Spanien kommt.", hint: "der Kollege", options: ["der", "den", "die"],
                 answer: 0, why: "„der Kollege“ is masculine, and he is the one who comes: der."),
            .gap(.medium, "Der Film, ___ wir gestern gesehen haben, war super.", hint: "der Film", options: ["der", "den", "dem"],
                 answer: 1, why: "We saw the film, so in the relative clause it is the object: der becomes den."),
            .build("The woman who lives next door is a doctor.",
                   words: ["ist", "Die Frau,", "wohnt,", "den", "Ärztin", "die", "nebenan"],
                   answers: ["Die Frau, die nebenan wohnt, ist Ärztin"],
                   why: "„die Frau“ is feminine and does the living: die. The relative clause ends with its verb, "
                       + "then the main verb follows: wohnt, ist.")
        ]
    )

    static let b1RelativeClausesDative = GrammarRule(
        id: "b1-relativsatz-dativ", level: .b1, title: "Relative clauses 2: dem, mit dem, wo",
        place: "A colleague at work", systemImage: "briefcase",
        german: "Das ist die Kollegin, mit der ich das Projekt mache.",
        english: "This is the colleague I'm doing the project with.",
        tiles: [Tile(text: "Das ist die Kollegin,"), Tile(text: "mit der", role: .key), Tile(text: "ich das Projekt"),
                Tile(text: "mache.", role: .end)],
        notice: "It's „mit“ + dative, so „die Kollegin“ becomes „mit der“. The preposition opens the relative clause.",
        rule: "In the dative the relative pronouns are dem, der, dem and plural denen. A preposition goes in front "
            + "of the pronoun, and a place can take wo.",
        visual: RuleVisual(
            source: Part(systemImage: "person.fill", german: "die Kollegin", role: "the noun"),
            target: Part(systemImage: "person.2.fill", german: "mit der ich arbeite", marked: "mit der", role: "with whom?"),
            sentence: "die Kollegin, mit der ich arbeite",
            columns: ["masc.", "fem.", "neut.", "plural"],
            rows: [
                Row(label: "To whom?", cells: ["dem", "der", "dem", "denen"], marked: [3]),
                Row(label: "with", cells: ["mit dem", "mit der", "mit dem", "mit denen"], marked: [3])
            ]
        ),
        exam: [
            .gap(.easy, "Das ist der Mann, ___ ich geholfen habe.", hint: "der Mann · helfen + dative",
                 options: ["den", "dem", "der"], answer: 1,
                 why: "helfen takes the dative, so masculine der becomes dem."),
            .gap(.medium, "Die Freunde, mit ___ ich Urlaub mache, wohnen in München.", hint: "die Freunde",
                 options: ["denen", "den", "die"], answer: 0,
                 why: "mit takes the dative, and in the plural the relative pronoun is „denen“, not „den“."),
            .build("The town where I live is small.",
                   words: ["klein", "in der", "Die Stadt,", "wohne,", "in die", "ist", "ich"],
                   answers: ["Die Stadt, in der ich wohne, ist klein"],
                   why: "Living somewhere answers „Wo?“: in + dative, so „die Stadt“ becomes „in der“. "
                       + "You can also say „wo ich wohne“.")
        ]
    )

    static let b1TwoPartConnectors = GrammarRule(
        id: "b1-doppelkonnektoren", level: .b1, title: "entweder … oder, weder … noch",
        place: "Planning a holiday", systemImage: "airplane",
        german: "Wir fahren entweder nach Italien oder nach Spanien.",
        english: "We're going either to Italy or to Spain.",
        tiles: [Tile(text: "Wir fahren"), Tile(text: "entweder", role: .key), Tile(text: "nach Italien"),
                Tile(text: "oder", role: .key), Tile(text: "nach Spanien.")],
        notice: "Two choices, and only one of them happens: „entweder … oder“.",
        rule: "Some connectors come in two parts and frame two options: entweder … oder (one of them), "
            + "weder … noch (neither), sowohl … als auch (both), nicht nur … sondern auch (not only, but also).",
        visual: RuleVisual(
            source: Part(systemImage: "cup.and.saucer.fill", german: "entweder Tee", marked: "entweder", role: "one …"),
            target: Part(systemImage: "mug.fill", german: "oder Kaffee", marked: "oder", role: "… or the other"),
            sentence: "entweder Tee oder Kaffee",
            columns: ["means"],
            rows: [
                Row(label: "entweder … oder", cells: ["one of the two"]),
                Row(label: "weder … noch", cells: ["neither of the two"], marked: [0]),
                Row(label: "sowohl … als auch", cells: ["both"]),
                Row(label: "nicht nur … sondern auch", cells: ["not only, but also"])
            ],
            isLinked: false
        ),
        exam: [
            .gap(.easy, "Ich trinke ___ Kaffee noch Tee.", options: ["weder", "entweder", "sowohl"], answer: 0,
                 why: "noch belongs to weder: neither coffee nor tea."),
            .gap(.medium, "Sie spricht ___ Englisch ___ Französisch.", prompt: "Fill both gaps.", hint: "both languages",
                 options: ["sowohl … als auch", "entweder … oder", "sowohl … oder"], answer: 0,
                 why: "Both languages: sowohl … als auch. sowohl never goes with oder."),
            .build("He is not only friendly but also funny.",
                   words: ["sondern auch", "Er ist", "als auch", "freundlich,", "lustig", "nicht nur"],
                   answers: ["Er ist nicht nur freundlich, sondern auch lustig"],
                   why: "nicht nur goes with sondern auch, and a comma comes before sondern.")
        ]
    )

    static let b1JeDesto = GrammarRule(
        id: "b1-je-desto", level: .b1, title: "je … desto: the more, the better",
        place: "At the language school", systemImage: "graduationcap",
        german: "Je mehr du sprichst, desto besser wird dein Deutsch.",
        english: "The more you speak, the better your German gets.",
        tiles: [Tile(text: "Je", role: .key), Tile(text: "mehr du"), Tile(text: "sprichst,", role: .end),
                Tile(text: "desto", role: .key), Tile(text: "besser"), Tile(text: "wird", role: .verb),
                Tile(text: "dein Deutsch.")],
        notice: "After „je“ the verb goes to the end. After „desto besser“ the verb comes straight away.",
        rule: "je + a comparative opens a clause with the verb at the end. desto (or umso) + a comparative "
            + "opens the main clause, and its verb follows at once.",
        visual: RuleVisual(
            source: Part(systemImage: "text.bubble.fill", german: "je mehr", marked: "je", role: "the more you do it …"),
            target: Part(systemImage: "chart.line.uptrend.xyaxis", german: "desto besser", marked: "desto",
                         role: "… the better it gets"),
            sentence: "je mehr, desto besser",
            columns: ["je …", "desto …"],
            rows: [
                Row(label: "the verb", cells: ["at the end", "right after"], marked: [0, 1]),
                Row(label: "for example", cells: ["je älter ich werde,", "desto ruhiger bin ich"])
            ]
        ),
        exam: [
            .gap(.easy, "Je länger ich warte, ___ nervöser werde ich.", options: ["desto", "als", "je"], answer: 0,
                 why: "je goes with desto: je länger, desto nervöser."),
            .gap(.medium, "Je früher wir ___, desto mehr Zeit ___ wir.", prompt: "Fill both gaps.", hint: "losfahren · haben",
                 options: ["losfahren … haben", "fahren los … haben", "losfahren … hat"], answer: 0,
                 why: "After je the verb goes to the end, and a separable verb joins up there: losfahren. "
                     + "After desto mehr Zeit the verb comes next: haben wir."),
            .build("The more I read, the more words I know.",
                   words: ["ich", "desto mehr", "kenne", "als", "lese,", "Wörter", "Je mehr", "ich"],
                   answers: ["Je mehr ich lese, desto mehr Wörter kenne ich"],
                   why: "After je mehr the verb goes to the end: ich lese. After desto mehr Wörter, the verb comes first: kenne ich.")
        ]
    )
}
