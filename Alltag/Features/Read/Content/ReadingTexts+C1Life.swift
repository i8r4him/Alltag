//
//  ReadingTexts+C1Life.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension ReadingTexts {
    static let c1BikeInsurance = ReadingText(
        id: "c1-bike-insurance", level: .c1, kind: .letter,
        title: "A letter from your insurer", detail: "Your stolen bike",
        systemImage: "bicycle",
        german: """
        Ihre Schadenmeldung vom 3. September – Fahrraddiebstahl

        Sehr geehrte Frau Lindqvist,
        vielen Dank für Ihre Schadenmeldung und die Kopie der polizeilichen Anzeige. Wir haben den Vorgang sorgfältig geprüft.
        Ihr Fahrrad ist über Ihre Hausratversicherung grundsätzlich gegen Diebstahl versichert, \
        allerdings enthält Ihr Vertrag die sogenannte Nachtzeitklausel.
        Danach besteht zwischen 22 und 6 Uhr nur dann Versicherungsschutz, \
        wenn sich das Fahrrad in einem verschlossenen Raum befindet oder zu dieser Zeit nachweislich in Gebrauch war.
        Laut Ihren Angaben haben Sie das Rad gegen 23 Uhr am Fahrradständer vor Ihrem Haus abgestellt \
        und am nächsten Morgen festgestellt, dass es gestohlen wurde. Eine Erstattung ist daher leider nicht möglich.
        Wir möchten Sie darauf hinweisen, dass wir seit diesem Jahr einen Tarif ohne Nachtzeitklausel anbieten. \
        Eine Umstellung ist jederzeit zum nächsten Monatsersten möglich; der Beitrag erhöht sich dabei um 2,40 Euro im Monat.
        Sind Sie mit unserer Entscheidung nicht einverstanden, können Sie sich kostenfrei an den Versicherungsombudsmann wenden.

        Mit freundlichen Grüßen
        Ihre Schadenabteilung
        """,
        questions: [
            ReadingQuestion(prompt: "Why won't the insurer pay?",
                            options: ["She told the police too late", "It was stolen at night and wasn't locked away indoors",
                                      "Bikes aren't covered by her contract"],
                            answer: 1,
                            evidence: "Danach besteht zwischen 22 und 6 Uhr nur dann Versicherungsschutz, "
                                + "wenn sich das Fahrrad in einem verschlossenen Raum befindet "
                                + "oder zu dieser Zeit nachweislich in Gebrauch war."),
            ReadingQuestion(prompt: "What does the insurer offer her?",
                            options: ["Half the value of the bike", "A cheaper contract",
                                      "A contract without the night-time rule, for a little more"],
                            answer: 2,
                            evidence: "Wir möchten Sie darauf hinweisen, dass wir seit diesem Jahr "
                                + "einen Tarif ohne Nachtzeitklausel anbieten."),
            ReadingQuestion(prompt: "What can she do if she disagrees?",
                            options: ["Turn to the insurance ombudsman for free", "Go to court at once", "Send the police report again"],
                            answer: 0,
                            evidence: "Sind Sie mit unserer Entscheidung nicht einverstanden, "
                                + "können Sie sich kostenfrei an den Versicherungsombudsmann wenden.")
        ])

    static let c1WaterDamage = ReadingText(
        id: "c1-water-damage", level: .c1, kind: .message,
        title: "A voice message from your landlady", detail: "Water through the ceiling",
        systemImage: "waveform",
        german: """
        Hallo Herr Okafor, hier ist Brandt, Ihre Vermieterin. Ich hab gerade mit Herrn Yilmaz von oben gesprochen. \
        Bei ihm ist wohl heute Nacht der Schlauch an der Waschmaschine geplatzt, und das Wasser ist offenbar bis zu Ihnen durchgekommen.
        Erst mal das Wichtigste: Schalten Sie bitte vorsichtshalber die Sicherung fürs Bad aus, bis sich das jemand angesehen hat.
        Der Installateur kommt morgen zwischen acht und zehn. \
        Falls Sie da schon weg sind, könnten Sie den Schlüssel vielleicht bei Frau Kühn im Erdgeschoss lassen?
        Und machen Sie bitte Fotos von allem, was nass geworden ist, auch von Ihren eigenen Sachen. \
        Ihre Möbel sind ja über Ihre Hausratversicherung abgedeckt, nicht über meine.
        Kann gut sein, dass danach ein paar Wochen ein Trocknungsgerät laufen muss. Das ist laut, ich weiß. \
        Den Strom dafür bekommen Sie selbstverständlich erstattet.
        Rufen Sie mich einfach zurück, wenn was ist. Danke Ihnen!
        """,
        questions: [
            ReadingQuestion(prompt: "What should he do straight away?",
                            options: ["Call the plumber", "Switch off the fuse for the bathroom", "Move his furniture out"],
                            answer: 1,
                            evidence: "Erst mal das Wichtigste: Schalten Sie bitte vorsichtshalber die Sicherung fürs Bad aus, "
                                + "bis sich das jemand angesehen hat."),
            ReadingQuestion(prompt: "Whose insurance pays for his furniture?",
                            options: ["The landlady's", "The neighbour's upstairs", "His own household insurance"],
                            answer: 2,
                            evidence: "Ihre Möbel sind ja über Ihre Hausratversicherung abgedeckt, nicht über meine."),
            ReadingQuestion(prompt: "Who pays for the electricity of the drying machine?",
                            options: ["He gets it paid back", "He pays it himself", "All the tenants share it"],
                            answer: 0,
                            evidence: "Den Strom dafür bekommen Sie selbstverständlich erstattet.")
        ])

    static let c1Inn = ReadingText(
        id: "c1-inn", level: .c1, kind: .menu,
        title: "The menu at a country inn", detail: "Booking for a big group",
        systemImage: "wineglass.fill",
        german: """
        Gasthaus Zur Linde – Herbstkarte
        Unsere Küche verarbeitet überwiegend Zutaten von Höfen aus der Region; das Angebot richtet sich daher nach der Saison.

        Kürbiscremesuppe mit gerösteten Kernen und Kernöl – 7,50 €
        Wildgulasch vom heimischen Reh mit Preiselbeeren und Serviettenknödeln – 24,90 €
        Geschmorte Ochsenbacke in Rotweinjus mit Selleriepüree – 26,50 €
        Gebratene Steinpilze auf Rahmpolenta (auf Wunsch vegan zubereitet) – 18,90 €
        Zwetschgendatschi mit geschlagener Sahne – 6,80 €

        Da wir sämtliche Gerichte frisch zubereiten, kann es zu Stoßzeiten zu Wartezeiten von bis zu 40 Minuten kommen.
        Für Gesellschaften ab zehn Personen bieten wir ausschließlich unser Drei-Gänge-Menü zu 45 € pro Person an; \
        um Vorbestellung bis spätestens drei Tage vorher wird gebeten.
        Mitgebrachter Wein ist willkommen; wir berechnen ein Korkgeld von 15 € pro Flasche.
        Über Allergene informiert Sie unser Servicepersonal gern.
        """,
        questions: [
            ReadingQuestion(prompt: "You're booking for twelve people. What can you have?",
                            options: ["Anything on the menu", "Only the three-course menu, ordered in advance", "Only soup and a main"],
                            answer: 1,
                            evidence: "Für Gesellschaften ab zehn Personen bieten wir ausschließlich unser Drei-Gänge-Menü "
                                + "zu 45 € pro Person an"),
            ReadingQuestion(prompt: "A friend is vegan. Which dish can the kitchen make for her?",
                            options: ["The pumpkin soup", "The plum cake", "The porcini mushrooms"],
                            answer: 2,
                            evidence: "Gebratene Steinpilze auf Rahmpolenta (auf Wunsch vegan zubereitet) – 18,90 €"),
            ReadingQuestion(prompt: "You bring two bottles of your own wine. What does that cost?",
                            options: ["Nothing", "15 euros", "30 euros"],
                            answer: 2,
                            evidence: "Mitgebrachter Wein ist willkommen; wir berechnen ein Korkgeld von 15 € pro Flasche.")
        ])

    static let c1JobAd = ReadingText(
        id: "c1-job-ad", level: .c1, kind: .advert,
        title: "A job advert", detail: "A post at the city library",
        systemImage: "briefcase.fill",
        german: """
        Die Stadtbibliothek sucht eine Koordinatorin oder einen Koordinator für Leseförderung (m/w/d)

        Teilzeit (30 Stunden) oder Vollzeit, unbefristet, Entgeltgruppe E 10 TVöD
        Ihre Aufgaben: Sie entwickeln Angebote, die Kinder und Jugendliche fürs Lesen begeistern, \
        und bauen Kooperationen mit Schulen und Kitas im Stadtgebiet auf.
        Darüber hinaus betreuen Sie unser Team aus rund 20 Ehrenamtlichen, die Vorlesestunden in mehreren Sprachen anbieten.
        Ihr Profil: ein abgeschlossenes Studium der Bibliothekswissenschaft, der Pädagogik oder eines vergleichbaren Fachs \
        sowie mindestens zwei Jahre Berufserfahrung in der Bildungsarbeit.
        Mehrsprachigkeit ist ausdrücklich erwünscht, aber keine Voraussetzung.
        Wir bieten flexible Arbeitszeiten, ein vergünstigtes Deutschlandticket \
        und die Möglichkeit, an bis zu zwei Tagen pro Woche mobil zu arbeiten.
        Bitte verzichten Sie auf ein Foto sowie auf Angaben zu Alter und Familienstand; \
        wir beurteilen Bewerbungen ausschließlich nach der Qualifikation.
        Bewerbungen bis zum 15. Januar über unser Online-Portal.
        """,
        questions: [
            ReadingQuestion(prompt: "Do you have to speak several languages?",
                            options: ["No, but it's welcome", "Yes, it's a must", "Only English is needed"],
                            answer: 0,
                            evidence: "Mehrsprachigkeit ist ausdrücklich erwünscht, aber keine Voraussetzung."),
            ReadingQuestion(prompt: "Who would you look after?",
                            options: ["About 20 volunteers", "The library's whole staff", "Teachers at local schools"],
                            answer: 0,
                            evidence: "Darüber hinaus betreuen Sie unser Team aus rund 20 Ehrenamtlichen, "
                                + "die Vorlesestunden in mehreren Sprachen anbieten."),
            ReadingQuestion(prompt: "What should you leave out of your application?",
                            options: ["Your degree", "Your work experience", "A photo, your age and whether you're married"],
                            answer: 2,
                            evidence: "Bitte verzichten Sie auf ein Foto sowie auf Angaben zu Alter und Familienstand")
        ])

    static let c1OfficeDays = ReadingText(
        id: "c1-office-days", level: .c1, kind: .announcement,
        title: "An announcement at work", detail: "Back to the office?",
        systemImage: "megaphone.fill",
        german: """
        Neue Regelung zum mobilen Arbeiten ab 1. Februar

        Liebe Kolleginnen und Kollegen,
        nach intensiven Verhandlungen haben sich Geschäftsführung und Betriebsrat auf eine neue Betriebsvereinbarung geeinigt.
        Künftig gilt: An mindestens zwei festen Tagen pro Woche arbeiten alle Teams vor Ort; \
        welche Tage das sind, legt jedes Team selbst fest.
        An den übrigen Tagen kann flexibel von zu Hause oder unterwegs gearbeitet werden, \
        sofern die Erreichbarkeit zwischen 10 und 15 Uhr gewährleistet ist.
        Da nicht mehr jeder Arbeitsplatz täglich genutzt wird, führen wir im dritten Stock ein Buchungssystem für Schreibtische ein. \
        Persönliche Gegenstände sind daher bitte am Ende des Tages in den Spinden zu verstauen.
        Wer aus gesundheitlichen oder familiären Gründen eine abweichende Regelung benötigt, kann diese beim Betriebsrat beantragen.
        Ihre Fragen beantworten wir gern bei einer Informationsveranstaltung am 20. Januar.

        Ihre Geschäftsführung und Ihr Betriebsrat
        """,
        questions: [
            ReadingQuestion(prompt: "Who decides which days a team is in the office?",
                            options: ["Each team itself", "The management", "The works council"],
                            answer: 0,
                            evidence: "welche Tage das sind, legt jedes Team selbst fest."),
            ReadingQuestion(prompt: "On the other days, what is the condition for working from home?",
                            options: ["Working longer hours", "Booking a desk first", "Being reachable from 10 to 3"],
                            answer: 2,
                            evidence: "sofern die Erreichbarkeit zwischen 10 und 15 Uhr gewährleistet ist."),
            ReadingQuestion(prompt: "You need another arrangement because of your child. What can you do?",
                            options: ["Apply to the works council", "Ask your team", "Wait for the meeting on 20 January"],
                            answer: 0,
                            evidence: "Wer aus gesundheitlichen oder familiären Gründen eine abweichende Regelung benötigt, "
                                + "kann diese beim Betriebsrat beantragen.")
        ])

    static let c1Delays = ReadingText(
        id: "c1-delays", level: .c1, kind: .article,
        title: "A comment in the paper", detail: "Sorry for the delay",
        systemImage: "quote.bubble.fill",
        german: """
        Kommentar: Bitte entschuldigen Sie die Verspätung

        Kaum ein Satz wird in Deutschland so häufig gesprochen und so selten geglaubt. \
        Wer regelmäßig Zug fährt, kennt die Durchsagen inzwischen auswendig: \
        Verzögerungen im Betriebsablauf, eine Reparatur am Zug, Personen im Gleis.
        Man könnte darüber lachen, wenn es nicht so viele Menschen beträfe, die pünktlich zur Arbeit, zur Kita oder zum Arzt müssen.
        Dabei liegt das Problem weniger bei den Beschäftigten, die oft unter schwierigsten Bedingungen versuchen, \
        den Betrieb aufrechtzuerhalten.
        Es liegt in jahrzehntelangen Versäumnissen: Statt in Gleise, Weichen und Stellwerke zu investieren, hat man lieber gespart.
        Nun soll in wenigen Jahren nachgeholt werden, was über Generationen vernachlässigt wurde, \
        und das bedeutet zunächst noch mehr Baustellen.
        Wer jetzt eine schnelle Besserung verspricht, macht es sich zu leicht. \
        Ehrlicher wäre es, den Fahrgästen zu sagen, dass es erst schlechter wird, bevor es besser werden kann.
        """,
        questions: [
            ReadingQuestion(prompt: "Where does the writer see the real problem?",
                            options: ["With the staff on the trains", "In decades of too little investment",
                                      "With passengers who complain"],
                            answer: 1,
                            evidence: "Es liegt in jahrzehntelangen Versäumnissen: "
                                + "Statt in Gleise, Weichen und Stellwerke zu investieren, hat man lieber gespart."),
            ReadingQuestion(prompt: "Why will things get worse first?",
                            options: ["Fewer people work for the railway", "Tickets get more expensive",
                                      "The repairs mean even more building sites"],
                            answer: 2,
                            evidence: "und das bedeutet zunächst noch mehr Baustellen."),
            ReadingQuestion(prompt: "What does the writer want from those in charge?",
                            options: ["Faster trains", "Cheaper tickets as an apology", "Honesty that it will take time"],
                            answer: 2,
                            evidence: "Ehrlicher wäre es, den Fahrgästen zu sagen, "
                                + "dass es erst schlechter wird, bevor es besser werden kann.")
        ])
}
