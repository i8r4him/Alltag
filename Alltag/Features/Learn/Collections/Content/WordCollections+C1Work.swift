//
//  WordCollections+C1Work.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension WordCollections {
    // C1: work, the law, the economy and art.

    static let c1Leadership = WordCollection(
        id: "c1-fuehrung", title: "Führen und Verhandeln", subtitle: "Leading and negotiating", level: .c1,
        category: .work, systemImage: "person.3.fill",
        words: [
            CollectionWord("die ", "Verhandlung", "negotiation",
                           "Die Verhandlungen mit dem Kunden laufen noch.", "Negotiations with the client are still going on."),
            CollectionWord("das ", "Zugeständnis", "concession",
                           "Ohne Zugeständnisse auf beiden Seiten kommen wir nicht weiter.",
                           "Without concessions on both sides we won’t get anywhere."),
            CollectionWord("die ", "Zielvereinbarung", "agreed targets",
                           "In der Zielvereinbarung steht, was ich bis Dezember erreichen soll.",
                           "The agreed targets say what I should achieve by December."),
            CollectionWord("das ", "Mitarbeitergespräch", "appraisal",
                           "Nächste Woche habe ich mein jährliches Mitarbeitergespräch.", "Next week I have my yearly appraisal."),
            CollectionWord("die ", "Befugnis", "authority",
                           "Dazu habe ich leider keine Befugnis.", "I’m afraid I don’t have the authority to do that."),
            CollectionWord("der ", "Spielraum", "room for manoeuvre",
                           "Beim Preis haben wir noch etwas Spielraum.", "We still have some room for manoeuvre on the price."),
            CollectionWord("die ", "Unternehmenskultur", "company culture",
                           "Die Unternehmenskultur ist hier sehr offen.", "The company culture here is very open."),
            CollectionWord("der ", "Führungsstil", "leadership style",
                           "Ihr Führungsstil ist streng, aber fair.", "Her leadership style is strict but fair."),
            CollectionWord("", "auf Augenhöhe", "as equals",
                           "Bei uns reden Chef und Azubis auf Augenhöhe.", "Here the boss and the apprentices talk as equals."),
            CollectionWord("", "sich behaupten", "to hold your own",
                           "In der Verhandlung musste sie sich gegen drei Männer behaupten.",
                           "In the negotiation she had to hold her own against three men."),
            CollectionWord("", "entgegenkommen", "to meet someone halfway",
                           "Beim Liefertermin kommen wir Ihnen gern entgegen.", "We’re happy to meet you halfway on the delivery date."),
            CollectionWord("", "anerkennen", "to acknowledge",
                           "Eine gute Chefin erkennt auch kleine Erfolge an.", "A good boss acknowledges small successes too."),
            CollectionWord("", "kompromissbereit", "willing to compromise",
                           "Beide Seiten zeigten sich kompromissbereit.", "Both sides showed they were willing to compromise."),
            CollectionWord("", "verbindlich", "binding",
                           "Das Angebot ist bis Freitag verbindlich.", "The offer is binding until Friday."),
            CollectionWord("", "ergebnisoffen", "with an open mind (about the outcome)",
                           "Wir gehen ergebnisoffen in das Gespräch.", "We’re going into the talks with an open mind.")
        ]
    )

    static let c1EmploymentLaw = WordCollection(
        id: "c1-arbeitsrecht", title: "Arbeitsrecht", subtitle: "Your rights at work", level: .c1,
        category: .work, systemImage: "shield.fill",
        words: [
            CollectionWord("der ", "Kündigungsschutz", "protection against dismissal",
                           "Nach sechs Monaten gilt für Sie der Kündigungsschutz.", "After six months you’re protected against dismissal."),
            CollectionWord("die ", "Betriebsvereinbarung", "works agreement",
                           "Laut Betriebsvereinbarung dürfen wir zwei Tage pro Woche im Homeoffice arbeiten.",
                           "Under the works agreement we may work from home two days a week."),
            CollectionWord("der ", "Betriebsrat", "works council",
                           "Wenden Sie sich am besten an den Betriebsrat.", "It’s best to go to the works council."),
            CollectionWord("der ", "Tarifvertrag", "collective agreement",
                           "Laut Tarifvertrag steht uns mehr Urlaub zu.", "Under the collective agreement we’re entitled to more holiday."),
            CollectionWord("die ", "Gewerkschaft", "trade union",
                           "Seit letztem Jahr bin ich in der Gewerkschaft.", "I joined the union last year."),
            CollectionWord("die ", "Abmahnung", "formal warning",
                           "Wer zu oft zu spät kommt, bekommt eine Abmahnung.", "If you’re late too often, you get a formal warning."),
            CollectionWord("der ", "Aufhebungsvertrag", "termination agreement",
                           "Unterschreiben Sie keinen Aufhebungsvertrag, ohne sich beraten zu lassen.",
                           "Don’t sign a termination agreement without getting advice."),
            CollectionWord("das ", "Arbeitsgericht", "employment tribunal",
                           "Der Streit landete vor dem Arbeitsgericht.", "The dispute ended up at the employment tribunal."),
            CollectionWord("der ", "Mutterschutz", "maternity protection",
                           "Im Mutterschutz bekommt sie weiter ihr Gehalt.", "She keeps getting her salary during maternity leave."),
            CollectionWord("die ", "Arbeitsunfähigkeitsbescheinigung", "sick note",
                           "Ab dem dritten Tag brauchen Sie eine Arbeitsunfähigkeitsbescheinigung.",
                           "From the third day you need a sick note."),
            CollectionWord("der ", "Mindestlohn", "minimum wage",
                           "Der Mindestlohn wurde wieder erhöht.", "The minimum wage has gone up again."),
            CollectionWord("der ", "Urlaubsanspruch", "holiday entitlement",
                           "Mein Urlaubsanspruch liegt bei dreißig Tagen.", "My holiday entitlement is thirty days."),
            CollectionWord("", "fristlos", "without notice",
                           "Er wurde fristlos entlassen.", "He was dismissed without notice."),
            CollectionWord("", "streiken", "to go on strike",
                           "Die Lokführer streiken schon wieder.", "The train drivers are on strike again."),
            CollectionWord("", "zustehen", "to be entitled to",
                           "Dir stehen noch fünf Urlaubstage zu.", "You’re still entitled to five days’ holiday.")
        ]
    )

    static let c1Law = WordCollection(
        id: "c1-recht", title: "Recht und Gericht", subtitle: "The law and the courts", level: .c1,
        category: .paperwork, systemImage: "scalemass.fill",
        words: [
            CollectionWord("die ", "Klage", "lawsuit",
                           "Wir haben Klage gegen den Vermieter eingereicht.", "We’ve taken the landlord to court."),
            CollectionWord("das ", "Urteil", "verdict",
                           "Das Urteil wird nächste Woche verkündet.", "The verdict will be announced next week."),
            CollectionWord("der ", "Zeuge", "witness",
                           "Die Polizei sucht Zeugen des Unfalls.", "The police are looking for witnesses to the accident."),
            CollectionWord("der ", "Beweis", "evidence, proof",
                           "Ohne Beweise kann man ihm nichts vorwerfen.", "Without evidence you can’t accuse him of anything."),
            CollectionWord("die ", "Rechtsanwältin", "lawyer (woman)",
                           "Meine Rechtsanwältin kümmert sich um alles.", "My lawyer is taking care of everything."),
            CollectionWord("die ", "Rechtsschutzversicherung", "legal expenses insurance",
                           "Zum Glück zahlt die Rechtsschutzversicherung die Anwaltskosten.",
                           "Luckily my legal insurance is paying the lawyer’s fees."),
            CollectionWord("der ", "Prozess", "trial",
                           "Der Prozess dauerte fast zwei Jahre.", "The trial lasted almost two years."),
            CollectionWord("der ", "Vergleich", "settlement",
                           "Am Ende haben sich beide Seiten auf einen Vergleich geeinigt.",
                           "In the end both sides agreed on a settlement."),
            CollectionWord("die ", "Vollmacht", "power of attorney",
                           "Mit dieser Vollmacht kann mein Sohn für mich unterschreiben.",
                           "With this power of attorney my son can sign for me."),
            CollectionWord("der ", "Mahnbescheid", "court payment order",
                           "Wenn Sie nicht zahlen, folgt ein Mahnbescheid.", "If you don’t pay, a court payment order will follow."),
            CollectionWord("", "Anzeige erstatten", "to report to the police",
                           "Nach dem Einbruch haben wir sofort Anzeige erstattet.",
                           "After the burglary we reported it to the police straight away."),
            CollectionWord("", "verklagen", "to sue",
                           "Der Kunde droht, uns zu verklagen.", "The customer is threatening to sue us."),
            CollectionWord("", "Einspruch einlegen", "to appeal, to object formally",
                           "Gegen das Bußgeld können Sie innerhalb von zwei Wochen Einspruch einlegen.",
                           "You can appeal against the fine within two weeks."),
            CollectionWord("", "rechtskräftig", "final (of a verdict)",
                           "Das Urteil ist noch nicht rechtskräftig.", "The verdict isn’t final yet."),
            CollectionWord("", "strafbar", "punishable by law",
                           "Beleidigung ist in Deutschland strafbar.", "Insulting someone is a criminal offence in Germany.")
        ]
    )

    static let c1Economy = WordCollection(
        id: "c1-wirtschaft", title: "Wirtschaft und Märkte", subtitle: "The economy", level: .c1,
        category: .paperwork, systemImage: "chart.line.uptrend.xyaxis",
        words: [
            CollectionWord("die ", "Konjunktur", "state of the economy",
                           "Die Konjunktur schwächelt seit Monaten.", "The economy has been weak for months."),
            CollectionWord("die ", "Rezession", "recession",
                           "Fachleute warnen vor einer Rezession.", "Experts are warning of a recession."),
            CollectionWord("das ", "Wirtschaftswachstum", "economic growth",
                           "Das Wirtschaftswachstum lag letztes Jahr bei null.", "Economic growth was zero last year."),
            CollectionWord("die ", "Arbeitslosigkeit", "unemployment",
                           "Die Arbeitslosigkeit ist im Osten gesunken.", "Unemployment has fallen in the east."),
            CollectionWord("der ", "Fachkräftemangel", "shortage of skilled workers",
                           "Wegen des Fachkräftemangels suchen viele Firmen im Ausland.",
                           "Because of the skills shortage many firms recruit abroad."),
            CollectionWord("der ", "Standort", "site, location (of a business)",
                           "Die Firma will den Standort in Bremen schließen.", "The company wants to close its Bremen site."),
            CollectionWord("der ", "Umsatz", "turnover, sales",
                           "Der Umsatz ist im dritten Quartal gestiegen.", "Sales rose in the third quarter."),
            CollectionWord("die ", "Aktie", "share",
                           "Ich habe ein paar Aktien geerbt.", "I inherited a few shares."),
            CollectionWord("der ", "Leitzins", "base rate",
                           "Die Zentralbank hat den Leitzins erneut erhöht.", "The central bank has raised the base rate again."),
            CollectionWord("die ", "Kaufkraft", "purchasing power",
                           "Durch die hohen Preise sinkt die Kaufkraft.", "High prices reduce people’s purchasing power."),
            CollectionWord("die ", "Staatsverschuldung", "national debt",
                           "Die Staatsverschuldung ist ein ständiges Streitthema.", "National debt is a constant bone of contention."),
            CollectionWord("die ", "Globalisierung", "globalisation",
                           "Von der Globalisierung profitieren nicht alle.", "Not everyone benefits from globalisation."),
            CollectionWord("der ", "Wettbewerb", "competition",
                           "Der Wettbewerb unter den Lieferdiensten ist hart.", "Competition between delivery services is tough."),
            CollectionWord("", "investieren", "to invest",
                           "Die Firma investiert Millionen in neue Technik.", "The company is investing millions in new technology."),
            CollectionWord("", "schwanken", "to fluctuate",
                           "Die Strompreise schwanken stark.", "Electricity prices fluctuate a lot.")
        ]
    )

    static let c1Art = WordCollection(
        id: "c1-kunst", title: "Kunst und Literatur", subtitle: "Art and literature", level: .c1,
        category: .freeTime, systemImage: "paintpalette.fill",
        words: [
            CollectionWord("das ", "Atelier", "studio (of an artist)",
                           "Die Malerin öffnet ihr Atelier am Wochenende für Besucher.",
                           "The painter opens her studio to visitors at the weekend."),
            CollectionWord("die ", "Sammlung", "collection",
                           "Das Museum hat eine große Sammlung moderner Kunst.", "The museum has a large collection of modern art."),
            CollectionWord("das ", "Werk", "work (of art)",
                           "Ihr Werk umfasst über dreißig Romane.", "Her work includes more than thirty novels."),
            CollectionWord("die ", "Epoche", "period, era",
                           "Welche Epoche der Kunst gefällt dir am besten?", "Which period of art do you like best?"),
            CollectionWord("das ", "Gedicht", "poem",
                           "Im Deutschunterricht mussten wir ein Gedicht auswendig lernen.",
                           "In German lessons we had to learn a poem by heart."),
            CollectionWord("der ", "Erzähler", "narrator",
                           "Am Ende ist der Erzähler selbst der Täter.", "In the end the narrator turns out to be the culprit."),
            CollectionWord("die ", "Strophe", "verse",
                           "Das Gedicht hat vier Strophen.", "The poem has four verses."),
            CollectionWord("der ", "Bildhauer", "sculptor",
                           "Der Bildhauer arbeitet nur mit Holz.", "The sculptor only works with wood."),
            CollectionWord("die ", "Uraufführung", "premiere",
                           "Die Uraufführung war sofort ausverkauft.", "The premiere sold out immediately."),
            CollectionWord("das ", "Motiv", "subject, motif",
                           "Ein beliebtes Motiv der Romantik ist der Wald.", "A popular motif of Romanticism is the forest."),
            CollectionWord("die ", "Metapher", "metaphor",
                           "Das Gedicht steckt voller Metaphern.", "The poem is full of metaphors."),
            CollectionWord("die ", "Neuerscheinung", "new release (book)",
                           "Im Schaufenster liegen die Neuerscheinungen des Herbstes.", "The autumn’s new books are in the window."),
            CollectionWord("", "interpretieren", "to interpret",
                           "Man kann das Ende ganz unterschiedlich interpretieren.",
                           "You can interpret the ending in very different ways."),
            CollectionWord("", "zeitgenössisch", "contemporary",
                           "Mir gefällt zeitgenössische Kunst besser als die alten Meister.",
                           "I prefer contemporary art to the old masters."),
            CollectionWord("", "vielschichtig", "complex, many-layered",
                           "Die Figuren im Roman sind sehr vielschichtig.", "The characters in the novel are very complex.")
        ]
    )
}
