//
//  ReadingTexts+A2.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension ReadingTexts {
    /// A2: everyday texts with "weil", "dass" and the perfect tense, about 80 to 120 words.
    static let a2: [ReadingText] = [a2Water, a2Course, a2Bike, a2Cleaning, a2Heating, a2Works]

    static let a2Water = ReadingText(
        id: "a2-water", level: .a2, kind: .notice,
        title: "A notice in the stairwell", detail: "No water on Thursday",
        systemImage: "drop.fill",
        german: """
        Liebe Mieterinnen und Mieter,

        am Donnerstag, 21. November, ist von 8 bis 12 Uhr kein Wasser im Haus.
        Im Keller werden die Wasserrohre repariert.
        Bitte füllen Sie vorher Wasser in Flaschen oder Töpfe ab.
        In dieser Zeit können Sie auch die Waschmaschine nicht benutzen.
        Ab 12 Uhr gibt es wieder Wasser. Am Anfang kann es braun sein. Lassen Sie es dann ein paar Minuten laufen.

        Wir bitten um Ihr Verständnis.
        Ihre Hausverwaltung Schulz
        """,
        questions: [
            ReadingQuestion(prompt: "When is there no water?",
                            options: ["All day on Thursday", "Thursday morning", "Friday from 8 o'clock"],
                            answer: 1, evidence: "am Donnerstag, 21. November, ist von 8 bis 12 Uhr kein Wasser im Haus."),
            ReadingQuestion(prompt: "What should you do before?",
                            options: ["Fill bottles or pots with water", "Call the property management", "Open the cellar"],
                            answer: 0, evidence: "Bitte füllen Sie vorher Wasser in Flaschen oder Töpfe ab."),
            ReadingQuestion(prompt: "What if the water is brown at first?",
                            options: ["Call the property management", "Don't drink it for a day", "Let it run for a few minutes"],
                            answer: 2, evidence: "Lassen Sie es dann ein paar Minuten laufen.")
        ])

    static let a2Course = ReadingText(
        id: "a2-course", level: .a2, kind: .email,
        title: "An email from the language school", detail: "Your course moves",
        systemImage: "envelope.fill",
        german: """
        Liebe Kursteilnehmerinnen und Kursteilnehmer,

        ab nächster Woche ist der Kurs A2.2 in einem anderen Raum. \
        Wir sind jetzt in Raum 104 im ersten Stock, nicht mehr in Raum 12 im Erdgeschoss.
        Die Zeit ändert sich auch: Der Kurs beginnt am Montag und Mittwoch schon um 17:30 Uhr und endet um 19 Uhr.
        Am 4. Dezember fällt der Unterricht aus, weil Ihre Lehrerin auf einer Fortbildung ist.
        Die Prüfung ist wie geplant am 18. Dezember.

        Bei Fragen schreiben Sie mir gern.
        Viele Grüße
        Sabine Krämer, Sprachschule Lingua
        """,
        questions: [
            ReadingQuestion(prompt: "Where is the course from next week?",
                            options: ["In room 12 on the ground floor", "Online", "In room 104 on the first floor"],
                            answer: 2, evidence: "Wir sind jetzt in Raum 104 im ersten Stock, nicht mehr in Raum 12 im Erdgeschoss."),
            ReadingQuestion(prompt: "When does the course start now?",
                            options: ["At 5:30 pm", "At 7 pm", "At 6 pm"],
                            answer: 0,
                            evidence: "Der Kurs beginnt am Montag und Mittwoch schon um 17:30 Uhr und endet um 19 Uhr."),
            ReadingQuestion(prompt: "Why is there no lesson on 4 December?",
                            options: ["It's a holiday", "The teacher is on a training course", "There is an exam"],
                            answer: 1, evidence: "Am 4. Dezember fällt der Unterricht aus, weil Ihre Lehrerin auf einer Fortbildung ist.")
        ])

    static let a2Bike = ReadingText(
        id: "a2-bike", level: .a2, kind: .advert,
        title: "A small ad", detail: "A bike for sale",
        systemImage: "bicycle",
        german: """
        Damenfahrrad zu verkaufen – 120 Euro

        Ich verkaufe mein Fahrrad, weil ich nach Hamburg umziehe.
        Das Fahrrad ist vier Jahre alt und hat sieben Gänge. Es ist blau und in gutem Zustand.
        Die Bremsen sind neu, aber das Licht vorne funktioniert nicht.
        Ein Schloss bekommen Sie gratis dazu.
        Nur Abholung in Köln-Ehrenfeld, kein Versand.
        Bei Interesse schreiben Sie mir bitte eine Nachricht. Am Wochenende können Sie das Fahrrad gern ansehen.
        """,
        questions: [
            ReadingQuestion(prompt: "Why is the bike for sale?",
                            options: ["It's broken", "The seller is moving to Hamburg", "The seller has a new bike"],
                            answer: 1, evidence: "Ich verkaufe mein Fahrrad, weil ich nach Hamburg umziehe."),
            ReadingQuestion(prompt: "What doesn't work?",
                            options: ["The front light", "The brakes", "The gears"],
                            answer: 0, evidence: "Die Bremsen sind neu, aber das Licht vorne funktioniert nicht."),
            ReadingQuestion(prompt: "What do you get for free?",
                            options: ["Delivery", "A helmet", "A lock"],
                            answer: 2, evidence: "Ein Schloss bekommen Sie gratis dazu.")
        ])

    static let a2Cleaning = ReadingText(
        id: "a2-cleaning", level: .a2, kind: .chat,
        title: "The flatshare group chat", detail: "Whose turn is it?",
        systemImage: "bubble.left.and.bubble.right.fill",
        german: """
        Tobi: Leute, die Küche sieht schlimm aus. Wer ist diese Woche mit Putzen dran?
        Mia: Laut Putzplan ist es Ali. Ich habe letzte Woche geputzt.
        Ali: Sorry, ich hatte so viel Stress bei der Arbeit. Ich mache es heute Abend, versprochen!
        Tobi: Danke. Und kann jemand den Müll runterbringen? Der Mülleimer ist total voll.
        Mia: Das mache ich gleich, ich gehe sowieso raus.
        Ali: Übrigens: Morgen kommt meine Schwester zu Besuch. Sie schläft eine Nacht bei uns im Wohnzimmer. Ist das okay?
        Tobi: Klar, kein Problem!
        """,
        questions: [
            ReadingQuestion(prompt: "Whose turn is it to clean this week?",
                            options: ["Mia's", "Tobi's", "Ali's"],
                            answer: 2, evidence: "Laut Putzplan ist es Ali."),
            ReadingQuestion(prompt: "Who takes the rubbish out?",
                            options: ["Mia", "Ali", "Tobi"],
                            answer: 0, evidence: "Das mache ich gleich, ich gehe sowieso raus."),
            ReadingQuestion(prompt: "What happens tomorrow?",
                            options: ["They all clean together", "Ali's sister comes to stay", "Tobi moves out"],
                            answer: 1, evidence: "Übrigens: Morgen kommt meine Schwester zu Besuch.")
        ])

    static let a2Heating = ReadingText(
        id: "a2-heating", level: .a2, kind: .letter,
        title: "A letter from the property management", detail: "Your heating is repaired",
        systemImage: "heater.vertical.fill",
        german: """
        Sehr geehrte Frau Becker,

        vielen Dank für Ihre Nachricht. Es tut uns leid, dass die Heizung in Ihrer Wohnung nicht funktioniert.
        Ein Techniker von der Firma Wärme Plus kommt am Dienstag zwischen 9 und 13 Uhr zu Ihnen.
        Bitte seien Sie in dieser Zeit zu Hause. Wenn das nicht geht, geben Sie den Schlüssel bitte Ihrem Nachbarn oder rufen Sie uns an.
        Die Reparatur kostet Sie nichts.
        Bis dahin können Sie bei uns im Büro einen Heizlüfter abholen.

        Mit freundlichen Grüßen
        Hausverwaltung Schulz
        """,
        questions: [
            ReadingQuestion(prompt: "What is the problem?",
                            options: ["The heating doesn't work", "There is no water", "The rent goes up"],
                            answer: 0, evidence: "Es tut uns leid, dass die Heizung in Ihrer Wohnung nicht funktioniert."),
            ReadingQuestion(prompt: "What if you aren't at home on Tuesday?",
                            options: ["The technician comes another week", "Give the key to a neighbour or call",
                                      "Leave the door open"],
                            answer: 1,
                            evidence: "Wenn das nicht geht, geben Sie den Schlüssel bitte Ihrem Nachbarn oder rufen Sie uns an."),
            ReadingQuestion(prompt: "Who pays for the repair?",
                            options: ["You do", "You and your neighbour", "It costs you nothing"],
                            answer: 2, evidence: "Die Reparatur kostet Sie nichts.")
        ])

    static let a2Works = ReadingText(
        id: "a2-works", level: .a2, kind: .announcement,
        title: "A notice from Deutsche Bahn", detail: "Engineering works",
        systemImage: "tram.fill",
        german: """
        Bauarbeiten zwischen Hamburg und Buchholz

        An den nächsten beiden Wochenenden fahren wegen Bauarbeiten keine Züge zwischen Hamburg-Harburg und Buchholz.
        Zwischen diesen Bahnhöfen gibt es einen Ersatzverkehr mit Bussen.
        Die Busse brauchen etwa 30 Minuten länger als der Zug. Fahrräder können leider nicht mitgenommen werden.
        Bitte planen Sie mehr Zeit ein und prüfen Sie Ihre Verbindung vor der Fahrt online oder in der App.

        Wir bitten um Ihr Verständnis.
        """,
        questions: [
            ReadingQuestion(prompt: "Why are there no trains at the weekend?",
                            options: ["A strike", "Bad weather", "Engineering works"],
                            answer: 2,
                            evidence: "An den nächsten beiden Wochenenden fahren wegen Bauarbeiten keine Züge "
                                + "zwischen Hamburg-Harburg und Buchholz."),
            ReadingQuestion(prompt: "How do you get from Harburg to Buchholz?",
                            options: ["By bus", "By another train", "You can't"],
                            answer: 0, evidence: "Zwischen diesen Bahnhöfen gibt es einen Ersatzverkehr mit Bussen."),
            ReadingQuestion(prompt: "What can't you take with you?",
                            options: ["A suitcase", "A bike", "A dog"],
                            answer: 1, evidence: "Fahrräder können leider nicht mitgenommen werden.")
        ])
}
