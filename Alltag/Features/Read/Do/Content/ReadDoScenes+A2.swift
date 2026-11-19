//
//  ReadDoScenes+A2.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension ReadDoScenes {
    /// A2: daily life gets busier: a late train, house rules, a restaurant bill.
    static let a2: [ReadDoScene] = [a2Train, a2Laundry, a2Pizza, a2Library, a2Restaurant, a2Sorting]

    static let a2Train = ReadDoScene(
        id: "a2-do-train", level: .a2, kind: .departures,
        title: "Delays at the station", detail: "Which train can you take?", systemImage: "tram.fill",
        content: """
        # Köln Hbf – Abfahrt
        ## Gleis 5 bis 8
        14:02 | RE 1 | Aachen | Gleis 5
        14:10 | S 12 | Troisdorf | Gleis 6
        14:15 | RB 25 | Lüdenscheid | fällt aus
        14:24 | RE 5 | Koblenz | Gleis 8
        14:31 | S 19 | Düren | Gleis 7
        RE 5: heute ca. 15 Minuten später.
        RB 25: Bitte nehmen Sie den Bus vor dem Bahnhof.
        """,
        tasks: [
            ReadDoTask(prompt: "Which train doesn't run today?", answer: "fällt aus"),
            ReadDoTask(prompt: "The train to Koblenz is late. Tap how late.", answer: "15 Minuten"),
            ReadDoTask(prompt: "You wanted the RB 25. What do you do now?", answer: "Bus vor dem Bahnhof")
        ])

    static let a2Laundry = ReadDoScene(
        id: "a2-do-laundry", level: .a2, kind: .sign,
        title: "The rules of the laundry room", detail: "When can you wash?", systemImage: "washer.fill",
        content: """
        # Waschküche – Hausordnung
        Waschen nur von 7 bis 21 Uhr.
        Sonntags bitte nicht waschen.
        Jede Wohnung hat einen Tag. Der Plan hängt neben der Tür.
        Bitte die Maschine nach dem Waschen sauber machen.
        Wäsche nicht länger als einen Tag im Trockenraum lassen.
        Bei Problemen: Hausmeister Herr Krause, Tel. 0221 554 21
        """,
        tasks: [
            ReadDoTask(prompt: "On which day can nobody wash?", answer: "Sonntags"),
            ReadDoTask(prompt: "Where do you find out which day is yours?", answer: "neben der Tür"),
            ReadDoTask(prompt: "The machine is broken. Who do you call?", answer: "Hausmeister")
        ])

    static let a2Pizza = ReadDoScene(
        id: "a2-do-pizza", level: .a2, kind: .packaging,
        title: "A frozen pizza", detail: "How do you bake it?", systemImage: "oven.fill",
        content: """
        # Pizza Margherita
        Tiefgefroren · 350 g
        ## Zubereitung
        Den Backofen auf 220 °C vorheizen.
        Die Pizza aus der Folie nehmen.
        Auf dem Rost in der Mitte 12–14 Minuten backen.
        Nicht in der Mikrowelle zubereiten.
        ## Lagerung
        Bei -18 °C haltbar bis: siehe Rand.
        Nach dem Auftauen nicht wieder einfrieren.
        """,
        tasks: [
            ReadDoTask(prompt: "How hot should the oven be?", answer: "220 °C"),
            ReadDoTask(prompt: "How long does it bake?", answer: "12–14 Minuten"),
            ReadDoTask(prompt: "What must you not do once it has thawed?", answer: "nicht wieder einfrieren")
        ])

    static let a2Library = ReadDoScene(
        id: "a2-do-library", level: .a2, kind: .form,
        title: "A library card", detail: "Fill in the form", systemImage: "books.vertical.fill",
        content: """
        # Stadtbibliothek – Antrag auf einen Leseausweis
        ## Persönliche Angaben
        Name, Vorname ___
        Straße, Hausnummer ___
        PLZ, Wohnort ___
        Geburtsdatum ___
        ## Nur für Kinder unter 16 Jahren
        Unterschrift eines Elternteils ___
        ## Gebühr
        Erwachsene | 12 € pro Jahr
        Schüler und Studierende | kostenlos
        """,
        tasks: [
            ReadDoTask(prompt: "Where do you write your postcode?", answer: "PLZ"),
            ReadDoTask(prompt: "Your daughter is 12. Where does a parent sign?", answer: "Elternteil"),
            ReadDoTask(prompt: "You're a student. What does the card cost you?", answer: "kostenlos")
        ])

    static let a2Restaurant = ReadDoScene(
        id: "a2-do-restaurant", level: .a2, kind: .receipt,
        title: "The bill at a restaurant", detail: "Who had what?", systemImage: "fork.knife",
        content: """
        # Trattoria Da Marco
        Tisch 7 · 2 Gäste
        ---
        1 Spaghetti Carbonara | 11,50
        1 Pizza Funghi | 9,80
        2 Apfelschorle 0,4 l | 7,60
        1 Tiramisu | 5,90
        ---
        Summe | 34,80
        inkl. MwSt. 19 % | 5,56
        Bedienung nicht inklusive.
        Vielen Dank und bis bald!
        """,
        tasks: [
            ReadDoTask(prompt: "How much were the two drinks?", answer: "Apfelschorle"),
            ReadDoTask(prompt: "What do you pay in all?", answer: "Summe"),
            ReadDoTask(prompt: "Is the tip already in the bill? Tap where it says.", answer: "Bedienung")
        ])

    static let a2Sorting = ReadDoScene(
        id: "a2-do-sorting", level: .a2, kind: .binCalendar,
        title: "What goes in which bin", detail: "Sort your rubbish", systemImage: "arrow.3.trianglepath",
        content: """
        # Mülltrennung – so geht's
        Gelbe Tonne | Joghurtbecher, Dosen, Folie
        Papier | Zeitungen, Kartons
        Biotonne | Obst, Gemüse, Kaffeesatz
        Glas | Flaschen und Gläser ohne Pfand
        Restmüll | Windeln, Staubsaugerbeutel
        Flaschen mit Pfand bringen Sie in den Supermarkt.
        """,
        tasks: [
            ReadDoTask(prompt: "Where do old coffee grounds go?", answer: "Kaffeesatz"),
            ReadDoTask(prompt: "Where does an empty tin go?", answer: "Dosen"),
            ReadDoTask(prompt: "Where do you take bottles with a deposit?", answer: "in den Supermarkt")
        ])
}
