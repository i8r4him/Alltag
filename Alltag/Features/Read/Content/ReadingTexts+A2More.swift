//
//  ReadingTexts+A2More.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension ReadingTexts {
    static let a2Dentist = ReadingText(
        id: "a2-dentist", level: .a2, kind: .email,
        title: "An email from the dentist's", detail: "Your appointment is cancelled",
        systemImage: "cross.case.fill",
        german: """
        Betreff: Ihr Termin am 25. November

        Guten Tag Herr Yilmaz,

        leider müssen wir Ihren Termin am Mittwoch, 25. November, um 10:15 Uhr absagen, weil Frau Dr. Lehmann krank ist.
        Wir können Ihnen zwei neue Termine anbieten: am Montag, 30. November, um 8:30 Uhr oder am Donnerstag, 3. Dezember, um 16 Uhr.
        Bitte antworten Sie uns bis Freitag, welcher Termin für Sie besser passt.
        Wenn Sie Schmerzen haben, können Sie natürlich auch ohne Termin in die Sprechstunde kommen.
        Bitte bringen Sie Ihre Versichertenkarte mit.

        Mit freundlichen Grüßen
        Ihr Praxisteam Dr. Lehmann
        """,
        questions: [
            ReadingQuestion(prompt: "Why is the appointment cancelled?",
                            options: ["The practice is closed for the holidays", "The dentist is ill", "You came too late"],
                            answer: 1,
                            evidence: "leider müssen wir Ihren Termin am Mittwoch, 25. November, um 10:15 Uhr absagen, "
                                + "weil Frau Dr. Lehmann krank ist."),
            ReadingQuestion(prompt: "What should you do by Friday?",
                            options: ["Say which new appointment suits you", "Pay the bill", "Send your insurance card"],
                            answer: 0, evidence: "Bitte antworten Sie uns bis Freitag, welcher Termin für Sie besser passt."),
            ReadingQuestion(prompt: "What can you do if you're in pain?",
                            options: ["Go to hospital", "Wait until December", "Come to the practice without an appointment"],
                            answer: 2,
                            evidence: "Wenn Sie Schmerzen haben, können Sie natürlich auch ohne Termin in die Sprechstunde kommen.")
        ])

    static let a2Neighbour = ReadingText(
        id: "a2-neighbour", level: .a2, kind: .message,
        title: "A message from your neighbour", detail: "Can you water the plants?",
        systemImage: "message.fill",
        german: """
        Hallo Daniel, hier ist Petra aus dem dritten Stock.
        Ich habe heute Mittag dein Paket angenommen, weil du nicht zu Hause warst. Du kannst es heute Abend nach 18 Uhr bei mir abholen.
        Und ich habe eine Frage: Wir fliegen am Sonntag für zwei Wochen nach Spanien. \
        Könntest du in dieser Zeit unsere Blumen gießen? Zweimal pro Woche reicht.
        Den Schlüssel gebe ich dir, wenn du das Paket holst.
        Danke dir! Petra
        """,
        questions: [
            ReadingQuestion(prompt: "Why does Petra have Daniel's parcel?",
                            options: ["He wasn't at home", "She ordered it by mistake", "It was in her letterbox"],
                            answer: 0, evidence: "Ich habe heute Mittag dein Paket angenommen, weil du nicht zu Hause warst."),
            ReadingQuestion(prompt: "How often should Daniel water the plants?",
                            options: ["Every day", "Twice a week", "Once in two weeks"],
                            answer: 1, evidence: "Zweimal pro Woche reicht."),
            ReadingQuestion(prompt: "When does Daniel get the key?",
                            options: ["On Sunday", "In two weeks", "When he picks up the parcel"],
                            answer: 2, evidence: "Den Schlüssel gebe ich dir, wenn du das Paket holst.")
        ])

    static let a2Canteen = ReadingText(
        id: "a2-canteen", level: .a2, kind: .menu,
        title: "The canteen at work", detail: "This week's lunches",
        systemImage: "fork.knife",
        german: """
        Kantine – Mittagessen vom 23. bis 27. November

        Montag: Gemüsesuppe mit Brot – 3,90 €
        Dienstag: Hähnchen mit Reis und Salat – 6,50 €
        Mittwoch: Spaghetti mit Tomatensoße (vegetarisch) – 5,20 €
        Donnerstag: Schweinebraten mit Kartoffeln – 6,90 €
        Freitag: Fisch mit Kartoffelsalat – 6,80 €

        Jeden Tag gibt es auch einen Salatteller für 4,50 €.
        Mitarbeiterinnen und Mitarbeiter mit Kantinenkarte bekommen 10 % Rabatt.
        Getränke und Nachtisch kosten extra.
        Am Freitag schließt die Kantine schon um 13:30 Uhr.
        """,
        questions: [
            ReadingQuestion(prompt: "You don't eat meat. Which day's lunch is for you?",
                            options: ["Tuesday's", "Wednesday's", "Thursday's"],
                            answer: 1, evidence: "Mittwoch: Spaghetti mit Tomatensoße (vegetarisch) – 5,20 €"),
            ReadingQuestion(prompt: "Who gets a discount?",
                            options: ["Staff with a canteen card", "Everybody on Friday", "Guests"],
                            answer: 0, evidence: "Mitarbeiterinnen und Mitarbeiter mit Kantinenkarte bekommen 10 % Rabatt."),
            ReadingQuestion(prompt: "What's different on Friday?",
                            options: ["There's no fish", "Drinks are free", "The canteen closes earlier"],
                            answer: 2, evidence: "Am Freitag schließt die Kantine schon um 13:30 Uhr.")
        ])

    static let a2Postcard = ReadingText(
        id: "a2-postcard", level: .a2, kind: .letter,
        title: "A postcard from a friend", detail: "Holidays by the sea",
        systemImage: "beach.umbrella.fill",
        german: """
        Liebe Sara,

        viele Grüße von der Ostsee! Ich bin jetzt seit einer Woche mit meiner Familie in Warnemünde.
        Am Anfang hat es jeden Tag geregnet, aber seit Montag scheint die Sonne.
        Gestern sind wir mit dem Fahrrad an der Küste entlang nach Heiligendamm gefahren. Das waren über 20 Kilometer!
        Das Wasser ist noch ziemlich kalt, deshalb bin ich nur einmal geschwommen.
        Wir essen fast jeden Abend Fisch. Nur mein Bruder isst lieber Pizza.
        Am Samstag fahren wir wieder nach Hause. Ich bringe dir etwas mit!

        Bis bald
        deine Julia
        """,
        questions: [
            ReadingQuestion(prompt: "What was the weather like at first?",
                            options: ["It was sunny", "It was windy but dry", "It rained every day"],
                            answer: 2, evidence: "Am Anfang hat es jeden Tag geregnet, aber seit Montag scheint die Sonne."),
            ReadingQuestion(prompt: "Why did Julia swim only once?",
                            options: ["The water is still quite cold", "She was ill", "The beach was closed"],
                            answer: 0, evidence: "Das Wasser ist noch ziemlich kalt, deshalb bin ich nur einmal geschwommen."),
            ReadingQuestion(prompt: "When does Julia go home?",
                            options: ["On Monday", "On Saturday", "In two weeks"],
                            answer: 1, evidence: "Am Samstag fahren wir wieder nach Hause.")
        ])

    static let a2Library = ReadingText(
        id: "a2-library", level: .a2, kind: .article,
        title: "Local news", detail: "The library opens on Sundays",
        systemImage: "newspaper.fill",
        german: """
        Stadtbibliothek jetzt auch sonntags geöffnet

        Seit diesem Monat ist die Stadtbibliothek auch am Sonntag geöffnet.
        Sie ist dann von 11 bis 17 Uhr offen. An den anderen Tagen bleiben die Öffnungszeiten gleich.
        Am Sonntag arbeiten dort keine Bibliothekare, sondern Studenten. Sie helfen den Besuchern und erklären die Computer.
        Bücher ausleihen und zurückgeben kann man am Sonntag nur am Automaten.
        Am ersten Sonntag sind über 1.200 Menschen gekommen, viele davon mit Kindern.
        „Viele Familien haben unter der Woche keine Zeit“, sagt die Leiterin Birgit Brandt. „Jetzt können sie gemeinsam kommen.“
        """,
        questions: [
            ReadingQuestion(prompt: "When is the library open on Sundays?",
                            options: ["From 9 am to 1 pm", "From 11 am to 5 pm", "All day"],
                            answer: 1, evidence: "Sie ist dann von 11 bis 17 Uhr offen."),
            ReadingQuestion(prompt: "Who works there on Sundays?",
                            options: ["Students", "Librarians", "Nobody"],
                            answer: 0, evidence: "Am Sonntag arbeiten dort keine Bibliothekare, sondern Studenten."),
            ReadingQuestion(prompt: "Why are Sundays good for families, says the head of the library?",
                            options: ["Books are cheaper on Sundays", "There's a café for children",
                                      "They have no time during the week"],
                            answer: 2, evidence: "„Viele Familien haben unter der Woche keine Zeit“, sagt die Leiterin Birgit Brandt.")
        ])

    static let a2Cat = ReadingText(
        id: "a2-cat", level: .a2, kind: .notice,
        title: "A poster on a lamp post", detail: "A cat is missing",
        systemImage: "cat.fill",
        german: """
        Katze vermisst!

        Unsere Katze Mimi ist seit Montagabend weg.
        Sie ist zwei Jahre alt, grau mit weißen Pfoten und hat ein rotes Halsband.
        Mimi ist sehr scheu und läuft weg, wenn fremde Leute kommen. Bitte versuchen Sie nicht, sie zu fangen.
        Bitte schauen Sie auch in Ihren Keller und in Ihre Garage. Vielleicht ist sie dort eingesperrt.
        Haben Sie Mimi gesehen? Dann rufen Sie uns bitte an: 0176 2345 6789 (Familie Hoffmann, Gartenstraße 8).
        Für Hinweise gibt es eine Belohnung von 50 Euro.
        """,
        questions: [
            ReadingQuestion(prompt: "What does Mimi look like?",
                            options: ["Black with a red collar", "Grey with white paws", "White with grey paws"],
                            answer: 1, evidence: "Sie ist zwei Jahre alt, grau mit weißen Pfoten und hat ein rotes Halsband."),
            ReadingQuestion(prompt: "Where should the neighbours look?",
                            options: ["In the park", "At the vet's", "In their cellar and garage"],
                            answer: 2, evidence: "Bitte schauen Sie auch in Ihren Keller und in Ihre Garage."),
            ReadingQuestion(prompt: "You see Mimi in the street. What do you do?",
                            options: ["Call the family", "Catch her and bring her home", "Give her some food"],
                            answer: 0, evidence: "Dann rufen Sie uns bitte an: 0176 2345 6789 (Familie Hoffmann, Gartenstraße 8).")
        ])
}
