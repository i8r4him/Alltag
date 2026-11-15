//
//  ReadingWords.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import NaturalLanguage

/// A word of a text to read: as it is written, without the punctuation
/// around it, and the sentence it is in.
struct ReadingWord: Identifiable, Hashable {
    /// Its place in the whole text, counted from 0.
    let id: Int
    /// As written, with its punctuation: „Mieter,“.
    let written: String
    /// Without the punctuation around it: „Mieter“. Empty for a number, a price or a dash.
    let word: String
    /// The sentence it is in, saved with the word as its example.
    let sentence: String

    /// Whether it can be tapped: a word, not a number or a dash.
    var isWord: Bool { !word.isEmpty }
}

/// One line of a text, split into words.
struct ReadingParagraph: Identifiable, Hashable {
    let id: Int
    let words: [ReadingWord]
    /// Whether an empty line comes before it, so it starts a new block.
    let startsBlock: Bool
}

/// Splits a text into lines and words, each word knowing its sentence. Pure, so it is tested.
enum ReadingWords {
    static func paragraphs(of text: String) -> [ReadingParagraph] {
        var paragraphs: [ReadingParagraph] = []
        var nextID = 0
        var afterEmptyLine = false
        for line in text.split(separator: "\n", omittingEmptySubsequences: false).map(String.init) {
            guard !line.allSatisfy(\.isWhitespace) else {
                afterEmptyLine = true
                continue
            }
            let sentences = sentenceRanges(in: line)
            var words: [ReadingWord] = []
            for piece in line.split(whereSeparator: \.isWhitespace) {
                let range = sentences.first { $0.contains(piece.startIndex) }
                let sentence = range.map { String(line[$0]) } ?? line
                words.append(ReadingWord(id: nextID, written: String(piece), word: clean(piece),
                                         sentence: sentence.trimmingCharacters(in: .whitespaces)))
                nextID += 1
            }
            paragraphs.append(ReadingParagraph(id: paragraphs.count, words: words,
                                               startsBlock: afterEmptyLine && !paragraphs.isEmpty))
            afterEmptyLine = false
        }
        return paragraphs
    }

    /// The word without the punctuation around it, or empty when it has no letters ("10:30", "–").
    static func clean(_ written: some StringProtocol) -> String {
        let word = written.trimmingCharacters(in: .punctuationCharacters.union(.symbols).union(.whitespaces))
        return word.contains(where: \.isLetter) ? word : ""
    }

    private static func sentenceRanges(in line: String) -> [Range<String.Index>] {
        let tokenizer = NLTokenizer(unit: .sentence)
        tokenizer.string = line
        tokenizer.setLanguage(.german)
        return tokenizer.tokens(for: line.startIndex..<line.endIndex)
    }
}

/// What a tapped word means: its dictionary form (a noun with its article),
/// the meaning, a short grammar note and an example.
struct ReadingMeaning: Hashable {
    /// The article with its trailing space ("die "), or empty.
    let article: String
    let word: String
    let meaning: String
    /// For example "noun · pl. Abrechnungen", or empty.
    let grammar: String
    let example: TranslationResult.Example?

    /// The word with its article: "die Nebenkostenabrechnung".
    var display: String { article + word }

    init(article: String = "", word: String, meaning: String, grammar: String = "",
         example: TranslationResult.Example? = nil) {
        self.article = article
        self.word = word
        self.meaning = meaning
        self.grammar = grammar
        self.example = example
    }

    /// From the translation of the tapped word. The server explains the word in
    /// `words`; Apple's translation on the iPhone has only the meaning.
    init(tapped: String, result: TranslationResult) {
        guard let entry = result.words.first, !entry.word.isEmpty else {
            self.init(word: tapped, meaning: result.english, example: result.examples.first)
            return
        }
        let (article, word) = Self.split(entry.word)
        self.init(article: article, word: word, meaning: entry.meaning.isEmpty ? result.english : entry.meaning,
                  grammar: entry.grammar, example: result.examples.first)
    }

    /// "die Wohnung" → ("die ", "Wohnung"). Anything else has no article.
    static func split(_ entry: String) -> (article: String, word: String) {
        for article in ["der ", "die ", "das "] where entry.hasPrefix(article) && entry.count > article.count {
            return (article, String(entry.dropFirst(article.count)))
        }
        return ("", entry)
    }
}
