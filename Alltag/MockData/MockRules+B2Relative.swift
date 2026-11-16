//
//  MockRules+B2Relative.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The B2 rules, part 10: dass or zu, goals, and relative clauses.
extension MockRules {
    static let b2DassOrZu = GrammarRule(
        id: "b2-dass-zu", level: .b2, title: "dass or zu?",
        place: "Job application", systemImage: "doc.text",
        german: "Ich freue mich, Sie bald kennenzulernen.",
        english: "I'm looking forward to meeting you soon.",
        tiles: [Tile(text: "Ich", role: .key), Tile(text: "freue mich, Sie bald"), Tile(text: "kennenzulernen.", role: .end)],
        notice: "The one who is glad and the one who meets are both „ich“, so the zu-infinitive works.",
        rule: "When both parts have the same subject, use zu + infinitive: Ich hoffe, dich zu sehen. "
            + "When the subjects differ, use dass: Ich hoffe, dass du kommst. dass always works; zu is shorter.",
        visual: RuleVisual(
            source: Part(systemImage: "person.fill", german: "Ich hoffe, dich zu sehen.", marked: "zu", role: "the same person"),
            target: Part(systemImage: "person.2.fill", german: "Ich hoffe, dass du kommst.", marked: "dass", role: "two people"),
            sentence: "Ich hoffe, dich zu sehen. Ich hoffe, dass du kommst.",
            columns: ["subjects", "say"],
            rows: [
                Row(label: "ich … ich", cells: ["the same", "Ich versuche, pünktlich zu sein."], marked: [1]),
                Row(label: "ich … du", cells: ["different", "Ich hoffe, dass du kommst."])
            ],
            isLinked: false
        ),
        exam: [
            .gap(.easy, "Ich hoffe, ___ du bald gesund wirst.", options: ["dass", "zu", "um"], answer: 0,
                 why: "I hope, you get well: two different people, so it is dass."),
            .gap(.medium, "Wir haben beschlossen, nach Wien ___, und hoffen, ___ uns besuchst.", prompt: "Fill both gaps.",
                 options: ["zu ziehen … dass du", "ziehen … dass du", "zu ziehen … du zu"], answer: 0,
                 why: "We decide and we move: the same subject, zu ziehen. We hope and you visit: different, dass du."),
            .build("I promise to be on time.", prompt: "Build the sentence. Two tiles are left over.",
                   words: ["zu sein", "pünktlich", "dass", "Ich verspreche,", "bin"],
                   answers: ["Ich verspreche, pünktlich zu sein"],
                   why: "I promise and I'm on time: the same subject, so zu + infinitive at the end.")
        ]
    )

    static let b2Goal = GrammarRule(
        id: "b2-final", level: .b2, title: "um … zu, damit, ohne … zu, statt … zu",
        place: "Talking about your course", systemImage: "graduationcap",
        german: "Ich lerne Deutsch, um in Deutschland zu studieren.",
        english: "I'm learning German so that I can study in Germany.",
        tiles: [Tile(text: "Ich lerne Deutsch,"), Tile(text: "um", role: .key), Tile(text: "in Deutschland"),
                Tile(text: "zu studieren.", role: .end)],
        notice: "„um … zu“ gives the goal. The subject of both parts is „ich“, so no dass-clause is needed.",
        rule: "A goal: um … zu with the same subject, damit with a different one (Ich spreche langsam, damit du mich verstehst). "
            + "Something left out: ohne … zu or ohne dass. Something done instead: statt … zu or statt dass.",
        visual: RuleVisual(
            source: Part(systemImage: "book.fill", german: "Ich lerne,", role: "what I do"),
            target: Part(systemImage: "graduationcap.fill", german: "um zu studieren", marked: "um", role: "the goal"),
            sentence: "Ich lerne, um zu studieren.",
            columns: ["same subject", "different subject"],
            rows: [
                Row(label: "goal", cells: ["um … zu", "damit"], marked: [0, 1]),
                Row(label: "left out", cells: ["ohne … zu", "ohne dass"]),
                Row(label: "instead", cells: ["statt … zu", "statt dass"])
            ]
        ),
        exam: [
            .gap(.easy, "Ich spreche langsam, ___ du mich verstehst.", options: ["damit", "um", "ohne"], answer: 0,
                 why: "I speak, you understand: two different subjects, so the goal takes damit."),
            .gap(.medium, "Er ging, ___ sich zu verabschieden, und blieb zu Hause, ___ zu arbeiten.", prompt: "Fill both gaps.",
                 options: ["ohne … statt", "um … ohne", "statt … damit"], answer: 0,
                 why: "He didn't say goodbye: ohne … zu. He stayed at home and didn't work: statt … zu."),
            .build("She left without saying goodbye.", prompt: "Build the sentence. Two tiles are left over.",
                   words: ["zu verabschieden", "ohne", "Sie ist gegangen,", "damit", "sich", "verabschiedet"],
                   answers: ["Sie ist gegangen, ohne sich zu verabschieden"],
                   why: "Something left out, same subject: ohne … zu, with the infinitive at the end.")
        ]
    )

