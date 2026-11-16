//
//  MockRules+A2Places.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The A2 rules, part 4: where something is and where it goes.
extension MockRules {
    static let a2WhereWhereTo = GrammarRule(
        id: "a2-wo-wohin", level: .a2, title: "Wo? or Wohin? auf dem Tisch, auf den Tisch",
        place: "At home", systemImage: "sofa",
        german: "Ich lege das Handy auf den Tisch. Jetzt liegt es auf dem Tisch.",
        english: "I put the phone on the table. Now it's lying on the table.",
        tiles: [Tile(text: "Ich lege das Handy auf"), Tile(text: "den", role: .end), Tile(text: "Tisch. Jetzt liegt es auf"),
                Tile(text: "dem", role: .end), Tile(text: "Tisch.")],
        notice: "„legen“ is a movement, Wohin?: the accusative, den Tisch. „liegen“ is a place, Wo?: the dative, dem Tisch.",
        rule: "After in, an, auf, unter, über, vor, hinter, neben and zwischen, a movement (Wohin?) takes the accusative "
            + "and a place (Wo?) the dative.",
        visual: RuleVisual(
            source: Part(systemImage: "arrow.down.to.line", german: "auf den Tisch", marked: "den", role: "Wohin?", name: "Accusative"),
            target: Part(systemImage: "table.furniture.fill", german: "auf dem Tisch", marked: "dem", role: "Wo?", name: "Dative"),
            sentence: "Ich lege es auf den Tisch. Es liegt auf dem Tisch.",
            columns: ["Wohin?", "Wo?"],
            rows: [
                Row(label: "masc.", cells: ["in den Park", "im Park"], marked: [0, 1]),
                Row(label: "fem.", cells: ["in die Küche", "in der Küche"], marked: [1]),
                Row(label: "neut.", cells: ["ins Kino", "im Kino"], marked: [0, 1]),
                Row(label: "verbs", cells: ["legen, stellen, hängen", "liegen, stehen, hängen"])
            ]
        ),
        exam: [
            .gap(.easy, "Wir gehen heute Abend ___ Kino.", hint: "das Kino", options: ["ins", "im", "in die"], answer: 0,
                 why: "Going is a movement, Wohin?: the accusative, in das Kino, shortened to ins."),
            .gap(.medium, "Ich stelle die Flasche ___ Kühlschrank. Jetzt steht sie ___ Kühlschrank.", prompt: "Fill both gaps.",
                 hint: "der Kühlschrank", options: ["in den … im", "im … in den", "in den … in den"], answer: 0,
                 why: "„stellen“ is a movement: in den Kühlschrank. „stehen“ is the place: in dem Kühlschrank, shortened to im."),
            .build("Hang the picture on the wall.", prompt: "You say it to a friend. One tile is left over.",
                   words: ["die Wand", "Häng", "der Wand", "an", "das Bild"],
                   answers: ["Häng das Bild an die Wand"],
                   why: "Hanging it up is a movement, Wohin?: an die Wand. „an der Wand“ is where it hangs afterwards.")
        ]
    )

