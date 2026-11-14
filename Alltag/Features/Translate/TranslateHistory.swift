//
//  TranslateHistory.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 14.11.26.
//

import Foundation
import Observation

/// A text the learner translated, with everything that came back, so the
/// history can show it again without asking the server.
struct TranslationLookup: Codable, Identifiable, Hashable {
    let input: String
    let result: TranslationResult
    let date: Date

    var id: String { input.lowercased() }

    /// Whether the learner typed German (so the translation is the English side).
    var sourceIsGerman: Bool {
        ConversationModel.normalized(input) == ConversationModel.normalized(result.german)
    }

    /// The other language's side of what was typed.
    var translation: String { sourceIsGerman ? result.english : result.german }
}

/// The recent translations, newest first, each text once. A few kilobytes,
/// so they are kept in `UserDefaults`, not in the database.
@Observable
final class TranslationHistory {
    static let key = "translate.lookups"
    static let limit = 30

    private(set) var lookups: [TranslationLookup]
    @ObservationIgnored private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        lookups = defaults.data(forKey: Self.key)
            .flatMap { try? JSONDecoder().decode([TranslationLookup].self, from: $0) } ?? []
    }

    func remember(_ input: String, result: TranslationResult, date: Date = .now) {
        let lookup = TranslationLookup(input: input, result: result, date: date)
        lookups.removeAll { $0.id == lookup.id }
        lookups.insert(lookup, at: 0)
        lookups = Array(lookups.prefix(Self.limit))
        store()
    }

    func remove(_ lookup: TranslationLookup) {
        lookups.removeAll { $0.id == lookup.id }
        store()
    }

    func clear() {
        lookups = []
        store()
    }

    private func store() {
        defaults.set(try? JSONEncoder().encode(lookups), forKey: Self.key)
    }
}
