//
//  MockReading.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 10.11.26.
//

import Foundation

/// An article the learner shared from Safari.
struct SavedArticle: Identifiable {
    let id = UUID()
    /// The article's German headline, shown as is.
    let title: String
    let site: String
    let level: String
    let minutes: Int
}

/// A text from daily life to read: a letter, notice or form.
struct ReadingText: Identifiable {
    /// Stable, so the reader can be opened by it.
    let id: String
    let title: LocalizedStringResource
    let detail: LocalizedStringResource
    let level: String
    let minutes: Int
    let systemImage: String
    /// The text itself, in German. One line per paragraph; an empty line starts a new block.
    let german: String
}

/// Sample content for the Read screen until the texts for each level (#270) are decided.
enum MockReading {
    static let articles = [
        SavedArticle(title: "Mietpreise in Berlin steigen weiter", site: "Spiegel", level: "B1", minutes: 6),
        SavedArticle(title: "Deutschlandticket: Was sich 2027 ändert", site: "tagesschau", level: "B1", minutes: 4)
    ]

    static let picked = ReadingText(
        id: "landlord", title: "A letter from your landlord", detail: "Your service charges, explained.",
        level: "A2", minutes: 3, systemImage: "envelope.open.fill",
        german: """
        Sehr geehrte Frau Becker,

        anbei erhalten Sie die Nebenkostenabrechnung für das letzte Jahr. Sie haben im Voraus 840 Euro bezahlt. \
        Die tatsächlichen Kosten waren aber 915 Euro.

        Bitte überweisen Sie die Differenz von 75 Euro bis Mitte Dezember auf unser Konto.

        Ab Januar steigt Ihre monatliche Vorauszahlung um 10 Euro. \
        Bei Fragen erreichen Sie uns montags bis freitags von 9 bis 13 Uhr.

        Mit freundlichen Grüßen
        Hausverwaltung Schulz
        """)

    static let more = [
        ReadingText(
            id: "buergeramt", title: "A notice from the Bürgeramt", detail: "Your appointment",
            level: "A2", minutes: 2, systemImage: "building.columns.fill",
            german: """
            Liebe Bürgerin, lieber Bürger,

            Ihr Termin im Bürgeramt ist am Dienstag um 10:30 Uhr. Bitte kommen Sie pünktlich. \
            Wer mehr als zehn Minuten zu spät kommt, muss einen neuen Termin buchen.

            Bringen Sie bitte Ihren Reisepass, den Mietvertrag und die Wohnungsgeberbestätigung mit. \
            Die Anmeldung ist kostenlos.

            Wenn Sie den Termin nicht wahrnehmen können, sagen Sie ihn bitte online ab.
            """),
        ReadingText(
            id: "doctor", title: "A form at the doctor's", detail: "Fill it in",
            level: "B1", minutes: 4, systemImage: "cross.case.fill",
            german: """
            Patientenfragebogen

            Bitte füllen Sie diesen Fragebogen vor Ihrem ersten Besuch aus. Ihre Angaben werden vertraulich behandelt.

            Haben Sie Allergien, zum Beispiel gegen Medikamente oder Lebensmittel? \
            Nehmen Sie regelmäßig Medikamente ein? Wenn ja, welche und wie oft?

            Gab es in Ihrer Familie schwere Krankheiten, etwa Herzprobleme oder Diabetes?

            Bitte bringen Sie Ihre Versichertenkarte und, falls vorhanden, Ihren Impfpass mit.
            """),
        ReadingText(
            id: "shift", title: "An email from work", detail: "A change of shift",
            level: "B1", minutes: 3, systemImage: "briefcase.fill",
            german: """
            Hallo zusammen,

            wegen einer Krankmeldung müssen wir den Schichtplan für nächste Woche ändern. \
            Ayşe übernimmt am Mittwoch die Frühschicht, dafür arbeitet Jonas am Freitag in der Spätschicht.

            Wer am Samstag einspringen kann, meldet sich bitte bis morgen bei mir. \
            Die Stunden werden natürlich als Überstunden bezahlt.

            Danke für eure Flexibilität!

            Viele Grüße
            Martina
            """),
        ReadingText(
            id: "cafe", title: "A menu at the café", detail: "Order lunch",
            level: "A1", minutes: 2, systemImage: "cup.and.saucer.fill",
            german: """
            Mittagstisch

            Montag bis Freitag, 11:30 bis 14:30 Uhr

            Tagessuppe mit Brot – 5,50 Euro
            Spaghetti mit Tomatensoße – 8,90 Euro
            Gemüsecurry mit Reis, vegan – 9,50 Euro
            Schnitzel mit Pommes und Salat – 12,90 Euro

            Zu jedem Gericht gibt es ein Glas Wasser gratis. Kaffee und Kuchen bekommen Sie den ganzen Tag.
            """),
        ReadingText(
            id: "bahn", title: "A notice from Deutsche Bahn", detail: "Engineering works",
            level: "A2", minutes: 2, systemImage: "tram.fill",
            german: """
            Bauarbeiten zwischen Hamburg und Buchholz

            An den nächsten beiden Wochenenden fahren wegen Bauarbeiten keine Züge zwischen Hamburg-Harburg und Buchholz. \
            Zwischen diesen Bahnhöfen gibt es einen Ersatzverkehr mit Bussen.

            Die Busse brauchen etwa 30 Minuten länger als der Zug. Fahrräder können leider nicht mitgenommen werden.

            Bitte planen Sie mehr Zeit ein und prüfen Sie Ihre Verbindung vor der Fahrt online oder in der App.

            Wir bitten um Ihr Verständnis.
            """)
    ]

    /// Every text, the picked one first.
    static var texts: [ReadingText] { [picked] + more }

    static func text(id: String) -> ReadingText? {
        texts.first { $0.id == id }
    }
}
