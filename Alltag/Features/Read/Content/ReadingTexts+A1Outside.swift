//
//  ReadingTexts+A1Outside.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension ReadingTexts {
    // MARK: - A1 out and about: signs, notices, menus and announcements

    static let a1Lunch = ReadingText(
        id: "a1-lunch", level: .a1, kind: .menu,
        title: "Lunch at the café", detail: "What's on the menu?",
        systemImage: "fork.knife",
        german: """
        Café am Markt – Mittagstisch
        Montag bis Freitag, 12 bis 15 Uhr

        Tomatensuppe mit Brot – 4,50 Euro
        Nudeln mit Gemüse – 7,90 Euro
        Hähnchen mit Reis und Salat – 9,50 Euro
        Kuchen des Tages – 3,20 Euro
        Kaffee oder Tee – 2,50 Euro

        Am Wochenende ist das Café von 10 bis 18 Uhr offen. Es gibt dann Frühstück, aber keinen Mittagstisch.
        """,
        questions: [
            ReadingQuestion(prompt: "How much is the tomato soup?",
                            options: ["2.50 euros", "4.50 euros", "7.90 euros"],
                            answer: 1, evidence: "Tomatensuppe mit Brot – 4,50 Euro"),
            ReadingQuestion(prompt: "What comes with the chicken?",
                            options: ["Rice and salad", "Bread", "Pasta and vegetables"],
                            answer: 0, evidence: "Hähnchen mit Reis und Salat – 9,50 Euro"),
            ReadingQuestion(prompt: "Can you have lunch there on Saturday?",
                            options: ["Yes, from 12 to 3", "Yes, all day", "No, only breakfast"],
                            answer: 2, evidence: "Es gibt dann Frühstück, aber keinen Mittagstisch.")
        ])

    static let a1Doctor = ReadingText(
        id: "a1-doctor", level: .a1, kind: .notice,
        title: "A sign at the doctor's", detail: "When is it open?",
        systemImage: "cross.case.fill",
        german: """
        Praxis Dr. Weber – Allgemeinmedizin

        Sprechzeiten:
        Montag, Dienstag und Donnerstag: 8 bis 12 Uhr und 15 bis 18 Uhr
        Mittwoch und Freitag: 8 bis 12 Uhr

        Bitte rufen Sie vorher an und machen Sie einen Termin. Telefon: 030 456 789
        Im Notfall rufen Sie bitte die 112 an.
        Vom 23. Dezember bis zum 2. Januar ist die Praxis geschlossen.
        """,
        questions: [
            ReadingQuestion(prompt: "Is the practice open on Wednesday afternoon?",
                            options: ["Yes, until 6 pm", "No, it's closed all day", "No, only in the morning"],
                            answer: 2, evidence: "Mittwoch und Freitag: 8 bis 12 Uhr"),
            ReadingQuestion(prompt: "How do you get an appointment?",
                            options: ["Online", "You call first", "You just come in"],
                            answer: 1, evidence: "Bitte rufen Sie vorher an und machen Sie einen Termin."),
            ReadingQuestion(prompt: "When is the practice closed?",
                            options: ["Every Monday", "In the summer", "From 23 December to 2 January"],
                            answer: 2, evidence: "Vom 23. Dezember bis zum 2. Januar ist die Praxis geschlossen.")
        ])

    static let a1Station = ReadingText(
        id: "a1-station", level: .a1, kind: .announcement,
        title: "At the station", detail: "Your train is late",
        systemImage: "tram.fill",
        german: """
        Achtung an Gleis 3!

        Der ICE nach München, Abfahrt 14:20 Uhr, hat heute circa 15 Minuten Verspätung.
        Der Zug fährt heute nicht von Gleis 3, sondern von Gleis 5.
        Das Bordbistro ist heute leider geschlossen.
        Wir bitten um Entschuldigung.
        """,
        questions: [
            ReadingQuestion(prompt: "How late is the train?",
                            options: ["About 5 minutes", "One hour", "About 15 minutes"],
                            answer: 2, evidence: "hat heute circa 15 Minuten Verspätung."),
            ReadingQuestion(prompt: "Where does the train leave from today?",
                            options: ["Platform 3", "Platform 5", "Platform 14"],
                            answer: 1, evidence: "Der Zug fährt heute nicht von Gleis 3, sondern von Gleis 5."),
            ReadingQuestion(prompt: "What is closed today?",
                            options: ["The bistro on the train", "Platform 3", "The ticket office"],
                            answer: 0, evidence: "Das Bordbistro ist heute leider geschlossen.")
        ])

    static let a1Supermarket = ReadingText(
        id: "a1-supermarket", level: .a1, kind: .announcement,
        title: "In the supermarket", detail: "We close soon",
        systemImage: "speaker.wave.2.fill",
        german: """
        Liebe Kundinnen und Kunden,

        in 15 Minuten schließen wir. Bitte kommen Sie jetzt zur Kasse.
        Heute haben wir ein Angebot: Alle Äpfel kosten nur 1,99 Euro pro Kilo.
        Unsere Bäckerei hat noch frisches Brot. Jedes Brot kostet jetzt nur die Hälfte.
        Jetzt ist auch Kasse 3 offen.
        Vielen Dank für Ihren Einkauf und einen schönen Abend!
        """,
        questions: [
            ReadingQuestion(prompt: "When does the shop close?",
                            options: ["At 3 o'clock", "In an hour", "In 15 minutes"],
                            answer: 2, evidence: "in 15 Minuten schließen wir."),
            ReadingQuestion(prompt: "How much are the apples today?",
                            options: ["1.99 euros a kilo", "1.99 euros each", "Half price"],
                            answer: 0, evidence: "Alle Äpfel kosten nur 1,99 Euro pro Kilo."),
            ReadingQuestion(prompt: "What is half price now?",
                            options: ["The apples", "Bread from the bakery", "Everything in the shop"],
                            answer: 1, evidence: "Jedes Brot kostet jetzt nur die Hälfte.")
        ])

    static let a1Lift = ReadingText(
        id: "a1-lift", level: .a1, kind: .notice,
        title: "A notice in the hallway", detail: "The lift is broken",
        systemImage: "exclamationmark.triangle.fill",
        german: """
        Achtung: Aufzug kaputt!

        Liebe Nachbarinnen und Nachbarn,

        der Aufzug funktioniert seit gestern nicht.
        Der Techniker kommt am Freitag. Dann geht der Aufzug hoffentlich wieder.
        Bitte nehmen Sie bis dahin die Treppe.
        Brauchen Sie Hilfe mit schweren Einkäufen? Dann rufen Sie mich an: 0176 22 34 455.

        Ihr Hausmeister Krüger
        """,
        questions: [
            ReadingQuestion(prompt: "What's wrong?",
                            options: ["There's no light on the stairs", "The lift doesn't work", "The front door is broken"],
                            answer: 1, evidence: "der Aufzug funktioniert seit gestern nicht."),
            ReadingQuestion(prompt: "When does the technician come?",
                            options: ["Today", "Next week", "On Friday"],
                            answer: 2, evidence: "Der Techniker kommt am Freitag."),
            ReadingQuestion(prompt: "You have heavy shopping. What can you do?",
                            options: ["Call Herr Krüger", "Wait until Friday", "Ring the neighbours"],
                            answer: 0, evidence: "Dann rufen Sie mich an: 0176 22 34 455.")
        ])

    static let a1Holiday = ReadingText(
        id: "a1-holiday", level: .a1, kind: .notice,
        title: "A sign on the bakery door", detail: "Closed for the holidays",
        systemImage: "sun.max.fill",
        german: """
        Bäckerei Krause

        Liebe Kundinnen und Kunden,

        wir machen Urlaub!
        Vom 2. bis zum 16. August ist unser Laden geschlossen.
        Ab dem 17. August sind wir wieder für Sie da.
        Brot und Brötchen bekommen Sie in dieser Zeit bei der Bäckerei Sonnenschein in der Marktstraße.
        Wir wünschen Ihnen einen schönen Sommer!

        Ihr Team der Bäckerei Krause
        """,
        questions: [
            ReadingQuestion(prompt: "Why is the bakery closed?",
                            options: ["The team is on holiday", "It's being renovated", "It's a public holiday"],
                            answer: 0, evidence: "wir machen Urlaub!"),
            ReadingQuestion(prompt: "When does it open again?",
                            options: ["On 2 August", "On 16 August", "On 17 August"],
                            answer: 2, evidence: "Ab dem 17. August sind wir wieder für Sie da."),
            ReadingQuestion(prompt: "Where can you buy bread in the meantime?",
                            options: ["At the supermarket", "At Bäckerei Sonnenschein", "Nowhere"],
                            answer: 1, evidence: "bei der Bäckerei Sonnenschein in der Marktstraße.")
        ])

    static let a1FleaMarket = ReadingText(
        id: "a1-flea-market", level: .a1, kind: .notice,
        title: "A poster on the street", detail: "A flea market on Saturday",
        systemImage: "tag.fill",
        german: """
        Flohmarkt in der Gartenstraße!

        Am Samstag, 15. Mai, von 10 bis 16 Uhr
        Hier finden Sie Kleidung, Bücher, Spielzeug und vieles mehr.
        Es gibt auch Kaffee und Kuchen. Das Geld ist für den Kindergarten.
        Sie möchten selbst etwas verkaufen? Ein Tisch kostet 5 Euro.
        Bitte rufen Sie bis zum 10. Mai Frau Berger an: 0157 33 44 11 22.
        Bei Regen ist der Flohmarkt im Gemeindehaus.
        """,
        questions: [
            ReadingQuestion(prompt: "When is the flea market?",
                            options: ["On Sunday morning", "Every Saturday", "On Saturday, 10 am to 4 pm"],
                            answer: 2, evidence: "Am Samstag, 15. Mai, von 10 bis 16 Uhr"),
            ReadingQuestion(prompt: "What is the money from the coffee and cake for?",
                            options: ["For the church", "For the nursery", "For Frau Berger"],
                            answer: 1, evidence: "Das Geld ist für den Kindergarten."),
            ReadingQuestion(prompt: "What happens if it rains?",
                            options: ["It's in the community hall", "It moves to Sunday", "It's cancelled"],
                            answer: 0, evidence: "Bei Regen ist der Flohmarkt im Gemeindehaus.")
        ])
}
