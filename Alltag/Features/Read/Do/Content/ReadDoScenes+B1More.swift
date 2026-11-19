//
//  ReadDoScenes+B1More.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension ReadDoScenes {
    static let b1Bins = ReadDoScene(
        id: "b1-do-bins", level: .b1, kind: .binCalendar,
        title: "The bin calendar", detail: "Christmas changes everything", systemImage: "trash.fill",
        content: """
        # Abfuhrkalender Dezember
        Gartenstraße 1–40
        ## Termine
        Restmüll (grau) | Do 3.12. | Do 17.12. | Do 31.12.
        Bioabfall (braun) | Fr 4.12. | Fr 11.12. | Fr 18.12. | Mo 28.12.
        Gelbe Tonne | Di 15.12. | Di 29.12.
        Papier (blau) | Mi 9.12.
        ---
        Wegen der Feiertage wird der Bioabfall in der Weihnachtswoche erst am Montag abgeholt.
        Weihnachtsbäume holen wir am Samstag, 9. Januar, ab. Bitte ohne Schmuck an den Straßenrand legen.
        Sperrmüll nur nach Anmeldung, zweimal im Jahr kostenlos.
        Stellen Sie die Tonnen am Abholtag bis 6 Uhr an die Straße.
        """,
        tasks: [
            ReadDoTask(prompt: "Your box of old newspapers is full. When is the blue bin emptied?", answer: "Papier"),
            ReadDoTask(prompt: "The brown bin isn't emptied on Friday in Christmas week. Tap why.", answer: "Feiertage"),
            ReadDoTask(prompt: "You want to get rid of an old sofa. Tap what you need to do.", answer: "Sperrmüll")
        ])

    static let b1Payslip = ReadDoScene(
        id: "b1-do-payslip", level: .b1, kind: .payslip,
        title: "Your pay slip", detail: "From gross to net", systemImage: "eurosign.circle.fill",
        content: """
        # Gehaltsabrechnung Oktober
        Lea Wagner · Personalnummer 1083
        ## Bezüge
        Grundgehalt | 2.900,00
        Schichtzulage | 180,00
        Gesamtbrutto | 3.080,00
        ## Abzüge
        Lohnsteuer | -356,25
        Krankenversicherung | -267,96
        Pflegeversicherung | -55,44
        Rentenversicherung | -286,44
        Arbeitslosenversicherung | -40,04
        ---
        Auszahlungsbetrag | 2.073,87
        Resturlaub | 14 Tage
        """,
        tasks: [
            ReadDoTask(prompt: "How much is actually paid into your account?", answer: "Auszahlungsbetrag"),
            ReadDoTask(prompt: "How much do you pay towards your pension?", answer: "Rentenversicherung"),
            ReadDoTask(prompt: "How many days of holiday do you have left?", answer: "Resturlaub")
        ])

    static let b1Bus = ReadDoScene(
        id: "b1-do-bus", level: .b1, kind: .schedule,
        title: "A bus timetable", detail: "The last bus to the hospital", systemImage: "bus.fill",
        content: """
        # Linie 34 · Rathaus → Klinikum
        ## Montag bis Freitag
        05:48 | 06:18 | dann alle 15 Minuten | bis 20:03
        20:33 | 21:33 | 22:33 R
        ## Samstag
        07:12 | dann alle 30 Minuten | bis 19:42 | 20:42 R
        ## Sonn- und Feiertage
        09:12 | dann jede Stunde | bis 21:12 R
        ---
        R = Rufbus: bitte mindestens 30 Minuten vorher unter 0800 340 340 bestellen.
        Tickets im Bus nur mit Karte oder Handy, kein Bargeld.
        """,
        tasks: [
            ReadDoTask(prompt: "Your night shift at the hospital starts at 23:00 on a Wednesday. Tap the last bus you can take.",
                       answer: "22:33"),
            ReadDoTask(prompt: "That bus only comes if you ask for it. Tap how.", answer: "Rufbus"),
            ReadDoTask(prompt: "You only have cash with you. Tap the problem.", answer: "kein Bargeld")
        ])

    static let b1Gym = ReadDoScene(
        id: "b1-do-gym", level: .b1, kind: .contract,
        title: "A gym contract", detail: "Read it before you sign", systemImage: "dumbbell.fill",
        content: """
        # Mitgliedsvertrag Fitnessstudio
        Mitglied: Daniel Kowalski
        ## Tarif
        Tarif Basic | 24,90 € im Monat
        Einmalige Aufnahmegebühr | 29,00 €
        Mindestlaufzeit | 12 Monate
        ## Kündigung
        Nach der Mindestlaufzeit verlängert sich der Vertrag auf unbestimmte Zeit. \
        Er kann dann mit einer Frist von einem Monat gekündigt werden.
        Die Kündigung muss in Textform erfolgen, zum Beispiel per E-Mail.
        ## Pause
        Bei Krankheit oder Schwangerschaft kann die Mitgliedschaft mit ärztlichem Attest pausiert werden.
        ---
        Ort, Datum, Unterschrift ___
        """,
        tasks: [
            ReadDoTask(prompt: "What do you pay only once, at the start?", answer: "Aufnahmegebühr"),
            ReadDoTask(prompt: "Can you cancel by phone? Tap how you must cancel.", answer: "Textform"),
            ReadDoTask(prompt: "You break your leg and can't train for two months. Tap what you can do.", answer: "Attest")
        ])

    static let b1Ticket = ReadDoScene(
        id: "b1-do-ticket", level: .b1, kind: .ticket,
        title: "A train ticket", detail: "Cologne to Munich", systemImage: "ticket.fill",
        content: """
        # Fahrkarte · Flexpreis
        Hinfahrt am 21.11.2026
        ## Verbindung
        Köln Hbf → München Hbf | ab 08:54 | an 13:28
        ICE 527 | Wagen 7 | Platz 45, Fenster
        ## Fahrgast
        1 Erwachsener, 2. Klasse | BahnCard 25
        Preis | 96,40 €
        ---
        Keine Zugbindung. Gültig am Reisetag und am Folgetag bis 10 Uhr.
        Bitte zeigen Sie bei der Kontrolle auch Ihre BahnCard und einen Ausweis vor.
        Bis einschließlich 1 Tag vor dem Reisetag kostenlos stornierbar.
        """,
        tasks: [
            ReadDoTask(prompt: "Where is your seat?", answer: "Platz 45"),
            ReadDoTask(prompt: "You miss your train. Tap what says you can take a later one.", answer: "Keine Zugbindung"),
            ReadDoTask(prompt: "What else must you show the conductor?", answer: "Ausweis")
        ])

    static let b1Prescription = ReadDoScene(
        id: "b1-do-prescription", level: .b1, kind: .prescription,
        title: "A prescription", detail: "Antibiotics from the doctor", systemImage: "pills.fill",
        content: """
        # Rezept
        Krankenkasse | Gesundheitskasse Nord
        Versicherter | Hoffmann, Jan · geb. 14.05.1988
        Gebühr pflichtig | ✕
        ## Verordnung
        Amoxicillin 1000 mg, 20 Filmtabletten | 1-1-1
        Ibuprofen 600 mg, 20 Filmtabletten | bei Bedarf, höchstens 3 am Tag
        ---
        Ärztin | Dr. med. Sara Brandt, Allgemeinmedizin
        Ausgestellt am | 18.11.2026
        Gültig 28 Tage ab Ausstellung.
        Hinweis der Ärztin: Das Antibiotikum bis zum Ende einnehmen, auch wenn es Ihnen besser geht.
        """,
        tasks: [
            ReadDoTask(prompt: "How many times a day do you take the antibiotic?", answer: "1-1-1"),
            ReadDoTask(prompt: "How long is the prescription valid?", answer: "Gültig 28 Tage"),
            ReadDoTask(prompt: "After three days you feel better. Tap what the doctor says.", answer: "bis zum Ende")
        ])
}
