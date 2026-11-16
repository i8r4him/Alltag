//
//  MockRules+B2Forms.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The B2 rules, part 8: pronouns that stand alone, comparing, participles
/// as adjectives and reported speech.
extension MockRules {
    static let b2StandAlonePronouns = GrammarRule(
        id: "b2-pronomen", level: .b2, title: "Pronouns that stand alone: welche, meiner, keins",
        place: "In the kitchen", systemImage: "fork.knife",
        german: "Ist noch Milch da? — Ja, im Kühlschrank ist noch welche.",
        english: "Is there any milk left? — Yes, there's still some in the fridge.",
        tiles: [Tile(text: "Ja, im Kühlschrank ist noch"), Tile(text: "welche.", role: .key)],
        notice: "„welche“ stands for some milk you don't count. For one thing you'd say „einer“, „eine“ or „eins“.",
        rule: "Without its noun, ein, kein and mein take der's ending: einer, eins, keiner, keins, meiner, meins. "
            + "For an amount or a plural with no article, use welche: Ich brauche Eier. Hast du welche?",
        visual: RuleVisual(
            source: Part(systemImage: "pencil", german: "mein Stift", role: "with its noun"),
            target: Part(systemImage: "pencil", german: "Das ist meiner.", marked: "meiner", role: "alone: -er, like der"),
            sentence: "Mein Stift. Das ist meiner.",
            columns: ["masc.", "fem.", "neut."],
            rows: [
                Row(label: "ein", cells: ["einer", "eine", "eins"], marked: [0, 2]),
                Row(label: "kein", cells: ["keiner", "keine", "keins"], marked: [0, 2]),
                Row(label: "mein", cells: ["meiner", "meine", "meins"], marked: [0, 2])
            ]
        ),
        exam: [
            .gap(.easy, "Ich habe keinen Regenschirm. Hast du ___?", hint: "der Regenschirm", options: ["einen", "ein", "eins"],
                 answer: 0,
                 why: "der Regenschirm in the accusative: einen, with or without the noun."),
            .gap(.medium, "Wir brauchen Tomaten. Im Supermarkt gibt es bestimmt ___, aber zu Hause haben wir ___.",
                 prompt: "Fill both gaps.", options: ["welche … keine", "eine … keins", "welche … keins"], answer: 0,
                 why: "Some tomatoes, a plural with no article: welche. None at all, in the plural: keine."),
            .build("No, mine is in my bag. (mine: das Handy)", prompt: "Build the answer. Two tiles are left over.",
                   words: ["in meiner Tasche", "meins", "Nein,", "mein", "ist", "meiner"],
                   answers: ["Nein, meins ist in meiner Tasche"],
                   why: "das Handy is neuter, so mein on its own becomes meins.")
        ]
    )

    static let b2Man = GrammarRule(
        id: "b2-indefinitpronomen", level: .b2, title: "man, jemand, niemand, beide",
        place: "Lost and found", systemImage: "magnifyingglass",
        german: "Hat jemand einen Schlüssel gefunden? Man hat mir gesagt, er liegt hier.",
        english: "Has anyone found a key? I was told it's here.",
        tiles: [Tile(text: "Hat"), Tile(text: "jemand", role: .key), Tile(text: "einen Schlüssel gefunden?"), Tile(text: "Man", role: .key),
                Tile(text: "hat mir gesagt, er liegt hier.")],
        notice: "„jemand“ is a person you don't know. „man“ is people in general: „Man hat mir gesagt“ means someone told me.",
        rule: "man is only a subject; in other cases it becomes einen and einem. jemand and niemand can take -en and -em "
            + "(jemanden, niemandem). beide means the two, and takes adjective endings after an article: meine beiden Brüder.",
        visual: RuleVisual(
            source: Part(systemImage: "person.fill.questionmark", german: "jemand", role: "a person"),
            target: Part(systemImage: "shippingbox.fill", german: "etwas", role: "a thing"),
            sentence: "Jemand. Etwas.",
            columns: ["nom.", "acc.", "dat."],
            rows: [
                Row(label: "man", cells: ["man", "einen", "einem"], marked: [1, 2]),
                Row(label: "jemand", cells: ["jemand", "jemanden", "jemandem"], marked: [1, 2]),
                Row(label: "niemand", cells: ["niemand", "niemanden", "niemandem"], marked: [1, 2])
            ],
            isLinked: false
        ),
        exam: [
            .gap(.easy, "Ist ___ zu Hause? Die Tür ist offen.", options: ["jemand", "man", "etwas"], answer: 0,
                 why: "An unknown person: jemand. man is people in general, and etwas is a thing."),
            .gap(.medium, "Das Essen schmeckt ___ nur, wenn ___ Hunger hat.", prompt: "Fill both gaps.",
                 options: ["einem … man", "man … einem", "einen … man"], answer: 0,
                 why: "schmecken takes the dative, and man becomes einem. As the subject it stays man."),
            .build("Both of my brothers live in Munich.",
                   words: ["Brüder", "Meine", "in München", "beiden", "wohnen", "beide"],
                   answers: ["Meine beiden Brüder wohnen in München"],
                   why: "After meine, beide takes -en like an adjective: meine beiden Brüder.")
        ]
    )

