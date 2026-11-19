//
//  ReadDoScenes+A1Papers.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension ReadDoScenes {
    // MARK: - A1 papers and packets: packaging, receipts, a ticket, forms, bins and a bill

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

    static let a1Pasta = ReadDoScene(
        id: "a1-do-pasta", level: .a1, kind: .packaging,
        title: "A packet of spaghetti", detail: "How do you cook it?", systemImage: "fork.knife.circle.fill",
        content: """
        # Spaghetti
        500 g
        ## Zubereitung
        Pro 100 g Nudeln 1 Liter Wasser kochen.
        Etwas Salz in das Wasser geben.
        Die Nudeln 9 Minuten kochen.
        Das Wasser abgießen. Guten Appetit!
        ## Zutaten
        Hartweizengrieß, Wasser
        """,
        tasks: [
            ReadDoTask(prompt: "How long do the spaghetti cook?", answer: "9 Minuten"),
            ReadDoTask(prompt: "How much is in the packet?", answer: "500 g"),
            ReadDoTask(prompt: "What do you put in the water?", answer: "Salz")
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

    static let a1Ticket = ReadDoScene(
        id: "a1-do-ticket", level: .a1, kind: .ticket,
        title: "A bus ticket", detail: "Is it still valid?", systemImage: "ticket.fill",
        content: """
        # Fahrkarte
        Einzelfahrt Erwachsene | 3,20 €
        Tarifzone | A
        Gekauft am | 19.11. um 08:14 Uhr
        Gültig | 90 Minuten
        Gültig bis | 19.11. um 09:44 Uhr
        ---
        Gute Fahrt!
        """,
        tasks: [
            ReadDoTask(prompt: "How much did the ticket cost?", answer: "3,20"),
            ReadDoTask(prompt: "How long can you ride with it?", answer: "90 Minuten"),
            ReadDoTask(prompt: "Until what time exactly is it valid?", answer: "Gültig bis")
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

    static let a1DoctorForm = ReadDoScene(
        id: "a1-do-doctor-form", level: .a1, kind: .form,
        title: "A form at the doctor's", detail: "Your first visit", systemImage: "stethoscope",
        content: """
        # Praxis Dr. Weber
        ## Patientenbogen
        Name, Vorname ___
        Geburtsdatum ___
        Adresse ___
        Krankenkasse ___
        Haben Sie Allergien? | ja · nein
        Nehmen Sie Medikamente? | ja · nein
        Datum, Unterschrift ___
        """,
        tasks: [
            ReadDoTask(prompt: "Where do you write your health insurance?", answer: "Krankenkasse"),
            ReadDoTask(prompt: "You can't take penicillin. Tap the question about it.", answer: "Allergien"),
            ReadDoTask(prompt: "Where do you sign?", answer: "Unterschrift")
        ])

    static let a1Bins = ReadDoScene(
        id: "a1-do-bins", level: .a1, kind: .binCalendar,
        title: "The bin calendar", detail: "Which bin goes out when?", systemImage: "trash.fill",
        content: """
        # Abfuhrkalender Dezember
        ## Lindenstraße
        Di 1.12. | Restmüll
        Do 3.12. | Gelber Sack
        Fr 4.12. | Biotonne
        Mi 9.12. | Papier
        Di 15.12. | Restmüll
        Fr 18.12. | Biotonne
        Bitte stellen Sie die Tonne bis 6 Uhr an die Straße.
        """,
        tasks: [
            ReadDoTask(prompt: "When is the paper collected?", answer: "Papier"),
            ReadDoTask(prompt: "When does the yellow bag go out?", answer: "Gelber Sack"),
            ReadDoTask(prompt: "By what time must the bin be on the street?", answer: "bis 6 Uhr")
        ])

    static let a1Bill = ReadDoScene(
        id: "a1-do-bill", level: .a1, kind: .bill,
        title: "A bill from the bike shop", detail: "What do you pay, and by when?", systemImage: "bicycle",
        content: """
        # Fahrrad Klinger
        Rechnung Nr. 2026-118
        Datum: 20.11.2026
        ---
        Reparatur Bremse | 25,00 €
        Neues Licht | 18,90 €
        Neuer Schlauch | 7,50 €
        ---
        Summe | 51,40 €
        Bitte zahlen Sie bis zum 4.12.2026.
        IBAN: DE12 3456 7890 1234 5678 90
        """,
        tasks: [
            ReadDoTask(prompt: "How much was the new light?", answer: "Licht"),
            ReadDoTask(prompt: "How much do you pay in total?", answer: "Summe"),
            ReadDoTask(prompt: "By when must you pay?", answer: "Bitte zahlen Sie")
        ])
}
