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
            CollectionWord("der ", "Zoll", "customs",
                           "Am Zoll mussten wir den Koffer öffnen.", "At customs we had to open the suitcase."),
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
            CollectionWord("der ", "Führerschein", "driving licence",
                           "Ich muss meinen Führerschein umschreiben lassen.", "I have to get my driving licence converted."),
            CollectionWord("der ", "Stau", "traffic jam",
                           "Auf der A7 stehen wir seit einer Stunde im Stau.", "We’ve been stuck in a jam on the A7 for an hour."),
            CollectionWord("die ", "Umleitung", "diversion",
                           "Wegen der Baustelle gibt es eine Umleitung.", "There’s a diversion because of the roadworks."),
            CollectionWord("die ", "Panne", "breakdown",
                           "Wir hatten auf der Autobahn eine Panne.", "We broke down on the motorway."),
            CollectionWord("der ", "Abschleppdienst", "breakdown service",
                           "Der Abschleppdienst war nach einer Stunde da.", "The tow truck arrived after an hour."),
            CollectionWord("die ", "Werkstatt", "garage (for repairs)",
                           "Das Auto ist seit Montag in der Werkstatt.", "The car has been at the garage since Monday."),
            CollectionWord("der ", "TÜV", "MOT",
                           "Nächsten Monat muss das Auto zum TÜV.", "The car is due its MOT next month."),
            CollectionWord("das ", "Bußgeld", "fine",
                           "Weil ich zu schnell gefahren bin, habe ich ein Bußgeld bekommen.", "I got a fine for speeding."),
            CollectionWord("der ", "Blitzer", "speed camera",
                           "Pass auf, da vorne steht ein Blitzer.", "Watch out, there’s a speed camera up ahead."),
            CollectionWord("die ", "Vorfahrt", "right of way",
                           "Wer von rechts kommt, hat Vorfahrt.", "Whoever comes from the right has right of way."),
            CollectionWord("der ", "Unfall", "accident",
                           "Bei dem Unfall wurde zum Glück niemand verletzt.", "Luckily no one was hurt in the accident."),
            CollectionWord("die ", "Ladesäule", "charging point",
                           "Die nächste Ladesäule ist nur zwei Kilometer entfernt.",
                           "The nearest charging point is only two kilometres away."),
            CollectionWord("die ", "Fahrgemeinschaft", "car share",
                           "Wir fahren in einer Fahrgemeinschaft, um Benzin zu sparen.", "We car-share to save petrol."),
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
            CollectionWord("der ", "Vorschlag", "suggestion",
                           "Darf ich einen Vorschlag machen?", "May I make a suggestion?"),
            CollectionWord("die ", "Präsentation", "presentation",
                           "Morgen halte ich eine Präsentation vor der Geschäftsleitung.",
                           "Tomorrow I’m giving a presentation to the management."),
            CollectionWord("das ", "Budget", "budget",
                           "Das Budget für das Projekt ist fast aufgebraucht.", "The project’s budget is almost used up."),
            CollectionWord("die ", "Abteilung", "department",
                           "Unsere Abteilung zieht in den dritten Stock.", "Our department is moving to the third floor."),
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
            CollectionWord("die ", "Weiterbildung", "further training",
                           "Die Firma bezahlt mir eine Weiterbildung zur Projektmanagerin.",
                           "The company is paying for me to train as a project manager."),
            CollectionWord("die ", "Beförderung", "promotion",
                           "Nach drei Jahren hat sie endlich eine Beförderung bekommen.", "After three years she finally got a promotion."),
            CollectionWord("die ", "Gehaltsverhandlung", "pay negotiation",
                           "Auf die Gehaltsverhandlung sollte man sich gut vorbereiten.", "You should prepare well for a pay negotiation."),
            CollectionWord("die ", "Qualifikation", "qualification",
                           "Für die Stelle fehlt mir noch eine Qualifikation.", "I’m still missing one qualification for the job."),
            CollectionWord("die ", "Anerkennung", "recognition",
                           "Die Anerkennung meines Abschlusses hat ein halbes Jahr gedauert.",
                           "Getting my degree recognised took six months."),
            CollectionWord("der ", "Abschluss", "degree, qualification",
                           "Welchen Abschluss haben Sie?", "What qualification do you have?"),
            CollectionWord("die ", "Berufserfahrung", "work experience",
                           "Wir suchen jemanden mit mindestens zwei Jahren Berufserfahrung.",
                           "We’re looking for someone with at least two years’ experience."),
            CollectionWord("die ", "Ausbildung", "apprenticeship, vocational training",
                           "Er macht eine Ausbildung zum Elektriker.", "He’s doing an apprenticeship as an electrician."),
            CollectionWord("das ", "Praktikum", "internship",
                           "Im Sommer mache ich ein Praktikum bei einer Bank.", "In the summer I’m doing an internship at a bank."),
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
