//
//  MistakePractice.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import SwiftData

/// Turns the learner's own mistakes into Memory items and practice.
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

    /// A practice session from the learner's saved mistakes, most overdue first,
    /// or `nil` when none have been saved with what was originally said.
    static func activity(in context: ModelContext) -> Activity? {
        let mistake = MemoryKind.mistake.rawValue
        var descriptor = FetchDescriptor<MemoryItem>(
            predicate: #Predicate { $0.kindRaw == mistake && $0.mistakeOriginal != "" },
            sortBy: [SortDescriptor(\.nextReview), SortDescriptor(\.createdAt, order: .reverse)])
        descriptor.fetchLimit = limit
        let items = (try? context.fetch(descriptor)) ?? []
        return activity(from: items)
    }

    /// One "which sounds natural?" question per mistake: the correction against what was said.
    static func activity(from items: [MemoryItem]) -> Activity? {
        guard !items.isEmpty else { return nil }
        let questions = items.map { item in
            // Whole sentence against whole sentence, so the length doesn't give it away.
            let correct = item.context.isEmpty ? item.word : item.context
            // Alternate the position of the right answer so it can't be guessed.
            let correctFirst = correct.count.isMultiple(of: 2)
            return Activity.Question(
                context: item.source == .conversation
                    ? String(localized: "You said in a conversation · \(item.sourceDetail)")
                    : String(localized: "You wrote:"),
                quote: "„\(item.mistakeOriginal)“",
                question: String(localized: "Which sounds natural?"),
                options: correctFirst ? [correct, item.mistakeOriginal] : [item.mistakeOriginal, correct],
                correctIndex: correctFirst ? 0 : 1,
                explanation: "\(item.meaning). \(item.contextNote)"
            )
        }
        return Activity(id: .mistakes, label: String(localized: "FIX YOUR MISTAKES"), tone: .mistake,
                        title: items.count == 1 ? String(localized: "One small fix")
                                                : String(localized: "\(items.count) small fixes"),
                        questions: questions)
    }

    private static func key(_ correction: String, _ original: String) -> String {
        ConversationModel.normalized(correction) + "|" + ConversationModel.normalized(original)
    }
}
