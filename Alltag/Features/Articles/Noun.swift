//
//  Noun.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 14.11.26.
//

import Foundation

/// der, die or das.
enum Article: String, CaseIterable, Identifiable, Sendable {
    case der, die, das

    var id: String { rawValue }

    /// The article at the start of `text` ("die Apotheke", "Der Tisch"), and the rest.
    static func split(_ text: String) -> (article: Article, rest: String)? {
        let parts = text.trimmingCharacters(in: .whitespacesAndNewlines).split(separator: " ", maxSplits: 1)
        guard parts.count == 2, let article = Article(rawValue: parts[0].lowercased()) else { return nil }
        return (article, String(parts[1]))
    }
}

/// A German noun with its article.
struct Noun: Identifiable, Hashable, Sendable {
    let article: Article
    let word: String
    /// The plural, or "–" when the noun has none in everyday use. Empty when unknown.
    let plural: String
    /// What it means, in English.
    let meaning: String
    /// The level it is taught at; `nil` for the learner's own words and looked-up ones.
    let level: Level?

    var id: String { word }
    var hasPlural: Bool { !plural.isEmpty && plural != "–" }

    /// Short, so the lists stay readable: article, noun, plural, meaning, level.
    init(_ article: Article, _ word: String, _ plural: String, _ meaning: String, _ level: Level? = nil) {
        self.article = article
        self.word = word
        self.plural = plural
        self.meaning = meaning
        self.level = level
    }
}

/// The nouns Alltag teaches: `Nouns+A1.swift` to `Nouns+B2.swift`, 200 in all.
enum Nouns {
    static var all: [Noun] { a1 + a2 + b1 + b2 }

    /// The nouns to practise at `level`: its own and the ones below it, so
    /// earlier words keep coming back. C1 and C2 practise everything.
    static func nouns(upTo level: Level) -> [Noun] {
        all.filter { ($0.level ?? .a1) <= level }
    }

    /// The nouns among the learner's saved words: the ones saved with an article.
    static func saved(in items: [MemoryItem]) -> [Noun] {
        var seen = Set<String>()
        return items.compactMap { item in
            guard item.kind != .mistake, let article = Article(rawValue: item.article.trimmingCharacters(in: .whitespaces).lowercased()),
                  seen.insert(item.word).inserted else { return nil }
            return Noun(article, item.word, "", item.meaning)
        }
    }
}
