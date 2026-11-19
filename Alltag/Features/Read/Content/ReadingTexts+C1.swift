//
//  ReadingTexts+C1.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension ReadingTexts {
    /// C1: official letters, news, debates and everyday life in dense German, about 130 to 190 words.
    /// The texts from daily life are in `ReadingTexts+C1Life.swift`.
    static let c1: [ReadingText] = [
        c1Tax, c1WaterDamage, c1Permit, c1Inn, c1Consultation, c1JobAd,
        c1Solar, c1BikeInsurance, c1RentCap, c1OfficeDays, c1Sleep, c1Delays
    ]

    static let c1Tax = ReadingText(
        id: "c1-tax", level: .c1, kind: .letter,
        title: "A letter from the tax office", detail: "Your tax assessment",
        systemImage: "doc.text.fill",
        german: """
        Bescheid für 2025 über Einkommensteuer

        Sehr geehrte Frau Nowak,
        die Festsetzung weicht von Ihrer Steuererklärung ab. \
        Die geltend gemachten Kosten für Ihr häusliches Arbeitszimmer konnten nur teilweise anerkannt werden, \
        da das Zimmer nach Ihren Angaben auch privat genutzt wird.
        Stattdessen wurde die Homeoffice-Pauschale für 180 Tage berücksichtigt.
        Es ergibt sich eine Erstattung in Höhe von 412 Euro, die in den nächsten Tagen auf Ihr Konto überwiesen wird.
        Gegen diesen Bescheid können Sie innerhalb eines Monats nach Bekanntgabe Einspruch einlegen. \
        Der Einspruch ist schriftlich oder elektronisch über ELSTER einzureichen und sollte begründet werden.
        Bitte bewahren Sie diesen Bescheid sorgfältig auf.

        Mit freundlichen Grüßen
        Ihr Finanzamt
        """,
        questions: [
            ReadingQuestion(prompt: "Why was the study only partly accepted?",
                            options: ["She didn't send receipts", "The room is also used privately", "She works fewer than 180 days"],
                            answer: 1,
                            evidence: "Die geltend gemachten Kosten für Ihr häusliches Arbeitszimmer "
                                + "konnten nur teilweise anerkannt werden, "
                                + "da das Zimmer nach Ihren Angaben auch privat genutzt wird."),
            ReadingQuestion(prompt: "What happens with the 412 euros?",
                            options: ["She gets them back", "She has to pay them", "They are kept until the appeal"],
                            answer: 0,
                            evidence: "Es ergibt sich eine Erstattung in Höhe von 412 Euro, "
                                + "die in den nächsten Tagen auf Ihr Konto überwiesen wird."),
            ReadingQuestion(prompt: "How long does she have to object?",
                            options: ["Two weeks", "Until the end of the year", "One month"],
                            answer: 2,
                            evidence: "Gegen diesen Bescheid können Sie innerhalb eines Monats nach Bekanntgabe Einspruch einlegen.")
        ])

    static let c1Permit = ReadingText(
        id: "c1-permit", level: .c1, kind: .email,
        title: "An email from the immigration office", detail: "Renewing your residence permit",
        systemImage: "person.text.rectangle.fill",
        german: """
        Sehr geehrter Herr Mensah,

        Ihr Aufenthaltstitel läuft am 31. März ab. Um eine lückenlose Verlängerung zu gewährleisten, \
        bitten wir Sie, spätestens sechs Wochen vor Ablauf einen Termin über unser Online-Portal zu vereinbaren.
        Zum Termin bringen Sie bitte Ihren gültigen Reisepass, ein aktuelles biometrisches Lichtbild, \
        einen Nachweis Ihrer Krankenversicherung sowie Ihre Gehaltsabrechnungen der letzten drei Monate mit.
        Sollten sich Ihr Arbeitgeber oder Ihre Wohnanschrift seit der letzten Erteilung geändert haben, \
        reichen Sie die entsprechenden Unterlagen bitte vorab per E-Mail ein.
        Wird der Antrag rechtzeitig gestellt, gilt Ihr bisheriger Aufenthaltstitel bis zur Entscheidung als fortbestehend. \
        Sie dürfen in dieser Zeit also weiterhin arbeiten.

        Mit freundlichen Grüßen
        Ausländerbehörde, Team Fachkräfte
        """,
        questions: [
            ReadingQuestion(prompt: "When should Herr Mensah book an appointment?",
                            options: ["Six weeks before it runs out, at the latest", "After 31 March", "Only once he is asked again"],
                            answer: 0,
                            evidence: "Um eine lückenlose Verlängerung zu gewährleisten, bitten wir Sie, "
                                + "spätestens sechs Wochen vor Ablauf einen Termin über unser Online-Portal zu vereinbaren."),
            ReadingQuestion(prompt: "What must he send in advance?",
                            options: ["His passport", "Papers about a new employer or address", "His last three payslips"],
                            answer: 1,
                            evidence: "Sollten sich Ihr Arbeitgeber oder Ihre Wohnanschrift seit der letzten Erteilung geändert haben, "
                                + "reichen Sie die entsprechenden Unterlagen bitte vorab per E-Mail ein."),
            ReadingQuestion(prompt: "What if the decision takes longer than his permit?",
                            options: ["He must stop working", "He has to leave the country", "His old permit stays valid"],
                            answer: 2,
                            evidence: "Wird der Antrag rechtzeitig gestellt, "
                                + "gilt Ihr bisheriger Aufenthaltstitel bis zur Entscheidung als fortbestehend.")
        ])

    static let c1Consultation = ReadingText(
        id: "c1-consultation", level: .c1, kind: .notice,
        title: "A notice from the council", detail: "Have your say on the park",
        systemImage: "tree.fill",
        german: """
        Bürgerbeteiligung: Wie soll der Stadtpark künftig aussehen?

        Der Stadtpark soll in den kommenden zwei Jahren umgestaltet werden. \
        Anlass sind die zunehmend heißen Sommer, unter denen insbesondere die alten Bäume leiden.
        Geplant sind unter anderem zusätzliche Schattenplätze, ein Wasserspielplatz \
        und mehr Flächen, auf denen Regenwasser versickern kann.
        Bevor die Pläne beschlossen werden, möchte die Stadt die Meinungen der Anwohnerinnen und Anwohner einholen.
        Vom 1. bis zum 30. April können Sie Ihre Vorschläge auf der Beteiligungsplattform der Stadt einreichen.
        Darüber hinaus findet am 15. April um 18 Uhr eine öffentliche Informationsveranstaltung im Rathaus statt.
        Die Ergebnisse der Beteiligung werden ausgewertet und dem Stadtrat vorgelegt, \
        der im Sommer über den endgültigen Entwurf entscheidet.
        """,
        questions: [
            ReadingQuestion(prompt: "Why is the park being redesigned?",
                            options: ["There are too few visitors", "Hotter summers are harming the trees", "A new road is planned"],
                            answer: 1,
                            evidence: "Anlass sind die zunehmend heißen Sommer, unter denen insbesondere die alten Bäume leiden."),
            ReadingQuestion(prompt: "How can residents take part?",
                            options: ["By sending ideas on the city's platform in April", "By voting in the summer",
                                      "Only by writing to the mayor"],
                            answer: 0,
                            evidence: "Vom 1. bis zum 30. April können Sie Ihre Vorschläge "
                                + "auf der Beteiligungsplattform der Stadt einreichen."),
            ReadingQuestion(prompt: "Who makes the final decision?",
                            options: ["The residents", "The park's gardeners", "The city council"],
                            answer: 2,
                            evidence: "Die Ergebnisse der Beteiligung werden ausgewertet und dem Stadtrat vorgelegt, "
                                + "der im Sommer über den endgültigen Entwurf entscheidet.")
        ])

    static let c1Solar = ReadingText(
        id: "c1-solar", level: .c1, kind: .chat,
        title: "The owners' group chat", detail: "Solar panels on the roof?",
        systemImage: "bubble.left.and.bubble.right.fill",
        german: """
        Herr Albers: Wie angekündigt, hier das Angebot für die Solaranlage auf unserem Dach: rund 48.000 Euro für alle sechs Parteien.
        Frau Demir: Danke! Wie lange würde es dauern, bis sich das rechnet?
        Herr Albers: Laut Gutachten etwa zwölf Jahre, vorausgesetzt, die Strompreise bleiben auf dem heutigen Niveau.
        Frau Petrov: Ehrlich gesagt bin ich skeptisch. Das Dach muss in spätestens fünf Jahren ohnehin saniert werden.
        Herr Albers: Berechtigter Einwand. Dann müsste die Anlage ab- und wieder aufgebaut werden, das kostet zusätzlich.
        Frau Demir: Wäre es nicht sinnvoller, beides zusammen zu machen und dafür die Förderung der KfW zu beantragen?
        Frau Petrov: Damit könnte ich leben, sofern die monatliche Belastung überschaubar bleibt.
        Herr Albers: Gut, dann lasse ich ein zweites Angebot für Dach und Anlage zusammen erstellen und wir stimmen bei der Versammlung ab.
        """,
        questions: [
            ReadingQuestion(prompt: "Why is Frau Petrov sceptical?",
                            options: ["Solar panels are ugly", "The roof needs repairing within five years anyway", "She is moving out"],
                            answer: 1,
                            evidence: "Das Dach muss in spätestens fünf Jahren ohnehin saniert werden."),
            ReadingQuestion(prompt: "What does Frau Demir suggest?",
                            options: ["Doing both at once and applying for funding", "Waiting for lower prices", "Asking another expert"],
                            answer: 0,
                            evidence: "Wäre es nicht sinnvoller, beides zusammen zu machen "
                                + "und dafür die Förderung der KfW zu beantragen?"),
            ReadingQuestion(prompt: "What will happen next?",
                            options: ["The panels are ordered at once", "Frau Petrov sells her flat",
                                      "A new quote, then a vote at the meeting"],
                            answer: 2,
                            evidence: "Gut, dann lasse ich ein zweites Angebot für Dach und Anlage zusammen erstellen "
                                + "und wir stimmen bei der Versammlung ab.")
        ])

    static let c1RentCap = ReadingText(
        id: "c1-rent-cap", level: .c1, kind: .article,
        title: "In the news", detail: "Does the rent cap work?",
        systemImage: "newspaper.fill",
        german: """
        Mietpreisbremse: Wirkung umstritten

        Seit ihrer Einführung soll die Mietpreisbremse verhindern, dass Mieten bei neuen Verträgen übermäßig steigen. \
        In angespannten Wohnungsmärkten darf die Miete höchstens zehn Prozent über der ortsüblichen Vergleichsmiete liegen.
        Eine neue Studie kommt nun zu einem gemischten Ergebnis. \
        Zwar sei der Anstieg der Mieten in den betroffenen Städten leicht gebremst worden, \
        doch würden viele Vermieter die Regeln schlicht ignorieren.
        Das Problem: Mieter müssen selbst aktiv werden und eine zu hohe Miete rügen. \
        Aus Angst vor Konflikten mit dem Vermieter verzichten jedoch die meisten darauf.
        Kritiker aus der Wohnungswirtschaft argumentieren hingegen, die Regelung schrecke Investoren ab \
        und verschärfe dadurch langfristig den Mangel an Wohnraum.
        Einig sind sich beide Seiten nur in einem Punkt: Ohne deutlich mehr Neubau wird sich die Lage nicht entspannen.
        """,
        questions: [
            ReadingQuestion(prompt: "What does the study find?",
                            options: ["Rents have fallen sharply", "Rents rise a little more slowly, but many landlords ignore the rules",
                                      "The rule has no effect at all"],
                            answer: 1,
                            evidence: "Zwar sei der Anstieg der Mieten in den betroffenen Städten leicht gebremst worden, "
                                + "doch würden viele Vermieter die Regeln schlicht ignorieren."),
            ReadingQuestion(prompt: "Why do most tenants not complain about rent that is too high?",
                            options: ["They fear trouble with their landlord", "It costs too much", "They don't know the rule"],
                            answer: 0,
                            evidence: "Aus Angst vor Konflikten mit dem Vermieter verzichten jedoch die meisten darauf."),
            ReadingQuestion(prompt: "What do both sides agree on?",
                            options: ["The rule should go", "Rents must be frozen", "Many more new homes are needed"],
                            answer: 2,
                            evidence: "Einig sind sich beide Seiten nur in einem Punkt: "
                                + "Ohne deutlich mehr Neubau wird sich die Lage nicht entspannen.")
        ])

    static let c1Sleep = ReadingText(
        id: "c1-sleep", level: .c1, kind: .article,
        title: "A science article", detail: "Sleep and memory",
        systemImage: "moon.zzz.fill",
        german: """
        Lernen im Schlaf? Was die Forschung wirklich sagt

        Dass Schlaf für das Gedächtnis wichtig ist, gilt inzwischen als gesichert. \
        Während wir schlafen, werden die Erfahrungen des Tages im Gehirn erneut abgespielt und gefestigt.
        Forscher aus Tübingen konnten nun zeigen, dass besonders die Tiefschlafphasen in der ersten Nachthälfte entscheidend sind.
        Versuchspersonen, die abends neue Vokabeln gelernt und danach normal geschlafen hatten, \
        erinnerten sich am nächsten Morgen an deutlich mehr Wörter als jene, die wach geblieben waren.
        Neues Wissen im Schlaf aufzunehmen, etwa durch Hörbücher, funktioniert dagegen nicht. \
        Das Gehirn kann zwar Gelerntes festigen, aber kaum Neues speichern.
        Die Forscher raten deshalb, schwierigen Stoff am Abend zu wiederholen und nicht die Nacht durchzulernen.
        """,
        questions: [
            ReadingQuestion(prompt: "Which part of the night matters most, according to the study?",
                            options: ["The early morning", "Dreaming just before waking", "Deep sleep in the first half"],
                            answer: 2,
                            evidence: "Forscher aus Tübingen konnten nun zeigen, "
                                + "dass besonders die Tiefschlafphasen in der ersten Nachthälfte entscheidend sind."),
            ReadingQuestion(prompt: "Can you learn new words from an audiobook while you sleep?",
                            options: ["No, the brain hardly stores anything new", "Yes, if it's quiet", "Only in deep sleep"],
                            answer: 0,
                            evidence: "Neues Wissen im Schlaf aufzunehmen, etwa durch Hörbücher, funktioniert dagegen nicht."),
            ReadingQuestion(prompt: "What do the researchers advise?",
                            options: ["Studying through the night", "Going over difficult things in the evening",
                                      "Sleeping less, but deeply"],
                            answer: 1,
                            evidence: "Die Forscher raten deshalb, schwierigen Stoff am Abend "
                                + "zu wiederholen und nicht die Nacht durchzulernen.")
        ])
}
