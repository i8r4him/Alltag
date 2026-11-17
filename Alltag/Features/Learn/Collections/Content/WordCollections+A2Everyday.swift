//
//  WordCollections+A2Everyday.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension WordCollections {
    // A2, everyday: your day, your phone, the weather.
    static let a2DailyRoutine = WordCollection(
        id: "a2-tagesablauf", title: "Mein Tag", subtitle: "Daily routine", level: .a2,
        category: .everyday, systemImage: "sun.horizon.fill",
        words: [
            CollectionWord("der ", "Wecker", "alarm clock",
                           "Mein Wecker klingelt um sechs.", "My alarm goes off at six."),
            CollectionWord("der ", "Alltag", "everyday life",
                           "Im Alltag spreche ich viel Deutsch.", "I speak a lot of German in everyday life."),
            CollectionWord("der ", "Vormittag", "morning",
                           "Am Vormittag habe ich Deutschkurs.", "I have my German class in the morning."),
            CollectionWord("das ", "Mittagessen", "lunch",
                           "Zum Mittagessen gibt es heute Suppe.", "There’s soup for lunch today."),
            CollectionWord("das ", "Abendessen", "dinner",
                           "Das Abendessen ist um sieben fertig.", "Dinner is ready at seven."),
            CollectionWord("", "aufstehen", "to get up",
                           "Am Wochenende stehe ich spät auf.", "At the weekend I get up late."),
            CollectionWord("", "duschen", "to have a shower",
                           "Ich dusche immer nach dem Sport.", "I always have a shower after sport."),
            CollectionWord("", "Zähne putzen", "to brush your teeth",
                           "Vergiss nicht, Zähne zu putzen!", "Don’t forget to brush your teeth!"),
            CollectionWord("", "frühstücken", "to have breakfast",
                           "Wir frühstücken um halb acht.", "We have breakfast at half past seven."),
            CollectionWord("", "einkaufen", "to do the shopping",
                           "Nach der Arbeit kaufe ich noch ein.", "After work I’ll do some shopping."),
            CollectionWord("", "sich ausruhen", "to rest",
                           "Nach dem Mittagessen ruhe ich mich kurz aus.", "After lunch I have a little rest."),
            CollectionWord("", "ins Bett gehen", "to go to bed",
                           "Unter der Woche gehe ich um elf ins Bett.", "During the week I go to bed at eleven."),
            CollectionWord("", "einschlafen", "to fall asleep",
                           "Ohne Musik kann ich nicht einschlafen.", "I can’t fall asleep without music."),
            CollectionWord("", "meistens", "usually",
                           "Meistens koche ich am Abend.", "I usually cook in the evening."),
            CollectionWord("", "früh", "early",
                           "Morgen muss ich früh raus.", "I have to get up early tomorrow.")
        ]
    )

    static let a2Phone = WordCollection(
        id: "a2-handy", title: "Handy und Internet", subtitle: "Phone and internet", level: .a2, category: .everyday, systemImage: "iphone",
        words: [
            CollectionWord("das ", "Handy", "mobile phone",
                           "Mein Handy ist gleich leer.", "My phone’s about to die."),
            CollectionWord("der ", "Akku", "battery",
                           "Der Akku hält nur noch einen halben Tag.", "The battery only lasts half a day now."),
            CollectionWord("das ", "Ladegerät", "charger",
                           "Kann ich kurz dein Ladegerät benutzen?", "Can I borrow your charger for a moment?"),
            CollectionWord("die ", "Nachricht", "message",
                           "Ich schicke dir gleich eine Nachricht.", "I’ll send you a message in a moment."),
            CollectionWord("die ", "Sprachnachricht", "voice message",
                           "Schick mir lieber eine Sprachnachricht.", "Better send me a voice message."),
            CollectionWord("der ", "Anruf", "call",
                           "Ich hatte drei verpasste Anrufe.", "I had three missed calls."),
            CollectionWord("das ", "Passwort", "password",
                           "Ich habe mein Passwort vergessen.", "I’ve forgotten my password."),
            CollectionWord("die ", "App", "app",
                           "Für die Bank brauche ich eine App.", "I need an app for the bank."),
            CollectionWord("der ", "Vertrag", "contract",
                           "Der Vertrag läuft noch ein Jahr.", "The contract has another year to run."),
            CollectionWord("das ", "Guthaben", "credit",
                           "Auf meiner Karte ist kein Guthaben mehr.", "There’s no credit left on my SIM."),
            CollectionWord("", "anrufen", "to call",
                           "Ruf mich an, wenn du Zeit hast.", "Call me when you’re free."),
            CollectionWord("", "zurückrufen", "to call back",
                           "Ich rufe Sie in zehn Minuten zurück.", "I’ll call you back in ten minutes."),
            CollectionWord("", "herunterladen", "to download",
                           "Ich lade die Datei gerade herunter.", "I’m downloading the file right now."),
            CollectionWord("", "aufladen", "to charge, to top up",
                           "Ich lade das Handy über Nacht auf.", "I charge my phone overnight."),
            CollectionWord("", "erreichen", "to reach",
                           "Ich kann dich seit gestern nicht erreichen.", "I haven’t been able to reach you since yesterday.")
        ]
    )

    static let a2Weather = WordCollection(
        id: "a2-wetter", title: "Das Wetter", subtitle: "The weather", level: .a2, category: .everyday, systemImage: "cloud.sun.fill",
        words: [
            CollectionWord("das ", "Wetter", "weather",
                           "Wie wird das Wetter morgen?", "What will the weather be like tomorrow?"),
            CollectionWord("die ", "Wettervorhersage", "weather forecast",
                           "Laut Wettervorhersage regnet es am Wochenende.", "According to the forecast it’ll rain at the weekend."),
            CollectionWord("der ", "Regen", "rain",
                           "Nach dem Regen kommt die Sonne wieder raus.", "After the rain the sun comes out again."),
            CollectionWord("der ", "Regenschirm", "umbrella",
                           "Ich habe meinen Regenschirm im Bus vergessen.", "I left my umbrella on the bus."),
            CollectionWord("der ", "Schnee", "snow",
                           "Im Januar liegt hier oft Schnee.", "There’s often snow here in January."),
            CollectionWord("das ", "Gewitter", "thunderstorm",
                           "Heute Nachmittag gibt es ein Gewitter.", "There’ll be a thunderstorm this afternoon."),
            CollectionWord("der ", "Wind", "wind",
                           "Der Wind ist heute richtig kalt.", "The wind is really cold today."),
            CollectionWord("die ", "Temperatur", "temperature",
                           "Die Temperaturen steigen auf 30 Grad.", "Temperatures will rise to 30 degrees."),
            CollectionWord("die ", "Wolke", "cloud",
                           "Am Himmel ist keine einzige Wolke.", "There isn’t a single cloud in the sky."),
            CollectionWord("das ", "Glatteis", "black ice",
                           "Fahr vorsichtig, es gibt Glatteis!", "Drive carefully, there’s black ice!"),
            CollectionWord("", "sonnig", "sunny",
                           "Morgen wird es sonnig und warm.", "Tomorrow will be sunny and warm."),
            CollectionWord("", "bewölkt", "cloudy",
                           "Heute ist es den ganzen Tag bewölkt.", "It’s cloudy all day today."),
            CollectionWord("", "regnen", "to rain",
                           "Es regnet schon seit drei Tagen.", "It’s been raining for three days."),
            CollectionWord("", "schwül", "muggy",
                           "Im Sommer ist es in der Stadt oft schwül.", "In summer it’s often muggy in the city."),
            CollectionWord("", "minus", "below zero",
                           "Heute Nacht sind es minus fünf Grad.", "It’ll be minus five tonight.")
        ]
    )
}
