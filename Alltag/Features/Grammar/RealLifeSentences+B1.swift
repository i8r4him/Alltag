//
//  RealLifeSentences+B1.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The real-life sentences of the B1 rules: three short ones each. The second
/// half is in `RealLifeSentences+B1More.swift`.
extension RealLifeSentence {
    static let b1ByRule: [String: [RealLifeSentence]] = [
        "b1-praeteritum": b1SimplePast,
        "b1-plusquamperfekt": b1PastPerfect,
        "b1-wenn-als": b1WennAls,
        "b1-zeitsaetze": b1TimeClauses,
        "b1-indirekte-frage": b1IndirectQuestions,
        "b1-relativsatz": b1RelativeClauses,
        "b1-relativsatz-dativ": b1RelativeClausesDative,
        "b1-trennbar-untrennbar": b1PrefixVerbs,
        "b1-reflexiv-dativ": b1ReflexiveDative,
        "b1-stellen-stehen": b1PlaceVerbs,
        "b1-verb-praeposition": b1PrepositionVerbs,
        "b1-da-wo": b1DaWoWords,
        "b1-zu-infinitiv": b1ZuInfinitive,
        "b1-ohne-zu": b1BareInfinitive,
        "b1-um-zu-damit": b1Purpose,
        "b1-lassen": b1Lassen,
        "b1-futur": b1Future,
        "b1-passiv": b1Passive,
        "b1-konjunktiv-zwei": b1Subjunctive,
        "b1-werden": b1UsesOfWerden,
        "b1-genitiv": b1Genitive,
        "b1-genitiv-praepositionen": b1GenitivePrepositions,
        "b1-zeitpraepositionen": b1TimePrepositions,
        "b1-n-deklination": b1NDeclension,
        "b1-adjektiv-ohne-artikel": b1AdjectiveNoArticle,
        "b1-adjektiv-nomen": b1AdjectiveNouns,
        "b1-superlativ": b1Superlative,
        "b1-partizip-eins": b1PresentParticiple,
        "b1-doppelkonnektoren": b1TwoPartConnectors,
        "b1-je-desto": b1JeDesto
    ]

    private static let b1SimplePast: [RealLifeSentence] = [
        RealLifeSentence(place: "Message from a colleague", systemImage: "message",
                         german: "Tut mir leid, ich hatte keine Zeit.",
                         english: "Sorry, I didn't have time.", marked: ["hatte"]),
        RealLifeSentence(place: "News on the radio", systemImage: "radio",
                         german: "Der Bundestag stimmte gestern über das Gesetz ab.",
                         english: "Yesterday the Bundestag voted on the law.", marked: ["stimmte", "ab"]),
        RealLifeSentence(place: "At the doctor's", systemImage: "stethoscope",
                         german: "Wann hatten Sie zum ersten Mal Fieber?",
                         english: "When did you first have a temperature?", marked: ["hatten"])
    ]

    private static let b1PastPerfect: [RealLifeSentence] = [
        RealLifeSentence(place: "Police report in the paper", systemImage: "newspaper",
                         german: "Der Fahrer hatte die rote Ampel nicht gesehen.",
                         english: "The driver hadn't seen the red light.", marked: ["hatte", "gesehen"]),
        RealLifeSentence(place: "Message from a friend", systemImage: "message",
                         german: "Ich hatte meinen Schlüssel vergessen, deshalb kam ich zu spät.",
                         english: "I'd forgotten my key, so I was late.", marked: ["hatte", "vergessen"]),
        RealLifeSentence(place: "Station announcement", systemImage: "tram",
                         german: "Der Anschlusszug war bereits abgefahren.",
                         english: "The connecting train had already left.", marked: ["war", "abgefahren"])
    ]

    private static let b1WennAls: [RealLifeSentence] = [
        RealLifeSentence(place: "Looking at old photos", systemImage: "photo",
                         german: "Als ich ein Kind war, hatten wir einen Hund.",
                         english: "When I was a child, we had a dog.", marked: ["Als", "war"]),
        RealLifeSentence(place: "Sign on a shop door", systemImage: "storefront",
                         german: "Wenn niemand da ist, klingeln Sie bitte.",
                         english: "If nobody is here, please ring the bell.", marked: ["Wenn", "ist"]),
        RealLifeSentence(place: "Message from a friend", systemImage: "message",
                         german: "Ruf mich an, wenn du zu Hause bist.",
                         english: "Call me when you're home.", marked: ["wenn", "bist"])
    ]

