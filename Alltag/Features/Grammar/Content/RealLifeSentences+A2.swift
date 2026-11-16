//
//  RealLifeSentences+A2.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The real-life sentences of the A2 rules: three short ones each.
extension RealLifeSentence {
    static let a2ByRule: [String: [RealLifeSentence]] = [
        "a2-perfekt-haben": a2PerfectHaben,
        "a2-partizip": a2Participle,
        "a2-perfekt-sein": a2PerfectSein,
        "a2-praeteritum": a2SimplePast,
        "a2-pronomen": a2Pronouns,
        "a2-dativ-verben": a2DativeVerbs,
        "a2-zwei-objekte": a2TwoObjects,
        "a2-reflexiv": a2Reflexive,
        "a2-und-aber": a2AndBut,
        "a2-deshalb": a2Therefore,
        "a2-nebensatz": a2VerbAtEnd,
        "a2-wo-wohin": a2WhereWhereTo,
        "a2-zum-beim": a2ToAtFrom,
        "a2-hin-her": a2HereThere,
        "a2-adjektiv-der": a2AdjectiveDer,
        "a2-adjektiv-ein": a2AdjectiveEin,
        "a2-komparativ": a2Comparative,
        "a2-partikeln": a2Particles,
        "a2-komposita": a2Compounds,
        "a2-endungen": a2Endings
    ]

    private static let a2PerfectHaben: [RealLifeSentence] = [
        RealLifeSentence(place: "Message from a friend", systemImage: "message",
                         german: "Hast du schon gegessen?",
                         english: "Have you eaten yet?", marked: ["Hast", "gegessen"]),
        RealLifeSentence(place: "At the pharmacy", systemImage: "cross.case",
                         german: "Haben Sie das Rezept mitgebracht?",
                         english: "Have you brought the prescription?", marked: ["Haben", "mitgebracht"]),
        RealLifeSentence(place: "Email from work", systemImage: "at",
                         german: "Ich habe Ihnen die Unterlagen geschickt.",
                         english: "I've sent you the documents.", marked: ["habe", "geschickt"])
    ]

    private static let a2Participle: [RealLifeSentence] = [
        RealLifeSentence(place: "Parcel notification", systemImage: "shippingbox",
                         german: "Wir haben Ihre Bestellung erhalten.",
                         english: "We've received your order.", marked: ["erhalten"]),
        RealLifeSentence(place: "At the till", systemImage: "creditcard",
                         german: "Haben Sie schon bezahlt?",
                         english: "Have you already paid?", marked: ["bezahlt"]),
        RealLifeSentence(place: "Message from a friend", systemImage: "message",
                         german: "Ich habe schon eingekauft.",
                         english: "I've already done the shopping.", marked: ["eingekauft"])
    ]

    private static let a2PerfectSein: [RealLifeSentence] = [
        RealLifeSentence(place: "Parcel notification", systemImage: "shippingbox",
                         german: "Ihr Paket ist heute angekommen.",
                         english: "Your parcel arrived today.", marked: ["ist", "angekommen"]),
        RealLifeSentence(place: "Monday at work", systemImage: "briefcase",
                         german: "Wir sind am Samstag ins Kino gegangen.",
                         english: "We went to the cinema on Saturday.", marked: ["sind", "gegangen"]),
        RealLifeSentence(place: "Message from a friend", systemImage: "message",
                         german: "Bist du gut nach Hause gekommen?",
                         english: "Did you get home all right?", marked: ["Bist", "gekommen"])
    ]

    private static let a2SimplePast: [RealLifeSentence] = [
        RealLifeSentence(place: "A colleague at work", systemImage: "briefcase",
                         german: "Wie war dein Wochenende?",
                         english: "How was your weekend?", marked: ["war"]),
        RealLifeSentence(place: "At the doctor's", systemImage: "stethoscope",
                         german: "Hatten Sie Fieber?",
                         english: "Did you have a temperature?", marked: ["Hatten"]),
        RealLifeSentence(place: "Email from work", systemImage: "at",
                         german: "Leider konnte ich gestern nicht kommen.",
                         english: "Unfortunately I couldn't come yesterday.", marked: ["konnte"])
    ]

