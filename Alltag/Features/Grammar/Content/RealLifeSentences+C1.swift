//
//  RealLifeSentences+C1.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The real-life sentences of the C1 rules: three each, from the news,
/// letters, work and friends.
extension RealLifeSentence {
    static let c1ByRule: [String: [RealLifeSentence]] = [
        "c1-zeitformen": c1Tenses,
        "c1-vermutung": c1PastGuess,
        "c1-sollen-wollen": c1Claims,
        "c1-trennbar": c1PrefixVerbs,
        "c1-genitivverben": c1GenitiveVerbs,
        "c1-artikelwoerter": c1ArticleWords,
        "c1-passiv-ohne-subjekt": c1PassiveNoSubject,
        "c1-passiv-grenzen": c1PassiveLimits,
        "c1-passiv-ersatz": c1PassiveAlternatives,
        "c1-wechselpraepositionen": c1PlacePrepositions,
        "c1-praepositionen-bedeutung": c1PrepositionMeanings,
        "c1-laut-zufolge": c1SourcePrepositions,
        "c1-zuliebe-mittels": c1MeaningPrepositions,
        "c1-verbinden-zeit": c1TimeLinks,
        "c1-verbinden-grund": c1ReasonLinks,
        "c1-verbinden-mittel": c1MeansLinks,
        "c1-nominalisierung": c1Nominal,
        "c1-funktionsverben": c1FunctionVerbs,
        "c1-attribute": c1Attributes,
        "c1-fokuspartikeln": c1FocusParticles,
        "c1-satzordnung": c1InformationOrder,
        "c1-gesprochen": c1SpokenGerman
    ]

    private static let c1Tenses: [RealLifeSentence] = [
        RealLifeSentence(place: "Message from a friend", systemImage: "message",
                         german: "Als ich ankam, hattet ihr schon gegessen.",
                         english: "When I arrived, you had already eaten.", marked: ["hattet", "gegessen"]),
        RealLifeSentence(place: "Email from work", systemImage: "at",
                         german: "Bis Ende des Monats werden wir alle Anträge bearbeitet haben.",
                         english: "By the end of the month we will have processed all the applications.",
                         marked: ["werden", "bearbeitet haben"]),
        RealLifeSentence(place: "News on the radio", systemImage: "radio",
                         german: "Nachdem der Sturm vorübergezogen war, öffneten die Schulen wieder.",
                         english: "After the storm had passed, the schools reopened.", marked: ["vorübergezogen war"])
    ]

    private static let c1PastGuess: [RealLifeSentence] = [
        RealLifeSentence(place: "Message from a friend", systemImage: "message",
                         german: "Du musst mich falsch verstanden haben.",
                         english: "You must have misunderstood me.", marked: ["musst", "verstanden haben"]),
        RealLifeSentence(place: "At the lost property office", systemImage: "bag",
                         german: "Sie könnten den Schirm im Zug vergessen haben.",
                         english: "You might have left the umbrella on the train.", marked: ["könnten", "vergessen haben"]),
        RealLifeSentence(place: "News on the radio", systemImage: "radio",
                         german: "Der Täter dürfte das Gebäude über den Hof verlassen haben.",
                         english: "The offender probably left the building through the courtyard.",
                         marked: ["dürfte", "verlassen haben"])
    ]

    private static let c1Claims: [RealLifeSentence] = [
        RealLifeSentence(place: "News headline", systemImage: "newspaper",
                         german: "Der Sänger soll heimlich geheiratet haben.",
                         english: "The singer is said to have married in secret.", marked: ["soll", "geheiratet haben"]),
        RealLifeSentence(place: "Message from a friend", systemImage: "message",
                         german: "Die Chefin sagt, du sollst sie zurückrufen.",
                         english: "The boss says you should call her back.", marked: ["sollst"]),
        RealLifeSentence(place: "A colleague at work", systemImage: "briefcase",
                         german: "Er will die Mail nie bekommen haben.",
                         english: "He claims he never got the email.", marked: ["will", "bekommen haben"])
    ]

