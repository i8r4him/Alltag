//
//  MockRules+B2Subjunctive.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The B2 rules, part 2: the Konjunktiv II beyond würde, hätte and wäre
/// (B1 has those for wishes, advice and polite requests).
extension MockRules {
    static let b2SubjunctiveForms = GrammarRule(
        id: "b2-konjunktiv2", level: .b2, title: "Konjunktiv II: käme, ginge, wüsste",
        place: "At the station", systemImage: "tram",
        german: "Wüssten Sie, wann der nächste Zug nach Bonn fährt?",
        english: "Would you know when the next train to Bonn leaves?",
        tiles: [Tile(text: "Wüssten", role: .verb), Tile(text: "Sie, wann der nächste Zug nach Bonn fährt?")],
        notice: "„Wüssten“ is the Konjunktiv II of „wissen“: the simple past „wussten“ plus an umlaut.",
        rule: "The Konjunktiv II comes from the simple past, with an umlaut where it can take one: kam → käme, wusste → wüsste. "
            + "Most verbs use würde + infinitive instead; sein, haben, the modal verbs and a few like wissen, kommen, "
            + "gehen and geben keep their own form.",
        visual: RuleVisual(
            source: Part(systemImage: "clock.arrow.circlepath", german: "kam", role: "simple past"),
            verb: "+ umlaut",
            target: Part(systemImage: "sparkles", german: "käme", marked: "ä", role: "Konjunktiv II"),
            sentence: "kam becomes käme.",
            columns: ["ich · er", "du", "wir · sie"],
            rows: [
                Row(label: "kommen", cells: ["käme", "kämst", "kämen"], marked: [0, 1, 2]),
                Row(label: "gehen", cells: ["ginge", "gingst", "gingen"]),
                Row(label: "wissen", cells: ["wüsste", "wüsstest", "wüssten"], marked: [0, 1, 2]),
                Row(label: "geben", cells: ["gäbe", "gäbst", "gäben"], marked: [0, 1, 2]),
                Row(label: "machen", cells: ["würde machen", "würdest machen", "würden machen"])
            ]
        ),
        exam: [
            .gap(.easy, "Ich ___ gern, wie das funktioniert.", hint: "wissen", options: ["wusste", "wüsste", "weiß"], answer: 1,
                 why: "A polite wish takes the Konjunktiv II: wusste + umlaut = wüsste. „wusste“ is the simple past."),
            .gap(.medium, "Es wäre schön, wenn ihr am Wochenende ___. Dann ___ es Kuchen.", prompt: "Fill both gaps.",
                 hint: "kommen · geben", options: ["kämt … gäbe", "kamt … gab", "kämt … gab"], answer: 0,
                 why: "Both are unreal, so both take the Konjunktiv II: kamt → kämt, gab → gäbe. "
                    + "Without the umlaut it is the simple past."),
            .build("If I had a car, I would visit you more often.",
                   words: ["Wenn", "ich ein Auto", "hätte,", "würde", "ich", "dich öfter", "besuchen", "hatte,"],
                   answers: ["Wenn ich ein Auto hätte, würde ich dich öfter besuchen"],
                   why: "haben has its own form: hätte. For besuchen, use würde + infinitive. "
                    + "„hatte“ is the simple past and would mean you really had one.")
        ]
    )

    static let b2SubjunctivePast = GrammarRule(
        id: "b2-konjunktiv2-vergangenheit", level: .b2, title: "Konjunktiv II in the past: hätte gemacht",
        place: "After a missed train", systemImage: "tram",
        german: "Wenn ich früher losgegangen wäre, hätte ich den Zug bekommen.",
        english: "If I'd left earlier, I'd have caught the train.",
        tiles: [Tile(text: "Wenn ich früher"), Tile(text: "losgegangen", role: .end), Tile(text: "wäre,", role: .verb),
                Tile(text: "hätte", role: .verb), Tile(text: "ich den Zug"), Tile(text: "bekommen.", role: .end)],
        notice: "Both halves are about the past, and neither happened: „wäre losgegangen“, „hätte bekommen“.",
        rule: "For something in the past that didn't happen: hätte or wäre + participle. "
            + "Verbs that take sein in the Perfekt take wäre. With a modal verb: hätte … machen können.",
        visual: RuleVisual(
            source: Part(systemImage: "figure.walk", german: "wäre gegangen", marked: "wäre", role: "with sein-verbs"),
            target: Part(systemImage: "phone.fill", german: "hätte angerufen", marked: "hätte", role: "with haben-verbs"),
            sentence: "Ich wäre gegangen. Ich hätte angerufen.",
            columns: ["Perfekt", "Konjunktiv II past"],
            rows: [
                Row(label: "machen", cells: ["habe gemacht", "hätte gemacht"], marked: [1]),
                Row(label: "fahren", cells: ["bin gefahren", "wäre gefahren"], marked: [1]),
                Row(label: "sein", cells: ["bin gewesen", "wäre gewesen"], marked: [1]),
                Row(label: "können", cells: ["habe … können", "hätte … können"], marked: [1])
            ],
            isLinked: false
        ),
        exam: [
            .gap(.easy, "Ich ___ dir gern geholfen, aber ich hatte keine Zeit.", options: ["hätte", "wäre", "habe"], answer: 0,
                 why: "It didn't happen, and helfen takes haben: hätte geholfen."),
            .gap(.medium, "Wenn du ___ wärst, ___ du sie getroffen.", prompt: "Fill both gaps.", hint: "kommen · treffen",
                 options: ["gekommen … hättest", "gekommen … wärst", "kommen … hättest"], answer: 0,
                 why: "kommen takes sein: wärst gekommen. treffen takes haben: hättest getroffen."),
            .build("We would have stayed longer, but it was raining.",
                   words: ["Wir", "wären", "länger", "geblieben,", "aber es hat geregnet", "hätten"],
                   answers: ["Wir wären länger geblieben, aber es hat geregnet"],
                   why: "bleiben takes sein in the Perfekt, so the unreal past is wären geblieben.")
        ]
    )

