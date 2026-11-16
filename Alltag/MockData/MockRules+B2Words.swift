//
//  MockRules+B2Words.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The B2 rules, part 11: connectors, negation, irgend-, position and
/// direction, and es.
extension MockRules {
    static let b2Connectors = GrammarRule(
        id: "b2-zweiteilig", level: .b2, title: "Two-part connectors: zwar … aber, einerseits … andererseits",
        place: "Flat advert", systemImage: "house",
        german: "Die Wohnung ist zwar klein, aber sehr hell.",
        english: "The flat is small, it's true, but very bright.",
        tiles: [Tile(text: "Die Wohnung ist"), Tile(text: "zwar", role: .key), Tile(text: "klein,"), Tile(text: "aber", role: .key),
                Tile(text: "sehr hell.")],
        notice: "„zwar“ admits a point, and „aber“ brings the one that counts more.",
        rule: "zwar … aber: yes, but. einerseits … andererseits: on the one hand, on the other. nicht … sondern: not this but that. "
            + "teils … teils: partly. je … umso: the more … the more. sowohl … als auch and weder … noch are in B1.",
        visual: RuleVisual(
            source: Part(systemImage: "hand.thumbsdown.fill", german: "zwar klein", marked: "zwar", role: "admitted"),
            target: Part(systemImage: "hand.thumbsup.fill", german: "aber hell", marked: "aber", role: "what counts"),
            sentence: "Zwar klein, aber hell.",
            columns: ["means", "example"],
            rows: [
                Row(label: "zwar … aber", cells: ["yes, but", "zwar teuer, aber gut"], marked: [0]),
                Row(label: "einerseits … andererseits", cells: ["on the one hand …", "einerseits gern, andererseits …"]),
                Row(label: "nicht … sondern", cells: ["not … but", "nicht heute, sondern morgen"]),
                Row(label: "teils … teils", cells: ["partly", "teils sonnig, teils bewölkt"]),
                Row(label: "je … umso", cells: ["the more …", "je früher, umso besser"])
            ]
        ),
        exam: [
            .gap(.easy, "Ich komme nicht heute, ___ morgen.", options: ["sondern", "aber", "oder"], answer: 0,
                 why: "After nicht, the right one comes with sondern: nicht heute, sondern morgen."),
            .gap(.medium, "___ verdiene ich hier mehr, ___ ist der Weg zur Arbeit sehr weit.", prompt: "Fill both gaps.",
                 options: ["Einerseits … andererseits", "Zwar … sondern", "Teils … andererseits"], answer: 0,
                 why: "Two sides of one decision: einerseits … andererseits. Each takes position 1, so the verb follows."),
            .build("The job is well paid, it's true, but very stressful.",
                   words: ["aber", "Der Job", "sehr stressig", "zwar", "ist", "gut bezahlt,", "sondern"],
                   answers: ["Der Job ist zwar gut bezahlt, aber sehr stressig"],
                   why: "zwar admits the good point, and aber brings the one that counts. sondern only follows nicht or kein.")
        ]
    )

    static let b2Negation = GrammarRule(
        id: "b2-negation", level: .b2, title: "Negation words: nie, niemand, nirgends",
        place: "Looking for your keys", systemImage: "key",
        german: "Ich habe meinen Schlüssel nirgends gefunden.",
        english: "I couldn't find my key anywhere.",
        tiles: [Tile(text: "Ich habe meinen Schlüssel"), Tile(text: "nirgends", role: .key), Tile(text: "gefunden.", role: .end)],
        notice: "„nirgends“ is „nicht“ + „irgendwo“: one word does the job.",
        rule: "German uses one negative word in a sentence: nie, niemand, nichts, nirgends or kein. Their opposites: immer, "
            + "jemand, etwas, überall. Not yet: noch nicht. No longer: nicht mehr. Yes to a negative question: doch.",
        visual: RuleVisual(
            source: Part(systemImage: "mappin.and.ellipse", german: "überall", role: "everywhere"),
            target: Part(systemImage: "xmark.circle.fill", german: "nirgends", marked: "nirgends", role: "nowhere"),
            sentence: "Überall. Nirgends.",
            columns: ["yes", "no"],
            rows: [
                Row(label: "time", cells: ["immer, schon", "nie, noch nicht"], marked: [1]),
                Row(label: "people", cells: ["jemand", "niemand"], marked: [1]),
                Row(label: "things", cells: ["etwas", "nichts"], marked: [1]),
                Row(label: "places", cells: ["überall", "nirgends"], marked: [1])
            ],
            isLinked: false
        ),
        exam: [
            .gap(.easy, "Ich habe ___ verstanden. Kannst du das wiederholen?", options: ["nichts", "niemand", "nie"], answer: 0,
                 why: "No thing at all: nichts."),
            .gap(.medium, "Hast du keinen Hunger? — ___! Ich habe seit heute Morgen ___ gegessen.", prompt: "Fill both gaps.",
                 options: ["Doch … nichts", "Ja … nichts", "Doch … etwas"], answer: 0,
                 why: "Yes to a negative question is doch. Eaten nothing: nichts."),
            .build("Nobody here knows anything about it.",
                   words: ["weiß", "etwas", "Niemand", "davon", "hier", "nichts"],
                   answers: ["Niemand hier weiß etwas davon"],
                   why: "German takes one negative word: niemand. So the second is etwas, not nichts.")
        ]
    )

