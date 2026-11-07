//
//  RuleModelTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import SwiftData
import Testing
@testable import Alltag

@Suite("Word-order task")
@MainActor
struct RuleModelTests {
    /// Places the rule's words in the order of `answer`.
    func place(_ answer: String, in model: RuleModel) throws {
        var remaining = Array(model.words.indices)
        var text = answer
        while !text.isEmpty {
            let index = try #require(remaining.first { text.hasPrefix(model.words[$0]) })
            model.place(index)
            remaining.removeAll { $0 == index }
            text = String(text.dropFirst(model.words[index].count)).trimmingCharacters(in: .whitespaces)
        }
    }

    @Test("Every rule's answer checks as right", arguments: MockRules.all)
    func rightAnswers(rule: GrammarRule) throws {
        for answer in rule.taskAnswers {
            let model = RuleModel(rule: rule)
            try place(answer, in: model)
            #expect(model.check() == .right, "\(rule.id): \(answer)")
        }
    }

    @Test("The words in their scrambled order are wrong")
    func wrongAnswer() {
        let model = RuleModel(rule: MockRules.weil)
        model.words.indices.forEach(model.place)
        #expect(model.placedWords == ["krank", "bin", "weil", "ich"])
        #expect(model.check() == .wrong)
    }

    @Test("„seit“ accepts both word orders")
    func twoAnswers() throws {
        for answer in ["Ich lerne seit zwei Jahren Deutsch", "Ich lerne Deutsch seit zwei Jahren"] {
            let model = RuleModel(rule: MockRules.seit)
            try place(answer, in: model)
            #expect(model.check() == .right)
        }
    }

    @Test("A word can be placed once; removing it frees it and clears the result")
    func placeAndRemove() {
        let model = RuleModel(rule: MockRules.weil)
        model.place(2)
        model.place(2)
        #expect(model.placedWords == ["weil"])
        #expect(model.isUsed(2))

        model.check()
        #expect(model.result == .wrong)
        model.remove(at: 0)
        #expect(model.placed.isEmpty)
        #expect(!model.isUsed(2))
        #expect(model.result == nil)
    }

    @Test("Check needs at least one word; reset clears everything")
    func checkAndReset() {
        let model = RuleModel(rule: MockRules.weil)
        #expect(model.check() == nil)
        model.place(0)
        model.check()
        model.reset()
        #expect(model.placed.isEmpty)
        #expect(model.result == nil)
    }

    @Test("Marking as solved saves a SolvedRule; again removes it")
    func solved() throws {
        let container = try AlltagStore.makeContainer(inMemory: true)
        let context = container.mainContext
        let model = RuleModel(rule: MockRules.weil)

        #expect(model.toggleSolved(in: context))
        var solved = try context.fetch(FetchDescriptor<SolvedRule>())
        #expect(solved.map(\.ruleID) == ["weil"])
        #expect(model.isSolved(in: solved))
        #expect(GrammarProgress(solved: solved).solvedCount(at: .b1) == 1)

        #expect(!model.toggleSolved(in: context))
        solved = try context.fetch(FetchDescriptor<SolvedRule>())
        #expect(solved.isEmpty)
    }
}
