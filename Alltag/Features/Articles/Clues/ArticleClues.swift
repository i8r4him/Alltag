//
//  ArticleClues.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The six clues, each in parts in the look of a cheat sheet: a picture, then
/// everyday nouns with a symbol and what they mean.
extension ArticleRule {
    static let all: [ArticleRule] = [genders, feminine, small, compound, plural, senses]

    private typealias Part = CheatSheet.Part

    private static func row(_ symbol: String, _ german: String, _ meaning: LocalizedStringResource,
                            marked: String? = nil) -> CheatSheet.Row {
        CheatSheet.row(symbol, german, meaning, marked: marked)
    }

    private static func side(_ symbol: String, _ german: String, _ role: String, marked: String? = nil) -> RuleVisual.Part {
        CheatSheet.side(symbol, german, role, marked: marked)
    }

    private static func picture(_ source: RuleVisual.Part, _ target: RuleVisual.Part, verb: String = "",
                                sentence: String, linked: Bool = true) -> RuleVisual {
        CheatSheet.picture(source, target, verb: verb, sentence: sentence, linked: linked)
    }

    static let genders = ArticleRule(
        id: "genders", title: "Three genders",
        explanation: """
            Der is masculine, die is feminine and das is neuter. They are grammatical, \
            so they say little about the thing itself.
            """,
        systemImage: "tag.fill",
        parts: [
            Part(title: "Grammar, not meaning", picture: picture(
                side("sun.max.fill", "die Sonne", "feminine", marked: "die"),
                side("moon.fill", "der Mond", "masculine", marked: "der"),
                sentence: "die Sonne, der Mond", linked: false
            ), rows: [
                row("table.furniture.fill", "der Tisch", "the table", marked: "der"),
                row("door.left.hand.closed", "die Tür", "the door", marked: "die"),
                row("window.vertical.closed", "das Fenster", "the window", marked: "das")
            ]),
            Part(title: "On the way to work", picture: picture(
                side("bus.fill", "der Bus", "masculine", marked: "der"),
                side("bicycle", "das Fahrrad", "neuter", marked: "das"),
                sentence: "der Bus, das Fahrrad", linked: false
            ), rows: [
                row("bus.fill", "der Bus", "the bus", marked: "der"),
                row("tram.fill", "die Straßenbahn", "the tram", marked: "die"),
                row("bicycle", "das Fahrrad", "the bike", marked: "das"),
                row("car.fill", "das Auto", "the car", marked: "das")
            ])
        ]
    )

    static let feminine = ArticleRule(
        id: "feminine", title: "Feminine endings",
        explanation: "Nouns ending in -ung, -heit, -keit and -schaft are feminine.",
        systemImage: "text.append",
        parts: [
            Part(title: "-ung", picture: picture(
                side("house.fill", "wohnen", "to live"),
                side("key.fill", "die Wohnung", "a flat", marked: "ung"),
                verb: "+ ung", sentence: "wohnen, die Wohnung"
            ), rows: [
                row("house.fill", "die Wohnung", "the flat", marked: "ung"),
                row("newspaper.fill", "die Zeitung", "the newspaper", marked: "ung"),
                row("doc.text.fill", "die Rechnung", "the bill", marked: "ung"),
                row("pencil", "die Übung", "the exercise", marked: "ung")
            ]),
            Part(title: "-heit and -keit", picture: picture(
                side("heart.fill", "gesund", "healthy"),
                side("cross.case.fill", "die Gesundheit", "health", marked: "heit"),
                verb: "+ heit", sentence: "gesund, die Gesundheit"
            ), rows: [
                row("bird.fill", "die Freiheit", "freedom", marked: "heit"),
                row("heart.fill", "die Gesundheit", "health", marked: "heit"),
                row("lightbulb.fill", "die Möglichkeit", "the possibility", marked: "keit"),
                row("clock.fill", "die Pünktlichkeit", "being on time", marked: "keit")
            ]),
            Part(title: "-schaft", picture: picture(
                side("person.fill", "der Freund", "a friend", marked: "der"),
                side("person.2.fill", "die Freundschaft", "a friendship", marked: "schaft"),
                verb: "+ schaft", sentence: "der Freund, die Freundschaft"
            ), rows: [
                row("person.2.fill", "die Freundschaft", "the friendship", marked: "schaft"),
                row("soccerball", "die Mannschaft", "the team", marked: "schaft"),
                row("building.2.fill", "die Nachbarschaft", "the neighbourhood", marked: "schaft")
            ])
        ]
    )

    static let small = ArticleRule(
        id: "small", title: "Small things: -chen and -lein",
        explanation: "Diminutives ending in -chen or -lein are neuter, even when they are people.",
        systemImage: "textformat.size.smaller",
        parts: [
            Part(title: "-chen makes it das", picture: picture(
                side("cat.fill", "die Katze", "a cat", marked: "die"),
                side("cat.fill", "das Kätzchen", "a kitten", marked: "das"),
                verb: "+ chen", sentence: "die Katze, das Kätzchen"
            ), rows: [
                row("figure.child", "das Mädchen", "the girl", marked: "chen"),
                row("basket.fill", "das Brötchen", "the bread roll", marked: "chen"),
                row("house.lodge.fill", "das Häuschen", "the little house", marked: "chen")
            ]),
            Part(title: "-lein: the same, in songs and stories", picture: picture(
                side("book.closed.fill", "das Buch", "a book"),
                side("book.closed.fill", "das Büchlein", "a little book", marked: "lein"),
                verb: "+ lein", sentence: "das Buch, das Büchlein"
            ), rows: [
                row("book.closed.fill", "das Büchlein", "the little book", marked: "lein"),
                row("bird.fill", "das Vöglein", "the little bird", marked: "lein"),
                row("figure.stand", "das Männlein", "the little man", marked: "lein")
            ])
        ]
    )

