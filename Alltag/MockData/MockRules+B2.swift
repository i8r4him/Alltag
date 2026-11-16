//
//  MockRules+B2.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The B2 rules in the order they are learnt and open, and part 1 of them:
/// word order. The others are in the `MockRules+B2….swift` files. Every B2
/// rule's ID starts with "b2-".
extension MockRules {
    static let b2: [GrammarRule] = [
        b2WordOrder, b2Subjunctive, b2Passive, b2Prepositions, b2Verbs, b2Nouns, b2Clauses, b2Words
    ].flatMap { $0 }

    private static let b2WordOrder: [GrammarRule] = [b2VerbPosition, b2TwoObjects, b2Tekamolo, b2NearVerb, b2Nicht]
    private static let b2Subjunctive: [GrammarRule] = [b2SubjunctiveForms, b2SubjunctivePast, b2Polite, b2Unreal, b2AsIf]
    private static let b2Passive: [GrammarRule] = [b2PassiveTenses, b2PassiveModal, b2PassiveAlternatives]
    private static let b2Prepositions: [GrammarRule] = [
        b2TwoWay, b2WhereFrom, b2Outside, b2TimePrepositions, b2ReasonPrepositions, b2PrepositionAfter
    ]
    private static let b2Verbs: [GrammarRule] = [
        b2VerbCases, b2VerbPrepositions, b2NounPrepositions, b2PastForms, b2DoubleInfinitive, b2PastUse,
        b2Future, b2ModalMeaning, b2ModalGuess, b2Lassen, b2Separable
    ]
    private static let b2Nouns: [GrammarRule] = [
        b2Gender, b2NoArticle, b2Genitive, b2NDeclension, b2AdjectiveEndings, b2AdjectiveNouns,
        b2StandAlonePronouns, b2Man, b2Comparison, b2Participles, b2ReportedSpeech
    ]
    private static let b2Clauses: [GrammarRule] = [
        b2Time, b2ReasonContrast, b2Result, b2Condition, b2Means, b2Infinitive, b2DassOrZu, b2Goal,
        b2Relative, b2RelativeGenitive, b2RelativeWas
    ]
    private static let b2Words: [GrammarRule] = [
        b2Connectors, b2Negation, b2Irgend, b2Direction, b2Es, b2NounVerb, b2DaWords, b2Particles, b2Commas
    ]

    static let b2VerbPosition = GrammarRule(
        id: "b2-verbstellung", level: .b2, title: "Where the verb goes: first, second or last",
        place: "Message from a colleague", systemImage: "message",
        german: "Der Bus fällt aus, deshalb komme ich später.",
        english: "The bus is cancelled, so I'll be late.",
        tiles: [Tile(text: "Der Bus fällt aus,"), Tile(text: "deshalb", role: .key), Tile(text: "komme", role: .verb),
                Tile(text: "ich später.")],
        notice: "„deshalb“ takes position 1 of the second sentence, so the verb comes straight after it: „deshalb komme ich“.",
        rule: "The verb is second in a statement, first in a yes/no question or a request, and last after weil or dass. "
            + "After und, aber, oder and denn nothing moves; after deshalb or trotzdem the verb comes next.",
        visual: RuleVisual(
            source: Part(systemImage: "2.circle.fill", german: "deshalb komme ich", marked: "komme", role: "after deshalb: verb next"),
            target: Part(systemImage: "arrow.right.to.line", german: "weil ich komme", marked: "komme", role: "after weil: verb last"),
            sentence: "Deshalb komme ich. Weil ich komme.",
            columns: ["the verb", "example"],
            rows: [
                Row(label: "und, aber, denn", cells: ["stays second", "…, denn ich komme."]),
                Row(label: "deshalb, trotzdem", cells: ["comes next", "…, deshalb komme ich."], marked: [0]),
                Row(label: "weil, dass, ob", cells: ["goes last", "…, weil ich komme."], marked: [0]),
                Row(label: "yes/no question", cells: ["comes first", "Kommst du?"])
            ],
            isLinked: false
        ),
        exam: [
            .gap(.easy, "Ich bin müde, deshalb ___ früh ins Bett.", options: ["ich gehe", "gehe ich", "ich gehen"], answer: 1,
                 why: "„deshalb“ is position 1, so the verb comes next and „ich“ follows: deshalb gehe ich."),
            .gap(.medium, "Er kommt heute nicht, ___.", prompt: "Pick the right ending.",
                 options: ["weil er ist krank", "denn er ist krank", "denn ist er krank"], answer: 1,
                 why: "After denn nothing moves: subject, then verb. After weil the verb would go to the end: weil er krank ist."),
            .build("It's raining, so we're staying at home today.",
                   words: ["zu Hause", "deshalb", "wir", "Es regnet,", "bleiben", "heute", "weil"],
                   answers: ["Es regnet, deshalb bleiben wir heute zu Hause"],
                   why: "„deshalb“ fills position 1, so „bleiben“ comes next and „wir“ follows. "
                    + "„weil“ would send the verb to the end and turn the meaning round.")
        ]
    )

