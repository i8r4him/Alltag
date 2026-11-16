//
//  MockRules+C1Prepositions.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The C1 rules, part 3: what the small prepositions mean beyond place and
/// time, and the formal ones that name a source, a basis or a reason.
extension MockRules {
    static let c1PlacePrepositions = GrammarRule(
        id: "c1-wechselpraepositionen", level: .c1, title: "vor, über, unter, an, auf: more than places",
        place: "Message from a friend", systemImage: "message",
        german: "Vor Aufregung konnte sie die ganze Nacht nicht schlafen.",
        english: "She was so excited she couldn't sleep all night.",
        tiles: [Tile(text: "Vor", role: .key), Tile(text: "Aufregung", role: .end), Tile(text: "konnte"),
                Tile(text: "sie die ganze Nacht nicht schlafen.")],
        notice: "„vor“ isn't a place here. Before a feeling, it gives the cause of something you can't help. "
            + "No article: vor Aufregung, vor Angst, vor Freude.",
        rule: "Away from places, these prepositions keep a picture: vor + a feeling is the cause, über and unter + a number "
            + "mean more or less than, an die + a number means about, auf says in which way (auf Deutsch).",
        visual: RuleVisual(
            source: Part(systemImage: "face.smiling", german: "vor Freude weinen", marked: "vor", role: "the cause"),
            target: Part(systemImage: "person.3.fill", german: "über 50 Leute", marked: "über", role: "more than"),
            sentence: "Vor Freude weinen. Über 50 Leute.",
            columns: ["means", "example"],
            rows: [
                Row(label: "vor", cells: ["cause: a feeling", "vor Angst zittern"], marked: [1]),
                Row(label: "über", cells: ["more than", "über 50 Gäste"], marked: [1]),
                Row(label: "unter", cells: ["less than, among", "unter 18, unter uns"], marked: [1]),
                Row(label: "an die", cells: ["about", "an die 100 Gäste"], marked: [1]),
                Row(label: "auf", cells: ["in which way", "auf Deutsch"], marked: [1]),
                Row(label: "in", cells: ["a state", "in Eile sein"], marked: [1])
            ],
            isLinked: false
        ),
        exam: [
            .gap(.easy, "Die Kinder schrien ___ Freude.", options: ["vor", "aus", "von"], answer: 0,
                 why: "A reaction you can't help takes vor without an article: vor Freude. "
                    + "aus is for a reason you act on, like aus Liebe helfen."),
            .gap(.medium, "___ die 200 Menschen warteten ___ freiem Himmel.", prompt: "Fill both gaps.",
                 options: ["Über … auf", "An … unter", "An … auf"], answer: 1,
                 why: "an die + a number means about. Out in the open is unter freiem Himmel."),
            .build("The children were shivering with cold in the rain.", prompt: "Build the sentence. Two tiles are left over.",
                   words: ["Die Kinder", "aus Kälte", "zitterten", "im Regen", "unter dem Regen", "vor Kälte"],
                   answers: ["Die Kinder zitterten im Regen vor Kälte", "Die Kinder zitterten vor Kälte im Regen"],
                   why: "Shivering just happens, so the cause takes vor: vor Kälte. In the rain is im Regen.")
        ]
    )

