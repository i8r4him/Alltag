//
//  ReadingTexts+NewKindsB.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The B1 and B2 samples of the new kinds of text. Temporary, like
/// `ReadingTexts.newKinds`.
extension ReadingTexts {
    static let b1Ticket = ReadingText(
        id: "b1-ticket", level: .b1, kind: .letter,
        title: "A parking ticket", detail: "A letter from the city",
        systemImage: "car.fill",
        german: """
        Stadt Köln – Ordnungsamt
        Verwarnung mit Verwarnungsgeld

        Sehr geehrte Frau Yilmaz,

        Ihr Auto mit dem Kennzeichen K-AY 284 stand am 12.11. von 14:05 bis 14:40 Uhr in der Venloer Straße 210.
        Dort gilt ein absolutes Halteverbot.
        Wir bieten Ihnen an, die Sache mit einem Verwarnungsgeld von 25 Euro zu erledigen.
        Bitte überweisen Sie den Betrag innerhalb einer Woche auf das unten genannte Konto.
        Zahlen Sie nicht rechtzeitig, beginnt ein Bußgeldverfahren, und es entstehen weitere Kosten.
        Sind Sie das Auto an diesem Tag nicht selbst gefahren, füllen Sie bitte den beiliegenden Anhörungsbogen aus.

        Mit freundlichen Grüßen
        Ihr Ordnungsamt
        """,
        questions: [
            ReadingQuestion(prompt: "Why did Ms Yilmaz get this letter?",
                            options: ["She drove too fast", "She parked where stopping is not allowed", "Her car has no insurance"],
                            answer: 1, evidence: "Dort gilt ein absolutes Halteverbot."),
            ReadingQuestion(prompt: "What happens if she pays late?",
                            options: ["Nothing", "She loses her licence", "A fine procedure starts and costs more"],
                            answer: 2,
                            evidence: "Zahlen Sie nicht rechtzeitig, beginnt ein Bußgeldverfahren, und es entstehen weitere Kosten."),
            ReadingQuestion(prompt: "What if someone else drove the car?",
                            options: ["Fill in the enclosed form", "Pay anyway", "Call the police"],
                            answer: 0,
                            evidence: "Sind Sie das Auto an diesem Tag nicht selbst gefahren, " +
                                "füllen Sie bitte den beiliegenden Anhörungsbogen aus.")
        ])

    static let b1Leaflet = ReadingText(
        id: "b1-leaflet", level: .b1, kind: .leaflet,
        title: "The leaflet in the medicine box", detail: "How to take ibuprofen",
        systemImage: "pills.fill",
        german: """
        Ibuprofen 400 mg – Gebrauchsinformation

        Wofür? Gegen leichte bis mäßige Schmerzen, zum Beispiel Kopfschmerzen oder Zahnschmerzen, und gegen Fieber.
        Erwachsene nehmen eine Tablette, höchstens drei Tabletten am Tag.
        Zwischen zwei Tabletten müssen mindestens sechs Stunden liegen.
        Nehmen Sie die Tablette mit einem Glas Wasser während einer Mahlzeit.
        Wenn Sie schwanger sind oder Probleme mit dem Magen haben, fragen Sie vorher Ihren Arzt.
        Nehmen Sie das Mittel ohne ärztlichen Rat nicht länger als drei Tage bei Fieber und vier Tage bei Schmerzen.
        """,
        questions: [
            ReadingQuestion(prompt: "How long must you wait between two tablets?",
                            options: ["Two hours", "At least six hours", "One day"],
                            answer: 1, evidence: "Zwischen zwei Tabletten müssen mindestens sechs Stunden liegen."),
            ReadingQuestion(prompt: "How should you take it?",
                            options: ["With water during a meal", "On an empty stomach", "With coffee in the morning"],
                            answer: 0, evidence: "Nehmen Sie die Tablette mit einem Glas Wasser während einer Mahlzeit."),
            ReadingQuestion(prompt: "Who should ask a doctor first?",
                            options: ["Everyone over 60", "People with a headache", "Pregnant women and people with stomach problems"],
                            answer: 2,
                            evidence: "Wenn Sie schwanger sind oder Probleme mit dem Magen haben, fragen Sie vorher Ihren Arzt.")
        ])

