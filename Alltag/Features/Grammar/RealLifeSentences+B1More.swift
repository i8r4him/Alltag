//
//  RealLifeSentences+B1More.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The real-life sentences of the B1 rules, second half: from lassen on.
/// `RealLifeSentences+B1.swift` lists them by rule.
extension RealLifeSentence {
    static let b1Lassen: [RealLifeSentence] = [
        RealLifeSentence(place: "At the hairdresser's", systemImage: "scissors",
                         german: "Möchten Sie sich die Haare waschen lassen?",
                         english: "Would you like your hair washed?", marked: ["waschen lassen"]),
        RealLifeSentence(place: "Message from a friend", systemImage: "message",
                         german: "Lass mich das machen!",
                         english: "Let me do that!", marked: ["Lass", "machen"]),
        RealLifeSentence(place: "Letter from an office", systemImage: "envelope",
                         german: "Bitte lassen Sie die Kopie beglaubigen.",
                         english: "Please have the copy certified.", marked: ["lassen", "beglaubigen"])
    ]

    static let b1Future: [RealLifeSentence] = [
        RealLifeSentence(place: "Weather on the radio", systemImage: "radio",
                         german: "Morgen wird die Sonne scheinen.",
                         english: "Tomorrow the sun will shine.", marked: ["wird", "scheinen"]),
        RealLifeSentence(place: "Message from a friend", systemImage: "message",
                         german: "Keine Sorge, ich werde pünktlich sein.",
                         english: "Don't worry, I'll be on time.", marked: ["werde", "sein"]),
        RealLifeSentence(place: "Station announcement", systemImage: "tram",
                         german: "Der Zug wird in wenigen Minuten eintreffen.",
                         english: "The train will arrive in a few minutes.", marked: ["wird", "eintreffen"])
    ]

    static let b1Passive: [RealLifeSentence] = [
        RealLifeSentence(place: "Notice in your building", systemImage: "building.2",
                         german: "Am Montag wird die Treppe geputzt.",
                         english: "The stairs will be cleaned on Monday.", marked: ["wird", "geputzt"]),
        RealLifeSentence(place: "Letter from an office", systemImage: "envelope",
                         german: "Ihr Ausweis wurde am 3. Mai ausgestellt.",
                         english: "Your ID card was issued on 3 May.", marked: ["wurde", "ausgestellt"]),
        RealLifeSentence(place: "Sign at the bakery", systemImage: "storefront",
                         german: "Hier wird jeden Tag frisch gebacken.",
                         english: "We bake fresh here every day.", marked: ["wird", "gebacken"])
    ]

    static let b1Subjunctive: [RealLifeSentence] = [
        RealLifeSentence(place: "At the bakery", systemImage: "storefront",
                         german: "Ich hätte gern zwei Brötchen.",
                         english: "I'd like two rolls.", marked: ["hätte"]),
        RealLifeSentence(place: "At the till", systemImage: "creditcard",
                         german: "Könnten Sie mir eine Tüte geben?",
                         english: "Could you give me a bag?", marked: ["Könnten"]),
        RealLifeSentence(place: "Message from a friend", systemImage: "message",
                         german: "Wenn ich Zeit hätte, würde ich mitkommen.",
                         english: "If I had time, I'd come along.", marked: ["hätte", "würde"])
    ]

    static let b1UsesOfWerden: [RealLifeSentence] = [
        RealLifeSentence(place: "Weather on the radio", systemImage: "radio",
                         german: "Heute wird es schon früh dunkel.",
                         english: "It's getting dark early today.", marked: ["wird"]),
        RealLifeSentence(place: "A colleague at work", systemImage: "briefcase",
                         german: "Sie wird nächstes Jahr Abteilungsleiterin.",
                         english: "She's becoming head of department next year.", marked: ["wird"]),
        RealLifeSentence(place: "Notice in your building", systemImage: "building.2",
                         german: "Die Heizung wird morgen repariert.",
                         english: "The heating will be repaired tomorrow.", marked: ["wird", "repariert"])
    ]