    static let c1PrepositionMeanings = GrammarRule(
        id: "c1-praepositionen-bedeutung", level: .c1, title: "um, bei, aus, nach, zu, mit: other meanings",
        place: "News on the radio", systemImage: "radio",
        german: "Zu meiner Überraschung sind die Mieten um zehn Prozent gestiegen.",
        english: "To my surprise, rents have gone up by ten per cent.",
        tiles: [Tile(text: "Zu", role: .key), Tile(text: "meiner Überraschung"), Tile(text: "sind die Mieten"),
                Tile(text: "um", role: .key), Tile(text: "zehn Prozent"), Tile(text: "gestiegen", role: .end)],
        notice: "„zu meiner Überraschung“ gives your reaction, and „um zehn Prozent“ says by how much. "
            + "Neither is about a place or a time.",
        rule: "um says by how much (um 10 % teurer), bei under which condition (bei Regen), aus out of which motive "
            + "(aus Angst), nach according to whom (meiner Meinung nach), zu with which result (zu meiner Freude), "
            + "mit at what age (mit 18).",
        visual: RuleVisual(
            source: Part(systemImage: "chart.line.uptrend.xyaxis", german: "um 10 % gestiegen", marked: "um",
                         role: "by how much"),
            target: Part(systemImage: "cloud.rain", german: "bei Regen", marked: "bei", role: "under which condition"),
            sentence: "Um zehn Prozent gestiegen. Bei Regen.",
            columns: ["means", "example"],
            rows: [
                Row(label: "um", cells: ["by how much", "um 5 % teurer"], marked: [1]),
                Row(label: "bei", cells: ["a condition", "bei Regen"], marked: [1]),
                Row(label: "aus", cells: ["a motive", "aus Angst"], marked: [1]),
                Row(label: "nach", cells: ["according to", "meiner Meinung\nnach"], marked: [1]),
                Row(label: "zu", cells: ["a result", "zu meiner Freude"], marked: [1]),
                Row(label: "mit", cells: ["an age", "mit 18 Jahren"], marked: [1])
            ],
            isLinked: false
        ),
        exam: [
            .gap(.easy, "Die Miete steigt ___ 50 Euro auf 850 Euro.", options: ["mit", "um", "zu"], answer: 1,
                 why: "um gives the difference: by 50 euros. auf gives the new total: to 850 euros."),
            .gap(.medium, "___ Regen fällt das Konzert aus, und ___ meinem Bedauern gibt es keinen neuen Termin.",
                 prompt: "Fill both gaps.", options: ["Mit … zu", "Bei … nach", "Bei … zu"], answer: 2,
                 why: "bei gives the condition: if it rains. zu + a possessive gives the reaction: to my regret."),
            .build("She lied out of fear, not out of malice.",
                   words: ["Sie hat", "vor Angst", "aus Angst", "gelogen,", "nicht", "aus Bosheit"],
                   answers: ["Sie hat aus Angst gelogen, nicht aus Bosheit"],
                   why: "Lying is something you choose to do, so the motive takes aus: aus Angst. "
                    + "vor Angst is for what fear makes you do without wanting to, like trembling.")
        ]
    )

    static let c1SourcePrepositions = GrammarRule(
        id: "c1-laut-zufolge", level: .c1, title: "laut, zufolge, bezüglich: where it's from, what it's about",
        place: "Weather on the radio", systemImage: "radio",
        german: "Dem Wetterdienst zufolge wird es am Wochenende stürmisch.",
        english: "According to the weather service, it will be stormy at the weekend.",
        tiles: [Tile(text: "Dem Wetterdienst", role: .end), Tile(text: "zufolge", role: .key), Tile(text: "wird es"),
                Tile(text: "am Wochenende stürmisch.")],
        notice: "„zufolge“ comes after its noun, which takes the dative. „laut“ would come before it: laut Wetterdienst.",
        rule: "To name a source or a basis: laut, gemäß and entsprechend (dative), and zufolge after its noun (dative). "
            + "To say what it's about: bezüglich and hinsichtlich (genitive).",
        visual: RuleVisual(
            source: Part(systemImage: "newspaper", german: "laut der Zeitung", marked: "laut", role: "before the noun"),
            target: Part(systemImage: "newspaper.fill", german: "der Zeitung zufolge", marked: "zufolge", role: "after the noun"),
            sentence: "Laut der Zeitung. Der Zeitung zufolge.",
            columns: ["case", "example"],
            rows: [
                Row(label: "laut", cells: ["dative", "laut Polizei"], marked: [0]),
                Row(label: "zufolge", cells: ["dative, after", "dem Bericht zufolge"], marked: [0]),
                Row(label: "gemäß", cells: ["dative", "gemäß Vertrag"], marked: [0]),
                Row(label: "entsprechend", cells: ["dative", "Ihrem Wunsch\nentsprechend"], marked: [0]),
                Row(label: "bezüglich", cells: ["genitive", "bezüglich Ihrer\nAnfrage"], marked: [0]),
                Row(label: "hinsichtlich", cells: ["genitive", "hinsichtlich\nder Kosten"], marked: [0])
            ],
            isLinked: false
        ),
        exam: [
            .gap(.easy, "___ Polizei wurde niemand verletzt.", options: ["Zufolge", "Laut", "Bezüglich"], answer: 1,
                 why: "laut comes before its noun and names the source. zufolge has to follow its noun, "
                    + "and bezüglich means regarding, not according to."),
            .gap(.medium, "___ Ihrer Anfrage teilen wir Ihnen mit, dass die Lieferung ___ Vertrag erfolgt.",
                 prompt: "Fill both gaps.",
                 options: ["Zufolge … laut", "Bezüglich … zufolge", "Bezüglich … gemäß"], answer: 2,
                 why: "bezüglich (genitive) says what the letter is about. gemäß says what the delivery follows: "
                    + "the contract. zufolge would have to come after its noun."),
            .build("According to the study, most people sleep too little.", prompt: "Build the sentence. Two tiles are left over.",
                   words: ["Bezüglich", "Der Studie", "der Studie", "zufolge", "schlafen", "die meisten Menschen", "zu wenig"],
                   answers: ["Der Studie zufolge schlafen die meisten Menschen zu wenig"],
                   why: "zufolge follows its noun in the dative: der Studie zufolge. That phrase is position 1, "
                    + "so the verb comes next.")
        ]
    )

