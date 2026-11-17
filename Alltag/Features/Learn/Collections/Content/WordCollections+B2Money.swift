//
//  WordCollections+B2Money.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension WordCollections {
    // B2: offices and money, free time.

    static let b2Contracts = WordCollection(
        id: "b2-vertraege", title: "Verträge und Versicherungen", subtitle: "Contracts and insurance", level: .b2,
        category: .paperwork, systemImage: "doc.text.fill",
        words: [
            CollectionWord("die ", "Vertragslaufzeit", "contract term",
                           "Die Vertragslaufzeit beträgt 24 Monate.", "The contract runs for 24 months."),
            CollectionWord("die ", "Kündigungsfrist", "notice period",
                           "Die Kündigungsfrist beträgt einen Monat zum Monatsende.",
                           "The notice period is one month to the end of the month."),
            CollectionWord("das ", "Kleingedruckte", "small print",
                           "Lies immer das Kleingedruckte, bevor du unterschreibst.", "Always read the small print before you sign."),
            CollectionWord("die ", "Haftpflichtversicherung", "personal liability insurance",
                           "Eine Haftpflichtversicherung sollte in Deutschland jeder haben.",
                           "Everyone in Germany should have personal liability insurance."),
            CollectionWord("die ", "Hausratversicherung", "contents insurance",
                           "Nach dem Einbruch hat die Hausratversicherung den Laptop bezahlt.",
                           "After the break-in the contents insurance paid for the laptop."),
            CollectionWord("der ", "Beitrag", "premium",
                           "Der monatliche Beitrag ist gestiegen.", "The monthly premium has gone up."),
            CollectionWord("die ", "Selbstbeteiligung", "excess",
                           "Die Selbstbeteiligung liegt bei 150 Euro.", "The excess is 150 euros."),
            CollectionWord("der ", "Schadensfall", "claim (insurance)",
                           "Im Schadensfall rufen Sie bitte diese Nummer an.", "If you need to make a claim, please call this number."),
            CollectionWord("die ", "Klausel", "clause",
                           "Diese Klausel im Vertrag ist unwirksam.", "This clause in the contract isn’t valid."),
            CollectionWord("der ", "Widerspruch", "objection",
                           "Gegen den Bescheid können Sie innerhalb eines Monats Widerspruch einlegen.",
                           "You can object to the decision within a month."),
            CollectionWord("der ", "Anspruch", "entitlement",
                           "Sie haben Anspruch auf eine Erstattung.", "You are entitled to a refund."),
            CollectionWord("", "abschließen", "to take out (a contract)",
                           "Ich möchte eine Zahnzusatzversicherung abschließen.", "I’d like to take out extra dental insurance."),
            CollectionWord("", "sich verlängern", "to renew (by itself)",
                           "Wenn Sie nicht kündigen, verlängert sich der Vertrag um ein Jahr.",
                           "If you don’t cancel, the contract renews for another year."),
            CollectionWord("", "versichert", "insured",
                           "Ist das Fahrrad auch gegen Diebstahl versichert?", "Is the bike insured against theft too?"),
            CollectionWord("", "gültig", "valid",
                           "Das Angebot ist bis Ende des Monats gültig.", "The offer is valid until the end of the month.")
        ]
    )

    static let b2Taxes = WordCollection(
        id: "b2-steuern", title: "Steuern und Finanzen", subtitle: "Taxes and finances", level: .b2,
        category: .paperwork, systemImage: "eurosign.circle.fill",
        words: [
            CollectionWord("die ", "Steuererklärung", "tax return",
                           "Die Steuererklärung mache ich jedes Jahr mit ELSTER.", "I do my tax return with ELSTER every year."),
            CollectionWord("die ", "Pendlerpauschale", "commuter allowance",
                           "Die Pendlerpauschale gibt es für jeden Kilometer zur Arbeit.",
                           "You get the commuter allowance for every kilometre to work."),
            CollectionWord("die ", "Steuerklasse", "tax class",
                           "Nach der Hochzeit haben wir die Steuerklasse gewechselt.", "After the wedding we changed tax class."),
            CollectionWord("der ", "Steuerbescheid", "tax assessment",
                           "Der Steuerbescheid kam nach sechs Wochen.", "The tax assessment came after six weeks."),
            CollectionWord("die ", "Steuerrückerstattung", "tax refund",
                           "Von der Steuerrückerstattung kaufe ich mir ein neues Fahrrad.", "I’m buying a new bike with my tax refund."),
            CollectionWord("das ", "Bruttogehalt", "gross salary",
                           "Im Vorstellungsgespräch spricht man meistens über das Bruttogehalt.",
                           "In job interviews you usually talk about the gross salary."),
            CollectionWord("das ", "Nettogehalt", "take-home pay",
                           "Mein Nettogehalt reicht kaum für Miete und Essen.", "My take-home pay barely covers rent and food."),
            CollectionWord("die ", "Lohnabrechnung", "payslip",
                           "Auf der Lohnabrechnung sieht man alle Abzüge.", "Your payslip shows all the deductions."),
            CollectionWord("die ", "Sozialabgaben", "social security contributions (plural)",
                           "Ein großer Teil des Gehalts geht für Sozialabgaben drauf.",
                           "A large part of the salary goes on social security contributions."),
            CollectionWord("die ", "Ausgaben", "expenses (plural)",
                           "Ich schreibe alle Ausgaben in eine App.", "I note all my expenses in an app."),
            CollectionWord("die ", "Schulden", "debts (plural)",
                           "Er hat Schulden bei der Bank.", "He owes the bank money."),
            CollectionWord("der ", "Kredit", "loan",
                           "Für das Auto haben wir einen Kredit aufgenommen.", "We took out a loan for the car."),
            CollectionWord("die ", "Altersvorsorge", "saving for retirement",
                           "Für die Altersvorsorge spare ich jeden Monat etwas.", "I save something every month for my retirement."),
            CollectionWord("", "absetzen", "to deduct (from tax)",
                           "Arbeitsmittel wie einen Laptop kann man von der Steuer absetzen.",
                           "You can deduct work equipment like a laptop from your taxes."),
            CollectionWord("", "anlegen", "to invest",
                           "Sie hat ihr Geld in einem ETF angelegt.", "She invested her money in an ETF.")
        ]
    )

    static let b2Culture = WordCollection(
        id: "b2-kultur", title: "Kultur und Medien", subtitle: "Culture and media", level: .b2,
        category: .freeTime, systemImage: "theatermasks.fill",
        words: [
            CollectionWord("die ", "Ausstellung", "exhibition",
                           "Die Ausstellung im Museum läuft noch bis März.", "The exhibition at the museum runs until March."),
            CollectionWord("die ", "Aufführung", "performance",
                           "Nach der Aufführung gab es minutenlangen Applaus.", "After the performance the applause went on for minutes."),
            CollectionWord("das ", "Publikum", "audience",
                           "Das Publikum war begeistert.", "The audience was thrilled."),
            CollectionWord("die ", "Kritik", "review",
                           "Der Film hat überall gute Kritiken bekommen.", "The film got good reviews everywhere."),
            CollectionWord("die ", "Handlung", "plot",
                           "Die Handlung ist ziemlich vorhersehbar.", "The plot is pretty predictable."),
            CollectionWord("der ", "Roman", "novel",
                           "Ich lese gerade einen Roman von Juli Zeh.", "I’m reading a novel by Juli Zeh at the moment."),
            CollectionWord("die ", "Hauptrolle", "lead role",
                           "Wer spielt die Hauptrolle?", "Who plays the lead?"),
            CollectionWord("die ", "Untertitel", "subtitles (plural)",
                           "Ich schaue Serien auf Deutsch mit Untertiteln.", "I watch series in German with subtitles."),
            CollectionWord("die ", "Folge", "episode",
                           "Heute Abend läuft die letzte Folge.", "The last episode is on tonight."),
            CollectionWord("der ", "Streamingdienst", "streaming service",
                           "Wir haben zu viele Streamingdienste abonniert.", "We subscribe to too many streaming services."),
            CollectionWord("der ", "Rundfunkbeitrag", "TV licence fee",
                           "Den Rundfunkbeitrag muss jeder Haushalt zahlen.", "Every household has to pay the licence fee."),
            CollectionWord("die ", "Lesung", "author reading",
                           "In der Buchhandlung gibt es heute Abend eine Lesung.", "There’s an author reading at the bookshop tonight."),
            CollectionWord("", "empfehlen", "to recommend",
                           "Kannst du mir ein gutes Buch empfehlen?", "Can you recommend a good book?"),
            CollectionWord("", "spannend", "gripping, exciting",
                           "Der Krimi war bis zur letzten Seite spannend.", "The crime novel was gripping right up to the last page."),
            CollectionWord("", "ausverkauft", "sold out",
                           "Das Konzert ist leider schon ausverkauft.", "The concert is already sold out, I’m afraid.")
        ]
    )

    static let b2Volunteering = WordCollection(
        id: "b2-ehrenamt", title: "Verein und Ehrenamt", subtitle: "Clubs and volunteering", level: .b2,
        category: .freeTime, systemImage: "person.2.fill",
        words: [
            CollectionWord("das ", "Ehrenamt", "voluntary work",
                           "Ein Ehrenamt ist eine gute Möglichkeit, Leute kennenzulernen.", "Volunteering is a good way to meet people."),
            CollectionWord("der ", "Verein", "club",
                           "In Deutschland gibt es für fast jedes Hobby einen Verein.",
                           "In Germany there’s a club for almost every hobby."),
            CollectionWord("die ", "Mitgliedschaft", "membership",
                           "Die Mitgliedschaft kostet 60 Euro im Jahr.", "Membership costs 60 euros a year."),
            CollectionWord("der ", "Vorstand", "committee, board",
                           "Der Vorstand wird alle zwei Jahre neu gewählt.", "The committee is elected every two years."),
            CollectionWord("die ", "Mitgliederversammlung", "general meeting",
                           "Bei der Mitgliederversammlung stimmen wir über das Sommerfest ab.",
                           "At the general meeting we vote on the summer party."),
            CollectionWord("die ", "Spende", "donation",
                           "Spenden kann man von der Steuer absetzen.", "Donations are tax-deductible."),
            CollectionWord("der ", "Freiwillige", "volunteer",
                           "Für das Stadtfest suchen wir noch Freiwillige.", "We’re still looking for volunteers for the town festival."),
            CollectionWord("die ", "Tafel", "food bank",
                           "Bei der Tafel bekommen Menschen mit wenig Geld günstige Lebensmittel.",
                           "At the food bank people with little money get cheap food."),
            CollectionWord("die ", "Nachbarschaftshilfe", "neighbourly help",
                           "Über die Nachbarschaftshilfe kaufe ich für eine ältere Frau ein.",
                           "Through a neighbourhood help scheme I do the shopping for an older woman."),
            CollectionWord("die ", "Mannschaft", "team",
                           "Unsere Mannschaft hat am Sonntag 3:1 gewonnen.", "Our team won 3–1 on Sunday."),
            CollectionWord("das ", "Turnier", "tournament",
                           "Am Wochenende spielen wir ein Turnier in Leipzig.", "At the weekend we’re playing in a tournament in Leipzig."),
            CollectionWord("die ", "Veranstaltung", "event",
                           "Die Veranstaltung findet bei jedem Wetter statt.", "The event takes place whatever the weather."),
            CollectionWord("", "sich engagieren", "to get involved",
                           "Sie engagiert sich seit Jahren für Geflüchtete.", "She has been helping refugees for years."),
            CollectionWord("", "beitreten", "to join",
                           "Letztes Jahr bin ich einem Chor beigetreten.", "Last year I joined a choir."),
            CollectionWord("", "ehrenamtlich", "voluntary, unpaid",
                           "Er trainiert ehrenamtlich die Jugendmannschaft.", "He coaches the youth team as a volunteer.")
        ]
    )
}
