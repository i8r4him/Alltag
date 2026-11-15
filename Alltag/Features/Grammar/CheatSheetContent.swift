//
//  CheatSheetContent.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// One part of a cheat sheet: a short title, one line on the rule, and
/// German examples. In an example, the words between asterisks are the ones
/// the rule is about ("Morgen *fahre* ich nach Berlin.").
struct CheatSheetPart: Identifiable {
    let title: LocalizedStringResource
    let explanation: LocalizedStringResource
    let examples: [String]

    var id: String { examples.joined() }
}

extension GrammarCheatSheet {
    /// One line under the title.
    var intro: LocalizedStringResource {
        switch self {
        case .articles: "Clues to which article a noun takes."
        case .cases: "Each case answers a question, and the article shows which one."
        case .wordOrder: "Where the verb goes decides most of German word order."
        }
    }

    var parts: [CheatSheetPart] {
        switch self {
        case .articles: []
        case .cases: Self.caseParts
        case .wordOrder: Self.wordOrderParts
        }
    }

    private static let caseParts: [CheatSheetPart] = [
        CheatSheetPart(title: "Who or what? Nominative",
                       explanation: "The subject: who or what does something.",
                       examples: ["*Der* Zug kommt um acht.", "*Die* Ärztin ist heute da."]),
        CheatSheetPart(title: "Whom or what? Accusative",
                       explanation: "The direct object. Only der changes: it becomes den.",
                       examples: ["Ich kaufe *den* Fahrschein.", "Ich habe *einen* Termin."]),
        CheatSheetPart(title: "To whom? Dative",
                       explanation: "The person who gets something, and the noun after some prepositions.",
                       examples: ["Ich gebe *dem* Arzt die Karte.", "Kannst du *mir* helfen?"]),
        CheatSheetPart(title: "Always accusative: durch, für, gegen, ohne, um",
                       explanation: "After these five, the accusative follows.",
                       examples: ["Das ist für *den* Kurs.", "Ich bin ohne *meinen* Ausweis da."]),
        CheatSheetPart(title: "Always dative: aus, bei, mit, nach, seit, von, zu",
                       explanation: "After these, the dative follows.",
                       examples: ["Ich fahre mit *dem* Bus.", "Nach *der* Arbeit gehe ich einkaufen.",
                                  "Ich wohne seit *einem* Jahr hier."]),
        CheatSheetPart(title: "Where to, or where? an, auf, in, über, unter, vor, hinter, neben, zwischen",
                       explanation: "Moving to a place takes the accusative. Being in a place takes the dative.",
                       examples: ["Ich lege das Buch auf *den* Tisch.", "Das Buch liegt auf *dem* Tisch.",
                                  "Ich gehe in *die* Stadt.", "Ich bin in *der* Stadt."])
    ]

    private static let wordOrderParts: [CheatSheetPart] = [
        CheatSheetPart(title: "The verb is second",
                       explanation: "In a statement the verb is the second part, whatever comes first.",
                       examples: ["Ich *fahre* morgen nach Berlin.", "Morgen *fahre* ich nach Berlin."]),
        CheatSheetPart(title: "The second verb goes to the end",
                       explanation: "With a modal verb, the perfect or a separable verb, the second part goes last.",
                       examples: ["Ich *muss* heute länger *arbeiten*.", "Wir *haben* den Zug *verpasst*.",
                                  "Der Zug *kommt* um acht *an*."]),
        CheatSheetPart(title: "After weil, dass, wenn, ob: the verb is last",
                       explanation: "In these clauses the verb moves to the very end.",
                       examples: ["Ich bleibe zu Hause, weil ich krank *bin*.",
                                  "Ich weiß nicht, ob der Zug pünktlich *ist*."]),
        CheatSheetPart(title: "Verb meets verb",
                       explanation: "When the sentence starts with a wenn or weil clause, the main verb comes right after the comma.",
                       examples: ["Wenn es regnet, *nehme* ich den Bus."]),
        CheatSheetPart(title: "Questions",
                       explanation: "A yes-or-no question starts with the verb. With a question word, the verb is second.",
                       examples: ["*Kommst* du morgen?", "Wann *kommst* du?"]),
        CheatSheetPart(title: "When, how, where",
                       explanation: "When several details follow the verb, the usual order is when, how, then where.",
                       examples: ["Ich fahre *morgen* *mit dem Zug* *nach Berlin*."])
    ]

    /// The articles by case, for the table on the Cases sheet: masculine,
    /// feminine, neuter and plural.
    static let caseTable: [(name: LocalizedStringResource, articles: [String])] = [
        ("Nominative", ["der", "die", "das", "die"]),
        ("Accusative", ["den", "die", "das", "die"]),
        ("Dative", ["dem", "der", "dem", "den"]),
        ("Genitive", ["des", "der", "des", "der"])
    ]
}

extension CheatSheetPart {
    /// The example split into plain and highlighted runs, in order.
    static func runs(of example: String) -> [(text: String, isHighlighted: Bool)] {
        example.components(separatedBy: "*").enumerated()
            .filter { !$0.element.isEmpty }
            .map { ($0.element, $0.offset.isMultiple(of: 2) == false) }
    }
}