    private static let b1TimeClauses: [RealLifeSentence] = [
        RealLifeSentence(place: "Medicine leaflet", systemImage: "cross.case",
                         german: "Nehmen Sie die Tablette, bevor Sie essen.",
                         english: "Take the tablet before you eat.", marked: ["bevor", "essen"]),
        RealLifeSentence(place: "On the platform", systemImage: "tram",
                         german: "Bitte steigen Sie erst ein, nachdem alle ausgestiegen sind.",
                         english: "Please wait until everyone has got off before you get on.", marked: ["nachdem", "sind"]),
        RealLifeSentence(place: "Meeting a neighbour", systemImage: "house",
                         german: "Seit wir hier wohnen, ist es viel ruhiger.",
                         english: "Since we've lived here, it's been much quieter.", marked: ["Seit", "wohnen"])
    ]

    private static let b1IndirectQuestions: [RealLifeSentence] = [
        RealLifeSentence(place: "At the station", systemImage: "tram",
                         german: "Wissen Sie, wann der nächste Zug fährt?",
                         english: "Do you know when the next train leaves?", marked: ["wann", "fährt"]),
        RealLifeSentence(place: "Email from work", systemImage: "at",
                         german: "Bitte sagen Sie mir, ob Sie am Freitag kommen.",
                         english: "Please let me know whether you're coming on Friday.", marked: ["ob", "kommen"]),
        RealLifeSentence(place: "At the town hall", systemImage: "building.columns",
                         german: "Können Sie mir erklären, was ich hier ausfüllen muss?",
                         english: "Can you explain what I have to fill in here?", marked: ["was", "muss"])
    ]

    private static let b1RelativeClauses: [RealLifeSentence] = [
        RealLifeSentence(place: "At the post office", systemImage: "shippingbox",
                         german: "Ich habe ein Paket, das nicht in den Briefkasten passt.",
                         english: "I have a parcel that doesn't fit in the letterbox.", marked: ["das", "passt"]),
        RealLifeSentence(place: "At the doctor's", systemImage: "stethoscope",
                         german: "Gibt es hier einen Arzt, der Englisch spricht?",
                         english: "Is there a doctor here who speaks English?", marked: ["der", "spricht"]),
        RealLifeSentence(place: "Flat advert", systemImage: "house",
                         german: "Wir suchen einen Mieter, der nicht raucht.",
                         english: "We're looking for a tenant who doesn't smoke.", marked: ["der", "raucht"])
    ]

    private static let b1RelativeClausesDative: [RealLifeSentence] = [
        RealLifeSentence(place: "Flat advert", systemImage: "house",
                         german: "Wir bieten eine Wohnung, in der Haustiere erlaubt sind.",
                         english: "We're offering a flat where pets are allowed.", marked: ["in der", "sind"]),
        RealLifeSentence(place: "A colleague at work", systemImage: "briefcase",
                         german: "Das ist der Kunde, mit dem ich telefoniert habe.",
                         english: "That's the customer I spoke to on the phone.", marked: ["mit dem", "habe"]),
        RealLifeSentence(place: "Message from a friend", systemImage: "message",
                         german: "Das ist das Café, wo wir uns kennengelernt haben.",
                         english: "That's the café where we met.", marked: ["wo", "haben"])
    ]

    private static let b1PrefixVerbs: [RealLifeSentence] = [
        RealLifeSentence(place: "Station announcement", systemImage: "tram",
                         german: "Bitte steigen Sie hier aus.",
                         english: "Please get off here.", marked: ["steigen", "aus"]),
        RealLifeSentence(place: "Email from work", systemImage: "at",
                         german: "Ich habe Ihre Nachricht erhalten.",
                         english: "I have received your message.", marked: ["erhalten"]),
        RealLifeSentence(place: "At the language school", systemImage: "graduationcap",
                         german: "Entschuldigung, ich verstehe die Frage nicht.",
                         english: "Sorry, I don't understand the question.", marked: ["verstehe"])
    ]

    private static let b1ReflexiveDative: [RealLifeSentence] = [
        RealLifeSentence(place: "At the doctor's", systemImage: "stethoscope",
                         german: "Ich habe mir den Arm gebrochen.",
                         english: "I've broken my arm.", marked: ["mir"]),
        RealLifeSentence(place: "Message from a friend", systemImage: "message",
                         german: "Kannst du dir das vorstellen?",
                         english: "Can you imagine that?", marked: ["dir"]),
        RealLifeSentence(place: "Before a meeting", systemImage: "briefcase",
                         german: "Ich sehe mir die Unterlagen morgen an.",
                         english: "I'll look at the documents tomorrow.", marked: ["mir"])
    ]