    static let b2TwoObjects = GrammarRule(
        id: "b2-dativ-akkusativ", level: .b2, title: "Two objects: who gets it, and what",
        place: "Birthday present", systemImage: "gift",
        german: "Ich schenke meiner Schwester ein Buch. Ich gebe es ihr morgen.",
        english: "I'm giving my sister a book. I'll give it to her tomorrow.",
        tiles: [Tile(text: "Ich gebe"), Tile(text: "es", role: .key), Tile(text: "ihr", role: .end), Tile(text: "morgen.")],
        notice: "With two nouns the person comes first: „meiner Schwester ein Buch“. With two pronouns it flips: „es ihr“.",
        rule: "Two nouns: the dative before the accusative. Two pronouns: the accusative before the dative. "
            + "A pronoun always comes before a noun.",
        visual: RuleVisual(
            source: Part(systemImage: "person.fill", german: "meiner Schwester", marked: "meiner", role: "Who gets it?", name: "Dative"),
            target: Part(systemImage: "book.fill", german: "ein Buch", role: "What?", name: "Accusative"),
            sentence: "Ich schenke meiner Schwester ein Buch.",
            columns: ["first", "then"],
            rows: [
                Row(label: "two nouns", cells: ["meiner Schwester", "ein Buch"]),
                Row(label: "two pronouns", cells: ["es", "ihr"], marked: [0]),
                Row(label: "pronoun and noun", cells: ["ihr", "ein Buch"], marked: [0])
            ]
        ),
        exam: [
            .gap(.easy, "Kannst du mir das Salz geben? — Ja, ich gebe ___ gleich.", options: ["dir es", "es dir", "dich es"], answer: 1,
                 why: "Two pronouns: the accusative comes first. „es“ (the salt) before „dir“."),
            .gap(.medium, "Hast du ___ den Brief gezeigt? — Ja, ich habe ___ gezeigt.", prompt: "Fill both gaps.",
                 hint: "der Chef · der Brief", options: ["dem Chef … ihn ihm", "dem Chef … ihm ihn", "den Chef … ihn ihm"], answer: 0,
                 why: "Two nouns: the person in the dative, „dem Chef“, comes first. "
                    + "Two pronouns: the accusative „ihn“ (the letter) before the dative „ihm“."),
            .build("Can you lend it to me? (it: das Auto)",
                   words: ["mir", "Kannst", "leihen", "es", "du", "mich"],
                   answers: ["Kannst du es mir leihen"],
                   why: "„es“ (the car, accusative) and „mir“ (dative) are both pronouns, so the accusative comes first: es mir. "
                    + "„mich“ is the accusative of ich.")
        ]
    )