    static let b1Courses = ReadingText(
        id: "b1-courses", level: .b1, kind: .programme,
        title: "The adult education programme", detail: "New courses in January",
        systemImage: "calendar",
        german: """
        Volkshochschule – Neue Kurse im Januar

        Spanisch für Anfänger: dienstags von 18 bis 19:30 Uhr, zehn Termine, 89 Euro.
        Smartphone-Fotografie: ein Workshop an einem Samstag, von 10 bis 16 Uhr, 45 Euro.
        Yoga am Morgen: donnerstags von 7 bis 8 Uhr, bitte eine eigene Matte mitbringen.
        Bewerbungstraining: Lebenslauf, Anschreiben und Vorstellungsgespräch. Für Arbeitssuchende ist der Kurs kostenlos.
        Studierende, Rentnerinnen und Rentner bekommen 20 Prozent Ermäßigung.
        Anmeldung online oder im Büro der Volkshochschule, spätestens eine Woche vor Kursbeginn.
        """,
        questions: [
            ReadingQuestion(prompt: "Which course takes only one day?",
                            options: ["Spanish", "Smartphone photography", "Yoga"],
                            answer: 1, evidence: "Smartphone-Fotografie: ein Workshop an einem Samstag, von 10 bis 16 Uhr, 45 Euro."),
            ReadingQuestion(prompt: "Who can take the job application course for free?",
                            options: ["Students", "Pensioners", "People looking for work"],
                            answer: 2,
                            evidence: "Bewerbungstraining: Lebenslauf, Anschreiben und Vorstellungsgespräch. " +
                                "Für Arbeitssuchende ist der Kurs kostenlos."),
            ReadingQuestion(prompt: "When must you sign up at the latest?",
                            options: ["One week before the course starts", "On the first day", "By the end of January"],
                            answer: 0,
                            evidence: "Anmeldung online oder im Büro der Volkshochschule, spätestens eine Woche vor Kursbeginn.")
        ])

    static let b2JobAd = ReadingText(
        id: "b2-job-ad", level: .b2, kind: .advert,
        title: "A job ad from a bakery", detail: "Part-time sales assistant",
        systemImage: "briefcase.fill",
        german: """
        Bio-Bäckerei Korn & Kruste sucht Verstärkung!

        Für unsere Filiale in Bonn-Beuel suchen wir ab sofort eine Verkäuferin oder einen Verkäufer in Teilzeit (20 Stunden pro Woche).
        Sie beraten unsere Kundschaft, bereiten belegte Brötchen zu und halten den Laden sauber.
        Erfahrung im Verkauf ist hilfreich, aber keine Voraussetzung – wir arbeiten Sie gründlich ein.
        Die Frühschicht beginnt um 6 Uhr, deshalb sollten Sie gern früh aufstehen.
        Wir bieten faire Bezahlung über Tarif, ein kleines Team und jeden Tag Brot zum Mitnehmen.
        Ein Anschreiben brauchen wir nicht: Schicken Sie uns einfach Ihren Lebenslauf an jobs@kornundkruste.de.
        """,
        questions: [
            ReadingQuestion(prompt: "Do you need sales experience?",
                            options: ["Yes, at least two years", "It helps, but it isn't required", "Only for the early shift"],
                            answer: 1,
                            evidence: "Erfahrung im Verkauf ist hilfreich, aber keine Voraussetzung – wir arbeiten Sie gründlich ein."),
            ReadingQuestion(prompt: "Why should you like getting up early?",
                            options: ["The early shift starts at 6", "The bakery opens at 5", "You deliver bread"],
                            answer: 0, evidence: "Die Frühschicht beginnt um 6 Uhr, deshalb sollten Sie gern früh aufstehen."),
            ReadingQuestion(prompt: "What should you send?",
                            options: ["A cover letter and references", "Nothing, just come by", "Only your CV"],
                            answer: 2,
                            evidence: "Ein Anschreiben brauchen wir nicht: Schicken Sie uns einfach Ihren Lebenslauf " +
                                "an jobs@kornundkruste.de.")
        ])
}