    static let c1MeaningPrepositions = GrammarRule(
        id: "c1-zuliebe-mittels", level: .c1, title: "zuliebe, mittels, anhand: prepositions that say what they mean",
        place: "Talking to a neighbour", systemImage: "house",
        german: "Meiner Gesundheit zuliebe gehe ich jetzt jeden Tag zu Fuß.",
        english: "For the sake of my health, I now walk every day.",
        tiles: [Tile(text: "Meiner Gesundheit", role: .end), Tile(text: "zuliebe", role: .key),
                Tile(text: "gehe ich jetzt jeden Tag zu Fuß.")],
        notice: "„zuliebe“ comes after its noun, in the dative: you do something for the sake of someone or something.",
        rule: "Some prepositions say exactly what they mean: zuliebe (for the sake of) follows a dative. "
            + "mittels (by means of), anhand (on the basis of), anstelle (instead of) and zwecks (for the purpose of) "
            + "take the genitive.",
        visual: RuleVisual(
            source: Part(systemImage: "heart.fill", german: "den Kindern zuliebe", marked: "zuliebe", role: "for whose sake"),
            target: Part(systemImage: "doc.text.magnifyingglass", german: "anhand der Daten", marked: "anhand",
                         role: "on what basis"),
            sentence: "Den Kindern zuliebe. Anhand der Daten.",
            columns: ["means", "case"],
            rows: [
                Row(label: "zuliebe", cells: ["for the sake of", "dative, after"], marked: [0]),
                Row(label: "mittels", cells: ["by means of", "genitive"], marked: [0]),
                Row(label: "anhand", cells: ["on the basis of", "genitive"], marked: [0]),
                Row(label: "anstelle", cells: ["instead of", "genitive"], marked: [0]),
                Row(label: "zwecks", cells: ["for the purpose of", "genitive"], marked: [0])
            ],
            isLinked: false
        ),
        exam: [
            .gap(.easy, "___ eines Fotos konnte die Polizei den Täter finden.", options: ["Zuliebe", "Anhand", "Zwecks"],
                 answer: 1,
                 why: "anhand + genitive: on the basis of something you look at, here a photo."),
            .gap(.medium, "___ zieht die Familie aufs Land.",
                 options: ["Zuliebe den Kindern", "Der Kinder zuliebe", "Den Kindern zuliebe"], answer: 2,
                 why: "zuliebe follows its noun, and the noun takes the dative: den Kindern zuliebe."),
            .build("The door is opened with a chip card.", prompt: "Build the sentence. Two tiles are left over.",
                   words: ["Die Tür", "zuliebe", "wird", "mittels", "eine Chipkarte", "einer Chipkarte", "geöffnet"],
                   answers: ["Die Tür wird mittels einer Chipkarte geöffnet"],
                   why: "mittels is the formal mit, typical of instructions, and takes the genitive: mittels einer Chipkarte.")
        ]
    )
}
