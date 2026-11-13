//
//  ConversationModel+History.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 12.11.26.
//

import Foundation
import SwiftData

extension ConversationModel {
    /// Saves the conversation, once: as practice, so the streak and the minutes
    /// count it (the time from the learner's first tap to the end), and as a
    /// copy the learner can reread from Learn. Nothing is saved when the
    /// learner didn't say anything.
    func recordPractice(in context: ModelContext, now: Date = .now) {
        guard !hasRecordedPractice, let startedAt, turnCount > 0 else { return }
        hasRecordedPractice = true
        let seconds = Int((endedAt ?? now).timeIntervalSince(startedAt).rounded())
        context.insert(PracticeSession(kind: .conversation, secondsSpoken: seconds, date: startedAt))
        let record = SessionRecord(kind: .conversation, title: scenario.title, secondsSpoken: seconds,
                                   lines: sessionLines, date: startedAt)
        context.insert(record)
        sessionRecord = record
    }

    /// A live conversation is checked after it ends, so its feedback reaches the saved copy late.
    func updateHistory() {
        sessionRecord?.lines = sessionLines
    }

    private var sessionLines: [SessionLine] {
        messages.filter { !$0.line.german.isEmpty }.map { SessionLine($0.line) }
    }
}
