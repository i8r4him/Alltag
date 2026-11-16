//
//  MockRules+B2Modal.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The B2 rules, part 6: guesses with werden, the modal verbs, lassen and
/// separable verbs.
extension MockRules {
    static let b2Future = GrammarRule(
        id: "b2-futur", level: .b2, title: "Guessing with werden: Futur I and II",
        place: "Waiting for a friend", systemImage: "clock",
        german: "Sie wird den Zug verpasst haben.",
        english: "She'll have missed the train.",
        tiles: [Tile(text: "Sie"), Tile(text: "wird", role: .verb), Tile(text: "den Zug"), Tile(text: "verpasst haben.", role: .end)],
        notice: "It's a guess about the past: „wird“, then the participle and „haben“ at the end.",
        rule: "werden + infinitive can be a guess about now: Er wird krank sein. Futur II, werden + participle + haben or sein, "
            + "is a guess about the past: Er wird krank gewesen sein. wohl makes the guess clear.",
        visual: RuleVisual(
            source: Part(systemImage: "questionmark.circle.fill", german: "Er wird krank sein.", marked: "wird", role: "a guess about now"),
            target: Part(systemImage: "clock.arrow.circlepath", german: "Er wird krank gewesen sein.", marked: "gewesen sein",
                         role: "a guess about the past"),
            sentence: "Er wird krank sein. Er wird krank gewesen sein.",
            columns: ["the guess"],
            rows: [
                Row(label: "now", cells: ["Er wird im Büro sein."]),
                Row(label: "past, haben", cells: ["Er wird es vergessen haben."], marked: [0]),
                Row(label: "past, sein", cells: ["Er wird nach Hause gegangen sein."], marked: [0])
            ],
            isLinked: false
        ),
        exam: [
            .gap(.easy, "Das Licht ist an. Er ___ wohl zu Hause sein.", options: ["wird", "würde", "wurde"], answer: 0,
                 why: "A guess about now: werden + infinitive. wohl shows it's a guess."),
            .gap(.medium, "Sie ist nicht mehr da. Sie wird schon nach Hause ___ ___.", prompt: "Fill both gaps.",
                 options: ["gegangen … sein", "gegangen … haben", "gehen … sein"], answer: 0,
                 why: "A guess about the past: participle + sein or haben. gehen takes sein: gegangen sein."),
            .build("He will probably have forgotten the appointment.",
                   words: ["vergessen", "Er", "haben", "wohl", "den Termin", "wird", "sein"],
                   answers: ["Er wird den Termin wohl vergessen haben", "Er wird wohl den Termin vergessen haben"],
                   why: "vergessen takes haben in the Perfekt, so the guess is wird … vergessen haben.")
        ]
    )

    static let b2ModalMeaning = GrammarRule(
        id: "b2-modalverben", level: .b2, title: "Modal verbs: what each one means",
        place: "Sign at the swimming pool", systemImage: "water.waves",
        german: "Kinder unter acht Jahren dürfen nur mit Erwachsenen ins Becken.",
        english: "Children under eight may only go in the pool with an adult.",
        tiles: [Tile(text: "Kinder unter acht Jahren"), Tile(text: "dürfen", role: .verb), Tile(text: "nur mit Erwachsenen ins Becken.")],
        notice: "„dürfen“ is about permission. The verb „gehen“ is left out: with a direction, it's clear.",
        rule: "können: able or possible. dürfen: allowed. müssen: necessary. sollen: someone else wants it. wollen: your own plan. "
            + "nicht müssen, or nicht brauchen zu: not necessary. nicht dürfen: not allowed.",
        visual: RuleVisual(
            source: Part(systemImage: "xmark.circle.fill", german: "Du darfst nicht kommen.", marked: "darfst nicht",
                         role: "not allowed"),
            target: Part(systemImage: "checkmark.circle", german: "Du musst nicht kommen.", marked: "musst nicht",
                         role: "not necessary"),
            sentence: "Du darfst nicht kommen. Du musst nicht kommen.",
            columns: ["means", "example"],
            rows: [
                Row(label: "können", cells: ["able, possible", "Ich kann schwimmen."]),
                Row(label: "dürfen", cells: ["allowed", "Hier darf man parken."]),
                Row(label: "müssen", cells: ["necessary", "Ich muss arbeiten."]),
                Row(label: "sollen", cells: ["someone wants it", "Ich soll dich grüßen."], marked: [0]),
                Row(label: "wollen", cells: ["your plan", "Wir wollen umziehen."])
            ],
            isLinked: false
        ),
        exam: [
            .gap(.easy, "Du ___ nicht kommen, wenn du keine Zeit hast.", prompt: "It isn't necessary. Fill the gap.",
                 options: ["musst", "darfst", "sollst"], answer: 0,
                 why: "nicht müssen means it isn't necessary. nicht dürfen would mean you're not allowed."),
            .gap(.medium, "Der Arzt sagt, ich ___ weniger Kaffee trinken, aber ich ___ nicht aufhören.", prompt: "Fill both gaps.",
                 options: ["soll … will", "will … soll", "darf … soll"], answer: 0,
                 why: "sollen: someone else wants it, here the doctor. wollen: what you want yourself."),
            .build("You don't need to bring anything.", prompt: "Build the sentence. Two tiles are left over.",
                   words: ["nichts", "Du", "mitbringen", "brauchst", "darfst", "mitzubringen"],
                   answers: ["Du brauchst nichts mitzubringen"],
                   why: "nicht brauchen + zu means it isn't necessary. With a separable verb, zu goes in the middle: mitzubringen.")
        ]
    )

