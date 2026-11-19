//
//  ReadingTexts+B2.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension ReadingTexts {
    /// B2: texts from work, the house, the family and the news, with formal phrasing, about 90 to 160
    /// words. The texts from family, health, the flat and the car are in `ReadingTexts+B2Everyday.swift`.
    static let b2: [ReadingText] = [
        b2Renovation, b2Garage, b2Interview, b2FlatAd, b2Party, b2Dentist, b2Waste,
        b2Canteen, b2FourDays, b2Nursery, b2Strike, b2Gym, b2ClassTrip, b2Recognition
    ]

    static let b2Renovation = ReadingText(
        id: "b2-renovation", level: .b2, kind: .letter,
        title: "A letter from the landlord", detail: "Building work and a new rent",
        systemImage: "building.2.fill",
        german: """
        Sehr geehrter Herr Okafor,

        wie auf der Mieterversammlung im Mai angekündigt, werden im Frühjahr in Ihrem Haus neue Fenster eingebaut \
        und die Fassade wird gedämmt.
        Die Arbeiten beginnen voraussichtlich am 3. März und dauern etwa sechs Wochen. In dieser Zeit steht ein Gerüst am Haus.
        Für den Einbau der Fenster müssen die Handwerker an einem Tag in Ihre Wohnung. \
        Den genauen Termin teilen wir Ihnen mindestens zwei Wochen vorher mit.
        Durch die Modernisierung sinken Ihre Heizkosten deutlich. \
        Gleichzeitig erhöht sich Ihre Kaltmiete nach Abschluss der Arbeiten um 38 Euro im Monat.
        Falls Sie in dieser Zeit Unterstützung brauchen, etwa weil Sie im Homeoffice arbeiten, melden Sie sich bitte bei uns.

        Mit freundlichen Grüßen
        Wohnbau Nord GmbH
        """,
        questions: [
            ReadingQuestion(prompt: "How long will the work take?",
                            options: ["Two weeks", "About six weeks", "Until May"],
                            answer: 1, evidence: "Die Arbeiten beginnen voraussichtlich am 3. März und dauern etwa sechs Wochen."),
            ReadingQuestion(prompt: "When will he know the day the workers come into his flat?",
                            options: ["At least two weeks before", "On the day itself", "At the tenants' meeting"],
                            answer: 0, evidence: "Den genauen Termin teilen wir Ihnen mindestens zwei Wochen vorher mit."),
            ReadingQuestion(prompt: "What happens to his costs afterwards?",
                            options: ["Both go down", "Nothing changes", "Heating gets cheaper, but the rent goes up"],
                            answer: 2,
                            evidence: "Gleichzeitig erhöht sich Ihre Kaltmiete nach Abschluss der Arbeiten um 38 Euro im Monat.")
        ])

    static let b2Interview = ReadingText(
        id: "b2-interview", level: .b2, kind: .email,
        title: "An email from a company", detail: "A job interview",
        systemImage: "person.crop.rectangle.fill",
        german: """
        Sehr geehrte Frau Haddad,

        vielen Dank für Ihre Bewerbung als Projektassistentin. Ihre Unterlagen haben uns überzeugt, \
        und wir möchten Sie gern persönlich kennenlernen.
        Wir laden Sie daher zu einem Vorstellungsgespräch am Donnerstag, den 12. Februar, um 10 Uhr in unser Büro ein.
        Das Gespräch dauert etwa eine Stunde. Neben mir nimmt auch Herr Lenz, der Leiter des Teams, daran teil.
        Bitte bereiten Sie anhand der beigefügten Unterlagen eine Präsentation von höchstens zehn Minuten vor.
        Die Fahrtkosten erstatten wir Ihnen selbstverständlich.
        Bitte bestätigen Sie den Termin bis Montag. Sollte er Ihnen nicht passen, schlagen Sie uns gern einen anderen vor.

        Mit freundlichen Grüßen
        Katrin Vogt, Personalabteilung
        """,
        questions: [
            ReadingQuestion(prompt: "What should Frau Haddad prepare?",
                            options: ["A written test", "A ten-minute presentation", "Two references"],
                            answer: 1,
                            evidence: "Bitte bereiten Sie anhand der beigefügten Unterlagen "
                                + "eine Präsentation von höchstens zehn Minuten vor."),
            ReadingQuestion(prompt: "Who pays for her journey?",
                            options: ["She does", "Herr Lenz", "The company"],
                            answer: 2, evidence: "Die Fahrtkosten erstatten wir Ihnen selbstverständlich."),
            ReadingQuestion(prompt: "What if the date doesn't suit her?",
                            options: ["She can suggest another one", "She can't come at all", "She has to call Herr Lenz"],
                            answer: 0, evidence: "Sollte er Ihnen nicht passen, schlagen Sie uns gern einen anderen vor.")
        ])

    static let b2Waste = ReadingText(
        id: "b2-waste", level: .b2, kind: .notice,
        title: "A notice in the bin room", detail: "Sorting the rubbish",
        systemImage: "trash.fill",
        german: """
        Wichtiger Hinweis zur Mülltrennung

        Liebe Bewohnerinnen und Bewohner,
        in den letzten Wochen wurde der Müll in unserem Haus immer wieder falsch getrennt. \
        Vor allem in der gelben Tonne landen häufig Glas und Restmüll.
        Die Entsorgungsfirma hat die Tonnen deshalb zweimal nicht geleert. \
        Für die Sonderleerung wurden uns 120 Euro in Rechnung gestellt, die auf alle Mietparteien umgelegt werden.
        Damit das nicht wieder passiert, hängt ab sofort im Müllraum eine Übersicht, was in welche Tonne gehört.
        Sperrmüll wie alte Möbel darf nicht im Hof abgestellt werden. \
        Einen kostenlosen Abholtermin können Sie bei der Stadtreinigung online vereinbaren.

        Vielen Dank für Ihre Mithilfe!
        Ihre Hausverwaltung
        """,
        questions: [
            ReadingQuestion(prompt: "What went wrong?",
                            options: ["The bins were stolen", "The rubbish was sorted wrongly", "The bins were emptied too early"],
                            answer: 1, evidence: "in den letzten Wochen wurde der Müll in unserem Haus immer wieder falsch getrennt."),
            ReadingQuestion(prompt: "Who pays the 120 euros?",
                            options: ["All the tenants together", "The property management", "The waste company"],
                            answer: 0,
                            evidence: "Für die Sonderleerung wurden uns 120 Euro in Rechnung gestellt, "
                                + "die auf alle Mietparteien umgelegt werden."),
            ReadingQuestion(prompt: "What should you do with an old sofa?",
                            options: ["Leave it in the courtyard", "Put it next to the yellow bin", "Book a free collection online"],
                            answer: 2, evidence: "Einen kostenlosen Abholtermin können Sie bei der Stadtreinigung online vereinbaren.")
        ])

    static let b2Party = ReadingText(
        id: "b2-party", level: .b2, kind: .chat,
        title: "The team chat at work", detail: "The Christmas party",
        systemImage: "bubble.left.and.bubble.right.fill",
        german: """
        Jana: Kurze Info an alle: Die Weihnachtsfeier ist dieses Jahr am 12. Dezember im Restaurant Zum Anker.
        Jana: Die Firma übernimmt das Essen und die ersten zwei Getränke. Wer mehr trinkt, zahlt selbst.
        Paul: Klingt gut! Ist das direkt nach der Arbeit?
        Jana: Ja, wir treffen uns um 18 Uhr dort. Wer möchte, kann an dem Tag schon um 16 Uhr Feierabend machen.
        Deniz: Ich bin an dem Tag leider auf Dienstreise in Wien. Schade!
        Jana: Oh nein! Dann stoßen wir beim nächsten Teamessen im Januar auf dich an.
        Paul: Gibt es auch vegetarische Gerichte? Ich esse seit Kurzem kein Fleisch mehr.
        Jana: Klar, tragt eure Wünsche bitte bis Freitag in die Tabelle ein, dann gebe ich sie ans Restaurant weiter.
        """,
        questions: [
            ReadingQuestion(prompt: "What does the company pay for?",
                            options: ["Everything", "Only the food", "The food and the first two drinks"],
                            answer: 2, evidence: "Die Firma übernimmt das Essen und die ersten zwei Getränke."),
            ReadingQuestion(prompt: "Why can't Deniz come?",
                            options: ["He's on a business trip", "He's ill", "He's on holiday"],
                            answer: 0, evidence: "Ich bin an dem Tag leider auf Dienstreise in Wien."),
            ReadingQuestion(prompt: "What should everyone do by Friday?",
                            options: ["Pay for their drinks", "Put what they'd like to eat in the table", "Book a table"],
                            answer: 1,
                            evidence: "Klar, tragt eure Wünsche bitte bis Freitag in die Tabelle "
                                + "ein, dann gebe ich sie ans Restaurant weiter.")
        ])

    static let b2FourDays = ReadingText(
        id: "b2-four-days", level: .b2, kind: .article,
        title: "In the news", detail: "A four-day week",
        systemImage: "newspaper.fill",
        german: """
        Vier Tage arbeiten, fünf Tage Gehalt?

        Seit einem Jahr testen mehrere Unternehmen in Deutschland die Vier-Tage-Woche. \
        Die Beschäftigten arbeiten weniger Stunden, bekommen aber das gleiche Gehalt.
        Nun liegen die ersten Ergebnisse vor: Die meisten Teilnehmer fühlen sich weniger gestresst und sind seltener krank.
        Auch die Firmen sind überwiegend zufrieden. Die Produktivität ist kaum gesunken, in einigen Fällen sogar gestiegen.
        Allerdings funktioniert das Modell nicht überall. \
        In der Pflege oder im Handel, wo Schichten besetzt werden müssen, fehlt oft das Personal dafür.
        Kritiker warnen außerdem, dass manche Beschäftigte nun dieselbe Arbeit in weniger Zeit erledigen müssen.
        Ob die Vier-Tage-Woche zum neuen Standard wird, ist daher noch offen.
        """,
        questions: [
            ReadingQuestion(prompt: "How do most of the people in the test feel?",
                            options: ["More stressed", "Less stressed and ill less often", "Bored"],
                            answer: 1,
                            evidence: "Nun liegen die ersten Ergebnisse vor: Die meisten Teilnehmer "
                                + "fühlen sich weniger gestresst und sind seltener krank."),
            ReadingQuestion(prompt: "Where is the model harder to use?",
                            options: ["In care and in shops", "In offices", "In IT companies"],
                            answer: 0,
                            evidence: "In der Pflege oder im Handel, wo Schichten besetzt werden müssen, fehlt oft das Personal dafür."),
            ReadingQuestion(prompt: "What do critics warn about?",
                            options: ["Lower pay", "Fewer jobs", "The same work in less time"],
                            answer: 2,
                            evidence: "Kritiker warnen außerdem, dass manche Beschäftigte nun "
                                + "dieselbe Arbeit in weniger Zeit erledigen müssen.")
        ])

    static let b2Strike = ReadingText(
        id: "b2-strike", level: .b2, kind: .announcement,
        title: "A notice from Deutsche Bahn", detail: "A strike",
        systemImage: "exclamationmark.triangle.fill",
        german: """
        Information zum Streik

        Wegen eines Streiks der Lokführergewerkschaft kommt es von Mittwoch, 2 Uhr, bis Freitag, 18 Uhr, \
        bundesweit zu starken Einschränkungen im Zugverkehr.
        An den Streiktagen gilt ein Notfahrplan. Im Fernverkehr fährt etwa jeder fünfte Zug.
        Wer seine Reise wegen des Streiks verschieben möchte, kann sein Ticket bis eine Woche nach Streikende flexibel nutzen.
        Alternativ können Sie Ihr Ticket kostenlos erstatten lassen.
        Bitte informieren Sie sich vor der Fahrt in der App oder auf unserer Website über Ihre Verbindung.

        Wir bedauern die Unannehmlichkeiten.
        """,
        questions: [
            ReadingQuestion(prompt: "How many long-distance trains run?",
                            options: ["None", "About one in five", "About half"],
                            answer: 1, evidence: "Im Fernverkehr fährt etwa jeder fünfte Zug."),
            ReadingQuestion(prompt: "What can you do with your ticket?",
                            options: ["Use it until a week after the strike", "Only use it on your train", "Nothing"],
                            answer: 0,
                            evidence: "Wer seine Reise wegen des Streiks verschieben möchte, "
                                + "kann sein Ticket bis eine Woche nach Streikende flexibel nutzen."),
            ReadingQuestion(prompt: "Can you get your money back?",
                            options: ["No", "Only half of it", "Yes, at no cost"],
                            answer: 2, evidence: "Alternativ können Sie Ihr Ticket kostenlos erstatten lassen.")
        ])
}
