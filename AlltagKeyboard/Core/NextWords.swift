//
//  NextWords.swift
//  AlltagKeyboard
//
//  Created by Ibrahim Abdullah on 21.11.26.
//

import Foundation

/// What the keyboard has learnt from the learner's own typing. It stays on the iPhone.
struct LearntWords: Codable, Equatable {
    /// For a word, the words written after it and how often.
    var pairs: [String: [String: Int]] = [:]
    /// Words the learner took back from a correction: they are never changed again.
    var kept: Set<String> = []
}

/// Which word tends to follow which: pairs every learner of German writes, and the learner's own.
struct NextWords: Equatable {
    /// The pairs the keyboard starts with; none in tests.
    var seed: [String: [String]] = [:]
    var learnt = LearntWords()

    static let followerLimit = 12
    static let wordLimit = 500
    static let keptLimit = 500

    /// The likeliest words after `word`: the learner's own habits first, then the common ones.
    func after(_ word: String, limit: Int = SuggestionPicker.limit) -> [String] {
        let key = word.lowercased()
        guard !key.isEmpty else { return [] }
        let own = (learnt.pairs[key] ?? [:]).sorted { $0.value > $1.value || ($0.value == $1.value && $0.key < $1.key) }
        let habits = own.filter { $0.value > 1 }.map { $0.key }
        let once = own.filter { $0.value == 1 }.map { $0.key }
        var picked: [String] = []
        for candidate in habits + (seed[key] ?? []) + once
        where !picked.contains(where: { $0.lowercased() == candidate.lowercased() }) {
            picked.append(candidate)
            if picked.count == limit { break }
        }
        return picked
    }

    /// Whether `next` is a word that often comes after `word`.
    func follows(_ word: String, _ next: String) -> Bool {
        let key = word.lowercased()
        let wanted = next.lowercased()
        guard !key.isEmpty else { return false }
        if (seed[key] ?? []).contains(where: { $0.lowercased() == wanted }) { return true }
        return (learnt.pairs[key] ?? [:]).contains { $0.key.lowercased() == wanted && $0.value > 1 }
    }

    mutating func learn(_ word: String, after previous: String) {
        let key = previous.lowercased()
        guard !key.isEmpty, !word.isEmpty, word.count <= 30 else { return }
        var followers = learnt.pairs[key] ?? [:]
        followers[word, default: 0] += 1
        if followers.count > Self.followerLimit,
           let rarest = followers.filter({ $0.key != word }).min(by: { ($0.value, $0.key) < ($1.value, $1.key) }) {
            followers.removeValue(forKey: rarest.key)
        }
        learnt.pairs[key] = followers
        if learnt.pairs.count > Self.wordLimit,
           let rarest = learnt.pairs.filter({ $0.key != key }).min(by: { Self.weight($0) < Self.weight($1) }) {
            learnt.pairs.removeValue(forKey: rarest.key)
        }
    }

    private static func weight(_ entry: (key: String, value: [String: Int])) -> (Int, String) {
        (entry.value.values.reduce(0, +), entry.key)
    }

    /// The learner wants this word as typed.
    mutating func keep(_ word: String) {
        if learnt.kept.count >= Self.keptLimit, let first = learnt.kept.min() { learnt.kept.remove(first) }
        learnt.kept.insert(word.lowercased())
    }

    func keeps(_ word: String) -> Bool {
        learnt.kept.contains(word.lowercased())
    }
}

/// Where the learnt words are kept between two showings of the keyboard.
protocol LearntWordsStore {
    func load() -> LearntWords
    func save(_ words: LearntWords)
}

/// Keeps them in a file in the keyboard's own container, which needs no Full Access.
struct FileLearntWordsStore: LearntWordsStore {
    var url = URL.applicationSupportDirectory.appendingPathComponent("keyboard-words.json")

    func load() -> LearntWords {
        guard let data = try? Data(contentsOf: url),
              let words = try? JSONDecoder().decode(LearntWords.self, from: data) else { return LearntWords() }
        return words
    }

    func save(_ words: LearntWords) {
        try? FileManager.default.createDirectory(at: url.deletingLastPathComponent(), withIntermediateDirectories: true)
        guard let data = try? JSONEncoder().encode(words) else { return }
        try? data.write(to: url, options: [.atomic, .completeFileProtectionUntilFirstUserAuthentication])
    }
}
