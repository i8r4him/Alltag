//
//  ReadDoScenes+A2More.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension ReadDoScenes {
    static let a2Gym = ReadDoScene(
        id: "a2-do-gym", level: .a2, kind: .bill,
        title: "A bill from the gym", detail: "Why is it more this month?", systemImage: "dumbbell.fill",
        content: """
        # FitPoint Studio – Rechnung
        Rechnungsnummer: 2026-1187
        Datum: 2. November 2026
        ---
        Monatsbeitrag November | 29,90 €
        Getränke-Flatrate | 5,00 €
        Neue Mitgliedskarte (alte Karte verloren) | 10,00 €
        ---
        Gesamt | 44,90 €
        Bitte überweisen Sie den Betrag bis zum 16. November.
        IBAN: DE89 3704 0044 0532 0130 00
        Verwendungszweck: Ihre Rechnungsnummer
        Ihr Vertrag läuft bis 31. März 2027. Kündigung bis 4 Wochen vor dem Ende.
        """,
        tasks: [
            ReadDoTask(prompt: "Why do you pay 10 euros more this month?", answer: "verloren"),
            ReadDoTask(prompt: "By when must you pay?", answer: "bis zum 16. November"),
            ReadDoTask(prompt: "Tap the number you write as the reference for the transfer.", answer: "2026-1187")
        ])

    static let a2Concert = ReadDoScene(
        id: "a2-do-concert", level: .a2, kind: .ticket,
        title: "A concert ticket", detail: "When can you go in?", systemImage: "ticket.fill",
        content: """
        # Lina Sommer – Live 2026
        Mittwoch, 9. Dezember 2026
        Einlass: 19:00 Uhr | Beginn: 20:00 Uhr
        Stadthalle, Am Ring 5
        ---
        Block C | Reihe 12 | Platz 7
        Preis | 49,90 € inkl. Gebühren
        ---
        Mit diesem Ticket fahren Sie mit Bus und Bahn kostenlos zum Konzert und zurück.
        Bitte keine großen Taschen und keine Getränke mitbringen.
        Sie können das Ticket nicht zurückgeben, nur wenn das Konzert ausfällt.
        """,
        tasks: [
            ReadDoTask(prompt: "When are the doors open?", answer: "Einlass"),
            ReadDoTask(prompt: "Where do you sit? Tap your seat.", answer: "Platz 7"),
            ReadDoTask(prompt: "How can you get there without paying for a ticket?", answer: "Bus und Bahn")
        ])

    static let a2Paediatrician = ReadDoScene(
        id: "a2-do-paediatrician", level: .a2, kind: .schedule,
        title: "The children's doctor", detail: "When can you come?", systemImage: "stethoscope",
        content: """
        # Kinderarztpraxis Dr. Wagner
        ## Sprechzeiten
        Mo, Di, Do | 8:00–12:00 und 15:00–18:00
        Mi, Fr | 8:00–13:00
        ## Akutsprechstunde ohne Termin
        Mo–Fr | 8:00–9:30
        ## Impfsprechstunde
        Do | 14:00–15:00, nur mit Termin
        Termine bitte online oder telefonisch: 0221 467 30 30
        Außerhalb der Sprechzeiten: Ärztlicher Bereitschaftsdienst 116 117
        """,
        tasks: [
            ReadDoTask(prompt: "Your child has a fever. When can you come without an appointment?", answer: "8:00–9:30"),
            ReadDoTask(prompt: "It's Wednesday. Tap the hours the practice is open today.", answer: "Mi, Fr"),
            ReadDoTask(prompt: "It's Saturday night and your child is ill. Which number do you call?", answer: "116 117")
        ])

    static let a2Prescription = ReadDoScene(
        id: "a2-do-prescription", level: .a2, kind: .prescription,
        title: "A prescription", detail: "How do you take your medicine?", systemImage: "pills.fill",
        content: """
        # Kassenrezept
        Krankenkasse | BKK Mitte
        Name, Vorname | Haddad, Amira
        geb. am | 12.04.1994
        ---
        Amoxicillin 1000 mg | 20 Tabletten
        Dosierung: 2-mal täglich 1 Tablette, morgens und abends
        Ibuprofen 600 mg | 20 Tabletten
        Dosierung: bei Bedarf 1 Tablette, höchstens 3 am Tag
        ---
        Datum | 23.11.2026
        Arzt | Dr. med. Petra Lang, Allgemeinmedizin
        """,
        tasks: [
            ReadDoTask(prompt: "How often do you take the antibiotic, Amoxicillin?", answer: "2-mal täglich"),
            ReadDoTask(prompt: "Which medicine do you take only when you need it?", answer: "bei Bedarf"),
            ReadDoTask(prompt: "Who wrote the prescription?", answer: "Dr. med.")
        ])

    static let a2TV = ReadDoScene(
        id: "a2-do-tv", level: .a2, kind: .tvGuide,
        title: "Saturday evening on TV", detail: "What's on tonight?", systemImage: "tv.fill",
        content: """
        # Fernsehprogramm – Samstag
        ## Das Erste
        18:00 | Sportschau – Fußball-Bundesliga
        20:00 | Tagesschau – Nachrichten
        20:15 | Mord am Bodensee – Krimi
        ## ZDF
        19:00 | heute – Nachrichten
        19:25 | Unsere Gärten – Reportage
        20:15 | Die große Weihnachtsshow – Musik und Gäste
        ## KiKA
        18:50 | Unser Sandmännchen
        19:00 | Die Waldbande – Serie für Kinder
        """,
        tasks: [
            ReadDoTask(prompt: "You want to see the football results. Tap the programme.", answer: "Sportschau"),
            ReadDoTask(prompt: "Your son wants a series for children at 7 o'clock. Tap it.", answer: "Serie für Kinder"),
            ReadDoTask(prompt: "You love crime films. Which one is on tonight?", answer: "Krimi")
        ])

    static let a2Payslip = ReadDoScene(
        id: "a2-do-payslip", level: .a2, kind: .payslip,
        title: "A pay slip from a minijob", detail: "How much did you earn?", systemImage: "eurosign.circle.fill",
        content: """
        # Café Morgenrot – Lohnabrechnung Oktober 2026
        Mitarbeiterin | Amira Haddad
        Beschäftigung | Minijob
        ---
        Arbeitsstunden | 40
        Stundenlohn | 13,90 €
        Bruttolohn | 556,00 €
        Abzüge | 0,00 €
        ---
        Auszahlung | 556,00 €
        Überweisung auf Ihr Konto am 3. November.
        Urlaub: noch 4 Tage
        """,
        tasks: [
            ReadDoTask(prompt: "How many hours did Amira work in October?", answer: "Arbeitsstunden"),
            ReadDoTask(prompt: "How much money comes to her account?", answer: "Auszahlung"),
            ReadDoTask(prompt: "How many days of holiday does she have left?", answer: "noch 4 Tage")
        ])
}
