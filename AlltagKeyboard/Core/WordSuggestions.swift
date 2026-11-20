//
//  WordSuggestions.swift
//  AlltagKeyboard
//
//  Created by Ibrahim Abdullah on 20.11.26.
//

import UIKit

/// Offers words for the one being typed.
protocol WordSuggesting {
    func suggestions(for word: String) -> [String]
}

/// Completions and spelling from the German dictionary on the iPhone
/// (`UITextChecker`). Nothing leaves the device.
struct DictionarySuggestions: WordSuggesting {
    private let checker = UITextChecker()
    private let language: String

    init() {
        language = UITextChecker.availableLanguages.first { $0.hasPrefix("de") } ?? "de_DE"
    }

    func suggestions(for word: String) -> [String] {
        guard word.count > 1 else { return [] }
        let range = NSRange(location: 0, length: word.utf16.count)
        let wrong = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: language)
        let guesses = wrong.location == NSNotFound ? [] : checker.guesses(forWordRange: range, in: word, language: language) ?? []
        let completions = checker.completions(forPartialWordRange: range, in: word, language: language) ?? []
        return SuggestionPicker.pick(typed: word, guesses: guesses, completions: completions)
    }
}

/// Chooses the words to show. Apart from the dictionary, so tests can check it.
enum SuggestionPicker {
    static let limit = 3

    /// A misspelt word gets its two best corrections first, then ways to finish it.
    static func pick(typed: String, guesses: [String], completions: [String]) -> [String] {
        let candidates = Array(guesses.prefix(2)) + completions + Array(guesses.dropFirst(2))
        var picked: [String] = []
        for candidate in candidates {
            let word = matchingCapital(of: typed, in: candidate)
            guard word != typed, !picked.contains(word) else { continue }
            picked.append(word)
            if picked.count == limit { break }
        }
        return picked
    }

    /// German nouns start with a capital: a word typed with one keeps it.
    static func matchingCapital(of typed: String, in candidate: String) -> String {
        guard let first = typed.first, first.isUppercase, let head = candidate.first else { return candidate }
        return head.uppercased() + candidate.dropFirst()
    }
}
