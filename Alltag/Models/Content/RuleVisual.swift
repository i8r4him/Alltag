//
//  RuleVisual.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// A picture of what a rule means: two sides drawn with symbols (who does
/// something to what, before and after, one and several), and the few forms
/// that change as a tiny table.
struct RuleVisual: Hashable, Sendable {
    /// One side of the picture: a symbol, the German under it, and its role.
    struct Part: Hashable, Sendable {
        let systemImage: String
        /// e.g. "den Kaffee".
        let german: String
        /// The word in `german` the rule changes, e.g. "den".
        var marked: String?
        /// The part's role in plain words, e.g. "What?".
        let role: String
        /// The grammar name, e.g. "Accusative". Empty when it has none.
        var name = ""
    }

    /// A row of the table: a label and one cell per column.
    struct Row: Hashable, Sendable {
        let label: String
        let cells: [String]
        /// The cells the rule changes, by column.
        var marked: Set<Int> = []
    }

    let source: Part
    /// The word on the arrow, e.g. "trinkt". Empty for an arrow alone.
    var verb = ""
    let target: Part
    /// The picture as a sentence, for VoiceOver.
    let sentence: String
    let columns: [String]
    let rows: [Row]
    /// Whether an arrow leads from the first side to the second. Off for two
    /// sides that stand next to each other, like „um 9 Uhr“ and „am Montag“.
    var isLinked = true
}
