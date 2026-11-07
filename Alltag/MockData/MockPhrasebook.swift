//
//  MockPhrasebook.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The prototype's Phrasebook (`PB`). "At the bakery" is added later by Debrief.
enum MockPhrasebook {
    private struct Group {
        let place: String
        let symbol: String
        let phrases: [(german: String, english: String)]
    }

    static func make(now: Date = .now) -> [Phrase] {
        let groups = [
            Group(place: "At the doctor", symbol: "cross.case", phrases: [
                ("Können wir den Termin auf morgen verschieben?", "Can we move the appointment to tomorrow?"),
                ("Ich habe seit zwei Tagen Halsschmerzen.", "I've had a sore throat for two days.")
            ]),
            Group(place: "Trains & travel", symbol: "tram", phrases: [
                ("Einmal nach München, hin und zurück.", "One return to Munich."),
                ("Von welchem Gleis fährt der Zug ab?", "Which platform does the train leave from?")
            ]),
            Group(place: "With my landlord", symbol: "key", phrases: [
                ("Die Heizung funktioniert nicht.", "The heating isn't working."),
                ("Wie lange ist die Kündigungsfrist?", "How long is the notice period?")
            ]),
            Group(place: "At work", symbol: "briefcase", phrases: [
                ("Sag mir Bescheid, wann du Zeit hast.", "Let me know when you're free."),
                ("Ich mache jetzt Feierabend.", "I'm calling it a day.")
            ])
        ]
        // A second apart, so the Phrasebook keeps the prototype's order.
        let phrases = groups.flatMap { group in group.phrases.map { (group, $0) } }
        return phrases.enumerated().map { index, entry in
            Phrase(german: entry.1.german, english: entry.1.english,
                   place: entry.0.place, placeSymbol: entry.0.symbol,
                   createdAt: now.addingTimeInterval(Double(index)))
        }
    }
}
