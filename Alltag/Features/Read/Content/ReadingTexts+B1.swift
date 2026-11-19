//
//  ReadingTexts+B1.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension ReadingTexts {
    /// B1: longer everyday texts with reasons, conditions and the passive, about 120 to 160 words.
    /// Every kind of text at least once; the rest are in `ReadingTexts+B1More.swift`.
    static let b1: [ReadingText] = [
        b1Charges, b1Delay, b1Lunch, b1Shift, b1Birthday, b1Courtyard,
        b1HealthCard, b1Lanterns, b1ReplacementBus, b1Room, b1RepairCafe, b1BikeStreet
    ]

    static let b1Charges = ReadingText(
        id: "b1-charges", level: .b1, kind: .letter,
        title: "A letter from the property management", detail: "Your service charges",
        systemImage: "envelope.open.fill",
        german: """
        Sehr geehrte Frau Becker,

        anbei erhalten Sie die Nebenkostenabrechnung für das letzte Jahr.
        Sie haben monatlich 70 Euro, also insgesamt 840 Euro, im Voraus bezahlt. Die tatsächlichen Kosten lagen jedoch bei 915 Euro.
        Der Grund dafür sind vor allem die gestiegenen Heizkosten.
        Bitte überweisen Sie die Differenz von 75 Euro bis zum 15. Dezember auf unser Konto.
        Damit Sie im nächsten Jahr nichts nachzahlen müssen, erhöhen wir Ihre monatliche Vorauszahlung ab Januar um 10 Euro.
        Bei Fragen zur Abrechnung erreichen Sie uns montags bis freitags von 9 bis 13 Uhr.

        Mit freundlichen Grüßen
        Hausverwaltung Schulz
        """,
        questions: [
            ReadingQuestion(prompt: "Why does Frau Becker have to pay more?",
                            options: ["She used too much water", "Heating cost more than planned", "The rent went up"],
                            answer: 1, evidence: "Der Grund dafür sind vor allem die gestiegenen Heizkosten."),
            ReadingQuestion(prompt: "How much must she pay by 15 December?",
                            options: ["75 euros", "840 euros", "915 euros"],
                            answer: 0, evidence: "Bitte überweisen Sie die Differenz von 75 Euro bis zum 15. Dezember auf unser Konto."),
            ReadingQuestion(prompt: "What changes from January?",
                            options: ["The heating is replaced", "She gets 10 euros back", "She pays 10 euros more a month in advance"],
                            answer: 2,
                            evidence: "Damit Sie im nächsten Jahr nichts nachzahlen müssen, "
                                + "erhöhen wir Ihre monatliche Vorauszahlung ab Januar um 10 Euro.")
        ])

    static let b1Shift = ReadingText(
        id: "b1-shift", level: .b1, kind: .email,
        title: "An email from work", detail: "A change of shift",
        systemImage: "briefcase.fill",
        german: """
        Hallo zusammen,

        wegen einer Krankmeldung müssen wir den Schichtplan für nächste Woche ändern.
        Ayşe übernimmt am Mittwoch die Frühschicht, dafür arbeitet Jonas am Freitag in der Spätschicht.
        Außerdem suchen wir noch jemanden, der am Samstag von 10 bis 16 Uhr einspringen kann. \
        Wer Zeit hat, meldet sich bitte bis morgen Mittag bei mir.
        Die Stunden werden natürlich als Überstunden bezahlt, oder ihr nehmt sie im Dezember als freie Tage.
        Den neuen Plan hänge ich heute Abend im Pausenraum aus.

        Danke für eure Flexibilität!
        Viele Grüße
        Martina
        """,
        questions: [
            ReadingQuestion(prompt: "Why does the rota change?",
                            options: ["Someone is off sick", "The shop is moving", "It's the holidays"],
                            answer: 0, evidence: "wegen einer Krankmeldung müssen wir den Schichtplan für nächste Woche ändern."),
            ReadingQuestion(prompt: "What is Martina looking for?",
                            options: ["A new colleague", "Someone to work on Saturday", "A bigger break room"],
                            answer: 1,
                            evidence: "Außerdem suchen wir noch jemanden, der am Samstag von 10 bis 16 Uhr einspringen kann."),
            ReadingQuestion(prompt: "What do you get for the extra hours?",
                            options: ["Nothing", "A bonus at Christmas", "Overtime pay or days off in December"],
                            answer: 2,
                            evidence: "Die Stunden werden natürlich als Überstunden bezahlt, "
                                + "oder ihr nehmt sie im Dezember als freie Tage.")
        ])

    static let b1Courtyard = ReadingText(
        id: "b1-courtyard", level: .b1, kind: .notice,
        title: "A notice by the letterboxes", detail: "A party in the courtyard",
        systemImage: "party.popper.fill",
        german: """
        Einladung zum Hoffest

        Liebe Nachbarinnen und Nachbarn,
        am Samstag, den 6. September, feiern wir ab 15 Uhr unser Hoffest im Innenhof.
        Für Getränke und Musik sorgt die Hausgemeinschaft. \
        Wir freuen uns aber, wenn jeder einen Salat, einen Kuchen oder etwas zum Grillen mitbringt.
        Falls es regnet, feiern wir im Gemeinschaftsraum im Erdgeschoss.
        Damit wir besser planen können, tragen Sie sich bitte bis Mittwoch in die Liste neben den Briefkästen ein.
        Ab 22 Uhr bitten wir um Ruhe, damit die Familien mit kleinen Kindern schlafen können.

        Bis bald im Hof!
        Familie Yilmaz und Herr Brandt
        """,
        questions: [
            ReadingQuestion(prompt: "What should guests bring?",
                            options: ["Something to drink", "Something to eat", "Music"],
                            answer: 1,
                            evidence: "Wir freuen uns aber, wenn jeder einen Salat, einen Kuchen oder etwas zum Grillen mitbringt."),
            ReadingQuestion(prompt: "What happens if it rains?",
                            options: ["The party moves to Sunday", "The party is cancelled", "They celebrate in the common room"],
                            answer: 2, evidence: "Falls es regnet, feiern wir im Gemeinschaftsraum im Erdgeschoss."),
            ReadingQuestion(prompt: "How do you say you're coming?",
                            options: ["Put your name on the list by the letterboxes", "Ring Herr Brandt's bell", "Send an email"],
                            answer: 0,
                            evidence: "Damit wir besser planen können, tragen Sie sich bitte bis Mittwoch "
                                + "in die Liste neben den Briefkästen ein.")
        ])

    static let b1Lanterns = ReadingText(
        id: "b1-lanterns", level: .b1, kind: .chat,
        title: "The nursery parents' chat", detail: "The lantern walk",
        systemImage: "bubble.left.and.bubble.right.fill",
        german: """
        Frau Klein: Liebe Eltern, am Freitag ist unser Laternenumzug! Wir treffen uns um 17 Uhr vor der Kita.
        Frau Klein: Bitte geben Sie Ihrem Kind warme Kleidung mit. Die Laternen basteln wir diese Woche in der Kita.
        Sandra: Super, danke! Dürfen Geschwister auch mitkommen?
        Frau Klein: Natürlich, die ganze Familie ist herzlich willkommen.
        Murat: Brauchen Sie noch Hilfe? Ich könnte zwei Thermoskannen mit Kinderpunsch mitbringen.
        Frau Klein: Das wäre toll, danke!
        Sandra: Und was machen wir, wenn es stark regnet?
        Frau Klein: Dann verschieben wir den Umzug auf Montag. Ich schreibe am Freitagmittag hier in die Gruppe.
        """,
        questions: [
            ReadingQuestion(prompt: "Where and when do they meet?",
                            options: ["In the park at 6 pm", "In front of the nursery at 5 pm", "At the church at 5 pm"],
                            answer: 1, evidence: "Wir treffen uns um 17 Uhr vor der Kita."),
            ReadingQuestion(prompt: "What does Murat offer?",
                            options: ["To bring punch for the children", "To make the lanterns", "To take photos"],
                            answer: 0, evidence: "Ich könnte zwei Thermoskannen mit Kinderpunsch mitbringen."),
            ReadingQuestion(prompt: "What happens if it rains heavily?",
                            options: ["They walk anyway", "It's cancelled", "It moves to Monday"],
                            answer: 2, evidence: "Dann verschieben wir den Umzug auf Montag.")
        ])

    static let b1Room = ReadingText(
        id: "b1-room", level: .b1, kind: .advert,
        title: "A small ad", detail: "A room in a flatshare",
        systemImage: "bed.double.fill",
        german: """
        WG-Zimmer in Leipzig-Connewitz ab 1. Dezember

        Wir sind eine entspannte Dreier-WG und suchen eine neue Mitbewohnerin oder einen neuen Mitbewohner.
        Das Zimmer ist 16 Quadratmeter groß, hell und teilweise möbliert. Bett und Schreibtisch kannst du übernehmen.
        Die Warmmiete beträgt 420 Euro, inklusive Internet und Strom.
        Küche und Bad teilen wir uns. Einen Balkon gibt es auch.
        Wir kochen gern zusammen, aber jeder hat auch seine Ruhe.
        Rauchen ist in der Wohnung nicht erlaubt, auf dem Balkon schon.
        Schreib uns ein paar Sätze über dich, dann laden wir dich zum Kennenlernen ein.
        """,
        questions: [
            ReadingQuestion(prompt: "What is included in the 420 euros?",
                            options: ["Food", "Internet and electricity", "A new bed"],
                            answer: 1, evidence: "Die Warmmiete beträgt 420 Euro, inklusive Internet und Strom."),
            ReadingQuestion(prompt: "Where may you smoke?",
                            options: ["On the balcony", "In your room", "Nowhere"],
                            answer: 0, evidence: "Rauchen ist in der Wohnung nicht erlaubt, auf dem Balkon schon."),
            ReadingQuestion(prompt: "What should you do if you're interested?",
                            options: ["Call them", "Come by on Saturday", "Write a few sentences about yourself"],
                            answer: 2, evidence: "Schreib uns ein paar Sätze über dich, dann laden wir dich zum Kennenlernen ein.")
        ])

    static let b1BikeStreet = ReadingText(
        id: "b1-bike-street", level: .b1, kind: .article,
        title: "Local news", detail: "A street for bikes",
        systemImage: "bicycle",
        german: """
        Neue Fahrradstraße in der Innenstadt

        Ab Montag wird die Goethestraße zur Fahrradstraße. Das hat der Stadtrat am Dienstag beschlossen.
        In einer Fahrradstraße haben Radfahrer Vorrang. Sie dürfen nebeneinander fahren, und Autos dürfen höchstens 30 km/h fahren.
        Anwohner können weiterhin mit dem Auto in die Straße fahren und dort parken. Für alle anderen ist die Durchfahrt verboten.
        Die Stadt hofft, dass so mehr Menschen mit dem Fahrrad zur Arbeit fahren.
        Einige Geschäfte sind allerdings skeptisch. \
        Sie befürchten, dass weniger Kunden kommen, wenn diese nicht mehr direkt vor dem Laden parken können.
        """,
        questions: [
            ReadingQuestion(prompt: "Who may still drive into the street?",
                            options: ["Only delivery vans", "People who live there", "Nobody"],
                            answer: 1, evidence: "Anwohner können weiterhin mit dem Auto in die Straße fahren und dort parken."),
            ReadingQuestion(prompt: "How fast may cars go?",
                            options: ["30 km/h at most", "50 km/h", "10 km/h"],
                            answer: 0, evidence: "Sie dürfen nebeneinander fahren, und Autos dürfen höchstens 30 km/h fahren."),
            ReadingQuestion(prompt: "Why are some shops worried?",
                            options: ["More noise", "Higher rents", "Fewer customers"],
                            answer: 2,
                            evidence: "Sie befürchten, dass weniger Kunden kommen, "
                                + "wenn diese nicht mehr direkt vor dem Laden parken können.")
        ])
}