    static let b2Comparison = GrammarRule(
        id: "b2-komparation", level: .b2, title: "Comparing: größer als, am größten",
        place: "Looking for a flat", systemImage: "house",
        german: "Die neue Wohnung ist größer als die alte, aber nicht so hell.",
        english: "The new flat is bigger than the old one, but not as bright.",
        tiles: [Tile(text: "Die neue Wohnung ist"), Tile(text: "größer", role: .verb), Tile(text: "als", role: .key),
                Tile(text: "die alte, aber nicht"), Tile(text: "so", role: .key), Tile(text: "hell.")],
        notice: "Different: „größer als“. Not equal: „nicht so hell“, where „wie“ would follow.",
        rule: "Different: comparative + als. The same: so … wie. More and more: immer + comparative. The most: am -sten, "
            + "or before a noun der, die, das + -ste. Before a noun every form takes adjective endings: eine größere Wohnung.",
        visual: RuleVisual(
            source: Part(systemImage: "house", german: "groß", role: "plain"),
            target: Part(systemImage: "building.2.fill", german: "größer als", marked: "größer", role: "comparative"),
            sentence: "Groß. Größer als.",
            columns: ["comparative", "superlative"],
            rows: [
                Row(label: "groß", cells: ["größer", "am größten"]),
                Row(label: "gut", cells: ["besser", "am besten"], marked: [0, 1]),
                Row(label: "viel", cells: ["mehr", "am meisten"], marked: [0, 1]),
                Row(label: "gern", cells: ["lieber", "am liebsten"], marked: [0, 1])
            ]
        ),
        exam: [
            .gap(.easy, "Berlin ist größer ___ München.", options: ["als", "wie", "dann"], answer: 0,
                 why: "After a comparative comes als: größer als."),
            .gap(.medium, "Wir suchen eine ___ Wohnung, denn die Mieten werden immer ___.", prompt: "Fill both gaps.",
                 hint: "groß · hoch", options: ["größere … höher", "größer … höhere", "größere … hoher"], answer: 0,
                 why: "Before a noun the comparative takes an ending: eine größere Wohnung. After werden it has none: immer höher."),
            .build("This is the best café in town.", prompt: "Build the sentence. Two tiles are left over.",
                   words: ["Café", "der Stadt", "am besten", "Das ist", "das beste", "das besteste"],
                   answers: ["Das ist das beste Café der Stadt"],
                   why: "Before a noun the superlative takes an ending: das beste Café. „am besten“ stands on its own, after a verb.")
        ]
    )

