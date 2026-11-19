//
//  LearnOverviewTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import Testing
@testable import Alltag

@MainActor
struct LearnOverviewTests {
    @Test("A new learner sees every part at their level with nothing done, and Listen as coming soon")
    func freshOverview() throws {
        let overview = LearnOverview.make(at: .a2, solvedRules: [], sessions: [], collectionWords: [])
        #expect(overview.parts.map(\.kind) == [.grammar, .read, .write, .words, .listen])
        let grammar = try #require(overview.part(.grammar))
        #expect(grammar.done == 0)
        #expect(grammar.total == GrammarProgress.rules(at: .a2).count)
        #expect(grammar.next?.target == GrammarProgress.rules(at: .a2).first.map { LessonTarget.rule($0.id) })
        #expect(overview.part(.listen)?.isComingSoon == true)
        #expect(overview.part(.listen)?.fraction == nil)
        #expect(overview.parts.allSatisfy { $0.items.count <= LearnOverview.itemLimit })
    }

    @Test("Solved rules count, and the next rule is the first unsolved; done items move to the back")
    func grammarProgress() throws {
        let rules = GrammarProgress.rules(at: .a2)
        let first = try #require(rules.first)
        let overview = LearnOverview.make(at: .a2, solvedRules: [SolvedRule(ruleID: first.id)], sessions: [],
                                          collectionWords: [])
        let grammar = try #require(overview.part(.grammar))
        #expect(grammar.done == 1)
        #expect(grammar.next?.target != .rule(first.id))
        #expect(grammar.items.first?.isDone == false)
    }

    @Test("Read mixes texts and Read and do, and counts a text read")
    func reading() throws {
        let text = ReadingTexts.a2Water
        let record = SessionRecord(uuid: ReadingProgress.recordID(for: text.id), kind: .reading, title: "Water")
        let read = try #require(LearnOverview.make(at: .a2, solvedRules: [], sessions: [record],
                                                   collectionWords: []).part(.read))
        #expect(read.done == 1)
        #expect(read.items.contains { if case .scene = $0.target { true } else { false } })
        #expect(read.items.contains { if case .text = $0.target { true } else { false } })
        #expect(read.next?.target != .text(text.id))
    }

    @Test("Write counts what was written and puts the friends not texted yet first")
    func writing() throws {
        let record = SessionRecord(kind: .writing, title: "Lena")
        let write = try #require(LearnOverview.make(at: .a2, solvedRules: [], sessions: [record],
                                                    collectionWords: []).part(.write))
        #expect(write.done == 1)
        #expect(write.fraction == nil)
        #expect(write.next?.target == .chat("wg"))
    }
}
