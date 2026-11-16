//
//  MockRules+C1Sentence.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The C1 rules, part 6: where small words and known things go in a
/// sentence, and how German sounds when it's spoken fast.
extension MockRules {
    static let c1FocusParticles = GrammarRule(
        id: "c1-fokuspartikeln", level: .c1, title: "auch, nur, erst, sogar: where they stand changes the meaning",
        place: "Message from a friend", systemImage: "message",
        german: "Ich habe nur den Anfang gelesen.",
        english: "I only read the beginning.",
        tiles: [Tile(text: "Ich habe"), Tile(text: "nur", role: .key), Tile(text: "den Anfang", role: .end),
                Tile(text: "gelesen.")],
        notice: "„nur“ points at what follows it: the beginning, not the rest. "
            + "„Nur ich habe den Anfang gelesen“ would mean that nobody else did.",
        rule: "auch, nur, sogar, selbst, erst and schon point at the word that follows them. Move the particle and you "
            + "change what's meant. With that word, it can fill position 1: Auch Tom kommt.",
        visual: RuleVisual(
            source: Part(systemImage: "person.fill", german: "Nur Tom kommt heute.", marked: "Nur", role: "nobody else"),
            target: Part(systemImage: "calendar", german: "Tom kommt nur heute.", marked: "nur", role: "on no other day"),
            sentence: "Nur Tom kommt heute. Tom kommt nur heute.",
            columns: ["sentence", "means"],
            rows: [
                Row(label: "auch", cells: ["Auch Tom kommt.", "others and Tom"], marked: [0]),
                Row(label: "sogar", cells: ["Sogar Tom kommt.", "Tom, surprisingly"], marked: [0]),
                Row(label: "nur", cells: ["Tom kommt nur\nheute.", "no other day"], marked: [0]),
                Row(label: "erst", cells: ["Tom kommt erst\num 9.", "later than hoped"], marked: [0]),
                Row(label: "schon", cells: ["Tom kommt schon\num 9.", "earlier than thought"], marked: [0])
            ],
            isLinked: false
        ),
        exam: [
            .gap(.easy, "Wir haben ___ zwei Karten, mehr gibt es nicht.", options: ["sogar", "nur", "auch"], answer: 1,
                 why: "nur says two and no more."),
            .gap(.medium, prompt: "Which sentence says that nobody else knows?",
                 options: ["Anna weiß nur das.", "Nur Anna weiß das.", "Anna weiß das auch."], answer: 1,
                 why: "nur points at what follows it: Nur Anna means Anna and nobody else. "
                    + "„Anna weiß nur das“ means she knows that and nothing else."),
            .build("The parcel won't arrive until Monday.", prompt: "Build the sentence. Two tiles are left over.",
                   words: ["Das Paket", "schon", "kommt", "erst", "nur", "am Montag"],
                   answers: ["Das Paket kommt erst am Montag"],
                   why: "erst says it's later than you'd like: not before Monday. schon would say earlier than expected, "
                    + "and nur that it comes on no other day.")
        ]
    )