    static let b2ModalGuess = GrammarRule(
        id: "b2-modal-vermutung", level: .b2, title: "Modal verbs for guesses: Er muss krank sein",
        place: "The neighbours' house", systemImage: "house",
        german: "Bei Müllers ist alles dunkel. Sie müssen im Urlaub sein.",
        english: "It's all dark at the Müllers'. They must be on holiday.",
        tiles: [Tile(text: "Sie"), Tile(text: "müssen", role: .verb), Tile(text: "im Urlaub"), Tile(text: "sein.", role: .end)],
        notice: "„müssen“ isn't a duty here: it's a guess you're almost sure of.",
        rule: "Modal verbs can show how sure you are: muss (almost certain), dürfte (likely), kann or könnte (possible), "
            + "kann nicht (impossible). For the past: muss … gewesen sein, kann … vergessen haben.",
        visual: RuleVisual(
            source: Part(systemImage: "questionmark.circle", german: "Er könnte krank sein.", marked: "könnte", role: "possible"),
            target: Part(systemImage: "checkmark.circle.fill", german: "Er muss krank sein.", marked: "muss", role: "almost certain"),
            sentence: "Er könnte krank sein. Er muss krank sein.",
            columns: ["how sure", "example"],
            rows: [
                Row(label: "muss", cells: ["almost certain", "Er muss zu Hause sein."], marked: [0]),
                Row(label: "dürfte", cells: ["likely", "Er dürfte zu Hause sein."]),
                Row(label: "kann, könnte", cells: ["possible", "Er könnte zu Hause sein."]),
                Row(label: "kann nicht", cells: ["impossible", "Er kann nicht zu Hause sein."])
            ]
        ),
        exam: [
            .gap(.easy, "Er hat den ganzen Tag gearbeitet. Er ___ müde sein.", options: ["muss", "darf", "will"], answer: 0,
                 why: "You're almost sure, so it is muss: Er muss müde sein."),
            .gap(.medium, "Das ___ nicht stimmen! Ich habe ihn gestern gesehen, er ___ also nicht in Spanien gewesen sein.",
                 prompt: "Fill both gaps.", options: ["kann … kann", "muss … darf", "darf … muss"], answer: 0,
                 why: "kann nicht says it's impossible. For the past: kann nicht … gewesen sein."),
            .build("She must have forgotten the appointment.", prompt: "Build the sentence. Two tiles are left over.",
                   words: ["vergessen", "Sie", "hat", "den Termin", "haben", "muss", "gemusst"],
                   answers: ["Sie muss den Termin vergessen haben"],
                   why: "A guess about the past: the modal verb, then the participle + haben at the end.")
        ]
    )

