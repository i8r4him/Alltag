//
//  MockRules+B2Style.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The B2 rules, part 12: noun-verb pairs, da-words, modal particles and
/// commas.
extension MockRules {
    static let b2NounVerb = GrammarRule(
        id: "b2-funktionsverben", level: .b2, title: "Noun-verb pairs: eine Entscheidung treffen",
        place: "Letter from an office", systemImage: "envelope",
        german: "Bitte stellen Sie den Antrag bis Ende März.",
        english: "Please submit the application by the end of March.",
        tiles: [Tile(text: "Bitte"), Tile(text: "stellen", role: .verb), Tile(text: "Sie"), Tile(text: "den Antrag", role: .key),
                Tile(text: "bis Ende März.")],
        notice: "„einen Antrag stellen“ is a fixed pair: the noun carries the meaning, and the verb comes with it.",
        rule: "Formal German often says it with a noun and a set verb: eine Entscheidung treffen (entscheiden), eine Frage stellen "
            + "(fragen), in Kraft treten, zur Verfügung stehen, Bescheid geben. Learn them as pairs: the verb can't be swapped.",
        visual: RuleVisual(
            source: Part(systemImage: "checkmark.circle.fill", german: "entscheiden", role: "the verb"),
            target: Part(systemImage: "doc.text.fill", german: "eine Entscheidung treffen", marked: "treffen", role: "noun + set verb"),
            sentence: "Entscheiden. Eine Entscheidung treffen.",
            columns: ["the pair", "means"],
            rows: [
                Row(label: "Entscheidung", cells: ["eine Entscheidung treffen", "entscheiden"]),
                Row(label: "Frage", cells: ["eine Frage stellen", "fragen"]),
                Row(label: "Verfügung", cells: ["zur Verfügung stehen", "be available"]),
                Row(label: "Bescheid", cells: ["Bescheid geben", "let know"]),
                Row(label: "Kraft", cells: ["in Kraft treten", "come into force"])
            ]
        ),
        exam: [
            .gap(.easy, "Darf ich Ihnen eine Frage ___?", options: ["stellen", "machen", "geben"], answer: 0,
                 why: "The pair is „eine Frage stellen“."),
            .gap(.medium, "Wir müssen bald eine Entscheidung ___, denn das Gesetz ___ im Mai in Kraft.", prompt: "Fill both gaps.",
                 options: ["treffen … tritt", "machen … tritt", "treffen … kommt"], answer: 0,
                 why: "The pairs are „eine Entscheidung treffen“ and „in Kraft treten“."),
            .build("The room is available to you all day.", prompt: "Build the sentence. Two tiles are left over.",
                   words: ["zur Verfügung", "Der Raum", "Sie", "steht", "den ganzen Tag", "ist", "Ihnen"],
                   answers: ["Der Raum steht Ihnen den ganzen Tag zur Verfügung"],
                   why: "The pair is „zur Verfügung stehen“, with the person in the dative: Ihnen. "
                    + "The noun part goes to the end.")
        ]
    )

    static let b2DaWords = GrammarRule(
        id: "b2-da-woerter", level: .b2, title: "da-words: darauf, damit, daran",
        place: "Message from a friend", systemImage: "message",
        german: "Ich freue mich schon darauf, euch zu sehen.",
        english: "I'm really looking forward to seeing you.",
        tiles: [Tile(text: "Ich freue mich schon"), Tile(text: "darauf,", role: .key), Tile(text: "euch zu sehen.")],
        notice: "„sich freuen auf“ needs „auf“. „darauf“ points ahead to what you look forward to.",
        rule: "For things, da + preposition replaces the preposition and a pronoun: auf den Urlaub → darauf. Before a vowel add r: "
            + "daran, darüber. For people keep the pronoun: auf ihn. A da-word can point ahead to a dass- or zu-clause.",
        visual: RuleVisual(
            source: Part(systemImage: "airplane", german: "auf den Urlaub", role: "a thing"),
            target: Part(systemImage: "arrow.uturn.left", german: "darauf", marked: "dar", role: "da(r) + preposition"),
            sentence: "Auf den Urlaub. Darauf.",
            columns: ["a thing", "a person"],
            rows: [
                Row(label: "warten auf", cells: ["darauf", "auf ihn"], marked: [0]),
                Row(label: "sprechen über", cells: ["darüber", "über sie"], marked: [0]),
                Row(label: "zufrieden mit", cells: ["damit", "mit ihm"], marked: [0]),
                Row(label: "denken an", cells: ["daran", "an dich"], marked: [0])
            ]
        ),
        exam: [
            .gap(.easy, "Denkst du an den Termin? — Ja, ich denke ___.", options: ["daran", "darauf", "damit"], answer: 0,
                 why: "„denken an“, and the appointment is a thing: daran."),
            .gap(.medium, "Bist du mit dem Hotel zufrieden? — Ja, ___. Und mit dem Kellner? — Ja, auch ___.",
                 prompt: "Fill both gaps.", options: ["damit … mit ihm", "mit ihm … damit", "damit … damit"], answer: 0,
                 why: "The hotel is a thing: damit. The waiter is a person, so the pronoun stays: mit ihm."),
            .build("We talked about it for a long time.", prompt: "Build the sentence. Two tiles are left over.",
                   words: ["darüber", "Wir haben", "über es", "gesprochen", "lange", "darauf"],
                   answers: ["Wir haben lange darüber gesprochen"],
                   why: "„sprechen über“ and a thing: darüber. German doesn't say „über es“.")
        ]
    )

