//
//  RuleModel.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import Observation
import SwiftData

/// The "Try it" word-order task: tap tiles into order, check, mark as solved.
@Observable
final class RuleModel {
    enum Result: Equatable {
        case right
        case wrong
    }

    let rule: GrammarRule
    /// Indices into `rule.taskWords`, in the order the learner placed them.
    private(set) var placed: [Int] = []
    private(set) var result: Result?

    init(rule: GrammarRule) {
        self.rule = rule
    }

    var words: [String] { rule.taskWords }
    var placedWords: [String] { placed.map { words[$0] } }
    var canCheck: Bool { !placed.isEmpty }

    func isUsed(_ index: Int) -> Bool { placed.contains(index) }

    /// Moves a word from the bank into the answer.
    func place(_ index: Int) {
        guard words.indices.contains(index), !isUsed(index) else { return }
        placed.append(index)
        result = nil
    }

    /// Sends a placed word back to the bank.
    func remove(at position: Int) {
        guard placed.indices.contains(position) else { return }
        placed.remove(at: position)
        result = nil
    }

    func reset() {
        placed = []
        result = nil
    }

    @discardableResult
    func check() -> Result? {
        guard canCheck else { return nil }
        result = rule.isCorrect(placedWords) ? .right : .wrong
        return result
    }

    // MARK: Solved

    func isSolved(in solved: [SolvedRule]) -> Bool {
        solved.contains { $0.ruleID == rule.id }
    }

    /// Marks the rule as solved, or un-marks it. Returns whether it's solved afterwards.
    @discardableResult
    func toggleSolved(in context: ModelContext) -> Bool {
        let id = rule.id
        let existing = (try? context.fetch(FetchDescriptor<SolvedRule>(predicate: #Predicate { $0.ruleID == id }))) ?? []
        if existing.isEmpty {
            context.insert(SolvedRule(ruleID: id))
        } else {
            existing.forEach(context.delete)
        }
        try? context.save()
        return existing.isEmpty
    }
}