    private static let c1PrefixVerbs: [RealLifeSentence] = [
        RealLifeSentence(place: "Traffic news on the radio", systemImage: "radio",
                         german: "Bitte umfahren Sie den Bereich weiträumig.",
                         english: "Please avoid the area by a wide margin.", marked: ["umfahren"]),
        RealLifeSentence(place: "Sign at the river", systemImage: "ferry",
                         german: "Die Fähre setzt jede Stunde über.",
                         english: "The ferry crosses every hour.", marked: ["setzt", "über"]),
        RealLifeSentence(place: "On the phone", systemImage: "phone",
                         german: "Könnten Sie die Nummer bitte wiederholen?",
                         english: "Could you repeat the number, please?", marked: ["wiederholen"])
    ]

    private static let c1GenitiveVerbs: [RealLifeSentence] = [
        RealLifeSentence(place: "Your tenancy agreement", systemImage: "doc.text",
                         german: "Jede Änderung bedarf der Schriftform.",
                         english: "Any change must be made in writing.", marked: ["bedarf", "der Schriftform"]),
        RealLifeSentence(place: "News on the radio", systemImage: "radio",
                         german: "Heute gedenken wir der Opfer des Anschlags.",
                         english: "Today we remember the victims of the attack.", marked: ["gedenken", "der Opfer"]),
        RealLifeSentence(place: "News headline", systemImage: "newspaper",
                         german: "Ex-Manager des Betrugs überführt",
                         english: "Former manager found guilty of fraud", marked: ["des Betrugs", "überführt"])
    ]

    private static let c1ArticleWords: [RealLifeSentence] = [
        RealLifeSentence(place: "Sign at the bakery", systemImage: "storefront",
                         german: "Alle frischen Backwaren ab 18 Uhr zum halben Preis.",
                         english: "All fresh baked goods half price from 6 pm.", marked: ["Alle frischen"]),
        RealLifeSentence(place: "Station announcement", systemImage: "tram",
                         german: "Wegen Bauarbeiten fallen mehrere regionale Verbindungen aus.",
                         english: "Due to construction work, several regional connections are cancelled.",
                         marked: ["mehrere regionale"]),
        RealLifeSentence(place: "Email from work", systemImage: "at",
                         german: "Bitte informieren Sie alle neuen Kolleginnen und Kollegen.",
                         english: "Please let all the new colleagues know.", marked: ["alle neuen"])
    ]

    private static let c1PassiveNoSubject: [RealLifeSentence] = [
        RealLifeSentence(place: "Sign in the library", systemImage: "books.vertical",
                         german: "Hier wird nicht gegessen und nicht telefoniert.",
                         english: "No eating or phone calls here.", marked: ["wird", "gegessen", "telefoniert"]),
        RealLifeSentence(place: "Notice in your building", systemImage: "building.2",
                         german: "Ab 22 Uhr wird nicht mehr gebohrt.",
                         english: "No drilling after 10 pm.", marked: ["wird", "gebohrt"]),
        RealLifeSentence(place: "Message from a friend", systemImage: "message",
                         german: "Bei uns wird am Samstag gegrillt. Kommst du?",
                         english: "We're having a barbecue on Saturday. Are you coming?", marked: ["wird", "gegrillt"])
    ]

    private static let c1PassiveLimits: [RealLifeSentence] = [
        RealLifeSentence(place: "Parcel notification", systemImage: "shippingbox",
                         german: "Ihr Paket wurde zugestellt.",
                         english: "Your parcel has been delivered.", marked: ["wurde", "zugestellt"]),
        RealLifeSentence(place: "Email from work", systemImage: "at",
                         german: "Ich habe Ihre Nachricht erhalten.",
                         english: "I have received your message.", marked: ["habe", "erhalten"]),
        RealLifeSentence(place: "Station announcement", systemImage: "tram",
                         german: "Der Zug aus Köln ist soeben angekommen.",
                         english: "The train from Cologne has just arrived.", marked: ["ist", "angekommen"])
    ]