    static let b2Particles = GrammarRule(
        id: "b2-modalpartikeln", level: .b2, title: "Modal particles: doch, mal, ja, denn",
        place: "Message from a friend", systemImage: "message",
        german: "Komm doch mal vorbei!",
        english: "Why don't you drop by!",
        tiles: [Tile(text: "Komm"), Tile(text: "doch", role: .key), Tile(text: "mal", role: .key), Tile(text: "vorbei!")],
        notice: "„doch mal“ makes the invitation warm and easy. Without them it sounds like an order.",
        rule: "Small words that add a tone, not a meaning: mal softens a request, doch urges (Komm doch!), ja shows you both know it "
            + "(Du bist ja nass!), halt or eben says it can't be helped, denn makes a question friendly.",
        visual: RuleVisual(
            source: Part(systemImage: "exclamationmark.circle.fill", german: "Komm vorbei!", role: "sounds like an order"),
            target: Part(systemImage: "face.smiling", german: "Komm doch mal vorbei!", marked: "doch mal", role: "friendly"),
            sentence: "Komm vorbei! Komm doch mal vorbei!",
            columns: ["adds", "example"],
            rows: [
                Row(label: "mal", cells: ["softer", "Kannst du mal kommen?"], marked: [1]),
                Row(label: "doch", cells: ["urging", "Setz dich doch!"], marked: [1]),
                Row(label: "ja", cells: ["we both see it", "Du bist ja nass!"], marked: [1]),
                Row(label: "halt, eben", cells: ["can't be helped", "Das ist halt so."], marked: [1]),
                Row(label: "denn", cells: ["a friendly question", "Was machst du denn?"], marked: [1])
            ]
        ),
        exam: [
            .gap(.easy, "Kannst du ___ das Fenster aufmachen?", options: ["mal", "ja", "halt"], answer: 0,
                 why: "mal softens a request: Kannst du mal …?"),
            .gap(.medium, "Du siehst ___ müde aus! Geh ___ ins Bett.", prompt: "Fill both gaps.",
                 options: ["ja … doch", "doch … ja", "denn … ja"], answer: 0,
                 why: "ja: you can both see it. doch: urging someone to do it."),
            .build("What are you doing here, then?", prompt: "Build the friendly question. One tile is left over.",
                   words: ["hier", "machst", "denn", "Was", "du", "ja"],
                   answers: ["Was machst du denn hier"],
                   why: "denn makes a question friendly and comes right after the subject. ja doesn't go in questions.")
        ]
    )

    static let b2Commas = GrammarRule(
        id: "b2-komma", level: .b2, title: "Where the commas go",
        place: "Writing an email", systemImage: "envelope",
        german: "Ich hoffe, dass Sie gut angekommen sind, und freue mich auf Ihre Antwort.",
        english: "I hope you arrived safely, and I look forward to your reply.",
        tiles: [Tile(text: "Ich hoffe,", role: .key), Tile(text: "dass Sie gut angekommen sind,", role: .key),
                Tile(text: "und freue mich auf Ihre Antwort.")],
        notice: "A comma before „dass“, and another after the dass-clause, where the main clause goes on.",
        rule: "A comma goes before and after every subordinate clause (dass, weil, wenn, a relative clause), before aber and "
            + "sondern, and before um … zu, ohne … zu and statt … zu. No comma before und or oder joining two parts.",
        visual: RuleVisual(
            source: Part(systemImage: "text.bubble.fill", german: "Ich weiß, dass du kommst.", marked: ",", role: "before dass"),
            target: Part(systemImage: "text.bubble", german: "Ich komme und bleibe.", role: "none before und"),
            sentence: "Ich weiß, dass du kommst. Ich komme und bleibe.",
            columns: ["comma?", "example"],
            rows: [
                Row(label: "dass, weil, wenn", cells: ["yes", "Ich bleibe, weil es regnet."], marked: [0]),
                Row(label: "relative clause", cells: ["both sides", "Der Mann, den ich kenne, …"], marked: [0]),
                Row(label: "aber, sondern", cells: ["yes", "klein, aber fein"], marked: [0]),
                Row(label: "um … zu", cells: ["yes", "Ich lerne, um zu bestehen."], marked: [0]),
                Row(label: "und, oder", cells: ["no", "Ich esse und trinke."])
            ],
            isLinked: false
        ),
        exam: [
            .gap(.easy, prompt: "Pick the right sentence.",
                 options: ["Ich glaube, dass er kommt.", "Ich glaube dass, er kommt.", "Ich glaube dass er, kommt."], answer: 0,
                 why: "The comma goes before dass, where the subordinate clause starts."),
            .gap(.medium, prompt: "Pick the right sentence.",
                 options: ["Der Film, den wir gesehen haben, war toll.", "Der Film den wir gesehen haben, war toll.",
                           "Der Film, den wir gesehen haben war toll."], answer: 0,
                 why: "A relative clause in the middle of a sentence takes a comma on both sides."),
            .build("We stayed at home because it was raining, and watched a film.",
                   words: ["und haben", "weil es geregnet hat", "Wir sind zu Hause geblieben,", "einen Film gesehen",
                           "weil es geregnet hat,"],
                   answers: ["Wir sind zu Hause geblieben, weil es geregnet hat, und haben einen Film gesehen"],
                   why: "The weil-clause sits in the middle of the sentence, so it takes a comma on both sides.")
        ]
    )
}
