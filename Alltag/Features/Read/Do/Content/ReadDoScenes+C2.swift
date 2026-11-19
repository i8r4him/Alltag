//
//  ReadDoScenes+C2.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension ReadDoScenes {
    /// C2: the small print of German life, read as fast as a native: a train that
    /// splits, parking signs, hazard warnings, Elterngeld, a hotel bill, a
    /// tradesman's invoice, a pay slip with a company car, a tenancy agreement, a
    /// prescription, a TV guide, a doctor's hours and a saver ticket.
    static let c2: [ReadDoScene] = [
        c2SplitTrain, c2Parking, c2DrainCleaner, c2ParentalAllowance,
        c2Hotel, c2Plumber, c2CompanyCar, c2Tenancy,
        c2Prescription, c2TVGuide, c2Practice, c2SaverTicket
    ]

    static let c2SplitTrain = ReadDoScene(
        id: "c2-do-split-train", level: .c2, kind: .departures,
        title: "A train that splits", detail: "Which half goes where?", systemImage: "train.side.front.car",
        content: """
        # Abfahrt Hannover Hbf
        ## Gleis 9 · 14:31 · ICE 1047
        Ziel: Köln Hbf / Düsseldorf Hbf
        Zugteilung in Hamm (Westf): Wagen 31–39 fahren über Hagen und Wuppertal nach Köln Hbf.
        Wagen 21–29 fahren über Dortmund und Essen nach Düsseldorf Hbf.
        Bitte steigen Sie in den richtigen Zugteil ein; ein Wechsel während der Fahrt ist nicht möglich.
        Heute in umgekehrter Wagenreihung: Wagen 39 hält im Abschnitt A.
        ---
        Der Halt in Bielefeld entfällt heute. Reisende nach Bielefeld nutzen bitte den Regionalexpress um 14:46 von Gleis 12.
        """,
        tasks: [
            ReadDoTask(prompt: "You're going to Wuppertal. Tap the coaches you need.", answer: "Wagen 31–39"),
            ReadDoTask(prompt: "Where on the platform do you wait for coach 39 today?", answer: "Abschnitt A"),
            ReadDoTask(prompt: "Your friend wanted to get off in Bielefeld. Tap what she has to do.", answer: "Regionalexpress")
        ])

    static let c2Parking = ReadDoScene(
        id: "c2-do-parking", level: .c2, kind: .sign,
        title: "A parking sign with fine print", detail: "May you park here?", systemImage: "parkingsign",
        content: """
        # Parken
        ## Zusatzzeichen
        Mo–Fr 8–18 h | mit Parkscheibe 2 Std.
        Sa 8–14 h | mit Parkscheibe 1 Std.
        Bewohner mit Parkausweis Nr. 17 | frei
        Elektrofahrzeuge während des Ladevorgangs | frei, höchstens 4 Std.
        Ladezone, Lieferverkehr frei | Mo–Sa 6–10 h
        ---
        Fahrzeuge, die unberechtigt in der Ladezone stehen, werden kostenpflichtig abgeschleppt.
        """,
        tasks: [
            ReadDoTask(prompt: "It's Saturday morning. How long may you stay with a parking disc?", answer: "Sa 8–14 h"),
            ReadDoTask(prompt: "You live here and have the residents' permit. Tap your line.", answer: "Parkausweis Nr. 17"),
            ReadDoTask(prompt: "Your electric car is charging. Tap the limit.", answer: "Ladevorgangs")
        ])

    static let c2DrainCleaner = ReadDoScene(
        id: "c2-do-drain-cleaner", level: .c2, kind: .packaging,
        title: "A bottle of drain cleaner", detail: "The warnings on the back", systemImage: "exclamationmark.triangle.fill",
        content: """
        # Abflussfrei Power-Gel
        ## Gefahr
        Enthält: Natriumhydroxid, Natriumhypochlorit
        Verursacht schwere Verätzungen der Haut und schwere Augenschäden.
        Nicht zusammen mit anderen Produkten verwenden. Kann gefährliche Gase (Chlor) freisetzen.
        ## Sicherheitshinweise
        Schutzhandschuhe und Augenschutz tragen.
        BEI KONTAKT MIT DEN AUGEN: Einige Minuten lang behutsam mit Wasser spülen. Kontaktlinsen nach Möglichkeit entfernen.
        BEI VERSCHLUCKEN: Mund ausspülen. KEIN Erbrechen herbeiführen. Sofort Giftinformationszentrum oder Arzt anrufen.
        Darf nicht in die Hände von Kindern gelangen.
        ## Anwendung
        250 ml in den Abfluss geben, mindestens 15 Minuten, bei hartnäckiger Verstopfung über Nacht einwirken lassen.
        Anschließend mit reichlich heißem Wasser nachspülen.
        """,
        tasks: [
            ReadDoTask(prompt: "You want to add vinegar cleaner for extra power. Tap why you mustn't.",
                       answer: "Nicht zusammen mit anderen Produkten"),
            ReadDoTask(prompt: "A child has swallowed some. Tap what to do.", answer: "BEI VERSCHLUCKEN"),
            ReadDoTask(prompt: "The drain is badly blocked. How long should it work?", answer: "über Nacht")
        ])

    static let c2ParentalAllowance = ReadDoScene(
        id: "c2-do-parental-allowance", level: .c2, kind: .form,
        title: "Applying for Elterngeld", detail: "Months, hours and income", systemImage: "figure.and.child.holdinghands",
        content: """
        # Antrag auf Elterngeld
        ## Teil 3 – Bezugszeitraum
        Lebensmonate des Kindes, in denen Sie Basiselterngeld beziehen möchten ___
        Lebensmonate, in denen Sie ElterngeldPlus beziehen möchten ___
        Partnerschaftsbonus: Monate, in denen beide Elternteile gleichzeitig 24 bis 32 Wochenstunden arbeiten ___
        ## Teil 4 – Einkommen
        Einkommen aus nichtselbstständiger Arbeit in den zwölf Kalendermonaten vor der Geburt ___
        Haben Sie in diesem Zeitraum Mutterschaftsleistungen oder Krankengeld erhalten? ___
        ## Wichtiger Hinweis
        Elterngeld wird rückwirkend nur für die letzten drei Monate vor Eingang des Antrags gezahlt.
        """,
        tasks: [
            ReadDoTask(prompt: "You and your partner will both work 30 hours a week for a while. Where does that go?",
                       answer: "Partnerschaftsbonus"),
            ReadDoTask(prompt: "You were on sick pay before the birth. Tap where you say so.", answer: "Krankengeld"),
            ReadDoTask(prompt: "Your baby is five months old and you haven't applied yet. Tap what you risk.", answer: "rückwirkend")
        ])

    static let c2Hotel = ReadDoScene(
        id: "c2-do-hotel", level: .c2, kind: .receipt,
        title: "A hotel bill", detail: "Two VAT rates and a city tax", systemImage: "bed.double.fill",
        content: """
        # Hotel am Domplatz
        Rechnung Nr. 26-08814 · Herr Paul Ferreira · 14.10. bis 17.10.
        ## Leistungen
        3 × Doppelzimmer à 129,00 · MwSt. 7 % | 387,00
        Frühstück für 2 Personen, 3 × à 36,00 · MwSt. 19 % | 108,00
        Minibar · MwSt. 19 % | 11,50
        Kulturförderabgabe 5 % der Übernachtung · steuerfrei | 19,35
        ---
        Gesamtbetrag | 525,85
        abzüglich Anzahlung vom 02.09. | −129,00
        Offener Betrag | 396,85
        Bei beruflich bedingten Übernachtungen wird die Kulturförderabgabe gegen Nachweis des Arbeitgebers erstattet.
        """,
        tasks: [
            ReadDoTask(prompt: "How much did breakfast cost altogether?", answer: "Frühstück"),
            ReadDoTask(prompt: "Tap what you had already paid when you booked.", answer: "Anzahlung"),
            ReadDoTask(prompt: "You were there for work. Tap what you can get back.", answer: "erstattet")
        ])

    static let c2Plumber = ReadDoScene(
        id: "c2-do-plumber", level: .c2, kind: .bill,
        title: "The plumber's invoice", detail: "Discounts and tax", systemImage: "wrench.adjustable.fill",
        content: """
        # Rechnung Nr. 2026-1187
        Sanitär Krüger GmbH · Ihr Auftrag vom 03.11.2026: Austausch des Durchlauferhitzers
        ## Lohnkosten
        Arbeitszeit Monteur, 3,5 Std. à 68,00 € | 238,00
        Anfahrtspauschale | 35,00
        ## Materialkosten
        Durchlauferhitzer, elektronisch, 21 kW | 489,00
        Kleinmaterial | 24,50
        ---
        Nettobetrag | 786,50
        zzgl. 19 % MwSt. | 149,44
        Rechnungsbetrag | 935,94
        Zahlbar innerhalb von 14 Tagen. Bei Zahlung innerhalb von 7 Tagen gewähren wir 2 % Skonto.
        Enthaltene Arbeits- und Fahrtkosten im Sinne des § 35a EStG: 273,00 € zzgl. MwSt. = 324,87 €
        """,
        tasks: [
            ReadDoTask(prompt: "You pay within a week. Tap what you save.", answer: "Skonto"),
            ReadDoTask(prompt: "Which part can you claim on your tax return?", answer: "§ 35a"),
            ReadDoTask(prompt: "What did it cost just for the plumber to come out?", answer: "Anfahrtspauschale")
        ])
}
