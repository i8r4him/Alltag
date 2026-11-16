//
//  ExamTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import SwiftData
import Testing
@testable import Alltag

@Suite("Rule exam")
@MainActor
struct ExamTests {
    private var rulesWithExam: [GrammarRule] { MockRules.all.filter { $0.hasExam } }

    private func emptyStore() throws -> ModelContainer {
        try AlltagStore.makeContainer(inMemory: true)
    }

    /// Places tiles so that they read `sentence`, longest tile first where two fit.
    private func build(_ sentence: String, in model: ExamModel) throws {
        var remaining = Array(model.words.indices)
        var text = sentence
        while !text.isEmpty {
            let fitting = remaining.filter { text == model.words[$0] || text.hasPrefix(model.words[$0] + " ") }
            let tile = try #require(fitting.max { model.words[$0].count < model.words[$1].count }, "No tile for „\(text)“")
            model.place(tile)
            remaining.removeAll { $0 == tile }
            text = String(text.dropFirst(model.words[tile].count)).trimmingCharacters(in: .whitespaces)
        }
    }

    /// Answers the question on screen, right or wrong.
    private func answer(_ model: ExamModel, right: Bool, in context: ModelContext) throws {
        let question = try #require(model.current)
        switch question.kind {
        case let .choice(options, answer):
            model.pick(right ? answer : (answer + 1) % options.count)
        case let .build(_, answers):
            if right {
                try build(try #require(answers.first), in: model)
            } else {
                model.place(0)
            }
        }
        #expect(model.check(in: context) == right)
    }

    // MARK: Content

    @Test("An exam has an easy, a medium and a hard question, in that order")
    func threeQuestions() {
        #expect(!rulesWithExam.isEmpty)
        for rule in rulesWithExam {
            #expect(rule.exam.map(\.difficulty) == ExamQuestion.Difficulty.allCases, "\(rule.id)")
            #expect(rule.exam.allSatisfy { !$0.prompt.isEmpty && !$0.explanation.isEmpty }, "\(rule.id)")
        }
    }

    @Test("Every choice has three different options and its answer among them")
    func choices() {
        for question in rulesWithExam.flatMap(\.exam) {
            guard case let .choice(options, answer) = question.kind else { continue }
            #expect(options.count >= 3)
            #expect(Set(options).count == options.count)
            #expect(options.indices.contains(answer))
        }
    }

    @Test("Every accepted sentence can be built from the question's tiles")
    func sentencesCanBeBuilt() throws {
        let container = try emptyStore()
        for rule in rulesWithExam {
            for (index, question) in rule.exam.enumerated() {
                guard case let .build(words, answers) = question.kind else { continue }
                #expect(!answers.isEmpty)
                for sentence in answers {
                    let model = ExamModel(rule: rule)
                    for _ in 0..<index {
                        try answer(model, right: true, in: container.mainContext)
                        model.next()
                    }
                    #expect(model.words == words)
                    try build(sentence, in: model)
                    #expect(model.check(in: container.mainContext) == true, "\(rule.id): \(sentence)")
                }
            }
        }
    }

    @Test("The accusative is the first rule with an exam and a picture")
    func accusative() throws {
        let rule = MockRules.accusative
        #expect(rule.hasExam)
        let visual = try #require(rule.visual)
        #expect(visual.target.german.contains(try #require(visual.target.marked)))
        #expect(visual.rows.allSatisfy { $0.cells.count == visual.columns.count })
        #expect(visual.rows.contains { !$0.marked.isEmpty })
    }

    // MARK: Taking the exam

    @Test("All three right passes the exam and solves the rule")
    func passing() throws {
        let container = try emptyStore()
        let context = container.mainContext
        let model = ExamModel(rule: MockRules.accusative)
        for _ in model.questions {
            #expect(!model.showsResult)
            try answer(model, right: true, in: context)
            model.next()
        }
        #expect(model.showsResult)
        #expect(model.isPassed)
        #expect(model.score == 3)
        #expect(try context.fetch(FetchDescriptor<SolvedRule>()).map(\.ruleID) == ["akkusativ"])
    }

    @Test("One wrong answer fails the exam and leaves the rule unsolved; it can be taken again")
    func failing() throws {
        let container = try emptyStore()
        let context = container.mainContext
        let model = ExamModel(rule: MockRules.accusative)
        try answer(model, right: true, in: context)
        model.next()
        try answer(model, right: false, in: context)
        model.next()
        try answer(model, right: true, in: context)
        model.next()
        #expect(model.showsResult)
        #expect(!model.isPassed)
        #expect(model.results == [true, false, true])
        #expect(try context.fetch(FetchDescriptor<SolvedRule>()).isEmpty)

        model.restart()
        #expect(model.index == 0)
        #expect(model.results.isEmpty)
        #expect(!model.showsResult)
        #expect(model.checked == nil)
    }

    @Test("An answer is checked once, and nothing changes after the check")
    func checkedOnce() throws {
        let container = try emptyStore()
        let context = container.mainContext
        let model = ExamModel(rule: MockRules.accusative)
        #expect(!model.canCheck)
        #expect(model.check(in: context) == nil)
        model.next()
        #expect(model.index == 0)

        try answer(model, right: false, in: context)
        let picked = model.picked
        model.pick(1)
        #expect(model.picked == picked)
        #expect(model.check(in: context) == nil)
        #expect(model.results == [false])
    }

    @Test("Passing again doesn't save the rule twice")
    func passingTwice() throws {
        let container = try emptyStore()
        let context = container.mainContext
        for _ in 0..<2 {
            let model = ExamModel(rule: MockRules.accusative)
            for _ in model.questions {
                try answer(model, right: true, in: context)
                model.next()
            }
        }
        #expect(try context.fetch(FetchDescriptor<SolvedRule>()).count == 1)
    }

    @Test("A leftover tile is not part of the sentence")
    func leftoverTile() throws {
        let container = try emptyStore()
        let context = container.mainContext
        let model = ExamModel(rule: MockRules.accusative)
        try answer(model, right: true, in: context)
        model.next()
        try answer(model, right: true, in: context)
        model.next()
        // „ein Salat“ instead of „einen Salat“: the tile that is left over.
        try build("Heute nehme ich ein Salat und eine Suppe", in: model)
        #expect(model.check(in: context) == false)
    }
}
