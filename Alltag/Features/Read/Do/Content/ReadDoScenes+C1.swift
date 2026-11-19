//
//  ReadDoScenes+C1.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension ReadDoScenes {
    /// C1: official German at full length: a tax form, a service charge statement, a medicine box.
    static let c1: [ReadDoScene] = [c1Replacement, c1NoParking, c1Medicine, c1Tax, c1ServiceCharges, c1Payslip]

    static let c1Replacement = ReadDoScene(
        id: "c1-do-replacement", level: .c1, kind: .departures,
        title: "Buses instead of trains", detail: "Works on the line", systemImage: "bus.doubledecker.fill",
        content: """
        # Hinweis: Ersatzverkehr
        ## Bonn – Remagen, 14. bis 28. Februar
        Wegen Bauarbeiten fallen alle Züge zwischen Bonn Hbf und Remagen aus.
        Ersatzbusse fahren ab Bonn Hbf, Bussteig C3, im 30-Minuten-Takt.
        Die Fahrzeit verlängert sich um etwa 25 Minuten. Planen Sie Anschlüsse entsprechend.
        Fahrräder können in den Ersatzbussen nicht befördert werden.
        Für Fahrgäste im Rollstuhl stehen nach Anmeldung (24 Stunden vorher) barrierefreie Kleinbusse bereit.
        Ihre Fahrkarte gilt auch in den Ersatzbussen.
        """,
        tasks: [
            ReadDoTask(prompt: "Where do you get on the replacement bus?", answer: "Bussteig C3"),
            ReadDoTask(prompt: "You're travelling with your bike. Tap what you need to know.", answer: "Fahrräder"),
            ReadDoTask(prompt: "A friend uses a wheelchair. What does she have to do?", answer: "Rollstuhl")
        ])

    static let c1NoParking = ReadDoScene(
        id: "c1-do-no-parking", level: .c1, kind: .sign,
        title: "A no-parking zone for a day", detail: "Someone is moving house", systemImage: "nosign",
        content: """
        # Haltverbot
        ## 12.03., 7 bis 17 Uhr
        Grund: Umzug, Kastanienweg 14
        Das Haltverbot gilt auf beiden Seiten der Fahrbahn auf einer Länge von 20 Metern.
        Fahrzeuge, die nach Beginn der Maßnahme dort stehen, werden kostenpflichtig abgeschleppt.
        Das Schild wurde am 08.03. aufgestellt.
        Genehmigt durch die Straßenverkehrsbehörde der Stadt Bonn, Az. 32-4/118
        """,
        tasks: [
            ReadDoTask(prompt: "Why can't you park here that day?", answer: "Umzug"),
            ReadDoTask(prompt: "How long is the zone?", answer: "20 Metern"),
            ReadDoTask(prompt: "Your car is still there at 8. Tap what happens.", answer: "abgeschleppt")
        ])

    static let c1Medicine = ReadDoScene(
        id: "c1-do-medicine", level: .c1, kind: .packaging,
        title: "A box of painkillers", detail: "The dose and the warnings", systemImage: "pills.fill",
        content: """
        # Paracetamol 500 mg – 20 Tabletten
        ## Dosierung
        Erwachsene und Jugendliche ab 43 kg | 1–2 Tabletten, höchstens 4-mal täglich
        Kinder von 6 bis 12 Jahren (22–40 kg) | 1 Tablette, höchstens 4-mal täglich
        Zwischen zwei Einnahmen mindestens 6 Stunden Abstand halten.
        ## Warnhinweise
        Die Tageshöchstdosis von 4.000 mg darf nicht überschritten werden.
        Bei Leber- oder Nierenerkrankungen nur nach Rücksprache mit dem Arzt anwenden.
        Ohne ärztlichen Rat nicht länger als 3 Tage einnehmen.
        Apothekenpflichtig
        """,
        tasks: [
            ReadDoTask(prompt: "Your nine-year-old has a fever. Tap the dose for them.", answer: "Kinder von 6 bis 12"),
            ReadDoTask(prompt: "What is the most anyone may take in one day?", answer: "Tageshöchstdosis"),
            ReadDoTask(prompt: "Who should talk to a doctor first?", answer: "Leber")
        ])

    static let c1Tax = ReadDoScene(
        id: "c1-do-tax", level: .c1, kind: .form,
        title: "Your tax return", detail: "What you spent for work", systemImage: "percent",
        content: """
        # Einkommensteuererklärung – Anlage N
        ## Werbungskosten
        Tage, an denen Sie zur Arbeit gefahren sind ___
        Einfache Entfernung zwischen Wohnung und Arbeitsstätte in km ___
        Arbeitsmittel, z. B. Laptop, Fachbücher ___
        Fortbildungskosten, z. B. Sprachkurs für den Beruf ___
        Homeoffice-Pauschale: Tage, an denen Sie zu Hause gearbeitet haben ___
        ## Hinweis
        Belege reichen Sie nur ein, wenn das Finanzamt sie anfordert.
        """,
        tasks: [
            ReadDoTask(prompt: "You live 18 km from work. Where does that go?", answer: "Einfache Entfernung"),
            ReadDoTask(prompt: "Your German course was for your job. Where do you put it?", answer: "Fortbildungskosten"),
            ReadDoTask(prompt: "Do you have to send your receipts now? Tap the answer.", answer: "Belege")
        ])

    static let c1ServiceCharges = ReadDoScene(
        id: "c1-do-service-charges", level: .c1, kind: .bill,
        title: "The service charge statement", detail: "Your landlord's yearly bill", systemImage: "building.2.fill",
        content: """
        # Betriebskostenabrechnung 2025
        Wohnung 3. OG links · 68 m² von 1.020 m²
        ## Umlage nach Wohnfläche
        Grundsteuer | 214,40
        Gebäudeversicherung | 158,20
        Müllabfuhr | 196,00
        Hausmeister | 312,80
        ## Umlage nach Verbrauch
        Heizung und Warmwasser | 1.046,60
        ---
        Ihre Kosten gesamt | 1.928,00
        Ihre Vorauszahlungen 12 × 150 € | 1.800,00
        Nachzahlung | 128,00
        Einwände sind innerhalb von 12 Monaten nach Zugang schriftlich geltend zu machen.
        """,
        tasks: [
            ReadDoTask(prompt: "Which cost depends on how much you used?", answer: "Heizung und Warmwasser"),
            ReadDoTask(prompt: "Do you pay more or get money back? Tap it.", answer: "Nachzahlung"),
            ReadDoTask(prompt: "You think something is wrong. How long do you have to object?", answer: "Einwände")
        ])

    static let c1Payslip = ReadDoScene(
        id: "c1-do-payslip", level: .c1, kind: .payslip,
        title: "A pay slip in December", detail: "Bonus, tax and savings", systemImage: "banknote.fill",
        content: """
        # Entgeltabrechnung Dezember
        Daniel Kovač · Steuerklasse 3
        ## Bezüge
        Tarifgehalt | 4.150,00
        Weihnachtsgeld | 2.075,00
        Vermögenswirksame Leistungen | 40,00
        Gesamtbrutto | 6.265,00
        ## Gesetzliche Abzüge
        Lohnsteuer | 812,33
        Solidaritätszuschlag | 0,00
        Sozialversicherung gesamt | 1.315,65
        ## Sonstige Abzüge
        Überweisung Bausparvertrag | 40,00
        ---
        Auszahlung | 4.097,02
        """,
        tasks: [
            ReadDoTask(prompt: "Why is his gross pay so high this month?", answer: "Weihnachtsgeld"),
            ReadDoTask(prompt: "Money goes straight to a savings plan. Tap where it leaves.", answer: "Bausparvertrag"),
            ReadDoTask(prompt: "Which tax is zero for him?", answer: "Solidaritätszuschlag")
        ])
}
