//
//  WordCollections+C2.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension WordCollections {
    /// C2: eleven topics of fifteen words, in the `WordCollections+C2…` files: the shades,
    /// idioms and set phrases of near-native German. This file has people and everyday life.
    static let c2: [WordCollection] = [
        c2Nuances, c2Debate, c2Idioms, c2Slang, c2FoodCulture, c2City, c2HealthEthics, c2Belonging, c2Business, c2Officialese, c2History
    ]

    static let c2Nuances = WordCollection(
        id: "c2-zwischentoene", title: "Zwischentöne", subtitle: "Shades of feeling", level: .c2,
        category: .people, systemImage: "theatermasks.fill",
        words: [
            CollectionWord("die ", "Wehmut", "wistfulness",
                           "Mit Wehmut denke ich an die Zeit in Leipzig zurück.", "I think back wistfully to my time in Leipzig."),
            CollectionWord("die ", "Schadenfreude", "pleasure at someone else’s misfortune",
                           "Ein bisschen Schadenfreude konnte ich mir nicht verkneifen.", "I couldn’t help feeling a little gleeful."),
            CollectionWord("die ", "Fremdscham", "cringing for someone else",
                           "Bei seiner Rede hatte ich echte Fremdscham.", "His speech made me cringe for him."),
            CollectionWord("die ", "Genugtuung", "satisfaction, vindication",
                           "Der Sieg vor Gericht war eine späte Genugtuung.", "Winning in court was a late vindication."),
            CollectionWord("das ", "Unbehagen", "unease",
                           "Bei dem Gedanken beschleicht mich ein leises Unbehagen.", "The thought gives me a slight feeling of unease."),
            CollectionWord("die ", "Rührung", "being moved, emotion",
                           "Bei der Hochzeitsrede hatten alle Tränen der Rührung in den Augen.",
                           "Everyone had tears in their eyes during the wedding speech."),
            CollectionWord("der ", "Groll", "grudge, resentment",
                           "Er hegt noch immer einen Groll gegen seinen Bruder.", "He still holds a grudge against his brother."),
            CollectionWord("die ", "Torschlusspanik", "fear that time is running out",
                           "Mit 39 bekam sie plötzlich Torschlusspanik.", "At 39 she suddenly panicked that time was running out."),
            CollectionWord("der ", "Weltschmerz", "world-weariness",
                           "Im Herbst packt mich manchmal der Weltschmerz.", "In autumn I’m sometimes gripped by world-weariness."),
            CollectionWord("die ", "Ehrfurcht", "awe",
                           "Vor dem Kölner Dom standen wir voller Ehrfurcht.", "We stood in awe in front of Cologne Cathedral."),
            CollectionWord("die ", "Verbitterung", "bitterness",
                           "Nach der Kündigung blieb bei ihm eine tiefe Verbitterung.", "Losing his job left him deeply bitter."),
            CollectionWord("", "kleinlaut", "sheepish",
                           "Nach dem Streit kam er ganz kleinlaut zurück.", "After the row he came back looking very sheepish."),
            CollectionWord("", "beklommen", "uneasy, anxious",
                           "Vor dem Gespräch war mir ziemlich beklommen zumute.", "I felt pretty anxious before the talk."),
            CollectionWord("", "überschwänglich", "effusive",
                           "Sie bedankte sich überschwänglich für die Blumen.", "She thanked us effusively for the flowers."),
            CollectionWord("", "hin- und hergerissen", "torn (between two choices)",
                           "Bei dem Jobangebot bin ich hin- und hergerissen.", "I’m torn about the job offer.")
        ]
    )

    static let c2Debate = WordCollection(
        id: "c2-debatte", title: "Haltung und Debatte", subtitle: "Taking a stand", level: .c2,
        category: .everyday, systemImage: "megaphone.fill",
        words: [
            CollectionWord("die ", "Meinungsmache", "spin, opinion-making",
                           "Der Bericht ist für mich reine Meinungsmache.", "To me the report is pure spin."),
            CollectionWord("der ", "Diskurs", "public debate, discourse",
                           "Der öffentliche Diskurs ist rauer geworden.", "Public debate has become harsher."),
            CollectionWord("die ", "Polarisierung", "polarisation",
                           "Soziale Medien verstärken die Polarisierung.", "Social media makes polarisation worse."),
            CollectionWord("die ", "Zivilcourage", "the courage to step in",
                           "Als die Frau belästigt wurde, zeigte ein Fahrgast Zivilcourage.",
                           "When the woman was harassed, a passenger had the courage to step in."),
            CollectionWord("die ", "Doppelmoral", "double standards",
                           "Das ist doch reine Doppelmoral!", "That’s pure double standards!"),
            CollectionWord("das ", "Gemeinwohl", "the common good",
                           "Politik sollte dem Gemeinwohl dienen.", "Politics should serve the common good."),
            CollectionWord("die ", "Streitkultur", "culture of debate",
                           "In unserer Familie gibt es eine gesunde Streitkultur.", "Our family has a healthy way of arguing things out."),
            CollectionWord("der ", "Zeitgeist", "spirit of the times",
                           "Die Serie trifft genau den Zeitgeist.", "The series perfectly captures the spirit of the times."),
            CollectionWord("das ", "Spannungsfeld", "tension (between two sides)",
                           "Wir bewegen uns im Spannungsfeld zwischen Freiheit und Sicherheit.",
                           "We’re caught between freedom and security."),
            CollectionWord("die ", "Gratwanderung", "balancing act",
                           "Satire ist immer eine Gratwanderung.", "Satire is always a balancing act."),
            CollectionWord("das ", "Tabu", "taboo",
                           "Über Geld zu sprechen ist hier immer noch ein Tabu.", "Talking about money is still taboo here."),
            CollectionWord("", "Stellung beziehen", "to take a position",
                           "Der Verein will nicht öffentlich Stellung beziehen.", "The club doesn’t want to take a public position."),
            CollectionWord("", "pauschalisieren", "to generalise",
                           "Man sollte nicht pauschalisieren, nicht alle Beamten sind langsam.",
                           "You shouldn’t generalise, not all civil servants are slow."),
            CollectionWord("", "scheinheilig", "hypocritical",
                           "Seine Entschuldigung klang ziemlich scheinheilig.", "His apology sounded pretty hypocritical."),
            CollectionWord("", "unverblümt", "bluntly",
                           "Sie hat ihm unverblümt die Meinung gesagt.", "She told him bluntly what she thought.")
        ]
    )

    static let c2Idioms = WordCollection(
        id: "c2-redewendungen", title: "Redewendungen", subtitle: "Idioms", level: .c2,
        category: .everyday, systemImage: "quote.bubble.fill",
        words: [
            CollectionWord("", "jemandem die Daumen drücken", "to keep your fingers crossed for someone",
                           "Ich drücke dir morgen für die Prüfung die Daumen!", "I’ll keep my fingers crossed for your exam tomorrow!"),
            CollectionWord("", "auf dem Holzweg sein", "to be on the wrong track",
                           "Mit dieser Vermutung bist du auf dem Holzweg.", "You’re on the wrong track with that guess."),
            CollectionWord("", "ins Fettnäpfchen treten", "to put your foot in it",
                           "Mit der Frage nach ihrem Alter bin ich voll ins Fettnäpfchen getreten.",
                           "I really put my foot in it by asking her age."),
            CollectionWord("", "Tomaten auf den Augen haben", "to miss something obvious",
                           "Hast du Tomaten auf den Augen? Das Schild ist doch riesig!", "Are you blind? The sign is huge!"),
            CollectionWord("", "den Nagel auf den Kopf treffen", "to hit the nail on the head",
                           "Mit deinem Kommentar hast du den Nagel auf den Kopf getroffen.",
                           "You hit the nail on the head with your comment."),
            CollectionWord("", "um den heißen Brei herumreden", "to beat about the bush",
                           "Red nicht um den heißen Brei herum, sag einfach, was los ist.",
                           "Stop beating about the bush and just say what’s wrong."),
            CollectionWord("", "die Kirche im Dorf lassen", "not to get carried away",
                           "Lass mal die Kirche im Dorf, so schlimm war es nicht.", "Let’s not get carried away, it wasn’t that bad."),
            CollectionWord("", "jemandem einen Bären aufbinden", "to pull someone’s leg",
                           "Du willst mir doch einen Bären aufbinden!", "You’re pulling my leg!"),
            CollectionWord("", "auf großem Fuß leben", "to live the high life",
                           "Seit der Erbschaft lebt er auf großem Fuß.", "Since the inheritance he’s been living the high life."),
            CollectionWord("", "die Nase voll haben", "to be fed up",
                           "Ich habe die Nase voll von den ständigen Zugausfällen.", "I’m fed up with the constant train cancellations."),
            CollectionWord("", "auf die lange Bank schieben", "to put something off",
                           "Die Steuererklärung schiebe ich schon seit Wochen auf die lange Bank.",
                           "I’ve been putting off my tax return for weeks."),
            CollectionWord("", "jemandem auf den Keks gehen", "to get on someone’s nerves",
                           "Das ständige Gehupe geht mir auf den Keks.", "The constant honking is getting on my nerves."),
            CollectionWord("", "Schwein haben", "to be lucky",
                           "Da hast du aber Schwein gehabt, der Zug hatte Verspätung!", "You were lucky there, the train was late!"),
            CollectionWord("", "jemandem reinen Wein einschenken", "to tell someone the plain truth",
                           "Irgendwann musst du ihm reinen Wein einschenken.", "Sooner or later you’ll have to tell him the truth."),
            CollectionWord("", "unter vier Augen", "in private",
                           "Können wir das unter vier Augen besprechen?", "Can we discuss this in private?")
        ]
    )

    static let c2Slang = WordCollection(
        id: "c2-umgangssprache", title: "Umgangssprache", subtitle: "Everyday slang", level: .c2,
        category: .everyday, systemImage: "bubble.left.fill",
        words: [
            CollectionWord("die ", "Kohle", "cash (slang)",
                           "Für den Urlaub fehlt mir gerade die Kohle.", "I haven’t got the cash for a holiday right now."),
            CollectionWord("die ", "Bude", "place, pad",
                           "Komm doch heute Abend auf meine Bude.", "Come round to my place tonight."),
            CollectionWord("der ", "Schmarrn", "nonsense (southern)",
                           "Red keinen Schmarrn!", "Don’t talk rubbish!"),
            CollectionWord("der ", "Zoff", "trouble, a row",
                           "Mit den Nachbarn gibt es ständig Zoff.", "There’s constant trouble with the neighbours."),
            CollectionWord("der ", "Kumpel", "mate",
                           "Am Samstag helfe ich einem Kumpel beim Umzug.", "On Saturday I’m helping a mate move house."),
            CollectionWord("", "Bock haben", "to fancy (doing something)",
                           "Hast du Bock auf Kino?", "Do you fancy the cinema?"),
            CollectionWord("", "pennen", "to kip, to sleep",
                           "Ich penne heute bei meinem Bruder.", "I’m crashing at my brother’s tonight."),
            CollectionWord("", "quatschen", "to chat, to natter",
                           "Wir haben bis zwei Uhr nachts gequatscht.", "We chatted until two in the morning."),
            CollectionWord("", "abhauen", "to clear off",
                           "Komm, lass uns abhauen, die Party ist langweilig.", "Come on, let’s get out of here, the party’s boring."),
            CollectionWord("", "blechen", "to cough up (money)",
                           "Für das Parkticket musste ich 40 Euro blechen.", "I had to cough up 40 euros for the parking ticket."),
            CollectionWord("", "malochen", "to slog away",
                           "Er hat dreißig Jahre im Bergwerk malocht.", "He slogged away in the mine for thirty years."),
            CollectionWord("", "meckern", "to moan",
                           "Meine Oma meckert über jedes neue Gebäude.", "My grandma moans about every new building."),
            CollectionWord("", "checken", "to get, to understand",
                           "Hast du gecheckt, was er meinte?", "Did you get what he meant?"),
            CollectionWord("", "chillen", "to chill",
                           "Am Wochenende will ich einfach nur chillen.", "At the weekend I just want to chill."),
            CollectionWord("", "krass", "crazy, wow",
                           "Krass, wie schnell du Deutsch gelernt hast!", "It’s crazy how fast you’ve learned German!")
        ]
    )
}