    static let b2Tekamolo = GrammarRule(
        id: "b2-tekamolo", level: .b2, title: "When, why, how, where: te-ka-mo-lo",
        place: "Planning a trip for work", systemImage: "briefcase",
        german: "Ich fahre morgen wegen des Termins mit dem Zug nach Köln.",
        english: "Tomorrow I'm going to Cologne by train because of the appointment.",
        tiles: [Tile(text: "Ich fahre"), Tile(text: "morgen", role: .key), Tile(text: "wegen des Termins", role: .key),
                Tile(text: "mit dem Zug", role: .key), Tile(text: "nach Köln.", role: .end)],
        notice: "When, why, how, where: „morgen“, „wegen des Termins“, „mit dem Zug“, „nach Köln“.",
        rule: "In the middle of a sentence the usual order is when (temporal), why (kausal), how (modal), "
            + "where (lokal): te-ka-mo-lo.",
        visual: RuleVisual(
            source: Part(systemImage: "clock.fill", german: "morgen", marked: "morgen", role: "When? First"),
            target: Part(systemImage: "mappin.and.ellipse", german: "nach Köln", marked: "nach Köln", role: "Where? Last"),
            sentence: "Ich fahre morgen mit dem Zug nach Köln.",
            columns: ["asks", "example"],
            rows: [
                Row(label: "te: temporal", cells: ["Wann?", "morgen"]),
                Row(label: "ka: kausal", cells: ["Warum?", "wegen des Termins"]),
                Row(label: "mo: modal", cells: ["Wie?", "mit dem Zug"]),
                Row(label: "lo: lokal", cells: ["Wo? Wohin?", "nach Köln"])
            ]
        ),
        exam: [
            .gap(.easy, "Wir treffen uns ___.", options: ["im Café um drei", "um drei im Café", "im Café drei um"], answer: 1,
                 why: "When comes before where: um drei, then im Café."),
            .gap(.medium, "Sie ist ___ gekommen.", prompt: "Pick the usual order.",
                 options: ["gestern wegen des Streiks zu Fuß", "zu Fuß gestern wegen des Streiks", "wegen des Streiks zu Fuß gestern"],
                 answer: 0,
                 why: "te-ka-mo: gestern (when), wegen des Streiks (why), zu Fuß (how)."),
            .build("On Monday I'm cycling to work because of the strike.",
                   prompt: "Build the sentence. Start with the day. One tile is left over.",
                   words: ["mit dem Rad", "fahre", "Am Montag", "zur Arbeit", "ich", "wegen des Streiks", "fahren"],
                   answers: ["Am Montag fahre ich wegen des Streiks mit dem Rad zur Arbeit"],
                   why: "„Am Montag“ is position 1, so the verb and then „ich“ follow. "
                    + "Then why, how and where: wegen des Streiks, mit dem Rad, zur Arbeit.")
        ]
    )

    static let b2NearVerb = GrammarRule(
        id: "b2-verbnah", level: .b2, title: "What completes the verb goes last",
        place: "Message from a friend", systemImage: "message",
        german: "Ich gehe heute Abend mit Lena ins Kino.",
        english: "I'm going to the cinema with Lena tonight.",
        tiles: [Tile(text: "Ich"), Tile(text: "gehe", role: .verb), Tile(text: "heute Abend"), Tile(text: "mit Lena"),
                Tile(text: "ins Kino.", role: .end)],
        notice: "„ins Kino gehen“ belong together: where you go sits at the end, as close to the verb as it can.",
        rule: "What completes the verb goes to the end, right before any second verb part: "
            + "a direction (nach Wien fahren), a place it needs (in Wien wohnen) or a word it forms one idea with (Deutsch lernen).",
        visual: RuleVisual(
            source: Part(systemImage: "figure.walk", german: "gehe", marked: "gehe", role: "the verb"),
            verb: "…",
            target: Part(systemImage: "film.fill", german: "ins Kino", marked: "ins Kino", role: "completes it: last"),
            sentence: "Ich gehe heute Abend ins Kino.",
            columns: ["in the middle", "at the end"],
            rows: [
                Row(label: "a direction", cells: ["morgen mit dem Zug", "nach Wien fahren"], marked: [1]),
                Row(label: "one idea", cells: ["seit einem Jahr", "Deutsch lernen"], marked: [1]),
                Row(label: "a place it needs", cells: ["seit 2019", "in Wien wohnen"], marked: [1]),
                Row(label: "sein + word", cells: ["heute leider", "krank sein"], marked: [1])
            ]
        ),
        exam: [
            .gap(.easy, "Ich fahre ___.", options: ["nach Hause morgen", "morgen nach Hause", "nach morgen Hause"], answer: 1,
                 why: "„nach Hause“ completes „fahren“, so it goes last, after the time."),
            .gap(.medium, "Er hat ___ gelernt.", prompt: "Pick the usual order.",
                 options: ["Deutsch drei Jahre lang in der Schule", "drei Jahre lang in der Schule Deutsch",
                           "in der Schule Deutsch drei Jahre lang"], answer: 1,
                 why: "„Deutsch lernen“ is one idea, so „Deutsch“ sits right before the participle. Time and place come earlier."),
            .build("Tomorrow we're driving to my parents' with the children.",
                   prompt: "Build the sentence. Start with „Morgen“. One tile is left over.",
                   words: ["zu meinen Eltern", "Morgen", "wir", "mit den Kindern", "fahren", "zu meine Eltern"],
                   answers: ["Morgen fahren wir mit den Kindern zu meinen Eltern"],
                   why: "The direction completes „fahren“, so it comes last. „zu“ takes the dative: zu meinen Eltern.")
        ]
    )