    static let b2Polite = GrammarRule(
        id: "b2-hoeflich", level: .b2, title: "Very polite: Würden Sie, Dürfte ich",
        place: "On the train", systemImage: "tram",
        german: "Dürfte ich kurz Ihr Telefon benutzen?",
        english: "Might I use your phone for a moment?",
        tiles: [Tile(text: "Dürfte", role: .verb), Tile(text: "ich kurz Ihr Telefon"), Tile(text: "benutzen?", role: .end)],
        notice: "„Dürfte ich“ is the Konjunktiv II of „dürfen“: politer than „Darf ich“.",
        rule: "For very polite requests, use the Konjunktiv II: Würden Sie …?, Hätten Sie …?, Wären Sie so nett …?, Dürfte ich …? "
            + "Softer still: Es wäre nett, wenn … Advice: An Ihrer Stelle würde ich …",
        visual: RuleVisual(
            source: Part(systemImage: "hand.raised.fill", german: "Darf ich …?", role: "polite"),
            target: Part(systemImage: "face.smiling", german: "Dürfte ich …?", marked: "Dürfte", role: "very polite"),
            sentence: "Darf ich becomes Dürfte ich.",
            columns: ["start with", "then"],
            rows: [
                Row(label: "a request", cells: ["Würden Sie …", "… mir helfen?"], marked: [0]),
                Row(label: "have you got", cells: ["Hätten Sie …", "… kurz Zeit?"], marked: [0]),
                Row(label: "may I", cells: ["Dürfte ich …", "… etwas fragen?"], marked: [0]),
                Row(label: "be so kind", cells: ["Wären Sie so nett, …", "… zu warten?"], marked: [0]),
                Row(label: "advice", cells: ["An Ihrer Stelle würde ich …", "… nachfragen."], marked: [0])
            ]
        ),
        exam: [
            .gap(.easy, "___ Sie so nett, mir zu helfen?", options: ["Wären", "Würden", "Hätten"], answer: 0,
                 why: "The phrase is „so nett sein“, so it takes sein: Wären Sie so nett …?"),
            .gap(.medium, "___ Sie kurz Zeit? Es ___ nett, wenn Sie mir das erklären könnten.", prompt: "Fill both gaps.",
                 options: ["Hätten … wäre", "Würden … wäre", "Hätten … hätte"], answer: 0,
                 why: "Zeit haben: Hätten Sie Zeit? nett sein: Es wäre nett."),
            .build("If I were you, I would call the landlord.", prompt: "Build the sentence. Use Sie. One tile is left over.",
                   words: ["An Ihrer Stelle", "würde", "ich", "den Vermieter", "anrufen", "werde"],
                   answers: ["An Ihrer Stelle würde ich den Vermieter anrufen"],
                   why: "„An Ihrer Stelle“ takes position 1, so würde comes next, then ich. „werde“ would be the future, not advice.")
        ]
    )