    private static let c1PassiveAlternatives: [RealLifeSentence] = [
        RealLifeSentence(place: "Letter from an office", systemImage: "envelope",
                         german: "Die Gebühr ist innerhalb von zwei Wochen zu zahlen.",
                         english: "The fee must be paid within two weeks.", marked: ["ist", "zu zahlen"]),
        RealLifeSentence(place: "On the train", systemImage: "tram",
                         german: "Das Fenster lässt sich leider nicht öffnen.",
                         english: "Unfortunately the window can't be opened.", marked: ["lässt sich", "öffnen"]),
        RealLifeSentence(place: "Email from work", systemImage: "at",
                         german: "Anbei finden Sie die noch zu prüfenden Verträge.",
                         english: "Attached are the contracts that still need checking.", marked: ["zu prüfenden"])
    ]

    private static let c1PlacePrepositions: [RealLifeSentence] = [
        RealLifeSentence(place: "News on the radio", systemImage: "radio",
                         german: "Über 2.000 Menschen feierten unter freiem Himmel.",
                         english: "Over 2,000 people celebrated in the open air.", marked: ["Über", "unter"]),
        RealLifeSentence(place: "A colleague at work", systemImage: "briefcase",
                         german: "Unter uns: Das Projekt steht unter Zeitdruck.",
                         english: "Between us, the project is under time pressure.", marked: ["Unter", "unter"]),
        RealLifeSentence(place: "Message from a friend", systemImage: "message",
                         german: "Ich bin vor Lachen fast vom Stuhl gefallen!",
                         english: "I nearly fell off my chair laughing!", marked: ["vor"])
    ]

    private static let c1PrepositionMeanings: [RealLifeSentence] = [
        RealLifeSentence(place: "News headline", systemImage: "newspaper",
                         german: "Mieten in Berlin um 8 Prozent gestiegen",
                         english: "Rents in Berlin up by 8 per cent", marked: ["um"]),
        RealLifeSentence(place: "Sign at the outdoor pool", systemImage: "figure.pool.swim",
                         german: "Bei Gewitter ist das Becken sofort zu verlassen.",
                         english: "In a thunderstorm, leave the pool at once.", marked: ["Bei"]),
        RealLifeSentence(place: "Email from work", systemImage: "at",
                         german: "Meiner Meinung nach sollten wir das Treffen verschieben.",
                         english: "In my opinion we should postpone the meeting.", marked: ["nach"])
    ]

    private static let c1SourcePrepositions: [RealLifeSentence] = [
        RealLifeSentence(place: "News on the radio", systemImage: "radio",
                         german: "Laut Polizei wurde niemand verletzt.",
                         english: "According to the police, nobody was hurt.", marked: ["Laut"]),
        RealLifeSentence(place: "Letter from an office", systemImage: "envelope",
                         german: "Bezüglich Ihrer Anfrage vom 3. Mai teilen wir Ihnen Folgendes mit.",
                         english: "Regarding your enquiry of 3 May, we can tell you the following.", marked: ["Bezüglich"]),
        RealLifeSentence(place: "News headline", systemImage: "newspaper",
                         german: "Experten zufolge steigen die Preise weiter.",
                         english: "According to experts, prices will keep rising.", marked: ["zufolge"])
    ]

    private static let c1MeaningPrepositions: [RealLifeSentence] = [
        RealLifeSentence(place: "Hotel information", systemImage: "bed.double",
                         german: "Ihre Zimmertür öffnen Sie mittels Ihrer Schlüsselkarte.",
                         english: "You open your room door with your key card.", marked: ["mittels"]),
        RealLifeSentence(place: "Message from a friend", systemImage: "message",
                         german: "Dir zuliebe komme ich mit ins Museum.",
                         english: "For your sake, I'll come to the museum.", marked: ["zuliebe"]),
        RealLifeSentence(place: "News on the radio", systemImage: "radio",
                         german: "Anhand der Videoaufnahmen wurde der Täter erkannt.",
                         english: "The offender was identified from the video footage.", marked: ["Anhand"])
    ]

