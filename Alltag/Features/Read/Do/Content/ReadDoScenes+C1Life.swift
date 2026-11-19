//
//  ReadDoScenes+C1Life.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension ReadDoScenes {
    static let c1Contract = ReadDoScene(
        id: "c1-do-contract", level: .c1, kind: .contract,
        title: "Your new rental contract", detail: "The small print before you sign", systemImage: "signature",
        content: """
        # Mietvertrag über Wohnraum
        ## § 2 Mietdauer
        Das Mietverhältnis beginnt am 1. Februar 2027 und läuft auf unbestimmte Zeit.
        ## § 3 Miete und Nebenkosten
        Nettokaltmiete | 940,00 €
        Vorauszahlung Betriebskosten | 210,00 €
        Vorauszahlung Heizkosten | 95,00 €
        Die Nettokaltmiete erhöht sich zum 1. Januar 2028 auf 968,20 € und zum 1. Januar 2029 auf 997,25 € (Staffelmiete).
        ## § 4 Mietsicherheit
        Die Kaution beträgt drei Nettokaltmieten und kann in drei gleichen monatlichen Raten gezahlt werden.
        ## § 8 Schönheitsreparaturen
        Die Wohnung wird unrenoviert übergeben; der Mieter ist bei Auszug nicht zur Renovierung verpflichtet.
        ## § 12 Tierhaltung
        Kleintiere sind erlaubt. Für Hunde und Katzen ist vorher die Zustimmung des Vermieters einzuholen.
        """,
        tasks: [
            ReadDoTask(prompt: "How much will the basic rent be in 2028?", answer: "968,20 €"),
            ReadDoTask(prompt: "You'd like to get a cat. Tap what you have to do first.", answer: "Zustimmung des Vermieters"),
            ReadDoTask(prompt: "Do you have to repaint when you move out? Tap the answer.", answer: "nicht zur Renovierung")
        ])

    static let c1TVGuide = ReadDoScene(
        id: "c1-do-tv-guide", level: .c1, kind: .tvGuide,
        title: "Tonight on TV", detail: "Films, repeats and subtitles", systemImage: "play.tv.fill",
        content: """
        # Heute Abend · Freitag, 20. November
        20:15 | Das Erste | Tatort: Schattenspiel (Krimi, Wdh. von 2024)
        20:15 | arte | Das Licht über Lissabon (Spielfilm, Portugal 2025, OmU)
        20:15 | ZDF | Die Satire-Runde (Kabarett, live)
        21:45 | 3sat | Wem gehört die Stadt? (Dokumentation über die Wohnungsnot)
        22:15 | ZDF | Spätnachrichten (mit Gebärdensprache im Livestream)
        23:30 | Das Erste | Der Sommer am See (Spielfilm, als Hörfilm mit Audiodeskription)
        """,
        tasks: [
            ReadDoTask(prompt: "You want a film in its own language with German subtitles. Tap it.", answer: "OmU"),
            ReadDoTask(prompt: "You've probably seen this crime drama before. How can you tell?", answer: "Wdh."),
            ReadDoTask(prompt: "Your grandfather is blind. Which film has a version made for him?", answer: "Hörfilm")
        ])

    static let c1Ticket = ReadDoScene(
        id: "c1-do-ticket", level: .c1, kind: .ticket,
        title: "A saver ticket", detail: "Are you bound to one train?", systemImage: "ticket.fill",
        content: """
        # Online-Ticket
        ## Sparpreis · 2. Klasse · 1 Erwachsener
        Hinfahrt am 18.12.2026
        Köln Hbf → München Hbf
        ab 09:55 | ICE 527 | an 14:32
        Zugbindung: Das Ticket gilt nur im angegebenen Zug.
        Ist absehbar, dass Sie Ihr Ziel mit mindestens 20 Minuten Verspätung erreichen, ist die Zugbindung aufgehoben.
        Umtausch und Erstattung bis einen Tag vor dem Geltungstag gegen ein Entgelt von 10 €, danach ausgeschlossen.
        Inklusive City-Ticket: Bus und Bahn am Zielort sind im Preis enthalten.
        Gesamtpreis | 49,99 €
        Nur gültig mit dem bei der Buchung angegebenen Ausweis.
        """,
        tasks: [
            ReadDoTask(prompt: "Your train will be half an hour late. May you take another one? Tap the rule.",
                       answer: "mindestens 20 Minuten"),
            ReadDoTask(prompt: "Your plans change two days before. Tap what you can do and what it costs.", answer: "Entgelt von 10 €"),
            ReadDoTask(prompt: "In Munich you take the underground to your hotel. Do you need another ticket?", answer: "City-Ticket")
        ])

    static let c1Bins = ReadDoScene(
        id: "c1-do-bins", level: .c1, kind: .binCalendar,
        title: "The bin calendar's small print", detail: "Holidays, Christmas trees and old devices", systemImage: "calendar",
        content: """
        # Abfallkalender Januar 2027
        ## Bezirk Süd
        Sa 2.1. | Biotonne (statt Fr 1.1.)
        Di 5.1. | Restmüll
        Do 7.1. | Gelbe Tonne
        Mo 11.1. | Weihnachtsbäume
        Fr 15.1. | Papier
        ## Hinweise
        Fällt ein Abholtag auf einen Feiertag, wird die Leerung am darauffolgenden Werktag nachgeholt.
        Weihnachtsbäume bitte ohne Schmuck, Lametta und Ständer bis 6 Uhr an den Straßenrand legen.
        Sperrmüll wird nur nach Anmeldung abgeholt, online oder telefonisch, spätestens zehn Tage vorher.
        Elektrogeräte gehören nicht in den Sperrmüll; geben Sie sie kostenlos am Wertstoffhof ab.
        """,
        tasks: [
            ReadDoTask(prompt: "New Year's Day is a holiday. Tap the day the organic bin comes instead.", answer: "statt Fr 1.1."),
            ReadDoTask(prompt: "What do you have to take off your Christmas tree? Tap it.", answer: "Lametta"),
            ReadDoTask(prompt: "Your old printer is broken. Where does it go?", answer: "Wertstoffhof")
        ])

    static let c1Schedule = ReadDoScene(
        id: "c1-do-schedule", level: .c1, kind: .schedule,
        title: "Your GP's opening hours", detail: "Over Christmas", systemImage: "stethoscope",
        content: """
        # Hausarztpraxis Dr. Weber und Dr. Aydın
        ## Sprechzeiten
        Mo, Di, Do | 8–12 Uhr | 15–18 Uhr
        Mi, Fr | 8–13 Uhr | nachmittags geschlossen
        Akutsprechstunde ohne Termin | täglich 8–9 Uhr
        ## Praxisurlaub vom 23.12. bis 3.1.
        Vertretung: Praxis Dr. Lenz, Kaiserstraße 12, nach telefonischer Anmeldung
        Rezepte und Überweisungen bestellen Sie bitte bis zum 22.12. über unsere Website.
        Außerhalb der Sprechzeiten: ärztlicher Bereitschaftsdienst unter 116 117
        Bei Lebensgefahr wählen Sie sofort den Notruf 112.
        """,
        tasks: [
            ReadDoTask(prompt: "You wake up ill on a Wednesday and have no appointment. When can you go?", answer: "Akutsprechstunde"),
            ReadDoTask(prompt: "It's 28 December and you need to see a doctor. Tap where to go.", answer: "Vertretung"),
            ReadDoTask(prompt: "It's Saturday and you need a doctor, but it isn't an emergency. Who do you call?",
                       answer: "Bereitschaftsdienst")
        ])

    static let c1Prescription = ReadDoScene(
        id: "c1-do-prescription", level: .c1, kind: .prescription,
        title: "A prescription from your doctor", detail: "What the boxes say", systemImage: "cross.case.fill",
        content: """
        # Kassenrezept
        Krankenkasse | BKK Rheinufer
        Versicherte Person | Okafor, Chidi · geb. 14.03.1991
        ## Gebühren
        Gebühr frei ☐ | Gebührenpflichtig ☒ | noctu ☐
        ## Rp. (Verordnung)
        aut idem ☒ | Levothyroxin 75 µg, 100 Tbl., N3, morgens nüchtern 1 Tbl.
        aut idem ☐ | Ibuprofen 600 mg, 20 Tbl., N1, bei Bedarf 1-0-1
        Ausstellungsdatum | 16.11.2026
        Einzulösen innerhalb von 28 Tagen nach Ausstellung.
        Unterschrift und Stempel der Praxis
        """,
        tasks: [
            ReadDoTask(prompt: "Do you have to pay a share at the chemist's? Tap the box that says so.", answer: "Gebührenpflichtig ☒"),
            ReadDoTask(prompt: "How should you take the thyroid tablets?", answer: "morgens nüchtern"),
            ReadDoTask(prompt: "How long do you have to take this to a chemist's?", answer: "innerhalb von 28 Tagen")
        ])

    static let c1ChemistReceipt = ReadDoScene(
        id: "c1-do-chemist-receipt", level: .c1, kind: .receipt,
        title: "A receipt from the chemist's", detail: "What did your health insurance pay?", systemImage: "eurosign.circle",
        content: """
        # Linden-Apotheke
        Bahnhofstraße 41, Bonn
        ---
        ## Kassenrezept
        Amoxicillin 1000 mg, 20 St. | 13,95
        davon Ihre Zuzahlung | 5,00
        ## Ohne Rezept, selbst bezahlt
        Nasenspray 15 ml | 4,49
        Halstabletten 24 St. | 7,98
        ---
        Ihr Anteil gesamt | 17,47
        EC-Karte | 17,47
        Zuzahlungen bitte aufbewahren: Wer die Belastungsgrenze erreicht, kann sich für den Rest des Jahres befreien lassen.
        """,
        tasks: [
            ReadDoTask(prompt: "How much of the antibiotic did you pay yourself?", answer: "Ihre Zuzahlung"),
            ReadDoTask(prompt: "Your health insurance paid nothing for some things. Tap the heading over them.", answer: "selbst bezahlt"),
            ReadDoTask(prompt: "Why should you keep this receipt?", answer: "Belastungsgrenze")
        ])

    static let c1Plumber = ReadDoScene(
        id: "c1-do-plumber", level: .c1, kind: .bill,
        title: "A plumber's bill", detail: "A discount and a tax break", systemImage: "wrench.and.screwdriver.fill",
        content: """
        # Rechnung Nr. 2026-1184
        Haustechnik Schäfer GmbH · 12.11.2026
        Leistung: Austausch des Spülkastens im Gäste-WC
        ## Positionen
        Anfahrtspauschale | 39,00
        Arbeitszeit 2,5 Std. à 68,00 | 170,00
        Material (Spülkasten, Dichtungen) | 186,50
        ---
        Nettobetrag | 395,50
        zzgl. 19 % MwSt. | 75,15
        Rechnungsbetrag | 470,65
        Zahlbar innerhalb von 14 Tagen ohne Abzug, bei Zahlung innerhalb von 7 Tagen abzüglich 2 % Skonto.
        Enthaltene Arbeits- und Fahrtkosten (brutto): 248,71 € – steuerlich absetzbar nach § 35a EStG.
        """,
        tasks: [
            ReadDoTask(prompt: "You pay within a week. Tap what you may take off.", answer: "Skonto"),
            ReadDoTask(prompt: "Which part can you claim on your tax return?", answer: "steuerlich absetzbar"),
            ReadDoTask(prompt: "The plumber charged a flat fee just for coming. Tap it.", answer: "Anfahrtspauschale")
        ])
}
