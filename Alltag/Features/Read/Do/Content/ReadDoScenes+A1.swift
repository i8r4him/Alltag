//
//  ReadDoScenes+A1.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension ReadDoScenes {
    /// A1: things you meet in the first weeks: a bus stop, a bakery, doorbells,
    /// a receipt, a ticket. Getting around and out in town are here; packaging,
    /// receipts, forms and bills are in `ReadDoScenes+A1Papers.swift`.
    static let a1: [ReadDoScene] = [
        a1Bus, a1Bakery, a1Doorbells, a1Milk, a1Receipt, a1Store, a1Form, a1Bins, a1UBahn,
        a1Pasta, a1Postbox, a1Pool, a1Ticket, a1DoctorForm, a1TV, a1Cinema, a1Bill
    ]

    static let a1Bus = ReadDoScene(
        id: "a1-do-bus", level: .a1, kind: .departures,
        title: "The bus stop", detail: "When does your bus come?", systemImage: "bus.fill",
        content: """
        # Haltestelle Rathaus
        ## Nächste Abfahrten
        10:05 | 12 | Hauptbahnhof | 3 Min.
        10:09 | 7 | Uni | 7 Min.
        10:14 | 12 | Zoo | 12 Min.
        10:20 | 3 | Krankenhaus | 18 Min.
        Heute fährt kein Bus 5. Bitte nehmen Sie den Bus 12.
        """,
        tasks: [
            ReadDoTask(prompt: "You want to go to the zoo. Tap your bus.", answer: "Zoo"),
            ReadDoTask(prompt: "Which bus goes to the hospital?", answer: "Krankenhaus"),
            ReadDoTask(prompt: "What does the board say about bus 5?", answer: "kein Bus 5")
        ])

    static let a1UBahn = ReadDoScene(
        id: "a1-do-ubahn", level: .a1, kind: .departures,
        title: "The U-Bahn platform", detail: "Which train is yours?", systemImage: "tram.fill",
        content: """
        # U-Bahnhof Marktplatz
        ## Abfahrten
        U2 | Flughafen | 2 Min. | Gleis 1
        U2 | Stadion | 4 Min. | Gleis 2
        U5 | Hauptbahnhof | 6 Min. | Gleis 1
        U5 | Messe | 9 Min. | Gleis 2
        U2 | Flughafen | 12 Min. | Gleis 1
        Der Aufzug zu Gleis 2 ist heute kaputt.
        """,
        tasks: [
            ReadDoTask(prompt: "You're flying today. Tap the next train to the airport.", answer: "Flughafen | 2 Min."),
            ReadDoTask(prompt: "Which train goes to the main station?", answer: "Hauptbahnhof"),
            ReadDoTask(prompt: "You have a heavy suitcase. What's the problem today?", answer: "Aufzug")
        ])

    static let a1Bakery = ReadDoScene(
        id: "a1-do-bakery", level: .a1, kind: .sign,
        title: "The bakery's opening hours", detail: "Is it open on Sunday?", systemImage: "storefront.fill",
        content: """
        # Bäckerei Sonnenschein
        ## Öffnungszeiten
        Montag bis Freitag | 6:30 – 18:00
        Samstag | 7:00 – 13:00
        Sonntag | 8:00 – 11:00
        Feiertage | geschlossen
        ---
        Frische Brötchen jeden Morgen!
        Wir suchen eine Aushilfe. Fragen Sie an der Kasse.
        """,
        tasks: [
            ReadDoTask(prompt: "When is the bakery open on Sunday?", answer: "Sonntag"),
            ReadDoTask(prompt: "When is it closed all day?", answer: "Feiertage"),
            ReadDoTask(prompt: "The bakery needs help. Where can you ask about it?", answer: "an der Kasse")
        ])

    static let a1Doorbells = ReadDoScene(
        id: "a1-do-doorbells", level: .a1, kind: .sign,
        title: "The doorbells", detail: "Which bell do you ring?", systemImage: "bell.fill",
        content: """
        # Lindenstraße 8
        3. OG rechts | L. Fischer
        3. OG links | Hoffmann
        2. OG rechts | Petrović
        2. OG links | WG Weber / Klein / Sánchez
        1. OG rechts | Dr. Aydın – Zahnarzt
        1. OG links | Schmidt
        EG | Hausmeister
        """,
        tasks: [
            ReadDoTask(prompt: "You're going to Lena Fischer's birthday party. Tap her bell.", answer: "Fischer"),
            ReadDoTask(prompt: "You have toothache. Where do you ring?", answer: "Zahnarzt"),
            ReadDoTask(prompt: "A parcel is for Carmen Sánchez. Which bell?", answer: "Sánchez")
        ])

    static let a1Store = ReadDoScene(
        id: "a1-do-store", level: .a1, kind: .sign,
        title: "The department store guide", detail: "Which floor do you need?", systemImage: "building.2.fill",
        content: """
        # Kaufhaus Stern
        ## Wegweiser
        UG | Lebensmittel · Getränke
        EG | Kosmetik · Taschen · Information
        1. OG | Damen · Herren
        2. OG | Kinder · Spielwaren
        3. OG | Haushalt · Elektro
        4. OG | Restaurant · Toiletten
        """,
        tasks: [
            ReadDoTask(prompt: "You need a toy for a child's birthday. Tap the floor.", answer: "Spielwaren"),
            ReadDoTask(prompt: "Your phone charger is broken. Where can you buy a new one?", answer: "Elektro"),
            ReadDoTask(prompt: "Where are the toilets?", answer: "Toiletten")
        ])

    static let a1Postbox = ReadDoScene(
        id: "a1-do-postbox", level: .a1, kind: .schedule,
        title: "The postbox", detail: "When is the post collected?", systemImage: "envelope.fill",
        content: """
        # Briefkasten
        ## Leerungszeiten
        Mo – Fr | 17:30 Uhr
        Sa | 12:00 Uhr
        So | keine Leerung
        ---
        Nächste Leerung | heute, 17:30 Uhr
        Pakete bitte in der Postfiliale abgeben.
        """,
        tasks: [
            ReadDoTask(prompt: "It's Saturday morning. By when must your letter be in the box?", answer: "12:00"),
            ReadDoTask(prompt: "Is the post collected on Sunday? Tap the answer.", answer: "keine Leerung"),
            ReadDoTask(prompt: "You have a parcel, not a letter. What does the box say?", answer: "Pakete")
        ])

    static let a1Pool = ReadDoScene(
        id: "a1-do-pool", level: .a1, kind: .sign,
        title: "Prices at the swimming pool", detail: "Which ticket do you need?", systemImage: "figure.pool.swim",
        content: """
        # Hallenbad Nord
        ## Eintritt
        Erwachsene | 4,50 €
        Kinder (6–17 Jahre) | 2,50 €
        Kinder unter 6 Jahren | frei
        Familienkarte (2 Erwachsene + 2 Kinder) | 11,00 €
        10er-Karte Erwachsene | 40,00 €
        ## Öffnungszeiten
        Montag | geschlossen
        Dienstag bis Freitag | 7:00 – 21:00
        Samstag und Sonntag | 9:00 – 18:00
        """,
        tasks: [
            ReadDoTask(prompt: "Your daughter is four. What does she pay?", answer: "unter 6"),
            ReadDoTask(prompt: "Two parents and two children: tap the cheapest ticket.", answer: "Familienkarte"),
            ReadDoTask(prompt: "Which day can't you swim?", answer: "geschlossen")
        ])

    static let a1TV = ReadDoScene(
        id: "a1-do-tv", level: .a1, kind: .tvGuide,
        title: "Tonight on TV", detail: "What do you want to watch?", systemImage: "tv.fill",
        content: """
        # Fernsehprogramm
        ## Heute, Samstag
        18:00 | Kochen mit Oma | Kochshow
        19:00 | Das Wetter
        19:30 | Tiere im Zoo | für Kinder
        20:00 | Nachrichten
        20:15 | Fußball: Deutschland – Spanien | live
        22:30 | Der Kommissar | Krimi
        """,
        tasks: [
            ReadDoTask(prompt: "You love football. When does the match start?", answer: "Fußball"),
            ReadDoTask(prompt: "Your children like animals. Tap their programme.", answer: "Tiere"),
            ReadDoTask(prompt: "Will it rain tomorrow? Tap where you find out.", answer: "Wetter")
        ])

    static let a1Cinema = ReadDoScene(
        id: "a1-do-cinema", level: .a1, kind: .schedule,
        title: "The cinema programme", detail: "Which film, when?", systemImage: "film.fill",
        content: """
        # Kino am Park
        ## Heute
        15:30 | Der kleine Bär | Saal 1 | ab 0 J.
        18:00 | Liebe in Paris | Saal 2 | ab 12 J.
        20:15 | Die Nacht | Saal 1 | ab 16 J.
        22:45 | Die Nacht | Saal 2 | ab 16 J.
        ---
        Dienstag ist Kinotag: Alle Karten kosten 6 €.
        """,
        tasks: [
            ReadDoTask(prompt: "You're going with your five-year-old son. Tap a film for him.", answer: "Der kleine Bär"),
            ReadDoTask(prompt: "You want to see \"Die Nacht\", but you work until 9 pm.", answer: "22:45"),
            ReadDoTask(prompt: "On which day are tickets cheaper?", answer: "Kinotag")
        ])
}
