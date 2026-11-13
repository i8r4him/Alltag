//
//  ServerTranslation.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 13.11.26.
//

import Foundation

/// The `translate` function's answer.
struct ServerTranslation: Decodable {
    struct Word: Decodable {
        let word: String
        let grammar: String
        let meaning: String
    }

    struct Tone: Decodable {
        let tone: String
        let german: String
    }

    struct Example: Decodable {
        let german: String
        let other: String
    }

    let german: String
    let other: String
    let note: String
    let words: [Word]
    let tones: [Tone]
    let examples: [Example]
}

extension TranslationResult {
    init(_ server: ServerTranslation) {
        self.init(
            english: server.other,
            german: server.german,
            words: server.words.map { WordBreakdown(word: $0.word, grammar: $0.grammar, meaning: $0.meaning) },
            tones: server.tones.compactMap { tone in
                ToneVariant.Tone.allCases.first { $0.rawValue.lowercased() == tone.tone }
                    .map { ToneVariant(tone: $0, german: tone.german) }
            },
            note: server.note,
            examples: server.examples.map { Example(german: $0.german, english: $0.other) }
        )
    }
}
