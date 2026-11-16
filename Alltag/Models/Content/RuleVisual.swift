//
//  RuleVisual.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// A picture of what a rule means: who does something to what, drawn with
/// symbols, and the few forms that change as a tiny table.
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
        /// The grammar name, e.g. "Accusative".
        let name: String
    }

    /// A row of the table: a label and one cell per column.
    struct Row: Hashable, Sendable {
        let label: String
        let cells: [String]
        /// The cells the rule changes, by column.
        var marked: Set<Int> = []
    }

    let from: Part
    /// The verb on the arrow, e.g. "trinkt".
    let verb: String
    let to: Part
    /// The picture as a sentence, for VoiceOver and under the picture.
    let sentence: String
    let columns: [String]
    let rows: [Row]
}
