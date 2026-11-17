//
//  WordCollections+A2Food.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension WordCollections {
    // A2, food: a restaurant, cooking, shopping online.
    static let a2Restaurant = WordCollection(
        id: "a2-restaurant", title: "Im Restaurant", subtitle: "At a restaurant", level: .a2,
        category: .food, systemImage: "cup.and.saucer.fill",
        words: [
            CollectionWord("das ", "Tagesgericht", "dish of the day",
                           "Was ist heute das Tagesgericht?", "What’s the dish of the day?"),
            CollectionWord("die ", "Bedienung", "waiter, waitress",
                           "Die Bedienung kommt gleich zu Ihnen.", "The waiter will be with you in a moment."),
            CollectionWord("", "reservieren", "to book",
                           "Ich möchte für heute Abend einen Tisch reservieren.", "I’d like to book a table for this evening."),
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
            CollectionWord("die ", "Beilage", "side dish",
                           "Als Beilage gibt es Reis oder Kartoffeln.", "It comes with rice or potatoes on the side."),
            CollectionWord("die ", "Portion", "portion",
                           "Die Portionen sind hier sehr groß.", "The portions here are really big."),
            CollectionWord("", "satt", "full (after eating)",
                           "Danke, ich bin satt.", "Thanks, I’m full."),
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
            CollectionWord("", "schälen", "to peel",
                           "Schäl bitte die Kartoffeln.", "Please peel the potatoes."),
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

    static let a2Online = WordCollection(
        id: "a2-online", title: "Online einkaufen", subtitle: "Shopping online", level: .a2, category: .food, systemImage: "bag.fill",
        words: [
            CollectionWord("der ", "Warenkorb", "basket",
                           "Die Schuhe liegen schon im Warenkorb.", "The shoes are already in the basket."),
            CollectionWord("die ", "Bestellung", "order",
                           "Ihre Bestellung ist unterwegs.", "Your order is on its way."),
            CollectionWord("die ", "Lieferung", "delivery",
                           "Die Lieferung dauert zwei bis drei Tage.", "Delivery takes two to three days."),
            CollectionWord("die ", "Versandkosten", "delivery charge",
                           "Ab 30 Euro gibt es keine Versandkosten.", "There’s no delivery charge on orders over 30 euros."),
            CollectionWord("das ", "Kundenkonto", "customer account",
                           "Man kann auch ohne Kundenkonto bestellen.", "You can order without a customer account too."),
            CollectionWord("die ", "Bewertung", "review",
                           "Die Bewertungen für die Jacke sind sehr gut.", "The reviews for the jacket are very good."),
            CollectionWord("die ", "Rücksendung", "return",
                           "Die Rücksendung ist kostenlos.", "Returns are free."),
            CollectionWord("der ", "Gutschein", "voucher",
                           "Ich habe einen Gutschein über 20 Euro.", "I’ve got a 20-euro voucher."),
            CollectionWord("die ", "Lieferadresse", "delivery address",
                           "Bitte prüfen Sie Ihre Lieferadresse.", "Please check your delivery address."),
            CollectionWord("der ", "Rabatt", "discount",
                           "Heute gibt es zehn Prozent Rabatt.", "There’s ten per cent off today."),
            CollectionWord("", "kostenlos", "free",
                           "Die App ist kostenlos.", "The app is free."),
            CollectionWord("", "liefern", "to deliver",
                           "Das Sofa wird am Freitag geliefert.", "The sofa is being delivered on Friday."),
            CollectionWord("", "stornieren", "to cancel",
                           "Kann ich die Bestellung noch stornieren?", "Can I still cancel the order?"),
            CollectionWord("", "vergleichen", "to compare",
                           "Ich vergleiche die Preise im Internet.", "I compare prices online."),
            CollectionWord("", "per Rechnung zahlen", "to pay on invoice",
                           "Kann ich per Rechnung zahlen?", "Can I pay on invoice?")
        ]
    )
}
