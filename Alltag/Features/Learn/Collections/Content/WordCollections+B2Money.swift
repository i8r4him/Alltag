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
            CollectionWord("das ", "Sonderkündigungsrecht", "right to cancel early",
                           "Nach einer Preiserhöhung haben Sie ein Sonderkündigungsrecht.",
                           "After a price rise you have the right to cancel early."),
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
            CollectionWord("der ", "Versicherungsschutz", "insurance cover",
                           "Der Versicherungsschutz gilt weltweit.", "The insurance cover applies worldwide."),
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
            CollectionWord("die ", "Lohnsteuer", "income tax (on wages)",
                           "Die Lohnsteuer wird direkt vom Gehalt abgezogen.", "Income tax is taken straight out of your salary."),
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
            CollectionWord("die ", "Rücklage", "savings for emergencies",
                           "Für Notfälle habe ich eine kleine Rücklage.", "I have a little put aside for emergencies."),
            CollectionWord("die ", "Inflation", "inflation",
                           "Wegen der Inflation ist das Leben deutlich teurer geworden.",
                           "Because of inflation, life has become a lot more expensive."),
            CollectionWord("der ", "Dispo", "overdraft",
                           "Am Monatsende bin ich oft im Dispo.", "At the end of the month I’m often overdrawn."),
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
            CollectionWord("die ", "Inszenierung", "production (of a play)",
                           "Die neue Inszenierung von Faust ist sehr modern.", "The new production of Faust is very modern."),
            CollectionWord("die ", "Aufführung", "performance",
                           "Nach der Aufführung gab es minutenlangen Applaus.", "After the performance the applause went on for minutes."),
            CollectionWord("die ", "Vernissage", "exhibition opening",
                           "Zur Vernissage kamen über hundert Gäste.", "Over a hundred guests came to the exhibition opening."),
            CollectionWord("der ", "Bestseller", "bestseller",
                           "Ihr erster Roman wurde sofort ein Bestseller.", "Her first novel became a bestseller straight away."),
            CollectionWord("die ", "Handlung", "plot",
                           "Die Handlung ist ziemlich vorhersehbar.", "The plot is pretty predictable."),
            CollectionWord("der ", "Roman", "novel",
                           "Ich lese gerade einen Roman von Juli Zeh.", "I’m reading a novel by Juli Zeh at the moment."),
            CollectionWord("die ", "Hauptrolle", "lead role",
                           "Wer spielt die Hauptrolle?", "Who plays the lead?"),
            CollectionWord("die ", "Rezension", "review",
                           "Die Rezension in der Zeitung war ziemlich negativ.", "The review in the paper was quite negative."),
            CollectionWord("die ", "Folge", "episode",
                           "Heute Abend läuft die letzte Folge.", "The last episode is on tonight."),
            CollectionWord("der ", "Streamingdienst", "streaming service",
                           "Wir haben zu viele Streamingdienste abonniert.", "We subscribe to too many streaming services."),
            CollectionWord("der ", "Rundfunkbeitrag", "TV licence fee",
                           "Den Rundfunkbeitrag muss jeder Haushalt zahlen.", "Every household has to pay the licence fee."),
            CollectionWord("das ", "Feuilleton", "arts pages",
                           "Im Feuilleton wird das Buch hoch gelobt.", "The book is highly praised in the arts pages."),
            CollectionWord("der ", "Regisseur", "director (of a film or play)",
                           "Der Regisseur hat schon mehrere Preise gewonnen.", "The director has already won several prizes."),
            CollectionWord("", "berührend", "moving",
                           "Das Ende des Films war sehr berührend.", "The end of the film was very moving."),
            CollectionWord("die ", "Mediathek", "a TV channel’s streaming library",
                           "Die Doku kannst du in der ARD-Mediathek anschauen.", "You can watch the documentary in the ARD Mediathek.")
        ]
    )

    static let b2Volunteering = WordCollection(
        id: "b2-ehrenamt", title: "Verein und Ehrenamt", subtitle: "Clubs and volunteering", level: .b2,
        category: .freeTime, systemImage: "person.2.fill",
        words: [
            CollectionWord("das ", "Engagement", "commitment, involvement",
                           "Vielen Dank für Ihr Engagement!", "Thank you very much for your commitment!"),
            CollectionWord("die ", "Bürgerinitiative", "residents’ campaign group",
                           "Eine Bürgerinitiative kämpft gegen den Bau der Straße.",
                           "A residents’ group is campaigning against the new road."),
            CollectionWord("die ", "Mitgliedschaft", "membership",
                           "Die Mitgliedschaft kostet 60 Euro im Jahr.", "Membership costs 60 euros a year."),
            CollectionWord("die ", "Satzung", "constitution (of a club)",
                           "Laut Satzung findet die Versammlung einmal im Jahr statt.",
                           "According to the constitution the meeting takes place once a year."),
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
            CollectionWord("der ", "Kassenwart", "treasurer (of a club)",
                           "Als Kassenwart kümmert er sich um die Finanzen des Vereins.",
                           "As treasurer he looks after the club’s finances."),
            CollectionWord("der ", "Schriftführer", "secretary (of a club)",
                           "Der Schriftführer schreibt das Protokoll der Sitzung.", "The secretary takes the minutes of the meeting."),
            CollectionWord("die ", "Spendenaktion", "fundraiser",
                           "Die Spendenaktion hat über 5.000 Euro eingebracht.", "The fundraiser brought in over 5,000 euros."),
            CollectionWord("", "sich engagieren", "to get involved",
                           "Sie engagiert sich seit Jahren für Geflüchtete.", "She has been helping refugees for years."),
            CollectionWord("", "beitreten", "to join",
                           "Letztes Jahr bin ich einem Chor beigetreten.", "Last year I joined a choir."),
            CollectionWord("", "ehrenamtlich", "voluntary, unpaid",
                           "Er trainiert ehrenamtlich die Jugendmannschaft.", "He coaches the youth team as a volunteer.")
        ]
    )
}