    static let a2ToAtFrom = GrammarRule(
        id: "a2-zum-beim", level: .a2, title: "zum Arzt, beim Arzt, vom Arzt",
        place: "Message from a friend", systemImage: "message",
        german: "Ich bin noch beim Arzt. Danach gehe ich zum Bäcker.",
        english: "I'm still at the doctor's. After that I'm going to the baker's.",
        tiles: [Tile(text: "Ich bin noch"), Tile(text: "beim", role: .key), Tile(text: "Arzt. Danach gehe ich"),
                Tile(text: "zum", role: .key), Tile(text: "Bäcker.")],
        notice: "At a person's place German uses „bei“: beim Arzt. Going to a person takes „zu“: zum Bäcker.",
        rule: "To a person: zu. At a person's: bei. From a person: von. Cities and countries take nach, in and aus, "
            + "and home is nach Hause and zu Hause.",
        visual: RuleVisual(
            source: Part(systemImage: "figure.walk", german: "zum Arzt", marked: "zum", role: "Wohin?"),
            target: Part(systemImage: "stethoscope", german: "beim Arzt", marked: "beim", role: "Wo?"),
            sentence: "Ich gehe zum Arzt. Ich bin beim Arzt.",
            columns: ["Wohin?", "Wo?", "Woher?"],
            rows: [
                Row(label: "a person", cells: ["zum Arzt", "beim Arzt", "vom Arzt"], marked: [0, 1, 2]),
                Row(label: "a building", cells: ["in die Schule", "in der Schule", "aus der Schule"]),
                Row(label: "a city", cells: ["nach Berlin", "in Berlin", "aus Berlin"]),
                Row(label: "home", cells: ["nach Hause", "zu Hause", "von zu Hause"], marked: [0, 1])
            ]
        ),
        exam: [
            .gap(.easy, "Ich muss heute noch ___ Friseur.", hint: "der Friseur", options: ["zum", "beim", "nach"], answer: 0,
                 why: "Going to a person takes zu: zu dem Friseur, shortened to zum."),
            .gap(.medium, "Bist du schon ___ Hause? — Nein, ich bin noch ___ meiner Oma.", prompt: "Fill both gaps.",
                 options: ["zu … bei", "nach … bei", "zu … zu"], answer: 0,
                 why: "Being at home is zu Hause. Being at a person's place takes bei: bei meiner Oma."),
            .build("After work I'm going home.",
                   words: ["gehe", "zu Hause", "Nach der Arbeit", "nach Hause", "ich"],
                   answers: ["Nach der Arbeit gehe ich nach Hause"],
                   why: "Going home is nach Hause. „zu Hause“ is where you are once you're there.")
        ]
    )

    static let a2HereThere = GrammarRule(
        id: "a2-hin-her", level: .a2, title: "hier, dort, hin, her: where and which way",
        place: "Message from a friend", systemImage: "message",
        german: "Das Konzert ist im Park. Gehst du auch hin?",
        english: "The concert is in the park. Are you going too?",
        tiles: [Tile(text: "Das Konzert ist im Park."), Tile(text: "Gehst", role: .verb), Tile(text: "du auch"),
                Tile(text: "hin?", role: .end)],
        notice: "„hingehen“ means to go there. „hin“ points away from the speaker and, like any prefix, goes to the end.",
        rule: "Wo? hier, da, dort. Wohin? her points towards the speaker and hin away: Komm her! Ich gehe hin. "
            + "With a verb they work like prefixes, and so do weg and zurück.",
        visual: RuleVisual(
            source: Part(systemImage: "figure.wave", german: "Komm her!", marked: "her", role: "towards me"),
            target: Part(systemImage: "figure.walk.departure", german: "Geh hin!", marked: "hin", role: "away from me"),
            sentence: "Komm her! Geh hin!",
            columns: ["Wo?", "Wohin?"],
            rows: [
                Row(label: "here", cells: ["hier", "her · hierher"], marked: [1]),
                Row(label: "there", cells: ["da · dort", "hin · dorthin"], marked: [1]),
                Row(label: "away", cells: ["weg", "weggehen"], marked: [1]),
                Row(label: "back", cells: ["zurück", "zurückkommen"], marked: [1])
            ]
        ),
        exam: [
            .gap(.easy, "Wo bist du? — Ich bin ___, am Eingang.", options: ["hier", "hierher", "hin"], answer: 0,
                 why: "Wo? asks for a place, so it is hier. hierher is a direction."),
            .gap(.medium, "Lena ist im Kino. Gehst du auch ___? — Nein, ich bleibe ___.", prompt: "Fill both gaps.",
                 options: ["hin … hier", "her … hier", "hin … hierher"], answer: 0,
                 why: "Lena is away from you, so you go hin. Staying is a place: hier."),
            .build("Tomorrow I'm going away, and I'll come back on Sunday.",
                   words: ["und", "weg", "Morgen", "zurück", "am Sonntag", "fahre", "hin", "komme", "ich"],
                   answers: ["Morgen fahre ich weg und komme am Sonntag zurück"],
                   why: "„wegfahren“ and „zurückkommen“ split like separable verbs: weg and zurück go to the end of their part.")
        ]
    )
}
