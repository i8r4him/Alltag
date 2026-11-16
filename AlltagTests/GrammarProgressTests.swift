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
          arguments: [(Level.a1, 0), (.a2, 0), (.b1, 0), (.b2, 0), (.c1, 0)])
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

    @Test("The next rule is the first unsolved one at the level, in order")
    func nextRuleInOrder() throws {
        let first = try #require(GrammarProgress(solved: []).nextRule(at: .a2))
        #expect(first.rule.id == "a2-perfekt-haben")
        #expect(first.number == 1)
        #expect(first.count == 20)
        #expect(!first.isLevelDone)

        let second = try #require(GrammarProgress(solved: [SolvedRule(ruleID: "a2-perfekt-haben")]).nextRule(at: .a2))
        #expect(second.rule.id == "a2-partizip")
        #expect(second.number == 2)
    }

    @Test("Once the level is done, the next rule comes from the level above")
    func nextRuleAfterLevel() throws {
        let progress = GrammarProgress(solved: MockRules.a2.map { SolvedRule(ruleID: $0.id) })
        let next = try #require(progress.nextRule(at: .a2))
        #expect(next.rule.id == GrammarProgress.rules(at: .b1).first?.id)
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
        #expect(!fresh.isLocked("pronomen"))
        #expect(fresh.blocker(of: "sein-haben")?.id == "pronomen")
        // A rule further down names the first rule that is still open, not the one right before it.
        #expect(fresh.blocker(of: "akkusativ")?.id == "pronomen")
        #expect(fresh.blocker(of: "a2-partizip")?.id == "a2-perfekt-haben")
        // The first rule of every level is open, whatever happened below it.
        #expect(!fresh.isLocked("a2-perfekt-haben"))
        #expect(!fresh.isLocked("weil"))

        let afterFirst = GrammarProgress(solved: [SolvedRule(ruleID: "pronomen")])
        #expect(!afterFirst.isLocked("sein-haben"))
        #expect(afterFirst.blocker(of: "praesens")?.id == "sein-haben")
        #expect(afterFirst.isLocked("a2-partizip"))
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
        #expect(place.number == 10)
        #expect(place.count == 20)
        #expect(GrammarProgress.rule(after: MockRules.verbSecond)?.id == "ja-nein-frage")
        #expect(GrammarProgress.rule(after: MockRules.accusative)?.id == "vokalwechsel")
        #expect(GrammarProgress.rule(after: MockRules.whichThis) == nil)
    }

    @Test("Each level lists its rules with lessons in order")
    func rulesAtLevel() {
        let first = ["pronomen", "sein-haben", "praesens", "v2", "ja-nein-frage", "w-frage", "artikel", "plural", "negation",
                     "akkusativ"]
        let second = ["vokalwechsel", "modalverben", "trennbar", "imperativ", "possessiv", "dativ", "wo-dativ",
                      "praepositionen", "zeit", "welcher-dieser"]
        #expect(GrammarProgress.rules(at: .a1).map(\.id) == first + second)
        #expect(GrammarProgress.rules(at: .a2).map(\.id) == MockRules.a2.map(\.id))
        #expect(GrammarProgress.rules(at: .c1).map(\.id) == ["nominal"])
    }
}
