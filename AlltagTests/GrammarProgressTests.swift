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
          arguments: [(Level.a1, 4), (.a2, 2), (.b1, 0), (.b2, 0), (.c1, 0)])
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

    @Test("The rules of a level open in order: a rule is locked until the ones before it are solved")
    func rulesOpenInOrder() {
        let fresh = GrammarProgress(solved: [])
        #expect(!fresh.isLocked("v2"))
        #expect(fresh.blocker(of: "akkusativ")?.id == "v2")
        #expect(fresh.blocker(of: "seit")?.id == "perfekt")
        // The first rule of every level is open, whatever happened below it.
        #expect(!fresh.isLocked("perfekt"))
        #expect(!fresh.isLocked("weil"))

        let afterFirst = GrammarProgress(solved: [SolvedRule(ruleID: "v2")])
        #expect(!afterFirst.isLocked("akkusativ"))
        #expect(afterFirst.isLocked("seit"))
    }

    @Test("A solved rule stays open, and an unknown rule is not locked")
    func solvedStaysOpen() {
        let progress = GrammarProgress(solved: [SolvedRule(ruleID: "akkusativ")])
        #expect(!progress.isLocked("akkusativ"))
        #expect(!progress.isLocked("no-such-rule"))
    }

    @Test("No topic with a rule is listed as solved: only the learner solves a rule")
    func ruleTopicsStartUnsolved() {
        for level in Level.selectable {
            for topic in MockLevels.topics(for: level) where topic.ruleID != nil {
                #expect(topic.status != .solved, "\(topic.title)")
            }
        }
    }

    @Test("A rule knows its place in its level and the rule that opens after it")
    func placeInLevel() throws {
        let place = try #require(GrammarProgress.place(of: MockRules.accusative))
        #expect(place.number == 2)
        #expect(place.count == 2)
        #expect(GrammarProgress.rule(after: MockRules.verbSecond)?.id == "akkusativ")
        #expect(GrammarProgress.rule(after: MockRules.accusative) == nil)
    }

    @Test("Each level lists its rules with lessons in order")
    func rulesAtLevel() {
        #expect(GrammarProgress.rules(at: .a1).map(\.id) == ["v2", "akkusativ"])
        #expect(GrammarProgress.rules(at: .a2).map(\.id) == ["perfekt", "seit"])
        #expect(GrammarProgress.rules(at: .c1).map(\.id) == ["nominal"])
    }
}
