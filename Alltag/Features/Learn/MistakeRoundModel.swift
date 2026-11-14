//
//  MistakeRoundModel.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 14.11.26.
//

import Foundation
import Observation
import SwiftData

/// A round of Fix your mistakes: one answer per mistake (the learner turns
/// the card over and says whether they knew the fix). Each answer moves
/// the mistake in Memory at once (stronger and further away, or weaker and
/// back next time), so leaving half-way loses nothing.
@Observable
final class MistakeRoundModel {
    /// How one mistake went, and where that leaves it.
    struct Outcome: Identifiable, Equatable {
        let question: MistakeQuestion
        let wasRight: Bool
        let step: ReviewSchedule.Step

        var id: UUID { question.id }
    }

    let questions: [MistakeQuestion]
    private(set) var index = 0
    /// How the current mistake was answered, if it has been.
    private(set) var wasRight: Bool?
    private(set) var outcomes: [Outcome] = []
    private(set) var isDone = false

    @ObservationIgnored private let items: [UUID: MemoryItem]
    @ObservationIgnored private let now: () -> Date

    init(items: [MemoryItem], now: @escaping () -> Date = { .now }) {
        questions = items.map { MistakeQuestion(item: $0) }
        self.items = Dictionary(items.map { ($0.uuid, $0) }) { first, _ in first }
        self.now = now
    }

    var question: MistakeQuestion { questions[index] }
    var total: Int { questions.count }
    var hasAnswered: Bool { wasRight != nil }
    /// Where the current answer left the mistake.
    var outcome: Outcome? { hasAnswered ? outcomes.last : nil }

    var fixed: [Outcome] { outcomes.filter(\.wasRight) }
    var comingBack: [Outcome] { outcomes.filter { !$0.wasRight } }

    /// A progress segment is filled for answered mistakes.
    func isSegmentFilled(_ segment: Int) -> Bool {
        isDone || segment < index || (segment == index && hasAnswered)
    }

    /// Takes the answer to the current mistake. Only the first one counts.
    func answer(_ right: Bool, in context: ModelContext? = nil) {
        guard wasRight == nil, !isDone, let item = items[question.id] else { return }
        wasRight = right
        outcomes.append(Outcome(question: question, wasRight: right, step: item.review(wasRight: right, at: now())))
        try? context?.save()
    }

    /// Moves to the next mistake, or to the summary after the last one.
    func next() {
        guard hasAnswered else { return }
        if index + 1 < total {
            index += 1
            wasRight = nil
        } else {
            isDone = true
        }
    }
}
