//
//  MockRules+A2Objects.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The A2 rules, part 2: pronouns and the people and things a verb takes.
extension MockRules {
    static let a2Pronouns = GrammarRule(
        id: "a2-pronomen", level: .a2, title: "mich or mir? Pronouns in the accusative and dative",
        place: "Message from a friend", systemImage: "message",
        german: "Kannst du mich anrufen? Ich erkläre dir alles.",
        english: "Can you call me? I'll explain everything to you.",
        tiles: [Tile(text: "Kannst du"), Tile(text: "mich", role: .end), Tile(text: "anrufen? Ich erkläre"),
                Tile(text: "dir", role: .end), Tile(text: "alles.")],
        notice: "„anrufen“ takes the accusative: mich. With „erklären“ you get the explanation, so you take the dative: dir.",
        rule: "Pronouns change with the case too: ich → mich → mir, du → dich → dir, er → ihn → ihm, sie → sie → ihr.",
        visual: RuleVisual(
            source: Part(systemImage: "eye.fill", german: "Ich sehe ihn.", marked: "ihn", role: "Whom?", name: "Accusative"),
            target: Part(systemImage: "gift.fill", german: "Ich helfe ihm.", marked: "ihm", role: "To whom?", name: "Dative"),
            sentence: "Ich sehe ihn. Ich helfe ihm.",
            columns: ["Akk.", "Dat."],
            rows: [
                Row(label: "ich", cells: ["mich", "mir"], marked: [0, 1]),
                Row(label: "du", cells: ["dich", "dir"], marked: [0, 1]),
                Row(label: "er", cells: ["ihn", "ihm"], marked: [0, 1]),
                Row(label: "sie", cells: ["sie", "ihr"], marked: [1]),
                Row(label: "wir", cells: ["uns", "uns"], marked: [0, 1]),
                Row(label: "ihr", cells: ["euch", "euch"], marked: [0, 1]),
                Row(label: "sie · Sie", cells: ["sie · Sie", "ihnen · Ihnen"], marked: [1])
            ],
            isLinked: false
        ),
        exam: [
            .gap(.easy, "Ich liebe ___.", hint: "du", options: ["dich", "dir", "du"], answer: 0,
                 why: "„lieben“ takes the accusative: du becomes dich."),
            .gap(.medium, "Das ist Herr Kaya. Ich kenne ___ gut und schreibe ___ oft.", prompt: "Fill both gaps.",
                 options: ["ihn … ihm", "ihm … ihn", "ihn … ihn"], answer: 0,
                 why: "„kennen“ takes the accusative: ihn. You write to him, so he takes the dative: ihm."),
            .build("Give me your number, I'll call you.", prompt: "Build the sentence. Two tiles are left over.",
                   words: ["dich", "mich", "Gib", "rufe", "deine Nummer,", "dir", "an", "ich", "mir"],
                   answers: ["Gib mir deine Nummer, ich rufe dich an"],
                   why: "You get the number, so you take the dative: mir. „anrufen“ takes the accusative: dich.")
        ]
    )

    static let a2DativeVerbs = GrammarRule(
        id: "a2-dativ-verben", level: .a2, title: "gefallen, schmecken, passen: verbs with the dative",
        place: "In a clothes shop", systemImage: "tshirt",
        german: "Die Jacke gefällt mir, aber sie passt mir nicht.",
        english: "I like the jacket, but it doesn't fit me.",
        tiles: [Tile(text: "Die Jacke"), Tile(text: "gefällt", role: .verb), Tile(text: "mir", role: .end), Tile(text: "aber sie"),
                Tile(text: "passt", role: .verb), Tile(text: "mir", role: .end), Tile(text: "nicht.")],
        notice: "In German the jacket does the pleasing: „Die Jacke gefällt mir“. The person who likes it takes the dative.",
        rule: "Some verbs always take the dative: gefallen, schmecken, passen, gehören, helfen, danken. "
            + "With gefallen and schmecken the thing is the subject, and the person takes the dative.",
        visual: RuleVisual(
            source: Part(systemImage: "tshirt.fill", german: "die Jacke", role: "What pleases?", name: "Nominative"),
            verb: "gefällt",
            target: Part(systemImage: "figure.stand", german: "mir", marked: "mir", role: "Whom?", name: "Dative"),
            sentence: "Die Jacke gefällt mir.",
            columns: ["means", "in a sentence"],
            rows: [
                Row(label: "gefallen", cells: ["to like", "Das gefällt mir."], marked: [1]),
                Row(label: "schmecken", cells: ["to taste good", "Schmeckt es dir?"], marked: [1]),
                Row(label: "passen", cells: ["to fit, to suit", "Passt dir 8 Uhr?"], marked: [1]),
                Row(label: "gehören", cells: ["to belong to", "Das gehört ihm."], marked: [1]),
                Row(label: "danken", cells: ["to thank", "Ich danke Ihnen."], marked: [1])
            ]
        ),
        exam: [
            .gap(.easy, "Die Suppe schmeckt ___ sehr gut.", hint: "ich", options: ["mich", "mir", "ich"], answer: 1,
                 why: "„schmecken“ takes the dative: the soup tastes good to me, mir."),
            .gap(.medium, "Die Schuhe ___ meiner Schwester.", hint: "gefallen", options: ["gefällt", "gefallen", "gefällst"], answer: 1,
                 why: "The shoes do the pleasing, and there are several: die Schuhe gefallen. Your sister takes the dative."),
            .build("Do you like the city?", prompt: "Build the question. Two tiles are left over.",
                   words: ["du", "die Stadt", "Gefällst", "dir", "Gefällt"],
                   answers: ["Gefällt dir die Stadt"],
                   why: "The city does the pleasing, so the verb goes with it: gefällt. You are the one it pleases: dir.")
        ]
    )

