//
//  ReadingTexts+C2Press.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension ReadingTexts {
    static let c2Fireworks = ReadingText(
        id: "c2-fireworks", level: .c2, kind: .notice,
        title: "A public order from the town", detail: "No fireworks in the old town",
        systemImage: "sparkles",
        german: """
        Allgemeinverfügung über ein Verbot von Feuerwerk in der Altstadt zum Jahreswechsel 2026/27

        Auf Grundlage des § 24 Abs. 2 der Ersten Verordnung zum Sprengstoffgesetz erlässt die Stadt Celle folgende Allgemeinverfügung:
        1. Das Abbrennen pyrotechnischer Gegenstände der Kategorie F2 ist vom 31. Dezember 2026, 18 Uhr, \
        bis zum 1. Januar 2027, 6 Uhr, innerhalb des in der Anlage gekennzeichneten Bereichs untersagt.
        2. Ausgenommen sind Gegenstände der Kategorie F1, etwa Wunderkerzen und Knallerbsen, die ganzjährig verwendet werden dürfen.
        3. Die sofortige Vollziehung wird angeordnet. Ein Widerspruch hat somit keine aufschiebende Wirkung.
        Begründung: Die historische Bebauung mit ihren Fachwerkhäusern und engen Gassen birgt eine erhebliche Brandgefahr. \
        In den vergangenen Jahren kam es zudem wiederholt zu Verletzungen durch gezielt auf Personen gerichtete Raketen.
        Verstöße können als Ordnungswidrigkeit mit einer Geldbuße von bis zu 50.000 Euro geahndet werden.
        Die Allgemeinverfügung gilt am Tag nach ihrer Bekanntmachung als bekannt gegeben.
        """,
        questions: [
            ReadingQuestion(prompt: "May children still wave sparklers in the old town that night?",
                            options: ["Yes, they are allowed all year", "No, all fireworks are banned", "Only before 6 pm"],
                            answer: 0,
                            evidence: "Ausgenommen sind Gegenstände der Kategorie F1, etwa Wunderkerzen und Knallerbsen, "
                                + "die ganzjährig verwendet werden dürfen."),
            ReadingQuestion(prompt: "Why is the old town in particular affected?",
                            options: ["Because of the many tourists",
                                      "Because its half-timbered houses and narrow lanes catch fire easily",
                                      "Because the police station is there"],
                            answer: 1,
                            evidence: "Die historische Bebauung mit ihren Fachwerkhäusern und engen Gassen "
                                + "birgt eine erhebliche Brandgefahr."),
            ReadingQuestion(prompt: "Someone objects to the order. What happens to the ban?",
                            options: ["It is paused until the objection is decided", "It ends at once",
                                      "It applies anyway"],
                            answer: 2,
                            evidence: "Ein Widerspruch hat somit keine aufschiebende Wirkung.")
        ])

    static let c2HolidayRuling = ReadingText(
        id: "c2-holiday-ruling", level: .c2, kind: .announcement,
        title: "A press release from a labour court", detail: "Holiday you never took",
        systemImage: "scalemass.fill",
        german: """
        Pressemitteilung: Urlaub verfällt nicht automatisch

        Der Anspruch auf bezahlten Jahresurlaub erlischt nur dann am Ende des Kalenderjahres, \
        wenn der Arbeitgeber den Arbeitnehmer zuvor in die Lage versetzt hat, seinen Urlaub rechtzeitig zu nehmen.
        Geklagt hatte eine Pflegekraft, die nach dem Ende ihres Arbeitsverhältnisses \
        die Abgeltung von 46 nicht genommenen Urlaubstagen aus drei Jahren verlangte. \
        Der Arbeitgeber hatte sich darauf berufen, die Tage seien jeweils zum Jahresende verfallen.
        Dem folgte die Kammer nicht. Der Arbeitgeber müsse konkret und in völliger Transparenz dazu auffordern, \
        den Urlaub zu nehmen, und klar darauf hinweisen, dass er andernfalls verfalle.
        Ein allgemeiner Hinweis im Arbeitsvertrag oder ein Aushang am Schwarzen Brett genüge hierfür nicht.
        Da der Arbeitgeber diesen Obliegenheiten nicht nachgekommen sei, stehe der Klägerin die Abgeltung in voller Höhe zu.
        Die Revision wurde nicht zugelassen.
        """,
        questions: [
            ReadingQuestion(prompt: "When does untaken holiday expire at the end of the year?",
                            options: ["Always", "Only if the employer made it possible to take it and gave a warning",
                                      "Never"],
                            answer: 1,
                            evidence: "wenn der Arbeitgeber den Arbeitnehmer zuvor in die Lage versetzt hat, "
                                + "seinen Urlaub rechtzeitig zu nehmen."),
            ReadingQuestion(prompt: "Which of these would NOT count as a proper warning?",
                            options: ["A note on the noticeboard", "A clear, personal request to take the days",
                                      "A letter saying the days will otherwise be lost"],
                            answer: 0,
                            evidence: "Ein allgemeiner Hinweis im Arbeitsvertrag oder ein Aushang am Schwarzen Brett "
                                + "genüge hierfür nicht."),
            ReadingQuestion(prompt: "What does the nurse get?",
                            options: ["Nothing", "Pay for half of the days", "Pay for all 46 days"],
                            answer: 2,
                            evidence: "stehe der Klägerin die Abgeltung in voller Höhe zu.")
        ])

    static let c2Column = ReadingText(
        id: "c2-column", level: .c2, kind: .article,
        title: "A satirical column", detail: "In praise of late trains",
        systemImage: "tram.fill",
        german: """
        Glosse: Lob der Verspätung

        Man muss der Bahn dankbar sein. Wo sonst lernt man in Zeiten ständiger Erreichbarkeit noch, was Warten eigentlich bedeutet?
        Wer heute in einen ICE steigt, bucht nicht einfach eine Fahrt, sondern ein Abenteuer mit offenem Ausgang. \
        Die Ankunftszeit auf dem Ticket ist dabei allenfalls als unverbindliche Absichtserklärung zu verstehen.
        Besonders erzieherisch wirkt die umgekehrte Wagenreihung. \
        Sie lehrt den Fahrgast, dass im Leben nichts dort ist, wo man es vermutet, \
        und dass ein kleiner Sprint über den Bahnsteig noch niemandem geschadet hat.
        Und wo sonst kommt man mit Fremden so unkompliziert ins Gespräch? \
        Nichts verbindet Menschen so zuverlässig wie die gemeinsame Empörung über eine „Störung im Betriebsablauf“.
        Natürlich ließe sich all das auch nüchterner sehen: \
        als Folge jahrzehntelanger Sparpolitik, maroder Gleise und fehlenden Personals.
        Aber wer wollte so kleinlich sein? \
        Die Bahn schenkt uns, was uns sonst niemand mehr schenkt: Zeit. Man hat sie nur nicht bestellt.
        """,
        questions: [
            ReadingQuestion(prompt: "How should you read the arrival time on the ticket, according to the column?",
                            options: ["As a vague intention, nothing more", "As a firm promise", "As the latest you'll arrive"],
                            answer: 0,
                            evidence: "Die Ankunftszeit auf dem Ticket ist dabei allenfalls "
                                + "als unverbindliche Absichtserklärung zu verstehen."),
            ReadingQuestion(prompt: "Which real causes does the writer name, almost in passing?",
                            options: ["Bad weather and strikes", "Too many passengers",
                                      "Years of cuts, crumbling tracks and too few staff"],
                            answer: 2,
                            evidence: "als Folge jahrzehntelanger Sparpolitik, maroder Gleise und fehlenden Personals."),
            ReadingQuestion(prompt: "What does the writer really think of the delays?",
                            options: ["They genuinely enjoy them", "They mock them by pretending to praise them",
                                      "They don't mind them at all"],
                            answer: 1,
                            evidence: "Die Bahn schenkt uns, was uns sonst niemand mehr schenkt: Zeit. Man hat sie nur nicht bestellt.")
        ])

    static let c2Review = ReadingText(
        id: "c2-review", level: .c2, kind: .article,
        title: "A book review", detail: "A novel that wants too much",
        systemImage: "book.fill",
        german: """
        Rezension: Ein Roman, der zu viel will

        Mit „Die Stunde der Kraniche“ legt Judith Albrecht nach ihrem gefeierten Debüt ihren zweiten Roman vor, \
        und die Erwartungen könnten kaum höher sein.
        Erzählt wird die Geschichte dreier Schwestern, die nach dem Tod der Mutter das Elternhaus in der Uckermark ausräumen \
        und dabei auf ein lange gehütetes Familiengeheimnis stoßen.
        Wo Albrecht bei dem bleibt, was sie kann, nämlich bei den feinen Verschiebungen im Verhältnis der Schwestern, \
        gelingen ihr Passagen von beklemmender Genauigkeit.
        Leider traut sie dieser Stärke nicht. \
        Ein Nebenstrang über die Treuhand, ein zweiter über die Klimakrise und ein dritter über eine Affäre in Berlin \
        blähen das Buch auf, ohne es zu vertiefen.
        Spätestens im letzten Drittel drängt sich der Eindruck auf, die Autorin wolle eine ganze Epoche erklären, \
        wo eine einzige Familie vollauf genügt hätte.
        So bleibt ein Roman, der in seinen besten Momenten berührt, als Ganzes aber hinter seinen Möglichkeiten zurückbleibt. \
        Lesenswert ist er dennoch, schon wegen der Mutter, die ausgerechnet als Abwesende das stärkste Kapitel bekommt.
        """,
        questions: [
            ReadingQuestion(prompt: "What does the critic praise?",
                            options: ["The many side plots", "The precise way it shows the sisters' relationship",
                                      "The happy ending"],
                            answer: 1,
                            evidence: "Wo Albrecht bei dem bleibt, was sie kann, nämlich bei den feinen Verschiebungen "
                                + "im Verhältnis der Schwestern, gelingen ihr Passagen von beklemmender Genauigkeit."),
            ReadingQuestion(prompt: "What is the book's main weakness?",
                            options: ["Side stories that make it longer but not deeper", "Language that is too simple",
                                      "It is far too short"],
                            answer: 0,
                            evidence: "blähen das Buch auf, ohne es zu vertiefen."),
            ReadingQuestion(prompt: "What is the critic's verdict overall?",
                            options: ["A masterpiece", "Not worth reading",
                                      "Moving at times, short of its potential, but still worth reading"],
                            answer: 2,
                            evidence: "So bleibt ein Roman, der in seinen besten Momenten berührt, "
                                + "als Ganzes aber hinter seinen Möglichkeiten zurückbleibt.")
        ])
}
