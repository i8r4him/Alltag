//
//  MockRules+B1Werden.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The B1 rules, part 5: werden, for the future, the passive and
/// Konjunktiv II, and werden on its own.
extension MockRules {
    static let b1Future = GrammarRule(
        id: "b1-futur", level: .b1, title: "The future: werden + infinitive",
        place: "Weather on the radio", systemImage: "radio",
        german: "Morgen wird es in ganz Deutschland regnen.",
        english: "Tomorrow it will rain all over Germany.",
        tiles: [Tile(text: "Morgen"), Tile(text: "wird", role: .verb), Tile(text: "es in ganz Deutschland"),
                Tile(text: "regnen.", role: .end)],
        notice: "„wird“ in position 2, „regnen“ at the end. For plans, German often just uses the present: „Morgen regnet es.“",
        rule: "werden + an infinitive at the end talks about the future, above all forecasts and promises. "
            + "For plans, the present with a time word is enough.",
        visual: RuleVisual(
            source: Part(systemImage: "2.circle.fill", german: "wird", marked: "wird", role: "Position 2: werden"),
            target: Part(systemImage: "arrow.right.to.line", german: "regnen", marked: "regnen", role: "The end: the infinitive"),
            sentence: "Es wird regnen.",
            columns: ["one", "several"],
            rows: [
                Row(label: "the speaker", cells: ["ich werde", "wir werden"]),
                Row(label: "spoken to", cells: ["du wirst", "ihr werdet"], marked: [0]),
                Row(label: "spoken about", cells: ["er wird", "sie werden"], marked: [0])
            ]
        ),
        exam: [
            .gap(.easy, "Ich ___ dich morgen anrufen.", options: ["werde", "wird", "wirst"], answer: 0,
                 why: "ich werde: werden in position 2, and anrufen at the end."),
            .gap(.medium, "___ du nächstes Jahr in Berlin ___?", prompt: "Fill both gaps.", hint: "werden · studieren",
                 options: ["Wirst … studieren", "Wird … studieren", "Wirst … studierst"], answer: 0,
                 why: "du wirst, and the second verb stays an infinitive at the end: studieren."),
            .build("I will help you tomorrow.", prompt: "Build the sentence. Two tiles are left over.",
                   words: ["helfen", "wird", "dir", "Ich", "helfe", "morgen", "werde"],
                   answers: ["Ich werde dir morgen helfen"],
                   why: "ich werde in position 2, and the action at the end as an infinitive: helfen.")
        ]
    )

    static let b1Passive = GrammarRule(
        id: "b1-passiv", level: .b1, title: "The passive: Das wird gemacht",
        place: "Notice in your building", systemImage: "building.2",
        german: "Die Mülltonnen werden jeden Dienstag geleert.",
        english: "The bins are emptied every Tuesday.",
        tiles: [Tile(text: "Die Mülltonnen"), Tile(text: "werden", role: .verb), Tile(text: "jeden Dienstag"),
                Tile(text: "geleert.", role: .end)],
        notice: "Nobody says who empties them. „werden“ in position 2, the participle „geleert“ at the end.",
        rule: "The passive puts the action first, not who does it: werden + the participle at the end. "
            + "In the simple past werden becomes wurde. Add von + dative only if the doer matters.",
        visual: RuleVisual(
            source: Part(systemImage: "person.fill", german: "Man repariert das Auto.", role: "active: someone does it"),
            target: Part(systemImage: "car.fill", german: "Das Auto wird repariert.", marked: "wird", role: "passive: it is done"),
            sentence: "Man repariert das Auto. Das Auto wird repariert.",
            columns: ["now", "simple past"],
            rows: [
                Row(label: "one thing", cells: ["wird gemacht", "wurde gemacht"], marked: [1]),
                Row(label: "several", cells: ["werden gemacht", "wurden gemacht"], marked: [1])
            ]
        ),
        exam: [
            .gap(.easy, "Das Paket ___ morgen geliefert.", options: ["wird", "werden", "wirst"], answer: 0,
                 why: "One parcel: wird, and the participle at the end: wird geliefert."),
            .gap(.medium, "Das Haus ___ 1910 ___.", prompt: "Fill both gaps.", hint: "bauen",
                 options: ["wurde … gebaut", "wird … gebaut", "wurde … bauen"], answer: 0,
                 why: "1910 is in the past: wurde. The participle goes to the end: gebaut."),
            .build("The letter was written by the boss.", prompt: "Build the sentence. Two tiles are left over.",
                   words: ["von", "die Chefin", "Der Brief", "geschrieben", "wird", "der Chefin", "wurde"],
                   answers: ["Der Brief wurde von der Chefin geschrieben"],
                   why: "The past: wurde. The doer comes with von + dative: von der Chefin. The participle goes to the end.")
        ]
    )

