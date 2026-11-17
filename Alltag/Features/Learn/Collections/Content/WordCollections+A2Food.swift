//
//  WordCollections+A2Food.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension WordCollections {
    // A2, food: a restaurant, cooking, clothes.
    static let a2Restaurant = WordCollection(
        id: "a2-restaurant", title: "Im Restaurant", subtitle: "At a restaurant", level: .a2,
        category: .food, systemImage: "cup.and.saucer.fill",
        words: [
            CollectionWord("die ", "Speisekarte", "menu",
                           "Könnten wir bitte die Speisekarte haben?", "Could we have the menu, please?"),
            CollectionWord("die ", "Bedienung", "waiter, waitress",
                           "Die Bedienung kommt gleich zu Ihnen.", "The waiter will be with you in a moment."),
            CollectionWord("der ", "Tisch", "table",
                           "Ich habe einen Tisch für vier Personen reserviert.", "I’ve booked a table for four."),
            CollectionWord("die ", "Vorspeise", "starter",
                           "Als Vorspeise nehme ich die Tomatensuppe.", "I’ll have the tomato soup as a starter."),
            CollectionWord("das ", "Hauptgericht", "main course",
                           "Das Hauptgericht kommt mit Salat und Pommes.", "The main course comes with salad and chips."),
            CollectionWord("die ", "Nachspeise", "dessert",
                           "Habt ihr noch Platz für eine Nachspeise?", "Have you still got room for a dessert?"),
            CollectionWord("das ", "Getränk", "drink",
                           "Die Getränke stehen auf der letzten Seite.", "The drinks are on the last page."),
            CollectionWord("das ", "Leitungswasser", "tap water",
                           "Kann ich ein Glas Leitungswasser haben?", "Can I have a glass of tap water?"),
            CollectionWord("die ", "Rechnung", "bill",
                           "Die Rechnung, bitte!", "The bill, please!"),
            CollectionWord("das ", "Trinkgeld", "tip",
                           "In Deutschland gibt man etwa zehn Prozent Trinkgeld.", "In Germany people tip about ten per cent."),
            CollectionWord("", "bestellen", "to order",
                           "Wir möchten jetzt bestellen.", "We’d like to order now."),
            CollectionWord("", "empfehlen", "to recommend",
                           "Was können Sie heute empfehlen?", "What can you recommend today?"),
            CollectionWord("", "vegetarisch", "vegetarian",
                           "Haben Sie auch etwas Vegetarisches?", "Have you got anything vegetarian?"),
            CollectionWord("", "getrennt zahlen", "to pay separately",
                           "Wir zahlen getrennt, bitte.", "We’re paying separately, please."),
            CollectionWord("", "Stimmt so", "keep the change",
                           "Das macht 18,50. – Hier sind 20, stimmt so.", "That’s 18.50. – Here’s 20, keep the change.")
        ]
    )

    static let a2Cooking = WordCollection(
        id: "a2-kochen", title: "Kochen", subtitle: "Cooking", level: .a2, category: .food, systemImage: "frying.pan.fill",
        words: [
            CollectionWord("der ", "Topf", "pot, saucepan",
                           "Stell den Topf auf den Herd.", "Put the pan on the cooker."),
            CollectionWord("die ", "Pfanne", "frying pan",
                           "Die Zwiebeln kommen zuerst in die Pfanne.", "The onions go into the pan first."),
            CollectionWord("der ", "Herd", "cooker",
                           "Ist der Herd noch an?", "Is the cooker still on?"),
            CollectionWord("der ", "Backofen", "oven",
                           "Den Kuchen 40 Minuten im Backofen backen.", "Bake the cake in the oven for 40 minutes."),
            CollectionWord("das ", "Messer", "knife",
                           "Vorsicht, das Messer ist sehr scharf!", "Careful, the knife is very sharp!"),
            CollectionWord("die ", "Zutat", "ingredient",
                           "Hast du alle Zutaten für die Suppe?", "Have you got all the ingredients for the soup?"),
            CollectionWord("das ", "Gewürz", "spice, seasoning",
                           "Salz und Pfeffer sind die wichtigsten Gewürze.", "Salt and pepper are the most important seasonings."),
            CollectionWord("die ", "Zwiebel", "onion",
                           "Beim Zwiebelschneiden muss ich immer weinen.", "I always cry when I cut onions."),
            CollectionWord("der ", "Löffel", "spoon",
                           "Zwei Löffel Zucker, bitte.", "Two spoonfuls of sugar, please."),
            CollectionWord("", "schneiden", "to cut",
                           "Schneid die Tomaten in kleine Stücke.", "Cut the tomatoes into small pieces."),
            CollectionWord("", "kochen", "to cook, to boil",
                           "Das Wasser kocht schon.", "The water’s already boiling."),
            CollectionWord("", "braten", "to fry",
                           "Ich brate das Fleisch fünf Minuten.", "I fry the meat for five minutes."),
            CollectionWord("", "backen", "to bake",
                           "Am Sonntag backen wir Brot.", "On Sunday we’re baking bread."),
            CollectionWord("", "umrühren", "to stir",
                           "Die Soße immer wieder umrühren.", "Keep stirring the sauce."),
            CollectionWord("", "probieren", "to taste, to try",
                           "Probier mal, ist es salzig genug?", "Have a taste – is it salty enough?")
        ]
    )

    static let a2Clothes = WordCollection(
        id: "a2-kleidung", title: "Kleidung", subtitle: "Clothes", level: .a2, category: .food, systemImage: "tshirt.fill",
        words: [
            CollectionWord("die ", "Hose", "trousers",
                           "Ich suche eine Hose für die Arbeit.", "I’m looking for some trousers for work."),
            CollectionWord("das ", "Hemd", "shirt",
                           "Zum Vorstellungsgespräch trage ich ein Hemd.", "I’m wearing a shirt to the interview."),
            CollectionWord("der ", "Pullover", "jumper",
                           "Zieh einen Pullover an, es ist kalt!", "Put a jumper on, it’s cold!"),
            CollectionWord("die ", "Jacke", "jacket",
                           "Meine Jacke hängt an der Garderobe.", "My jacket is hanging on the coat rack."),
            CollectionWord("der ", "Mantel", "coat",
                           "Im Winter brauchst du einen warmen Mantel.", "In winter you need a warm coat."),
            CollectionWord("das ", "Kleid", "dress",
                           "Sie hat sich für die Hochzeit ein neues Kleid gekauft.", "She’s bought a new dress for the wedding."),
            CollectionWord("der ", "Rock", "skirt",
                           "Sie trägt einen langen Rock.", "She’s wearing a long skirt."),
            CollectionWord("der ", "Schuh", "shoe",
                           "Mein linker Schuh drückt.", "My left shoe pinches."),
            CollectionWord("die ", "Mütze", "woolly hat",
                           "Setz die Mütze auf, es schneit!", "Put your hat on, it’s snowing!"),
            CollectionWord("der ", "Schal", "scarf",
                           "Der Schal ist aus Wolle.", "The scarf is made of wool."),
            CollectionWord("", "sich anziehen", "to get dressed",
                           "Ich ziehe mich schnell an.", "I’ll quickly get dressed."),
            CollectionWord("", "anprobieren", "to try on",
                           "Darf ich das Hemd anprobieren?", "May I try the shirt on?"),
            CollectionWord("", "passen", "to fit",
                           "Die Jeans passt perfekt.", "The jeans fit perfectly."),
            CollectionWord("", "stehen", "to suit",
                           "Die Farbe steht dir gut.", "The colour suits you."),
            CollectionWord("", "eng", "tight",
                           "Die Jacke ist an den Armen zu eng.", "The jacket is too tight in the arms.")
        ]
    )
}
