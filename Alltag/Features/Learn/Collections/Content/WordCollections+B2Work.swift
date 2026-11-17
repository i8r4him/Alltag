//
//  WordCollections+B2Work.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension WordCollections {
    // B2: getting around and work.

    static let b2TravelTrouble = WordCollection(
        id: "b2-reisepannen", title: "Pannen auf Reisen", subtitle: "When travel goes wrong", level: .b2,
        category: .travel, systemImage: "suitcase.rolling.fill",
        words: [
            CollectionWord("die ", "Fahrgastrechte", "passenger rights (plural)",
                           "Nach zwei Stunden Verspätung bekommt man dank der Fahrgastrechte die Hälfte des Fahrpreises zurück.",
                           "Thanks to passenger rights you get half the fare back after a two-hour delay."),
            CollectionWord("der ", "Zugausfall", "cancelled train",
                           "Wegen eines Zugausfalls bin ich erst nachts angekommen.",
                           "Because a train was cancelled I didn’t arrive until the night."),
            CollectionWord("die ", "Einreise", "entry (into a country)",
                           "Bei der Einreise wurde mein Visum kontrolliert.", "My visa was checked on entry."),
            CollectionWord("die ", "Entschädigung", "compensation",
                           "Ab einer Stunde Verspätung bekommt man eine Entschädigung.",
                           "If you’re an hour late or more, you get compensation."),
            CollectionWord("die ", "Weiterreise", "onward journey",
                           "Die Weiterreise ist erst morgen früh möglich.", "We can’t continue our journey until tomorrow morning."),
            CollectionWord("die ", "Gepäckausgabe", "baggage reclaim",
                           "An der Gepäckausgabe habe ich eine Stunde gewartet.", "I waited an hour at baggage reclaim."),
            CollectionWord("die ", "Verlustmeldung", "loss report",
                           "Am Schalter habe ich eine Verlustmeldung für meinen Koffer gemacht.",
                           "I reported my suitcase missing at the desk."),
            CollectionWord("die ", "Umbuchung", "rebooking",
                           "Die Umbuchung auf einen späteren Flug war kostenlos.", "Rebooking onto a later flight was free."),
            CollectionWord("die ", "Stornierung", "cancellation",
                           "Bei einer Stornierung bis zwei Tage vorher fallen keine Kosten an.",
                           "There’s no charge if you cancel up to two days before."),
            CollectionWord("die ", "Reiserücktrittsversicherung", "trip cancellation insurance",
                           "Zum Glück hatten wir eine Reiserücktrittsversicherung.", "Luckily we had trip cancellation insurance."),
            CollectionWord("die ", "Botschaft", "embassy",
                           "Nachdem mein Pass gestohlen wurde, musste ich zur Botschaft.",
                           "After my passport was stolen I had to go to the embassy."),
            CollectionWord("der ", "Streik", "strike",
                           "Wegen des Streiks fahren heute kaum Züge.", "Because of the strike hardly any trains are running today."),
            CollectionWord("", "umleiten", "to divert",
                           "Unser Flug wurde nach München umgeleitet.", "Our flight was diverted to Munich."),
            CollectionWord("", "verpassen", "to miss",
                           "Beeil dich, sonst verpassen wir den Bus!", "Hurry up, or we’ll miss the bus!"),
            CollectionWord("", "gestrandet", "stranded",
                           "Wegen des Sturms waren wir zwei Tage am Flughafen gestrandet.",
                           "Because of the storm we were stranded at the airport for two days.")
        ]
    )

    static let b2Driving = WordCollection(
        id: "b2-auto", title: "Auto und Straßenverkehr", subtitle: "Driving", level: .b2,
        category: .travel, systemImage: "car.fill",
        words: [
            CollectionWord("die ", "Geschwindigkeitsbegrenzung", "speed limit",
                           "Auf deutschen Autobahnen gibt es oft keine Geschwindigkeitsbegrenzung.",
                           "German motorways often have no speed limit."),
            CollectionWord("das ", "Fahrverbot", "driving ban",
                           "Wegen zu schnellen Fahrens hat er einen Monat Fahrverbot bekommen.",
                           "He got a one-month driving ban for speeding."),
            CollectionWord("die ", "Kfz-Versicherung", "car insurance",
                           "Die Kfz-Versicherung ist für junge Fahrer besonders teuer.",
                           "Car insurance is especially expensive for young drivers."),
            CollectionWord("der ", "Sachschaden", "damage to property",
                           "Bei dem Zusammenstoß gab es nur Sachschaden.", "The collision only caused damage to property."),
            CollectionWord("der ", "Verkehrsverstoß", "traffic offence",
                           "Bei schweren Verkehrsverstößen gibt es Punkte in Flensburg.",
                           "Serious traffic offences get you penalty points in Flensburg."),
            CollectionWord("die ", "Rettungsgasse", "emergency corridor",
                           "Im Stau muss man sofort eine Rettungsgasse bilden.",
                           "In a traffic jam you have to make an emergency corridor straight away."),
            CollectionWord("der ", "Winterreifen", "winter tyre",
                           "Bei Glatteis sind Winterreifen Pflicht.", "Winter tyres are compulsory when the roads are icy."),
            CollectionWord("das ", "Bußgeld", "fine",
                           "Wer am Steuer telefoniert, muss ein Bußgeld zahlen.",
                           "If you use your phone while driving, you have to pay a fine."),
            CollectionWord("der ", "Blitzer", "speed camera",
                           "Pass auf, da vorne steht ein Blitzer.", "Watch out, there’s a speed camera up ahead."),
            CollectionWord("die ", "Probefahrt", "test drive",
                           "Vor dem Kauf machen wir eine Probefahrt.", "We’ll take it for a test drive before buying."),
            CollectionWord("die ", "Fahrerflucht", "hit-and-run",
                           "Nach dem Unfall hat der Fahrer Fahrerflucht begangen.", "After the accident the driver fled the scene."),
            CollectionWord("", "sich anschnallen", "to put your seat belt on",
                           "Bitte schnall dich an, wir fahren los.", "Please put your seat belt on, we’re setting off."),
            CollectionWord("", "beschleunigen", "to accelerate",
                           "Auf der Auffahrt muss man kräftig beschleunigen.", "On the slip road you have to accelerate hard."),
            CollectionWord("", "überholen", "to overtake",
                           "Auf der Autobahn darf man nicht rechts überholen.", "You mustn’t overtake on the right on the motorway."),
            CollectionWord("", "einparken", "to park (a car into a space)",
                           "Kannst du hier einparken? Die Lücke ist ziemlich klein.", "Can you park here? The space is pretty small.")
        ]
    )

    static let b2Meetings = WordCollection(
        id: "b2-meetings", title: "Meetings und Projekte", subtitle: "Meetings and projects", level: .b2,
        category: .work, systemImage: "chart.bar.doc.horizontal.fill",
        words: [
            CollectionWord("die ", "Tagesordnung", "agenda",
                           "Was steht heute auf der Tagesordnung?", "What’s on the agenda today?"),
            CollectionWord("das ", "Protokoll", "minutes",
                           "Wer schreibt heute das Protokoll?", "Who’s taking the minutes today?"),
            CollectionWord("der ", "Termindruck", "time pressure",
                           "Wegen des Termindrucks arbeiten wir diese Woche länger.",
                           "Because of the time pressure we’re working longer this week."),
            CollectionWord("der ", "Meilenstein", "milestone",
                           "Den ersten Meilenstein haben wir pünktlich erreicht.", "We reached the first milestone on time."),
            CollectionWord("die ", "Zuständigkeit", "responsibility",
                           "Das fällt nicht in meine Zuständigkeit.", "That isn’t my responsibility."),
            CollectionWord("der ", "Ansprechpartner", "contact person",
                           "Wer ist bei Ihnen der Ansprechpartner für Rechnungen?",
                           "Who is the contact person for invoices at your company?"),
            CollectionWord("die ", "Rückmeldung", "feedback, reply",
                           "Ich warte noch auf eine Rückmeldung vom Kunden.", "I’m still waiting to hear back from the client."),
            CollectionWord("die ", "Rücksprache", "checking with someone",
                           "Nach Rücksprache mit meiner Chefin kann ich zusagen.", "After checking with my boss I can say yes."),
            CollectionWord("die ", "Präsentation", "presentation",
                           "Morgen halte ich eine Präsentation vor der Geschäftsleitung.",
                           "Tomorrow I’m giving a presentation to the management."),
            CollectionWord("das ", "Budget", "budget",
                           "Das Budget für das Projekt ist fast aufgebraucht.", "The project’s budget is almost used up."),
            CollectionWord("das ", "Anliegen", "concern, request",
                           "Was ist Ihr Anliegen?", "What can I help you with?"),
            CollectionWord("", "verschieben", "to postpone",
                           "Können wir das Meeting auf nächste Woche verschieben?", "Can we postpone the meeting until next week?"),
            CollectionWord("", "zusammenfassen", "to sum up",
                           "Lassen Sie mich die wichtigsten Punkte kurz zusammenfassen.", "Let me briefly sum up the main points."),
            CollectionWord("", "delegieren", "to delegate",
                           "Als Teamleiterin muss sie lernen, Aufgaben zu delegieren.", "As a team leader she has to learn to delegate."),
            CollectionWord("", "sich abstimmen", "to coordinate",
                           "Ich stimme mich vorher noch mit dem Vertrieb ab.", "I’ll coordinate with sales first.")
        ]
    )

    static let b2Career = WordCollection(
        id: "b2-karriere", title: "Karriere und Weiterbildung", subtitle: "Career and training", level: .b2,
        category: .work, systemImage: "graduationcap.fill",
        words: [
            CollectionWord("die ", "Führungskraft", "manager",
                           "Als Führungskraft trägt sie viel Verantwortung.", "As a manager she carries a lot of responsibility."),
            CollectionWord("die ", "Beförderung", "promotion",
                           "Nach drei Jahren hat sie endlich eine Beförderung bekommen.", "After three years she finally got a promotion."),
            CollectionWord("die ", "Gehaltsverhandlung", "pay negotiation",
                           "Auf die Gehaltsverhandlung sollte man sich gut vorbereiten.", "You should prepare well for a pay negotiation."),
            CollectionWord("die ", "Qualifikation", "qualification",
                           "Für die Stelle fehlt mir noch eine Qualifikation.", "I’m still missing one qualification for the job."),
            CollectionWord("das ", "Arbeitszeugnis", "reference (from an employer)",
                           "Im Arbeitszeugnis steht, dass ich zuverlässig bin.", "My reference says I’m reliable."),
            CollectionWord("die ", "Abfindung", "severance pay",
                           "Nach der Kündigung hat er eine Abfindung bekommen.", "He got severance pay after being let go."),
            CollectionWord("die ", "Berufserfahrung", "work experience",
                           "Wir suchen jemanden mit mindestens zwei Jahren Berufserfahrung.",
                           "We’re looking for someone with at least two years’ experience."),
            CollectionWord("der ", "Quereinsteiger", "career changer",
                           "Die Schule sucht auch Quereinsteiger als Lehrer.",
                           "The school is also looking for career changers to become teachers."),
            CollectionWord("die ", "Fachkraft", "skilled worker",
                           "Deutschland wirbt im Ausland um Fachkräfte.", "Germany is trying to attract skilled workers from abroad."),
            CollectionWord("die ", "Stärke", "strength",
                           "Was sind Ihre Stärken und Schwächen?", "What are your strengths and weaknesses?"),
            CollectionWord("das ", "Netzwerk", "network",
                           "Über mein Netzwerk habe ich von der Stelle erfahren.", "I heard about the job through my network."),
            CollectionWord("die ", "Selbstständigkeit", "self-employment",
                           "Nach zehn Jahren als Angestellter wagt er den Schritt in die Selbstständigkeit.",
                           "After ten years as an employee he’s going self-employed."),
            CollectionWord("", "aufsteigen", "to move up",
                           "In kleinen Firmen kann man oft schneller aufsteigen.", "In small companies you can often move up faster."),
            CollectionWord("", "sich weiterentwickeln", "to grow (in your job)",
                           "In meinem jetzigen Job kann ich mich nicht weiterentwickeln.", "I can’t grow any further in my current job."),
            CollectionWord("", "belastbar", "able to work under pressure",
                           "In fast jeder Stellenanzeige steht: belastbar und teamfähig.",
                           "Almost every job ad says: able to work under pressure and a team player.")
        ]
    )
}
