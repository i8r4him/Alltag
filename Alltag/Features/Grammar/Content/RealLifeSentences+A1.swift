//
//  RealLifeSentences+A1.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The real-life sentences of the A1 rules: three short ones each. The
/// sentences of "The verb is always second" and the accusative are in
/// `RealLifeSentences.swift`.
extension RealLifeSentence {
    static let a1ByRule: [String: [RealLifeSentence]] = [
        "pronomen": a1Pronouns,
        "sein-haben": a1SeinHaben,
        "praesens": a1PresentTense,
        "ja-nein-frage": a1YesNoQuestions,
        "w-frage": a1WQuestions,
        "artikel": a1Articles,
        "plural": a1Plural,
        "negation": a1Negation,
        "vokalwechsel": a1VowelChange,
        "modalverben": a1ModalVerbs,
        "trennbar": a1SeparableVerbs,
        "imperativ": a1Imperative,
        "possessiv": a1Possessives,
        "dativ": a1Dative,
        "wo-dativ": a1WhereDative,
        "praepositionen": a1FixedPrepositions,
        "zeit": a1TimePrepositions,
        "welcher-dieser": a1WhichThis
    ]

    private static let a1Pronouns: [RealLifeSentence] = [
        RealLifeSentence(place: "Message from a friend", systemImage: "message",
                         german: "Wir sind schon da. Wo bist du?",
                         english: "We're already here. Where are you?", marked: ["Wir", "du"]),
        RealLifeSentence(place: "At the till", systemImage: "creditcard",
                         german: "Haben Sie eine Kundenkarte?",
                         english: "Do you have a loyalty card?", marked: ["Sie"]),
        RealLifeSentence(place: "A colleague at work", systemImage: "briefcase",
                         german: "Das ist Jonas. Er ist neu hier.",
                         english: "This is Jonas. He's new here.", marked: ["Er"])
    ]

    private static let a1SeinHaben: [RealLifeSentence] = [
        RealLifeSentence(place: "At the bakery", systemImage: "storefront",
                         german: "Ich möchte zwei Brötchen, bitte.",
                         english: "I'd like two rolls, please.", marked: ["möchte"]),
        RealLifeSentence(place: "At the till", systemImage: "creditcard",
                         german: "Haben Sie eine Tüte?",
                         english: "Do you have a bag?", marked: ["Haben"]),
        RealLifeSentence(place: "Sign on a shop door", systemImage: "door.left.hand.closed",
                         german: "Wir sind gleich zurück.",
                         english: "We'll be right back.", marked: ["sind"])
    ]

    private static let a1PresentTense: [RealLifeSentence] = [
        RealLifeSentence(place: "A colleague at work", systemImage: "briefcase",
                         german: "Ich mache jetzt Pause.",
                         english: "I'm taking a break now.", marked: ["mache"]),
        RealLifeSentence(place: "Station announcement", systemImage: "tram",
                         german: "Der Zug kommt in fünf Minuten.",
                         english: "The train arrives in five minutes.", marked: ["kommt"]),
        RealLifeSentence(place: "Message from a friend", systemImage: "message",
                         german: "Was machst du heute Abend?",
                         english: "What are you doing this evening?", marked: ["machst"])
    ]

    private static let a1YesNoQuestions: [RealLifeSentence] = [
        RealLifeSentence(place: "At the till", systemImage: "creditcard",
                         german: "Zahlen Sie mit Karte?",
                         english: "Are you paying by card?", marked: ["Zahlen"]),
        RealLifeSentence(place: "Message from a friend", systemImage: "message",
                         german: "Kommst du heute?",
                         english: "Are you coming today?", marked: ["Kommst"]),
        RealLifeSentence(place: "At the bakery", systemImage: "storefront",
                         german: "Ist das alles?",
                         english: "Is that everything?", marked: ["Ist"])
    ]

    private static let a1WQuestions: [RealLifeSentence] = [
        RealLifeSentence(place: "At the station", systemImage: "tram",
                         german: "Wo ist Gleis 3?",
                         english: "Where is platform 3?", marked: ["Wo"]),
        RealLifeSentence(place: "At the till", systemImage: "creditcard",
                         german: "Was kostet das?",
                         english: "How much is that?", marked: ["Was"]),
        RealLifeSentence(place: "A colleague at work", systemImage: "briefcase",
                         german: "Wann hast du Pause?",
                         english: "When is your break?", marked: ["Wann"])
    ]

