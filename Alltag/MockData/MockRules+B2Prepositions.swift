//
//  MockRules+B2Prepositions.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The B2 rules, part 4: prepositions of place, time and reason.
extension MockRules {
    static let b2TwoWay = GrammarRule(
        id: "b2-wechselpraepositionen", level: .b2, title: "Two-way prepositions: Wo? or Wohin?",
        place: "Moving house", systemImage: "shippingbox",
        german: "Stell die Kiste bitte in den Keller.",
        english: "Please put the box in the cellar.",
        tiles: [Tile(text: "Stell die Kiste bitte"), Tile(text: "in", role: .key), Tile(text: "den", role: .end), Tile(text: "Keller.")],
        notice: "The box is moving somewhere: Wohin? So „in“ takes the accusative: „in den Keller“.",
        rule: "an, auf, hinter, in, neben, über, unter, vor and zwischen: a movement to a place (Wohin?) takes the accusative, "
            + "a position (Wo?) takes the dative.",
        visual: RuleVisual(
            source: Part(systemImage: "shippingbox.fill", german: "in den Keller", marked: "den", role: "Wohin?", name: "Accusative"),
            target: Part(systemImage: "shippingbox", german: "im Keller", marked: "im", role: "Wo?", name: "Dative"),
            sentence: "Wohin? In den Keller. Wo? Im Keller.",
            columns: ["Wohin? (acc.)", "Wo? (dat.)"],
            rows: [
                Row(label: "der Tisch", cells: ["auf den Tisch", "auf dem Tisch"], marked: [0, 1]),
                Row(label: "die Wand", cells: ["an die Wand", "an der Wand"], marked: [1]),
                Row(label: "das Bett", cells: ["unter das Bett", "unter dem Bett"], marked: [1])
            ]
        ),
        exam: [
            .gap(.easy, "Ich lege das Handy auf ___ Tisch.", hint: "der Tisch", options: ["den", "dem", "der"], answer: 0,
                 why: "Putting it there is a movement: Wohin? The accusative turns der into den."),
            .gap(.medium, "Das Bild hängt schon ___ Wand, und ich hänge den Spiegel ___ Tür.", prompt: "Fill both gaps.",
                 hint: "die Wand · die Tür", options: ["an der … neben die", "an die … neben der", "an der … neben der"], answer: 0,
                 why: "The picture is already there: Wo? an der Wand. The mirror is being put there: Wohin? neben die Tür."),
            .build("Put the milk in the fridge, it's on the table.", prompt: "Build the sentence. Two tiles are left over.",
                   words: ["in den", "Stell", "Tisch", "die Milch", "auf dem", "Kühlschrank,", "in dem", "sie steht", "auf den"],
                   answers: ["Stell die Milch in den Kühlschrank, sie steht auf dem Tisch"],
                   why: "Into the fridge is a movement: in den Kühlschrank. Standing on the table is a position: auf dem Tisch.")
        ]
    )

