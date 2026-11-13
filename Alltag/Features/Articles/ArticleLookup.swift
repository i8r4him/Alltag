//
//  ArticleLookup.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 14.11.26.
//

import Foundation

/// Finds the article of a word the learner types: in Alltag's nouns and their
/// own saved words first, and with the translation service for anything else.
/// The word may be German ("Apotheke") or in the learner's language ("pharmacy").
enum ArticleLookup {
    enum Answer: Equatable {
        case found(Noun)
        /// The word was understood, but it isn't a noun, so it has no article.
        case notANoun(german: String, meaning: String)
        case unknown
    }

    /// The noun in `nouns` that is `text`, ignoring case and an article typed in front.
    static func local(_ text: String, in nouns: [Noun]) -> Noun? {
        let typed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        let word = (Article.split(typed)?.rest ?? typed).lowercased()
        guard !word.isEmpty else { return nil }
        return nouns.first { $0.word.lowercased() == word } ?? nouns.first { $0.meaning.lowercased() == word }
    }

    static func find(_ text: String, in nouns: [Noun], translation: any TranslationService) async -> Answer {
        if let noun = local(text, in: nouns) { return .found(noun) }
        let typed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !typed.isEmpty, let result = try? await translation.translate(typed) else { return .unknown }
        return answer(from: result)
    }

    /// Reads the article out of a translation: the explained words give a noun with its article.
    static func answer(from result: TranslationResult) -> Answer {
        for word in result.words {
            guard let (article, rest) = Article.split(word.word) else { continue }
            return .found(Noun(article, rest, plural(in: word.grammar), word.meaning))
        }
        if let (article, rest) = Article.split(result.german), !rest.contains(" ") {
            return .found(Noun(article, rest, "", result.english))
        }
        return result.german.isEmpty ? .unknown : .notANoun(german: result.german, meaning: result.english)
    }

    /// "noun · pl. Termine" → "Termine".
    static func plural(in grammar: String) -> String {
        guard let range = grammar.range(of: "pl. ") else { return "" }
        let rest = grammar[range.upperBound...]
        return String(rest.prefix { !"·,;()".contains($0) }).trimmingCharacters(in: .whitespaces)
    }
}
