//
//  ReadDoScenes+A1.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension ReadDoScenes {
    /// A1: things you meet in the first weeks: a bus stop, a bakery, a receipt.
    static let a1: [ReadDoScene] = [a1Bus, a1Bakery, a1Milk, a1Form, a1Receipt, a1Bins]

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

    static let a1Milk = ReadDoScene(
        id: "a1-do-milk", level: .a1, kind: .packaging,
        title: "A carton of milk", detail: "How long does it keep?", systemImage: "drop.fill",
        content: """
        # Frische Vollmilch
        3,8 % Fett · 1 Liter
        ## Haltbarkeit
        Mindestens haltbar bis: 28.11.
        Nach dem Öffnen im Kühlschrank lagern.
        Geöffnet in 3 Tagen verbrauchen.
        ## Herkunft
        Von Bauernhöfen aus Bayern
        """,
        tasks: [
            ReadDoTask(prompt: "How much fat is in the milk?", answer: "Fett"),
            ReadDoTask(prompt: "Until when is it good if it stays closed?", answer: "Mindestens haltbar"),
            ReadDoTask(prompt: "You opened it today. How long do you have to drink it?", answer: "3 Tagen")
        ])

    static let a1Form = ReadDoScene(
        id: "a1-do-form", level: .a1, kind: .form,
        title: "A form at the language school", detail: "Sign up for a course", systemImage: "list.clipboard.fill",
        content: """
        # Anmeldung – Sprachschule Lingua
        ## Ihre Daten
        Familienname ___
        Vorname ___
        Geburtsdatum ___
        Telefonnummer ___
        ## Kurs
        Deutsch A1 am Vormittag | Mo–Fr, 9–12 Uhr
        Deutsch A1 am Abend | Di + Do, 18–20:30 Uhr
        Unterschrift ___
        """,
        tasks: [
            ReadDoTask(prompt: "Where do you write your first name?", answer: "Vorname"),
            ReadDoTask(prompt: "Where does your birthday go?", answer: "Geburtsdatum"),
            ReadDoTask(prompt: "You work during the day. Tap the course that fits.", answer: "am Abend")
        ])

    static let a1Receipt = ReadDoScene(
        id: "a1-do-receipt", level: .a1, kind: .receipt,
        title: "A supermarket receipt", detail: "What did you pay?", systemImage: "cart.fill",
        content: """
        # FRISCHMARKT
        Hauptstraße 12, Köln
        ---
        Bananen | 1,49
        Brot | 2,29
        Käse | 3,19
        Wasser 6 x 1,5 l | 2,94
        Pfand | 1,50
        ---
        SUMME EUR | 11,41
        Bar | 20,00
        Rückgeld | 8,59
        Vielen Dank für Ihren Einkauf!
        """,
        tasks: [
            ReadDoTask(prompt: "How much was the cheese?", answer: "Käse"),
            ReadDoTask(prompt: "You pay a little extra for the bottles. Tap it.", answer: "Pfand"),
            ReadDoTask(prompt: "How much money did you get back?", answer: "Rückgeld")
        ])

    static let a1Bins = ReadDoScene(
        id: "a1-do-bins", level: .a1, kind: .binCalendar,
        title: "The bin calendar", detail: "Which bin goes out when?", systemImage: "trash.fill",
        content: """
        # Abfuhrkalender Dezember
        ## Lindenstraße
        Mo 1.12. | Restmüll
        Mi 3.12. | Gelber Sack
        Fr 5.12. | Biotonne
        Di 9.12. | Papier
        Mo 15.12. | Restmüll
        Bitte stellen Sie die Tonne bis 6 Uhr an die Straße.
        """,
        tasks: [
            ReadDoTask(prompt: "When is the paper collected?", answer: "Papier"),
            ReadDoTask(prompt: "When does the yellow bag go out?", answer: "Gelber Sack"),
            ReadDoTask(prompt: "By what time must the bin be on the street?", answer: "bis 6 Uhr")
        ])
}
