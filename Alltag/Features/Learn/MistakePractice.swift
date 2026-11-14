//
//  MistakePractice.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import SwiftData
import SwiftUI

/// Turns the learner's own mistakes into Memory items, and finds the ones to fix now.
enum MistakePractice {
    /// Questions per practice session.
    static let limit = 3

    /// A Memory item for a fix the learner got: `said`, corrected.
    /// `nil` unless `feedback` is a fix with a correction that differs from what was said.
    static func item(said: String, feedback: Feedback, scenario: Scenario, at date: Date = .now) -> MemoryItem? {
        item(said: said, feedback: feedback, sourceDetail: scenario.title, at: date)
    }

    /// The same, for a fix that didn't come from a scenario (`sourceDetail` says where it was said).
    static func item(said: String, feedback: Feedback, sourceDetail: String, at date: Date = .now) -> MemoryItem? {
        guard feedback.kind == .fix, let correction = feedback.correction,
              ConversationModel.normalized(correction) != ConversationModel.normalized(said) else { return nil }
        return MemoryItem(word: correction, meaning: feedback.title, context: correction, contextNote: feedback.note,
                          kind: .mistake, source: .conversation, sourceDetail: sourceDetail,
                          mistakeOriginal: said, strength: 0, nextReview: date, createdAt: date)
    }

    /// Saves the items that aren't in Memory yet (same correction and original). Returns how many were added.
    @discardableResult
    static func save(_ items: [MemoryItem], in context: ModelContext) -> Int {
        let mistake = MemoryKind.mistake.rawValue
        let existing = (try? context.fetch(FetchDescriptor<MemoryItem>(predicate: #Predicate { $0.kindRaw == mistake }))) ?? []
        var known = Set(existing.map { key($0.word, $0.mistakeOriginal) })
        var added = 0
        for item in items where known.insert(key(item.word, item.mistakeOriginal)).inserted {
            context.insert(item)
            added += 1
        }
        if added > 0 { try? context.save() }
        return added
    }

    /// The mistakes that can be practised (saved with what was said), the one due first on top.
    static var practisable: FetchDescriptor<MemoryItem> {
        let mistake = MemoryKind.mistake.rawValue
        return FetchDescriptor<MemoryItem>(
            predicate: #Predicate { $0.kindRaw == mistake && $0.mistakeOriginal != "" },
            sortBy: [SortDescriptor(\.nextReview), SortDescriptor(\.createdAt, order: .reverse)])
    }

    /// The mistakes to fix now: due, and not learned yet.
    static func due(_ items: [MemoryItem], at date: Date = .now) -> [MemoryItem] {
        items.filter { !$0.isLearned && $0.isDue(at: date) }
    }

    /// When the next mistake comes back, if any is still on its way to being learned.
    static func nextReturn(_ items: [MemoryItem], at date: Date = .now) -> Date? {
        items.filter { !$0.isLearned && !$0.isDue(at: date) }.map(\.nextReview).min()
    }

    /// The questions of one round: the mistakes due now, most overdue first.
    static func round(in context: ModelContext, at date: Date = .now) -> [MemoryItem] {
        Array(due((try? context.fetch(practisable)) ?? [], at: date).prefix(limit))
    }

    /// Which words of `said` are the mistake: the ones that aren't in `correction`
    /// at that place. A sentence that only lacks a word has none, and neither has one
    /// that was reworded altogether.
    static func wrongWords(said: String, correction: String) -> Set<Int> {
        let words: (String) -> [String] = { text in
            text.split(whereSeparator: \.isWhitespace).map { ConversationModel.normalized(String($0)) }
        }
        let spoken = words(said)
        let difference = spoken.difference(from: words(correction))
        let wrong = Set(difference.insertions.compactMap { change in
            if case .insert(let offset, _, _) = change { offset } else { nil }
        })
        // When most of the sentence differs, the correction is a rewording: marking words would say nothing.
        return wrong.count * 2 > spoken.count ? [] : wrong
    }

    /// What the learner said, in quotes, with the wrong words underlined in coral.
    static func quote(said: String, correction: String) -> Text {
        let wrong = wrongWords(said: said, correction: correction)
        var text = AttributedString("„")
        for (index, word) in said.split(whereSeparator: \.isWhitespace).enumerated() {
            if index > 0 { text += AttributedString(" ") }
            var part = AttributedString(String(word))
            if wrong.contains(index) {
                part.underlineStyle = Text.LineStyle(pattern: .solid, color: .mistake)
            } else if !wrong.isEmpty {
                part.foregroundColor = .secondary
            }
            text += part
        }
        return Text(text + AttributedString("“"))
    }

    private static func key(_ correction: String, _ original: String) -> String {
        ConversationModel.normalized(correction) + "|" + ConversationModel.normalized(original)
    }
}