    static let b2Irgend = GrammarRule(
        id: "b2-irgend", level: .b2, title: "irgend-: irgendwo, irgendwann, irgendein",
        place: "Message from a friend", systemImage: "message",
        german: "Lass uns irgendwann nächste Woche irgendwo essen gehen.",
        english: "Let's go out to eat somewhere sometime next week.",
        tiles: [Tile(text: "Lass uns"), Tile(text: "irgendwann", role: .key), Tile(text: "nächste Woche"),
                Tile(text: "irgendwo", role: .key), Tile(text: "essen gehen.")],
        notice: "„irgend-“ means it doesn't matter, or you don't know exactly: some time, some place.",
        rule: "irgend- makes a word vague: irgendwo, irgendwann, irgendwie, irgendjemand, irgendetwas. "
            + "irgendein means some or any, and takes ein's endings: irgendeinen Stift.",
        visual: RuleVisual(
            source: Part(systemImage: "mappin.and.ellipse", german: "wo", role: "where"),
            verb: "+ irgend-",
            target: Part(systemImage: "map.fill", german: "irgendwo", marked: "irgend", role: "somewhere"),
            sentence: "Wo. Irgendwo.",
            columns: ["means", "example"],
            rows: [
                Row(label: "irgendwo", cells: ["somewhere", "irgendwo in Berlin"]),
                Row(label: "irgendwann", cells: ["sometime", "irgendwann im Mai"]),
                Row(label: "irgendwie", cells: ["somehow", "Das geht irgendwie."]),
                Row(label: "irgendein", cells: ["some, any", "irgendein Buch"])
            ]
        ),
        exam: [
            .gap(.easy, "Ich habe meine Brille ___ liegen lassen.", options: ["irgendwo", "irgendwann", "irgendwie"], answer: 0,
                 why: "A place you don't know: irgendwo."),
            .gap(.medium, "Gib mir ___ Stift, egal welchen, und ___ Karte.", prompt: "Fill both gaps.",
                 hint: "der Stift · die Karte",
                 options: ["irgendeinen … irgendeine", "irgendein … irgendeine", "irgendeinen … irgendeinen"], answer: 0,
                 why: "irgendein takes ein's endings: einen Stift → irgendeinen Stift, eine Karte → irgendeine Karte."),
            .build("Somebody called you.", prompt: "Build the sentence. Two tiles are left over.",
                   words: ["hat", "dir", "angerufen", "Irgendjemand", "dich", "Irgendwo"],
                   answers: ["Irgendjemand hat dich angerufen"],
                   why: "A person you don't know: irgendjemand. anrufen takes the accusative: dich.")
        ]
    )

