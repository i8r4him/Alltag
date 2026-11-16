//
//  B1RulesTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import Testing
@testable import Alltag

/// The B1 rules. What every rule needs (sentences, a picture, an exam that
/// can be solved) is checked for all rules in `ExamTests` and
/// `GrammarContentTests`; this checks the B1 list itself.
@Suite("B1 rules")
@MainActor
struct B1RulesTests {
    @Test("B1 has thirty rules, each with a picture, an exam and its own ID")
    func allOfB1() {
        #expect(MockRules.b1.count == 30)
        #expect(Set(MockRules.b1.map(\.id)).count == 30)
        for rule in MockRules.b1 {
            #expect(rule.level == .b1, "\(rule.id)")
            #expect(rule.id.hasPrefix("b1-"), "\(rule.id)")
            #expect(rule.hasExam, "\(rule.id)")
            #expect(rule.visual != nil, "\(rule.id)")
            #expect(rule.taskWords.isEmpty, "\(rule.id)")
            #expect(MockRules.rule(id: rule.id) == rule, "\(rule.id)")
        }
    }

    @Test("B1 lists its rules in the order they open, starting with the simple past")
    func order() throws {
        #expect(GrammarProgress.rules(at: .b1).map(\.id) == MockRules.b1.map(\.id))
        #expect(MockLevels.topics(for: .b1).allSatisfy { $0.ruleID != nil && $0.status == .new })

        let fresh = GrammarProgress(solved: [])
        #expect(!fresh.isLocked("b1-praeteritum"))
        #expect(fresh.blocker(of: "b1-je-desto")?.id == "b1-praeteritum")
        let next = try #require(fresh.nextRule(at: .b1))
        #expect(next.rule.id == "b1-praeteritum")
        #expect(next.count == 30)
    }

    @Test("No B1 rule shares an ID with a rule of another level")
    func ownIDs() {
        let ids = MockRules.all.map(\.id)
        #expect(Set(ids).count == ids.count)
    }
}