    static let b1Subjunctive = GrammarRule(
        id: "b1-konjunktiv-zwei", level: .b1, title: "Konjunktiv II: würde, hätte, wäre",
        place: "At a restaurant", systemImage: "fork.knife",
        german: "Ich hätte gern die Suppe. Könnten Sie mir auch ein Wasser bringen?",
        english: "I'd like the soup. Could you bring me a water as well?",
        tiles: [Tile(text: "Ich"), Tile(text: "hätte", role: .verb), Tile(text: "gern die Suppe."), Tile(text: "Könnten", role: .verb),
                Tile(text: "Sie mir auch ein Wasser"), Tile(text: "bringen?", role: .end)],
        notice: "„hätte“ and „könnten“ sound softer than „habe“ and „können“. That's how you order politely.",
        rule: "Konjunktiv II is for wishes, advice, polite requests and things that aren't real. sein, haben and "
            + "the modal verbs have their own forms (wäre, hätte, könnte); most other verbs take würde + infinitive.",
        visual: RuleVisual(
            source: Part(systemImage: "checkmark.circle.fill", german: "Ich habe Zeit.", role: "real"),
            target: Part(systemImage: "sparkles", german: "Ich hätte gern Zeit.", marked: "hätte", role: "a wish"),
            sentence: "Ich habe Zeit. Ich hätte gern Zeit.",
            columns: ["ich · er", "du", "wir · sie"],
            rows: [
                Row(label: "sein", cells: ["wäre", "wärst", "wären"], marked: [0]),
                Row(label: "haben", cells: ["hätte", "hättest", "hätten"], marked: [0]),
                Row(label: "können", cells: ["könnte", "könntest", "könnten"], marked: [0]),
                Row(label: "other verbs", cells: ["würde …", "würdest …", "würden …"], marked: [0])
            ],
            isLinked: false
        ),
        exam: [
            .gap(.easy, "Wenn ich mehr Zeit ___, würde ich mehr lesen.", options: ["hätte", "habe", "hatte"], answer: 0,
                 why: "It isn't real, so haben becomes hätte."),
            .gap(.medium, "An deiner Stelle ___ ich zum Arzt ___.", prompt: "Fill both gaps.", hint: "advice",
                 options: ["würde … gehen", "werde … gehen", "würde … gehe"], answer: 0,
                 why: "Advice: würde + the infinitive at the end. „werde“ would be the future."),
            .build("If I were rich, I would travel around the world.",
                   words: ["würde", "war,", "Wenn ich", "reisen", "reich", "ich", "um die Welt", "wäre,"],
                   answers: ["Wenn ich reich wäre, würde ich um die Welt reisen"],
                   why: "It isn't real: wäre, not war. After the wenn-clause, the main clause starts with its verb: würde ich … reisen.")
        ]
    )

    static let b1UsesOfWerden = GrammarRule(
        id: "b1-werden", level: .b1, title: "The four jobs of werden",
        place: "At a birthday party", systemImage: "gift.fill",
        german: "Mein Sohn wird morgen zehn.",
        english: "My son turns ten tomorrow.",
        tiles: [Tile(text: "Mein Sohn"), Tile(text: "wird", role: .verb), Tile(text: "morgen"), Tile(text: "zehn.", role: .end)],
        notice: "Here „werden“ is a verb on its own: to become. „zehn werden“ is how you say „turn ten“.",
        rule: "werden on its own means to become. With an infinitive it makes the future, "
            + "with a participle the passive, and as würde it makes Konjunktiv II.",
        visual: RuleVisual(
            source: Part(systemImage: "figure.child", german: "Er ist neun.", role: "now"),
            verb: "wird",
            target: Part(systemImage: "figure.stand", german: "Er wird zehn.", marked: "wird", role: "becomes"),
            sentence: "Er ist neun. Er wird zehn.",
            columns: ["for example", "means"],
            rows: [
                Row(label: "on its own", cells: ["Er wird Arzt.", "become"], marked: [1]),
                Row(label: "+ infinitive", cells: ["Es wird regnen.", "future"]),
                Row(label: "+ participle", cells: ["Das wird gemacht.", "passive"]),
                Row(label: "würde", cells: ["Ich würde gehen.", "would"])
            ]
        ),
        exam: [
            .gap(.easy, "Im Herbst ___ die Tage kürzer.", options: ["werden", "wird", "wirst"], answer: 0,
                 why: "die Tage is plural, and they become shorter: werden."),
            .gap(.medium, "Das Fenster ___ morgen ___.", prompt: "Fill both gaps.", hint: "reparieren",
                 options: ["wird … repariert", "wird … reparieren", "würde … repariert"], answer: 0,
                 why: "The window doesn't repair anything: it is repaired. werden with a participle is the passive: wird repariert."),
            .build("She wants to become a doctor.", prompt: "Build the sentence. Two tiles are left over.",
                   words: ["Ärztin", "zu werden", "Sie", "wird", "will", "werden"],
                   answers: ["Sie will Ärztin werden"],
                   why: "werden on its own means to become. After the modal verb „will“ it goes to the end, without zu.")
        ]
    )
}
