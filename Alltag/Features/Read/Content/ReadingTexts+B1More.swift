//
//  ReadingTexts+B1More.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension ReadingTexts {
    static let b1HealthCard = ReadingText(
        id: "b1-health-card", level: .b1, kind: .letter,
        title: "A letter from your health insurer", detail: "A photo for your new card",
        systemImage: "cross.case.fill",
        german: """
        Ihre neue Gesundheitskarte

        Sehr geehrter Herr Hoffmann,

        Ihre elektronische Gesundheitskarte ist nur noch bis zum 31. März gültig.
        Damit wir Ihnen rechtzeitig eine neue Karte schicken können, brauchen wir ein aktuelles Foto von Ihnen.
        Am einfachsten laden Sie das Foto in unserer App hoch.
        Sie können es aber auch mit dem beiliegenden Rückumschlag per Post schicken. Das Porto übernehmen wir.
        Das Foto sollte nicht älter als ein Jahr sein, und Ihr Gesicht muss gut zu erkennen sein.
        Bitte senden Sie es uns bis zum 15. Februar. Die neue Karte bekommen Sie dann etwa drei Wochen später.
        Bis dahin können Sie Ihre alte Karte beim Arzt ganz normal benutzen.

        Mit freundlichen Grüßen
        Ihre Gesundheitskasse Nord
        """,
        questions: [
            ReadingQuestion(prompt: "Why does the insurer write to Herr Hoffmann?",
                            options: ["He hasn't paid", "His card runs out at the end of March", "He has a new doctor"],
                            answer: 1, evidence: "Ihre elektronische Gesundheitskarte ist nur noch bis zum 31. März gültig."),
            ReadingQuestion(prompt: "He doesn't use the app. How can he send the photo?",
                            options: ["He has to bring it to the office", "By email", "By post, in the envelope that came with the letter"],
                            answer: 2,
                            evidence: "Sie können es aber auch mit dem beiliegenden Rückumschlag per Post schicken."),
            ReadingQuestion(prompt: "Can he see a doctor before the new card arrives?",
                            options: ["Yes, with his old card", "Only with a paper form", "No, he has to wait"],
                            answer: 0, evidence: "Bis dahin können Sie Ihre alte Karte beim Arzt ganz normal benutzen.")
        ])

    static let b1Delay = ReadingText(
        id: "b1-delay", level: .b1, kind: .message,
        title: "A message from the train app", detail: "Your train is late",
        systemImage: "train.side.front.car",
        german: """
        Ihre Reise nach Hamburg: Der ICE 578 hat voraussichtlich 70 Minuten Verspätung wegen einer Signalstörung.
        Ihre Zugbindung ist aufgehoben. Sie können also auch einen anderen Zug nehmen, ohne ein neues Ticket zu kaufen.
        Kommen Sie mindestens 60 Minuten zu spät an, erhalten Sie 25 Prozent des Fahrpreises zurück, ab 120 Minuten sind es 50 Prozent.
        Den Antrag stellen Sie am einfachsten hier in der App unter „Fahrgastrechte“.
        Wir bitten um Entschuldigung.
        """,
        questions: [
            ReadingQuestion(prompt: "Why is the train late?",
                            options: ["Bad weather", "A strike", "A problem with a signal"],
                            answer: 2,
                            evidence: "Der ICE 578 hat voraussichtlich 70 Minuten Verspätung wegen einer Signalstörung."),
            ReadingQuestion(prompt: "What can you do now?",
                            options: ["Take another train with the same ticket", "Take a taxi for free", "Get all your money back at once"],
                            answer: 0,
                            evidence: "Sie können also auch einen anderen Zug nehmen, ohne ein neues Ticket zu kaufen."),
            ReadingQuestion(prompt: "You arrive 70 minutes late. What do you get back?",
                            options: ["Nothing", "A quarter of the fare", "Half of the fare"],
                            answer: 1,
                            evidence: "Kommen Sie mindestens 60 Minuten zu spät an, erhalten Sie 25 Prozent des Fahrpreises zurück")
        ])

    static let b1Birthday = ReadingText(
        id: "b1-birthday", level: .b1, kind: .chat,
        title: "The family chat", detail: "A surprise for Grandma",
        systemImage: "birthday.cake.fill",
        german: """
        Elif: Hallo zusammen! Oma wird am 12. Dezember 70. Wollen wir ihr eine Überraschungsparty machen?
        Can: Gute Idee! Aber nicht bei ihr zu Hause, sonst merkt sie es sofort.
        Elif: Ich habe schon im Restaurant „Am Markt“ gefragt. Der Nebenraum ist an dem Samstag noch frei, für bis zu 30 Personen.
        Tante Leyla: Wunderbar! Ich kümmere mich um den Kuchen, den backe ich selbst.
        Can: Und das Geschenk? Ich dachte an einen Gutschein für eine Schifffahrt auf dem Rhein. Davon redet sie schon lange.
        Elif: Perfekt. Jeder gibt 20 Euro, ich sammle das Geld. Bitte überweist es mir bis Sonntag.
        Tante Leyla: Und wer bringt Oma hin? Sie darf ja nichts wissen.
        Can: Das mache ich. Ich sage ihr einfach, dass wir zu zweit essen gehen.
        """,
        questions: [
            ReadingQuestion(prompt: "Why not have the party at Grandma's home?",
                            options: ["Her flat is too small", "She would notice at once", "She's away that weekend"],
                            answer: 1, evidence: "Aber nicht bei ihr zu Hause, sonst merkt sie es sofort."),
            ReadingQuestion(prompt: "What will they give her?",
                            options: ["A voucher for a boat trip", "A cake from the restaurant", "Twenty euros each"],
                            answer: 0, evidence: "Ich dachte an einen Gutschein für eine Schifffahrt auf dem Rhein."),
            ReadingQuestion(prompt: "How will Can get her to the restaurant?",
                            options: ["He tells her about the party", "Aunt Leyla picks her up",
                                      "He says it's just the two of them going for a meal"],
                            answer: 2, evidence: "Ich sage ihr einfach, dass wir zu zweit essen gehen.")
        ])

    static let b1Lunch = ReadingText(
        id: "b1-lunch", level: .b1, kind: .menu,
        title: "A lunch menu", detail: "The week at the bistro",
        systemImage: "fork.knife",
        german: """
        Mittagstisch im Bistro Lindenhof
        Montag bis Freitag, 11:30 bis 14:30 Uhr. Zu jedem Gericht gibt es einen kleinen Salat.
        Montag: Hähnchencurry mit Reis – 10,50 €
        Dienstag: Gemüselasagne (vegetarisch) – 9,80 €
        Mittwoch: Rinderroulade mit Rotkohl und Klößen – 12,90 €
        Donnerstag: Linsensuppe mit Brot (vegan) – 7,50 €
        Freitag: Backfisch mit Kartoffelsalat – 11,50 €
        Alle Gerichte gibt es auch zum Mitnehmen. Wenn Sie Ihre eigene Dose mitbringen, sparen Sie 50 Cent.
        Fragen Sie unser Personal, wenn Sie Informationen zu Allergenen brauchen.
        """,
        questions: [
            ReadingQuestion(prompt: "You're vegan. Which day is for you?",
                            options: ["Tuesday", "Friday", "Thursday"],
                            answer: 2, evidence: "Donnerstag: Linsensuppe mit Brot (vegan) – 7,50 €"),
            ReadingQuestion(prompt: "How can you pay a little less?",
                            options: ["Bring your own box for a takeaway", "Come before 12", "Leave out the salad"],
                            answer: 0, evidence: "Wenn Sie Ihre eigene Dose mitbringen, sparen Sie 50 Cent."),
            ReadingQuestion(prompt: "Where do you find out about allergens?",
                            options: ["On the menu", "From the staff", "On the bistro's website"],
                            answer: 1, evidence: "Fragen Sie unser Personal, wenn Sie Informationen zu Allergenen brauchen.")
        ])

    static let b1ReplacementBus = ReadingText(
        id: "b1-replacement-bus", level: .b1, kind: .announcement,
        title: "A poster at the station", detail: "Buses instead of trains",
        systemImage: "bus.doubledecker.fill",
        german: """
        Bauarbeiten: Busse statt S-Bahn

        Vom 2. bis 13. März werden zwischen den Stationen Nordbahnhof und Flughafen die Gleise erneuert.
        In dieser Zeit fahren auf diesem Abschnitt keine S-Bahnen. Stattdessen fahren Ersatzbusse im Abstand von zehn Minuten.
        Die Haltestellen der Ersatzbusse finden Sie vor den Bahnhöfen. Folgen Sie einfach den gelben Schildern.
        Bitte planen Sie für Ihre Fahrt etwa 20 Minuten mehr ein.
        Fahrräder können in den Bussen leider nicht mitgenommen werden. Kinderwagen und Rollstühle sind dagegen kein Problem.
        Ihre Fahrkarten gelten natürlich auch in den Ersatzbussen.
        Wir bitten Sie um Verständnis.
        """,
        questions: [
            ReadingQuestion(prompt: "How often do the buses run?",
                            options: ["Every 20 minutes", "Every ten minutes", "Once an hour"],
                            answer: 1, evidence: "Stattdessen fahren Ersatzbusse im Abstand von zehn Minuten."),
            ReadingQuestion(prompt: "How do you find the bus stops?",
                            options: ["Follow the yellow signs", "Ask at the ticket office", "Look in the app"],
                            answer: 0, evidence: "Folgen Sie einfach den gelben Schildern."),
            ReadingQuestion(prompt: "You travel with your bike. What is the problem?",
                            options: ["You need an extra ticket", "Only folding bikes are allowed", "Bikes can't go on the buses"],
                            answer: 2, evidence: "Fahrräder können in den Bussen leider nicht mitgenommen werden.")
        ])

    static let b1RepairCafe = ReadingText(
        id: "b1-repair-cafe", level: .b1, kind: .article,
        title: "Local news", detail: "Repair it, don't throw it away",
        systemImage: "hammer.fill",
        german: """
        Reparieren statt wegwerfen

        Seit Oktober gibt es im Stadtteilzentrum Süd ein Repair-Café.
        Jeden ersten Samstag im Monat können Besucher dort kaputte Toaster, Lampen, Kleidung oder Fahrräder reparieren lassen.
        Die Helferinnen und Helfer arbeiten ehrenamtlich, das heißt, sie bekommen kein Geld dafür.
        Die Reparatur ist kostenlos, über eine kleine Spende freut sich das Team aber.
        „Wir wollen nicht einfach alles für die Leute machen“, erklärt die Organisatorin Petra Lang. \
        „Die Besucher sollen zuschauen und selbst etwas lernen.“
        Beim letzten Treffen wurden 34 Geräte repariert. Nur bei sechs Geräten hat es nicht geklappt, meistens weil Ersatzteile fehlten.
        Wer mithelfen möchte, ist herzlich willkommen. Besonders gesucht werden Menschen, die nähen können.
        """,
        questions: [
            ReadingQuestion(prompt: "How much does a repair cost?",
                            options: ["Five euros", "Only the spare parts", "Nothing, but you can give a donation"],
                            answer: 2, evidence: "Die Reparatur ist kostenlos, über eine kleine Spende freut sich das Team aber."),
            ReadingQuestion(prompt: "What does Petra Lang want visitors to do?",
                            options: ["Watch and learn something", "Bring a cake", "Leave their things and come back later"],
                            answer: 0, evidence: "Die Besucher sollen zuschauen und selbst etwas lernen."),
            ReadingQuestion(prompt: "Who are they looking for most?",
                            options: ["Electricians", "People who can sew", "Young people"],
                            answer: 1, evidence: "Besonders gesucht werden Menschen, die nähen können.")
        ])
}