    private static let c1TimeLinks: [RealLifeSentence] = [
        RealLifeSentence(place: "Sign in the office kitchen", systemImage: "cup.and.saucer",
                         german: "Bitte spülen Sie Ihre Tasse, bevor Sie gehen.",
                         english: "Please wash your cup before you leave.", marked: ["bevor", "gehen"]),
        RealLifeSentence(place: "Station announcement", systemImage: "tram",
                         german: "Während der Bauarbeiten fahren Ersatzbusse.",
                         english: "Replacement buses run during the construction work.", marked: ["Während"]),
        RealLifeSentence(place: "Message from a friend", systemImage: "message",
                         german: "Ich gehe noch einkaufen, danach komme ich zu dir.",
                         english: "I'm going shopping first, then I'll come round to yours.", marked: ["danach", "komme"])
    ]

    private static let c1ReasonLinks: [RealLifeSentence] = [
        RealLifeSentence(place: "Station announcement", systemImage: "tram",
                         german: "Wegen einer Störung verzögert sich die Abfahrt.",
                         english: "Due to a fault, the departure is delayed.", marked: ["Wegen"]),
        RealLifeSentence(place: "Email from work", systemImage: "at",
                         german: "Das Treffen fällt aus, stattdessen sprechen wir online.",
                         english: "The meeting is cancelled; we'll talk online instead.", marked: ["stattdessen", "sprechen"]),
        RealLifeSentence(place: "News on the radio", systemImage: "radio",
                         german: "Obwohl die Preise steigen, kaufen die Menschen mehr.",
                         english: "Although prices are rising, people are buying more.", marked: ["Obwohl", "steigen"])
    ]

    private static let c1MeansLinks: [RealLifeSentence] = [
        RealLifeSentence(place: "Health insurance leaflet", systemImage: "cross.case",
                         german: "Sie sparen Zeit, indem Sie den Antrag online stellen.",
                         english: "You save time by applying online.", marked: ["indem", "stellen"]),
        RealLifeSentence(place: "Sign on a shop door", systemImage: "door.left.hand.closed",
                         german: "Bei Fragen wenden Sie sich bitte an unser Personal.",
                         english: "If you have any questions, please ask our staff.", marked: ["Bei"]),
        RealLifeSentence(place: "Letter from an office", systemImage: "envelope",
                         german: "Damit wir Ihren Antrag bearbeiten können, brauchen wir Ihre Unterschrift.",
                         english: "So that we can process your application, we need your signature.", marked: ["Damit", "können"])
    ]

    private static let c1Nominal: [RealLifeSentence] = [
        RealLifeSentence(place: "News headline", systemImage: "newspaper",
                         german: "Wegen des Streiks fallen viele Flüge aus.",
                         english: "Because of the strike, many flights are cancelled.", marked: ["Wegen des Streiks"]),
        RealLifeSentence(place: "Your tenancy agreement", systemImage: "doc.text",
                         german: "Nach Ablauf der Frist ist keine Kündigung mehr möglich.",
                         english: "Once the deadline has passed, notice can no longer be given.",
                         marked: ["Nach Ablauf der Frist"]),
        RealLifeSentence(place: "Railway app", systemImage: "iphone",
                         german: "Bei Verspätungen informieren wir Sie per Push-Nachricht.",
                         english: "If there are delays, we'll let you know with a notification.", marked: ["Bei Verspätungen"]),
        RealLifeSentence(place: "Letter from an office", systemImage: "envelope",
                         german: "Zur Prüfung Ihres Antrags benötigen wir weitere Unterlagen.",
                         english: "To check your application, we need further documents.",
                         marked: ["Zur Prüfung Ihres Antrags"])
    ]

