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

/// Says which words exist, for the auto-correction.
protocol WordChecking {
    /// A German word, written as it should be.
    func isWord(_ word: String) -> Bool
    /// A word to leave alone though it isn't German: another language's, or one the iPhone was taught.
    func isForeignWord(_ word: String) -> Bool
    /// The dictionary's own corrections of a misspelt word, the best first.
    func guesses(for word: String) -> [String]
}

extension WordChecking {
    func isForeignWord(_ word: String) -> Bool { false }
}

/// Completions and spelling from the German dictionary on the iPhone
/// (`UITextChecker`). Nothing leaves the device.
struct DictionarySuggestions: WordSuggesting, WordChecking {
    /// What the dictionary said before: asking it takes long next to a key press.
    private final class Memory {
        var german: [String: Bool] = [:]
        var foreign: [String: Bool] = [:]
    }

    private let checker = UITextChecker()
    private let memory = Memory()
    private let language: String
    /// Learners also type in English ("How do I say …?"); its words are not German mistakes.
    private let english: String?

    init() {
        let languages = UITextChecker.availableLanguages
        language = languages.first { $0.hasPrefix("de") } ?? "de_DE"
        english = languages.first { $0.hasPrefix("en") }
    }

    func suggestions(for word: String) -> [String] {
        guard word.count > 1 else { return [] }
        let range = NSRange(location: 0, length: word.utf16.count)
        let corrections = isSpelt(word, in: language) ? [] : self.guesses(for: word)
        let completions = checker.completions(forPartialWordRange: range, in: word, language: language) ?? []
        return SuggestionPicker.pick(typed: word, guesses: corrections, completions: completions)
    }

    func isWord(_ word: String) -> Bool {
        if let known = memory.german[word] { return known }
        let isKnown = isSpelt(word, in: language)
        if memory.german.count > 800 { memory.german.removeAll(keepingCapacity: true) }
        memory.german[word] = isKnown
        return isKnown
    }

    func isForeignWord(_ word: String) -> Bool {
        if let known = memory.foreign[word] { return known }
        let isKnown = UITextChecker.hasLearnedWord(word) || (english.map { isSpelt(word, in: $0) } ?? false)
        if memory.foreign.count > 800 { memory.foreign.removeAll(keepingCapacity: true) }
        memory.foreign[word] = isKnown
        return isKnown
    }

    func guesses(for word: String) -> [String] {
        let range = NSRange(location: 0, length: word.utf16.count)
        return checker.guesses(forWordRange: range, in: word, language: language) ?? []
    }

    private func isSpelt(_ word: String, in language: String) -> Bool {
        let range = NSRange(location: 0, length: word.utf16.count)
        let wrong = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: language)
        return wrong.location == NSNotFound
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
