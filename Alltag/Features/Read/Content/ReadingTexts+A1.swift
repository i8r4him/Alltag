//
//  ReadingTexts+A1.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension ReadingTexts {
    /// A1: short, everyday texts in the present tense, about 40 to 90 words, in
    /// the order a learner meets them: chats and menus first, letters from
    /// offices last. The texts on the phone and out and about are in
    /// `ReadingTexts+A1Phone.swift` and `ReadingTexts+A1Outside.swift`.
    static let a1: [ReadingText] = [
        a1Flatshare, a1Birthday, a1Lunch, a1Postcard, a1Late, a1Doctor, a1Parcel,
        a1Family, a1Station, a1Course, a1Sofa, a1Supermarket, a1Caretaker, a1Tandem,
        a1Lift, a1Pool, a1Work, a1Reminder, a1Holiday, a1Appointment, a1FleaMarket
    ]

    // MARK: - Letters and emails

    static let a1Parcel = ReadingText(
        id: "a1-parcel", level: .a1, kind: .letter,
        title: "A card from the parcel service", detail: "Your parcel is waiting",
        systemImage: "shippingbox.fill",
        german: """
        Benachrichtigung

        Liebe Kundin, lieber Kunde,

        wir waren heute um 10:15 Uhr bei Ihnen. Leider waren Sie nicht zu Hause.
        Ihr Paket ist jetzt in der Postfiliale in der Bahnhofstraße 4.
        Sie können es ab morgen um 9 Uhr abholen. Das Paket bleibt sieben Tage dort.
        Bitte bringen Sie diese Karte und Ihren Ausweis mit.

        Vielen Dank!
        Ihr Paketdienst
        """,
        questions: [
            ReadingQuestion(prompt: "Where is your parcel now?",
                            options: ["With a neighbour", "At the post office on Bahnhofstraße", "In front of your door"],
                            answer: 1, evidence: "Ihr Paket ist jetzt in der Postfiliale in der Bahnhofstraße 4."),
            ReadingQuestion(prompt: "When can you pick it up?",
                            options: ["Today at 10:15", "From tomorrow at 9", "Only in seven days"],
                            answer: 1, evidence: "Sie können es ab morgen um 9 Uhr abholen."),
            ReadingQuestion(prompt: "What do you need to bring?",
                            options: ["Money for the post", "Nothing", "This card and your ID"],
                            answer: 2, evidence: "Bitte bringen Sie diese Karte und Ihren Ausweis mit.")
        ])

    static let a1Postcard = ReadingText(
        id: "a1-postcard", level: .a1, kind: .letter,
        title: "A postcard from Julia", detail: "Greetings from Hamburg",
        systemImage: "envelope.fill",
        german: """
        Viele Grüße aus Hamburg!

        Hallo Ali,

        ich bin seit Freitag in Hamburg. Ich bin hier mit meiner Schwester.
        Das Wetter ist leider nicht so gut. Es regnet viel und es ist kalt.
        Aber die Stadt ist sehr schön! Heute machen wir eine Hafenrundfahrt. Morgen gehen wir ins Museum.
        Das Essen ist super, besonders der Fisch!
        Am Sonntag fahren wir wieder nach Hause. Am Montag bin ich wieder im Büro.

        Bis bald!
        Deine Julia
        """,
        questions: [
            ReadingQuestion(prompt: "Who is Julia in Hamburg with?",
                            options: ["Her colleagues", "Her sister", "Ali"],
                            answer: 1, evidence: "Ich bin hier mit meiner Schwester."),
            ReadingQuestion(prompt: "How is the weather?",
                            options: ["Rainy and cold", "Sunny and warm", "Windy but warm"],
                            answer: 0, evidence: "Es regnet viel und es ist kalt."),
            ReadingQuestion(prompt: "What does Julia like a lot?",
                            options: ["The hotel", "The weather", "The fish"],
                            answer: 2, evidence: "Das Essen ist super, besonders der Fisch!")
        ])

    static let a1Course = ReadingText(
        id: "a1-course", level: .a1, kind: .email,
        title: "An email from the language school", detail: "Your course starts",
        systemImage: "graduationcap.fill",
        german: """
        Betreff: Ihr Deutschkurs A1

        Liebe Kursteilnehmerin, lieber Kursteilnehmer,

        vielen Dank für Ihre Anmeldung! Ihr Kurs beginnt am Montag, den 11. Januar.
        Der Kurs ist von Montag bis Freitag, von 9 bis 12 Uhr.
        Wir sind im Raum 204. Er ist im zweiten Stock.
        Ihre Lehrerin heißt Anna Schulz.
        Bitte kaufen Sie das Kursbuch an der Rezeption. Es kostet 25 Euro.
        Haben Sie Fragen? Dann rufen Sie uns an: 0221 334 556.

        Viele Grüße
        Ihre Sprachschule Lingua
        """,
        questions: [
            ReadingQuestion(prompt: "When does the course start?",
                            options: ["On Friday, 11 January", "On Monday, 11 January", "On Monday, 12 January"],
                            answer: 1, evidence: "Ihr Kurs beginnt am Montag, den 11. Januar."),
            ReadingQuestion(prompt: "Where is room 204?",
                            options: ["On the ground floor", "Next to reception", "On the second floor"],
                            answer: 2, evidence: "Er ist im zweiten Stock."),
            ReadingQuestion(prompt: "Where do you get the course book?",
                            options: ["At reception, for 25 euros", "From the teacher, for free", "In a bookshop"],
                            answer: 0, evidence: "Bitte kaufen Sie das Kursbuch an der Rezeption.")
        ])

    static let a1Caretaker = ReadingText(
        id: "a1-caretaker", level: .a1, kind: .letter,
        title: "A letter from the property management", detail: "A new caretaker",
        systemImage: "wrench.and.screwdriver.fill",
        german: """
        Hausverwaltung Becker

        Liebe Mieterinnen und Mieter,

        ab März haben wir einen neuen Hausmeister. Er heißt Herr Krüger.
        Herr Krüger ist von Montag bis Freitag von 7 bis 15 Uhr im Haus.
        Sein Büro ist im Keller, neben dem Fahrradraum.
        Ist in Ihrer Wohnung etwas kaputt? Dann rufen Sie bitte Herrn Krüger an: 0176 22 34 455.
        Am Wochenende ist Herr Krüger nicht da. Im Notfall rufen Sie bitte 030 987 65 43 an.

        Mit freundlichen Grüßen
        Ihre Hausverwaltung Becker
        """,
        questions: [
            ReadingQuestion(prompt: "Who is Herr Krüger?",
                            options: ["The new caretaker", "A new neighbour", "The landlord"],
                            answer: 0, evidence: "ab März haben wir einen neuen Hausmeister."),
            ReadingQuestion(prompt: "Where is his office?",
                            options: ["On the ground floor", "In his flat", "In the cellar, next to the bike room"],
                            answer: 2, evidence: "Sein Büro ist im Keller, neben dem Fahrradraum."),
            ReadingQuestion(prompt: "There's an emergency on Sunday. What do you do?",
                            options: ["Call 030 987 65 43", "Call Herr Krüger", "Wait until Monday"],
                            answer: 0, evidence: "Im Notfall rufen Sie bitte 030 987 65 43 an.")
        ])

    static let a1Work = ReadingText(
        id: "a1-work", level: .a1, kind: .email,
        title: "An email from your new job", detail: "Your first day",
        systemImage: "briefcase.fill",
        german: """
        Betreff: Dein erster Arbeitstag

        Hallo Samir,

        herzlich willkommen im Team!
        Dein erster Arbeitstag ist am Montag. Bitte komm um 8:30 Uhr.
        Bitte geh zuerst zum Empfang im Erdgeschoss. Dort bekommst du deinen Mitarbeiterausweis.
        Um 9 Uhr zeige ich dir das Büro und deinen Computer.
        Mittags essen wir zusammen in der Kantine. Das Essen ist am ersten Tag gratis.

        Bis Montag!
        Petra Lange
        Teamleiterin Kundenservice
        """,
        questions: [
            ReadingQuestion(prompt: "What time should Samir arrive on Monday?",
                            options: ["At 9:00", "At 8:30", "At noon"],
                            answer: 1, evidence: "Bitte komm um 8:30 Uhr."),
            ReadingQuestion(prompt: "Where does he go first?",
                            options: ["To the canteen", "To Petra's office", "To reception on the ground floor"],
                            answer: 2, evidence: "Bitte geh zuerst zum Empfang im Erdgeschoss."),
            ReadingQuestion(prompt: "What about lunch on the first day?",
                            options: ["It's free in the canteen", "He brings his own", "There's no lunch break"],
                            answer: 0, evidence: "Das Essen ist am ersten Tag gratis.")
        ])

    static let a1Appointment = ReadingText(
        id: "a1-appointment", level: .a1, kind: .email,
        title: "An email from the citizens' office", detail: "Registering your flat",
        systemImage: "building.columns.fill",
        german: """
        Betreff: Ihr Termin im Bürgeramt

        Guten Tag,

        Ihr Termin ist am Dienstag, den 19. Januar, um 9:40 Uhr.
        Grund: Anmeldung einer Wohnung
        Ort: Bürgeramt Mitte, Rathausstraße 15, Zimmer 12
        Bitte bringen Sie Ihren Pass oder Ihren Personalausweis mit.
        Bringen Sie auch das Formular von Ihrem Vermieter mit (Wohnungsgeberbestätigung).
        Bitte kommen Sie pünktlich.
        Sie haben an dem Tag keine Zeit? Dann sagen Sie den Termin bitte online ab.

        Mit freundlichen Grüßen
        Ihr Bürgeramt Mitte
        """,
        questions: [
            ReadingQuestion(prompt: "What is the appointment for?",
                            options: ["A new passport", "Registering your flat", "A job interview"],
                            answer: 1, evidence: "Grund: Anmeldung einer Wohnung"),
            ReadingQuestion(prompt: "What must you bring from your landlord?",
                            options: ["Your rental contract", "A key", "A form"],
                            answer: 2, evidence: "Bringen Sie auch das Formular von Ihrem Vermieter mit (Wohnungsgeberbestätigung)."),
            ReadingQuestion(prompt: "You can't come that day. What do you do?",
                            options: ["Cancel it online", "Just don't go", "Send a letter"],
                            answer: 0, evidence: "Dann sagen Sie den Termin bitte online ab.")
        ])
}
