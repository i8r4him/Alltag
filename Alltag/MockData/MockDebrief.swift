//
//  MockDebrief.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The prototype's debrief sample (`DB`).
enum MockDebrief {
    static let bakery = Debrief(
        event: "Lunch at the bakery",
        time: "12:40",
        sampleInput: "I wanted to ask if the bread has nuts in it, because I'm allergic — but I froze.",
        phrases: [
            Debrief.Example(german: "Sind da Nüsse drin?", english: "Are there nuts in it?"),
            Debrief.Example(german: "Ich bin allergisch gegen Nüsse.", english: "I'm allergic to nuts.")
        ],
        grammarTip: "allergisch gegen + accusative. „Nüsse“ is the plural of „die Nuss“.",
        phrasebookPlace: "At the bakery",
        phrasebookSymbol: "birthday.cake"
    )
}
