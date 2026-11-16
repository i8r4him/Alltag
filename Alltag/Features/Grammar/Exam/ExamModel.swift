//
//  ExamModel.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import Observation
import SwiftData

/// A rule's exam: three questions, one after the other. Every answer is
/// checked once; the rule is solved when all three are right.
@Observable
final class ExamModel {
    let rule: GrammarRule
    let questions: [ExamQuestion]
    /// The question on screen.
    private(set) var index = 0
    /// Whether each answered question was right, in order.
    private(set) var results: [Bool] = []
    /// The option picked in a choice question.
    private(set) var picked: Int?
    /// Indices into the build question's tiles, in the order they were placed.
    private(set) var placed: [Int] = []
    /// Whether the question on screen has been checked, and how it went.
    private(set) var checked: Bool?
    /// The result is on screen, after the last question.
    private(set) var showsResult = false

    init(rule: GrammarRule) {
        self.rule = rule
        questions = rule.exam
    }

    var current: ExamQuestion? { questions.indices.contains(index) ? questions[index] : nil }
    var isFinished: Bool { !questions.isEmpty && results.count == questions.count }
    var score: Int { results.filter { $0 }.count }
    /// The exam is passed with every question right.
    var isPassed: Bool { isFinished && score == questions.count }
    var isLastQuestion: Bool { index == questions.count - 1 }

    /// The tiles of the build question on screen.
    var words: [String] {
        if case let .build(words, _) = current?.kind { return words }
        return []
    }

    var placedWords: [String] { placed.map { words[$0] } }

    var canCheck: Bool {
        guard checked == nil, let current else { return false }
        switch current.kind {
        case .choice: return picked != nil
        case .build: return !placed.isEmpty
        }
    }

    // MARK: Answering

    func pick(_ option: Int) {
        guard checked == nil, case let .choice(options, _) = current?.kind, options.indices.contains(option) else { return }
        picked = option
    }

    func isUsed(_ tile: Int) -> Bool { placed.contains(tile) }

    /// Moves a tile from the bank into the sentence.
    func place(_ tile: Int) {
        guard checked == nil, words.indices.contains(tile), !isUsed(tile) else { return }
        placed.append(tile)
    }

    /// Sends a placed tile back to the bank.
    func remove(at position: Int) {
        guard checked == nil, placed.indices.contains(position) else { return }
        placed.remove(at: position)
    }

    /// Checks the answer on screen. An answer is checked once. The last
    /// answer finishes the exam, and a passed exam marks the rule as solved.
    @discardableResult
    func check(in context: ModelContext) -> Bool? {
        guard canCheck, let current else { return nil }
        let isRight: Bool
        switch current.kind {
        case let .choice(_, answer): isRight = picked == answer
        case let .build(_, answers): isRight = answers.contains(placedWords.joined(separator: " "))
        }
        checked = isRight
        results.append(isRight)
        if isPassed { markSolved(in: context) }
        return isRight
    }

    /// Goes on to the next question, or to the result after the last one.
    func next() {
        guard checked != nil else { return }
        if isFinished {
            showsResult = true
        } else {
            index += 1
            clearAnswer()
        }
    }

    func restart() {
        index = 0
        results = []
        showsResult = false
        clearAnswer()
    }

    private func clearAnswer() {
        picked = nil
        placed = []
        checked = nil
    }

    private func markSolved(in context: ModelContext) {
        let id = rule.id
        let existing = (try? context.fetch(FetchDescriptor<SolvedRule>(predicate: #Predicate { $0.ruleID == id }))) ?? []
        guard existing.isEmpty else { return }
        context.insert(SolvedRule(ruleID: id))
        try? context.save()
    }
}
