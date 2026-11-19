//
//  ReadingTexts+C2.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension ReadingTexts {
    /// C2: German as natives read it, between the lines: a coded job reference,
    /// a lawyer's notice, a summons, corporate euphemism, a public order, a family
    /// arguing, a voice message in slang, a tasting menu, an estate agent's ad, a
    /// court's press release, a satirical column and a book review.
    static let c2: [ReadingText] = [
        c2Reference, c2Eviction, c2Care, c2Tasting,
        c2VoiceMessage, c2Fireworks, c2FlatAd, c2Restructuring,
        c2Summons, c2Column, c2HolidayRuling, c2Review
    ]

    static let c2Reference = ReadingText(
        id: "c2-reference", level: .c2, kind: .email,
        title: "An email about your job reference", detail: "What it really says",
        systemImage: "doc.text.magnifyingglass",
        german: """
        Betreff: Dein Zeugnis – ehrliche Einschätzung

        Liebe Sara,
        ich habe mir dein Zeugnis gestern Abend in Ruhe angesehen, und um es vorwegzunehmen: \
        Es ist besser, als du befürchtest, aber nicht so gut, wie es klingt.
        Die Leistungsbeurteilung ist an sich solide. \
        „Stets zu unserer vollen Zufriedenheit“ entspricht im Zeugnisdeutsch einer guten Zwei; \
        für die Bestnote hätte es „vollsten“ heißen müssen, so absurd dieser Superlativ auch ist.
        Stutzig gemacht hat mich etwas anderes: Dein Verhalten gegenüber Vorgesetzten wird gelobt, \
        deine Kolleginnen und Kollegen tauchen dagegen mit keinem Wort auf. \
        Wer Zeugnisse zu lesen weiß, sieht in so einer Auslassung einen Hinweis auf Spannungen im Team.
        Auch der Schlusssatz ist auffallend knapp. \
        Es fehlen sowohl der Dank für die Zusammenarbeit als auch das Bedauern über dein Ausscheiden, \
        was Personaler durchaus als Distanzierung lesen.
        Mein Rat: Bitte die Personalabteilung freundlich, aber bestimmt um eine Berichtigung. \
        Du hast Anspruch auf ein wohlwollendes Zeugnis, \
        und ein fehlender Satz lässt sich in der Regel ohne großes Aufheben ergänzen.
        Wenn du magst, setzen wir das Schreiben am Wochenende zusammen auf.

        Herzliche Grüße
        Katrin
        """,
        questions: [
            ReadingQuestion(prompt: "How good is Sara's rating for her work, according to Katrin?",
                            options: ["The best possible", "Good, but not the top grade", "Barely adequate"],
                            answer: 1,
                            evidence: "„Stets zu unserer vollen Zufriedenheit“ entspricht im Zeugnisdeutsch einer guten Zwei;"),
            ReadingQuestion(prompt: "What worries Katrin most?",
                            options: ["The reference is far too long", "Her boss is criticised",
                                      "Her colleagues aren't mentioned at all"],
                            answer: 2,
                            evidence: "deine Kolleginnen und Kollegen tauchen dagegen mit keinem Wort auf."),
            ReadingQuestion(prompt: "What does Katrin advise?",
                            options: ["Politely but firmly asking HR to correct it", "Accepting it as it is",
                                      "Taking the company to court at once"],
                            answer: 0,
                            evidence: "Bitte die Personalabteilung freundlich, aber bestimmt um eine Berichtigung.")
        ])

    static let c2Eviction = ReadingText(
        id: "c2-eviction", level: .c2, kind: .letter,
        title: "A letter from your landlord's lawyer", detail: "Notice to leave: he needs the flat",
        systemImage: "house.fill",
        german: """
        Kündigung des Mietverhältnisses wegen Eigenbedarfs

        Sehr geehrte Frau Lindqvist,
        hiermit zeigen wir an, dass wir Ihren Vermieter, Herrn Dr. Martin Haller, anwaltlich vertreten; \
        eine auf uns lautende Vollmacht fügen wir bei.
        Namens und in Vollmacht unseres Mandanten kündigen wir das mit Ihnen bestehende Mietverhältnis \
        über die Wohnung Gneisenaustraße 41, 2. OG rechts, fristgerecht zum 31. August 2027.
        Unser Mandant benötigt die Wohnung für seine Tochter, die im kommenden Jahr ihr Studium in Berlin aufnimmt \
        und bislang bei ihm in München lebt. Eine vergleichbare Wohnung steht ihm im Haus nicht zur Verfügung.
        Wir weisen Sie darauf hin, dass Sie der Kündigung widersprechen und die Fortsetzung des Mietverhältnisses verlangen können, \
        wenn dessen Beendigung für Sie oder Ihre Familie eine nicht zu rechtfertigende Härte bedeuten würde.
        Der Widerspruch bedarf der Schriftform \
        und muss unserem Mandanten spätestens zwei Monate vor Ablauf der Kündigungsfrist zugehen.
        Unser Mandant ist darüber hinaus bereit, Ihnen bei einem Auszug vor dem genannten Termin \
        die Umzugskosten bis zu einem Betrag von 3.000 Euro zu erstatten.

        Mit freundlichen Grüßen
        Dr. Sabine Wernicke, Rechtsanwältin
        """,
        questions: [
            ReadingQuestion(prompt: "Why does the landlord want the flat back?",
                            options: ["To sell it", "For his daughter, who is starting university", "To renovate it"],
                            answer: 1,
                            evidence: "Unser Mandant benötigt die Wohnung für seine Tochter, "
                                + "die im kommenden Jahr ihr Studium in Berlin aufnimmt"),
            ReadingQuestion(prompt: "On what grounds can Frau Lindqvist object?",
                            options: ["If moving out would be an unjustifiable hardship", "If she has always paid on time",
                                      "If the lawyer's letter came late"],
                            answer: 0,
                            evidence: "wenn dessen Beendigung für Sie oder Ihre Familie "
                                + "eine nicht zu rechtfertigende Härte bedeuten würde."),
            ReadingQuestion(prompt: "What is she offered if she leaves early?",
                            options: ["A cheaper flat in the building", "Three months without rent",
                                      "Up to 3,000 euros towards the move"],
                            answer: 2,
                            evidence: "die Umzugskosten bis zu einem Betrag von 3.000 Euro zu erstatten.")
        ])

    static let c2Summons = ReadingText(
        id: "c2-summons", level: .c2, kind: .letter,
        title: "A summons from the district court", detail: "You're called as a witness",
        systemImage: "building.columns.fill",
        german: """
        Ladung als Zeugin

        Amtsgericht Köln, Strafsache gegen Herrn T. wegen fahrlässiger Körperverletzung, Az. 523 Ds 117/26
        Sehr geehrte Frau Okafor,
        in oben genannter Strafsache werden Sie als Zeugin zur Hauptverhandlung \
        am Dienstag, 12. Januar 2027, um 9:30 Uhr, Saal 112, geladen.
        Gegenstand Ihrer Vernehmung ist der Verkehrsunfall vom 3. Juli 2026 \
        an der Kreuzung Aachener Straße / Innere Kanalstraße, den Sie beobachtet haben.
        Sie sind zum Erscheinen verpflichtet. Bleiben Sie ohne genügende Entschuldigung aus, \
        können Ihnen die durch Ihr Ausbleiben verursachten Kosten auferlegt und ein Ordnungsgeld festgesetzt werden.
        Sind Sie aus wichtigem Grund verhindert, etwa wegen Krankheit, \
        teilen Sie dies dem Gericht bitte unverzüglich unter Angabe des Aktenzeichens mit und fügen Sie einen Nachweis bei.
        Notizen, Fotos oder andere Unterlagen, die Ihnen die Erinnerung an den Vorfall erleichtern, dürfen Sie mitbringen.
        Für Verdienstausfall und Fahrtkosten werden Sie nach dem Justizvergütungs- und -entschädigungsgesetz entschädigt; \
        den Antrag erhalten Sie nach der Verhandlung bei der Geschäftsstelle.

        Auf Anordnung
        Schulte, Justizbeschäftigte
        """,
        questions: [
            ReadingQuestion(prompt: "What will she be asked about?",
                            options: ["An accident she caused herself", "A traffic accident she saw", "A dispute at her work"],
                            answer: 1,
                            evidence: "Gegenstand Ihrer Vernehmung ist der Verkehrsunfall vom 3. Juli 2026"),
            ReadingQuestion(prompt: "What can happen if she simply doesn't turn up?",
                            options: ["Nothing: being a witness is voluntary", "The trial is simply moved",
                                      "She may have to pay the costs and a fine"],
                            answer: 2,
                            evidence: "können Ihnen die durch Ihr Ausbleiben verursachten Kosten auferlegt "
                                + "und ein Ordnungsgeld festgesetzt werden."),
            ReadingQuestion(prompt: "May she bring the photos she took that day?",
                            options: ["Yes, notes and photos are allowed", "No, she must speak from memory",
                                      "Only if the judge agrees in writing first"],
                            answer: 0,
                            evidence: "Notizen, Fotos oder andere Unterlagen, die Ihnen die Erinnerung an den Vorfall erleichtern, "
                                + "dürfen Sie mitbringen.")
        ])

    static let c2Restructuring = ReadingText(
        id: "c2-restructuring", level: .c2, kind: .email,
        title: "An email from the management", detail: "A “realignment” of the company",
        systemImage: "briefcase.fill",
        german: """
        Betreff: Neuaufstellung unseres Bereichs – nächste Schritte

        Liebe Kolleginnen und Kollegen,
        wie in der Betriebsversammlung angekündigt, \
        werden wir unsere Strukturen in den kommenden Monaten konsequent an die veränderte Marktlage anpassen.
        Im Zuge dieser Neuaufstellung werden die Teams Vertrieb Nord und Vertrieb Süd zum 1. April \
        unter einer gemeinsamen Leitung zusammengeführt. Dabei lassen sich Doppelstrukturen nicht vermeiden, \
        was bedauerlicherweise auch Auswirkungen auf die Zahl der Stellen haben wird.
        Uns ist bewusst, dass diese Nachricht Fragen und auch Sorgen auslöst. \
        Gemeinsam mit dem Betriebsrat haben wir uns daher darauf verständigt, den Abbau so sozialverträglich wie möglich zu gestalten: \
        vorrangig über Altersteilzeit, freiwillige Aufhebungsverträge und interne Wechsel.
        Betriebsbedingte Kündigungen sind nach heutigem Stand nicht vorgesehen, \
        können aber, so ehrlich wollen wir sein, nicht für alle Zeit ausgeschlossen werden.
        Wer sich für ein freiwilliges Ausscheiden interessiert, kann sich bis zum 15. Januar vertraulich an die Personalabteilung wenden. \
        Bis zu diesem Stichtag gilt eine erhöhte Abfindung.
        Ihre Fragen beantworten wir gern in unseren offenen Sprechstunden, jeden Donnerstag ab 14 Uhr.

        Viele Grüße
        Ihre Geschäftsführung
        """,
        questions: [
            ReadingQuestion(prompt: "What does the email really announce?",
                            options: ["Jobs will be cut", "Everyone gets a pay rise", "The company is moving"],
                            answer: 0,
                            evidence: "was bedauerlicherweise auch Auswirkungen auf die Zahl der Stellen haben wird."),
            ReadingQuestion(prompt: "Will people be made redundant?",
                            options: ["Yes, from April", "Not for now, but it isn't ruled out for good",
                                      "Never: the works council has forbidden it"],
                            answer: 1,
                            evidence: "Betriebsbedingte Kündigungen sind nach heutigem Stand nicht vorgesehen, "
                                + "können aber, so ehrlich wollen wir sein, nicht für alle Zeit ausgeschlossen werden."),
            ReadingQuestion(prompt: "Why might someone talk to HR before 15 January?",
                            options: ["To be sure of keeping their job", "To join the works council",
                                      "To get a bigger payment for leaving voluntarily"],
                            answer: 2,
                            evidence: "Bis zu diesem Stichtag gilt eine erhöhte Abfindung.")
        ])
}
