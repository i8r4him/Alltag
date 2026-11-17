//
//  WordCollections+B2.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension WordCollections {
    /// B2: nineteen topics of fifteen words, in the `WordCollections+B2…` files.
    /// This file has people and everyday life.
    static let b2: [WordCollection] = [
        b2Relationships, b2Society, b2News, b2Environment, b2Digital, b2Diet, b2Complaints, b2Renting, b2Repairs,
        b2Hospital, b2WellBeing, b2TravelTrouble, b2Driving, b2Meetings, b2Career, b2Contracts, b2Taxes, b2Culture,
        b2Volunteering
    ]

    static let b2Relationships = WordCollection(
        id: "b2-beziehungen", title: "Beziehungen und Gefühle", subtitle: "Relationships and feelings", level: .b2,
        category: .people, systemImage: "heart.fill",
        words: [
            CollectionWord("die ", "Beziehung", "relationship",
                           "Unsere Beziehung ist durch die Entfernung nicht einfacher geworden.",
                           "The distance hasn’t made our relationship any easier."),
            CollectionWord("das ", "Vertrauen", "trust",
                           "Ohne Vertrauen funktioniert keine Freundschaft.", "No friendship works without trust."),
            CollectionWord("die ", "Eifersucht", "jealousy",
                           "Seine Eifersucht hat am Ende alles kaputt gemacht.", "In the end his jealousy ruined everything."),
            CollectionWord("das ", "Missverständnis", "misunderstanding",
                           "Das war nur ein Missverständnis, ich habe es nicht so gemeint.",
                           "That was just a misunderstanding, I didn’t mean it like that."),
            CollectionWord("der ", "Streit", "argument",
                           "Nach dem Streit haben wir zwei Tage nicht miteinander geredet.",
                           "After the argument we didn’t talk to each other for two days."),
            CollectionWord("die ", "Enttäuschung", "disappointment",
                           "Die Absage war eine große Enttäuschung für sie.", "Being turned down was a big disappointment for her."),
            CollectionWord("die ", "Geduld", "patience",
                           "Mit kleinen Kindern braucht man viel Geduld.", "You need a lot of patience with small children."),
            CollectionWord("die ", "Trennung", "break-up",
                           "Nach der Trennung ist er in eine kleinere Wohnung gezogen.",
                           "After the break-up he moved into a smaller flat."),
            CollectionWord("der ", "Kompromiss", "compromise",
                           "Am Ende haben wir einen Kompromiss gefunden.", "In the end we found a compromise."),
            CollectionWord("die ", "Rücksicht", "consideration",
                           "Nimm bitte ein bisschen Rücksicht auf deine Mitbewohner.",
                           "Please show your flatmates a bit of consideration."),
            CollectionWord("die ", "Gemeinsamkeit", "something in common",
                           "Wir haben viele Gemeinsamkeiten, zum Beispiel die Liebe zur Musik.",
                           "We have a lot in common, for example our love of music."),
            CollectionWord("", "sich verlassen auf", "to rely on",
                           "Auf meine Schwester kann ich mich immer verlassen.", "I can always rely on my sister."),
            CollectionWord("", "sich versöhnen", "to make up",
                           "Nach einer Woche haben sie sich wieder versöhnt.", "After a week they made up again."),
            CollectionWord("", "sich Sorgen machen", "to worry",
                           "Mach dir keine Sorgen, ich komme bestimmt pünktlich.", "Don’t worry, I’ll definitely be on time."),
            CollectionWord("", "gekränkt", "hurt, offended",
                           "Sie war gekränkt, weil niemand an ihren Geburtstag gedacht hat.",
                           "She was hurt because nobody remembered her birthday.")
        ]
    )

    static let b2Society = WordCollection(
        id: "b2-gesellschaft", title: "Zusammenleben und Gesellschaft", subtitle: "Society and living together", level: .b2,
        category: .people, systemImage: "person.3.fill",
        words: [
            CollectionWord("die ", "Gesellschaft", "society",
                           "In unserer Gesellschaft leben Menschen aus vielen Ländern zusammen.",
                           "People from many countries live together in our society."),
            CollectionWord("die ", "Integration", "integration",
                           "Sprachkurse sind ein wichtiger Teil der Integration.",
                           "Language courses are an important part of integration."),
            CollectionWord("die ", "Vielfalt", "diversity",
                           "Die kulturelle Vielfalt in Berlin gefällt mir sehr.", "I really like Berlin’s cultural diversity."),
            CollectionWord("das ", "Vorurteil", "prejudice",
                           "Viele Vorurteile verschwinden, wenn man sich persönlich kennenlernt.",
                           "Many prejudices disappear when people get to know each other."),
            CollectionWord("die ", "Gleichberechtigung", "equal rights",
                           "Gleichberechtigung im Beruf ist noch nicht überall selbstverständlich.",
                           "Equal rights at work aren’t yet taken for granted everywhere."),
            CollectionWord("die ", "Herkunft", "background, origin",
                           "Ihre Herkunft spielt bei der Bewerbung keine Rolle.", "Your background plays no part in the application."),
            CollectionWord("die ", "Staatsangehörigkeit", "citizenship",
                           "Sie hat die deutsche Staatsangehörigkeit beantragt.", "She has applied for German citizenship."),
            CollectionWord("die ", "Generation", "generation",
                           "Die ältere Generation nutzt das Internet anders.", "The older generation uses the internet differently."),
            CollectionWord("die ", "Rente", "pension",
                           "Meine Eltern gehen nächstes Jahr in Rente.", "My parents are retiring next year."),
            CollectionWord("die ", "Armut", "poverty",
                           "Viele Rentner sind von Armut bedroht.", "Many pensioners are at risk of poverty."),
            CollectionWord("die ", "Toleranz", "tolerance",
                           "Toleranz bedeutet, auch andere Meinungen zu akzeptieren.", "Tolerance means accepting other opinions too."),
            CollectionWord("die ", "Nachbarschaft", "neighbourhood",
                           "In unserer Nachbarschaft hilft man sich gegenseitig.", "In our neighbourhood people help each other."),
            CollectionWord("", "sich einleben", "to settle in",
                           "Wir haben uns in der neuen Stadt schnell eingelebt.", "We settled into the new town quickly."),
            CollectionWord("", "sich anpassen", "to adapt",
                           "Am Anfang fiel es mir schwer, mich anzupassen.", "At first I found it hard to adapt."),
            CollectionWord("", "benachteiligen", "to put at a disadvantage",
                           "Niemand darf wegen seiner Religion benachteiligt werden.",
                           "Nobody may be put at a disadvantage because of their religion.")
        ]
    )

    static let b2News = WordCollection(
        id: "b2-nachrichten", title: "Nachrichten und Politik", subtitle: "News and politics", level: .b2,
        category: .everyday, systemImage: "newspaper.fill",
        words: [
            CollectionWord("die ", "Regierung", "government",
                           "Die Regierung hat neue Maßnahmen angekündigt.", "The government has announced new measures."),
            CollectionWord("die ", "Wahl", "election",
                           "Vor der Wahl informiere ich mich über die Programme der Parteien.",
                           "Before the election I read up on what the parties stand for."),
            CollectionWord("die ", "Partei", "party",
                           "Welche Partei hat die meisten Stimmen bekommen?", "Which party got the most votes?"),
            CollectionWord("die ", "Opposition", "opposition",
                           "Die Opposition kritisiert den Plan scharf.", "The opposition sharply criticises the plan."),
            CollectionWord("das ", "Gesetz", "law",
                           "Das neue Gesetz tritt im Januar in Kraft.", "The new law comes into force in January."),
            CollectionWord("die ", "Abstimmung", "vote",
                           "Die Abstimmung im Bundestag ist für Freitag geplant.", "The vote in the Bundestag is planned for Friday."),
            CollectionWord("die ", "Demonstration", "demonstration",
                           "Am Samstag gibt es eine große Demonstration in der Innenstadt.",
                           "There’s a big demonstration in the city centre on Saturday."),
            CollectionWord("die ", "Meinungsfreiheit", "freedom of speech",
                           "Die Meinungsfreiheit ist im Grundgesetz geschützt.", "Freedom of speech is protected by the Basic Law."),
            CollectionWord("die ", "Schlagzeile", "headline",
                           "Die Schlagzeile klingt dramatischer als der Artikel.", "The headline sounds more dramatic than the article."),
            CollectionWord("die ", "Quelle", "source",
                           "Prüf lieber die Quelle, bevor du das teilst.", "Better check the source before you share that."),
            CollectionWord("die ", "Umfrage", "poll, survey",
                           "Laut einer Umfrage sind die meisten Menschen dagegen.", "According to a poll, most people are against it."),
            CollectionWord("der ", "Rücktritt", "resignation",
                           "Nach dem Skandal hat die Ministerin ihren Rücktritt erklärt.",
                           "After the scandal the minister announced her resignation."),
            CollectionWord("", "wählen", "to vote",
                           "Ab 18 darf man in Deutschland den Bundestag wählen.",
                           "In Germany you can vote in Bundestag elections from 18."),
            CollectionWord("", "berichten", "to report",
                           "Alle Zeitungen berichten heute über den Streik.", "All the papers are reporting on the strike today."),
            CollectionWord("", "umstritten", "controversial",
                           "Der Vorschlag ist auch innerhalb der Partei umstritten.",
                           "The proposal is controversial even within the party.")
        ]
    )

    static let b2Environment = WordCollection(
        id: "b2-umwelt", title: "Umwelt und Klima", subtitle: "Environment", level: .b2,
        category: .everyday, systemImage: "leaf.fill",
        words: [
            CollectionWord("der ", "Klimawandel", "climate change",
                           "Der Klimawandel betrifft uns alle.", "Climate change affects us all."),
            CollectionWord("die ", "Erderwärmung", "global warming",
                           "Die Erderwärmung führt zu mehr Hitzewellen.", "Global warming leads to more heatwaves."),
            CollectionWord("die ", "Emissionen", "emissions (plural)",
                           "Die Emissionen im Verkehr sinken nur langsam.", "Transport emissions are only falling slowly."),
            CollectionWord("die ", "erneuerbaren Energien", "renewable energy (plural)",
                           "Der Anteil der erneuerbaren Energien wächst jedes Jahr.", "The share of renewable energy grows every year."),
            CollectionWord("die ", "Mülltrennung", "sorting rubbish",
                           "Die Mülltrennung nehmen viele Deutsche sehr ernst.", "Many Germans take sorting their rubbish very seriously."),
            CollectionWord("die ", "Mehrwegflasche", "returnable bottle",
                           "Wasser kaufe ich lieber in Mehrwegflaschen.", "I prefer to buy water in returnable bottles."),
            CollectionWord("die ", "Verschwendung", "waste",
                           "Lebensmittel wegzuwerfen ist reine Verschwendung.", "Throwing food away is a complete waste."),
            CollectionWord("die ", "Nachhaltigkeit", "sustainability",
                           "Beim Einkaufen achte ich mehr auf Nachhaltigkeit.", "When I shop I pay more attention to sustainability."),
            CollectionWord("der ", "Umweltschutz", "protecting the environment",
                           "Jeder kann etwas für den Umweltschutz tun.", "Everyone can do something to protect the environment."),
            CollectionWord("die ", "Überschwemmung", "flood",
                           "Nach dem Starkregen gab es Überschwemmungen im ganzen Tal.",
                           "After the heavy rain there were floods across the whole valley."),
            CollectionWord("die ", "Dürre", "drought",
                           "Wegen der Dürre war die Ernte dieses Jahr schlecht.", "Because of the drought the harvest was poor this year."),
            CollectionWord("der ", "Verbrauch", "consumption",
                           "Der Verbrauch von Plastik ist immer noch zu hoch.", "Plastic consumption is still too high."),
            CollectionWord("", "verschmutzen", "to pollute",
                           "Mikroplastik verschmutzt die Meere.", "Microplastics pollute the oceans."),
            CollectionWord("", "recyceln", "to recycle",
                           "Altes Glas kann man immer wieder recyceln.", "Old glass can be recycled again and again."),
            CollectionWord("", "umweltfreundlich", "environmentally friendly",
                           "Mit dem Rad zur Arbeit zu fahren ist am umweltfreundlichsten.",
                           "Cycling to work is the most environmentally friendly option.")
        ]
    )

    static let b2Digital = WordCollection(
        id: "b2-digital", title: "Internet und Technik", subtitle: "Digital life", level: .b2,
        category: .everyday, systemImage: "laptopcomputer",
        words: [
            CollectionWord("der ", "Datenschutz", "data protection",
                           "Beim Datenschutz ist Deutschland besonders streng.", "Germany is particularly strict about data protection."),
            CollectionWord("das ", "Passwort", "password",
                           "Benutz nicht überall dasselbe Passwort.", "Don’t use the same password everywhere."),
            CollectionWord("der ", "Speicherplatz", "storage space",
                           "Auf meinem Handy ist kein Speicherplatz mehr frei.", "There’s no storage space left on my phone."),
            CollectionWord("das ", "Update", "update",
                           "Nach dem Update funktioniert die App nicht mehr.", "Since the update the app doesn’t work any more."),
            CollectionWord("die ", "Benachrichtigung", "notification",
                           "Abends schalte ich alle Benachrichtigungen aus.", "In the evening I turn off all notifications."),
            CollectionWord("der ", "Bildschirm", "screen",
                           "Kinder sollten nicht zu lange vor dem Bildschirm sitzen.",
                           "Children shouldn’t sit in front of a screen for too long."),
            CollectionWord("die ", "Verbindung", "connection",
                           "Im Zug ist die Verbindung ständig weg.", "On the train the connection keeps dropping."),
            CollectionWord("die ", "Einstellungen", "settings (plural)",
                           "Das kannst du in den Einstellungen ändern.", "You can change that in the settings."),
            CollectionWord("der ", "Anhang", "attachment",
                           "Den Vertrag finden Sie im Anhang.", "You’ll find the contract attached."),
            CollectionWord("die ", "Datei", "file",
                           "Die Datei ist zu groß zum Verschicken.", "The file is too big to send."),
            CollectionWord("der ", "Betrug", "fraud, scam",
                           "Gib deine Bankdaten nie per SMS weiter, das ist oft Betrug.",
                           "Never give your bank details by text message; it’s often a scam."),
            CollectionWord("", "herunterladen", "to download",
                           "Die Fahrkarte kannst du als PDF herunterladen.", "You can download the ticket as a PDF."),
            CollectionWord("", "sich anmelden", "to log in",
                           "Ich kann mich nicht anmelden, mein Konto ist gesperrt.", "I can’t log in; my account is locked."),
            CollectionWord("", "speichern", "to save",
                           "Hast du das Dokument gespeichert?", "Did you save the document?"),
            CollectionWord("", "abstürzen", "to crash",
                           "Mein Laptop stürzt dauernd ab.", "My laptop keeps crashing.")
        ]
    )
}