    private static let a2Pronouns: [RealLifeSentence] = [
        RealLifeSentence(place: "At the till", systemImage: "creditcard",
                         german: "Kann ich Ihnen helfen?",
                         english: "Can I help you?", marked: ["Ihnen"]),
        RealLifeSentence(place: "Message from a friend", systemImage: "message",
                         german: "Ich rufe dich später an.",
                         english: "I'll call you later.", marked: ["dich"]),
        RealLifeSentence(place: "Meeting a neighbour", systemImage: "house",
                         german: "Ich habe ihn lange nicht gesehen.",
                         english: "I haven't seen him for a long time.", marked: ["ihn"])
    ]

    private static let a2DativeVerbs: [RealLifeSentence] = [
        RealLifeSentence(place: "At the restaurant", systemImage: "fork.knife",
                         german: "Hat es Ihnen geschmeckt?",
                         english: "Did you enjoy your meal?", marked: ["Ihnen", "geschmeckt"]),
        RealLifeSentence(place: "Message from a friend", systemImage: "message",
                         german: "Passt dir Freitag um sieben?",
                         english: "Does Friday at seven suit you?", marked: ["Passt", "dir"]),
        RealLifeSentence(place: "At the till", systemImage: "creditcard",
                         german: "Gehört die Tüte Ihnen?",
                         english: "Is this bag yours?", marked: ["Gehört", "Ihnen"])
    ]

    private static let a2TwoObjects: [RealLifeSentence] = [
        RealLifeSentence(place: "Letter from an office", systemImage: "envelope",
                         german: "Wir schicken Ihnen die Unterlagen per Post.",
                         english: "We'll send you the documents by post.", marked: ["Ihnen", "die Unterlagen"]),
        RealLifeSentence(place: "At the bakery", systemImage: "storefront",
                         german: "Können Sie mir das einpacken?",
                         english: "Could you wrap that for me?", marked: ["mir", "das"]),
        RealLifeSentence(place: "Message from a friend", systemImage: "message",
                         german: "Ich gebe es dir morgen zurück.",
                         english: "I'll give it back to you tomorrow.", marked: ["es", "dir"])
    ]

    private static let a2Reflexive: [RealLifeSentence] = [
        RealLifeSentence(place: "Letter from an office", systemImage: "envelope",
                         german: "Bitte melden Sie sich bis Freitag.",
                         english: "Please get in touch by Friday.", marked: ["sich"]),
        RealLifeSentence(place: "Message from a friend", systemImage: "message",
                         german: "Ich freue mich auf Samstag!",
                         english: "I'm looking forward to Saturday!", marked: ["mich"]),
        RealLifeSentence(place: "On the train", systemImage: "tram",
                         german: "Bitte halten Sie sich fest.",
                         english: "Please hold on tight.", marked: ["sich"])
    ]

    private static let a2AndBut: [RealLifeSentence] = [
        RealLifeSentence(place: "Sign on a shop door", systemImage: "door.left.hand.closed",
                         german: "Wir haben geöffnet, aber nur bis 14 Uhr.",
                         english: "We're open, but only until 2 pm.", marked: ["aber"]),
        RealLifeSentence(place: "Message from a friend", systemImage: "message",
                         german: "Ich komme später, denn ich muss noch arbeiten.",
                         english: "I'll be late, because I still have to work.", marked: ["denn", "ich", "muss"]),
        RealLifeSentence(place: "At the bakery", systemImage: "storefront",
                         german: "Zum Hieressen oder zum Mitnehmen?",
                         english: "To eat in or to take away?", marked: ["oder"])
    ]