    static let b2WhereFrom = GrammarRule(
        id: "b2-wo-wohin-woher", level: .b2, title: "Where, where to, where from: in, nach, aus",
        place: "Talking about holidays", systemImage: "airplane",
        german: "Ich komme gerade aus der Schweiz und fahre morgen zu meinen Eltern.",
        english: "I've just come back from Switzerland, and tomorrow I'm going to my parents'.",
        tiles: [Tile(text: "Ich komme gerade"), Tile(text: "aus", role: .key), Tile(text: "der Schweiz und fahre morgen"),
                Tile(text: "zu", role: .key), Tile(text: "meinen Eltern.")],
        notice: "From a country: „aus“. To people: „zu“. Both take the dative.",
        rule: "Towns and most countries: in, nach, aus (in Wien, nach Wien, aus Wien). People: bei, zu, von. "
            + "Countries with an article, like die Schweiz: in der, in die, aus der.",
        visual: RuleVisual(
            source: Part(systemImage: "house.fill", german: "aus Berlin", marked: "aus", role: "Woher?"),
            target: Part(systemImage: "mappin.and.ellipse", german: "nach Wien", marked: "nach", role: "Wohin?"),
            sentence: "Aus Berlin nach Wien.",
            columns: ["Wo?", "Wohin?", "Woher?"],
            rows: [
                Row(label: "a town", cells: ["in Wien", "nach Wien", "aus Wien"]),
                Row(label: "die Schweiz", cells: ["in der Schweiz", "in die Schweiz", "aus der Schweiz"], marked: [1]),
                Row(label: "a person", cells: ["bei Anna", "zu Anna", "von Anna"]),
                Row(label: "home", cells: ["zu Hause", "nach Hause", "von zu Hause"], marked: [0, 1])
            ]
        ),
        exam: [
            .gap(.easy, "Ich fliege morgen ___ Spanien.", options: ["in", "nach", "zu"], answer: 1,
                 why: "A country without an article, as a direction: nach Spanien."),
            .gap(.medium, "Er war gerade ___ Arzt und geht jetzt ___ Hause.", prompt: "Fill both gaps.",
                 options: ["beim … nach", "zum … zu", "beim … zu"], answer: 0,
                 why: "Wo? with a person is bei: beim Arzt. Going home is nach Hause; zu Hause means at home."),
            .build("My friend comes from Turkey and lives in Switzerland.",
                   words: ["in der Schweiz", "kommt", "Meine Freundin", "und wohnt", "aus der Türkei", "von der Türkei"],
                   answers: ["Meine Freundin kommt aus der Türkei und wohnt in der Schweiz"],
                   why: "Where from, for a country: aus. Both countries have an article, so it is aus der Türkei and in der Schweiz.")
        ]
    )

    static let b2Outside = GrammarRule(
        id: "b2-innerhalb", level: .b2, title: "innerhalb, außerhalb, gegenüber, entlang",
        place: "Directions on the phone", systemImage: "map",
        german: "Das Hotel liegt etwas außerhalb der Stadt, gegenüber dem Bahnhof.",
        english: "The hotel is a little outside the town, opposite the station.",
        tiles: [Tile(text: "Das Hotel liegt etwas"), Tile(text: "außerhalb", role: .key), Tile(text: "der Stadt,", role: .end),
                Tile(text: "gegenüber", role: .key), Tile(text: "dem Bahnhof.", role: .end)],
        notice: "„außerhalb“ takes the genitive: „der Stadt“. „gegenüber“ takes the dative: „dem Bahnhof“.",
        rule: "innerhalb, außerhalb, oberhalb and unterhalb take the genitive. gegenüber takes the dative. "
            + "entlang usually follows its noun, with the accusative: die Straße entlang.",
        visual: RuleVisual(
            source: Part(systemImage: "building.2.fill", german: "innerhalb der Stadt", marked: "der", role: "inside", name: "Genitive"),
            target: Part(systemImage: "tree.fill", german: "außerhalb der Stadt", marked: "der", role: "outside", name: "Genitive"),
            sentence: "Innerhalb der Stadt. Außerhalb der Stadt.",
            columns: ["case", "example"],
            rows: [
                Row(label: "innerhalb, außerhalb", cells: ["genitive", "außerhalb des Zentrums"], marked: [0]),
                Row(label: "gegenüber", cells: ["dative", "gegenüber der Kirche"]),
                Row(label: "entlang", cells: ["accusative, after", "den Fluss entlang"])
            ],
            isLinked: false
        ),
        exam: [
            .gap(.easy, "Wir wohnen ___ der Stadt, auf dem Land.", options: ["innerhalb", "außerhalb", "gegenüber"], answer: 1,
                 why: "In the country is outside the town: außerhalb der Stadt."),
            .gap(.medium, "Die Apotheke ist gegenüber ___ Post, innerhalb ___ Einkaufszentrums.", prompt: "Fill both gaps.",
                 hint: "die Post · das Einkaufszentrum", options: ["der … des", "die … dem", "der … dem"], answer: 0,
                 why: "gegenüber + dative: die Post → der Post. innerhalb + genitive: das Einkaufszentrum → des Einkaufszentrums."),
            .build("Walk along the river to the bridge.", prompt: "Build the sentence. Use Sie. One tile is left over.",
                   words: ["entlang", "Gehen Sie", "bis zur Brücke", "dem Fluss", "den Fluss"],
                   answers: ["Gehen Sie den Fluss entlang bis zur Brücke"],
                   why: "After its noun, entlang takes the accusative: den Fluss entlang.")
        ]
    )

