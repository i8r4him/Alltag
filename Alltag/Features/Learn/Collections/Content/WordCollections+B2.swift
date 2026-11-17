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
            CollectionWord("die ", "Geborgenheit", "feeling safe and loved",
                           "Bei meinen Großeltern habe ich mich immer geborgen gefühlt, diese Geborgenheit vermisse ich.",
                           "I always felt safe and loved at my grandparents’; I miss that feeling."),
            CollectionWord("die ", "Verlegenheit", "embarrassment",
                           "Vor Verlegenheit wurde er ganz rot.", "He went bright red with embarrassment."),
            CollectionWord("die ", "Eifersucht", "jealousy",
                           "Seine Eifersucht hat am Ende alles kaputt gemacht.", "In the end his jealousy ruined everything."),
            CollectionWord("die ", "Auseinandersetzung", "row, dispute",
                           "Nach der Auseinandersetzung herrschte tagelang Funkstille.", "After the row there was radio silence for days."),
            CollectionWord("der ", "Vorwurf", "reproach, blame",
                           "Ich will dir keinen Vorwurf machen, aber du hättest anrufen können.",
                           "I don’t want to blame you, but you could have called."),
            CollectionWord("die ", "Enttäuschung", "disappointment",
                           "Die Absage war eine große Enttäuschung für sie.", "Being turned down was a big disappointment for her."),
            CollectionWord("die ", "Wertschätzung", "appreciation",
                           "In unserem Team fehlt manchmal die Wertschätzung.", "Our team sometimes lacks appreciation."),
            CollectionWord("die ", "Trennung", "break-up",
                           "Nach der Trennung ist er in eine kleinere Wohnung gezogen.",
                           "After the break-up he moved into a smaller flat."),
            CollectionWord("der ", "Kompromiss", "compromise",
                           "Am Ende haben wir einen Kompromiss gefunden.", "In the end we found a compromise."),
            CollectionWord("", "nachtragend", "holding a grudge",
                           "Sei nicht so nachtragend, das ist doch schon Jahre her.", "Don’t hold a grudge, that was years ago."),
            CollectionWord("die ", "Gemeinsamkeit", "something in common",
                           "Wir haben viele Gemeinsamkeiten, zum Beispiel die Liebe zur Musik.",
                           "We have a lot in common, for example our love of music."),
            CollectionWord("", "sich anvertrauen", "to confide in",
                           "Meiner besten Freundin kann ich mich immer anvertrauen.", "I can always confide in my best friend."),
            CollectionWord("", "verzeihen", "to forgive",
                           "Kannst du mir das noch einmal verzeihen?", "Can you forgive me one more time?"),
            CollectionWord("", "sich auseinanderleben", "to drift apart",
                           "Nach dem Studium haben wir uns leider auseinandergelebt.", "After university we sadly drifted apart."),
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
            CollectionWord("die ", "Teilhabe", "participation",
                           "Jeder soll die Chance auf Teilhabe am gesellschaftlichen Leben haben.",
                           "Everyone should have the chance to take part in society."),
            CollectionWord("die ", "Generation", "generation",
                           "Die ältere Generation nutzt das Internet anders.", "The older generation uses the internet differently."),
            CollectionWord("der ", "Wohlstand", "prosperity, wealth",
                           "Der Wohlstand ist in Deutschland ungleich verteilt.", "Wealth is unevenly distributed in Germany."),
            CollectionWord("die ", "Armut", "poverty",
                           "Viele Rentner sind von Armut bedroht.", "Many pensioners are at risk of poverty."),
            CollectionWord("die ", "Toleranz", "tolerance",
                           "Toleranz bedeutet, auch andere Meinungen zu akzeptieren.", "Tolerance means accepting other opinions too."),
            CollectionWord("die ", "Chancengleichheit", "equal opportunities",
                           "Bildung ist der Schlüssel zur Chancengleichheit.", "Education is the key to equal opportunities."),
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
            CollectionWord("die ", "Energiewende", "energy transition",
                           "Die Energiewende kostet viel Geld, ist aber notwendig.",
                           "The energy transition costs a lot of money but is necessary."),
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
            CollectionWord("die ", "künstliche Intelligenz", "artificial intelligence",
                           "Viele Firmen setzen inzwischen künstliche Intelligenz ein.", "Many companies now use artificial intelligence."),
            CollectionWord("der ", "Algorithmus", "algorithm",
                           "Der Algorithmus zeigt mir nur Videos, die mir gefallen.", "The algorithm only shows me videos I like."),
            CollectionWord("der ", "Speicherplatz", "storage space",
                           "Auf meinem Handy ist kein Speicherplatz mehr frei.", "There’s no storage space left on my phone."),
            CollectionWord("die ", "Datensicherung", "backup",
                           "Eine regelmäßige Datensicherung erspart viel Ärger.", "Regular backups save a lot of trouble."),
            CollectionWord("die ", "Privatsphäre", "privacy",
                           "In sozialen Netzwerken achte ich auf meine Privatsphäre.", "On social networks I’m careful about my privacy."),
            CollectionWord("der ", "Hackerangriff", "cyberattack",
                           "Nach einem Hackerangriff war die Website tagelang offline.",
                           "After a cyberattack the website was down for days."),
            CollectionWord("die ", "Verbindung", "connection",
                           "Im Zug ist die Verbindung ständig weg.", "On the train the connection keeps dropping."),
            CollectionWord("die ", "Zwei-Faktor-Authentifizierung", "two-factor authentication",
                           "Aktivieren Sie die Zwei-Faktor-Authentifizierung für Ihr Konto.",
                           "Turn on two-factor authentication for your account."),
            CollectionWord("die ", "Falschmeldung", "false report, fake news",
                           "Diese Falschmeldung wurde tausendfach geteilt.", "This fake news was shared thousands of times."),
            CollectionWord("die ", "Datei", "file",
                           "Die Datei ist zu groß zum Verschicken.", "The file is too big to send."),
            CollectionWord("der ", "Virenschutz", "antivirus software",
                           "Ist auf deinem Laptop ein Virenschutz installiert?", "Have you got antivirus software on your laptop?"),
            CollectionWord("", "verschlüsseln", "to encrypt",
                           "Die Nachrichten sind Ende-zu-Ende verschlüsselt.", "The messages are end-to-end encrypted."),
            CollectionWord("", "aktualisieren", "to update",
                           "Bitte aktualisieren Sie die App auf die neueste Version.", "Please update the app to the latest version."),
            CollectionWord("", "digitalisieren", "to digitise",
                           "Viele Ämter wollen ihre Formulare digitalisieren.", "Many public offices want to digitise their forms."),
            CollectionWord("", "abstürzen", "to crash",
                           "Mein Laptop stürzt dauernd ab.", "My laptop keeps crashing.")
        ]
    )
}