    static let compound = ArticleRule(
        id: "compound", title: "The last noun decides",
        explanation: "A compound noun takes the article of its last part.",
        systemImage: "puzzlepiece.fill",
        parts: [
            Part(title: "Haus at the front", picture: picture(
                side("house.fill", "das Haus", "comes first", marked: "das"),
                side("door.left.hand.closed", "die Haustür", "decides", marked: "die"),
                verb: "+ Tür", sentence: "das Haus, die Haustür"
            ), rows: [
                row("door.left.hand.closed", "die Haustür", "the front door", marked: "tür"),
                row("key.fill", "der Hausschlüssel", "the house key", marked: "schlüssel"),
                row("pencil", "die Hausaufgabe", "the homework", marked: "aufgabe")
            ]),
            Part(title: "Haus at the end: always das", picture: picture(
                side("cross.case.fill", "krank", "ill"),
                side("building.2.fill", "das Krankenhaus", "the hospital", marked: "haus"),
                verb: "+ Haus", sentence: "krank, das Krankenhaus"
            ), rows: [
                row("cross.case.fill", "das Krankenhaus", "the hospital", marked: "haus"),
                row("building.columns.fill", "das Rathaus", "the town hall", marked: "haus"),
                row("bag.fill", "das Kaufhaus", "the department store", marked: "haus")
            ]),
            Part(title: "Every day", picture: picture(
                side("cup.and.saucer.fill", "der Kaffee", "comes first", marked: "der"),
                side("mug.fill", "die Kaffeetasse", "decides", marked: "die"),
                verb: "+ Tasse", sentence: "der Kaffee, die Kaffeetasse"
            ), rows: [
                row("mug.fill", "die Kaffeetasse", "the coffee cup", marked: "tasse"),
                row("bus.fill", "die Bushaltestelle", "the bus stop", marked: "stelle"),
                row("train.side.front.car", "der Bahnhof", "the station", marked: "hof")
            ])
        ]
    )

    static let plural = ArticleRule(
        id: "plural", title: "The plural is always die",
        explanation: "Every plural takes die, so it doesn't tell you the singular's article.",
        systemImage: "square.stack.fill",
        parts: [
            Part(title: "One or many", picture: picture(
                side("person.fill", "der Mann", "one", marked: "der"),
                side("person.3.fill", "die Männer", "many", marked: "die"),
                sentence: "der Mann, die Männer"
            ), rows: [
                row("table.furniture.fill", "der Tisch → die Tische", "table, tables", marked: "die"),
                row("figure.2.and.child.holdinghands", "das Kind → die Kinder", "child, children", marked: "die"),
                row("books.vertical.fill", "das Buch → die Bücher", "book, books", marked: "die"),
                row("car.fill", "das Auto → die Autos", "car, cars", marked: "die")
            ]),
            Part(title: "The plural hides the singular", picture: picture(
                side("books.vertical.fill", "die Bücher", "many", marked: "die"),
                side("book.closed.fill", "das Buch", "learn this one", marked: "das"),
                sentence: "die Bücher, das Buch"
            ), rows: [
                row("key.fill", "die Schlüssel → der Schlüssel", "keys, one key", marked: "der"),
                row("basket.fill", "die Brötchen → das Brötchen", "rolls, one roll", marked: "das"),
                row("cup.and.saucer.fill", "die Tassen → die Tasse", "cups, one cup", marked: "die")
            ])
        ]
    )

    static let senses = ArticleRule(
        id: "senses", title: "Some words have two",
        explanation: "The article can change with the meaning. Look the word up to see each meaning on its own.",
        systemImage: "arrow.left.arrow.right",
        parts: [
            Part(title: "Same word, two things", picture: picture(
                side("mountain.2.fill", "der See", "a lake", marked: "der"),
                side("water.waves", "die See", "the sea", marked: "die"),
                sentence: "der See, die See", linked: false
            ), rows: [
                row("mountain.2.fill", "der See", "the lake", marked: "der"),
                row("water.waves", "die See", "the sea", marked: "die"),
                row("briefcase.fill", "der Leiter", "the manager", marked: "der"),
                row("figure.stairs", "die Leiter", "the ladder", marked: "die"),
                row("steeringwheel", "das Steuer", "the steering wheel", marked: "das"),
                row("banknote.fill", "die Steuer", "the tax", marked: "die")
            ]),
            Part(title: "Even three", picture: picture(
                side("guitars.fill", "die Band", "a band", marked: "die"),
                side("gift.fill", "das Band", "a ribbon", marked: "das"),
                sentence: "die Band, das Band", linked: false
            ), rows: [
                row("guitars.fill", "die Band", "the band", marked: "die"),
                row("gift.fill", "das Band", "the ribbon", marked: "das"),
                row("books.vertical.fill", "der Band", "the volume of a book series", marked: "der")
            ])
        ]
    )
}
