//
//  ReadDoScenes+B1.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension ReadDoScenes {
    /// B1: things with small print: a changed platform, a parking sign, a phone bill.
    static let b1: [ReadDoScene] = [b1Platform, b1Parking, b1Detergent, b1Registration, b1Electronics, b1PhoneBill]

    static let b1Platform = ReadDoScene(
        id: "b1-do-platform", level: .b1, kind: .departures,
        title: "A change of platform", detail: "Your train to Berlin", systemImage: "train.side.front.car",
        content: """
        # Düsseldorf Hbf – Fernverkehr
        15:12 | ICE 945 | Berlin Hbf | Gleis 16
        15:20 | IC 2213 | Stuttgart | Gleis 18
        15:34 | ICE 105 | Basel SBB | Gleis 15
        15:46 | ICE 657 | Leipzig Hbf | Gleis 17
        ICE 945: heute Abfahrt von Gleis 13 statt 16.
        IC 2213: Wagen 9 fehlt heute. Reservierungen in Wagen 9 gelten nicht.
        ICE 105: Das Bordrestaurant ist heute geschlossen.
        """,
        tasks: [
            ReadDoTask(prompt: "You're going to Berlin. Where does your train really leave from?", answer: "Gleis 13"),
            ReadDoTask(prompt: "Your seat to Stuttgart is booked in car 9. Tap the problem.", answer: "Wagen 9"),
            ReadDoTask(prompt: "On which train can't you buy a meal?", answer: "Bordrestaurant")
        ])

    static let b1Parking = ReadDoScene(
        id: "b1-do-parking", level: .b1, kind: .sign,
        title: "A parking sign", detail: "Can you park here?", systemImage: "parkingsign",
        content: """
        # Parken
        Mo–Fr 8–18 Uhr | mit Parkschein, höchstens 2 Std.
        Sa 8–14 Uhr | mit Parkschein
        Außerhalb dieser Zeiten | frei
        Bewohner mit Parkausweis Zone B | frei
        ---
        Der Automat steht am Ende der Straße. Sie können auch per App bezahlen.
        Wer auf dem Gehweg parkt, wird abgeschleppt.
        """,
        tasks: [
            ReadDoTask(prompt: "It's Sunday. Tap the line that says whether you need a ticket.", answer: "Außerhalb dieser Zeiten"),
            ReadDoTask(prompt: "On a weekday, how long can you stay?", answer: "höchstens 2 Std."),
            ReadDoTask(prompt: "Who can always park here for free?", answer: "Bewohner")
        ])

    static let b1Detergent = ReadDoScene(
        id: "b1-do-detergent", level: .b1, kind: .packaging,
        title: "Washing powder", detail: "How much do you need?", systemImage: "bubbles.and.sparkles.fill",
        content: """
        # Colorwaschmittel
        Für bunte Wäsche · 20 Waschladungen
        ## Dosierung pro Waschladung (4–5 kg)
        Wenig verschmutzt | 60 ml
        Normal verschmutzt | 75 ml
        Stark verschmutzt | 110 ml
        Bei hartem Wasser etwas mehr nehmen.
        ## Hinweise
        Nicht für Wolle und Seide geeignet.
        Darf nicht in die Hände von Kindern gelangen.
        """,
        tasks: [
            ReadDoTask(prompt: "Your football kit is very dirty. How much powder do you use?", answer: "Stark verschmutzt"),
            ReadDoTask(prompt: "What must you not wash with it?", answer: "Wolle"),
            ReadDoTask(prompt: "When should you use a little more?", answer: "hartem Wasser")
        ])

    static let b1Registration = ReadDoScene(
        id: "b1-do-registration", level: .b1, kind: .form,
        title: "Registering your address", detail: "The form at the city office", systemImage: "house.fill",
        content: """
        # Anmeldung bei der Meldebehörde
        ## Neue Wohnung
        Tag des Einzugs ___
        Straße, Hausnummer, PLZ, Ort ___
        Ist das Ihre Hauptwohnung? Ja oder nein ___
        ## Bisherige Wohnung
        Anschrift der bisherigen Wohnung ___
        ## Angaben zur Person
        Familienstand ___
        Staatsangehörigkeit ___
        Bitte legen Sie die Wohnungsgeberbestätigung Ihres Vermieters bei.
        """,
        tasks: [
            ReadDoTask(prompt: "Where do you write the day you moved in?", answer: "Tag des Einzugs"),
            ReadDoTask(prompt: "Where does your nationality go?", answer: "Staatsangehörigkeit"),
            ReadDoTask(prompt: "What do you need to get from your landlord?", answer: "Wohnungsgeberbestätigung")
        ])

    static let b1Electronics = ReadDoScene(
        id: "b1-do-electronics", level: .b1, kind: .receipt,
        title: "A receipt for headphones", detail: "Can you take them back?", systemImage: "headphones",
        content: """
        # TECHNIKWELT
        Filiale Essen-Mitte
        ---
        Kopfhörer Bluetooth | 79,99
        Ladekabel USB-C | 12,99
        Rabatt Kabel 20 % | -2,60
        ---
        SUMME EUR | 90,38
        EC-Karte | 90,38
        ---
        Umtausch innerhalb von 14 Tagen nur mit Kassenbon.
        Gilt nicht für geöffnete Software.
        Garantie: 2 Jahre ab Kaufdatum.
        """,
        tasks: [
            ReadDoTask(prompt: "How did you pay?", answer: "EC-Karte"),
            ReadDoTask(prompt: "How long can you exchange the headphones?", answer: "14 Tagen"),
            ReadDoTask(prompt: "How much did you save?", answer: "Rabatt")
        ])

    static let b1PhoneBill = ReadDoScene(
        id: "b1-do-phone-bill", level: .b1, kind: .bill,
        title: "A phone bill", detail: "Why is it higher this month?", systemImage: "iphone",
        content: """
        # Mobilfunk-Rechnung November
        Kundennummer 4471 2290
        ## Ihre Kosten
        Grundgebühr Tarif Smart M | 19,99
        Zusätzliches Datenvolumen 5 GB | 9,99
        Anrufe ins Ausland | 6,40
        Treue-Bonus | -5,00
        ---
        Gesamtbetrag | 31,38
        Der Betrag wird am 5.12. von Ihrem Konto abgebucht.
        Ihr Vertrag kann ab 1. März monatlich gekündigt werden.
        """,
        tasks: [
            ReadDoTask(prompt: "The bill is higher because you bought extra data. Tap it.", answer: "Datenvolumen"),
            ReadDoTask(prompt: "When is the money taken from your account?", answer: "abgebucht"),
            ReadDoTask(prompt: "From when can you end the contract?", answer: "gekündigt")
        ])
}