    private static let a1Articles: [RealLifeSentence] = [
        RealLifeSentence(place: "At the bakery", systemImage: "storefront",
                         german: "Ein Brot und eine Brezel, bitte.",
                         english: "A loaf of bread and a pretzel, please.", marked: ["Ein", "eine"]),
        RealLifeSentence(place: "Station announcement", systemImage: "tram",
                         german: "Der Zug hat Verspätung.",
                         english: "The train is delayed.", marked: ["Der"]),
        RealLifeSentence(place: "Supermarket leaflet", systemImage: "cart",
                         german: "Die Butter kostet heute 1,49 Euro.",
                         english: "Butter is 1.49 euros today.", marked: ["Die"])
    ]

    private static let a1Plural: [RealLifeSentence] = [
        RealLifeSentence(place: "At the bakery", systemImage: "storefront",
                         german: "Vier Brötchen, bitte.",
                         english: "Four rolls, please.", marked: ["Brötchen"]),
        RealLifeSentence(place: "Supermarket leaflet", systemImage: "cart",
                         german: "Äpfel und Bananen im Angebot.",
                         english: "Apples and bananas on offer.", marked: ["Äpfel", "Bananen"]),
        RealLifeSentence(place: "On the train", systemImage: "tram",
                         german: "Die Türen schließen automatisch.",
                         english: "The doors close automatically.", marked: ["Die Türen"])
    ]

    private static let a1Negation: [RealLifeSentence] = [
        RealLifeSentence(place: "At the till", systemImage: "creditcard",
                         german: "Ich habe leider kein Kleingeld.",
                         english: "Sorry, I have no change.", marked: ["kein"]),
        RealLifeSentence(place: "Message from a friend", systemImage: "message",
                         german: "Ich komme heute nicht.",
                         english: "I'm not coming today.", marked: ["nicht"]),
        RealLifeSentence(place: "Sign on a shop door", systemImage: "door.left.hand.closed",
                         german: "Bitte nicht rauchen.",
                         english: "Please don't smoke.", marked: ["nicht"])
    ]

    private static let a1VowelChange: [RealLifeSentence] = [
        RealLifeSentence(place: "Station announcement", systemImage: "tram",
                         german: "Der Zug fährt heute von Gleis 2.",
                         english: "Today the train leaves from platform 2.", marked: ["fährt"]),
        RealLifeSentence(place: "A colleague at work", systemImage: "briefcase",
                         german: "Sprichst du Englisch?",
                         english: "Do you speak English?", marked: ["Sprichst"]),
        RealLifeSentence(place: "Message from a friend", systemImage: "message",
                         german: "Was isst du heute?",
                         english: "What are you eating today?", marked: ["isst"])
    ]

    private static let a1ModalVerbs: [RealLifeSentence] = [
        RealLifeSentence(place: "At the till", systemImage: "creditcard",
                         german: "Kann ich mit Karte zahlen?",
                         english: "Can I pay by card?", marked: ["Kann", "zahlen"]),
        RealLifeSentence(place: "At the pharmacy", systemImage: "cross.case",
                         german: "Sie müssen die Tabletten morgens nehmen.",
                         english: "You have to take the tablets in the morning.", marked: ["müssen", "nehmen"]),
        RealLifeSentence(place: "Sign on a shop door", systemImage: "door.left.hand.closed",
                         german: "Hier dürfen Sie nicht parken.",
                         english: "You may not park here.", marked: ["dürfen", "parken"])
    ]

    private static let a1SeparableVerbs: [RealLifeSentence] = [
        RealLifeSentence(place: "Message from a friend", systemImage: "message",
                         german: "Ich rufe dich später an.",
                         english: "I'll call you later.", marked: ["rufe", "an"]),
        RealLifeSentence(place: "Station announcement", systemImage: "tram",
                         german: "Der Zug kommt auf Gleis 4 an.",
                         english: "The train is arriving at platform 4.", marked: ["kommt", "an"]),
        RealLifeSentence(place: "A colleague at work", systemImage: "briefcase",
                         german: "Wann fängst du morgen an?",
                         english: "When do you start tomorrow?", marked: ["fängst", "an"])
    ]

