//
//  Noun.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 14.11.26.
//

import Foundation

/// der, die or das.
enum Article: String, CaseIterable, Identifiable, Codable, Sendable {
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
struct Noun: Identifiable, Hashable, Codable, Sendable {
    let article: Article
    let word: String
    /// The plural, or "–" when the noun has none in everyday use. Empty when unknown.
    let plural: String
    /// What it means, in English.
    let meaning: String
    /// The level it is taught at; `nil` for the learner's own words and looked-up ones.
    var level: Level?
    var example: String = ""
    var explanation: String = ""

    enum CodingKeys: String, CodingKey { case article, word, plural, meaning, example, explanation }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        article = try values.decode(Article.self, forKey: .article)
        word = try values.decode(String.self, forKey: .word)
        plural = try values.decode(String.self, forKey: .plural)
        meaning = try values.decode(String.self, forKey: .meaning)
        example = try values.decodeIfPresent(String.self, forKey: .example) ?? ""
        explanation = try values.decodeIfPresent(String.self, forKey: .explanation) ?? ""
    }

    var id: String { article.rawValue + "|" + word }
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
