//
//  ReadingTexts+A1.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension ReadingTexts {
    /// A1: short, everyday texts in the present tense, about 50 to 80 words.
    static let a1: [ReadingText] = [a1Parcel, a1Flatshare, a1Lunch, a1Birthday, a1Doctor, a1Station]

    static let a1Parcel = ReadingText(
        id: "a1-parcel", level: .a1, kind: .notice,
        title: "A card from the parcel service", detail: "Your parcel is waiting",
        systemImage: "shippingbox.fill",
        german: """
        Liebe Kundin, lieber Kunde,

        wir waren heute um 10:15 Uhr bei Ihnen. Leider waren Sie nicht zu Hause.
        Ihr Paket ist jetzt in der Post-Filiale in der Bahnhofstraße 4.
        Sie können es ab morgen um 9 Uhr abholen. Das Paket bleibt sieben Tage dort.
        Bitte bringen Sie diese Karte und Ihren Ausweis mit.

        Vielen Dank!
        Ihr Paketdienst
        """,
        questions: [
            ReadingQuestion(prompt: "Where is your parcel now?",
                            options: ["At the post office on Bahnhofstraße", "With a neighbour", "In front of your door"],
                            answer: 0, evidence: "Ihr Paket ist jetzt in der Post-Filiale in der Bahnhofstraße 4."),
            ReadingQuestion(prompt: "When can you pick it up?",
                            options: ["Today at 10:15", "From tomorrow at 9", "Only in seven days"],
                            answer: 1, evidence: "Sie können es ab morgen um 9 Uhr abholen."),
            ReadingQuestion(prompt: "What do you need to bring?",
                            options: ["Money for the post", "Nothing", "This card and your ID"],
                            answer: 2, evidence: "Bitte bringen Sie diese Karte und Ihren Ausweis mit.")
        ])

    static let a1Flatshare = ReadingText(
        id: "a1-flatshare", level: .a1, kind: .chat,
        title: "The flatshare group chat", detail: "Who needs what?",
        systemImage: "bubble.left.and.bubble.right.fill",
        german: """
        Mia: Hallo ihr zwei! Ich gehe gleich einkaufen. Braucht ihr etwas?
        Tobi: Ja, bitte Milch und Brot. Danke!
        Mia: Okay. Und du, Ali?
        Ali: Ich brauche Eier, bitte sechs Stück. Wir haben auch keinen Kaffee mehr.
        Mia: Kein Problem. Ich bin um 18 Uhr wieder zu Hause.
        Tobi: Super! Heute Abend koche ich. Es gibt Nudeln mit Tomatensoße.
        """,
        questions: [
            ReadingQuestion(prompt: "Why does Mia write?",
                            options: ["She is going shopping", "She is cooking tonight", "She is late"],
                            answer: 0, evidence: "Ich gehe gleich einkaufen."),
            ReadingQuestion(prompt: "What does Ali need?",
                            options: ["Milk and bread", "Eggs, and there is no coffee", "Pasta"],
                            answer: 1, evidence: "Ich brauche Eier, bitte sechs Stück."),
            ReadingQuestion(prompt: "Who cooks tonight?",
                            options: ["Mia", "Ali", "Tobi"],
                            answer: 2, evidence: "Heute Abend koche ich.")
        ])

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

    static let a1Birthday = ReadingText(
        id: "a1-birthday", level: .a1, kind: .message,
        title: "A message from Lena", detail: "An invitation",
        systemImage: "gift.fill",
        german: """
        Hallo!

        Am Samstag habe ich Geburtstag. Ich werde 25!
        Ich mache eine kleine Party bei mir zu Hause. Sie beginnt um 19 Uhr.
        Meine Adresse ist Lindenstraße 8, im dritten Stock.
        Bitte bring nichts mit, ich habe genug Essen und Getränke.
        Kommst du? Schreib mir bitte bis Donnerstag.

        Liebe Grüße
        Lena
        """,
        questions: [
            ReadingQuestion(prompt: "Why is Lena having a party?",
                            options: ["She has a new flat", "It's her birthday", "It's the weekend"],
                            answer: 1, evidence: "Am Samstag habe ich Geburtstag."),
            ReadingQuestion(prompt: "When does the party start?",
                            options: ["At 7 pm", "At 8 pm", "At 3 pm"],
                            answer: 0, evidence: "Sie beginnt um 19 Uhr."),
            ReadingQuestion(prompt: "What should you bring?",
                            options: ["Something to eat", "Drinks", "Nothing"],
                            answer: 2, evidence: "Bitte bring nichts mit, ich habe genug Essen und Getränke.")
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
                            options: ["No, only in the morning", "Yes, until 6 pm", "No, it's closed all day"],
                            answer: 0, evidence: "Mittwoch und Freitag: 8 bis 12 Uhr"),
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
        Achtung bitte an Gleis 3!

        Der ICE nach München, Abfahrt 14:20 Uhr, hat heute etwa 15 Minuten Verspätung.
        Der Zug fährt heute von Gleis 5.
        Das Bistro im Zug ist heute leider geschlossen.
        Wir bitten um Entschuldigung.
        """,
        questions: [
            ReadingQuestion(prompt: "How late is the train?",
                            options: ["About 15 minutes", "About 5 minutes", "One hour"],
                            answer: 0, evidence: "Der ICE nach München, Abfahrt 14:20 Uhr, hat heute etwa 15 Minuten Verspätung."),
            ReadingQuestion(prompt: "Where does the train leave from today?",
                            options: ["Platform 3", "Platform 5", "Platform 14"],
                            answer: 1, evidence: "Der Zug fährt heute von Gleis 5."),
            ReadingQuestion(prompt: "What is closed today?",
                            options: ["Platform 3", "The ticket office", "The bistro on the train"],
                            answer: 2, evidence: "Das Bistro im Zug ist heute leider geschlossen.")
        ])
}