    private static let a2Therefore: [RealLifeSentence] = [
        RealLifeSentence(place: "Station announcement", systemImage: "tram",
                         german: "Die Strecke ist gesperrt, deshalb fährt der Zug über Kassel.",
                         english: "The line is closed, so the train is going via Kassel.", marked: ["deshalb", "fährt"]),
        RealLifeSentence(place: "Weather on the radio", systemImage: "radio",
                         german: "Es wird kalt, trotzdem bleibt es trocken.",
                         english: "It's getting cold, but it will stay dry.", marked: ["trotzdem", "bleibt"]),
        RealLifeSentence(place: "At the doctor's", systemImage: "stethoscope",
                         german: "Nehmen Sie die Tabletten, dann geht es Ihnen bald besser.",
                         english: "Take the tablets, then you'll soon feel better.", marked: ["dann", "geht"])
    ]

    private static let a2VerbAtEnd: [RealLifeSentence] = [
        RealLifeSentence(place: "Sign on a shop door", systemImage: "door.left.hand.closed",
                         german: "Wir haben heute zu, weil wir umziehen.",
                         english: "We're closed today because we're moving.", marked: ["weil", "umziehen"]),
        RealLifeSentence(place: "Message from a friend", systemImage: "message",
                         german: "Sag Bescheid, wenn du da bist.",
                         english: "Let me know when you're there.", marked: ["wenn", "bist"]),
        RealLifeSentence(place: "Email from work", systemImage: "at",
                         german: "Ich glaube, dass das Meeting um zehn beginnt.",
                         english: "I think the meeting starts at ten.", marked: ["dass", "beginnt"])
    ]

    private static let a2WhereWhereTo: [RealLifeSentence] = [
        RealLifeSentence(place: "Notice in your building", systemImage: "building.2",
                         german: "Bitte stellen Sie keine Fahrräder in den Flur.",
                         english: "Please don't put bikes in the hallway.", marked: ["in den"]),
        RealLifeSentence(place: "Message from a friend", systemImage: "message",
                         german: "Ich sitze schon im Café.",
                         english: "I'm already sitting in the café.", marked: ["im"]),
        RealLifeSentence(place: "At the doctor's", systemImage: "stethoscope",
                         german: "Legen Sie sich bitte auf die Liege.",
                         english: "Please lie down on the couch.", marked: ["auf die"])
    ]

    private static let a2ToAtFrom: [RealLifeSentence] = [
        RealLifeSentence(place: "Message from a friend", systemImage: "message",
                         german: "Ich bin noch beim Friseur.",
                         english: "I'm still at the hairdresser's.", marked: ["beim"]),
        RealLifeSentence(place: "A colleague at work", systemImage: "briefcase",
                         german: "Ich muss morgen zum Arzt.",
                         english: "I have to go to the doctor's tomorrow.", marked: ["zum"]),
        RealLifeSentence(place: "Station announcement", systemImage: "tram",
                         german: "Dieser Zug fährt nach Hamburg.",
                         english: "This train goes to Hamburg.", marked: ["nach"])
    ]

    private static let a2HereThere: [RealLifeSentence] = [
        RealLifeSentence(place: "At the station", systemImage: "tram",
                         german: "Der Ausgang ist dort drüben.",
                         english: "The exit is over there.", marked: ["dort"]),
        RealLifeSentence(place: "Message from a friend", systemImage: "message",
                         german: "Wo bist du? Ich komme hin.",
                         english: "Where are you? I'll come over.", marked: ["hin"]),
        RealLifeSentence(place: "Sign on a shop door", systemImage: "door.left.hand.closed",
                         german: "Bin gleich zurück.",
                         english: "Back in a moment.", marked: ["zurück"])
    ]

