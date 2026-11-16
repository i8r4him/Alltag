//
//  GrammarC1Tests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import Testing
@testable import Alltag

@Suite("Grammar C1")
@MainActor
struct GrammarC1Tests {
    @Test("C1 has its rules, each with a picture, an exam and its own ID")
    func allOfC1() {
        #expect(MockRules.c1.count == 22)
        #expect(Set(MockRules.c1.map(\.id)).count == MockRules.c1.count)
        for rule in MockRules.c1 {
            #expect(rule.id.hasPrefix("c1-"), "\(rule.id)")
            #expect(rule.level == .c1, "\(rule.id)")
            #expect(rule.hasExam, "\(rule.id)")
            #expect(rule.visual != nil, "\(rule.id)")
            #expect(rule.taskWords.isEmpty, "\(rule.id): a rule with an exam has no task")
        }
    }

    @Test("C1 lists exactly its rules, in order, and opens them one by one")
    func order() throws {
        let topics = MockLevels.topics(for: .c1)
        #expect(topics.compactMap(\.ruleID) == MockRules.c1.map(\.id))
        #expect(topics.count == MockRules.c1.count)
        let progress = GrammarProgress(solved: [])
        let first = try #require(MockRules.c1.first)
        let second = try #require(MockRules.c1.dropFirst().first)
        #expect(!progress.isLocked(first.id))
        #expect(progress.blocker(of: second.id)?.id == first.id)
        #expect(progress.nextRule(at: .c1)?.rule.id == first.id)
    }

    @Test("Every C1 rule has three real-life sentences of its own")
    func realLifeSentences() {
        for rule in MockRules.c1 {
            #expect((RealLifeSentence.c1ByRule[rule.id]?.count ?? 0) >= 3, "\(rule.id)")
        }
        #expect(Set(RealLifeSentence.c1ByRule.keys) == Set(MockRules.c1.map(\.id)))
    }
}
