//
//  KeyboardSupport.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 20.11.26.
//

import Foundation
@testable import Alltag

/// A text field for the keyboard tests: the text before and after the cursor.
@MainActor
final class FakeDocument: TextDocument {
    var before: String
    var after = ""

    init(_ before: String = "") {
        self.before = before
    }

    var textBeforeCursor: String { before }

    var textAfterCursor: String { after }

    func insert(_ text: String) {
        before += text
    }

    func deleteBackward() {
        if !before.isEmpty { before.removeLast() }
    }

    func moveCursor(by offset: Int) {
        if offset < 0 {
            let count = min(-offset, before.count)
            after = String(before.suffix(count)) + after
            before.removeLast(count)
        } else {
            let count = min(offset, after.count)
            before += after.prefix(count)
            after.removeFirst(count)
        }
    }
}

/// Offers fixed words, so no test asks the dictionary on the device.
@MainActor
struct FixedWords: WordSuggesting {
    let words: [String: [String]]

    func suggestions(for word: String) -> [String] {
        words[word] ?? []
    }
}

/// A dictionary of fixed words, so no test asks the one on the device. Like the German one,
/// it takes a word written small with a capital too, and a noun only with its capital.
@MainActor
struct FixedDictionary: WordChecking {
    let words: Set<String>
    /// Words only another language knows.
    var others: Set<String> = []
    /// Words the dictionary takes without thinking of them: they are never among its guesses.
    var madeUp: Set<String> = []

    init(_ words: String) {
        self.words = Set(words.split(whereSeparator: \.isWhitespace).map(String.init))
    }

    func isForeignWord(_ word: String) -> Bool {
        others.contains(word)
    }

    func isWord(_ word: String) -> Bool {
        if words.contains(word) || madeUp.contains(word) { return true }
        guard let first = word.first, first.isUppercase else { return false }
        return words.contains(first.lowercased() + word.dropFirst())
    }

    /// The words one or two changed letters away, the nearest first.
    func guesses(for word: String) -> [String] {
        let typed = Array(word.lowercased())
        var near: [(word: String, distance: Int)] = []
        for candidate in words {
            let distance = Self.distance(typed, Array(candidate.lowercased()))
            if distance <= 2 { near.append((candidate, distance)) }
        }
        near.sort { ($0.distance, $0.word) < ($1.distance, $1.word) }
        return near.map { $0.word }
    }

    /// How many letters have to change, come or go to make one word of the other.
    static func distance(_ first: [Character], _ second: [Character]) -> Int {
        var row = Array(0...second.count)
        for (index, letter) in first.enumerated() {
            var next = [index + 1]
            for (other, character) in second.enumerated() {
                next.append(min(row[other] + (letter == character ? 0 : 1), row[other + 1] + 1, next[other] + 1))
            }
            row = next
        }
        return row[second.count]
    }
}
