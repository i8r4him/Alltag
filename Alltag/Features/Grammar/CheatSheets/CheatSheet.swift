//
//  CheatSheet.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// A one-page summary of a pattern at one level: a short German label for the
/// tile, a title, and groups of German forms, each with what it means.
struct CheatSheet: Identifiable {
    /// A symbol that means the same thing all through a sheet, e.g. a pin for
    /// "Wo?" (you stay, so dative).
    struct Key {
        let id: String
        let systemImage: String
        /// e.g. "Wo?" or "Dativ".
        let german: String
        let meaning: LocalizedStringResource
    }

    struct Row {
        let german: String
        let meaning: LocalizedStringResource
        /// An everyday symbol for the example, e.g. a bus for „mit dem Bus“.
        var systemImage: String?
        /// The words the pattern is about, in the theme colour, e.g. „mit dem“.
        var marked: String?
        /// The `Key` this example is an instance of.
        var key: String?
    }

    struct Part {
        let title: LocalizedStringResource
        let rows: [Row]
        /// The `Key` the whole part is about.
        var key: String?
        /// The part as a picture, in the look of a rule's picture.
        var picture: RuleVisual?
    }

    let id: String
    let level: Level
    /// The German on the tile, e.g. "Verb 2".
    let label: String
    let title: LocalizedStringResource
    let summary: LocalizedStringResource
    let systemImage: String
    let parts: [Part]
    /// What the symbols on the sheet stand for. Empty when it has none.
    var keys: [Key] = []

    /// The key with `id`, if the sheet has one.
    func key(_ id: String?) -> Key? {
        keys.first { $0.id == id }
    }

    /// The sheets for `level`, in the order they're shown.
    static func sheets(for level: Level) -> [CheatSheet] {
        all.filter { $0.level == level }
    }
}