    private static let a2AdjectiveDer: [RealLifeSentence] = [
        RealLifeSentence(place: "On the train", systemImage: "tram",
                         german: "Der nächste Halt ist Hauptbahnhof.",
                         english: "The next stop is the central station.", marked: ["nächste"]),
        RealLifeSentence(place: "At the till", systemImage: "creditcard",
                         german: "Nehmen Sie die kleine Tüte?",
                         english: "Are you taking the small bag?", marked: ["kleine"]),
        RealLifeSentence(place: "Supermarket leaflet", systemImage: "cart",
                         german: "Den frischen Fisch gibt es nur heute.",
                         english: "The fresh fish is only on offer today.", marked: ["frischen"])
    ]

    private static let a2AdjectiveEin: [RealLifeSentence] = [
        RealLifeSentence(place: "At the bakery", systemImage: "storefront",
                         german: "Ich hätte gern ein großes Brot.",
                         english: "I'd like a large loaf, please.", marked: ["großes"]),
        RealLifeSentence(place: "Meeting a neighbour", systemImage: "house",
                         german: "Wir haben einen kleinen Hund.",
                         english: "We've got a small dog.", marked: ["kleinen"]),
        RealLifeSentence(place: "Email from work", systemImage: "at",
                         german: "Ich wünsche Ihnen ein schönes Wochenende.",
                         english: "Have a nice weekend.", marked: ["schönes"])
    ]

    private static let a2Comparative: [RealLifeSentence] = [
        RealLifeSentence(place: "Railway app", systemImage: "iphone",
                         german: "Die schnellste Verbindung dauert drei Stunden.",
                         english: "The fastest connection takes three hours.", marked: ["schnellste"]),
        RealLifeSentence(place: "Supermarket leaflet", systemImage: "cart",
                         german: "Jetzt noch günstiger!",
                         english: "Now even cheaper!", marked: ["günstiger"]),
        RealLifeSentence(place: "Weather on the radio", systemImage: "radio",
                         german: "Morgen wird es wärmer als heute.",
                         english: "Tomorrow will be warmer than today.", marked: ["wärmer", "als"])
    ]

    private static let a2Particles: [RealLifeSentence] = [
        RealLifeSentence(place: "Message from a friend", systemImage: "message",
                         german: "Wo bist du denn?",
                         english: "So where are you?", marked: ["denn"]),
        RealLifeSentence(place: "At the till", systemImage: "creditcard",
                         german: "Zeigen Sie bitte mal Ihren Ausweis.",
                         english: "Could you show me your ID, please?", marked: ["mal"]),
        RealLifeSentence(place: "Meeting a neighbour", systemImage: "house",
                         german: "Kommen Sie doch mal vorbei!",
                         english: "Do drop by some time!", marked: ["doch", "mal"])
    ]

    private static let a2Compounds: [RealLifeSentence] = [
        RealLifeSentence(place: "At the station", systemImage: "tram",
                         german: "Der Fahrkartenautomat nimmt nur Karten.",
                         english: "The ticket machine only takes cards.", marked: ["Fahrkartenautomat"]),
        RealLifeSentence(place: "Notice in your building", systemImage: "building.2",
                         german: "Bitte die Haustür immer schließen.",
                         english: "Please always close the front door.", marked: ["Haustür"]),
        RealLifeSentence(place: "Railway app", systemImage: "iphone",
                         german: "Ihre Sitzplatzreservierung ist gespeichert.",
                         english: "Your seat reservation has been saved.", marked: ["Sitzplatzreservierung"])
    ]

    private static let a2Endings: [RealLifeSentence] = [
        RealLifeSentence(place: "Letter from an office", systemImage: "envelope",
                         german: "Bitte bringen Sie die Rechnung mit.",
                         english: "Please bring the invoice with you.", marked: ["Rechnung"]),
        RealLifeSentence(place: "At the bakery", systemImage: "storefront",
                         german: "Noch zwei Brötchen, bitte.",
                         english: "Two more rolls, please.", marked: ["Brötchen"]),
        RealLifeSentence(place: "Station announcement", systemImage: "tram",
                         german: "Eine Information für alle Fahrgäste nach Köln.",
                         english: "Some information for all passengers travelling to Cologne.", marked: ["Information"])
    ]
}
