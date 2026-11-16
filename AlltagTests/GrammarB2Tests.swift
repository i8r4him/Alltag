//
//  GrammarB2Tests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import Testing
@testable import Alltag

@Suite("Grammar B2")
@MainActor
struct GrammarB2Tests {
    @Test("B2 has its rules, each with a picture, an exam and its own b2- ID")
    func allOfB2() {
        let rules = MockRules.b2
        #expect(rules.count == 61)
        #expect(Set(rules.map(\.id)).count == rules.count)
        for rule in rules {
            #expect(rule.id.hasPrefix("b2-"), "\(rule.id)")
            #expect(rule.level == .b2, "\(rule.id)")
            #expect(rule.hasExam, "\(rule.id)")
            #expect(rule.visual != nil, "\(rule.id)")
            #expect(rule.taskWords.isEmpty, "\(rule.id): a rule with an exam has no „Try it“ task")
        }
    }

    @Test("Every B2 rule is in MockRules.all and the B2 list, in the order it opens")
    func listedInOrder() {
        let ids = MockRules.b2.map(\.id)
        #expect(MockLevels.topics(for: .b2).compactMap(\.ruleID) == ids)
        #expect(GrammarProgress.rules(at: .b2).map(\.id) == ids)
        #expect(ids.allSatisfy { MockRules.rule(id: $0) != nil })
        #expect(MockLevels.topics(for: .b2).allSatisfy { $0.status == .new })
    }

    @Test("The B2 rules open in order")
    func opensInOrder() throws {
        let first = try #require(MockRules.b2.first)
        let second = MockRules.b2[1]
        let fresh = GrammarProgress(solved: [])
        #expect(!fresh.isLocked(first.id))
        #expect(fresh.blocker(of: second.id)?.id == first.id)
        #expect(!GrammarProgress(solved: [SolvedRule(ruleID: first.id)]).isLocked(second.id))
        #expect(fresh.nextRule(at: .b2)?.rule.id == first.id)
    }

    @Test("Every B2 rule has three real-life sentences of its own")
    func realLifeSentences() throws {
        for rule in MockRules.b2 {
            let sentences = try #require(RealLifeSentence.byRule[rule.id], "\(rule.id)")
            #expect(sentences.count == 3, "\(rule.id)")
            #expect(Set(sentences.map(\.id)).count == sentences.count, "\(rule.id)")
        }
    }
}
