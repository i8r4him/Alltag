//
//  CheatSheetsAdvanced.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension CheatSheet {
    // MARK: B1

    static let verbAtTheEnd = CheatSheet(
        id: "verb-at-the-end", level: .b1, label: "weil · dass", title: "Verb at the end",
        summary: "After weil, dass, wenn, ob and similar words, the conjugated verb goes to the end of the clause.",
        systemImage: "arrow.right.to.line",
        parts: [
            Part(title: "The verb goes to the end", picture: picture(
                side("bed.double.fill", "Ich bleibe zu Hause,", "main clause"),
                side("thermometer.medium", "ich krank bin.", "the verb at the end", marked: "bin"),
                verb: "weil", sentence: "Ich bleibe zu Hause, weil ich krank bin."
            ), rows: [
                row("thermometer.medium", "Ich bleibe zu Hause, weil ich krank bin.", "weil: because", marked: "bin"),
                row("checkmark.circle.fill", "Ich hoffe, dass du kommst.", "dass: that", marked: "kommst"),
                row("cloud.rain.fill", "Wenn es regnet, bleiben wir drinnen.", "wenn: if, when", marked: "regnet"),
                row("questionmark.circle.fill", "Weißt du, ob der Laden heute offen hat?", "ob: whether", marked: "hat"),
                row("moon.fill", "Ich gehe noch raus, obwohl es spät ist.", "obwohl: although", marked: "ist")
            ]),
            Part(title: "The verb stays second", picture: picture(
                side("bed.double.fill", "denn ich bin müde", "denn: verb second", marked: "bin"),
                side("house.fill", "deshalb bleibe ich", "deshalb: the verb next", marked: "bleibe"),
                sentence: "denn ich bin müde, deshalb bleibe ich", linked: false
            ), rows: [
                row("bed.double.fill", "Ich gehe ins Bett, denn ich bin müde.", "denn also means because", marked: "bin"),
                row("cloud.rain.fill", "Es regnet, deshalb bleibe ich zu Hause.", "After deshalb the verb comes next", marked: "bleibe"),
                row("eurosign.circle.fill", "Ich spare, trotzdem reicht das Geld nicht.", "trotzdem: still, all the same", marked: "reicht")
            ])
        ]
    )

    static let relativeClauses = CheatSheet(
        id: "relative-clauses", level: .b1, label: "der · den · dem", title: "Relative clauses",
        summary: "The pronoun takes the gender of the noun and the case of its role in the clause. The verb goes to the end.",
        systemImage: "link",
        parts: [
            Part(title: "Who or which", picture: picture(
                side("figure.stand", "der Nachbar,", "the noun"),
                side("house.fill", "unten wohnt", "the verb at the end", marked: "wohnt"),
                verb: "der", sentence: "der Nachbar, der unten wohnt"
            ), rows: [
                row("house.fill", "Das ist der Nachbar, der unten wohnt.", "Subject: like the article", marked: "der unten"),
                row("person.2.fill", "Das ist der Kollege, den ich gestern getroffen habe.", "Accusative", marked: "den"),
                row("hand.raised.fill", "Wo ist der Kollege, dem ich helfen soll?", "Dative", marked: "dem"),
                row("person.3.fill", "Das sind die Leute, denen das Auto gehört.", "Dative plural: denen", marked: "denen"),
                row("briefcase.fill", "Das ist die Firma, bei der ich arbeite.", "The preposition comes first", marked: "bei der")
            ])
        ]
    )

    static let politeWishes = CheatSheet(
        id: "polite-wishes", level: .b1, label: "würde · hätte", title: "Polite wishes",
        summary: "würde, hätte, wäre and könnte make a request softer, or talk about what isn't real.",
        systemImage: "hand.wave",
        parts: [
            Part(title: "Asking politely", picture: picture(
                side("exclamationmark.bubble.fill", "Ich will einen Kaffee.", "too direct", marked: "will"),
                side("cup.and.saucer.fill", "Ich hätte gern einen Kaffee.", "polite", marked: "hätte"),
                sentence: "Ich will einen Kaffee. Ich hätte gern einen Kaffee."
            ), rows: [
                row("cup.and.saucer.fill", "Ich hätte gern einen Cappuccino.", "I'd like a cappuccino.", marked: "hätte"),
                row("doc.text.fill", "Könnten Sie mir das Formular erklären?", "Could you explain the form to me?", marked: "Könnten"),
                row("wind", "Würden Sie bitte das Fenster zumachen?", "Would you close the window, please?", marked: "Würden"),
                row("calendar", "Wäre Montag für Sie möglich?", "Would Monday work for you?", marked: "Wäre")
            ]),
            Part(title: "If only", picture: picture(
                side("clock.fill", "Wenn ich Zeit hätte,", "not real", marked: "hätte"),
                side("airplane", "würde ich reisen.", "what you'd do", marked: "würde"),
                sentence: "Wenn ich Zeit hätte, würde ich reisen."
            ), rows: [
                row("party.popper.fill", "Ich würde gern zur Party kommen.", "würde + infinitive at the end", marked: "würde"),
                row("book.fill", "Wenn ich mehr Zeit hätte, würde ich mehr lesen.", "If I had more time, I'd read more.", marked: "hätte"),
                row("sun.max.fill", "Das wäre schön!", "That would be nice!", marked: "wäre")
            ])
        ]
    )

    // MARK: B2

    static let passive = CheatSheet(
        id: "passive", level: .b2, label: "werden + Partizip", title: "The passive",
        summary: "werden in position 2, the participle at the end. Add von + dative only if the doer matters.",
        systemImage: "gearshape.2",
        parts: [
            Part(title: "Tenses", picture: picture(
                side("flame.fill", "Die Heizung", "what it's about"),
                side("wrench.and.screwdriver.fill", "repariert.", "the participle at the end", marked: "repariert"),
                verb: "wird", sentence: "Die Heizung wird repariert."
            ), rows: [
                row("flame.fill", "Die Heizung wird heute repariert.", "Present", marked: "wird"),
                row("envelope.fill", "Der Brief wurde gestern verschickt.", "Past", marked: "wurde"),
                row("creditcard.fill", "Die Miete ist schon überwiesen worden.", "Perfect: worden, not geworden", marked: "worden"),
                row("hammer.fill", "Die Wohnung muss noch renoviert werden.", "With a modal verb", marked: "werden")
            ]),
            Part(title: "The doer", picture: picture(
                side("flame.fill", "Die Heizung wurde", "what it's about"),
                side("person.fill", "vom Hausmeister", "who did it", marked: "vom", name: "von + Dativ"),
                sentence: "Die Heizung wurde vom Hausmeister repariert."
            ), rows: [
                row("wrench.and.screwdriver.fill", "Die Heizung wurde vom Hausmeister repariert.", "von + dative: who did it",
                    marked: "vom Hausmeister"),
                row("building.columns.fill", "Der Antrag wird vom Amt geprüft.", "Only say who if it matters", marked: "vom Amt")
            ])
        ]
    )

    static let verbsWithPrepositions = CheatSheet(
        id: "verbs-with-prepositions", level: .b2, label: "warten auf", title: "Verbs with prepositions",
        summary: "Many verbs come with a fixed preposition. Learn them as one piece, with the case.",
        systemImage: "puzzlepiece",
        parts: [
            Part(title: "Common pairs", picture: picture(
                side("person.fill", "Ich warte", "the verb"),
                side("bus.fill", "den Bus", "auf + Akk", marked: "den", name: "Akkusativ"),
                verb: "auf", sentence: "Ich warte auf den Bus."
            ), rows: [
                row("bus.fill", "Ich warte schon lange auf den Bus.", "warten auf + Akk: to wait for", marked: "auf den"),
                row("sun.max.fill", "Ich freue mich auf den Urlaub.", "sich freuen auf + Akk: to look forward to", marked: "auf den"),
                row("gift.fill", "Sie freut sich über das Geschenk.", "sich freuen über + Akk: to be pleased about", marked: "über das"),
                row("heart.fill", "Ich denke oft an meine Familie.", "denken an + Akk: to think of", marked: "an meine"),
                row("person.3.fill", "Ich nehme am Kurs teil.", "teilnehmen an + Dat: to take part in", marked: "am"),
                row("pawprint.fill", "Wer kümmert sich um den Hund?", "sich kümmern um + Akk: to take care of", marked: "um den")
            ]),
            Part(title: "Asking and pointing back", picture: picture(
                side("shippingbox.fill", "Worauf? Darauf.", "things", marked: "Darauf"),
                side("person.fill", "Auf wen? Auf ihn.", "people", marked: "ihn"),
                sentence: "Worauf? Darauf. Auf wen? Auf ihn.", linked: false
            ), rows: [
                row("shippingbox.fill", "Worauf wartest du? Auf das Paket.", "Things: wo- and the preposition", marked: "Worauf"),
                row("clock.fill", "Ich warte schon seit Tagen darauf.", "Pointing back to a thing: da-", marked: "darauf"),
                row("person.fill", "Auf wen wartest du? Auf meinen Bruder.", "People: the preposition, then who", marked: "Auf wen")
            ])
        ]
    )

    static let connectors = CheatSheet(
        id: "connectors", level: .b2, label: "weder … noch", title: "Two-part connectors",
        summary: "Pairs that link two ideas in one sentence.",
        systemImage: "point.3.connected.trianglepath.dotted",
        parts: [
            Part(title: "Pairs", picture: picture(
                side("car.fill", "weder ein Auto", "neither", marked: "weder"),
                side("bicycle", "noch ein Fahrrad", "nor", marked: "noch"),
                sentence: "Ich habe weder ein Auto noch ein Fahrrad.", linked: false
            ), rows: [
                row("bicycle", "Ich habe weder ein Auto noch ein Fahrrad.", "weder … noch: neither … nor", marked: "weder"),
                row("bubble.left.and.bubble.right.fill", "Sie spricht sowohl Arabisch als auch Deutsch.", "sowohl … als auch: both … and",
                    marked: "sowohl"),
                row("tram.fill", "Wir nehmen entweder die S-Bahn oder ein Taxi.", "entweder … oder: either … or", marked: "entweder"),
                row("moon.fill", "Er arbeitet nicht nur tagsüber, sondern auch nachts.", "nicht nur … sondern auch: not only … but also",
                    marked: "nicht nur"),
                row("house.fill", "Die Wohnung ist zwar klein, aber sehr hell.", "zwar … aber: admittedly … but", marked: "zwar")
            ]),
            Part(title: "je … desto", picture: picture(
                side("clock.fill", "Je früher", "the more …", marked: "Je"),
                side("hand.thumbsup.fill", "desto besser", "… the more", marked: "desto"),
                sentence: "Je früher, desto besser."
            ), rows: [
                row("clock.fill", "Je früher wir losfahren, desto besser.", "The earlier we leave, the better.", marked: "Je"),
                row("bubble.left.fill", "Je mehr du sprichst, desto leichter wird es.", "The more you speak, the easier it gets.",
                    marked: "desto")
            ])
        ]
    )

    // MARK: C1

    static let formalStyle = CheatSheet(
        id: "formal-style", level: .c1, label: "die Erhöhung", title: "Formal style",
        summary: "Formal German turns verbs into nouns and links them with the genitive. Typical for news, offices and contracts.",
        systemImage: "doc.text",
        parts: [
            Part(title: "Verb to noun", picture: picture(
                side("chart.line.uptrend.xyaxis", "erhöhen", "the verb"),
                side("doc.text.fill", "die Erhöhung", "the noun, feminine", marked: "ung"),
                sentence: "erhöhen, die Erhöhung"
            ), rows: [
                row("eurosign.circle.fill", "Die Erhöhung der Miete gilt ab Januar.", "erhöhen → die Erhöhung: -ung is feminine",
                    marked: "Erhöhung"),
                row("checkmark.circle.fill", "Die Entscheidung fällt nächste Woche.", "entscheiden → die Entscheidung",
                    marked: "Entscheidung"),
                row("train.side.front.car", "Die Abfahrt verzögert sich um zehn Minuten.", "abfahren → die Abfahrt: some change their form",
                    marked: "Abfahrt")
            ]),
            Part(title: "Clause to phrase", picture: picture(
                side("bubble.left.fill", "weil gestreikt wird", "spoken", marked: "weil"),
                side("newspaper.fill", "wegen des Streiks", "written", marked: "wegen", name: "Genitiv"),
                sentence: "weil gestreikt wird, wegen des Streiks"
            ), rows: [
                row("house.fill", "nachdem die Mieten erhöht wurden → nach der Erhöhung der Mieten", "nachdem becomes nach + dative",
                    marked: "nach der Erhöhung"),
                row("megaphone.fill", "weil gestreikt wird → wegen des Streiks", "weil becomes wegen + genitive",
                    marked: "wegen des Streiks"),
                row("cloud.rain.fill", "wenn es regnet → bei Regen", "wenn becomes bei + dative", marked: "bei Regen"),
                row("umbrella.fill", "obwohl es regnet → trotz des Regens", "obwohl becomes trotz + genitive", marked: "trotz des Regens")
            ])
        ]
    )

    static let particles = CheatSheet(
        id: "particles", level: .c1, label: "doch · ja · mal", title: "Modal particles",
        summary: "Small words that add a tone: friendlier, surprised or more natural. They don't change the facts.",
        systemImage: "bubble.left.and.text.bubble.right",
        parts: [
            Part(title: "Tone", picture: picture(
                side("bubble.left.fill", "Komm mit!", "plain"),
                side("face.smiling", "Komm doch mit!", "friendlier", marked: "doch"),
                sentence: "Komm mit! Komm doch mit!"
            ), rows: [
                row("party.popper.fill", "Komm doch mit, das wird lustig!", "doch: a friendly push", marked: "doch"),
                row("star.fill", "Du sprichst ja schon super Deutsch!", "ja: surprise, or “as you know”", marked: "ja"),
                row("hand.raised.fill", "Kannst du mal kurz helfen?", "mal: makes a request softer", marked: "mal"),
                row("questionmark.circle.fill", "Was ist denn los?", "denn: real interest in a question", marked: "denn"),
                row("ellipsis.bubble.fill", "Das ist halt so.", "halt: that's just how it is", marked: "halt"),
                row("thermometer.medium", "Er ist wohl krank.", "wohl: probably", marked: "wohl")
            ])
        ]
    )

    static let passiveAlternatives = CheatSheet(
        id: "passive-alternatives", level: .c1, label: "lässt sich", title: "Alternatives to the passive",
        summary: "Other ways to say what can or must be done, without werden.",
        systemImage: "arrow.triangle.branch",
        parts: [
            Part(title: "Can be done", picture: picture(
                side("wrench.and.screwdriver.fill", "lässt sich reparieren", "can be done", marked: "lässt sich"),
                side("checkmark.circle.fill", "reparierbar", "can be done", marked: "bar"),
                sentence: "lässt sich reparieren, reparierbar", linked: false
            ), rows: [
                row("calendar", "Der Termin lässt sich leider nicht verschieben.", "sich lassen + infinitive", marked: "lässt sich"),
                row("iphone", "Das Handy ist noch reparierbar.", "-bar: can be done", marked: "bar"),
                row("key.fill", "Der Schlüssel ist nirgends zu finden.", "sein + zu: can (not) be done", marked: "zu finden")
            ]),
            Part(title: "Must be done", picture: picture(
                side("doc.text.fill", "Der Antrag ist", "official"),
                side("calendar", "bis Montag einzureichen", "must be done", marked: "einzureichen"),
                sentence: "Der Antrag ist bis Montag einzureichen."
            ), rows: [
                row("doc.text.fill", "Der Antrag ist bis Montag einzureichen.", "sein + zu: must be done", marked: "einzureichen"),
                row("eurosign.circle.fill", "Die Rechnung ist innerhalb von 14 Tagen zu bezahlen.", "Typical for letters and rules",
                    marked: "zu bezahlen"),
                row("person.text.rectangle.fill", "Der Ausweis ist mitzubringen.", "A separable verb: zu in the middle",
                    marked: "mitzubringen")
            ])
        ]
    )
}
