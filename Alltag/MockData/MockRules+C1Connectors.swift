//
//  MockRules+C1Connectors.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The C1 rules, part 4: one idea, three tools. A preposition takes a noun,
/// an adverb stands alone in position 1, and a connector starts a clause with
/// the verb at the end: for time, for reason and contrast, and for means,
/// condition and purpose.
extension MockRules {
    static let c1TimeLinks = GrammarRule(
        id: "c1-verbinden-zeit", level: .c1, title: "nach, danach or nachdem? Linking times",
        place: "Planning a weekend", systemImage: "calendar",
        german: "Nach dem Essen gehen wir spazieren. Danach trinken wir Kaffee.",
        english: "After the meal we go for a walk. After that we have coffee.",
        tiles: [Tile(text: "Nach", role: .key), Tile(text: "dem Essen gehen wir spazieren."), Tile(text: "Danach", role: .key),
                Tile(text: "trinken", role: .verb), Tile(text: "wir Kaffee.")],
        notice: "„nach“ needs a noun. „danach“ stands alone in position 1, so the verb follows at once. "
            + "„nachdem“ would start a clause with the verb at the end.",
        rule: "One idea, three tools: a preposition takes a noun (vor dem Essen), an adverb stands alone and fills "
            + "position 1 (vorher), a connector starts a clause with the verb at the end (bevor wir essen).",
        visual: RuleVisual(
            source: Part(systemImage: "fork.knife", german: "nach dem Essen", marked: "nach", role: "+ a noun",
                         name: "preposition"),
            target: Part(systemImage: "figure.walk", german: "nachdem wir gegessen haben", marked: "nachdem",
                         role: "+ a clause", name: "connector"),
            sentence: "Nach dem Essen. Nachdem wir gegessen haben.",
            columns: ["+ noun", "alone", "+ clause"],
            rows: [
                Row(label: "before", cells: ["vor", "vorher", "bevor"], marked: [2]),
                Row(label: "after", cells: ["nach", "danach", "nachdem"], marked: [2]),
                Row(label: "during", cells: ["während", "währenddessen", "während"], marked: [2]),
                Row(label: "since", cells: ["seit", "seitdem", "seit"], marked: [2]),
                Row(label: "until", cells: ["bis zu", "bis dahin", "bis"], marked: [2])
            ],
            isLinked: false
        ),
        exam: [
            .gap(.easy, "___ ich ins Bett gehe, lese ich noch ein bisschen.", options: ["Vor", "Vorher", "Bevor"], answer: 2,
                 why: "A whole clause follows, with its verb at the end: that needs the connector, bevor."),
            .gap(.medium, "___ der Arbeit gehe ich einkaufen. ___ koche ich.", prompt: "Fill both gaps.",
                 options: ["Nachdem … Danach", "Nach … Danach", "Nach … Nachdem"], answer: 1,
                 why: "„der Arbeit“ is a noun, so the preposition: nach. The second sentence has no noun after the gap, "
                    + "just the verb: the adverb danach."),
            .build("After he had finished his degree, he moved to Hamburg.", prompt: "Build the sentence. Two tiles are left over.",
                   words: ["Nachdem", "Danach", "er", "sein Studium", "abgeschlossen hatte,", "Nach", "zog er", "nach Hamburg"],
                   answers: ["Nachdem er sein Studium abgeschlossen hatte, zog er nach Hamburg"],
                   why: "nachdem starts a clause, with the verb at the end, and the earlier action takes the Plusquamperfekt. "
                    + "That clause is position 1, so the main clause starts with its verb: zog er.")
        ]
    )