    static let b2TimePrepositions = GrammarRule(
        id: "b2-zeitpraepositionen", level: .b2, title: "Time: ab, über, innerhalb, während",
        place: "Letter from an office", systemImage: "envelope",
        german: "Bitte zahlen Sie die Gebühr innerhalb einer Woche.",
        english: "Please pay the fee within a week.",
        tiles: [Tile(text: "Bitte zahlen Sie die Gebühr"), Tile(text: "innerhalb", role: .key), Tile(text: "einer Woche.", role: .end)],
        notice: "„innerhalb“ sets a deadline and takes the genitive: „einer Woche“.",
        rule: "ab: from a point on (ab Montag). über: longer than (über eine Stunde). innerhalb: within. während: during. "
            + "vor: ago (vor zwei Jahren). innerhalb and während take the genitive.",
        visual: RuleVisual(
            source: Part(systemImage: "calendar", german: "ab Montag", marked: "ab", role: "from then on"),
            target: Part(systemImage: "hourglass", german: "innerhalb einer Woche", marked: "innerhalb", role: "before the week ends"),
            sentence: "Ab Montag. Innerhalb einer Woche.",
            columns: ["case", "example"],
            rows: [
                Row(label: "ab", cells: ["dative", "ab nächster Woche"]),
                Row(label: "über", cells: ["accusative", "über eine Stunde"]),
                Row(label: "innerhalb, während", cells: ["genitive", "während des Urlaubs"], marked: [0]),
                Row(label: "vor", cells: ["dative", "vor zwei Jahren"])
            ],
            isLinked: false
        ),
        exam: [
            .gap(.easy, "Die neuen Preise gelten ___ Januar.", options: ["ab", "vor", "während"], answer: 0,
                 why: "ab marks the point from which something starts: ab Januar."),
            .gap(.medium, "___ des Urlaubs war ich krank, und ich habe ___ zwei Wochen gefehlt.", prompt: "Fill both gaps.",
                 options: ["Während … über", "Innerhalb … ab", "Während … ab"], answer: 0,
                 why: "während + genitive: during the holiday. über + a length of time: more than two weeks."),
            .build("I moved to Hamburg two years ago.",
                   words: ["nach Hamburg", "Ich", "gezogen", "vor zwei Jahren", "bin", "vor zwei Jahre"],
                   answers: ["Ich bin vor zwei Jahren nach Hamburg gezogen"],
                   why: "vor + dative: vor zwei Jahren, with the dative plural -n. The time comes before the direction.")
        ]
    )

