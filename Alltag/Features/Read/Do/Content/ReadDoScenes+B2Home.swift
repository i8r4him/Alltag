//
//  ReadDoScenes+B2Home.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension ReadDoScenes {
    // B2's scenes of the flat and the street. The list of B2 scenes is in `ReadDoScenes+B2.swift`.

    static let b2Parking = ReadDoScene(
        id: "b2-do-parking", level: .b2, kind: .sign,
        title: "A parking sign", detail: "Can you park here?", systemImage: "parkingsign",
        content: """
        # Parken
        Mo–Fr 8–18 Uhr, Sa 8–14 Uhr
        nur mit Parkschein
        Höchstparkdauer 2 Std.
        Bewohner mit Parkausweis Nr. 14 frei
        ---
        Parkscheinautomat am Ende der Straße.
        Bezahlen auch per App möglich: Zone 3402.
        Die ersten 15 Minuten sind mit Parkschein gebührenfrei.
        Widerrechtlich abgestellte Fahrzeuge werden kostenpflichtig abgeschleppt.
        """,
        tasks: [
            ReadDoTask(prompt: "It's Saturday, 3 pm. Tap the line that says if you need a ticket.", answer: "Sa 8–14 Uhr"),
            ReadDoTask(prompt: "You have no coins. How else can you pay?", answer: "per App"),
            ReadDoTask(prompt: "Your neighbour has a permit for this street. Tap what applies to them.", answer: "Bewohner")
        ])

    static let b2Hardware = ReadDoScene(
        id: "b2-do-hardware", level: .b2, kind: .receipt,
        title: "A receipt from the DIY store", detail: "What can you take back?", systemImage: "hammer.fill",
        content: """
        # BAUWELT
        Filiale Köln-Ehrenfeld · Kasse 4
        ---
        Akku-Bohrschrauber 18 V | 129,00
        Bohrer-Set Holz/Metall | 24,99
        Wandfarbe weiß 10 l | 49,95
        Abtönfarbe, angemischt | 8,49
        Treuerabatt 10 % auf Farben | -5,84
        ---
        Summe EUR | 206,59
        Kreditkarte | 206,59
        enthaltene MwSt. 19 % | 32,98
        ---
        Umtausch und Rückgabe innerhalb von 30 Tagen mit Kassenbon.
        Individuell angemischte Farben sind vom Umtausch ausgeschlossen.
        Für Elektrogeräte gilt die gesetzliche Gewährleistung von 2 Jahren.
        """,
        tasks: [
            ReadDoTask(prompt: "You don't like the colour you had mixed. Can you take it back? Tap the rule.",
                       answer: "angemischte Farben"),
            ReadDoTask(prompt: "How much did you save with your loyalty card?", answer: "Treuerabatt"),
            ReadDoTask(prompt: "The drill breaks after a year. Tap what protects you.", answer: "Gewährleistung")
        ])

    static let b2Medicine = ReadDoScene(
        id: "b2-do-medicine", level: .b2, kind: .packaging,
        title: "A box of painkillers", detail: "How many can you take?", systemImage: "pills.fill",
        content: """
        # Ibuprofen 400 mg
        20 Filmtabletten · zum Einnehmen
        ## Anwendungsgebiete
        Leichte bis mäßig starke Schmerzen wie Kopf- und Zahnschmerzen, Fieber
        ## Dosierung
        Erwachsene und Jugendliche ab 40 kg | 1 Tablette, bei Bedarf alle 6 Stunden
        Tageshöchstdosis | 3 Tabletten (1.200 mg)
        Kinder unter 12 Jahren | nicht geeignet
        ## Hinweise
        Bei empfindlichem Magen während einer Mahlzeit einnehmen.
        Ohne ärztlichen Rat nicht länger als 4 Tage bei Schmerzen oder 3 Tage bei Fieber anwenden.
        Apothekenpflichtig · Packungsbeilage beachten
        """,
        tasks: [
            ReadDoTask(prompt: "You took one at 10 am. Tap what says when you may take the next.", answer: "alle 6 Stunden"),
            ReadDoTask(prompt: "What's the most you may take in one day?", answer: "Tageshöchstdosis"),
            ReadDoTask(prompt: "Your headache is still there on day five. Tap what the box says.", answer: "nicht länger als")
        ])

    static let b2Bins = ReadDoScene(
        id: "b2-do-bins", level: .b2, kind: .binCalendar,
        title: "The bin collection plan", detail: "Christmas moves the dates", systemImage: "calendar",
        content: """
        # Abfuhrkalender Dezember
        ## Bezirk Nord · Straßen A bis K
        Mi 2.12. | Restmüll
        Fr 4.12. | Altpapier
        Di 8.12. | Gelber Sack
        Fr 11.12. | Biotonne
        Mi 16.12. | Restmüll
        Di 22.12. | Gelber Sack
        Mo 28.12. | Biotonne (Nachholtermin für Fr 25.12.)
        Mi 30.12. | Restmüll
        ---
        Fällt die Abfuhr auf einen Feiertag, wird sie am nächsten Werktag nachgeholt.
        Die Biotonne wird von Dezember bis Februar nur alle zwei Wochen geleert.
        Bitte stellen Sie die Tonnen am Abfuhrtag bis 6 Uhr an den Straßenrand.
        Weihnachtsbäume ohne Schmuck werden am Sa 9.1. abgeholt.
        Sperrmüll: zweimal im Jahr kostenlos, Termin online vereinbaren.
        """,
        tasks: [
            ReadDoTask(prompt: "The organic bin isn't emptied on Christmas Day. When is it emptied?", answer: "Nachholtermin"),
            ReadDoTask(prompt: "By what time must the bins be out on the street?", answer: "bis 6 Uhr"),
            ReadDoTask(prompt: "When is your Christmas tree taken away?", answer: "Weihnachtsbäume")
        ])

    static let b2Insurance = ReadDoScene(
        id: "b2-do-insurance", level: .b2, kind: .form,
        title: "An insurance claim form", detail: "Your bike was stolen", systemImage: "bicycle",
        content: """
        # Schadenanzeige Hausratversicherung
        Versicherungsnummer ___
        Schadentag und Uhrzeit ___
        Schadenort (genaue Adresse) ___
        Schilderung des Schadenhergangs ___
        Gestohlene oder beschädigte Gegenstände mit Kaufpreis ___
        Polizeiliches Aktenzeichen (bei Diebstahl und Einbruch) ___
        Wurden Sicherungen überwunden (z. B. Schloss aufgebrochen)? ___
        Bankverbindung für die Erstattung ___
        Bitte fügen Sie Kaufbelege und Fotos bei.
        Ort, Datum, Unterschrift ___
        """,
        tasks: [
            ReadDoTask(prompt: "The police gave you a reference number. Where does it go?", answer: "Aktenzeichen"),
            ReadDoTask(prompt: "Where do you describe what happened?", answer: "Schadenhergang"),
            ReadDoTask(prompt: "The bike was locked and the lock was cut. Where do you say so?", answer: "Sicherungen")
        ])

    static let b2Lease = ReadDoScene(
        id: "b2-do-lease", level: .b2, kind: .contract,
        title: "A tenancy agreement", detail: "What did you sign?", systemImage: "signature",
        content: """
        # Mietvertrag über Wohnraum
        ## § 3 Miete und Nebenkosten
        Kaltmiete | 820,00 €
        Vorauszahlung Betriebskosten | 180,00 €
        Vorauszahlung Heizkosten | 95,00 €
        Gesamtmiete monatlich | 1.095,00 €
        Die Miete ist monatlich im Voraus, spätestens bis zum dritten Werktag, zu zahlen.
        ## § 5 Mietsicherheit
        Der Mieter leistet eine Kaution von 2.460 Euro. Er ist berechtigt, sie in drei gleichen Monatsraten zu zahlen.
        ## § 9 Tierhaltung
        Kleintiere sind erlaubt. Hunde und Katzen nur mit schriftlicher Zustimmung des Vermieters.
        ## § 12 Kündigung
        Der Mieter kann mit einer Frist von drei Monaten zum Monatsende kündigen.
        """,
        tasks: [
            ReadDoTask(prompt: "By when must the rent be paid each month?", answer: "dritten Werktag"),
            ReadDoTask(prompt: "Can you pay the deposit in parts? Tap where it says.", answer: "Monatsraten"),
            ReadDoTask(prompt: "You'd like a cat. What do you need first?", answer: "schriftlicher Zustimmung")
        ])

    static let b2ServiceCharges = ReadDoScene(
        id: "b2-do-service-charges", level: .b2, kind: .bill,
        title: "The yearly service charges", detail: "Do you owe your landlord?", systemImage: "house.fill",
        content: """
        # Betriebskostenabrechnung
        Zeitraum 01.01. bis 31.12. · Wohnung 2. OG links · 72 m²
        ## Ihr Anteil an den Kosten
        Heizung und Warmwasser | 1.046,30
        Wasser und Abwasser | 318,40
        Müllabfuhr | 142,80
        Hausreinigung und Gartenpflege | 236,50
        Grundsteuer | 198,00
        Gebäudeversicherung | 121,60
        ---
        Summe Ihrer Kosten | 2.063,60
        Ihre Vorauszahlungen 12 × 160 € | 1.920,00
        Nachzahlung | 143,60
        Bitte überweisen Sie den Betrag bis zum 15. März.
        Einwendungen gegen diese Abrechnung können Sie innerhalb von 12 Monaten erheben.
        Ihre neue monatliche Vorauszahlung ab April: 172 €.
        """,
        tasks: [
            ReadDoTask(prompt: "Do you have to pay extra? Tap it.", answer: "Nachzahlung"),
            ReadDoTask(prompt: "How much of the property tax do you pay?", answer: "Grundsteuer"),
            ReadDoTask(prompt: "You think a cost is wrong. How long do you have to object?", answer: "Einwendungen")
        ])
}