    static let b2Lassen = GrammarRule(
        id: "b2-lassen", level: .b2, title: "lassen: let, leave, have done",
        place: "At the hairdresser's", systemImage: "scissors",
        german: "Ich lasse mir die Haare schneiden.",
        english: "I'm having my hair cut.",
        tiles: [Tile(text: "Ich"), Tile(text: "lasse", role: .verb), Tile(text: "mir die Haare"), Tile(text: "schneiden.", role: .end)],
        notice: "You don't cut it yourself: „lassen“ + infinitive means someone does it for you.",
        rule: "lassen + infinitive: have something done (Ich lasse das Auto reparieren) or let someone do it (Lass mich gehen!). "
            + "On its own it means leave: Ich lasse den Schlüssel hier. Perfekt with another verb: habe … reparieren lassen.",
        visual: RuleVisual(
            source: Part(systemImage: "person.fill", german: "Ich lasse", marked: "lasse", role: "I arrange it"),
            target: Part(systemImage: "scissors", german: "schneiden", role: "someone else does it"),
            sentence: "Ich lasse mir die Haare schneiden.",
            columns: ["with", "example"],
            rows: [
                Row(label: "have done", cells: ["+ infinitive", "das Auto reparieren lassen"], marked: [1]),
                Row(label: "let", cells: ["+ infinitive", "Lass mich das machen!"]),
                Row(label: "leave", cells: ["on its own", "den Schlüssel hier lassen"])
            ]
        ),
        exam: [
            .gap(.easy, "Ich ___ meinen Computer reparieren.", options: ["lasse", "lässt", "lassen"], answer: 0,
                 why: "ich lasse. With du and er the a changes: du lässt, er lässt."),
            .gap(.medium, "Er ___ sein Fahrrad gestern zu Hause ___.", prompt: "He left it at home. Fill both gaps.",
                 options: ["hat … gelassen", "hat … lassen", "ist … gelassen"], answer: 0,
                 why: "lassen on its own means leave, and with no other verb its participle is gelassen: hat … gelassen."),
            .build("We had the flat painted.",
                   words: ["lassen", "die Wohnung", "Wir", "streichen", "haben", "gelassen"],
                   answers: ["Wir haben die Wohnung streichen lassen"],
                   why: "With another verb, lassen stays an infinitive in the Perfekt: streichen lassen.")
        ]
    )

    static let b2Separable = GrammarRule(
        id: "b2-trennbar", level: .b2, title: "Separable or not: umziehen, unterschreiben",
        place: "Road works", systemImage: "car",
        german: "Die Polizei leitet den Verkehr um. Bitte umfahren Sie die Unfallstelle.",
        english: "The police are diverting the traffic. Please drive around the accident.",
        tiles: [Tile(text: "Die Polizei"), Tile(text: "leitet", role: .verb), Tile(text: "den Verkehr"), Tile(text: "um.", role: .end),
                Tile(text: "Bitte"), Tile(text: "umfahren", role: .key), Tile(text: "Sie die Unfallstelle.")],
        notice: "„umleiten“ splits: „leitet … um“. „umfahren“, to drive around, doesn't split: the stress is on „fahren“.",
        rule: "be-, emp-, ent-, er-, ge-, miss-, ver- and zer- never split. Most other prefixes do (an-, auf-, mit-). "
            + "über-, unter-, um-, durch- and wieder- can do both: a stressed prefix splits, a stressed verb doesn't.",
        visual: RuleVisual(
            source: Part(systemImage: "arrow.uturn.left", german: "Er fährt den Baum um.", marked: "um", role: "UMfahren: knock down"),
            target: Part(systemImage: "arrow.turn.up.right", german: "Er umfährt den Baum.", marked: "umfährt",
                         role: "umFAHren: drive around"),
            sentence: "Er fährt den Baum um. Er umfährt den Baum.",
            columns: ["splits?", "Perfekt"],
            rows: [
                Row(label: "anrufen", cells: ["yes", "angerufen"]),
                Row(label: "verstehen", cells: ["never", "verstanden"], marked: [0]),
                Row(label: "umziehen", cells: ["yes", "umgezogen"]),
                Row(label: "unterschreiben", cells: ["no", "unterschrieben"], marked: [0])
            ],
            isLinked: false
        ),
        exam: [
            .gap(.easy, "Ich ___ dich nicht.", hint: "verstehen", options: ["verstehe", "stehe ver", "verstehen"], answer: 0,
                 why: "ver- never splits: ich verstehe."),
            .gap(.medium, "Er hat den Brief ins Deutsche ___ und ist dann nach Köln ___.", prompt: "Fill both gaps.",
                 hint: "übersetzen · umziehen", options: ["übersetzt … umgezogen", "übergesetzt … umgezogen", "übersetzt … umzogen"],
                 answer: 0,
                 why: "übersetzen, to translate, doesn't split, so it has no ge-: übersetzt. umziehen splits: umgezogen."),
            .build("Please fill in the form and sign it.", prompt: "Build the sentence. Use Sie. One tile is left over.",
                   words: ["und", "unterschreiben Sie", "Bitte", "aus", "das Formular", "es", "füllen Sie", "unter"],
                   answers: ["Bitte füllen Sie das Formular aus und unterschreiben Sie es"],
                   why: "ausfüllen splits: füllen … aus. unterschreiben doesn't: the stress is on schreiben.")
        ]
    )
}
