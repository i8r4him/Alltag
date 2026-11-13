//
//  ArticleTrainer.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 14.11.26.
//

import Foundation
import Observation
import SwiftData

/// A round of the der, die, das trainer: a noun appears, the learner picks its
/// article. A noun answered wrongly comes back later in the same round, and
/// first in the next rounds until it is answered right.
@Observable
final class ArticleTrainer {
    /// Nouns in a round, before the ones that come back.
    static let roundSize = 10
    /// Where the nouns still to learn are kept between rounds.
    static let missedKey = "articles.missed"

    private(set) var queue: [Noun]
    private(set) var index = 0
    /// The article picked for the noun on screen, until Next.
    private(set) var picked: Article?
    /// Nouns answered right the first time they came up.
    private(set) var rightFirstTime = 0
    /// Nouns answered wrongly at least once this round, in order.
    private(set) var missed: [Noun] = []
    private let asked: Int
    private let defaults: UserDefaults
    @ObservationIgnored private var hasRecorded = false

    /// Starts a round from `nouns`: the ones missed before come first, the rest are drawn at random.
    init(nouns: [Noun], defaults: UserDefaults = .standard, using generator: inout some RandomNumberGenerator) {
        self.defaults = defaults
        let stored = Set(defaults.stringArray(forKey: Self.missedKey) ?? [])
        let earlier = nouns.filter { stored.contains($0.id) }.shuffled(using: &generator).prefix(Self.roundSize / 2)
        let fresh = nouns.filter { !earlier.contains($0) }.shuffled(using: &generator).prefix(Self.roundSize - earlier.count)
        let round = Array(earlier) + Array(fresh)
        queue = round
        asked = round.count
    }

    var current: Noun? { queue.indices.contains(index) ? queue[index] : nil }
    var isDone: Bool { index >= queue.count }
    var isRight: Bool? { picked.map { $0 == current?.article } }
    /// How many nouns the round asks about, without the ones that come back.
    var total: Int { asked }
    /// How far the round is, 0…1.
    var progress: Double { queue.isEmpty ? 1 : Double(index) / Double(queue.count) }

    func pick(_ article: Article) {
        guard picked == nil, let noun = current else { return }
        picked = article
        var stored = Set(defaults.stringArray(forKey: Self.missedKey) ?? [])
        if article == noun.article {
            if !missed.contains(noun) { rightFirstTime += 1 }
            stored.remove(noun.id)
        } else {
            stored.insert(noun.id)
            if !missed.contains(noun) {
                missed.append(noun)
                // Once more before the round ends.
                queue.append(noun)
            }
        }
        defaults.set(Array(stored).sorted(), forKey: Self.missedKey)
    }

    func next() {
        guard picked != nil else { return }
        picked = nil
        index += 1
    }

    /// A finished round counts as practice for the streak, once.
    func recordPractice(in context: ModelContext, now: Date = .now) {
        guard isDone, asked > 0, !hasRecorded else { return }
        hasRecorded = true
        context.insert(PracticeSession(kind: .review, date: now))
        try? context.save()
    }
}
