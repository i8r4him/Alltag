//
//  WordCollection.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// A ready-made set of words for one everyday place or topic at one level,
/// like "Beim Arzt" at A2. The + on its card adds the words to Memory.
struct WordCollection: Identifiable {
    /// Stable, e.g. "a2-arzt".
    let id: String
    /// The German name, e.g. "Beim Arzt". Memory keeps it as the words' source.
    let title: String
    /// What it is about in the learner's language, e.g. "At the doctor’s".
    let subtitle: LocalizedStringResource
    let level: Level
    let category: CollectionCategory
    let systemImage: String
    /// Empty for a collection whose words aren't written yet: it shows as
    /// "Coming soon" on the page of all collections.
    var words: [CollectionWord] = []

    var isReady: Bool { !words.isEmpty }
}

/// The groups on the page of all collections, in this order.
enum CollectionCategory: CaseIterable, Identifiable {
    case people, everyday, food, home, health, travel, work, paperwork, freeTime

    var id: Self { self }

    var title: LocalizedStringResource {
        switch self {
        case .people: "People"
        case .everyday: "Everyday"
        case .food: "Food and shopping"
        case .home: "Home"
        case .health: "Health"
        case .travel: "Getting around"
        case .work: "Work"
        case .paperwork: "Offices and money"
        case .freeTime: "Free time"
        }
    }
}

/// One word in a collection, with a short real-life sentence.
struct CollectionWord: Identifiable {
    /// The article with its trailing space ("die "), or empty.
    let article: String
    let word: String
    /// English meaning.
    let meaning: String
    /// A short sentence in German.
    let example: String
    /// The sentence in English.
    let exampleMeaning: String

    init(_ article: String, _ word: String, _ meaning: String, _ example: String, _ exampleMeaning: String) {
        self.article = article
        self.word = word
        self.meaning = meaning
        self.example = example
        self.exampleMeaning = exampleMeaning
    }

    var id: String { article + word }
    /// Article and word, e.g. "die Praxis".
    var displayWord: String { article + word }
}

/// The collections Learn offers, from A1's everyday basics to C2's idioms,
/// each level in its own `WordCollections+<level>…` files.
enum WordCollections {
    static let all: [WordCollection] = a1 + a2 + b1 + b2 + c1 + c2

    /// The collections with words.
    static var ready: [WordCollection] { all.filter(\.isReady) }

    /// The collections at `level` in `category`, those with words first.
    static func collections(at level: Level, in category: CollectionCategory) -> [WordCollection] {
        let matching = all.filter { $0.level == level && $0.category == category }
        return matching.filter(\.isReady) + matching.filter { !$0.isReady }
    }

    /// The ready collections, the learner's level first, then the levels
    /// nearest to it, keeping the written order within a level.
    static func ordered(for level: Level) -> [WordCollection] {
        let own = position(of: level)
        return ready.enumerated()
            .sorted { lhs, rhs in
                let left = abs(position(of: lhs.element.level) - own)
                let right = abs(position(of: rhs.element.level) - own)
                return left == right ? lhs.offset < rhs.offset : left < right
            }
            .map(\.element)
    }

    private static func position(of level: Level) -> Int {
        Level.allCases.firstIndex(of: level) ?? 0
    }

    static func collection(id: String) -> WordCollection? {
        all.first { $0.id == id }
    }
}