    private static let b1PlaceVerbs: [RealLifeSentence] = [
        RealLifeSentence(place: "Notice in your building", systemImage: "building.2",
                         german: "Bitte stellen Sie keine Fahrräder in den Flur.",
                         english: "Please don't put bicycles in the hallway.", marked: ["stellen", "in den Flur"]),
        RealLifeSentence(place: "Message from a friend", systemImage: "message",
                         german: "Der Schlüssel liegt unter der Matte.",
                         english: "The key is under the mat.", marked: ["liegt", "unter der Matte"]),
        RealLifeSentence(place: "At the hotel reception", systemImage: "key",
                         german: "Ihren Mantel können Sie an die Garderobe hängen.",
                         english: "You can hang your coat on the coat rack.", marked: ["an die Garderobe", "hängen"])
    ]

    private static let b1PrepositionVerbs: [RealLifeSentence] = [
        RealLifeSentence(place: "Email from work", systemImage: "at",
                         german: "Ich freue mich auf Ihre Antwort.",
                         english: "I look forward to your reply.", marked: ["freue", "auf"]),
        RealLifeSentence(place: "Station announcement", systemImage: "tram",
                         german: "Wir bitten um Ihr Verständnis.",
                         english: "We apologise for the inconvenience.", marked: ["bitten", "um"]),
        RealLifeSentence(place: "Letter from an office", systemImage: "envelope",
                         german: "Bitte denken Sie an Ihren Ausweis.",
                         english: "Please remember your ID card.", marked: ["denken", "an"])
    ]

    private static let b1DaWoWords: [RealLifeSentence] = [
        RealLifeSentence(place: "Email from work", systemImage: "at",
                         german: "Vielen Dank dafür!",
                         english: "Thanks a lot for that!", marked: ["dafür"]),
        RealLifeSentence(place: "At the town hall", systemImage: "building.columns",
                         german: "Worum geht es?",
                         english: "What's it about?", marked: ["Worum"]),
        RealLifeSentence(place: "Message from a friend", systemImage: "message",
                         german: "Hast du daran gedacht, Milch zu kaufen?",
                         english: "Did you remember to buy milk?", marked: ["daran"])
    ]

    private static let b1ZuInfinitive: [RealLifeSentence] = [
        RealLifeSentence(place: "Sign in a museum", systemImage: "building.columns",
                         german: "Es ist nicht erlaubt, hier zu fotografieren.",
                         english: "Taking photos is not allowed here.", marked: ["zu fotografieren"]),
        RealLifeSentence(place: "Email from work", systemImage: "at",
                         german: "Ich versuche, Sie morgen anzurufen.",
                         english: "I'll try to call you tomorrow.", marked: ["anzurufen"]),
        RealLifeSentence(place: "Message from a friend", systemImage: "message",
                         german: "Hast du Lust, heute Abend ins Kino zu gehen?",
                         english: "Do you fancy going to the cinema tonight?", marked: ["zu gehen"])
    ]

    private static let b1BareInfinitive: [RealLifeSentence] = [
        RealLifeSentence(place: "Message from a friend", systemImage: "message",
                         german: "Gehen wir heute Abend essen?",
                         english: "Shall we go out to eat tonight?", marked: ["Gehen", "essen"]),
        RealLifeSentence(place: "At the doctor's", systemImage: "stethoscope",
                         german: "Bleiben Sie bitte noch kurz liegen.",
                         english: "Please stay lying down for a moment.", marked: ["Bleiben", "liegen"]),
        RealLifeSentence(place: "Meeting a neighbour", systemImage: "house",
                         german: "Ich höre Ihre Kinder oft singen.",
                         english: "I often hear your children singing.", marked: ["höre", "singen"])
    ]

    private static let b1Purpose: [RealLifeSentence] = [
        RealLifeSentence(place: "Letter from an office", systemImage: "envelope",
                         german: "Um den Antrag zu bearbeiten, brauchen wir Ihre Unterschrift.",
                         english: "To process the application, we need your signature.", marked: ["Um", "zu bearbeiten"]),
        RealLifeSentence(place: "Sign on a front door", systemImage: "door.left.hand.closed",
                         german: "Bitte Tür schließen, damit die Katze nicht rausläuft.",
                         english: "Please close the door so the cat doesn't get out.", marked: ["damit", "rausläuft"]),
        RealLifeSentence(place: "At the language school", systemImage: "graduationcap",
                         german: "Ich lerne jeden Tag, um die Prüfung zu bestehen.",
                         english: "I study every day to pass the exam.", marked: ["um", "zu bestehen"])
    ]
}