    static let b2Unreal = GrammarRule(
        id: "b2-irreal", level: .b2, title: "Without wenn: Hätte ich Zeit, …",
        place: "Chat with a friend", systemImage: "message",
        german: "Hätte ich mehr Zeit, würde ich öfter kochen.",
        english: "If I had more time, I'd cook more often.",
        tiles: [Tile(text: "Hätte", role: .verb), Tile(text: "ich mehr Zeit,"), Tile(text: "würde", role: .verb),
                Tile(text: "ich öfter kochen.")],
        notice: "There is no „wenn“: „Hätte“ comes first instead. It means „Wenn ich mehr Zeit hätte“.",
        rule: "An unreal condition can drop wenn; then its verb comes first: Hätte ich Zeit, … "
            + "A wish adds doch, nur or bloß: Wenn ich doch Zeit hätte! or Hätte ich bloß Zeit!",
        visual: RuleVisual(
            source: Part(systemImage: "cloud.rain.fill", german: "Wenn ich Zeit hätte, …", marked: "hätte", role: "with wenn"),
            target: Part(systemImage: "sun.max.fill", german: "Hätte ich Zeit, …", marked: "Hätte", role: "without wenn"),
            sentence: "Wenn ich Zeit hätte. Hätte ich Zeit.",
            columns: ["with wenn", "without wenn"],
            rows: [
                Row(label: "condition", cells: ["Wenn ich Zeit hätte, …", "Hätte ich Zeit, …"], marked: [1]),
                Row(label: "wish", cells: ["Wenn ich doch Zeit hätte!", "Hätte ich doch Zeit!"], marked: [1]),
                Row(label: "past wish", cells: ["Wenn ich bloß gefragt hätte!", "Hätte ich bloß gefragt!"], marked: [1])
            ]
        ),
        exam: [
            .gap(.easy, "___ ich mehr Geld, würde ich ein Auto kaufen.", options: ["Hätte", "Habe", "Wenn"], answer: 0,
                 why: "Without wenn, the verb of the condition comes first, in the Konjunktiv II: Hätte ich mehr Geld, …"),
            .gap(.medium, "___ ich doch nur früher ___!", prompt: "A wish about this morning. Fill both gaps.", hint: "aufstehen",
                 options: ["Wäre … aufgestanden", "Hätte … aufgestanden", "Wäre … aufstehen"], answer: 0,
                 why: "A wish about the past: Konjunktiv II + participle. aufstehen takes sein: Wäre ich doch aufgestanden!"),
            .build("If the weather were better, we'd go for a walk.", prompt: "Build it without „wenn“. One tile is left over.",
                   words: ["würden", "das Wetter", "Wäre", "wir", "besser,", "spazieren gehen", "Wenn"],
                   answers: ["Wäre das Wetter besser, würden wir spazieren gehen"],
                   why: "Without wenn, „Wäre“ comes first. The condition is position 1 of the sentence, so „würden“ follows at once.")
        ]
    )

    static let b2AsIf = GrammarRule(
        id: "b2-als-ob", level: .b2, title: "als ob: as if",
        place: "Talking about a colleague", systemImage: "briefcase",
        german: "Er tut so, als ob er alles wüsste.",
        english: "He acts as if he knew everything.",
        tiles: [Tile(text: "Er tut so,"), Tile(text: "als ob", role: .key), Tile(text: "er alles"), Tile(text: "wüsste.", role: .verb)],
        notice: "He doesn't know everything, so it is the Konjunktiv II: „wüsste“, at the end after „als ob“.",
        rule: "als ob compares with something that isn't true: Konjunktiv II, verb at the end. "
            + "With als alone the verb comes right after it: als wüsste er alles.",
        visual: RuleVisual(
            source: Part(systemImage: "person.fill", german: "Er tut so,", role: "what you see"),
            target: Part(systemImage: "graduationcap.fill", german: "als ob er alles wüsste", marked: "wüsste", role: "not true"),
            sentence: "Er tut so, als ob er alles wüsste.",
            columns: ["the verb", "example"],
            rows: [
                Row(label: "als ob", cells: ["at the end", "als ob er krank wäre"], marked: [1]),
                Row(label: "als", cells: ["right after als", "als wäre er krank"], marked: [1]),
                Row(label: "past", cells: ["hätte, wäre + participle", "als ob er nichts gehört hätte"], marked: [1])
            ]
        ),
        exam: [
            .gap(.easy, "Sie sieht aus, als ob sie nicht geschlafen ___.", options: ["hat", "hätte", "habe"], answer: 1,
                 why: "als ob takes the Konjunktiv II. For the past it is hätte + participle."),
            .gap(.medium, "Er tut so, als ___ er mich nicht kennen.", options: ["ob würde", "würde", "ob wird"], answer: 1,
                 why: "With als alone the verb comes right after it: als würde er mich nicht kennen. With als ob it would go last."),
            .build("It looks as if it's about to rain.",
                   words: ["Es sieht aus,", "als ob", "es", "gleich", "regnen", "würde", "wird"],
                   answers: ["Es sieht aus, als ob es gleich regnen würde"],
                   why: "als ob takes the Konjunktiv II with the verb at the end: regnen würde. „wird“ isn't the Konjunktiv.")
        ]
    )
}
