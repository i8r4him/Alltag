//
//  ReadingTexts+A1Phone.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension ReadingTexts {
    // MARK: - A1 on your phone: chats, messages, small ads and the news

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
                            options: ["She is cooking tonight", "She is late", "She is going shopping"],
                            answer: 2, evidence: "Ich gehe gleich einkaufen."),
            ReadingQuestion(prompt: "What does Ali need?",
                            options: ["Milk and bread", "Eggs, and there is no coffee", "Pasta"],
                            answer: 1, evidence: "Ich brauche Eier, bitte sechs Stück."),
            ReadingQuestion(prompt: "Who cooks tonight?",
                            options: ["Mia", "Ali", "Tobi"],
                            answer: 2, evidence: "Heute Abend koche ich.")
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

    static let a1Late = ReadingText(
        id: "a1-late", level: .a1, kind: .message,
        title: "A message from Tom", detail: "He's running late",
        systemImage: "clock.fill",
        german: """
        Hi, sorry! Mein Bus kommt nicht. Ich nehme jetzt die U-Bahn.
        Ich bin in 20 Minuten da, also um 19:20 Uhr.
        Der Film beginnt erst um 19:45 Uhr. Das ist also kein Problem.
        Kannst du schon die Karten kaufen? Ich gebe dir das Geld später.
        Wir treffen uns vor dem Kino, okay?
        Bis gleich!
        Tom
        """,
        questions: [
            ReadingQuestion(prompt: "Why is Tom late?",
                            options: ["He's still at work", "He forgot the time", "His bus isn't coming"],
                            answer: 2, evidence: "Mein Bus kommt nicht."),
            ReadingQuestion(prompt: "What does Tom ask you to do?",
                            options: ["Wait at the bus stop", "Buy the tickets", "Call him"],
                            answer: 1, evidence: "Kannst du schon die Karten kaufen?"),
            ReadingQuestion(prompt: "Where do you meet?",
                            options: ["In front of the cinema", "At the U-Bahn station", "In a café"],
                            answer: 0, evidence: "Wir treffen uns vor dem Kino, okay?")
        ])

    static let a1Family = ReadingText(
        id: "a1-family", level: .a1, kind: .chat,
        title: "The family group chat", detail: "Lunch on Sunday",
        systemImage: "person.3.fill",
        german: """
        Mama: Hallo zusammen! Am Sonntag koche ich. Kommt ihr alle zum Mittagessen?
        Ben: Ja, gern! Um wie viel Uhr?
        Mama: Um 13 Uhr. Es gibt Hähnchen mit Kartoffeln.
        Lea: Ich komme auch, aber erst um 14 Uhr. Ich arbeite bis 13 Uhr.
        Mama: Kein Problem, Lea. Wir warten mit dem Nachtisch auf dich.
        Ben: Soll ich etwas mitbringen?
        Mama: Ja, bitte einen Kuchen für den Nachmittag!
        """,
        questions: [
            ReadingQuestion(prompt: "What is Mum cooking?",
                            options: ["Fish with rice", "Chicken with potatoes", "Pasta"],
                            answer: 1, evidence: "Es gibt Hähnchen mit Kartoffeln."),
            ReadingQuestion(prompt: "Why does Lea come later?",
                            options: ["She works until 1 pm", "Her train is late", "She isn't hungry"],
                            answer: 0, evidence: "Ich arbeite bis 13 Uhr."),
            ReadingQuestion(prompt: "What should Ben bring?",
                            options: ["Drinks", "Nothing", "A cake"],
                            answer: 2, evidence: "Ja, bitte einen Kuchen für den Nachmittag!")
        ])

    static let a1Sofa = ReadingText(
        id: "a1-sofa", level: .a1, kind: .advert,
        title: "A small ad", detail: "A sofa for free",
        systemImage: "sofa.fill",
        german: """
        Sofa zu verschenken

        Ich ziehe um und verschenke mein Sofa.
        Es ist grau, zwei Meter lang und fünf Jahre alt.
        Das Sofa ist sehr bequem und sauber. Es hat nur einen kleinen Fleck.
        Sie müssen das Sofa selbst abholen. Es ist im 4. Stock und es gibt keinen Aufzug.
        Abholung nur am Samstag zwischen 10 und 16 Uhr.
        Bitte schreiben Sie mir eine Nachricht.
        """,
        questions: [
            ReadingQuestion(prompt: "How much does the sofa cost?",
                            options: ["50 euros", "Nothing, it's free", "5 euros"],
                            answer: 1, evidence: "Ich ziehe um und verschenke mein Sofa."),
            ReadingQuestion(prompt: "What will make it hard to pick up?",
                            options: ["It's very heavy and old", "It's far away", "There's no lift"],
                            answer: 2, evidence: "Es ist im 4. Stock und es gibt keinen Aufzug."),
            ReadingQuestion(prompt: "When can you pick it up?",
                            options: ["On Saturday from 10 to 4", "Every evening", "On Sunday"],
                            answer: 0, evidence: "Abholung nur am Samstag zwischen 10 und 16 Uhr.")
        ])

    static let a1Tandem = ReadingText(
        id: "a1-tandem", level: .a1, kind: .advert,
        title: "A small ad", detail: "Looking for a language partner",
        systemImage: "person.2.fill",
        german: """
        Tandempartner gesucht!

        Hallo! Ich heiße Clara, ich bin 28 Jahre alt und komme aus Leipzig.
        Ich lerne Englisch und suche einen Tandempartner oder eine Tandempartnerin.
        Wir sprechen eine Stunde Deutsch und eine Stunde Englisch.
        Ich habe am Dienstag und am Donnerstag ab 18 Uhr Zeit.
        Wir können uns im Café oder in der Bibliothek treffen.
        Ich mag Musik, Kochen und Fahrradfahren.
        Schreib mir einfach eine Nachricht!
        """,
        questions: [
            ReadingQuestion(prompt: "Which language is Clara learning?",
                            options: ["German", "English", "Spanish"],
                            answer: 1, evidence: "Ich lerne Englisch und suche einen Tandempartner oder eine Tandempartnerin."),
            ReadingQuestion(prompt: "When does she have time?",
                            options: ["At the weekend", "Every morning", "Tuesdays and Thursdays from 6 pm"],
                            answer: 2, evidence: "Ich habe am Dienstag und am Donnerstag ab 18 Uhr Zeit."),
            ReadingQuestion(prompt: "Where does she want to meet?",
                            options: ["In a café or the library", "At her flat", "Only online"],
                            answer: 0, evidence: "Wir können uns im Café oder in der Bibliothek treffen.")
        ])

    static let a1Reminder = ReadingText(
        id: "a1-reminder", level: .a1, kind: .message,
        title: "A text from the doctor's practice", detail: "Don't forget your appointment",
        systemImage: "calendar.badge.clock",
        german: """
        Praxis Dr. Weber: Erinnerung an Ihren Termin
        Ihr Termin ist morgen, am Mittwoch, um 10:30 Uhr.
        Bitte bringen Sie Ihre Krankenkassenkarte mit.
        Bitte kommen Sie 10 Minuten früher.
        Sie können nicht kommen? Bitte sagen Sie den Termin bis heute 18 Uhr ab. Telefon: 030 456 789
        Diese SMS ist automatisch. Bitte antworten Sie nicht.
        """,
        questions: [
            ReadingQuestion(prompt: "When is the appointment?",
                            options: ["Today at 6 pm", "Tomorrow at 10:30", "On Wednesday at 10"],
                            answer: 1, evidence: "Ihr Termin ist morgen, am Mittwoch, um 10:30 Uhr."),
            ReadingQuestion(prompt: "What should you bring?",
                            options: ["Your health insurance card", "Your passport", "Nothing"],
                            answer: 0, evidence: "Bitte bringen Sie Ihre Krankenkassenkarte mit."),
            ReadingQuestion(prompt: "You can't come. What do you do?",
                            options: ["Reply to the text", "Just don't go", "Call before 6 pm today"],
                            answer: 2, evidence: "Bitte sagen Sie den Termin bis heute 18 Uhr ab.")
        ])

    static let a1Pool = ReadingText(
        id: "a1-pool", level: .a1, kind: .article,
        title: "Local news", detail: "The swimming pool is open again",
        systemImage: "newspaper.fill",
        german: """
        Das Hallenbad Nord ist wieder offen

        Das Hallenbad Nord ist seit gestern wieder offen.
        Es war ein Jahr lang geschlossen. Die Stadt hat das Bad renoviert.
        Jetzt gibt es ein neues Becken für Kinder und eine Sauna.
        Der Eintritt kostet für Erwachsene 4,50 Euro und für Kinder 2,50 Euro.
        Am Dienstag und am Donnerstag gibt es von 18 bis 20 Uhr Schwimmkurse für Erwachsene.
        Am Montag ist das Bad geschlossen.
        """,
        questions: [
            ReadingQuestion(prompt: "Why was the pool closed for a year?",
                            options: ["It was too expensive", "It was being renovated", "There was no water"],
                            answer: 1, evidence: "Die Stadt hat das Bad renoviert."),
            ReadingQuestion(prompt: "What is new?",
                            options: ["A children's pool and a sauna", "A café", "A bigger car park"],
                            answer: 0, evidence: "Jetzt gibt es ein neues Becken für Kinder und eine Sauna."),
            ReadingQuestion(prompt: "When are there swimming lessons for adults?",
                            options: ["On Monday mornings", "At the weekend", "On Tuesday and Thursday evenings"],
                            answer: 2, evidence: "Am Dienstag und am Donnerstag gibt es von 18 bis 20 Uhr Schwimmkurse für Erwachsene.")
        ])
}
