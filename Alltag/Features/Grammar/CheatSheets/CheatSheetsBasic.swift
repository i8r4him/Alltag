//
//  CheatSheetsBasic.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension CheatSheet {
    /// Every sheet, A1 to C1. Three per level.
    static let all: [CheatSheet] = [
        wordOrder, presentTense, negation,
        past, cases, prepositions,
        verbAtTheEnd, relativeClauses, politeWishes,
        passive, verbsWithPrepositions, connectors,
        formalStyle, particles, passiveAlternatives
    ]

    // MARK: A1

    static let wordOrder = CheatSheet(
        id: "word-order", level: .a1, label: "Verb 2", title: "Word order",
        summary: "In a main clause the verb is always second. Whatever comes first, the subject moves behind it.",
        systemImage: "arrow.left.arrow.right",
        parts: [
            Part(title: "Statements", picture: picture(
                side("sunrise.fill", "Morgens", "comes first"),
                side("person.fill", "ich Kaffee", "the subject moves behind", marked: "ich"),
                verb: "trinke", sentence: "Morgens trinke ich Kaffee."
            ), rows: [
                row("person.fill", "Ich trinke morgens Kaffee.", "The subject first, the verb second", marked: "trinke"),
                row("sunrise.fill", "Morgens trinke ich Kaffee.", "Time first: the subject moves behind the verb", marked: "trinke ich"),
                row("building.2.fill", "Im Büro trinke ich Tee.", "Place first: the same", marked: "trinke ich"),
                row("bed.double.fill", "Am Wochenende schlafe ich lange.", "Anything can come first. The verb stays second",
                    marked: "schlafe ich")
            ]),
            Part(title: "Questions", picture: picture(
                side("questionmark.circle.fill", "Trinkst du Kaffee?", "yes or no", marked: "Trinkst"),
                side("text.bubble.fill", "Was trinkst du?", "a question word", marked: "trinkst"),
                sentence: "Trinkst du Kaffee? Was trinkst du?", linked: false
            ), rows: [
                row("cup.and.saucer.fill", "Trinkst du einen Kaffee mit?", "Yes or no: the verb first", marked: "Trinkst"),
                row("clock.fill", "Wann fängt der Kurs an?", "A question word, then the verb", marked: "fängt"),
                row("mappin.and.ellipse", "Wo wohnst du?", "wo, wann, was, wer, wie: then the verb", marked: "wohnst")
            ])
        ]
    )

    static let presentTense = CheatSheet(
        id: "present-tense", level: .a1, label: "ich · du · er", title: "Present tense",
        summary: "Take the infinitive, drop -en and add the ending for the person.",
        systemImage: "person.2",
        parts: [
            Part(title: "lernen", picture: picture(
                side("book.closed.fill", "lernen", "drop -en", marked: "en"),
                side("person.fill", "ich lerne", "add the ending", marked: "e"),
                sentence: "lernen, ich lerne"
            ), rows: [
                row("person.fill", "Ich lerne jeden Abend Deutsch.", "ich: -e", marked: "lerne"),
                row("person.2.fill", "Lernst du auch Deutsch?", "du: -st (friends, family)", marked: "Lernst"),
                row("figure.stand", "Mein Sohn lernt Englisch.", "er, sie, es: -t", marked: "lernt"),
                row("person.3.fill", "Wir lernen zusammen.", "wir: -en", marked: "lernen"),
                row("person.3.sequence.fill", "Was lernt ihr gerade?", "ihr: -t (a group)", marked: "lernt"),
                row("briefcase.fill", "Lernen Sie schon lange Deutsch?", "sie, Sie: -en (they, or polite you)", marked: "Lernen")
            ]),
            Part(title: "Learn these by heart", picture: picture(
                side("face.smiling", "Ich bin müde.", "sein, to be", marked: "bin"),
                side("calendar", "Ich habe Zeit.", "haben, to have", marked: "habe"),
                sentence: "Ich bin müde. Ich habe Zeit.", linked: false
            ), rows: [
                row("face.smiling", "ich bin · du bist · er ist", "sein, to be"),
                row("bag.fill", "ich habe · du hast · er hat", "haben, to have"),
                row("airplane", "Ich bin seit Mai in Deutschland.", "ich bin: I am", marked: "bin"),
                row("calendar", "Hast du morgen Zeit?", "du hast: no b", marked: "Hast")
            ])
        ]
    )

    static let negation = CheatSheet(
        id: "negation", level: .a1, label: "nicht · kein", title: "Saying no",
        summary: "kein stands for a noun with ein or no article. nicht is for everything else.",
        systemImage: "nosign",
        parts: [
            Part(title: "kein", picture: picture(
                side("car.fill", "ein Auto", "a noun with ein", marked: "ein"),
                side("xmark.circle.fill", "kein Auto", "becomes kein", marked: "kein"),
                sentence: "ein Auto, kein Auto"
            ), rows: [
                row("car.fill", "Ich habe kein Auto.", "ein Auto becomes kein Auto", marked: "kein"),
                row("cup.and.saucer.fill", "Danke, ich trinke keinen Kaffee.", "kein takes the endings of ein", marked: "keinen"),
                row("clock.fill", "Sorry, ich habe heute keine Zeit.", "No article becomes keine", marked: "keine")
            ]),
            Part(title: "nicht", picture: picture(
                side("calendar", "Ich komme nicht.", "at the end", marked: "nicht"),
                side("hand.thumbsdown.fill", "nicht gut", "before an adjective", marked: "nicht"),
                sentence: "Ich komme nicht. Nicht gut.", linked: false
            ), rows: [
                row("calendar", "Ich komme heute nicht.", "nicht near the end of the sentence", marked: "nicht"),
                row("key.fill", "Das ist nicht mein Schlüssel.", "before what you say no to", marked: "nicht"),
                row("fork.knife", "Das Essen ist nicht so gut.", "before an adjective", marked: "nicht"),
                row("house.fill", "Ich wohne nicht in Berlin.", "before a place", marked: "nicht")
            ])
        ]
    )

    // MARK: A2

    static let past = CheatSheet(
        id: "past", level: .a2, label: "haben · sein", title: "Talking about the past",
        summary: "haben or sein in position 2, the participle at the very end.",
        systemImage: "clock.arrow.circlepath",
        parts: [
            Part(title: "haben or sein", picture: picture(
                side("fork.knife", "Ich habe gekocht.", "most verbs", marked: "habe", name: "haben"),
                side("tram.fill", "Ich bin gefahren.", "from A to B", marked: "bin", name: "sein"),
                sentence: "Ich habe gekocht. Ich bin gefahren.", linked: false
            ), rows: [
                row("fork.knife", "Gestern habe ich Pizza gemacht.", "Most verbs take haben", marked: "habe"),
                row("tram.fill", "Ich bin mit der U-Bahn gefahren.", "Moving from A to B takes sein", marked: "bin"),
                row("bed.double.fill", "Das Baby ist endlich eingeschlafen.", "A change of state takes sein", marked: "ist"),
                row("house.fill", "Am Sonntag bin ich zu Hause geblieben.", "bleiben and sein take sein", marked: "bin")
            ]),
            Part(title: "The participle", picture: picture(
                side("cart.fill", "einkaufen", "the verb"),
                side("bag.fill", "eingekauft", "ge- in the middle", marked: "ge"),
                sentence: "einkaufen, eingekauft"
            ), rows: [
                row("figure.run", "Ich habe Sport gemacht.", "Regular: ge- … -t", marked: "gemacht"),
                row("car.fill", "Wir sind nach Hamburg gefahren.", "Irregular: ge- … -en", marked: "gefahren"),
                row("cart.fill", "Hast du schon eingekauft?", "Separable: ge- in the middle", marked: "eingekauft"),
                row("phone.fill", "Ich habe mit meiner Mutter telefoniert.", "-ieren and be-, ver-, er-: no ge-", marked: "telefoniert")
            ])
        ]
    )

    static let cases = CheatSheet(
        id: "cases", level: .a2, label: "Akk · Dat", title: "Cases",
        summary: "Who or what you act on is accusative. Who you give to or do something for is dative.",
        systemImage: "square.stack.3d.up",
        parts: [
            Part(title: "Accusative: wen? was?", picture: picture(
                side("person.fill", "Ich", "Wer?"),
                side("birthday.cake.fill", "den Kuchen", "Was?", marked: "den", name: "Akkusativ"),
                verb: "nehme", sentence: "Ich nehme den Kuchen."
            ), rows: [
                row("list.bullet", "den · die · das · die", "Only der changes: der becomes den"),
                row("list.bullet", "einen · eine · ein", "ein: the same pattern"),
                row("birthday.cake.fill", "Ich nehme den Kuchen.", "I'll have the cake.", marked: "den"),
                row("laptopcomputer", "Ich brauche einen neuen Laptop.", "I need a new laptop.", marked: "einen")
            ]),
            Part(title: "Dative: wem?", picture: picture(
                side("person.fill", "Ich helfe", "Wer?"),
                side("figure.stand", "dem Nachbarn", "Wem?", marked: "dem", name: "Dativ"),
                sentence: "Ich helfe dem Nachbarn."
            ), rows: [
                row("list.bullet", "dem · der · dem · den", "Masculine, feminine, neuter, plural"),
                row("list.bullet", "einem · einer · einem", "ein in the dative"),
                row("gift.fill", "Ich schenke meiner Mutter Blumen.", "Who gets something: dative", marked: "meiner"),
                row("figure.2.and.child.holdinghands", "Ich spiele mit den Kindern.", "The plural adds -n", marked: "den Kindern")
            ]),
            Part(title: "Pronouns", picture: picture(
                side("phone.fill", "Ruf mich an!", "Wen?", marked: "mich", name: "Akkusativ"),
                side("hand.raised.fill", "Hilf mir!", "Wem?", marked: "mir", name: "Dativ"),
                sentence: "Ruf mich an! Hilf mir!", linked: false
            ), rows: [
                row("list.bullet", "mich · dich · ihn · sie · uns", "Accusative: me, you, him, her, us"),
                row("list.bullet", "mir · dir · ihm · ihr · uns", "Dative: to me, to you, to him, to her, to us"),
                row("phone.fill", "Ruf mich später an!", "Call me later!", marked: "mich"),
                row("hand.thumbsup.fill", "Das gefällt mir.", "I like that: gefallen takes the dative", marked: "mir")
            ])
        ]
    )

    static let prepositions = CheatSheet(
        id: "prepositions", level: .a2, label: "mit · für · in", title: "Prepositions and cases",
        summary: "Each preposition decides the case of the noun after it.",
        systemImage: "mappin.and.ellipse",
        parts: [
            Part(title: "Always dative", picture: picture(
                side("figure.stand", "Ich fahre", "Wer?"),
                side("bus.fill", "dem Bus", "Womit?", marked: "dem", name: "Dativ"),
                verb: "mit", sentence: "Ich fahre mit dem Bus."
            ), rows: [
                row("bus.fill", "Ich fahre mit dem Bus zur Arbeit.", "mit: how you go, or who with", marked: "mit dem"),
                row("house.fill", "Heute Abend bin ich bei meiner Schwester.", "bei: at someone's place", marked: "bei meiner"),
                row("cross.case.fill", "Ich muss morgen zum Arzt.", "zu: to a person or place. zum is zu dem", marked: "zum"),
                row("briefcase.fill", "Ich komme gerade von der Arbeit.", "von: from a person or place", marked: "von der"),
                row("calendar", "Seit einem Jahr wohne ich in Köln.", "seit: since, and still true", marked: "Seit einem"),
                row("list.bullet", "aus · bei · mit · nach · seit · von · zu", "The seven to learn together")
            ]),
            Part(title: "Always accusative", picture: picture(
                side("gift.fill", "die Blumen", "Was?"),
                side("person.fill", "dich", "Für wen?", marked: "dich", name: "Akkusativ"),
                verb: "für", sentence: "Die Blumen sind für dich."
            ), rows: [
                row("gift.fill", "Die Blumen sind für dich.", "für: for someone", marked: "für dich"),
                row("suitcase.rolling.fill", "Ich fahre ohne meinen Mann in den Urlaub.", "ohne: without", marked: "ohne meinen"),
                row("tree.fill", "Wir laufen durch den Park.", "durch: through", marked: "durch den"),
                row("cart.fill", "Der Supermarkt ist gleich um die Ecke.", "um: around. With a time: um 8 Uhr", marked: "um die"),
                row("list.bullet", "durch · für · gegen · ohne · um", "The five to learn together")
            ]),
            Part(title: "Where? or Where to?", picture: picture(
                side("mappin.and.ellipse", "in der Küche", "Wo?", marked: "der", name: "Dativ"),
                side("figure.walk", "in die Küche", "Wohin?", marked: "die", name: "Akkusativ"),
                sentence: "Wo? In der Küche. Wohin? In die Küche.", linked: false
            ), rows: [
                row("mappin.and.ellipse", "Ich bin in der Küche.", "You stay in a place: dative", marked: "in der"),
                row("figure.walk", "Ich gehe in die Küche.", "You move to a place: accusative", marked: "in die"),
                row("iphone", "Das Handy liegt auf dem Tisch.", "liegen: it stays there", marked: "auf dem"),
                row("hand.point.down.fill", "Ich lege das Handy auf den Tisch.", "legen: you put it there", marked: "auf den"),
                row("list.bullet", "an · auf · hinter · in · neben · über · unter · vor · zwischen", "These nine work this way")
            ])
        ]
    )
}
