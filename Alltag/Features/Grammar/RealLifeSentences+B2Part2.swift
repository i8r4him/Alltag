//
//  RealLifeSentences+B2Part2.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The real-life sentences of the B2 rules, part 2: from the verbs with a
/// fixed preposition to the participles.
extension RealLifeSentence {
    static let b2Part2: [String: [RealLifeSentence]] = [
        "b2-verb-praeposition": [
            RealLifeSentence(place: "Station announcement", systemImage: "tram",
                             german: "Wir bitten um Ihr Verständnis.",
                             english: "We ask for your understanding.", marked: ["um"]),
            RealLifeSentence(place: "Email from work", systemImage: "at",
                             german: "Ich kümmere mich um den Termin.",
                             english: "I'll take care of the appointment.", marked: ["um den"]),
            RealLifeSentence(place: "Message from a friend", systemImage: "message",
                             german: "Wartest du auf mich?",
                             english: "Are you waiting for me?", marked: ["auf"])
        ],
        "b2-nomen-praeposition": [
            RealLifeSentence(place: "Message from a friend", systemImage: "message",
                             german: "Hast du Lust auf Kino?",
                             english: "Do you fancy the cinema?", marked: ["Lust auf"]),
            RealLifeSentence(place: "Feedback at work", systemImage: "hand.thumbsup",
                             german: "Wir sind stolz auf unser Team.",
                             english: "We're proud of our team.", marked: ["stolz auf"]),
            RealLifeSentence(place: "Job advert", systemImage: "briefcase",
                             german: "Sie haben Interesse an Technik?",
                             english: "Are you interested in technology?", marked: ["Interesse an"])
        ],
        "b2-vergangenheit-formen": [
            RealLifeSentence(place: "Reading a novel", systemImage: "book",
                             german: "Sie öffnete die Tür und sah niemanden.",
                             english: "She opened the door and saw no one.", marked: ["öffnete", "sah"]),
            RealLifeSentence(place: "Message from a friend", systemImage: "message",
                             german: "Ich dachte, du kommst heute.",
                             english: "I thought you were coming today.", marked: ["dachte"]),
            RealLifeSentence(place: "News headline", systemImage: "newspaper",
                             german: "Als die Polizei kam, waren die Täter schon geflohen.",
                             english: "When the police arrived, the culprits had already fled.", marked: ["kam", "waren", "geflohen"])
        ],
        "b2-perfekt-modal": [
            RealLifeSentence(place: "Message from a friend", systemImage: "message",
                             german: "Ich habe leider nicht kommen können.",
                             english: "Sadly I wasn't able to come.", marked: ["habe", "kommen können"]),
            RealLifeSentence(place: "At the garage", systemImage: "car",
                             german: "Wir haben die Bremsen reparieren lassen.",
                             english: "We had the brakes repaired.", marked: ["haben", "reparieren lassen"]),
            RealLifeSentence(place: "A colleague at work", systemImage: "briefcase",
                             german: "Ich habe am Wochenende arbeiten müssen.",
                             english: "I had to work at the weekend.", marked: ["habe", "arbeiten müssen"])
        ],
        "b2-vergangenheit": [
            RealLifeSentence(place: "Monday at work", systemImage: "briefcase",
                             german: "Am Wochenende war ich in Hamburg.",
                             english: "I was in Hamburg at the weekend.", marked: ["war"]),
            RealLifeSentence(place: "Newspaper article", systemImage: "newspaper",
                             german: "Der Bürgermeister eröffnete gestern das Fest.",
                             english: "Yesterday the mayor opened the festival.", marked: ["eröffnete"]),
            RealLifeSentence(place: "Message from a friend", systemImage: "message",
                             german: "Ich habe gestern einen tollen Film gesehen.",
                             english: "I saw a great film yesterday.", marked: ["habe", "gesehen"])
        ],
        "b2-futur": [
            RealLifeSentence(place: "Waiting for a friend", systemImage: "clock",
                             german: "Sie wird im Stau stehen.",
                             english: "She'll be stuck in traffic.", marked: ["wird", "stehen"]),
            RealLifeSentence(place: "A colleague at work", systemImage: "briefcase",
                             german: "Er wird den Termin vergessen haben.",
                             english: "He'll have forgotten the appointment.", marked: ["wird", "vergessen haben"]),
            RealLifeSentence(place: "Weather on the radio", systemImage: "radio",
                             german: "Morgen wird es wohl regnen.",
                             english: "It will probably rain tomorrow.", marked: ["wird", "wohl"])
        ],
        "b2-modalverben": [
            RealLifeSentence(place: "Sign at the swimming pool", systemImage: "water.waves",
                             german: "Kinder dürfen nur mit Erwachsenen ins Becken.",
                             english: "Children may only go in the pool with an adult.", marked: ["dürfen"]),
            RealLifeSentence(place: "Message from a friend", systemImage: "message",
                             german: "Ich soll dich von Anna grüßen.",
                             english: "Anna says hello.", marked: ["soll"]),
            RealLifeSentence(place: "Letter from an office", systemImage: "envelope",
                             german: "Sie brauchen keine Unterlagen mitzubringen.",
                             english: "You don't need to bring any documents.", marked: ["brauchen", "mitzubringen"])
        ],
        "b2-modal-vermutung": [
            RealLifeSentence(place: "The neighbours' house", systemImage: "house",
                             german: "Sie müssen im Urlaub sein.",
                             english: "They must be on holiday.", marked: ["müssen"]),
            RealLifeSentence(place: "Lost and found", systemImage: "magnifyingglass",
                             german: "Das könnte Ihr Schlüssel sein.",
                             english: "This could be your key.", marked: ["könnte"]),
            RealLifeSentence(place: "A colleague at work", systemImage: "briefcase",
                             german: "Das kann nicht stimmen.",
                             english: "That can't be right.", marked: ["kann nicht"])
        ],
        "b2-lassen": [
            RealLifeSentence(place: "At the hairdresser's", systemImage: "scissors",
                             german: "Ich lasse mir nur die Spitzen schneiden.",
                             english: "I'm just having the ends cut.", marked: ["lasse", "schneiden"]),
            RealLifeSentence(place: "Message from a friend", systemImage: "message",
                             german: "Lass mich kurz nachdenken.",
                             english: "Let me think for a moment.", marked: ["Lass"]),
            RealLifeSentence(place: "At the garage", systemImage: "car",
                             german: "Sie können das Auto bis morgen hier lassen.",
                             english: "You can leave the car here until tomorrow.", marked: ["lassen"])
        ],
        "b2-trennbar": [
            RealLifeSentence(place: "Station announcement", systemImage: "tram",
                             german: "Bitte steigen Sie hier um.",
                             english: "Please change trains here.", marked: ["steigen", "um"]),
            RealLifeSentence(place: "Letter from an office", systemImage: "envelope",
                             german: "Bitte unterschreiben Sie auf Seite 2.",
                             english: "Please sign on page 2.", marked: ["unterschreiben"]),
            RealLifeSentence(place: "Moving house", systemImage: "shippingbox",
                             german: "Wir ziehen im Juni um.",
                             english: "We're moving in June.", marked: ["ziehen", "um"])
        ],
        "b2-genus": [
            RealLifeSentence(place: "News headline", systemImage: "newspaper",
                             german: "Die Regierung plant eine neue Lösung.",
                             english: "The government is planning a new solution.", marked: ["Die Regierung", "Lösung"]),
            RealLifeSentence(place: "Hotel website", systemImage: "bed.double",
                             german: "Das Zentrum erreichen Sie in fünf Minuten.",
                             english: "You can reach the centre in five minutes.", marked: ["Das Zentrum"]),
            RealLifeSentence(place: "Job advert", systemImage: "briefcase",
                             german: "Wir bieten Ihnen Sicherheit und Freiheit.",
                             english: "We offer you security and freedom.", marked: ["Sicherheit", "Freiheit"])
        ],
        "b2-artikel": [
            RealLifeSentence(place: "Small talk", systemImage: "bubble.left.and.bubble.right",
                             german: "Ich bin Lehrerin und komme aus Spanien.",
                             english: "I'm a teacher and I come from Spain.", marked: ["Lehrerin", "Spanien"]),
            RealLifeSentence(place: "At the market", systemImage: "cart",
                             german: "Ich nehme ein Kilo Äpfel.",
                             english: "I'll take a kilo of apples.", marked: ["Äpfel"]),
            RealLifeSentence(place: "In a furniture shop", systemImage: "sofa",
                             german: "Der Tisch ist aus Holz.",
                             english: "The table is made of wood.", marked: ["aus Holz"])
        ],
        "b2-genitiv": [
            RealLifeSentence(place: "Letter from an office", systemImage: "envelope",
                             german: "Bitte geben Sie den Namen des Vermieters an.",
                             english: "Please give your landlord's name.", marked: ["des Vermieters"]),
            RealLifeSentence(place: "News headline", systemImage: "newspaper",
                             german: "Das Ende des Streiks ist in Sicht.",
                             english: "The end of the strike is in sight.", marked: ["des Streiks"]),
            RealLifeSentence(place: "Message from a friend", systemImage: "message",
                             german: "Wir feiern Annas Geburtstag am Samstag.",
                             english: "We're celebrating Anna's birthday on Saturday.", marked: ["Annas"])
        ],
        "b2-n-deklination": [
            RealLifeSentence(place: "Call to customer service", systemImage: "phone",
                             german: "Wir rufen den Kunden morgen zurück.",
                             english: "We'll call the customer back tomorrow.", marked: ["den Kunden"]),
            RealLifeSentence(place: "Email from work", systemImage: "at",
                             german: "Ich habe mit Herrn Braun gesprochen.",
                             english: "I've spoken to Mr Braun.", marked: ["Herrn"]),
            RealLifeSentence(place: "A colleague at work", systemImage: "briefcase",
                             german: "Kennst du schon den neuen Kollegen?",
                             english: "Have you met the new colleague yet?", marked: ["Kollegen"])
        ],
        "b2-adjektivendungen": [
            RealLifeSentence(place: "At the bakery", systemImage: "storefront",
                             german: "Ein großes Brot und frische Brötchen, bitte.",
                             english: "A large loaf and fresh rolls, please.", marked: ["großes", "frische"]),
            RealLifeSentence(place: "Flat advert", systemImage: "house",
                             german: "Schöne Wohnung mit großem Balkon",
                             english: "Lovely flat with a big balcony", marked: ["Schöne", "großem"]),
            RealLifeSentence(place: "Weather on the radio", systemImage: "radio",
                             german: "Morgen gibt es den ganzen Tag starken Regen.",
                             english: "Tomorrow there'll be heavy rain all day.", marked: ["ganzen", "starken"])
        ],
        "b2-adjektiv-nomen": [
            RealLifeSentence(place: "Hospital visit", systemImage: "cross.case",
                             german: "Besuchszeiten für Angehörige: 14 bis 19 Uhr",
                             english: "Visiting hours for relatives: 2 to 7 pm", marked: ["Angehörige"]),
            RealLifeSentence(place: "Sign in a museum", systemImage: "building.columns",
                             german: "Erwachsene 10 Euro, Kinder frei",
                             english: "Adults 10 euros, children free", marked: ["Erwachsene"]),
            RealLifeSentence(place: "Message from a friend", systemImage: "message",
                             german: "Ich treffe heute ein paar Bekannte.",
                             english: "I'm meeting a few acquaintances today.", marked: ["Bekannte"])
        ],
        "b2-pronomen": [
            RealLifeSentence(place: "In the kitchen", systemImage: "fork.knife",
                             german: "Haben wir noch Eier? — Ja, es sind noch welche da.",
                             english: "Have we got any eggs? — Yes, there are still some.", marked: ["welche"]),
            RealLifeSentence(place: "Lost and found", systemImage: "magnifyingglass",
                             german: "Ist das Ihre Jacke? — Nein, meine ist blau.",
                             english: "Is this your jacket? — No, mine is blue.", marked: ["meine"]),
            RealLifeSentence(place: "At the café", systemImage: "cup.and.saucer",
                             german: "Ich brauche einen Löffel. — Hier liegt einer.",
                             english: "I need a spoon. — There's one here.", marked: ["einer"])
        ],
        "b2-indefinitpronomen": [
            RealLifeSentence(place: "Lost and found", systemImage: "magnifyingglass",
                             german: "Hat jemand eine blaue Mütze gesehen?",
                             english: "Has anyone seen a blue hat?", marked: ["jemand"]),
            RealLifeSentence(place: "Sign in a museum", systemImage: "building.columns",
                             german: "Hier darf man nicht essen.",
                             english: "You can't eat in here.", marked: ["man"]),
            RealLifeSentence(place: "Message from a friend", systemImage: "message",
                             german: "Wir kommen beide zur Party.",
                             english: "We're both coming to the party.", marked: ["beide"])
        ],
        "b2-komparation": [
            RealLifeSentence(place: "At the market", systemImage: "cart",
                             german: "Die Erdbeeren sind heute billiger als gestern.",
                             english: "The strawberries are cheaper today than yesterday.", marked: ["billiger als"]),
            RealLifeSentence(place: "News headline", systemImage: "newspaper",
                             german: "Die Mieten werden immer teurer.",
                             english: "Rents keep getting more expensive.", marked: ["immer teurer"]),
            RealLifeSentence(place: "Supermarket leaflet", systemImage: "cart",
                             german: "Unser bestes Angebot der Woche!",
                             english: "Our best offer of the week!", marked: ["bestes"])
        ],
        "b2-partizip": [
            RealLifeSentence(place: "Station announcement", systemImage: "tram",
                             german: "Der verspätete Zug fährt jetzt ein.",
                             english: "The delayed train is now arriving.", marked: ["verspätete"]),
            RealLifeSentence(place: "At the bakery", systemImage: "storefront",
                             german: "Frisch gebackenes Brot gibt es ab 7 Uhr.",
                             english: "There's freshly baked bread from 7 o'clock.", marked: ["gebackenes"]),
            RealLifeSentence(place: "Road sign", systemImage: "car",
                             german: "Achtung, spielende Kinder!",
                             english: "Caution, children playing!", marked: ["spielende"])
        ]
    ]
}
