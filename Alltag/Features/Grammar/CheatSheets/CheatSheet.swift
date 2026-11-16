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
    struct Row {
        let german: String
        let meaning: LocalizedStringResource
    }

    struct Part {
        let title: LocalizedStringResource
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
}
