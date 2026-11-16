//
//  RealLifeSentences+B2.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The real-life sentences of the B2 rules: three short ones each, in the
/// order of `MockRules.b2`. The rest are in `RealLifeSentences+B2Part2.swift`
/// and `RealLifeSentences+B2Part3.swift`.
extension RealLifeSentence {
    static let b2ByRule: [String: [RealLifeSentence]] = b2Part1
        .merging(b2Part2) { first, _ in first }
        .merging(b2Part3) { first, _ in first }

    private static let b2Part1: [String: [RealLifeSentence]] = [
        "b2-verbstellung": [
            RealLifeSentence(place: "Sign on a shop door", systemImage: "storefront",
                             german: "Wir haben Urlaub, deshalb bleibt der Laden zu.",
                             english: "We're on holiday, so the shop is closed.", marked: ["deshalb", "bleibt"]),
            RealLifeSentence(place: "Message from a friend", systemImage: "message",
                             german: "Kommst du heute Abend mit?",
                             english: "Are you coming along tonight?", marked: ["Kommst"]),
            RealLifeSentence(place: "Email from work", systemImage: "at",
                             german: "Ich melde mich, sobald ich mehr weiß.",
                             english: "I'll get in touch as soon as I know more.", marked: ["melde", "weiß"])
        ],
        "b2-dativ-akkusativ": [
            RealLifeSentence(place: "At the till", systemImage: "creditcard",
                             german: "Soll ich Ihnen den Bon geben?",
                             english: "Shall I give you the receipt?", marked: ["Ihnen", "den Bon"]),
            RealLifeSentence(place: "Message from a friend", systemImage: "message",
                             german: "Ich schicke es dir heute Abend.",
                             english: "I'll send it to you tonight.", marked: ["es", "dir"]),
            RealLifeSentence(place: "At the town hall", systemImage: "building.columns",
                             german: "Zeigen Sie mir bitte Ihren Ausweis.",
                             english: "Please show me your ID.", marked: ["mir", "Ihren Ausweis"])
        ],
        "b2-tekamolo": [
            RealLifeSentence(place: "Station announcement", systemImage: "tram",
                             german: "Der ICE fährt heute wegen einer Störung ohne Halt nach Köln.",
                             english: "Today the ICE is going straight to Cologne because of a fault.",
                             marked: ["heute", "wegen einer Störung", "ohne Halt", "nach Köln"]),
            RealLifeSentence(place: "Message from a friend", systemImage: "message",
                             german: "Ich komme morgen mit dem Rad zu dir.",
                             english: "I'll come to yours by bike tomorrow.", marked: ["morgen", "mit dem Rad", "zu dir"]),
            RealLifeSentence(place: "A colleague at work", systemImage: "briefcase",
                             german: "Wir essen um zwölf zusammen in der Kantine.",
                             english: "We're having lunch together in the canteen at twelve.",
                             marked: ["um zwölf", "zusammen", "in der Kantine"])
        ],
        "b2-verbnah": [
            RealLifeSentence(place: "Message from a friend", systemImage: "message",
                             german: "Ich fahre am Wochenende mit Tom nach Leipzig.",
                             english: "I'm going to Leipzig with Tom at the weekend.", marked: ["nach Leipzig"]),
            RealLifeSentence(place: "At the doctor's", systemImage: "stethoscope",
                             german: "Sie müssen eine Woche im Bett bleiben.",
                             english: "You need to stay in bed for a week.", marked: ["im Bett bleiben"]),
            RealLifeSentence(place: "Small talk", systemImage: "bubble.left.and.bubble.right",
                             german: "Ich lerne seit einem Jahr Deutsch.",
                             english: "I've been learning German for a year.", marked: ["Deutsch"])
        ],
        "b2-nicht": [
            RealLifeSentence(place: "Ticket machine", systemImage: "ticket",
                             german: "Der Automat funktioniert leider nicht.",
                             english: "Sadly the machine isn't working.", marked: ["nicht"]),
            RealLifeSentence(place: "Message from a friend", systemImage: "message",
                             german: "Ich kann heute nicht kommen.",
                             english: "I can't come today.", marked: ["nicht", "kommen"]),
            RealLifeSentence(place: "Station announcement", systemImage: "tram",
                             german: "Der Zug hält heute nicht in Fulda.",
                             english: "Today the train isn't stopping at Fulda.", marked: ["nicht", "in Fulda"])
        ],
        "b2-konjunktiv2": [
            RealLifeSentence(place: "At the station", systemImage: "tram",
                             german: "Wüssten Sie, wo Gleis 7 ist?",
                             english: "Would you know where platform 7 is?", marked: ["Wüssten"]),
            RealLifeSentence(place: "Message from a friend", systemImage: "message",
                             german: "Es wäre schön, wenn du kämst.",
                             english: "It would be lovely if you came.", marked: ["wäre", "kämst"]),
            RealLifeSentence(place: "Email from work", systemImage: "at",
                             german: "Ein Termin am Freitag ginge auch.",
                             english: "An appointment on Friday would work too.", marked: ["ginge"])
        ],
        "b2-konjunktiv2-vergangenheit": [
            RealLifeSentence(place: "Message from a friend", systemImage: "message",
                             german: "Das hättest du mir früher sagen können!",
                             english: "You could have told me earlier!", marked: ["hättest", "können"]),
            RealLifeSentence(place: "After a missed train", systemImage: "tram",
                             german: "Fast hätte ich den Zug verpasst.",
                             english: "I almost missed the train.", marked: ["hätte", "verpasst"]),
            RealLifeSentence(place: "A colleague at work", systemImage: "briefcase",
                             german: "Ohne deine Hilfe wäre ich nicht fertig geworden.",
                             english: "Without your help I wouldn't have finished.", marked: ["wäre", "geworden"])
        ],
        "b2-hoeflich": [
            RealLifeSentence(place: "Phone call to an office", systemImage: "phone",
                             german: "Würden Sie mich bitte zurückrufen?",
                             english: "Would you call me back, please?", marked: ["Würden"]),
            RealLifeSentence(place: "On the train", systemImage: "tram",
                             german: "Dürfte ich mich hier hinsetzen?",
                             english: "Might I sit here?", marked: ["Dürfte"]),
            RealLifeSentence(place: "Email from work", systemImage: "at",
                             german: "Es wäre nett, wenn Sie mir kurz antworten könnten.",
                             english: "It would be kind if you could reply briefly.", marked: ["wäre", "könnten"])
        ],
        "b2-irreal": [
            RealLifeSentence(place: "Message from a friend", systemImage: "message",
                             german: "Hätte ich Zeit, würde ich mitkommen.",
                             english: "If I had time, I'd come along.", marked: ["Hätte", "würde"]),
            RealLifeSentence(place: "Rainy Monday", systemImage: "cloud.rain",
                             german: "Wäre doch schon Wochenende!",
                             english: "If only it were the weekend already!", marked: ["Wäre"]),
            RealLifeSentence(place: "A colleague at work", systemImage: "briefcase",
                             german: "Hätte ich das bloß gewusst!",
                             english: "If only I'd known!", marked: ["Hätte", "gewusst"])
        ],
        "b2-als-ob": [
            RealLifeSentence(place: "Talking about a colleague", systemImage: "briefcase",
                             german: "Sie tut so, als ob nichts passiert wäre.",
                             english: "She acts as if nothing had happened.", marked: ["als ob", "wäre"]),
            RealLifeSentence(place: "Weather on the radio", systemImage: "radio",
                             german: "Es sieht aus, als würde es gleich regnen.",
                             english: "It looks as if it's about to rain.", marked: ["als würde"]),
            RealLifeSentence(place: "Message from a friend", systemImage: "message",
                             german: "Ich fühle mich, als hätte ich nicht geschlafen.",
                             english: "I feel as if I hadn't slept.", marked: ["als hätte"])
        ],
        "b2-passiv": [
            RealLifeSentence(place: "Notice in your building", systemImage: "building.2",
                             german: "Am Freitag wird das Wasser abgestellt.",
                             english: "The water will be turned off on Friday.", marked: ["wird", "abgestellt"]),
            RealLifeSentence(place: "Letter from an office", systemImage: "envelope",
                             german: "Ihr Antrag ist genehmigt worden.",
                             english: "Your application has been approved.", marked: ["ist", "genehmigt worden"]),
            RealLifeSentence(place: "News headline", systemImage: "newspaper",
                             german: "Die Brücke wurde nach zwei Jahren wieder eröffnet.",
                             english: "The bridge was reopened after two years.", marked: ["wurde", "eröffnet"])
        ],
        "b2-passiv-modal": [
            RealLifeSentence(place: "At the till", systemImage: "creditcard",
                             german: "Hier kann nur mit Karte bezahlt werden.",
                             english: "Only card payments are accepted here.", marked: ["kann", "bezahlt werden"]),
            RealLifeSentence(place: "Letter from an office", systemImage: "envelope",
                             german: "Das Formular muss bis Montag eingereicht werden.",
                             english: "The form must be handed in by Monday.", marked: ["muss", "eingereicht werden"]),
            RealLifeSentence(place: "Sign in a museum", systemImage: "building.columns",
                             german: "Hier darf nicht fotografiert werden.",
                             english: "No photography here.", marked: ["darf", "fotografiert werden"])
        ],
        "b2-passiv-ersatz": [
            RealLifeSentence(place: "Instructions in the box", systemImage: "shippingbox",
                             german: "Der Deckel lässt sich leicht öffnen.",
                             english: "The lid opens easily.", marked: ["lässt sich", "öffnen"]),
            RealLifeSentence(place: "Letter from an office", systemImage: "envelope",
                             german: "Die Gebühr ist sofort zu bezahlen.",
                             english: "The fee must be paid immediately.", marked: ["ist", "zu bezahlen"]),
            RealLifeSentence(place: "At the café", systemImage: "cup.and.saucer",
                             german: "Das Leitungswasser ist hier trinkbar.",
                             english: "The tap water here is safe to drink.", marked: ["trinkbar"])
        ],
        "b2-wechselpraepositionen": [
            RealLifeSentence(place: "Moving house", systemImage: "shippingbox",
                             german: "Die Kisten kommen in den Keller.",
                             english: "The boxes go in the cellar.", marked: ["in den"]),
            RealLifeSentence(place: "In the kitchen", systemImage: "fork.knife",
                             german: "Die Schlüssel liegen auf dem Regal.",
                             english: "The keys are on the shelf.", marked: ["auf dem"]),
            RealLifeSentence(place: "At a restaurant", systemImage: "fork.knife",
                             german: "Setzen Sie sich doch ans Fenster.",
                             english: "Do sit by the window.", marked: ["ans"])
        ],
        "b2-wo-wohin-woher": [
            RealLifeSentence(place: "Planning a holiday", systemImage: "airplane",
                             german: "Wir fliegen im Mai in die Türkei.",
                             english: "We're flying to Turkey in May.", marked: ["in die"]),
            RealLifeSentence(place: "Message from a friend", systemImage: "message",
                             german: "Ich bin gerade bei meiner Oma.",
                             english: "I'm at my gran's right now.", marked: ["bei"]),
            RealLifeSentence(place: "Small talk", systemImage: "bubble.left.and.bubble.right",
                             german: "Woher kommst du? — Aus der Schweiz.",
                             english: "Where are you from? — Switzerland.", marked: ["Woher", "Aus der"])
        ],
        "b2-innerhalb": [
            RealLifeSentence(place: "Hotel website", systemImage: "bed.double",
                             german: "Parkplätze gibt es außerhalb des Zentrums.",
                             english: "There's parking outside the centre.", marked: ["außerhalb des"]),
            RealLifeSentence(place: "Directions on the phone", systemImage: "map",
                             german: "Die Apotheke ist gegenüber der Kirche.",
                             english: "The pharmacy is opposite the church.", marked: ["gegenüber der"]),
            RealLifeSentence(place: "Sign in a park", systemImage: "tree",
                             german: "Bitte gehen Sie den Weg entlang.",
                             english: "Please follow the path.", marked: ["den Weg entlang"])
        ],
        "b2-zeitpraepositionen": [
            RealLifeSentence(place: "Sign on a shop door", systemImage: "storefront",
                             german: "Ab Montag haben wir wieder geöffnet.",
                             english: "We're open again from Monday.", marked: ["Ab"]),
            RealLifeSentence(place: "Letter from an office", systemImage: "envelope",
                             german: "Bitte antworten Sie innerhalb von zwei Wochen.",
                             english: "Please reply within two weeks.", marked: ["innerhalb"]),
            RealLifeSentence(place: "Station announcement", systemImage: "tram",
                             german: "Der Zug hat über eine Stunde Verspätung.",
                             english: "The train is more than an hour late.", marked: ["über"])
        ],
        "b2-kausal-praepositionen": [
            RealLifeSentence(place: "Station announcement", systemImage: "tram",
                             german: "Wegen eines Unwetters fallen alle Züge aus.",
                             english: "Because of a storm, all trains are cancelled.", marked: ["Wegen"]),
            RealLifeSentence(place: "News headline", systemImage: "newspaper",
                             german: "Trotz des Regens kamen Tausende zum Konzert.",
                             english: "Despite the rain, thousands came to the concert.", marked: ["Trotz des"]),
            RealLifeSentence(place: "Message from a friend", systemImage: "message",
                             german: "Ich hätte fast vor Freude geweint!",
                             english: "I nearly cried with joy!", marked: ["vor Freude"])
        ],
        "b2-praeposition-stellung": [
            RealLifeSentence(place: "Meeting at work", systemImage: "bubble.left.and.bubble.right",
                             german: "Meiner Meinung nach ist das zu teuer.",
                             english: "In my opinion that's too expensive.", marked: ["nach"]),
            RealLifeSentence(place: "News on the radio", systemImage: "radio",
                             german: "Dem Bericht zufolge steigen die Mieten weiter.",
                             english: "According to the report, rents are still rising.", marked: ["zufolge"]),
            RealLifeSentence(place: "Directions on the phone", systemImage: "map",
                             german: "Das Café liegt dem Rathaus gegenüber.",
                             english: "The café is opposite the town hall.", marked: ["gegenüber"])
        ],
        "b2-verb-kasus": [
            RealLifeSentence(place: "Message from a friend", systemImage: "message",
                             german: "Danke, dass du mir geholfen hast!",
                             english: "Thanks for helping me!", marked: ["mir"]),
            RealLifeSentence(place: "In a clothes shop", systemImage: "tshirt",
                             german: "Die Farbe steht Ihnen gut.",
                             english: "The colour suits you.", marked: ["Ihnen"]),
            RealLifeSentence(place: "Email from work", systemImage: "at",
                             german: "Ich schicke Ihnen die Unterlagen morgen.",
                             english: "I'll send you the documents tomorrow.", marked: ["Ihnen", "die Unterlagen"])
        ]
    ]
}