    static let b1Genitive: [RealLifeSentence] = [
        RealLifeSentence(place: "Letter from an office", systemImage: "envelope",
                         german: "Bitte senden Sie uns eine Kopie des Mietvertrags.",
                         english: "Please send us a copy of the tenancy agreement.", marked: ["des Mietvertrags"]),
        RealLifeSentence(place: "News on the radio", systemImage: "radio",
                         german: "Die Zahl der Arbeitslosen ist gesunken.",
                         english: "The number of people out of work has fallen.", marked: ["der Arbeitslosen"]),
        RealLifeSentence(place: "At the station", systemImage: "tram",
                         german: "Der Ausgang ist am Ende des Bahnsteigs.",
                         english: "The exit is at the end of the platform.", marked: ["des Bahnsteigs"])
    ]

    static let b1GenitivePrepositions: [RealLifeSentence] = [
        RealLifeSentence(place: "Station announcement", systemImage: "tram",
                         german: "Wegen einer Störung fällt der Zug aus.",
                         english: "Due to a fault, the train is cancelled.", marked: ["Wegen einer Störung"]),
        RealLifeSentence(place: "Letter from an office", systemImage: "envelope",
                         german: "Bitte zahlen Sie innerhalb einer Woche.",
                         english: "Please pay within a week.", marked: ["innerhalb einer Woche"]),
        RealLifeSentence(place: "Sign at the pharmacy", systemImage: "cross.case",
                         german: "Außerhalb der Öffnungszeiten hilft die Notdienstapotheke.",
                         english: "Outside opening hours, the emergency pharmacy can help.",
                         marked: ["Außerhalb der Öffnungszeiten"])
    ]

    static let b1TimePrepositions: [RealLifeSentence] = [
        RealLifeSentence(place: "At the doctor's", systemImage: "stethoscope",
                         german: "Ich habe seit drei Tagen Kopfschmerzen.",
                         english: "I've had a headache for three days.", marked: ["seit drei Tagen"]),
        RealLifeSentence(place: "Sign on a shop door", systemImage: "storefront",
                         german: "Ab Dezember haben wir auch sonntags geöffnet.",
                         english: "From December we're open on Sundays too.", marked: ["Ab Dezember"]),
        RealLifeSentence(place: "Message from a friend", systemImage: "message",
                         german: "Ich bin vor einer Stunde angekommen.",
                         english: "I arrived an hour ago.", marked: ["vor einer Stunde"])
    ]

    static let b1NDeclension: [RealLifeSentence] = [
        RealLifeSentence(place: "Email from work", systemImage: "at",
                         german: "Bitte leiten Sie die E-Mail an Herrn Wagner weiter.",
                         english: "Please forward the email to Mr Wagner.", marked: ["Herrn"]),
        RealLifeSentence(place: "At the language school", systemImage: "graduationcap",
                         german: "Die Lehrerin hilft jedem Studenten.",
                         english: "The teacher helps every student.", marked: ["Studenten"]),
        RealLifeSentence(place: "A colleague at work", systemImage: "briefcase",
                         german: "Kennst du schon unseren neuen Kollegen?",
                         english: "Have you met our new colleague yet?", marked: ["Kollegen"])
    ]

    static let b1AdjectiveNoArticle: [RealLifeSentence] = [
        RealLifeSentence(place: "Board outside a café", systemImage: "cup.and.saucer",
                         german: "Heute: frische Waffeln mit heißen Kirschen.",
                         english: "Today: fresh waffles with hot cherries.", marked: ["frische", "heißen"]),
        RealLifeSentence(place: "Job advert", systemImage: "briefcase",
                         german: "Wir bieten flexible Arbeitszeiten und gutes Gehalt.",
                         english: "We offer flexible hours and a good salary.", marked: ["flexible", "gutes"]),
        RealLifeSentence(place: "Flat advert", systemImage: "house",
                         german: "Schöne Wohnung mit großem Balkon zu vermieten.",
                         english: "Lovely flat with a large balcony to let.", marked: ["Schöne", "großem"])
    ]

