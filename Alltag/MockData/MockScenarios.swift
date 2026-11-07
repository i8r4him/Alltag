//
//  MockScenarios.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The prototype's conversation scenarios (`SCEN`).
enum MockScenarios {
    static let all: [Scenario] = [dentist, postOffice, station]

    static func scenario(_ id: Scenario.ID) -> Scenario {
        switch id {
        case .dentist: dentist
        case .postOffice: postOffice
        case .station: station
        }
    }

    static let dentist = Scenario(
        id: .dentist,
        title: "At the dentist",
        meta: "German · B1 · phone call",
        goal: "Goal: move your appointment to tomorrow",
        completion: "You moved the appointment.",
        savedPhrases: [SavedPhrase(german: "verschieben", english: "to postpone, move"),
                       SavedPhrase(german: "wenn mir das passt", english: "if that suits me — verb last")],
        systemImage: "cross.case",
        script: [
            ConversationLine(speaker: .companion,
                             german: "Praxis Dr. Weber, guten Tag. Wie kann ich Ihnen helfen?",
                             english: "Dr. Weber's practice, good afternoon. How can I help you?"),
            ConversationLine(speaker: .learner,
                             german: "Können wir den Termin auf morgen verschieben?",
                             english: "Can we move the appointment to tomorrow?",
                             feedback: Feedback(kind: .good, title: "Natural and polite",
                                                note: "„verlegen“ would sound a touch more formal on the phone.")),
            ConversationLine(speaker: .companion,
                             german: "Natürlich. Morgen hätten wir um 10:30 Uhr oder um 15 Uhr etwas frei.",
                             english: "Of course. Tomorrow we have 10:30 or 3 pm available."),
            ConversationLine(speaker: .learner,
                             german: "Ich komme um 15 Uhr, wenn das passt mir.",
                             english: "I'll come at 3 pm, if that suits me.",
                             feedback: Feedback(kind: .fix, title: "Verb goes last after „wenn“",
                                                note: "… wenn mir das passt. Also: „wenn es Ihnen passt“ is what you meant.")),
            ConversationLine(speaker: .companion,
                             german: "Prima, dann trage ich Sie für morgen um 15 Uhr ein. Bis morgen!",
                             english: "Great, I'll put you down for 3 pm tomorrow. See you then!")
        ]
    )

    static let postOffice = Scenario(
        id: .postOffice,
        title: "At the post office",
        meta: "German · B1 · at the counter",
        goal: "Goal: send a package back",
        completion: "You sent the package back.",
        savedPhrases: [SavedPhrase(german: "zurückschicken", english: "to send back"),
                       SavedPhrase(german: "auf meinem Handy", english: "on my phone — dative after auf")],
        systemImage: "shippingbox",
        script: [
            ConversationLine(speaker: .companion,
                             german: "Guten Tag! Was kann ich für Sie tun?",
                             english: "Hello! What can I do for you?"),
            ConversationLine(speaker: .learner,
                             german: "Ich möchte dieses Paket zurückschicken.",
                             english: "I'd like to send this package back.",
                             feedback: Feedback(kind: .good, title: "Clear and natural",
                                                note: "„zurückschicken“ is separable: Ich schicke es zurück.")),
            ConversationLine(speaker: .companion,
                             german: "Haben Sie schon ein Rücksendeetikett?",
                             english: "Do you already have a return label?"),
            ConversationLine(speaker: .learner,
                             german: "Ja, ich habe es auf mein Handy.",
                             english: "Yes, I have it on my phone.",
                             feedback: Feedback(kind: .fix, title: "Location takes the dative",
                                                note: "… auf meinem Handy. „Where?“ → dative.")),
            ConversationLine(speaker: .companion,
                             german: "Perfekt, dann scanne ich den Code. Hier ist Ihre Quittung.",
                             english: "Perfect, I'll scan the code. Here's your receipt.")
        ]
    )

    static let station = Scenario(
        id: .station,
        title: "At the station",
        meta: "German · B1 · ticket desk",
        goal: "Goal: buy a return ticket to Munich",
        completion: "Your Munich trip is booked.",
        savedPhrases: [SavedPhrase(german: "hin und zurück", english: "return (there and back)"),
                       SavedPhrase(german: "abfahren", english: "to depart — separable")],
        systemImage: "tram",
        script: [
            ConversationLine(speaker: .companion,
                             german: "Guten Morgen, wohin möchten Sie fahren?",
                             english: "Good morning, where would you like to go?"),
            ConversationLine(speaker: .learner,
                             german: "Eine Fahrkarte nach München, bitte. Für Freitag.",
                             english: "A ticket to Munich, please. For Friday.",
                             feedback: Feedback(kind: .good, title: "Spot on",
                                                note: "Add „einfach“ or „hin und zurück“ to say one-way or return.")),
            ConversationLine(speaker: .companion,
                             german: "Einfach oder hin und zurück?",
                             english: "One-way or return?"),
            ConversationLine(speaker: .learner,
                             german: "Hin und zurück. Wann der Zug fährt ab?",
                             english: "Return. When does the train leave?",
                             feedback: Feedback(kind: .fix, title: "Questions: verb comes second",
                                                note: "Wann fährt der Zug ab?")),
            ConversationLine(speaker: .companion,
                             german: "Der ICE fährt um 9:12 Uhr von Gleis 7 ab. Das macht 89 Euro.",
                             english: "The ICE leaves at 9:12 from platform 7. That will be 89 euros.")
        ]
    )
}
