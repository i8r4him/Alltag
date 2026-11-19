//
//  WebExamples.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// A real German article that suits a level, to try "Read from the web" with:
/// only its link is in the app; the reader loads it like any shared link.
struct WebExample: Identifiable, Sendable {
    /// The article's headline, in German as the site writes it.
    let title: String
    /// "nachrichtenleicht.de"
    let site: String
    let url: URL
    /// What it is about, in English: "Why trains are late in winter".
    let about: LocalizedStringResource

    var id: String { url.absoluteString }
}

/// Example articles by level, each level in its own `WebExamples+<level>.swift`.
/// Prefer pages that stay online: explainers and lessons over the day's news.
enum WebExamples {
    static func examples(for level: Level) -> [WebExample] {
        switch level {
        case .a1: a1
        case .a2: a2
        case .b1: b1
        case .b2: b2
        case .c1: c1
        case .c2: c2
        }
    }
}
