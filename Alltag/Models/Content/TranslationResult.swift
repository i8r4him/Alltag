//
//  TranslationResult.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// A translation with the explanations shown in Translate.
struct TranslationResult: Hashable, Sendable, Codable {
    /// A word or phrase from the translation, explained.
    struct WordBreakdown: Hashable, Sendable, Codable {
        let word: String
        /// Grammar note, e.g. "noun · pl. Termine".
        let grammar: String
        let meaning: String
    }

    /// The same sentence in another register.
    struct ToneVariant: Hashable, Sendable, Codable {
        enum Tone: String, CaseIterable, Sendable, Codable {
            case formal = "Formal"
            case neutral = "Neutral"
            case casual = "Casual"
        }

        let tone: Tone
        let german: String
    }

    /// An example sentence using the same words.
    struct Example: Hashable, Sendable, Codable {
        let german: String
        let english: String
    }

    let english: String
    let german: String
    let words: [WordBreakdown]
    let tones: [ToneVariant]
    /// Note on register and usage.
    let note: String
    let examples: [Example]

    /// Whether word-by-word, tones or examples are present.
    var isExplained: Bool { !words.isEmpty || !tones.isEmpty || !examples.isEmpty }
}
