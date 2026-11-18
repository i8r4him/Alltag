//
//  SpeechChunks.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import NaturalLanguage

/// Splits a text into the pieces the cloud voice speaks one after another: one sentence each,
/// and a sentence longer than the server takes is split between words.
enum SpeechChunks {
    /// The server's `speak` function takes 300 characters; this leaves room.
    static let limit = 280

    static func split(_ text: String, limit: Int = limit) -> [String] {
        let text = SpeechAudioCache.normalised(text)
        guard !text.isEmpty else { return [] }
        let tokenizer = NLTokenizer(unit: .sentence)
        tokenizer.string = text
        tokenizer.setLanguage(.german)
        var sentences: [String] = []
        tokenizer.enumerateTokens(in: text.startIndex..<text.endIndex) { range, _ in
            let sentence = text[range].trimmingCharacters(in: .whitespaces)
            if !sentence.isEmpty { sentences.append(sentence) }
            return true
        }
        if sentences.isEmpty { sentences = [text] }
        return sentences.flatMap { pack($0, limit: limit) }
    }

    /// Puts whole words together into pieces of at most `limit` characters.
    private static func pack(_ sentence: String, limit: Int) -> [String] {
        guard sentence.count > limit else { return [sentence] }
        var pieces: [String] = []
        var current = ""
        for word in sentence.split(separator: " ") {
            let candidate = current.isEmpty ? String(word) : "\(current) \(word)"
            if candidate.count > limit, !current.isEmpty {
                pieces.append(current)
                current = String(word.prefix(limit))
            } else {
                current = String(candidate.prefix(limit))
            }
        }
        if !current.isEmpty { pieces.append(current) }
        return pieces
    }
}