    static let b1AdjectiveNouns: [RealLifeSentence] = [
        RealLifeSentence(place: "Birthday card", systemImage: "gift",
                         german: "Alles Gute zum Geburtstag!",
                         english: "Happy birthday!", marked: ["Gute"]),
        RealLifeSentence(place: "At the swimming pool", systemImage: "figure.pool.swim",
                         german: "Für Jugendliche unter 16 ist der Eintritt frei.",
                         english: "Entry is free for young people under 16.", marked: ["Jugendliche"]),
        RealLifeSentence(place: "Message from a friend", systemImage: "message",
                         german: "Gibt es etwas Neues?",
                         english: "Any news?", marked: ["Neues"])
    ]

    static let b1Superlative: [RealLifeSentence] = [
        RealLifeSentence(place: "Supermarket leaflet", systemImage: "cart",
                         german: "Bei uns sind die Preise am niedrigsten.",
                         english: "Our prices are the lowest.", marked: ["am niedrigsten"]),
        RealLifeSentence(place: "Railway app", systemImage: "iphone",
                         german: "Die schnellste Verbindung dauert zwei Stunden.",
                         english: "The fastest connection takes two hours.", marked: ["schnellste"]),
        RealLifeSentence(place: "Meeting a neighbour", systemImage: "house",
                         german: "Am liebsten sitze ich auf dem Balkon.",
                         english: "Best of all, I like sitting on the balcony.", marked: ["Am liebsten"])
    ]

    static let b1PresentParticiple: [RealLifeSentence] = [
        RealLifeSentence(place: "Station announcement", systemImage: "tram",
                         german: "Bitte nicht mehr in den abfahrenden Zug einsteigen.",
                         english: "Please don't board the departing train.", marked: ["abfahrenden"]),
        RealLifeSentence(place: "Letter from your landlord", systemImage: "envelope",
                         german: "Die laufenden Kosten zahlen Sie jeden Monat.",
                         english: "You pay the running costs every month.", marked: ["laufenden"]),
        RealLifeSentence(place: "Weather on the radio", systemImage: "radio",
                         german: "In der kommenden Woche wird es wärmer.",
                         english: "It will get warmer in the coming week.", marked: ["kommenden"])
    ]

    static let b1TwoPartConnectors: [RealLifeSentence] = [
        RealLifeSentence(place: "At the till", systemImage: "creditcard",
                         german: "Sie können entweder bar oder mit Karte zahlen.",
                         english: "You can pay either in cash or by card.", marked: ["entweder", "oder"]),
        RealLifeSentence(place: "Flat advert", systemImage: "house",
                         german: "Die Wohnung hat weder einen Balkon noch einen Keller.",
                         english: "The flat has neither a balcony nor a cellar.", marked: ["weder", "noch"]),
        RealLifeSentence(place: "Job advert", systemImage: "briefcase",
                         german: "Sie sprechen sowohl Deutsch als auch Englisch.",
                         english: "You speak both German and English.", marked: ["sowohl", "als auch"])
    ]

    static let b1JeDesto: [RealLifeSentence] = [
        RealLifeSentence(place: "At the language school", systemImage: "graduationcap",
                         german: "Je früher Sie sich anmelden, desto günstiger ist der Kurs.",
                         english: "The earlier you sign up, the cheaper the course.", marked: ["Je", "desto"]),
        RealLifeSentence(place: "Message from a friend", systemImage: "message",
                         german: "Je länger ich hier wohne, desto besser gefällt es mir.",
                         english: "The longer I live here, the more I like it.", marked: ["Je", "desto"]),
        RealLifeSentence(place: "Supermarket leaflet", systemImage: "cart",
                         german: "Je mehr Sie kaufen, desto mehr sparen Sie.",
                         english: "The more you buy, the more you save.", marked: ["Je", "desto"])
    ]
}
