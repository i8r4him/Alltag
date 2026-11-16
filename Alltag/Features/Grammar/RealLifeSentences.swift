//
//  RealLifeSentences.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension RealLifeSentence {
    /// Sentences for each rule, by rule ID. The marked words appear in the
    /// sentence in this order.
    static let byRule: [String: [RealLifeSentence]] = a1ByRule.merging(a2ByRule) { _, later in later }
        .merging(b1ByRule) { _, later in later }.merging(b2ByRule) { _, later in later }.merging([
        "v2": verbSecond,
        "akkusativ": accusative,
        "nominal": nominal
    ]) { _, later in later }

    private static let verbSecond: [RealLifeSentence] = [
        RealLifeSentence(place: "Sign at the bakery", systemImage: "storefront",
                         german: "Heute haben wir bis 18 Uhr geöffnet.",
                         english: "Today we're open until 6 pm.", marked: ["haben"]),
        RealLifeSentence(place: "Weather on the radio", systemImage: "radio",
                         german: "Am Wochenende wird es sonnig.",
                         english: "At the weekend it will be sunny.", marked: ["wird"]),
        RealLifeSentence(place: "Supermarket leaflet", systemImage: "cart",
                         german: "Diese Woche gibt es Erdbeeren im Angebot.",
                         english: "This week strawberries are on offer.", marked: ["gibt"]),
        RealLifeSentence(place: "A colleague at work", systemImage: "briefcase",
                         german: "Um zwölf essen wir in der Kantine.",
                         english: "At twelve we eat in the canteen.", marked: ["essen"])
    ]

    private static let accusative: [RealLifeSentence] = [
        RealLifeSentence(place: "At the bakery", systemImage: "storefront",
                         german: "Ich hätte gern einen Kaffee zum Mitnehmen.",
                         english: "I'd like a coffee to take away.", marked: ["einen"]),
        RealLifeSentence(place: "At the till", systemImage: "creditcard",
                         german: "Brauchen Sie den Kassenbon?",
                         english: "Do you need the receipt?", marked: ["den"]),
        RealLifeSentence(place: "Message from a friend", systemImage: "message",
                         german: "Hast du den Schlüssel?",
                         english: "Have you got the key?", marked: ["den"]),
        RealLifeSentence(place: "At the station", systemImage: "tram",
                         german: "Entschuldigung, ich suche den Ausgang.",
                         english: "Excuse me, I'm looking for the exit.", marked: ["den"])
    ]

    private static let nominal: [RealLifeSentence] = [
        RealLifeSentence(place: "News headline", systemImage: "newspaper",
                         german: "Wegen des Streiks fallen viele Flüge aus.",
                         english: "Because of the strike, many flights are cancelled.", marked: ["Wegen des Streiks"]),
        RealLifeSentence(place: "Your tenancy agreement", systemImage: "doc.text",
                         german: "Nach Ablauf der Frist ist keine Kündigung mehr möglich.",
                         english: "Once the deadline has passed, notice can no longer be given.",
                         marked: ["Nach Ablauf der Frist"]),
        RealLifeSentence(place: "Railway app", systemImage: "iphone",
                         german: "Bei Verspätungen informieren wir Sie per Push-Nachricht.",
                         english: "If there are delays, we'll let you know with a notification.", marked: ["Bei Verspätungen"]),
        RealLifeSentence(place: "Letter from an office", systemImage: "envelope",
                         german: "Zur Prüfung Ihres Antrags benötigen wir weitere Unterlagen.",
                         english: "To check your application, we need further documents.",
                         marked: ["Zur Prüfung Ihres Antrags"])
    ]
}