    static let b2ReasonPrepositions = GrammarRule(
        id: "b2-kausal-praepositionen", level: .b2, title: "Reasons: wegen, aufgrund, trotz, vor, aus",
        place: "Station announcement", systemImage: "tram",
        german: "Aufgrund eines Notarzteinsatzes verzögert sich die Weiterfahrt.",
        english: "Because of a medical emergency, the onward journey is delayed.",
        tiles: [Tile(text: "Aufgrund", role: .key), Tile(text: "eines Notarzteinsatzes", role: .end),
                Tile(text: "verzögert sich die Weiterfahrt.")],
        notice: "„aufgrund“ gives the reason and takes the genitive: „eines Notarzteinsatzes“.",
        rule: "wegen, aufgrund and trotz take the genitive (in speech wegen often takes the dative). "
            + "For feelings, with no article: vor for what you can't help (vor Angst zittern), aus for why you act (aus Liebe).",
        visual: RuleVisual(
            source: Part(systemImage: "cloud.bolt.fill", german: "wegen des Gewitters", marked: "wegen", role: "the reason",
                         name: "Genitive"),
            target: Part(systemImage: "airplane", german: "fällt der Flug aus", role: "what follows"),
            sentence: "Wegen des Gewitters fällt der Flug aus.",
            columns: ["case", "example"],
            rows: [
                Row(label: "wegen, aufgrund", cells: ["genitive", "wegen des Regens"], marked: [0]),
                Row(label: "trotz", cells: ["genitive", "trotz des Regens"], marked: [0]),
                Row(label: "vor", cells: ["no article", "vor Freude weinen"]),
                Row(label: "aus", cells: ["no article", "aus Angst schweigen"])
            ]
        ),
        exam: [
            .gap(.easy, "___ des Streiks fahren heute keine Busse.", options: ["Wegen", "Trotz", "Aus"], answer: 0,
                 why: "The strike is the reason: wegen + genitive."),
            .gap(.medium, "Sie zitterte ___ Kälte, ging aber ___ Neugier trotzdem hinaus.", prompt: "Fill both gaps.",
                 options: ["vor … aus", "aus … vor", "wegen … vor"], answer: 0,
                 why: "vor: something you can't help, like shaking with cold. aus: a reason you act on, like curiosity."),
            .build("Despite the rain, we went for a walk.",
                   words: ["sind", "Trotz", "spazieren gegangen", "des Regens", "wir", "der Regen"],
                   answers: ["Trotz des Regens sind wir spazieren gegangen"],
                   why: "trotz takes the genitive: des Regens. The whole phrase is position 1, so the verb follows.")
        ]
    )

    static let b2PrepositionAfter = GrammarRule(
        id: "b2-praeposition-stellung", level: .b2, title: "Prepositions after the noun: meiner Meinung nach",
        place: "Meeting at work", systemImage: "bubble.left.and.bubble.right",
        german: "Meiner Meinung nach sollten wir das Projekt verschieben.",
        english: "In my opinion we should postpone the project.",
        tiles: [Tile(text: "Meiner Meinung", role: .end), Tile(text: "nach", role: .key),
                Tile(text: "sollten wir das Projekt verschieben.")],
        notice: "In „meiner Meinung nach“ the preposition follows the noun, and it still takes the dative.",
        rule: "A few prepositions can or must follow their noun: nach (meiner Meinung nach), zufolge (dem Bericht zufolge), "
            + "gegenüber (dem Rathaus gegenüber), entlang (den Weg entlang). Some go round it: von heute an.",
        visual: RuleVisual(
            source: Part(systemImage: "text.bubble.fill", german: "nach meiner Meinung", role: "before"),
            target: Part(systemImage: "quote.bubble.fill", german: "meiner Meinung nach", marked: "nach", role: "after"),
            sentence: "Nach meiner Meinung. Meiner Meinung nach.",
            columns: ["case", "example"],
            rows: [
                Row(label: "nach", cells: ["dative", "meiner Meinung nach"], marked: [1]),
                Row(label: "zufolge", cells: ["dative", "dem Bericht zufolge"], marked: [1]),
                Row(label: "gegenüber", cells: ["dative", "dem Rathaus gegenüber"]),
                Row(label: "entlang", cells: ["accusative", "den Weg entlang"]),
                Row(label: "von … an", cells: ["dative", "von heute an"])
            ]
        ),
        exam: [
            .gap(.easy, "Dem Wetterbericht ___ wird es morgen kalt.", options: ["zufolge", "wegen", "trotz"], answer: 0,
                 why: "zufolge follows its noun and means „according to“. It takes the dative: dem Wetterbericht."),
            .gap(.medium, "___ Meinung ___ ist der Film zu lang.", prompt: "Fill both gaps.",
                 options: ["Meiner … nach", "Meine … nach", "Mein … zufolge"], answer: 0,
                 why: "nach after the noun still takes the dative: meiner Meinung nach."),
            .build("From today on I'll cycle to work.",
                   words: ["an", "fahre", "zur Arbeit", "Von heute", "mit dem Rad", "ich", "auf"],
                   answers: ["Von heute an fahre ich mit dem Rad zur Arbeit"],
                   why: "„von … an“ goes round the time: von heute an. It is position 1, so the verb follows, "
                    + "and how comes before where.")
        ]
    )
}
