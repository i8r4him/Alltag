//
//  MistakeQuestion.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 14.11.26.
//

import Foundation

/// One of the learner's mistakes, ready to be asked about: what they said,
/// the correction, and why.
struct MistakeQuestion: Identifiable, Equatable {
    /// The Memory item's `uuid`.
    let id: UUID
    let said: String
    let correction: String
    /// Shown after the answer.
    let explanation: String
    /// Where it was said, e.g. a scenario's title or "Articles".
    let source: String

    init(item: MemoryItem) {
        id = item.uuid
        said = item.mistakeOriginal
        correction = item.context.isEmpty ? item.word : item.context
        explanation = [item.meaning, item.contextNote].filter { !$0.isEmpty }.joined(separator: ". ")
        source = item.sourceDetail.isEmpty ? String(localized: item.source.title) : item.sourceDetail
    }
}