    static let b2Nicht = GrammarRule(
        id: "b2-nicht", level: .b2, title: "Where nicht goes",
        place: "Call to the landlord", systemImage: "phone",
        german: "Die Heizung funktioniert seit gestern nicht.",
        english: "The heating hasn't been working since yesterday.",
        tiles: [Tile(text: "Die Heizung"), Tile(text: "funktioniert", role: .verb), Tile(text: "seit gestern"),
                Tile(text: "nicht.", role: .key)],
        notice: "„nicht“ negates the whole sentence, so it goes to the end, after the time.",
        rule: "To negate the whole sentence, nicht goes as far back as it can: after objects and times, but before what completes "
            + "the verb and before a second verb part. To negate one word, put nicht right before it.",
        visual: RuleVisual(
            source: Part(systemImage: "xmark.circle.fill", german: "Ich komme heute nicht.", marked: "nicht", role: "the whole sentence"),
            target: Part(systemImage: "scope", german: "nicht heute, sondern morgen", marked: "nicht heute", role: "one word"),
            sentence: "Ich komme heute nicht. Nicht heute, sondern morgen.",
            columns: ["nicht goes", "example"],
            rows: [
                Row(label: "whole sentence", cells: ["at the end", "Ich kenne ihn nicht."]),
                Row(label: "with a 2nd verb", cells: ["before it", "Ich habe ihn nicht gesehen."], marked: [0]),
                Row(label: "sein, a place", cells: ["before it", "Er ist nicht krank."], marked: [0]),
                Row(label: "one word", cells: ["right before it", "nicht ich, sondern du"])
            ],
            isLinked: false
        ),
        exam: [
            .gap(.easy, "Ich habe ___.", options: ["nicht das Paket bekommen", "das Paket nicht bekommen", "das Paket bekommen nicht"],
                 answer: 1,
                 why: "nicht negates the whole sentence: after the object, before the participle."),
            .gap(.medium, "Wir fahren ___.", prompt: "You mean: we're going, but on Friday, not tomorrow.",
                 options: ["morgen nicht nach Berlin", "nicht morgen nach Berlin, sondern am Freitag", "morgen nach Berlin nicht"],
                 answer: 1,
                 why: "To negate one word, put nicht right before it, and give the right one with „sondern“: "
                    + "nicht morgen, sondern am Freitag."),
            .build("I didn't understand the email.",
                   words: ["verstanden", "nicht", "Ich", "die E-Mail", "habe", "keine"],
                   answers: ["Ich habe die E-Mail nicht verstanden"],
                   why: "nicht goes after the object and before the participle at the end. „keine“ would replace the article.")
        ]
    )
}