    static let b2Participles = GrammarRule(
        id: "b2-partizip", level: .b2, title: "Participles as adjectives: das spielende Kind",
        place: "Station announcement", systemImage: "tram",
        german: "Der verspätete Zug fährt in wenigen Minuten ein.",
        english: "The delayed train will arrive in a few minutes.",
        tiles: [Tile(text: "Der"), Tile(text: "verspätete", role: .key), Tile(text: "Zug fährt in wenigen Minuten ein.")],
        notice: "„verspätet“ is the participle of „sich verspäten“. Before a noun it takes an adjective ending: „der verspätete Zug“.",
        rule: "Partizip I, the infinitive + d, is something happening now: das weinende Kind, the child who is crying. "
            + "Partizip II is done or passive: das reparierte Fahrrad, the bike that was repaired. Both take adjective endings.",
        visual: RuleVisual(
            source: Part(systemImage: "figure.run", german: "der laufende Mann", marked: "laufende", role: "Partizip I: doing it now"),
            target: Part(systemImage: "checkmark.circle.fill", german: "die gelesene Zeitung", marked: "gelesene",
                         role: "Partizip II: done"),
            sentence: "Der laufende Mann. Die gelesene Zeitung.",
            columns: ["Partizip I", "Partizip II"],
            rows: [
                Row(label: "spielen", cells: ["die spielenden Kinder", "das gespielte Lied"]),
                Row(label: "kochen", cells: ["das kochende Wasser", "das gekochte Ei"]),
                Row(label: "schreiben", cells: ["der schreibende Student", "der geschriebene Text"])
            ],
            isLinked: false
        ),
        exam: [
            .gap(.easy, "Vorsicht, ___ Wasser!", hint: "kochen, happening now", options: ["kochendes", "gekochtes", "kochend"], answer: 0,
                 why: "It's boiling now: Partizip I, kochend, with the ending of no article: kochendes Wasser."),
            .gap(.medium, "Die ___ Gäste bekommen einen Kaffee, und die ___ Rechnung liegt auf dem Tisch.", prompt: "Fill both gaps.",
                 hint: "warten · bezahlen", options: ["wartenden … bezahlte", "gewarteten … bezahlende", "wartende … bezahlten"],
                 answer: 0,
                 why: "The guests are waiting now: Partizip I, wartenden. The bill has been paid: Partizip II, bezahlte."),
            .build("I'm looking for the stolen bike.", prompt: "Build the sentence. Two tiles are left over.",
                   words: ["gestohlene", "Fahrrad", "Ich suche", "stehlende", "das", "gestohlenes"],
                   answers: ["Ich suche das gestohlene Fahrrad"],
                   why: "The bike was stolen: Partizip II. After das it takes -e: das gestohlene Fahrrad.")
        ]
    )

    static let b2ReportedSpeech = GrammarRule(
        id: "b2-indirekte-rede", level: .b2, title: "Reported speech: er sagt, er sei krank",
        place: "News on the radio", systemImage: "radio",
        german: "Der Minister sagte, die Lage sei unter Kontrolle.",
        english: "The minister said the situation was under control.",
        tiles: [Tile(text: "Der Minister sagte,"), Tile(text: "die Lage"), Tile(text: "sei", role: .verb), Tile(text: "unter Kontrolle.")],
        notice: "„sei“ is the Konjunktiv I of „sein“: the radio reports what he said without saying it's true.",
        rule: "News and reports use the Konjunktiv I: the stem + e (er habe, er komme, er sei). Where it looks like the normal "
            + "present, use the Konjunktiv II (sie hätten). For the past: habe or sei + participle (er sei gekommen).",
        visual: RuleVisual(
            source: Part(systemImage: "quote.bubble.fill", german: "„Ich bin krank.“", role: "he says"),
            target: Part(systemImage: "newspaper.fill", german: "Er sei krank.", marked: "sei", role: "reported", name: "Konjunktiv I"),
            sentence: "Ich bin krank. Er sei krank.",
            columns: ["said", "reported"],
            rows: [
                Row(label: "sein", cells: ["Ich bin müde.", "Er sei müde."], marked: [1]),
                Row(label: "haben", cells: ["Ich habe Zeit.", "Er habe Zeit."], marked: [1]),
                Row(label: "plural", cells: ["Wir haben Zeit.", "Sie hätten Zeit."], marked: [1]),
                Row(label: "past", cells: ["Ich bin gekommen.", "Er sei gekommen."], marked: [1])
            ]
        ),
        exam: [
            .gap(.easy, "Sie sagt, sie ___ keine Zeit.", prompt: "Report it as the news would.", options: ["habe", "hat", "haben"],
                 answer: 0,
                 why: "Konjunktiv I of haben with sie (she): sie habe."),
            .gap(.medium, "Die Firma teilte mit, die Mitarbeiter ___ mehr Geld bekommen, und der Chef ___ zufrieden.",
                 prompt: "Fill both gaps.", options: ["würden … sei", "werden … ist", "würden … ist"], answer: 0,
                 why: "„sie werden“ would look like the normal present, so it becomes the Konjunktiv II: würden. "
                    + "der Chef sei: Konjunktiv I."),
            .build("The witness said she had seen nothing.",
                   words: ["habe", "sie", "Die Zeugin sagte,", "gesehen", "nichts", "hat"],
                   answers: ["Die Zeugin sagte, sie habe nichts gesehen"],
                   why: "Reported past: habe + participle. „hat“ would be the normal Perfekt.")
        ]
    )
}
