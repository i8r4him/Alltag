//
//  ReadDoTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import SwiftData
import Testing
@testable import Alltag

/// "Read and do": the scenes are written by hand, and a round counts only first tries.
@MainActor
struct ReadDoTests {
    @Test("Every scene has a unique id that starts with its level and isn't a text's id")
    func ids() {
        let ids = ReadDoScenes.all.map(\.id)
        #expect(Set(ids).count == ids.count)
        #expect(Set(ids).isDisjoint(with: ReadingTexts.all.map(\.id)))
        for scene in ReadDoScenes.all {
            #expect(scene.id.hasPrefix(scene.level.rawValue.lowercased() + "-do-"), "\(scene.id)")
        }
    }

    @Test("Every task's answer is on exactly one line that can be tapped")
    func answers() {
        for scene in ReadDoScenes.all {
            #expect(scene.tasks.count == 3, "\(scene.id)")
            for task in scene.tasks {
                #expect(scene.lines(answering: task).count == 1, "\(scene.id): \(task.answer)")
            }
        }
    }

    @Test("Every level has scenes; C2 does its own once they are written, C1's until then")
    func levels() {
        for level in Level.allCases {
            #expect(!ReadDoScenes.scenes(at: level).isEmpty, "\(level)")
        }
        let c2Level: Level = ReadDoScenes.c2.isEmpty ? .c1 : .c2
        #expect(ReadDoScenes.scenes(at: .c2).allSatisfy { $0.level == c2Level })
    }

    @Test("Lines are read by their marks")
    func parsing() {
        #expect(ReadDoLine(id: 0, source: "# Abfahrt").style == .heading)
        #expect(ReadDoLine(id: 0, source: "## Zutaten").style == .label)
        #expect(ReadDoLine(id: 0, source: "---").style == .rule)
        #expect(ReadDoLine(id: 0, source: "Vorname ___").cells == ["Vorname"])
        #expect(ReadDoLine(id: 0, source: "10:05 | 12 | Zoo").cells == ["10:05", "12", "Zoo"])
        #expect(ReadDoLine(id: 0, source: "Bitte nehmen Sie den Bus.").style == .text)
    }

    @Test("A wrong line, then the right one: done, but not at the first try")
    func wrongThenRight() throws {
        let round = ReadDoRound(scene: ReadDoScenes.a1Receipt)
        let task = try #require(round.current)
        let right = try #require(round.scene.lines(answering: task).first)
        let wrong = try #require(round.scene.lines.first { $0.isTappable && $0.id != right.id })
        #expect(!round.tap(wrong))
        #expect(round.wrongLines == [wrong.id])
        #expect(round.hintLine == nil)
        #expect(round.tap(right))
        #expect(round.isAnswered)
        #expect(round.firstTries == [false])
    }

    @Test("Two wrong lines light up the right one")
    func hint() throws {
        let round = ReadDoRound(scene: ReadDoScenes.a1Receipt)
        let task = try #require(round.current)
        let right = try #require(round.scene.lines(answering: task).first)
        let wrongs = round.scene.lines.filter { $0.isTappable && $0.id != right.id }.prefix(2)
        for line in wrongs { round.tap(line) }
        #expect(round.hintLine == right.id)
    }

    @Test("Three right at the first try pass; a rule can't be tapped")
    func passing() throws {
        let round = ReadDoRound(scene: ReadDoScenes.a1Receipt)
        let rule = try #require(round.scene.lines.first { $0.style == .rule })
        #expect(!round.tap(rule))
        for _ in round.tasks {
            let task = try #require(round.current)
            let line = try #require(round.scene.lines(answering: task).first)
            round.tap(line)
            round.next()
        }
        #expect(round.isFinished)
        #expect(round.isPassed)
        round.restart()
        #expect(round.index == 0 && !round.isFinished && round.firstTries.isEmpty)
    }

    @Test("A done scene is kept in Your sessions once and counts as read")
    func markDone() throws {
        let container = try AlltagStore.makeContainer(inMemory: true)
        let context = container.mainContext
        let scene = ReadDoScenes.a2Train
        try ReadingProgress.markDone(scene, in: context)
        try ReadingProgress.markDone(scene, in: context)
        let records = try context.fetch(FetchDescriptor<SessionRecord>())
        #expect(records.count == 1)
        #expect(ReadingProgress.readIDs(in: records) == [scene.id])
    }
}
