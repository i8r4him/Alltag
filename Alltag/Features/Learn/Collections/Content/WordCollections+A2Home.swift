//
//  WordCollections+A2Home.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension WordCollections {
    // A2, home: housework and furniture.
    static let a2Housework = WordCollection(
        id: "a2-haushalt", title: "Der Haushalt", subtitle: "Housework", level: .a2, category: .home, systemImage: "washer.fill",
        words: [
            CollectionWord("der ", "Haushalt", "housework, household",
                           "Wir teilen uns den Haushalt.", "We share the housework."),
            CollectionWord("die ", "Waschmaschine", "washing machine",
                           "Die Waschmaschine läuft noch.", "The washing machine is still on."),
            CollectionWord("die ", "Wäsche", "washing, laundry",
                           "Ich hänge die Wäsche auf den Balkon.", "I’m hanging the washing out on the balcony."),
            CollectionWord("der ", "Staubsauger", "vacuum cleaner",
                           "Der Staubsauger steht im Flur.", "The vacuum cleaner is in the hall."),
            CollectionWord("die ", "Spülmaschine", "dishwasher",
                           "Kannst du die Spülmaschine ausräumen?", "Can you empty the dishwasher?"),
            CollectionWord("der ", "Mülleimer", "bin",
                           "Der Mülleimer ist schon wieder voll.", "The bin is full again."),
            CollectionWord("das ", "Geschirr", "dishes",
                           "Wer spült heute das Geschirr?", "Who’s doing the washing-up today?"),
            CollectionWord("", "putzen", "to clean",
                           "Samstags putzen wir die Wohnung.", "On Saturdays we clean the flat."),
            CollectionWord("", "aufräumen", "to tidy up",
                           "Räum bitte dein Zimmer auf!", "Please tidy your room!"),
            CollectionWord("", "staubsaugen", "to vacuum",
                           "Ich muss heute noch staubsaugen.", "I still have to vacuum today."),
            CollectionWord("", "waschen", "to wash",
                           "Ich wasche die Handtücher bei 60 Grad.", "I wash the towels at 60 degrees."),
            CollectionWord("", "bügeln", "to iron",
                           "Ich bügle nie, das ist mir zu viel Arbeit.", "I never iron, it’s too much work for me."),
            CollectionWord("", "trennen", "to separate",
                           "In Deutschland trennt man den Müll.", "In Germany people separate their rubbish."),
            CollectionWord("", "sauber", "clean",
                           "Die Küche ist endlich wieder sauber.", "The kitchen is finally clean again."),
            CollectionWord("", "schmutzig", "dirty",
                           "Deine Schuhe sind ganz schmutzig.", "Your shoes are really dirty.")
        ]
    )

    static let a2Furniture = WordCollection(
        id: "a2-moebel", title: "Möbel", subtitle: "Furniture", level: .a2, category: .home, systemImage: "sofa.fill",
        words: [
            CollectionWord("die ", "Möbel", "furniture",
                           "Die Wohnung ist ohne Möbel.", "The flat is unfurnished."),
            CollectionWord("der ", "Sessel", "armchair",
                           "Opa sitzt am liebsten in seinem Sessel.", "Grandpa likes sitting in his armchair best."),
            CollectionWord("der ", "Kleiderschrank", "wardrobe",
                           "Der Kleiderschrank passt nicht durch die Tür.", "The wardrobe won’t fit through the door."),
            CollectionWord("das ", "Bücherregal", "bookcase",
                           "Die Bücher stehen im Bücherregal.", "The books are in the bookcase."),
            CollectionWord("der ", "Schreibtisch", "desk",
                           "Mein Schreibtisch steht am Fenster.", "My desk is by the window."),
            CollectionWord("das ", "Kissen", "cushion, pillow",
                           "Das Kissen ist mir zu hart.", "The pillow is too hard for me."),
            CollectionWord("die ", "Matratze", "mattress",
                           "Die neue Matratze ist viel bequemer.", "The new mattress is much more comfortable."),
            CollectionWord("die ", "Decke", "blanket",
                           "Nimm dir eine Decke, wenn dir kalt ist.", "Take a blanket if you’re cold."),
            CollectionWord("der ", "Teppich", "rug, carpet",
                           "Der Teppich ist neu, zieh bitte die Schuhe aus.", "The rug is new, please take your shoes off."),
            CollectionWord("der ", "Vorhang", "curtain",
                           "Mach bitte die Vorhänge zu.", "Please close the curtains."),
            CollectionWord("der ", "Spiegel", "mirror",
                           "Der Spiegel hängt im Flur.", "The mirror hangs in the hall."),
            CollectionWord("", "aufbauen", "to put together",
                           "Wir bauen das Regal heute Abend auf.", "We’re putting the shelves together tonight."),
            CollectionWord("", "stellen", "to put (upright)",
                           "Stell den Sessel bitte ans Fenster.", "Please put the armchair by the window."),
            CollectionWord("", "hängen", "to hang",
                           "Wir hängen das Bild über das Sofa.", "We’re hanging the picture above the sofa."),
            CollectionWord("", "gebraucht", "second-hand",
                           "Den Tisch habe ich gebraucht gekauft.", "I bought the table second-hand.")
        ]
    )
}
