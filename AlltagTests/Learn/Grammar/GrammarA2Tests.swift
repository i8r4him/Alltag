//
//  GrammarA2Tests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import Testing
@testable import Alltag

@Suite("Grammar A2")
@MainActor
struct GrammarA2Tests {
    @Test("A2 has twenty rules, each with a picture, an exam and its own ID")
    func allOfA2() {
        #expect(MockRules.a2.count == 20)
        #expect(Set(MockRules.a2.map { $0.id }).count == 20)
        for rule in MockRules.a2 {
            #expect(rule.level == .a2, "\(rule.id)")
            #expect(rule.id.hasPrefix("a2-"), "\(rule.id)")
            #expect(rule.hasExam, "\(rule.id)")
            #expect(rule.visual != nil, "\(rule.id)")
            #expect(RealLifeSentence.byRule[rule.id]?.count == 3, "\(rule.id)")
        }
    }

    @Test("A2 lists exactly its rules, in order, and every A2 topic is a rule")
    func listedInOrder() {
        let topics = MockLevels.topics(for: .a2)
        #expect(topics.count == MockRules.a2.count)
        #expect(topics.compactMap(\.ruleID) == MockRules.a2.map(\.id))
        #expect(topics.map(\.title) == MockRules.a2.map(\.title))
        #expect(topics.allSatisfy { $0.status == .new })
    }

    @Test("The A2 rules open one after the other")
    func openInOrder() {
        var solved: [SolvedRule] = []
        for (index, rule) in MockRules.a2.enumerated() {
            let progress = GrammarProgress(solved: solved)
            #expect(!progress.isLocked(rule.id), "\(rule.id)")
            if let next = MockRules.a2.dropFirst(index + 1).first {
                #expect(progress.blocker(of: next.id)?.id == rule.id, "\(next.id)")
            }
            solved.append(SolvedRule(ruleID: rule.id))
        }
    }
}
