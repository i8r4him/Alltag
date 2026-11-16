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
    /// A rule with the "Try it" task, so these tests don't depend on which
    /// rules still have one.
    private static let rule = GrammarRule(
        id: "try-it", level: .b1, title: "Verb at the end after weil",
        place: "Station announcement", systemImage: "tram",
        german: "Der Zug hat Verspätung, weil ein Baum auf den Gleisen liegt.",
        english: "The train is delayed because a tree is lying on the tracks.",
        tiles: [GrammarRule.Tile(text: "weil", role: .key), GrammarRule.Tile(text: "liegt", role: .end)],
        notice: "After „weil“, the verb waits until the very end.",
        rule: "After weil, the conjugated verb moves to the end of the clause.",
        taskPrompt: "Finish: „Ich komme heute nicht, …“",
        taskWords: ["krank", "bin", "weil", "ich"],
        taskAnswers: ["weil ich krank bin"]
    )

    /// A rule whose task accepts two word orders.
    private static let twoOrders = GrammarRule(
        id: "try-it-twice", level: .b1, title: "„seit“ or „für“?",
        place: "Meeting a neighbour", systemImage: "house",
        german: "Seit wann wohnst du hier? — Seit drei Jahren.",
        english: "How long have you lived here? — For three years.",
        tiles: [GrammarRule.Tile(text: "Seit", role: .key)],
        notice: "It started three years ago and is still true.",
        rule: "„seit“ + dative for something that began in the past and continues now.",
        taskPrompt: "Say: \"I have been learning German for two years.\"",
        taskWords: ["seit", "lerne", "zwei Jahren", "Ich", "Deutsch"],
        taskAnswers: ["Ich lerne seit zwei Jahren Deutsch", "Ich lerne Deutsch seit zwei Jahren"]
    )

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
        let model = RuleModel(rule: Self.rule)
        model.words.indices.forEach(model.place)
        #expect(model.placedWords == ["krank", "bin", "weil", "ich"])
        #expect(model.check() == .wrong)
    }

    @Test("A task can accept two word orders")
    func twoAnswers() throws {
        for answer in ["Ich lerne seit zwei Jahren Deutsch", "Ich lerne Deutsch seit zwei Jahren"] {
            let model = RuleModel(rule: Self.twoOrders)
            try place(answer, in: model)
            #expect(model.check() == .right)
        }
    }

    @Test("A word can be placed once; removing it frees it and clears the result")
    func placeAndRemove() {
        let model = RuleModel(rule: Self.rule)
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
        let model = RuleModel(rule: Self.rule)
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
        let model = RuleModel(rule: Self.rule)

        #expect(model.toggleSolved(in: context))
        var solved = try context.fetch(FetchDescriptor<SolvedRule>())
        #expect(solved.map(\.ruleID) == ["try-it"])
        #expect(model.isSolved(in: solved))
        #expect(GrammarProgress(solved: solved).solvedRuleIDs == ["try-it"])

        #expect(!model.toggleSolved(in: context))
        solved = try context.fetch(FetchDescriptor<SolvedRule>())
        #expect(solved.isEmpty)
    }
}