    static let c1InformationOrder = GrammarRule(
        id: "c1-satzordnung", level: .c1, title: "Known first, new last: the order of information",
        place: "Message from a friend", systemImage: "message",
        german: "Das Buch? Ich habe es gestern meiner Schwester gegeben.",
        english: "The book? I gave it to my sister yesterday.",
        tiles: [Tile(text: "Ich habe"), Tile(text: "es", role: .key), Tile(text: "gestern"),
                Tile(text: "meiner Schwester", role: .end), Tile(text: "gegeben.")],
        notice: "The book is known, so „es“ comes early. Who got it is the news, so „meiner Schwester“ comes as late as it can.",
        rule: "In the middle of a sentence, what is known comes before what is new: pronouns before nouns, "
            + "accusative before dative pronoun (es ihm), and the newest information last, just before the verb at the end.",
        visual: RuleVisual(
            source: Part(systemImage: "checkmark.circle", german: "es", marked: "es", role: "known: early"),
            target: Part(systemImage: "sparkles", german: "meiner Schwester", marked: "meiner Schwester", role: "new: late"),
            sentence: "Ich habe es meiner Schwester gegeben.",
            columns: ["earlier", "later"],
            rows: [
                Row(label: "pronoun, noun", cells: ["es, ihr", "dem Kind,\ndas Buch"], marked: [0]),
                Row(label: "two pronouns", cells: ["es (acc.)", "ihr (dat.)"], marked: [0]),
                Row(label: "two new nouns", cells: ["dem Kind (dat.)", "ein Buch (acc.)"], marked: [0]),
                Row(label: "known, new", cells: ["das Buch", "einem Kind"], marked: [0]),
                Row(label: "time, place", cells: ["morgen", "in Berlin"], marked: [0])
            ]
        ),
        exam: [
            .gap(.easy, "Hast du Paul das Geld gegeben? – Ja, ich habe ___ gegeben.",
                 options: ["ihm es", "es ihm", "ihn es"], answer: 1,
                 why: "Two pronouns: the accusative comes first, es ihm."),
            .gap(.medium, "Wem hast du den Schal geschenkt? – Ich habe ___ geschenkt.",
                 options: ["meiner Mutter ihn", "ihr meiner Mutter", "ihn meiner Mutter"], answer: 2,
                 why: "The scarf is known, so it's a pronoun and comes early: ihn. "
                    + "Who got it is the new information, so it comes last: meiner Mutter."),
            .build("I'll show it to my colleagues in the office tomorrow.",
                   words: ["Ich", "ihnen", "zeige", "es", "morgen", "meinen Kollegen", "im Büro"],
                   answers: ["Ich zeige es morgen meinen Kollegen im Büro", "Ich zeige es morgen im Büro meinen Kollegen"],
                   why: "es is known, so it comes right after the verb. Then the time, then the new people. "
                    + "„ihnen“ would repeat the colleagues.")
        ]
    )

    static let c1SpokenGerman = GrammarRule(
        id: "c1-gesprochen", level: .c1, title: "haste, kommste, 'ne: German as it's spoken",
        place: "A colleague at work", systemImage: "briefcase",
        german: "Haste mal 'ne Minute?",
        english: "Have you got a minute?",
        tiles: [Tile(text: "Haste", role: .key), Tile(text: "mal"), Tile(text: "'ne", role: .end), Tile(text: "Minute?")],
        notice: "„Haste“ is „hast du“ run together, and „'ne“ is „eine“. You'll hear it everywhere, "
            + "but don't write it in a letter.",
        rule: "In fast speech, du merges with the verb (hast du → haste), ein and eine shrink to 'n and 'ne, es to 's, "
            + "and ich habe loses its -e (ich hab). Understand it everywhere; use it only with friends.",
        visual: RuleVisual(
            source: Part(systemImage: "text.bubble", german: "Hast du Zeit?", marked: "Hast du", role: "written"),
            target: Part(systemImage: "waveform", german: "Haste Zeit?", marked: "Haste", role: "spoken"),
            sentence: "Hast du Zeit? Haste Zeit?",
            columns: ["written", "spoken"],
            rows: [
                Row(label: "du after a verb", cells: ["hast du,\nkannst du", "haste,\nkannste"], marked: [1]),
                Row(label: "ein, eine", cells: ["ein, eine,\neinen", "'n, 'ne,\n'nen"], marked: [1]),
                Row(label: "es", cells: ["geht es,\ngibt es", "geht's,\ngibt's"], marked: [1]),
                Row(label: "ich + -e", cells: ["ich habe,\nich gehe", "ich hab,\nich geh"], marked: [1]),
                Row(label: "nicht, etwas", cells: ["nicht, etwas", "nich, was"], marked: [1])
            ]
        ),
        exam: [
            .gap(.easy, "„Kommste mit?“", prompt: "What does it mean?",
                 options: ["Kommt sie mit?", "Kommst du mit?", "Komm mit!"], answer: 1,
                 why: "-ste at the end of a verb is the verb plus du: kommste = kommst du."),
            .gap(.medium, "„Ich hab 'nen Termin, haste das nich gesehen?“", prompt: "How is it written?",
                 options: ["Ich habe ein Termin, hast du das nicht gesehen?",
                           "Ich habe einen Termin, hast du das nicht gesehen?",
                           "Ich habe einen Termin, hast das nicht gesehen?"], answer: 1,
                 why: "'nen is einen (der Termin, in the accusative), haste is hast du, and nich is nicht."),
            .build("Spoken: „Gibt's hier 'n Café?“", prompt: "Write it properly. Two tiles are left over.",
                   words: ["Gibt", "'s", "es", "hier", "einen", "ein", "Café"],
                   answers: ["Gibt es hier ein Café"],
                   why: "'s is es, and 'n is ein. das Café is neuter, so in the accusative it stays ein, not einen.")
        ]
    )
}
