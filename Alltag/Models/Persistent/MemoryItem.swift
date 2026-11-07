//
//  MemoryItem.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import SwiftData

/// A word or phrase in the learner's Memory.
///
/// CloudKit-ready: every property has a default and nothing is unique, so
/// iCloud sync can be switched on later without a migration.
@Model
final class MemoryItem {
    /// Strength runs from 0 (new) to `maxStrength` (well known).
    static let maxStrength = 4

    /// Stable identifier for App Intents and Spotlight. (`id` is taken by
    /// SwiftData's `PersistentIdentifier`.)
    var uuid: UUID = UUID()
    /// Article including its trailing space ("die "), or empty.
    var article: String = ""
    var word: String = ""
    /// English meaning.
    var meaning: String = ""
    /// Example sentence in German.
    var context: String = ""
    /// English translation of the example, or a note about the learner's mistake.
    var contextNote: String = ""
    /// Human-readable source, e.g. "Spiegel, today".
    var sourceDetail: String = ""
    /// For a mistake: what the learner actually said or wrote. `word` holds the correction.
    var mistakeOriginal: String = ""
    var strength: Int = 0
    var nextReview: Date = Date.now
    var createdAt: Date = Date.now

    // Stored as raw values so they can be used in `#Predicate` filters.
    var kindRaw: String = MemoryKind.fromYourDay.rawValue
    var sourceRaw: String = MemorySource.safari.rawValue

    init(
        article: String = "",
        word: String,
        meaning: String,
        context: String = "",
        contextNote: String = "",
        kind: MemoryKind,
        source: MemorySource,
        sourceDetail: String = "",
        mistakeOriginal: String = "",
        strength: Int = 0,
        nextReview: Date = .now,
        createdAt: Date = .now
    ) {
        self.article = article
        self.word = word
        self.meaning = meaning
        self.context = context
        self.contextNote = contextNote
        self.kindRaw = kind.rawValue
        self.sourceRaw = source.rawValue
        self.sourceDetail = sourceDetail
        self.mistakeOriginal = mistakeOriginal
        self.strength = min(max(strength, 0), Self.maxStrength)
        self.nextReview = nextReview
        self.createdAt = createdAt
    }

    var kind: MemoryKind {
        get { MemoryKind(rawValue: kindRaw) ?? .fromYourDay }
        set { kindRaw = newValue.rawValue }
    }

    var source: MemorySource {
        get { MemorySource(rawValue: sourceRaw) ?? .safari }
        set { sourceRaw = newValue.rawValue }
    }

    /// Whether the item should be reviewed at `date`.
    func isDue(at date: Date = .now) -> Bool {
        nextReview <= date
    }

    /// Article and word, e.g. "die Kündigungsfrist".
    var displayWord: String { article + word }
}
