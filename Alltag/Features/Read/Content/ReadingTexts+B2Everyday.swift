//
//  ReadingTexts+B2Everyday.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension ReadingTexts {
    // B2's texts from family, health, the flat and the car. The list of B2 texts is in `ReadingTexts+B2.swift`.

    static let b2Dentist = ReadingText(
        id: "b2-dentist", level: .b2, kind: .letter,
        title: "A letter from your health insurer", detail: "Who pays for the new crown?",
        systemImage: "cross.case.fill",
        german: """
        Ihr Heil- und Kostenplan vom 14. Oktober

        Sehr geehrte Frau Petrović,

        wir haben den Heil- und Kostenplan Ihrer Zahnarztpraxis für eine neue Krone geprüft und genehmigen die Behandlung.
        Als gesetzlich Versicherte erhalten Sie einen Festzuschuss in Höhe von 60 Prozent der Regelversorgung.
        Da Sie Ihr Bonusheft in den letzten fünf Jahren lückenlos geführt haben, erhöht sich der Zuschuss auf 70 Prozent.
        Den restlichen Betrag sowie die Mehrkosten für eine aufwendigere Versorgung, etwa eine Vollkeramikkrone, \
        tragen Sie selbst.
        Bitte beachten Sie, dass die Genehmigung sechs Monate gültig ist. \
        Wird die Behandlung später begonnen, muss ein neuer Plan eingereicht werden.
        Ihre Zahnarztpraxis rechnet den Zuschuss direkt mit uns ab. \
        Sie erhalten von der Praxis nur eine Rechnung über Ihren Eigenanteil.

        Mit freundlichen Grüßen
        Ihre Gesundheitskasse Nord
        """,
        questions: [
            ReadingQuestion(prompt: "Why does she get 70 percent?",
                            options: ["Her dentist asked for it", "She kept her bonus booklet for five years", "She chose a ceramic crown"],
                            answer: 1,
                            evidence: "Da Sie Ihr Bonusheft in den letzten fünf Jahren lückenlos geführt haben, "
                                + "erhöht sich der Zuschuss auf 70 Prozent."),
            ReadingQuestion(prompt: "What if she starts the treatment in eight months?",
                            options: ["Nothing changes", "She needs a new plan", "She pays for all of it"],
                            answer: 1, evidence: "Wird die Behandlung später begonnen, muss ein neuer Plan eingereicht werden."),
            ReadingQuestion(prompt: "Which bill does the practice send her?",
                            options: ["One for the whole treatment", "None at all", "One for her own share only"],
                            answer: 2, evidence: "Sie erhalten von der Praxis nur eine Rechnung über Ihren Eigenanteil.")
        ])

    static let b2Garage = ReadingText(
        id: "b2-garage", level: .b2, kind: .message,
        title: "A message from the garage", detail: "The brakes need doing",
        systemImage: "car.fill",
        german: """
        Guten Tag Herr Yilmaz, hier ist die Werkstatt Kerber.
        Bei der Inspektion haben wir festgestellt, dass die Bremsbeläge vorne fast verschlissen sind. \
        So kommen Sie im Dezember nicht durch den TÜV.
        Wir würden die Beläge gern gleich mitwechseln. \
        Laut Kostenvoranschlag kostet das inklusive Material und Arbeitszeit rund 240 Euro.
        Die Bremsscheiben sind noch in Ordnung, die sind erst beim nächsten Mal dran.
        Wenn Sie einverstanden sind, geben Sie uns bitte bis 14 Uhr Bescheid. \
        Dann ist der Wagen heute noch fertig, sonst erst morgen Mittag.
        Ohne Ihr Okay machen wir nichts, was über die Inspektion hinausgeht.
        Viele Grüße, Murat Kerber
        """,
        questions: [
            ReadingQuestion(prompt: "What's wrong with the car?",
                            options: ["The tyres are worn", "The front brake pads are almost worn out", "The brake discs must be changed"],
                            answer: 1,
                            evidence: "Bei der Inspektion haben wir festgestellt, dass die Bremsbeläge vorne fast verschlissen sind."),
            ReadingQuestion(prompt: "What must he do to get the car back today?",
                            options: ["Pay 240 euros at once", "Answer by 2 pm", "Come by at noon"],
                            answer: 1, evidence: "Wenn Sie einverstanden sind, geben Sie uns bitte bis 14 Uhr Bescheid."),
            ReadingQuestion(prompt: "What does the garage do if he doesn't answer?",
                            options: ["Only the inspection", "The brakes anyway", "The brakes and the discs"],
                            answer: 0, evidence: "Ohne Ihr Okay machen wir nichts, was über die Inspektion hinausgeht.")
        ])

    static let b2FlatAd = ReadingText(
        id: "b2-flat-ad", level: .b2, kind: .advert,
        title: "A small ad for a flat", detail: "Taking over someone's flat",
        systemImage: "key.fill",
        german: """
        Nachmieter gesucht: 3-Zimmer-Altbau in Leipzig-Gohlis

        Wir ziehen beruflich nach Hamburg und suchen zum 1. Februar Nachmieter für unsere helle Wohnung \
        (78 m², 2. OG, kein Aufzug).
        Die Kaltmiete beträgt 690 Euro, hinzu kommen rund 210 Euro Nebenkosten. Die Kaution liegt bei drei Kaltmieten.
        Die Einbauküche ist erst zwei Jahre alt. \
        Wir würden sie gern für 1.800 Euro an die Nachmieter abgeben, das ist aber keine Bedingung.
        Die Wohnung liegt ruhig zum Hof und hat einen Balkon. Haustiere sind nach Absprache mit dem Vermieter erlaubt.
        Bitte beachten: Der Vermieter entscheidet am Ende selbst, wer den Vertrag bekommt. \
        Er verlangt eine Schufa-Auskunft und die letzten drei Gehaltsnachweise.
        Besichtigung am Samstag, 9. Januar, zwischen 11 und 13 Uhr. Bitte melden Sie sich vorher kurz per Nachricht an.
        """,
        questions: [
            ReadingQuestion(prompt: "Do you have to buy the kitchen?",
                            options: ["Yes, for 1,800 euros", "No, it isn't a condition", "Only if you have pets"],
                            answer: 1,
                            evidence: "Wir würden sie gern für 1.800 Euro an die Nachmieter abgeben, das ist aber keine Bedingung."),
            ReadingQuestion(prompt: "Who decides who gets the flat?",
                            options: ["The people moving out", "The landlord", "Whoever comes to the viewing first"],
                            answer: 1, evidence: "Der Vermieter entscheidet am Ende selbst, wer den Vertrag bekommt."),
            ReadingQuestion(prompt: "What do you have to show?",
                            options: ["A credit report and three pay slips", "A letter from your old landlord", "Only your passport"],
                            answer: 0, evidence: "Er verlangt eine Schufa-Auskunft und die letzten drei Gehaltsnachweise.")
        ])

    static let b2Canteen = ReadingText(
        id: "b2-canteen", level: .b2, kind: .menu,
        title: "The canteen at work", detail: "Lunch this week",
        systemImage: "fork.knife",
        german: """
        Betriebsrestaurant · Wochenkarte

        Montag: Linsensuppe mit Würstchen, auch vegan mit Räuchertofu – 4,20 €
        Dienstag: Hähnchen-Curry mit Basmatireis – 5,80 €
        Mittwoch: Kürbisrisotto mit Parmesan (vegetarisch) – 5,20 €
        Donnerstag: Schweinebraten mit Klößen und Rotkohl – 6,10 €
        Freitag: Seelachsfilet mit Kartoffelsalat – 5,90 €

        Die Preise gelten für Mitarbeitende. Gäste zahlen einen Aufschlag von 2,50 € pro Gericht.
        Bitte zahlen Sie bargeldlos mit Ihrem Firmenausweis. Bargeld wird nicht mehr angenommen.
        Wegen eines Lieferengpasses kann es am Donnerstag zu Änderungen kommen.
        Angaben zu Allergenen erhalten Sie an der Ausgabe oder im Intranet.
        Lunchpakete für Dienstreisen bestellen Sie bitte bis 10 Uhr am Vortag.
        """,
        questions: [
            ReadingQuestion(prompt: "You bring a visitor. What do they pay for the curry?",
                            options: ["5.80 euros", "8.30 euros", "2.50 euros"],
                            answer: 1, evidence: "Gäste zahlen einen Aufschlag von 2,50 € pro Gericht."),
            ReadingQuestion(prompt: "How do you pay?",
                            options: ["In cash", "With your company ID card", "By bank transfer"],
                            answer: 1, evidence: "Bitte zahlen Sie bargeldlos mit Ihrem Firmenausweis."),
            ReadingQuestion(prompt: "You travel for work on Wednesday. When do you order a packed lunch?",
                            options: ["By 10 am on Tuesday", "On Wednesday morning", "On Monday in the intranet"],
                            answer: 0, evidence: "Lunchpakete für Dienstreisen bestellen Sie bitte bis 10 Uhr am Vortag.")
        ])

    static let b2Nursery = ReadingText(
        id: "b2-nursery", level: .b2, kind: .email,
        title: "An email from the nursery", detail: "Closed for a strike",
        systemImage: "figure.and.child.holdinghands",
        german: """
        Warnstreik am Donnerstag: Notbetreuung

        Liebe Eltern,

        die Gewerkschaft hat für Donnerstag, den 26. November, zu einem ganztägigen Warnstreik im öffentlichen Dienst \
        aufgerufen. Auch ein Großteil unseres Teams wird sich daran beteiligen.
        Die Kita bleibt an diesem Tag deshalb geschlossen. Wir bieten lediglich eine Notbetreuung für höchstens 15 Kinder an.
        Vorrang haben Kinder von Alleinerziehenden und von Eltern, die beide in der Pflege, bei der Polizei \
        oder bei der Feuerwehr arbeiten.
        Wenn Sie die Notbetreuung brauchen, geben Sie bitte das angehängte Formular bis Dienstag, 12 Uhr, im Büro ab. \
        Eine Bescheinigung Ihres Arbeitgebers ist beizulegen.
        Die Elternbeiträge für den Streiktag können leider nicht erstattet werden.
        Wir wissen, dass das für viele Familien eine Belastung ist, und danken Ihnen für Ihr Verständnis.

        Herzliche Grüße
        Ihr Team der Kita Sonnenblume
        """,
        questions: [
            ReadingQuestion(prompt: "How many children can come on the strike day?",
                            options: ["None", "Up to 15", "All whose parents work"],
                            answer: 1, evidence: "Wir bieten lediglich eine Notbetreuung für höchstens 15 Kinder an."),
            ReadingQuestion(prompt: "Whose children get a place first?",
                            options: ["Those who register online first", "The youngest children", "Single parents' and some key workers'"],
                            answer: 2,
                            evidence: "Vorrang haben Kinder von Alleinerziehenden und von Eltern, die beide in der Pflege, bei der Polizei "
                                + "oder bei der Feuerwehr arbeiten."),
            ReadingQuestion(prompt: "What must parents hand in with the form?",
                            options: ["A doctor's note", "A letter from their employer", "The fee for the day"],
                            answer: 1, evidence: "Eine Bescheinigung Ihres Arbeitgebers ist beizulegen.")
        ])

    static let b2Gym = ReadingText(
        id: "b2-gym", level: .b2, kind: .letter,
        title: "A letter from the gym", detail: "Your cancellation",
        systemImage: "dumbbell.fill",
        german: """
        Bestätigung Ihrer Kündigung

        Sehr geehrter Herr Nowak,

        wir bestätigen den Eingang Ihrer Kündigung vom 3. November.
        Leider können wir sie nicht wie gewünscht zum 30. November umsetzen. \
        Ihr Vertrag hat eine Mindestlaufzeit von 24 Monaten und endet daher frühestens am 31. März.
        Bis dahin wird der Monatsbeitrag von 34,90 Euro weiterhin von Ihrem Konto abgebucht. \
        Selbstverständlich können Sie das Studio bis zum Vertragsende uneingeschränkt nutzen.
        Eine vorzeitige Kündigung ist nur aus wichtigem Grund möglich, zum Beispiel bei einem Umzug von mehr als \
        30 Kilometern oder einer längeren Krankheit. In diesem Fall benötigen wir einen Nachweis, etwa eine \
        Meldebescheinigung oder ein ärztliches Attest.
        Alternativ bieten wir Ihnen an, Ihre Mitgliedschaft für bis zu drei Monate kostenlos ruhen zu lassen.

        Mit sportlichen Grüßen
        Ihr FitWerk-Team
        """,
        questions: [
            ReadingQuestion(prompt: "When does his contract end?",
                            options: ["On 30 November", "On 31 March at the earliest", "In 24 months"],
                            answer: 1,
                            evidence: "Ihr Vertrag hat eine Mindestlaufzeit von 24 Monaten und endet daher frühestens am 31. März."),
            ReadingQuestion(prompt: "What would let him leave earlier?",
                            options: ["Paying a fee", "Not going any more", "Moving over 30 km away, with proof"],
                            answer: 2,
                            evidence: "Eine vorzeitige Kündigung ist nur aus wichtigem Grund möglich, "
                                + "zum Beispiel bei einem Umzug von mehr als 30 Kilometern oder einer längeren Krankheit."),
            ReadingQuestion(prompt: "What does the gym offer him instead?",
                            options: ["A cheaper contract", "A free break of up to three months", "A personal trainer"],
                            answer: 1,
                            evidence: "Alternativ bieten wir Ihnen an, "
                                + "Ihre Mitgliedschaft für bis zu drei Monate kostenlos ruhen zu lassen.")
        ])

    static let b2ClassTrip = ReadingText(
        id: "b2-class-trip", level: .b2, kind: .chat,
        title: "The parents' chat", detail: "The class trip",
        systemImage: "bubble.left.and.bubble.right.fill",
        german: """
        Frau Berger: Liebe Eltern, die Klassenfahrt an die Ostsee findet vom 10. bis 14. Mai statt. \
        Sie kostet 285 Euro pro Kind.
        Frau Berger: Bitte überweisen Sie bis zum 31. Januar eine Anzahlung von 100 Euro, den Rest bis Ende März.
        Anna: Danke! Ist die Zugfahrt schon im Preis enthalten?
        Frau Berger: Ja, Anreise, Unterkunft mit Vollpension und alle Ausflüge sind inklusive. \
        Nur Taschengeld bringen die Kinder selbst mit, höchstens 30 Euro.
        Mehmet: Falls es für jemanden finanziell eng wird: Wer zum Beispiel Wohngeld bekommt, \
        kann die Kosten über Bildung und Teilhabe übernehmen lassen.
        Frau Berger: Guter Hinweis, danke! Das Formular gibt es im Sekretariat. \
        Stellen Sie den Antrag am besten früh, denn die Bearbeitung dauert ein paar Wochen.
        Sabine: Gibt es vorher noch einen Elternabend? Ich hätte ein paar Fragen zur Aufsicht am Strand.
        Frau Berger: Ja, am 11. März um 19 Uhr in Raum 104. Dort klären wir alles Weitere.
        """,
        questions: [
            ReadingQuestion(prompt: "How much do parents pay by the end of January?",
                            options: ["285 euros", "100 euros", "30 euros"],
                            answer: 1,
                            evidence: "Bitte überweisen Sie bis zum 31. Januar eine Anzahlung von 100 Euro, den Rest bis Ende März."),
            ReadingQuestion(prompt: "What isn't in the price?",
                            options: ["The train", "The meals", "Pocket money"],
                            answer: 2, evidence: "Nur Taschengeld bringen die Kinder selbst mit, höchstens 30 Euro."),
            ReadingQuestion(prompt: "Why should parents apply for help early?",
                            options: ["It takes a few weeks", "The money runs out", "The office closes in March"],
                            answer: 0, evidence: "Stellen Sie den Antrag am besten früh, denn die Bearbeitung dauert ein paar Wochen.")
        ])

    static let b2Recognition = ReadingText(
        id: "b2-recognition", level: .b2, kind: .article,
        title: "In the news", detail: "Qualifications from abroad",
        systemImage: "newspaper.fill",
        german: """
        Fachkräfte warten oft lange auf die Anerkennung

        Deutschland sucht dringend Fachkräfte, doch wer seinen Berufsabschluss im Ausland erworben hat, braucht häufig viel Geduld.
        Ärztinnen, Pflegekräfte oder Erzieher dürfen in Deutschland erst dann in ihrem Beruf arbeiten, \
        wenn ihr Abschluss offiziell anerkannt ist.
        Nicht selten dauert das Verfahren mehrere Monate, in manchen Fällen sogar über ein Jahr.
        Ein Grund dafür ist, dass jedes Bundesland eigene Stellen hat, die die Unterlagen prüfen. \
        Zudem müssen Zeugnisse oft übersetzt und beglaubigt werden, was zusätzlich Zeit und Geld kostet.
        Wird ein Abschluss nur teilweise anerkannt, können die Betroffenen eine Anpassungsmaßnahme oder eine Prüfung machen, \
        um die Unterschiede auszugleichen.
        Die Bundesregierung will die Verfahren nun stärker digitalisieren. \
        Fachverbände fordern außerdem, dass Bewerber schon während des Verfahrens in ihrem Bereich arbeiten dürfen, \
        etwa als Hilfskraft.
        """,
        questions: [
            ReadingQuestion(prompt: "When can a nurse from abroad work as a nurse in Germany?",
                            options: ["Straight away", "Once her qualification is recognised", "After a year in Germany"],
                            answer: 1,
                            evidence: "Ärztinnen, Pflegekräfte oder Erzieher dürfen in Deutschland erst dann in ihrem Beruf arbeiten, "
                                + "wenn ihr Abschluss offiziell anerkannt ist."),
            ReadingQuestion(prompt: "Why does it take so long?",
                            options: ["Each federal state has its own offices", "Too few people apply", "The exams are once a year"],
                            answer: 0,
                            evidence: "Ein Grund dafür ist, dass jedes Bundesland eigene Stellen hat, die die Unterlagen prüfen."),
            ReadingQuestion(prompt: "What if a qualification is only partly recognised?",
                            options: ["You must study again", "You can't work in Germany", "A course or an exam makes up the gap"],
                            answer: 2,
                            evidence: "Wird ein Abschluss nur teilweise anerkannt, können die Betroffenen eine Anpassungsmaßnahme "
                                + "oder eine Prüfung machen, um die Unterschiede auszugleichen.")
        ])
}
