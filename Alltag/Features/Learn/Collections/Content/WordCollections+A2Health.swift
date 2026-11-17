//
//  WordCollections+A2Health.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

extension WordCollections {
    // A2, health: emergencies.
    static let a2Emergencies = WordCollection(
        id: "a2-notfall", title: "Im Notfall", subtitle: "Emergencies", level: .a2, category: .health, systemImage: "cross.case.fill",
        words: [
            CollectionWord("der ", "Notruf", "emergency number",
                           "Der Notruf in Deutschland ist 112.", "The emergency number in Germany is 112."),
            CollectionWord("der ", "Krankenwagen", "ambulance",
                           "Rufen Sie sofort einen Krankenwagen!", "Call an ambulance at once!"),
            CollectionWord("die ", "Polizei", "police",
                           "Die Polizei erreichen Sie unter 110.", "You can reach the police on 110."),
            CollectionWord("die ", "Feuerwehr", "fire brigade",
                           "Die Feuerwehr war in fünf Minuten da.", "The fire brigade was there in five minutes."),
            CollectionWord("der ", "Unfall", "accident",
                           "An der Kreuzung ist ein Unfall passiert.", "There’s been an accident at the crossroads."),
            CollectionWord("die ", "Verletzung", "injury",
                           "Die Verletzung ist zum Glück nicht schlimm.", "Luckily the injury isn’t serious."),
            CollectionWord("das ", "Krankenhaus", "hospital",
                           "Sie liegt seit Dienstag im Krankenhaus.", "She’s been in hospital since Tuesday."),
            CollectionWord("die ", "Notaufnahme", "A&E",
                           "In der Notaufnahme mussten wir drei Stunden warten.", "We had to wait three hours in A&E."),
            CollectionWord("der ", "Notarzt", "emergency doctor",
                           "Der Notarzt ist gleich da.", "The emergency doctor will be here any minute."),
            CollectionWord("der ", "Bereitschaftsdienst", "out-of-hours doctor service",
                           "Am Wochenende erreichen Sie den Bereitschaftsdienst unter 116 117.",
                           "At the weekend you can reach the out-of-hours service on 116 117."),
            CollectionWord("das ", "Feuer", "fire",
                           "Feuer! Alle raus aus dem Haus!", "Fire! Everybody out of the building!"),
            CollectionWord("die ", "Hilfe", "help",
                           "Hilfe! Kann mir jemand helfen?", "Help! Can anyone help me?"),
            CollectionWord("", "verletzt", "injured, hurt",
                           "Ist jemand verletzt?", "Is anyone hurt?"),
            CollectionWord("", "bluten", "to bleed",
                           "Die Wunde blutet stark.", "The wound is bleeding heavily."),
            CollectionWord("", "bewusstlos", "unconscious",
                           "Der Mann ist bewusstlos, aber er atmet.", "The man is unconscious, but he’s breathing.")
        ]
    )
}