    static let b2Relative = GrammarRule(
        id: "b2-relativ", level: .b2, title: "Relative clauses: der, den, dem, denen",
        place: "Introducing a neighbour", systemImage: "house",
        german: "Das ist die Nachbarin, mit der ich oft Kaffee trinke.",
        english: "That's the neighbour I often have coffee with.",
        tiles: [Tile(text: "Das ist die Nachbarin,"), Tile(text: "mit", role: .key), Tile(text: "der", role: .end),
                Tile(text: "ich oft Kaffee"), Tile(text: "trinke.", role: .verb)],
        notice: "„mit“ takes the dative, so it is „mit der“. The preposition comes first, and the verb goes to the end.",
        rule: "A relative pronoun takes the gender of its noun and the case of its job in the clause. It looks like der, die, das, "
            + "except dative plural: denen. A preposition goes in front of it: das Haus, in dem ich wohne.",
        visual: RuleVisual(
            source: Part(systemImage: "person.fill", german: "die Frau,", role: "the noun"),
            target: Part(systemImage: "cup.and.saucer.fill", german: "mit der ich Kaffee trinke", marked: "der", role: "mit + dative"),
            sentence: "Die Frau, mit der ich Kaffee trinke.",
            columns: ["masc.", "fem.", "neut.", "plural"],
            rows: [
                Row(label: "nom.", cells: ["der", "die", "das", "die"]),
                Row(label: "acc.", cells: ["den", "die", "das", "die"], marked: [0]),
                Row(label: "dat.", cells: ["dem", "der", "dem", "denen"], marked: [3])
            ]
        ),
        exam: [
            .gap(.easy, "Das ist der Kollege, ___ ich gestern getroffen habe.", options: ["den", "der", "dem"], answer: 0,
                 why: "I met him: the accusative of a masculine noun, den."),
            .gap(.medium, "Wo sind die Leute, ___ das Auto gehört, und der Schlüssel, ___ ich gefunden habe?",
                 prompt: "Fill both gaps.", options: ["denen … den", "die … der", "denen … der"], answer: 0,
                 why: "gehören takes the dative, and the dative plural is denen. I found the key: accusative, den."),
            .build("That's the city where I was born.", prompt: "Build it with in + a relative pronoun. One tile is left over.",
                   words: ["ich", "die Stadt,", "geboren", "in der", "Das ist", "bin", "in die"],
                   answers: ["Das ist die Stadt, in der ich geboren bin"],
                   why: "Where I was born is a place, Wo?, so in takes the dative: in der. The verb goes to the end.")
        ]
    )

