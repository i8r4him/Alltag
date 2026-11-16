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
    static let byRule: [String: [RealLifeSentence]] = a1ByRule.merging(b1ByRule) { _, later in later }.merging([
        "v2": verbSecond,
        "akkusativ": accusative,
        "perfekt": perfekt,
        "seit": seit,
        "passiv": passiv,
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

    private static let perfekt: [RealLifeSentence] = [
        RealLifeSentence(place: "Message from a friend", systemImage: "message",
                         german: "Ich habe dir gestern ein Foto geschickt.",
                         english: "I sent you a photo yesterday.", marked: ["habe", "geschickt"]),
        RealLifeSentence(place: "Monday at work", systemImage: "briefcase",
                         german: "Wir sind am Samstag ins Kino gegangen.",
                         english: "We went to the cinema on Saturday.", marked: ["sind", "gegangen"]),
        RealLifeSentence(place: "At the pharmacy", systemImage: "cross.case",
                         german: "Haben Sie das Rezept mitgebracht?",
                         english: "Have you brought the prescription?", marked: ["Haben", "mitgebracht"]),
        RealLifeSentence(place: "Parcel notification", systemImage: "shippingbox",
                         german: "Ihr Paket ist heute angekommen.",
                         english: "Your parcel arrived today.", marked: ["ist", "angekommen"])
    ]

    private static let seit: [RealLifeSentence] = [
        RealLifeSentence(place: "At the doctor's", systemImage: "stethoscope",
                         german: "Seit wann haben Sie die Schmerzen?",
                         english: "How long have you had the pain?", marked: ["Seit"]),
        RealLifeSentence(place: "Meeting a neighbour", systemImage: "house",
                         german: "Wir wohnen seit 2020 in diesem Haus.",
                         english: "We've lived in this house since 2020.", marked: ["seit"]),
        RealLifeSentence(place: "Station announcement", systemImage: "tram",
                         german: "Die Strecke ist seit Montag gesperrt.",
                         english: "The line has been closed since Monday.", marked: ["seit"]),
        RealLifeSentence(place: "Planning a holiday", systemImage: "airplane",
                         german: "Wir fahren für zwei Wochen nach Italien.",
                         english: "We're going to Italy for two weeks.", marked: ["für"])
    ]

    private static let passiv: [RealLifeSentence] = [
        RealLifeSentence(place: "Notice in your building", systemImage: "building.2",
                         german: "Am Freitag wird das Wasser abgestellt.",
                         english: "The water will be turned off on Friday.", marked: ["wird", "abgestellt"]),
        RealLifeSentence(place: "Letter from an office", systemImage: "envelope",
                         german: "Ihr Antrag wurde genehmigt.",
                         english: "Your application has been approved.", marked: ["wurde", "genehmigt"]),
        RealLifeSentence(place: "At the till", systemImage: "creditcard",
                         german: "Hier kann nur mit Karte bezahlt werden.",
                         english: "Only card payments are accepted here.", marked: ["kann", "bezahlt werden"]),
        RealLifeSentence(place: "Station announcement", systemImage: "tram",
                         german: "Der Zug wird heute auf Gleis 5 bereitgestellt.",
                         english: "Today the train will leave from platform 5.", marked: ["wird", "bereitgestellt"])
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