    static let a2TwoObjects = GrammarRule(
        id: "a2-zwei-objekte", level: .a2, title: "Giving: the person in the dative, the thing in the accusative",
        place: "A birthday", systemImage: "gift",
        german: "Ich schenke meiner Mutter Blumen. Ich gebe sie ihr morgen.",
        english: "I'm giving my mother flowers. I'll give them to her tomorrow.",
        tiles: [Tile(text: "Ich schenke"), Tile(text: "meiner Mutter", role: .end), Tile(text: "Blumen. Ich gebe"),
                Tile(text: "sie", role: .key), Tile(text: "ihr", role: .end), Tile(text: "morgen.")],
        notice: "With two nouns, the person comes first. When the flowers become „sie“, the thing goes first: sie ihr.",
        rule: "geben, schenken, zeigen, bringen: the person takes the dative and the thing the accusative. "
            + "The person usually comes first, but a pronoun for the thing goes before it.",
        visual: RuleVisual(
            source: Part(systemImage: "gift.fill", german: "das Geschenk", role: "What?", name: "Accusative"),
            target: Part(systemImage: "figure.child", german: "dem Kind", marked: "dem", role: "To whom?", name: "Dative"),
            sentence: "Ich gebe dem Kind das Geschenk.",
            columns: ["first", "then"],
            rows: [
                Row(label: "two nouns", cells: ["dem Kind", "das Geschenk"]),
                Row(label: "the person as a pronoun", cells: ["ihm", "das Geschenk"]),
                Row(label: "the thing as a pronoun", cells: ["es", "dem Kind"], marked: [0]),
                Row(label: "two pronouns", cells: ["es", "ihm"], marked: [0])
            ]
        ),
        exam: [
            .gap(.easy, "Ich bringe ___ einen Kaffee.", hint: "du", options: ["dir", "dich", "du"], answer: 0,
                 why: "You get the coffee, so you take the dative: dir. The coffee is the accusative: einen Kaffee."),
            .gap(.medium, "Wo ist mein Buch? — Ich habe ___ gegeben.", hint: "das Buch · dein Bruder",
                 options: ["es deinem Bruder", "deinem Bruder es", "es deinen Bruder"], answer: 0,
                 why: "The book is now a pronoun, es, so it comes first. Your brother gets it: dative, deinem Bruder."),
            .build("I'll show it to you tomorrow.",
                   words: ["morgen", "es", "dich", "zeige", "Ich", "dir"],
                   answers: ["Ich zeige es dir morgen"],
                   why: "With two pronouns the thing comes first: es dir. You are the one it is shown to: dative, dir.")
        ]
    )

    static let a2Reflexive = GrammarRule(
        id: "a2-reflexiv", level: .a2, title: "sich freuen, sich anziehen: reflexive verbs",
        place: "In the morning", systemImage: "alarm",
        german: "Ich ziehe mich schnell an und wasche mir die Hände.",
        english: "I get dressed quickly and wash my hands.",
        tiles: [Tile(text: "Ich ziehe"), Tile(text: "mich", role: .end), Tile(text: "schnell an und wasche"),
                Tile(text: "mir", role: .end), Tile(text: "die Hände.")],
        notice: "„sich anziehen“: I dress myself, so mich. With the hands in the sentence, I take the dative: mir die Hände.",
        rule: "Reflexive verbs come with sich, which is the same person as the subject: ich → mich, du → dich, er/sie → sich. "
            + "If a thing is in the sentence too, ich and du take mir and dir.",
        visual: RuleVisual(
            source: Part(systemImage: "person.fill", german: "ich", role: "Who?"),
            verb: "wasche",
            target: Part(systemImage: "arrow.uturn.backward.circle.fill", german: "mich", marked: "mich", role: "the same person"),
            sentence: "Ich wasche mich.",
            columns: ["alone", "with a thing"],
            rows: [
                Row(label: "ich", cells: ["mich", "mir"], marked: [1]),
                Row(label: "du", cells: ["dich", "dir"], marked: [1]),
                Row(label: "er · sie · es", cells: ["sich", "sich"]),
                Row(label: "wir", cells: ["uns", "uns"]),
                Row(label: "ihr", cells: ["euch", "euch"]),
                Row(label: "sie · Sie", cells: ["sich", "sich"])
            ]
        ),
        exam: [
            .gap(.easy, "Ich freue ___ auf das Wochenende.", options: ["mich", "mir", "sich"], answer: 0,
                 why: "The pronoun is the same person as the subject: ich freue mich."),
            .gap(.medium, "Wir treffen ___ um acht, und Paul putzt ___ noch schnell die Zähne.", prompt: "Fill both gaps.",
                 options: ["uns … sich", "uns … ihm", "sich … sich"], answer: 0,
                 why: "wir takes uns. Paul is er, and er always takes sich, with a thing too."),
            .build("I'm brushing my teeth.", prompt: "Build the sentence. Two tiles are left over.",
                   words: ["die Zähne", "mich", "Ich", "meine", "mir", "putze"],
                   answers: ["Ich putze mir die Zähne"],
                   why: "With a thing in the sentence, the person takes the dative: mir. German says „die Zähne“, not „meine“.")
        ]
    )
}
