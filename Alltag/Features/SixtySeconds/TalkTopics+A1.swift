//
//  TalkTopics+A1.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 12.11.26.
//

import Foundation

extension TalkTopics {
    /// 60-second topics for A1: the title, a question to get going, and the English meaning.
    static let a1: [TalkTopic] = [
        TalkTopic(.a1, 1, "Meine Familie", "Wer gehört zu deiner Familie?", "My family"),
        TalkTopic(.a1, 2, "Ich stelle mich vor", "Wie heißt du, und woher kommst du?", "Introducing myself"),
        TalkTopic(.a1, 3, "Meine Wohnung", "Wie sieht deine Wohnung aus?", "My flat"),
        TalkTopic(.a1, 4, "Mein Zimmer", "Was gibt es in deinem Zimmer?", "My room"),
        TalkTopic(.a1, 5, "Mein Frühstück", "Was isst und trinkst du am Morgen?", "My breakfast"),
        TalkTopic(.a1, 6, "Mein Lieblingsessen", "Was isst du gern?", "My favourite food"),
        TalkTopic(.a1, 7, "Meine Hobbys", "Was machst du gern in deiner Freizeit?", "My hobbies"),
        TalkTopic(.a1, 8, "Mein Tag", "Was machst du jeden Tag?", "My day"),
        TalkTopic(.a1, 9, "Mein Wochenende", "Was machst du am Wochenende?", "My weekend"),
        TalkTopic(.a1, 10, "Das Wetter heute", "Wie ist das Wetter heute?", "The weather today"),
        TalkTopic(.a1, 11, "Meine Stadt", "Wo wohnst du, und was gibt es dort?", "My town"),
        TalkTopic(.a1, 12, "Mein bester Freund", "Wie heißt dein bester Freund, und wie ist er?", "My best friend"),
        TalkTopic(.a1, 13, "Meine Arbeit", "Was arbeitest du?", "My job"),
        TalkTopic(.a1, 14, "Mein Deutschkurs", "Wann und wo lernst du Deutsch?", "My German course"),
        TalkTopic(.a1, 15, "Im Supermarkt", "Was kaufst du im Supermarkt?", "At the supermarket"),
        TalkTopic(.a1, 16, "Meine Kleidung", "Was trägst du heute?", "My clothes"),
        TalkTopic(.a1, 17, "Meine Lieblingsfarbe", "Welche Farbe magst du, und was hast du in dieser Farbe?", "My favourite colour"),
        TalkTopic(.a1, 18, "Mein Handy", "Was machst du mit deinem Handy?", "My phone"),
        TalkTopic(.a1, 19, "Tiere", "Welche Tiere magst du? Hast du ein Haustier?", "Animals"),
        TalkTopic(.a1, 20, "Mein Geburtstag", "Wann hast du Geburtstag, und was machst du dann?", "My birthday"),
        TalkTopic(.a1, 21, "Meine Eltern", "Wie heißen deine Eltern, und wo wohnen sie?", "My parents"),
        TalkTopic(.a1, 22, "Meine Geschwister", "Hast du Geschwister? Wie alt sind sie?", "My brothers and sisters"),
        TalkTopic(.a1, 23, "Getränke", "Was trinkst du gern?", "Drinks"),
        TalkTopic(.a1, 24, "Obst und Gemüse", "Welches Obst und Gemüse isst du gern?", "Fruit and vegetables"),
        TalkTopic(.a1, 25, "Mein Morgen", "Wann stehst du auf, und was machst du dann?", "My morning"),
        TalkTopic(.a1, 26, "Mein Abend", "Was machst du am Abend?", "My evening"),
        TalkTopic(.a1, 27, "Sport", "Machst du Sport? Welchen?", "Sport"),
        TalkTopic(.a1, 28, "Musik", "Welche Musik hörst du gern?", "Music"),
        TalkTopic(.a1, 29, "Filme und Serien", "Was siehst du gern?", "Films and series"),
        TalkTopic(.a1, 30, "Mein Land", "Woher kommst du, und wie ist dein Land?", "My country"),
        TalkTopic(.a1, 31, "Sprachen", "Welche Sprachen sprichst du?", "Languages"),
        TalkTopic(.a1, 32, "Mein Weg zur Arbeit", "Wie kommst du zur Arbeit oder zum Kurs?", "My way to work"),
        TalkTopic(.a1, 33, "Im Café", "Was bestellst du im Café?", "At the café"),
        TalkTopic(.a1, 34, "Meine Nachbarn", "Wer wohnt neben dir?", "My neighbours"),
        TalkTopic(.a1, 35, "Die Jahreszeiten", "Welche Jahreszeit magst du, und warum?", "The seasons"),
        TalkTopic(.a1, 36, "Mein Lieblingstag", "Welcher Wochentag ist dein Lieblingstag?", "My favourite day of the week"),
        TalkTopic(.a1, 37, "Kochen", "Kochst du gern? Was kochst du?", "Cooking"),
        TalkTopic(.a1, 38, "Einkaufen", "Wo kaufst du ein, und was kaufst du oft?", "Shopping"),
        TalkTopic(.a1, 39, "Mein Lieblingsort", "Wo bist du gern?", "My favourite place"),
        TalkTopic(.a1, 40, "Meine Küche", "Was gibt es in deiner Küche?", "My kitchen"),
        TalkTopic(.a1, 41, "Bus und Bahn", "Fährst du mit dem Bus oder mit der Bahn?", "Bus and train"),
        TalkTopic(.a1, 42, "Im Park", "Was machst du im Park?", "In the park"),
        TalkTopic(.a1, 43, "Mein Urlaub", "Wohin fährst du gern im Urlaub?", "My holiday"),
        TalkTopic(.a1, 44, "Meine Freunde", "Was machst du mit deinen Freunden?", "My friends"),
        TalkTopic(.a1, 45, "Das mag ich nicht", "Was isst oder machst du nicht gern?", "Things I don't like"),
        TalkTopic(.a1, 46, "Mein Computer", "Was machst du am Computer?", "My computer"),
        TalkTopic(.a1, 47, "Bücher", "Liest du gern? Was liest du?", "Books"),
        TalkTopic(.a1, 48, "Mein Lehrer", "Wie ist dein Lehrer oder deine Lehrerin?", "My teacher"),
        TalkTopic(.a1, 49, "Am Sonntag", "Was machst du am Sonntag?", "On Sunday"),
        TalkTopic(.a1, 50, "Das kann ich gut", "Was kannst du gut?", "What I'm good at")
    ]
}
