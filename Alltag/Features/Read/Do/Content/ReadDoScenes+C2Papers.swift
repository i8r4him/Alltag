//
//  ReadDoScenes+C2Papers.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension ReadDoScenes {
    static let c2CompanyCar = ReadDoScene(
        id: "c2-do-company-car", level: .c2, kind: .payslip,
        title: "A pay slip with a company car", detail: "Taxed on money you never see", systemImage: "car.fill",
        content: """
        # Entgeltabrechnung Oktober 2026
        Mira Hoffmann · Steuerklasse 1 · Kirchensteuer 9 %
        ## Bezüge
        Gehalt | 5.200,00
        Geldwerter Vorteil Dienstwagen, 1 % von 48.000 € | 480,00
        Fahrten Wohnung – Arbeit, 0,03 % × 22 km | 316,80
        Entgeltumwandlung betriebliche Altersversorgung | −200,00
        Steuer- und SV-Brutto | 5.796,80
        ## Abzüge
        Lohnsteuer | 1.287,41
        Kirchensteuer | 115,87
        Sozialversicherung | 1.257,90
        Abzug Sachbezug Dienstwagen | −796,80
        ---
        Auszahlungsbetrag | 2.338,82
        """,
        tasks: [
            ReadDoTask(prompt: "She may use the company car privately. Tap where that is counted as pay.",
                       answer: "Geldwerter Vorteil"),
            ReadDoTask(prompt: "200 euros go into her company pension. Tap the line.", answer: "Entgeltumwandlung"),
            ReadDoTask(prompt: "How much reaches her bank account?", answer: "Auszahlungsbetrag")
        ])

    static let c2Tenancy = ReadDoScene(
        id: "c2-do-tenancy", level: .c2, kind: .contract,
        title: "A tenancy agreement", detail: "The clauses that matter", systemImage: "signature",
        content: """
        # Mietvertrag für Wohnraum
        ## § 3 Miete
        Die Nettokaltmiete beträgt 1.240 Euro. Sie erhöht sich als Staffelmiete jeweils zum 1. Januar um 35 Euro, erstmals 2028.
        Während der Laufzeit der Staffelmiete sind Erhöhungen bis zur ortsüblichen Vergleichsmiete ausgeschlossen.
        ## § 4 Mietsicherheit
        Der Mieter leistet eine Kaution in Höhe von drei Nettokaltmieten. \
        Er ist berechtigt, sie in drei gleichen monatlichen Teilzahlungen zu erbringen.
        ## § 5 Kündigung
        Beide Parteien verzichten für die Dauer von zwei Jahren ab Vertragsschluss auf ihr Recht zur ordentlichen Kündigung.
        ## § 9 Schönheitsreparaturen
        Die Wohnung wird unrenoviert übergeben. Schönheitsreparaturen trägt der Vermieter.
        ## § 12 Tierhaltung
        Kleintiere dürfen gehalten werden; Hunde und Katzen nur mit vorheriger schriftlicher Zustimmung des Vermieters.
        """,
        tasks: [
            ReadDoTask(prompt: "Can the landlord raise the rent to the local average in between? Tap the answer.",
                       answer: "ortsüblichen Vergleichsmiete"),
            ReadDoTask(prompt: "You'd like to pay the deposit bit by bit. Tap where it says you may.", answer: "Teilzahlungen"),
            ReadDoTask(prompt: "You want to adopt a cat. Tap what you need.", answer: "Hunde und Katzen")
        ])

    static let c2Prescription = ReadDoScene(
        id: "c2-do-prescription", level: .c2, kind: .prescription,
        title: "A prescription from your GP", detail: "What the boxes mean", systemImage: "cross.case.fill",
        content: """
        # Kassenrezept
        Techniker Krankenkasse | Versicherten-Nr. K482915736
        Kowalski, Marta | geb. 12.08.1984
        Gebühr frei | –
        Geb.-pfl. | ✕
        noctu | –
        ## Rp.
        Amoxicillin 1000 mg, 20 Filmtabletten N1 | aut idem ✕ | 1-0-1 über 10 Tage
        Ibuprofen 600 mg, 20 Filmtabletten N1 | bei Bedarf bis 3 × täglich nach dem Essen
        ---
        19.11.2026 | Dr. med. Henrike Sommer, Fachärztin für Allgemeinmedizin, Regensburg
        """,
        tasks: [
            ReadDoTask(prompt: "Which medicine must the chemist hand over exactly as written, with no cheaper copy?",
                       answer: "aut idem"),
            ReadDoTask(prompt: "How often a day do you take the antibiotic?", answer: "1-0-1"),
            ReadDoTask(prompt: "Do you pay the prescription charge? Tap the box that says so.", answer: "Geb.-pfl.")
        ])

    static let c2TVGuide = ReadDoScene(
        id: "c2-do-tv-guide", level: .c2, kind: .tvGuide,
        title: "Tonight on TV", detail: "Abbreviations in the listings", systemImage: "tv.fill",
        content: """
        # Fernsehprogramm · Freitag, 4. Dezember
        ## 20:15
        Das Erste | Tatort: Schattenspiel | Krimi · UT · AD
        ZDF | Die Toten vom Kreidefelsen | Krimi · Wh. vom 12.03.
        arte | Les Jours d'automne | Spielfilm, F 2025 · OmU
        ## 21:45
        3sat | Mainzer Kabarettnacht | live
        ## 23:30
        Das Erste | Grenzgänger | Thriller · FSK 16
        ZDF | Lesezeichen | Büchergespräch · Wh. am So 10:30
        """,
        tasks: [
            ReadDoTask(prompt: "You want a French film with German subtitles. Tap it.", answer: "OmU"),
            ReadDoTask(prompt: "Your grandfather is blind. Which film has audio description?", answer: "UT · AD"),
            ReadDoTask(prompt: "You'll miss the book programme tonight. When can you still see it?", answer: "Wh. am So")
        ])

    static let c2Practice = ReadDoScene(
        id: "c2-do-practice", level: .c2, kind: .schedule,
        title: "Your GP's surgery hours", detail: "When and how to get seen", systemImage: "stethoscope",
        content: """
        # Hausarztpraxis Dr. Yilmaz & Dr. Berger
        ## Sprechzeiten
        Mo, Di, Do | 8–12 Uhr und 15–18 Uhr
        Mi, Fr | 8–13 Uhr
        Akutsprechstunde ohne Termin | täglich 8–9 Uhr
        Videosprechstunde | Di 18–19 Uhr, nach Vereinbarung
        ## Telefon und Anliegen
        Telefonisch erreichbar | Mo–Fr 9–11 Uhr
        Folgerezepte und Überweisungen | nur über die Praxis-App
        ## Urlaub
        22.12. bis 02.01. | Vertretung: Praxis Dr. Hahn, Bahnhofstraße 8
        In lebensbedrohlichen Notfällen 112, außerhalb der Sprechzeiten ärztlicher Bereitschaftsdienst unter 116 117.
        """,
        tasks: [
            ReadDoTask(prompt: "You woke up with a fever and have no appointment. When can you just come in?",
                       answer: "Akutsprechstunde"),
            ReadDoTask(prompt: "You need more of your usual tablets. How do you order them?", answer: "Praxis-App"),
            ReadDoTask(prompt: "It's 27 December and you need a doctor. Tap where you go.", answer: "Vertretung")
        ])

    static let c2SaverTicket = ReadDoScene(
        id: "c2-do-saver-ticket", level: .c2, kind: .ticket,
        title: "A saver ticket", detail: "Bound to one train, unless…", systemImage: "ticket.fill",
        content: """
        # Online-Ticket · Sparpreis
        ## Hinfahrt am 06.12.2026
        Frankfurt (Main) Hbf → München Hbf | ICE 523 | ab 10:50 | an 14:02
        Zugbindung: nur gültig im angegebenen Zug
        Wagen 7, Platz 64 | Fenster | Ruhebereich
        ## Fahrkartenkontrolle
        Gültig nur zusammen mit einem amtlichen Lichtbildausweis des Reisenden.
        ## Umtausch und Erstattung
        Bis einen Tag vor dem ersten Geltungstag gegen ein Entgelt von 10 Euro, danach ausgeschlossen.
        Ist am Zielort eine Verspätung von mindestens 20 Minuten zu erwarten, ist die Zugbindung aufgehoben.
        """,
        tasks: [
            ReadDoTask(prompt: "Your train is expected to be 25 minutes late. May you take another one? Tap the answer.",
                       answer: "Zugbindung aufgehoben"),
            ReadDoTask(prompt: "You cancel the trip on 4 December. Tap what it costs.", answer: "Entgelt von 10 Euro"),
            ReadDoTask(prompt: "The conductor checks your ticket. What else must you show?", answer: "Lichtbildausweis")
        ])
}
