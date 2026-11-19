//
//  ReadDoScenes+B2.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension ReadDoScenes {
    /// B2: the paperwork of a settled life: a bank transfer, an electricity bill, a pay slip, a tenancy
    /// agreement. The scenes of the flat and the street are in `ReadDoScenes+B2Home.swift`.
    static let b2: [ReadDoScene] = [
        b2Airport, b2Parking, b2Label, b2Transfer, b2Hardware, b2Electricity, b2Medicine,
        b2Payslip, b2Bins, b2Insurance, b2Lease, b2ServiceCharges, b2Detour
    ]

    static let b2Airport = ReadDoScene(
        id: "b2-do-airport", level: .b2, kind: .departures,
        title: "The airport board", detail: "Is your flight on time?", systemImage: "airplane.departure",
        content: """
        # Flughafen Frankfurt – Abflug
        ## Terminal 1
        09:40 | LH 1402 | Wien | Gate A22 · Boarding
        09:55 | LH 902 | London | annulliert
        10:05 | EW 7751 | Palma | Gate B44 · neue Zeit 11:20
        10:15 | LH 220 | München | Gate A16 · Gate geschlossen
        Passagiere nach London wenden sich bitte an den Lufthansa-Schalter in Halle B.
        """,
        tasks: [
            ReadDoTask(prompt: "Your flight to Palma is late. Tap when it leaves now.", answer: "neue Zeit"),
            ReadDoTask(prompt: "Which flight is it already too late to get on?", answer: "Gate geschlossen"),
            ReadDoTask(prompt: "Your flight to London is cancelled. Where do you go?", answer: "Halle B")
        ])

    static let b2Detour = ReadDoScene(
        id: "b2-do-detour", level: .b2, kind: .sign,
        title: "A notice about road works", detail: "How do you get home?", systemImage: "exclamationmark.triangle.fill",
        content: """
        # Achtung Baustelle
        Vom 2. bis 20. Dezember ist die Kastanienallee zwischen Parkstraße und Marktplatz voll gesperrt.
        Die Umleitung für Autos führt über die Ringstraße.
        Fußgänger und Radfahrer können die Baustelle auf der Ostseite passieren.
        Die Buslinie 8 hält in dieser Zeit an der Ersatzhaltestelle Parkstraße.
        Anlieger erreichen ihre Garagen nur nachts von 20 bis 6 Uhr.
        Wir bitten um Ihr Verständnis. Ihr Tiefbauamt
        """,
        tasks: [
            ReadDoTask(prompt: "You're going by car. Which way do you drive?", answer: "Ringstraße"),
            ReadDoTask(prompt: "Where does bus 8 stop now?", answer: "Ersatzhaltestelle"),
            ReadDoTask(prompt: "You live on the street. When can you get to your garage?", answer: "Anlieger")
        ])

    static let b2Label = ReadDoScene(
        id: "b2-do-label", level: .b2, kind: .packaging,
        title: "Ingredients and allergens", detail: "Is it safe for your friend?", systemImage: "leaf.fill",
        content: """
        # Bio-Müsliriegel Haselnuss
        ## Zutaten
        Haferflocken*, Honig*, Haselnüsse* (18 %), Reissirup*, Sonnenblumenöl*, Salz
        *aus kontrolliert biologischem Anbau
        ## Nährwerte pro 100 g
        Energie | 1.920 kJ / 459 kcal
        Fett | 21 g
        davon gesättigte Fettsäuren | 2,4 g
        Zucker | 24 g
        ## Allergenhinweis
        Kann Spuren von Erdnüssen, Milch und Sesam enthalten.
        Trocken lagern und vor Wärme schützen.
        """,
        tasks: [
            ReadDoTask(prompt: "Your friend is allergic to peanuts. Tap the warning.", answer: "Erdnüssen"),
            ReadDoTask(prompt: "How much sugar is in 100 g?", answer: "Zucker"),
            ReadDoTask(prompt: "How should you keep the bars?", answer: "Trocken lagern")
        ])

    static let b2Transfer = ReadDoScene(
        id: "b2-do-transfer", level: .b2, kind: .form,
        title: "A bank transfer form", detail: "Pay your rent by hand", systemImage: "eurosign.circle.fill",
        content: """
        # SEPA-Überweisung
        Name des Empfängers ___
        IBAN des Empfängers ___
        BIC (nur bei Zahlungen ins Ausland) ___
        Betrag in Euro ___
        Verwendungszweck, z. B. Rechnungsnummer ___
        Name des Kontoinhabers ___
        IBAN des Kontoinhabers ___
        Datum, Unterschrift ___
        """,
        tasks: [
            ReadDoTask(prompt: "Where do you write your landlord's IBAN?", answer: "IBAN des Empfängers"),
            ReadDoTask(prompt: "Where do you write \u{201C}Miete Dezember\u{201D}?", answer: "Verwendungszweck"),
            ReadDoTask(prompt: "Which field can you leave empty when you pay a German bank?", answer: "BIC")
        ])

    static let b2Electricity = ReadDoScene(
        id: "b2-do-electricity", level: .b2, kind: .bill,
        title: "An electricity bill", detail: "Do you pay more or get money back?", systemImage: "bolt.fill",
        content: """
        # Jahresabrechnung Strom
        Zeitraum 01.01. bis 31.12.
        ## Verbrauch
        Zählerstand alt | 18.240 kWh
        Zählerstand neu | 20.890 kWh
        Ihr Verbrauch | 2.650 kWh
        ## Kosten
        Arbeitspreis 2.650 kWh × 0,32 € | 848,00
        Grundpreis 12 Monate | 144,00
        Gesamtkosten | 992,00
        Ihre Abschläge 12 × 85 € | 1.020,00
        Guthaben | 28,00
        Ihr neuer monatlicher Abschlag ab Februar: 82 €.
        """,
        tasks: [
            ReadDoTask(prompt: "How much electricity did you use this year?", answer: "Ihr Verbrauch"),
            ReadDoTask(prompt: "Do you pay extra or get money back? Tap it.", answer: "Guthaben"),
            ReadDoTask(prompt: "What will you pay each month from now on?", answer: "neuer monatlicher Abschlag")
        ])

    static let b2Payslip = ReadDoScene(
        id: "b2-do-payslip", level: .b2, kind: .payslip,
        title: "A pay slip", detail: "What's left after tax?", systemImage: "doc.text.fill",
        content: """
        # Gehaltsabrechnung Oktober
        Sara Haddad · Steuerklasse 1
        ## Bezüge
        Grundgehalt | 3.200,00
        Zuschlag Nachtarbeit | 180,00
        Gesamtbrutto | 3.380,00
        ## Abzüge
        Lohnsteuer | 412,58
        Krankenversicherung | 277,16
        Rentenversicherung | 314,34
        Arbeitslosen- und Pflegeversicherung | 107,32
        ---
        Auszahlungsbetrag (netto) | 2.268,60
        """,
        tasks: [
            ReadDoTask(prompt: "What does Sara earn before anything is taken off?", answer: "Gesamtbrutto"),
            ReadDoTask(prompt: "She worked some nights. Tap the extra money.", answer: "Nachtarbeit"),
            ReadDoTask(prompt: "What goes into her bank account?", answer: "Auszahlungsbetrag")
        ])
}
