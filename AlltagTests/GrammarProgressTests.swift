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
}