    static let c1ReasonLinks = GrammarRule(
        id: "c1-verbinden-grund", level: .c1, title: "trotz, trotzdem or obwohl? Reason, result and contrast",
        place: "Station announcement", systemImage: "tram",
        german: "Trotz des Streiks fährt die S-Bahn. Trotzdem kommen viele zu spät.",
        english: "Despite the strike, the S-Bahn is running. Even so, many people are late.",
        tiles: [Tile(text: "Trotz", role: .key), Tile(text: "des Streiks fährt die S-Bahn."), Tile(text: "Trotzdem", role: .key),
                Tile(text: "kommen", role: .verb), Tile(text: "viele zu spät.")],
        notice: "„trotz“ takes a noun in the genitive. „trotzdem“ fills position 1, so the verb comes straight after. "
            + "„obwohl“ would send the verb to the end.",
        rule: "Reason: wegen, deshalb, weil. Result: infolge, folglich, sodass. Despite: trotz, trotzdem, obwohl. "
            + "Contrast: statt, stattdessen, während. Each time a preposition, an adverb and a connector.",
        visual: RuleVisual(
            source: Part(systemImage: "cloud.rain", german: "trotz des Regens", marked: "trotz", role: "+ a noun",
                         name: "preposition"),
            target: Part(systemImage: "figure.walk", german: "obwohl es regnet", marked: "obwohl", role: "+ a clause",
                         name: "connector"),
            sentence: "Trotz des Regens. Obwohl es regnet.",
            columns: ["+ noun", "alone", "+ clause"],
            rows: [
                Row(label: "reason", cells: ["wegen", "deshalb", "weil"], marked: [1]),
                Row(label: "result", cells: ["infolge", "folglich", "sodass"], marked: [1]),
                Row(label: "despite", cells: ["trotz", "trotzdem", "obwohl"], marked: [1]),
                Row(label: "contrast", cells: ["statt", "stattdessen", "während"], marked: [1])
            ],
            isLinked: false
        ),
        exam: [
            .gap(.easy, "Es regnete stark. ___ fand das Konzert statt.", options: ["Obwohl", "Trotz", "Trotzdem"], answer: 2,
                 why: "trotzdem is an adverb: it stands alone in position 1, and the verb follows."),
            .gap(.medium, "___ eines Unfalls war die Autobahn gesperrt, ___ wir zwei Stunden im Stau standen.",
                 prompt: "Fill both gaps.",
                 options: ["Folglich … sodass", "Infolge … folglich", "Infolge … sodass"], answer: 2,
                 why: "infolge + genitive names the cause. sodass starts a clause for the result, with the verb at the end."),
            .build("The flight was cancelled, so we took the train instead.", prompt: "Build the sentence. Two tiles are left over.",
                   words: ["Der Flug", "statt", "fiel aus,", "deshalb", "wir nahmen", "nahmen wir", "stattdessen", "den Zug"],
                   answers: ["Der Flug fiel aus, deshalb nahmen wir stattdessen den Zug"],
                   why: "deshalb is an adverb in position 1 of its clause, so the verb follows: nahmen wir. "
                    + "stattdessen stands alone; statt would need a noun.")
        ]
    )

    static let c1MeansLinks = GrammarRule(
        id: "c1-verbinden-mittel", level: .c1, title: "durch, dadurch or indem? Means, condition and purpose",
        place: "Health insurance leaflet", systemImage: "cross.case",
        german: "Sie bleiben gesund, indem Sie sich regelmäßig bewegen.",
        english: "You stay healthy by exercising regularly.",
        tiles: [Tile(text: "Sie bleiben gesund,"), Tile(text: "indem", role: .key), Tile(text: "Sie sich regelmäßig"),
                Tile(text: "bewegen", role: .end)],
        notice: "„indem“ says how: by doing what. Its verb goes to the end. With a noun it would be "
            + "„durch regelmäßige Bewegung“.",
        rule: "Means: durch, dadurch, indem. Condition: bei, dann, wenn or falls. Purpose: für or zu, dafür or dazu, "
            + "damit or um … zu. Without: ohne, –, ohne dass or ohne … zu.",
        visual: RuleVisual(
            source: Part(systemImage: "figure.run", german: "durch Sport", marked: "durch", role: "+ a noun",
                         name: "preposition"),
            target: Part(systemImage: "heart.fill", german: "indem man Sport treibt", marked: "indem", role: "+ a clause",
                         name: "connector"),
            sentence: "Durch Sport. Indem man Sport treibt.",
            columns: ["+ noun", "alone", "+ clause"],
            rows: [
                Row(label: "means", cells: ["durch", "dadurch", "indem"], marked: [2]),
                Row(label: "condition", cells: ["bei", "dann", "wenn, falls"], marked: [2]),
                Row(label: "purpose", cells: ["für, zu", "dafür, dazu", "damit,\num … zu"], marked: [2]),
                Row(label: "without", cells: ["ohne", "–", "ohne dass,\nohne … zu"], marked: [2])
            ],
            isLinked: false
        ),
        exam: [
            .gap(.easy, "Man lernt eine Sprache am besten, ___ man viel spricht.", options: ["durch", "dadurch", "indem"],
                 answer: 2,
                 why: "A clause follows, with its verb at the end, and it says how: indem."),
            .gap(.medium, "Ich spare Geld, ___ ich mit dem Rad fahre, ___ ich mir im Sommer eine Reise leisten kann.",
                 prompt: "Fill both gaps.",
                 options: ["indem … damit", "dadurch … damit", "indem … um"], answer: 0,
                 why: "indem says how I save: by cycling. damit gives the purpose with a clause of its own; "
                    + "um would need zu and an infinitive."),
            .build("By checking the data carefully, we found the mistake.", prompt: "Build the sentence. Two tiles are left over.",
                   words: ["Durch", "Dadurch, dass", "wir", "die Daten", "genau", "indem", "prüften,", "fanden wir", "den Fehler"],
                   answers: ["Dadurch, dass wir die Daten genau prüften, fanden wir den Fehler"],
                   why: "dadurch, dass works like indem: it says how, with the verb at the end. "
                    + "Durch would need a noun: durch die genaue Prüfung der Daten.")
        ]
    )
}
