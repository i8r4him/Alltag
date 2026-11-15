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
    @Test("A new learner has solved nothing")
    func newLearner() {
        let progress = GrammarProgress(solved: [])
        #expect(progress.solvedCount == 0)
        #expect(progress.rules.count == MockRules.all.count)
        #expect(MockRules.all.allSatisfy { !progress.isSolved($0) })
    }

    @Test("Solved comes only from SolvedRule")
    func solvedRule() {
        let progress = GrammarProgress(solved: [SolvedRule(ruleID: "weil"), SolvedRule(ruleID: "unknown")])
        #expect(progress.isSolved(MockRules.weil))
        #expect(!progress.isSolved(MockRules.seit))
        #expect(progress.solvedCount == 1)
    }

    @Test("Rules start at the learner's level, then go up, then down")
    func order() {
        let progress = GrammarProgress(solved: [])
        #expect(progress.ordered(from: .b1).map(\.id) == ["weil", "passiv", "nominal", "perfekt", "seit", "v2"])
        #expect(progress.ordered(from: .a1).map(\.id) == ["v2", "perfekt", "seit", "weil", "passiv", "nominal"])
        #expect(progress.ordered(from: .c1).map(\.id) == ["nominal", "passiv", "weil", "perfekt", "seit", "v2"])
    }

    @Test("The next rule is the first unsolved one in that order")
    func nextRule() {
        #expect(GrammarProgress(solved: []).nextRule(from: .a2)?.id == "perfekt")
        let solved = [SolvedRule(ruleID: "perfekt"), SolvedRule(ruleID: "seit")]
        #expect(GrammarProgress(solved: solved).nextRule(from: .a2)?.id == "weil")
    }

    @Test("With every rule solved there is no next rule")
    func allSolved() {
        let progress = GrammarProgress(solved: MockRules.all.map { SolvedRule(ruleID: $0.id) })
        #expect(progress.nextRule(from: .b1) == nil)
        #expect(progress.solvedCount == MockRules.all.count)
    }

    @Test("Grammar starts at the learner's level, C1 for C2, A1 without a profile",
          arguments: [(Level?.some(.a2), Level.a2), (.some(.c1), .c1), (.some(.c2), .c1), (nil, .a1)])
    func startLevel(profile: Level?, expected: Level) {
        #expect(GrammarProgress.startLevel(for: profile) == expected)
    }
}