    static let b2Direction = GrammarRule(
        id: "b2-richtung", level: .b2, title: "Position or movement: stehen or stellen",
        place: "Moving furniture", systemImage: "sofa",
        german: "Wir stellen das Sofa ans Fenster. Dann steht es in der Sonne.",
        english: "We're putting the sofa by the window. Then it's in the sun.",
        tiles: [Tile(text: "Wir"), Tile(text: "stellen", role: .verb), Tile(text: "das Sofa ans Fenster. Dann"),
                Tile(text: "steht", role: .verb), Tile(text: "es in der Sonne.")],
        notice: "„stellen“ is the movement, with the accusative. „stehen“ is where it ends up, with the dative.",
        rule: "Movement takes the accusative and regular verbs: stellen, legen, setzen, hängen (hängte). Position takes the dative "
            + "and irregular verbs: stehen, liegen, sitzen, hängen (hing). In speech, herauf, herein become rauf, rein.",
        visual: RuleVisual(
            source: Part(systemImage: "arrow.down.circle.fill", german: "auf den Tisch legen", marked: "den", role: "movement",
                         name: "Accusative"),
            target: Part(systemImage: "book.closed.fill", german: "auf dem Tisch liegen", marked: "dem", role: "position",
                         name: "Dative"),
            sentence: "Auf den Tisch legen. Auf dem Tisch liegen.",
            columns: ["movement (acc.)", "position (dat.)"],
            rows: [
                Row(label: "upright", cells: ["stellen, stellte", "stehen, stand"]),
                Row(label: "flat", cells: ["legen, legte", "liegen, lag"]),
                Row(label: "seated", cells: ["setzen, setzte", "sitzen, saß"]),
                Row(label: "hanging", cells: ["hängen, hängte", "hängen, hing"], marked: [0, 1])
            ]
        ),
        exam: [
            .gap(.easy, "Das Buch ___ auf dem Tisch.", options: ["liegt", "legt", "stellt"], answer: 0,
                 why: "Where it is, with the dative: liegen. legen is the movement."),
            .gap(.medium, "Ich habe den Mantel an den Haken ___, und jetzt ___ er dort.", prompt: "Fill both gaps.",
                 options: ["gehängt … hängt", "gehangen … hängt", "gehängt … hängte"], answer: 0,
                 why: "The movement is regular: hängen, hängte, gehängt. Where it is now: er hängt."),
            .build("Come down, dinner is on the table.", prompt: "Build the sentence. Two tiles are left over.",
                   words: ["steht", "Komm", "das Essen", "rauf,", "auf dem Tisch", "runter,", "stellt"],
                   answers: ["Komm runter, das Essen steht auf dem Tisch"],
                   why: "Down towards the speaker: runter. The food is in place: steht, with auf dem Tisch.")
        ]
    )

    static let b2Es = GrammarRule(
        id: "b2-es", level: .b2, title: "The word es",
        place: "Email from work", systemImage: "at",
        german: "Es freut mich, dass Sie Zeit für ein Gespräch haben.",
        english: "I'm pleased that you have time for a meeting.",
        tiles: [Tile(text: "Es", role: .key), Tile(text: "freut mich,"), Tile(text: "dass", role: .key),
                Tile(text: "Sie Zeit für ein Gespräch"), Tile(text: "haben.", role: .end)],
        notice: "„Es“ holds the place of the dass-clause, which comes later.",
        rule: "es can be a pronoun (das Buch → es), a subject with no doer (es regnet, es gibt, es geht mir gut), or a placeholder "
            + "for a dass- or zu-clause that comes later. The placeholder goes when something else takes position 1: Mich freut, dass …",
        visual: RuleVisual(
            source: Part(systemImage: "cloud.rain.fill", german: "Es regnet.", marked: "Es", role: "no doer"),
            target: Part(systemImage: "arrow.right", german: "Es freut mich, dass …", marked: "Es", role: "placeholder"),
            sentence: "Es regnet. Es freut mich, dass …",
            columns: ["es is", "example"],
            rows: [
                Row(label: "weather, time", cells: ["the subject", "Es ist kalt."]),
                Row(label: "es gibt", cells: ["the subject", "Es gibt Kuchen."]),
                Row(label: "a clause later", cells: ["a placeholder", "Es ist schön, dass du da bist."], marked: [0]),
                Row(label: "something else first", cells: ["dropped", "Mich freut, dass du da bist."])
            ],
            isLinked: false
        ),
        exam: [
            .gap(.easy, "___ gibt heute Fisch.", options: ["Es", "Das", "Er"], answer: 0,
                 why: "„es gibt“ always takes es: Es gibt heute Fisch."),
            .gap(.medium, "Wie geht ___ dir? — Danke, mir geht ___ gut.", prompt: "Fill both gaps.",
                 options: ["es … es", "du … es", "es … er"], answer: 0,
                 why: "„es geht“ has no doer: es stays in both, and the person is in the dative."),
            .build("It's important that you come on time.",
                   words: ["wichtig,", "Es ist", "kommst", "dass", "pünktlich", "du", "bist"],
                   answers: ["Es ist wichtig, dass du pünktlich kommst"],
                   why: "es holds position 1 for the dass-clause, and the verb of the dass-clause goes last.")
        ]
    )
}