    static let b2RelativeGenitive = GrammarRule(
        id: "b2-relativ-genitiv", level: .b2, title: "Whose: dessen and deren",
        place: "Talking about a friend", systemImage: "person.2",
        german: "Das ist meine Freundin, deren Sohn mit mir studiert.",
        english: "That's my friend whose son is studying with me.",
        tiles: [Tile(text: "Das ist meine Freundin,"), Tile(text: "deren", role: .key), Tile(text: "Sohn mit mir"),
                Tile(text: "studiert.", role: .verb)],
        notice: "Whose son? Hers: the friend is feminine, so it is „deren“, whatever the son is.",
        rule: "whose: dessen for a masculine or neuter noun, deren for a feminine or plural one. "
            + "It depends on the noun before it, not the one after it, which takes no article.",
        visual: RuleVisual(
            source: Part(systemImage: "person.fill", german: "der Mann,", role: "masculine"),
            target: Part(systemImage: "car.fill", german: "dessen Auto rot ist", marked: "dessen", role: "whose"),
            sentence: "Der Mann, dessen Auto rot ist.",
            columns: ["whose"],
            rows: [
                Row(label: "der Mann", cells: ["dessen"], marked: [0]),
                Row(label: "das Kind", cells: ["dessen"], marked: [0]),
                Row(label: "die Frau", cells: ["deren"]),
                Row(label: "die Leute", cells: ["deren"])
            ]
        ),
        exam: [
            .gap(.easy, "Der Nachbar, ___ Hund immer bellt, ist nett.", options: ["dessen", "deren", "dem"], answer: 0,
                 why: "der Nachbar is masculine, so whose is dessen."),
            .gap(.medium, "Die Firma, ___ Chef ich kenne, sucht Leute, ___ Deutsch gut ist.", prompt: "Fill both gaps.",
                 options: ["deren … deren", "dessen … dessen", "deren … dessen"], answer: 0,
                 why: "die Firma is feminine and Leute is plural: both take deren. The noun after it doesn't matter."),
            .build("The child whose mother is ill is staying with us.",
                   words: ["Mutter", "Das Kind,", "bei uns", "dessen", "bleibt", "krank ist,", "deren"],
                   answers: ["Das Kind, dessen Mutter krank ist, bleibt bei uns"],
                   why: "whose depends on das Kind, which is neuter: dessen. The mother's gender doesn't matter.")
        ]
    )

    static let b2RelativeWas = GrammarRule(
        id: "b2-relativ-was", level: .b2, title: "Relative clauses with was, wo, wer",
        place: "In a shop", systemImage: "bag",
        german: "Das ist alles, was ich brauche.",
        english: "That's everything I need.",
        tiles: [Tile(text: "Das ist alles,"), Tile(text: "was", role: .key), Tile(text: "ich"), Tile(text: "brauche.", role: .verb)],
        notice: "After „alles“ the relative pronoun is „was“, not „das“.",
        rule: "was after alles, etwas, nichts, vieles and das, after a superlative used as a noun (das Beste, was …), "
            + "and for a whole clause. wo for places. wer for whoever: Wer zu spät kommt, muss warten.",
        visual: RuleVisual(
            source: Part(systemImage: "cart.fill", german: "alles,", role: "the word"),
            target: Part(systemImage: "checkmark.circle.fill", german: "was ich brauche", marked: "was", role: "the relative clause"),
            sentence: "Alles, was ich brauche.",
            columns: ["relative", "example"],
            rows: [
                Row(label: "alles, nichts", cells: ["was", "nichts, was hilft"], marked: [0]),
                Row(label: "das Beste", cells: ["was", "das Beste, was es gibt"], marked: [0]),
                Row(label: "a place", cells: ["wo", "die Stadt, wo ich wohne"]),
                Row(label: "whoever", cells: ["wer", "Wer fragt, lernt."])
            ]
        ),
        exam: [
            .gap(.easy, "Es gibt nichts, ___ ich lieber esse.", options: ["was", "das", "wo"], answer: 0,
                 why: "After nichts the relative pronoun is was."),
            .gap(.medium, "Er hat die Prüfung bestanden, ___ mich sehr freut, und wir feiern in Köln, ___ er wohnt.",
                 prompt: "Fill both gaps.", options: ["was … wo", "das … wo", "was … wohin"], answer: 0,
                 why: "was refers to the whole clause before it. wo is for the place where he lives."),
            .build("That was the best thing I ate in Berlin.",
                   words: ["was", "das Beste,", "in Berlin", "Das war", "ich", "gegessen habe", "das"],
                   answers: ["Das war das Beste, was ich in Berlin gegessen habe"],
                   why: "After a superlative used as a noun, das Beste, the relative pronoun is was.")
        ]
    )
}