    private static let c1FunctionVerbs: [RealLifeSentence] = [
        RealLifeSentence(place: "News on the radio", systemImage: "radio",
                         german: "Die neue Regel tritt im März in Kraft.",
                         english: "The new rule comes into force in March.", marked: ["tritt", "in Kraft"]),
        RealLifeSentence(place: "Email from work", systemImage: "at",
                         german: "Gern stelle ich Ihnen die Unterlagen zur Verfügung.",
                         english: "I'm happy to provide you with the documents.", marked: ["stelle", "zur Verfügung"]),
        RealLifeSentence(place: "Letter from an office", systemImage: "envelope",
                         german: "Eine Verlängerung kommt leider nicht in Frage.",
                         english: "Unfortunately, an extension is out of the question.", marked: ["kommt", "in Frage"])
    ]

    private static let c1Attributes: [RealLifeSentence] = [
        RealLifeSentence(place: "Station announcement", systemImage: "tram",
                         german: "Der aus München kommende ICE fährt heute auf Gleis 7 ein.",
                         english: "The ICE from Munich arrives on platform 7 today.", marked: ["aus München kommende"]),
        RealLifeSentence(place: "Letter from an office", systemImage: "envelope",
                         german: "Bitte senden Sie uns die ausgefüllten und unterschriebenen Formulare zurück.",
                         english: "Please send the completed and signed forms back to us.",
                         marked: ["ausgefüllten", "unterschriebenen"]),
        RealLifeSentence(place: "News headline", systemImage: "newspaper",
                         german: "Die lange erwartete Brücke über die Elbe ist eröffnet.",
                         english: "The long-awaited bridge over the Elbe has opened.", marked: ["lange erwartete", "über die Elbe"])
    ]

    private static let c1FocusParticles: [RealLifeSentence] = [
        RealLifeSentence(place: "Sign on a shop door", systemImage: "door.left.hand.closed",
                         german: "Nur heute: alle Schuhe zum halben Preis.",
                         english: "Today only: all shoes half price.", marked: ["Nur"]),
        RealLifeSentence(place: "Station announcement", systemImage: "tram",
                         german: "Der Zug fährt erst in zehn Minuten ab.",
                         english: "The train won't leave for another ten minutes.", marked: ["erst"]),
        RealLifeSentence(place: "Message from a friend", systemImage: "message",
                         german: "Sogar mein Chef hat gelacht!",
                         english: "Even my boss laughed!", marked: ["Sogar"])
    ]

    private static let c1InformationOrder: [RealLifeSentence] = [
        RealLifeSentence(place: "Message from a friend", systemImage: "message",
                         german: "Den Schlüssel habe ich dir doch gestern gegeben!",
                         english: "But I gave you the key yesterday!", marked: ["Den Schlüssel", "dir"]),
        RealLifeSentence(place: "At the post office", systemImage: "envelope",
                         german: "Können Sie mir das bitte einpacken?",
                         english: "Could you wrap that for me, please?", marked: ["mir das"]),
        RealLifeSentence(place: "Email from work", systemImage: "at",
                         german: "Ich schicke Ihnen die Präsentation morgen früh.",
                         english: "I'll send you the presentation tomorrow morning.", marked: ["Ihnen", "die Präsentation"])
    ]

    private static let c1SpokenGerman: [RealLifeSentence] = [
        RealLifeSentence(place: "Message from a friend", systemImage: "message",
                         german: "Haste heute Abend Zeit?",
                         english: "Are you free this evening?", marked: ["Haste"]),
        RealLifeSentence(place: "On the train", systemImage: "tram",
                         german: "Gibt's hier noch 'n freien Platz?",
                         english: "Is there a free seat here?", marked: ["Gibt's", "'n"]),
        RealLifeSentence(place: "A colleague at work", systemImage: "briefcase",
                         german: "Ich hab grad 'ne Idee.",
                         english: "I've just had an idea.", marked: ["hab", "'ne"])
    ]
}
