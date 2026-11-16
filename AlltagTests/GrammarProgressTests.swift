//
//  GrammarProgressTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import Testing
@testable import Alltag

@Suite("Grammar progress")
@MainActor
struct GrammarProgressTests {
    @Test("Without solved rules, the prototype's counts per level",
          arguments: [(Level.a1, 5), (.a2, 3), (.b1, 0), (.b2, 0), (.c1, 0)])
    func solvedCounts(level: Level, expected: Int) {
        #expect(GrammarProgress(solved: []).solvedCount(at: level) == expected)
    }

    @Test("Solving a rule turns its topic solved, whatever it was")
    func solvingRule() throws {
        let progress = GrammarProgress(solved: [SolvedRule(ruleID: "weil")])
        let weil = try #require(MockLevels.topics(for: .b1).first { $0.ruleID == "weil" })
        #expect(weil.status == .mistake)
        #expect(progress.status(of: weil) == .solved)
        #expect(progress.solvedCount(at: .b1) == 1)
    }

    @Test("Topics without a rule keep their status")
    func topicsWithoutRule() throws {
        let progress = GrammarProgress(solved: [SolvedRule(ruleID: "weil")])
        let relative = try #require(MockLevels.topics(for: .b1).first { $0.title == "Relative clauses" })
        #expect(progress.status(of: relative) == .learning)
    }

    @Test("Grammar opens at the learner's level, or B1",
          arguments: [(Level?.some(.a2), Level.a2), (.some(.c1), .c1), (.some(.c2), .b1), (nil, .b1)])
    func initialLevel(profile: Level?, expected: Level) {
        #expect(GrammarProgress.initialLevel(for: profile) == expected)
    }

    @Test("The mistakes focus points at real rules")
    func focus() {
        #expect(MockLevels.focus.map(\.ruleID) == ["weil", "seit"])
        #expect(MockLevels.focus.allSatisfy { MockRules.rule(id: $0.ruleID) != nil })
    }

    @Test("The next rule is the first unsolved one at the level, in order")
    func nextRuleInOrder() throws {
        let first = try #require(GrammarProgress(solved: []).nextRule(at: .a2))
        #expect(first.rule.id == "perfekt")
        #expect(first.number == 1)
        #expect(first.count == 2)
        #expect(!first.isLevelDone)

        let second = try #require(GrammarProgress(solved: [SolvedRule(ruleID: "perfekt")]).nextRule(at: .a2))
        #expect(second.rule.id == "seit")
        #expect(second.number == 2)
    }

    @Test("Once the level is done, the next rule comes from the level above")
    func nextRuleAfterLevel() throws {
        let progress = GrammarProgress(solved: [SolvedRule(ruleID: "perfekt"), SolvedRule(ruleID: "seit")])
        let next = try #require(progress.nextRule(at: .a2))
        #expect(next.rule.id == "weil")
        #expect(next.isLevelDone)
    }

    @Test("When every rule is done there is no next rule")
    func noNextRule() {
        let progress = GrammarProgress(solved: MockRules.all.map { SolvedRule(ruleID: $0.id) })
        #expect(progress.nextRule(at: .a1) == nil)
    }

    @Test("Each level lists its rules with lessons in order")
    func rulesAtLevel() {
        #expect(GrammarProgress.rules(at: .a2).map(\.id) == ["perfekt", "seit"])
        #expect(GrammarProgress.rules(at: .c1).map(\.id) == ["nominal"])
    }
}