    private static let a1Imperative: [RealLifeSentence] = [
        RealLifeSentence(place: "On the train", systemImage: "tram",
                         german: "Steigen Sie bitte hier aus.",
                         english: "Please get off here.", marked: ["Steigen Sie"]),
        RealLifeSentence(place: "At the pharmacy", systemImage: "cross.case",
                         german: "Nehmen Sie eine Tablette am Abend.",
                         english: "Take one tablet in the evening.", marked: ["Nehmen Sie"]),
        RealLifeSentence(place: "Message from a friend", systemImage: "message",
                         german: "Ruf mich bitte an!",
                         english: "Please call me!", marked: ["Ruf"])
    ]

    private static let a1Possessives: [RealLifeSentence] = [
        RealLifeSentence(place: "At the till", systemImage: "creditcard",
                         german: "Hier ist Ihre Karte.",
                         english: "Here is your card.", marked: ["Ihre"]),
        RealLifeSentence(place: "Message from a friend", systemImage: "message",
                         german: "Wie ist deine Adresse?",
                         english: "What's your address?", marked: ["deine"]),
        RealLifeSentence(place: "A colleague at work", systemImage: "briefcase",
                         german: "Das ist mein Platz.",
                         english: "That's my seat.", marked: ["mein"])
    ]

    private static let a1Dative: [RealLifeSentence] = [
        RealLifeSentence(place: "At the station", systemImage: "tram",
                         german: "Ich helfe der Frau mit dem Koffer.",
                         english: "I'm helping the woman with her suitcase.", marked: ["der", "dem"]),
        RealLifeSentence(place: "Message from a friend", systemImage: "message",
                         german: "Die Tasche gehört der Lehrerin.",
                         english: "The bag belongs to the teacher.", marked: ["der"]),
        RealLifeSentence(place: "A colleague at work", systemImage: "briefcase",
                         german: "Ich bringe dem Chef einen Kaffee.",
                         english: "I'm bringing the boss a coffee.", marked: ["dem"])
    ]

    private static let a1WhereDative: [RealLifeSentence] = [
        RealLifeSentence(place: "Message from a friend", systemImage: "message",
                         german: "Ich bin noch im Büro.",
                         english: "I'm still at the office.", marked: ["im"]),
        RealLifeSentence(place: "A colleague at work", systemImage: "briefcase",
                         german: "Die Papiere liegen auf dem Tisch.",
                         english: "The papers are on the table.", marked: ["auf dem"]),
        RealLifeSentence(place: "At the station", systemImage: "tram",
                         german: "Der Kiosk ist neben dem Eingang.",
                         english: "The kiosk is next to the entrance.", marked: ["neben dem"])
    ]

    private static let a1FixedPrepositions: [RealLifeSentence] = [
        RealLifeSentence(place: "Message from a friend", systemImage: "message",
                         german: "Ich komme mit dem Fahrrad.",
                         english: "I'm coming by bike.", marked: ["mit dem"]),
        RealLifeSentence(place: "At the bakery", systemImage: "storefront",
                         german: "Das ist für meine Kollegin.",
                         english: "That's for my colleague.", marked: ["für meine"]),
        RealLifeSentence(place: "A colleague at work", systemImage: "briefcase",
                         german: "Nach der Arbeit gehe ich zum Arzt.",
                         english: "After work I'm going to the doctor.", marked: ["Nach der", "zum"])
    ]

    private static let a1TimePrepositions: [RealLifeSentence] = [
        RealLifeSentence(place: "Sign on a shop door", systemImage: "door.left.hand.closed",
                         german: "Am Sonntag geschlossen.",
                         english: "Closed on Sundays.", marked: ["Am"]),
        RealLifeSentence(place: "Message from a friend", systemImage: "message",
                         german: "Wir treffen uns um acht.",
                         english: "We're meeting at eight.", marked: ["um"]),
        RealLifeSentence(place: "Supermarket leaflet", systemImage: "cart",
                         german: "Im Dezember bis 22 Uhr geöffnet.",
                         english: "Open until 10 pm in December.", marked: ["Im"])
    ]

    private static let a1WhichThis: [RealLifeSentence] = [
        RealLifeSentence(place: "At the station", systemImage: "tram",
                         german: "Welcher Zug fährt nach Bonn?",
                         english: "Which train goes to Bonn?", marked: ["Welcher"]),
        RealLifeSentence(place: "At the bakery", systemImage: "storefront",
                         german: "Welches Brot möchten Sie?",
                         english: "Which bread would you like?", marked: ["Welches"]),
        RealLifeSentence(place: "At the till", systemImage: "creditcard",
                         german: "Diese Kasse ist geschlossen.",
                         english: "This till is closed.", marked: ["Diese"])
    ]
}
