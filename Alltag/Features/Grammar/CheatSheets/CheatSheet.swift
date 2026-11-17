//
//  CheatSheet.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// A one-page summary of a pattern at one level: a short German label for the
/// tile, a title, and parts that each open with a picture and go on with
/// everyday examples, each with a symbol and what it means.
struct CheatSheet: Identifiable {
    struct Row {
        /// An everyday symbol for the example, e.g. a bus for „mit dem Bus“.
        let systemImage: String
        let german: String
        let meaning: LocalizedStringResource
        /// The words the pattern is about, in the theme colour, e.g. „mit dem“.
        /// The last match is marked. Without a mark the whole line is.
        var marked: String?
    }

    struct Part {
        let title: LocalizedStringResource
        /// The part as a picture, in the look of a rule's picture.
        let picture: RuleVisual
        let rows: [Row]
    }

    let id: String
    let level: Level
    /// The German on the tile, e.g. "Verb 2".
    let label: String
    let title: LocalizedStringResource
    let summary: LocalizedStringResource
    let systemImage: String
    let parts: [Part]

    /// The sheets for `level`, in the order they're shown.
    static func sheets(for level: Level) -> [CheatSheet] {
        all.filter { $0.level == level }
    }

    static func row(_ symbol: String, _ german: String, _ meaning: LocalizedStringResource, marked: String? = nil) -> Row {
        Row(systemImage: symbol, german: german, meaning: meaning, marked: marked)
    }

    /// One side of a part's picture: a symbol, the German under it and its role.
    static func side(_ symbol: String, _ german: String, _ role: String,
                     marked: String? = nil, name: String = "") -> RuleVisual.Part {
        RuleVisual.Part(systemImage: symbol, german: german, marked: marked, role: role, name: name)
    }

    /// A part's picture: two sides, with an arrow (and `verb` on it) from one
    /// to the other unless they only stand side by side.
    static func picture(_ source: RuleVisual.Part, _ target: RuleVisual.Part, verb: String = "",
                        sentence: String, linked: Bool = true) -> RuleVisual {
        RuleVisual(source: source, verb: verb, target: target, sentence: sentence, columns: [], rows: [], isLinked: linked)
    }
}
