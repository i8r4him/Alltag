//
//  WordCollections+A1Shopping.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension WordCollections {
    static let a1Food = WordCollection(
        id: "a1-essen", title: "Essen und Trinken", subtitle: "Food and drink", level: .a1,
        category: .food, systemImage: "fork.knife",
        words: [
            CollectionWord("das ", "Brot", "bread",
                           "Zum Frühstück esse ich Brot mit Käse.", "For breakfast I have bread and cheese."),
            CollectionWord("das ", "Brötchen", "bread roll",
                           "Ich hole schnell Brötchen beim Bäcker.", "I’m just getting some rolls from the baker’s."),
            CollectionWord("der ", "Käse", "cheese",
                           "Der Käse kommt aus der Schweiz.", "The cheese is from Switzerland."),
            CollectionWord("das ", "Ei", "egg",
                           "Ich esse jeden Morgen ein Ei.", "I eat an egg every morning."),
            CollectionWord("das ", "Fleisch", "meat",
                           "Ich esse kein Fleisch.", "I don’t eat meat."),
            CollectionWord("der ", "Fisch", "fish",
                           "Freitags gibt es Fisch.", "There’s fish on Fridays."),
            CollectionWord("das ", "Gemüse", "vegetables",
                           "Kinder, esst auch das Gemüse!", "Kids, eat your vegetables too!"),
            CollectionWord("das ", "Obst", "fruit",
                           "Obst ist gesund.", "Fruit is good for you."),
            CollectionWord("der ", "Apfel", "apple",
                           "Möchtest du einen Apfel?", "Would you like an apple?"),
            CollectionWord("das ", "Wasser", "water",
                           "Ist das Wasser mit Kohlensäure?", "Is the water sparkling?"),
            CollectionWord("der ", "Kaffee", "coffee",
                           "Trinkst du Kaffee mit Milch?", "Do you take milk in your coffee?"),
            CollectionWord("die ", "Milch", "milk",
                           "Wir brauchen noch Milch.", "We still need milk."),
            CollectionWord("der ", "Tee", "tea",
                           "Ich trinke lieber Tee.", "I prefer tea."),
            CollectionWord("der ", "Hunger", "hunger",
                           "Ich habe großen Hunger.", "I’m really hungry."),
            CollectionWord("", "lecker", "tasty, delicious",
                           "Die Suppe ist sehr lecker!", "The soup is really tasty!")
        ]
    )

    static let a1Cafe = WordCollection(
        id: "a1-cafe", title: "Im Café", subtitle: "At the café", level: .a1,
        category: .food, systemImage: "mug.fill",
        words: [
            CollectionWord("die ", "Speisekarte", "menu",
                           "Können wir bitte die Speisekarte haben?", "Could we have the menu, please?"),
            CollectionWord("", "bestellen", "to order",
                           "Möchten Sie schon bestellen?", "Are you ready to order?"),
            CollectionWord("", "ich hätte gern", "I’d like",
                           "Ich hätte gern einen Cappuccino.", "I’d like a cappuccino."),
            CollectionWord("die ", "Tasse", "cup",
                           "Eine Tasse Tee, bitte.", "A cup of tea, please."),
            CollectionWord("das ", "Glas", "glass",
                           "Ein Glas Rotwein, bitte.", "A glass of red wine, please."),
            CollectionWord("der ", "Kuchen", "cake",
                           "Der Kuchen ist hausgemacht.", "The cake is homemade."),
            CollectionWord("der ", "Saft", "juice",
                           "Der Saft ist frisch gepresst.", "The juice is freshly squeezed."),
            CollectionWord("das ", "Frühstück", "breakfast",
                           "Bis wann gibt es Frühstück?", "Until when is breakfast served?"),
            CollectionWord("", "Guten Appetit", "enjoy your meal",
                           "Guten Appetit!", "Enjoy your meal!"),
            CollectionWord("", "frei", "free (not taken)",
                           "Ist der Platz noch frei?", "Is this seat free?"),
            CollectionWord("", "besetzt", "taken",
                           "Tut mir leid, der Platz ist besetzt.", "Sorry, this seat is taken."),
            CollectionWord("die ", "Rechnung", "bill",
                           "Die Rechnung, bitte!", "The bill, please!"),
            CollectionWord("", "zahlen", "to pay",
                           "Wir möchten zahlen, bitte.", "We’d like to pay, please."),
            CollectionWord("", "getrennt", "separately",
                           "Zusammen oder getrennt? — Getrennt, bitte.", "Together or separately? — Separately, please."),
            CollectionWord("das ", "Trinkgeld", "tip",
                           "Wie viel Trinkgeld gibt man in Deutschland?", "How much do you tip in Germany?")
        ]
    )

    static let a1Supermarket = WordCollection(
        id: "a1-supermarkt", title: "Im Supermarkt", subtitle: "At the supermarket", level: .a1,
        category: .food, systemImage: "basket.fill",
        words: [
            CollectionWord("der ", "Einkaufszettel", "shopping list",
                           "Hast du den Einkaufszettel?", "Have you got the shopping list?"),
            CollectionWord("", "brauchen", "to need",
                           "Brauchen wir noch Eier?", "Do we still need eggs?"),
            CollectionWord("", "suchen", "to look for",
                           "Ich suche den Zucker.", "I’m looking for the sugar."),
            CollectionWord("das ", "Regal", "shelf",
                           "Die Nudeln stehen links im Regal.", "The pasta is on the shelf on the left."),
            CollectionWord("das ", "Kilo", "kilo",
                           "Ein Kilo Tomaten, bitte.", "A kilo of tomatoes, please."),
            CollectionWord("die ", "Flasche", "bottle",
                           "Ich nehme eine Flasche Wasser.", "I’ll take a bottle of water."),
            CollectionWord("die ", "Packung", "packet",
                           "Eine Packung Reis kostet einen Euro.", "A packet of rice is one euro."),
            CollectionWord("das ", "Stück", "piece, one",
                           "Was kostet ein Stück?", "How much is one?"),
            CollectionWord("", "kosten", "to cost",
                           "Die Äpfel kosten zwei Euro.", "The apples are two euros."),
            CollectionWord("der ", "Preis", "price",
                           "Der Preis steht auf dem Schild.", "The price is on the label."),
            CollectionWord("der ", "Euro", "euro",
                           "Das macht zwölf Euro.", "That’s twelve euros."),
            CollectionWord("", "teuer", "expensive",
                           "Das ist mir zu teuer.", "That’s too expensive for me."),
            CollectionWord("", "billig", "cheap",
                           "Hier ist das Obst billig.", "Fruit is cheap here."),
            CollectionWord("", "bezahlen", "to pay",
                           "Kann ich mit Karte bezahlen?", "Can I pay by card?"),
            CollectionWord("", "geöffnet", "open",
                           "Der Supermarkt ist bis 22 Uhr geöffnet.", "The supermarket is open until 10 pm.")
        ]
    )

    static let a1Clothes = WordCollection(
        id: "a1-kleidung", title: "Kleidung", subtitle: "Clothes", level: .a1,
        category: .food, systemImage: "tshirt.fill",
        words: [
            CollectionWord("die ", "Kleidung", "clothes",
                           "Wo finde ich Kleidung für Kinder?", "Where can I find children’s clothes?"),
            CollectionWord("die ", "Hose", "trousers",
                           "Die Hose ist zu lang.", "The trousers are too long."),
            CollectionWord("das ", "Hemd", "shirt",
                           "Er trägt ein weißes Hemd.", "He’s wearing a white shirt."),
            CollectionWord("der ", "Pullover", "jumper",
                           "Der Pullover ist schön warm.", "The jumper is nice and warm."),
            CollectionWord("die ", "Jacke", "jacket",
                           "Nimm eine Jacke mit, es ist kalt.", "Take a jacket, it’s cold."),
            CollectionWord("der ", "Mantel", "coat",
                           "Mein Mantel hängt an der Tür.", "My coat is hanging on the door."),
            CollectionWord("das ", "Kleid", "dress",
                           "Das Kleid steht dir gut.", "That dress suits you."),
            CollectionWord("der ", "Rock", "skirt",
                           "Sie trägt einen blauen Rock.", "She’s wearing a blue skirt."),
            CollectionWord("der ", "Schuh", "shoe",
                           "Mir ist der linke Schuh zu klein.", "The left shoe is too small for me."),
            CollectionWord("die ", "Mütze", "woolly hat",
                           "Im Winter trage ich eine Mütze.", "In winter I wear a woolly hat."),
            CollectionWord("", "anziehen", "to put on, to get dressed",
                           "Ich muss mich noch anziehen.", "I still need to get dressed."),
            CollectionWord("", "tragen", "to wear",
                           "Was soll ich heute tragen?", "What should I wear today?"),
            CollectionWord("", "anprobieren", "to try on",
                           "Kann ich die Hose anprobieren?", "Can I try on these trousers?"),
            CollectionWord("", "passen", "to fit",
                           "Die Schuhe passen nicht.", "The shoes don’t fit."),
            CollectionWord("", "schwarz", "black",
                           "Die Jacke gibt es nur in Schwarz.", "The jacket only comes in black.")
        ]
    )
}
