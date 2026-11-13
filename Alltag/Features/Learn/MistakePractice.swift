//
//  MistakePractice.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import SwiftData
import SwiftUI

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
