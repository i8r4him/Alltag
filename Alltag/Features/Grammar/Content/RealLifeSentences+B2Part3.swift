//
//  RealLifeSentences+B2Part3.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The real-life sentences of the B2 rules, part 3: from reported speech
/// to the commas.
extension RealLifeSentence {
    static let b2Part3: [String: [RealLifeSentence]] = [
        "b2-indirekte-rede": [
            RealLifeSentence(place: "News on the radio", systemImage: "radio",
                             german: "Der Minister sagte, die Lage sei stabil.",
                             english: "The minister said the situation was stable.", marked: ["sei"]),
            RealLifeSentence(place: "News headline", systemImage: "newspaper",
                             german: "Die Polizei teilte mit, niemand sei verletzt worden.",
                             english: "The police said no one had been injured.", marked: ["sei", "worden"]),
            RealLifeSentence(place: "Newspaper article", systemImage: "newspaper",
                             german: "Der Trainer meinte, die Mannschaft habe gut gespielt.",
                             english: "The coach said the team had played well.", marked: ["habe", "gespielt"])
        ],
        "b2-temporal": [
            RealLifeSentence(place: "Message from a friend", systemImage: "message",
                             german: "Ruf mich an, sobald du da bist.",
                             english: "Call me as soon as you're there.", marked: ["sobald", "bist"]),
            RealLifeSentence(place: "Instructions in the box", systemImage: "shippingbox",
                             german: "Bevor Sie das Gerät reinigen, ziehen Sie den Stecker.",
                             english: "Before you clean the device, unplug it.", marked: ["Bevor", "reinigen"]),
            RealLifeSentence(place: "Small talk", systemImage: "bubble.left.and.bubble.right",
                             german: "Als ich nach Berlin kam, sprach ich kein Deutsch.",
                             english: "When I came to Berlin, I didn't speak any German.", marked: ["Als", "kam"])
        ],
        "b2-kausal-konzessiv": [
            RealLifeSentence(place: "Sign on a shop door", systemImage: "storefront",
                             german: "Da wir umbauen, bleibt der Laden geschlossen.",
                             english: "As we're renovating, the shop is closed.", marked: ["Da", "umbauen"]),
            RealLifeSentence(place: "Message from a friend", systemImage: "message",
                             german: "Obwohl es regnet, gehen wir joggen.",
                             english: "Although it's raining, we're going jogging.", marked: ["Obwohl", "regnet"]),
            RealLifeSentence(place: "A colleague at work", systemImage: "briefcase",
                             german: "Ich bin müde, trotzdem mache ich weiter.",
                             english: "I'm tired, but I'm carrying on anyway.", marked: ["trotzdem", "mache"])
        ],
        "b2-konsekutiv": [
            RealLifeSentence(place: "Weather warning", systemImage: "snowflake",
                             german: "Es schneit so stark, dass viele Straßen gesperrt sind.",
                             english: "It's snowing so heavily that many roads are closed.", marked: ["so", "dass", "sind"]),
            RealLifeSentence(place: "Station announcement", systemImage: "tram",
                             german: "Der Zug hat Verspätung, sodass Anschlüsse nicht erreicht werden.",
                             english: "The train is delayed, so some connections will be missed.", marked: ["sodass", "werden"]),
            RealLifeSentence(place: "Message from a friend", systemImage: "message",
                             german: "Ich war zu müde, um noch auszugehen.",
                             english: "I was too tired to go out.", marked: ["zu müde", "um", "auszugehen"])
        ],
        "b2-konditional": [
            RealLifeSentence(place: "Email from a hotel", systemImage: "bed.double",
                             german: "Falls Sie später ankommen, rufen Sie uns bitte an.",
                             english: "If you arrive later, please call us.", marked: ["Falls", "ankommen"]),
            RealLifeSentence(place: "Your tenancy agreement", systemImage: "doc.text",
                             german: "Sofern nichts anderes vereinbart ist, gilt der Vertrag ein Jahr.",
                             english: "Unless otherwise agreed, the contract runs for a year.", marked: ["Sofern", "ist"]),
            RealLifeSentence(place: "Small talk", systemImage: "bubble.left.and.bubble.right",
                             german: "Ich trinke Tee, während mein Mann nur Kaffee trinkt.",
                             english: "I drink tea, whereas my husband only drinks coffee.", marked: ["während", "trinkt"])
        ],
        "b2-modalsatz": [
            RealLifeSentence(place: "Tips on a website", systemImage: "lightbulb",
                             german: "Sparen Sie Strom, indem Sie Geräte ganz ausschalten.",
                             english: "Save electricity by switching devices off completely.", marked: ["indem", "ausschalten"]),
            RealLifeSentence(place: "A colleague at work", systemImage: "briefcase",
                             german: "Ich lerne Wörter, indem ich sie aufschreibe.",
                             english: "I learn words by writing them down.", marked: ["indem", "aufschreibe"]),
            RealLifeSentence(place: "News headline", systemImage: "newspaper",
                             german: "Die Stadt spart Geld dadurch, dass sie weniger Busse einsetzt.",
                             english: "The city is saving money by running fewer buses.", marked: ["dadurch", "dass", "einsetzt"])
        ],
        "b2-infinitiv": [
            RealLifeSentence(place: "Message from a friend", systemImage: "message",
                             german: "Hast du Lust, heute Abend zu kochen?",
                             english: "Do you fancy cooking tonight?", marked: ["zu kochen"]),
            RealLifeSentence(place: "A colleague at work", systemImage: "briefcase",
                             german: "Ich gehe kurz Mittag essen.",
                             english: "I'm just going for lunch.", marked: ["gehe", "essen"]),
            RealLifeSentence(place: "Letter from an office", systemImage: "envelope",
                             german: "Vergessen Sie nicht, den Ausweis mitzubringen.",
                             english: "Don't forget to bring your ID.", marked: ["mitzubringen"])
        ],
        "b2-dass-zu": [
            RealLifeSentence(place: "Job application", systemImage: "doc.text",
                             german: "Ich freue mich, von Ihnen zu hören.",
                             english: "I look forward to hearing from you.", marked: ["zu hören"]),
            RealLifeSentence(place: "Message from a friend", systemImage: "message",
                             german: "Ich hoffe, dass du bald wieder gesund bist.",
                             english: "I hope you're well again soon.", marked: ["dass", "bist"]),
            RealLifeSentence(place: "Email from work", systemImage: "at",
                             german: "Wir haben beschlossen, das Treffen zu verschieben.",
                             english: "We've decided to postpone the meeting.", marked: ["zu verschieben"])
        ],
        "b2-final": [
            RealLifeSentence(place: "Talking about your course", systemImage: "graduationcap",
                             german: "Ich mache den Kurs, um eine bessere Stelle zu finden.",
                             english: "I'm doing the course to find a better job.", marked: ["um", "zu finden"]),
            RealLifeSentence(place: "Message from a friend", systemImage: "message",
                             german: "Ich schicke dir die Adresse, damit du den Weg findest.",
                             english: "I'll send you the address so you can find your way.", marked: ["damit", "findest"]),
            RealLifeSentence(place: "A colleague at work", systemImage: "briefcase",
                             german: "Er ist gegangen, ohne sich zu verabschieden.",
                             english: "He left without saying goodbye.", marked: ["ohne", "zu verabschieden"])
        ],
        "b2-relativ": [
            RealLifeSentence(place: "Flat advert", systemImage: "house",
                             german: "Wir suchen eine Wohnung, die einen Balkon hat.",
                             english: "We're looking for a flat that has a balcony.", marked: ["die", "hat"]),
            RealLifeSentence(place: "Small talk", systemImage: "bubble.left.and.bubble.right",
                             german: "Das ist der Kollege, mit dem ich arbeite.",
                             english: "That's the colleague I work with.", marked: ["mit dem", "arbeite"]),
            RealLifeSentence(place: "Lost and found", systemImage: "magnifyingglass",
                             german: "Die Leute, denen das Fahrrad gehört, sind schon weg.",
                             english: "The people the bike belongs to have already gone.", marked: ["denen", "gehört"])
        ],
        "b2-relativ-genitiv": [
            RealLifeSentence(place: "News headline", systemImage: "newspaper",
                             german: "Die Familie, deren Haus abgebrannt ist, braucht Hilfe.",
                             english: "The family whose house burned down needs help.", marked: ["deren"]),
            RealLifeSentence(place: "Small talk", systemImage: "bubble.left.and.bubble.right",
                             german: "Das ist mein Nachbar, dessen Hund immer bellt.",
                             english: "That's my neighbour whose dog always barks.", marked: ["dessen"]),
            RealLifeSentence(place: "Job advert", systemImage: "briefcase",
                             german: "Wir sind eine Firma, deren Produkte jeder kennt.",
                             english: "We're a company whose products everyone knows.", marked: ["deren"])
        ],
        "b2-relativ-was": [
            RealLifeSentence(place: "In a shop", systemImage: "bag",
                             german: "Das ist alles, was ich brauche.",
                             english: "That's everything I need.", marked: ["was"]),
            RealLifeSentence(place: "Small talk", systemImage: "bubble.left.and.bubble.right",
                             german: "Hamburg ist die Stadt, wo ich geboren bin.",
                             english: "Hamburg is the city where I was born.", marked: ["wo"]),
            RealLifeSentence(place: "Sign at a cinema", systemImage: "film",
                             german: "Wer zu spät kommt, muss draußen warten.",
                             english: "Anyone who arrives late has to wait outside.", marked: ["Wer"])
        ],
        "b2-zweiteilig": [
            RealLifeSentence(place: "Flat advert", systemImage: "house",
                             german: "Die Wohnung ist zwar klein, aber sehr hell.",
                             english: "The flat is small, but very bright.", marked: ["zwar", "aber"]),
            RealLifeSentence(place: "Weather on the radio", systemImage: "radio",
                             german: "Morgen ist es teils sonnig, teils bewölkt.",
                             english: "Tomorrow will be partly sunny, partly cloudy.", marked: ["teils", "teils"]),
            RealLifeSentence(place: "Station announcement", systemImage: "tram",
                             german: "Der Zug fährt nicht von Gleis 3, sondern von Gleis 5.",
                             english: "The train leaves not from platform 3 but from platform 5.", marked: ["nicht", "sondern"])
        ],
        "b2-negation": [
            RealLifeSentence(place: "Looking for your keys", systemImage: "key",
                             german: "Ich finde meinen Schlüssel nirgends.",
                             english: "I can't find my key anywhere.", marked: ["nirgends"]),
            RealLifeSentence(place: "Phone call to an office", systemImage: "phone",
                             german: "Es ist leider niemand da.",
                             english: "I'm afraid nobody's here.", marked: ["niemand"]),
            RealLifeSentence(place: "Message from a friend", systemImage: "message",
                             german: "Ich rauche nicht mehr.",
                             english: "I don't smoke any more.", marked: ["nicht mehr"])
        ],
        "b2-irgend": [
            RealLifeSentence(place: "Message from a friend", systemImage: "message",
                             german: "Lass uns irgendwann was trinken gehen.",
                             english: "Let's go for a drink sometime.", marked: ["irgendwann"]),
            RealLifeSentence(place: "Lost and found", systemImage: "magnifyingglass",
                             german: "Irgendjemand hat seine Tasche vergessen.",
                             english: "Somebody has left their bag behind.", marked: ["Irgendjemand"]),
            RealLifeSentence(place: "A colleague at work", systemImage: "briefcase",
                             german: "Das klappt schon irgendwie.",
                             english: "It'll work out somehow.", marked: ["irgendwie"])
        ],
        "b2-richtung": [
            RealLifeSentence(place: "Moving house", systemImage: "shippingbox",
                             german: "Stell die Lampe bitte neben das Sofa.",
                             english: "Please put the lamp next to the sofa.", marked: ["Stell", "das"]),
            RealLifeSentence(place: "Message from a friend", systemImage: "message",
                             german: "Komm rein, die Tür ist offen!",
                             english: "Come in, the door's open!", marked: ["rein"]),
            RealLifeSentence(place: "In the kitchen", systemImage: "fork.knife",
                             german: "Der Schlüssel hängt neben der Tür.",
                             english: "The key is hanging by the door.", marked: ["hängt", "der"])
        ],
        "b2-es": [
            RealLifeSentence(place: "Weather on the radio", systemImage: "radio",
                             german: "Morgen gibt es viel Sonne.",
                             english: "Tomorrow there'll be lots of sun.", marked: ["gibt es"]),
            RealLifeSentence(place: "Email from work", systemImage: "at",
                             german: "Es freut mich, dass es geklappt hat.",
                             english: "I'm pleased it worked out.", marked: ["Es", "es"]),
            RealLifeSentence(place: "Message from a friend", systemImage: "message",
                             german: "Wie geht es dir?",
                             english: "How are you?", marked: ["es"])
        ],
        "b2-funktionsverben": [
            RealLifeSentence(place: "Letter from an office", systemImage: "envelope",
                             german: "Bitte stellen Sie den Antrag online.",
                             english: "Please submit the application online.", marked: ["stellen", "den Antrag"]),
            RealLifeSentence(place: "Email from work", systemImage: "at",
                             german: "Geben Sie mir bitte bis Freitag Bescheid.",
                             english: "Please let me know by Friday.", marked: ["Geben", "Bescheid"]),
            RealLifeSentence(place: "News headline", systemImage: "newspaper",
                             german: "Das neue Gesetz tritt im Januar in Kraft.",
                             english: "The new law comes into force in January.", marked: ["tritt", "in Kraft"])
        ],
        "b2-da-woerter": [
            RealLifeSentence(place: "Message from a friend", systemImage: "message",
                             german: "Ich freue mich schon darauf!",
                             english: "I'm already looking forward to it!", marked: ["darauf"]),
            RealLifeSentence(place: "Email from work", systemImage: "at",
                             german: "Ich kümmere mich darum.",
                             english: "I'll take care of it.", marked: ["darum"]),
            RealLifeSentence(place: "A colleague at work", systemImage: "briefcase",
                             german: "Denk bitte daran, das Licht auszumachen.",
                             english: "Please remember to switch off the light.", marked: ["daran"])
        ],
        "b2-modalpartikeln": [
            RealLifeSentence(place: "Message from a friend", systemImage: "message",
                             german: "Komm doch mal vorbei!",
                             english: "Why don't you drop by!", marked: ["doch", "mal"]),
            RealLifeSentence(place: "At home", systemImage: "house",
                             german: "Was machst du denn da?",
                             english: "What are you doing there?", marked: ["denn"]),
            RealLifeSentence(place: "A colleague at work", systemImage: "briefcase",
                             german: "Das ist halt so.",
                             english: "That's just the way it is.", marked: ["halt"])
        ],
        "b2-komma": [
            RealLifeSentence(place: "Email from work", systemImage: "at",
                             german: "Ich hoffe, dass alles gut geklappt hat.",
                             english: "I hope everything went well.", marked: [", dass"]),
            RealLifeSentence(place: "Letter from an office", systemImage: "envelope",
                             german: "Bitte bringen Sie alle Unterlagen mit, die Sie haben.",
                             english: "Please bring all the documents you have.", marked: [", die"]),
            RealLifeSentence(place: "Message from a friend", systemImage: "message",
                             german: "Ich komme später, weil der Bus nicht fährt.",
                             english: "I'll be late because the bus isn't running.", marked: [", weil"])
        ]
    ]
}
