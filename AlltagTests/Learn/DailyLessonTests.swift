//
//  DailyLessonTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import Testing
@testable import Alltag

@MainActor
struct DailyLessonTests {
    private let calendar = Calendar(identifier: .gregorian)
    private var today: Date { calendar.date(from: DateComponents(year: 2026, month: 11, day: 20, hour: 12)) ?? .now }
    private var yesterday: Date { today.addingTimeInterval(-86_400) }

    private func steps(_ records: DailyLesson.Records = .init(), on date: Date? = nil) -> [LessonStep] {
        DailyLesson.steps(at: .a2, records: records, on: date ?? today, calendar: calendar)
    }

    @Test("A new learner gets words, a rule, something to read and a chat, none done, and no mistakes")
    func freshLesson() {
        let lesson = steps()
        #expect(lesson.map(\.part) == [.words, .grammar, .read, .write])
        #expect(lesson.allSatisfy { !$0.isDone })
        #expect(DailyLesson.current(in: lesson)?.part == .words)
        let firstRule = GrammarProgress.rules(at: .a2).first?.id
        #expect(lesson.first { $0.part == .grammar }?.target == firstRule.map(LessonTarget.rule))
        #expect(lesson.first { $0.part == .write }?.target == .chat("lena"))
    }

    @Test("A rule solved today ticks Grammar off; one solved yesterday moves it to the next rule")
    func grammar() throws {
        let rules = GrammarProgress.rules(at: .a2)
        let first = try #require(rules.first)
        let second = try #require(rules.dropFirst().first)

        let solvedToday = steps(.init(solvedRules: [SolvedRule(ruleID: first.id, solvedAt: today)]))
        let doneStep = try #require(solvedToday.first { $0.part == .grammar })
        #expect(doneStep.isDone)
        #expect(doneStep.target == .rule(first.id))

        let solvedBefore = steps(.init(solvedRules: [SolvedRule(ruleID: first.id, solvedAt: yesterday)]))
        let nextStep = try #require(solvedBefore.first { $0.part == .grammar })
        #expect(!nextStep.isDone)
        #expect(nextStep.target == .rule(second.id))
    }

    @Test("Reading alternates by day between a text and a Read and do scene")
    func readingAlternates() {
        let targets = [today, yesterday].compactMap { day in steps(on: day).first { $0.part == .read }?.target }
        let kinds = Set(targets.map { target -> String in
            if case .text = target { return "text" }
            if case .scene = target { return "scene" }
            return "other"
        })
        #expect(kinds == ["text", "scene"])
    }

    @Test("A text read today ticks Read off")
    func readToday() {
        let text = ReadingTexts.a2Water
        let record = SessionRecord(uuid: ReadingProgress.recordID(for: text.id), kind: .reading, title: "Water",
                                   date: today)
        let step = steps(.init(sessions: [record])).first { $0.part == .read }
        #expect(step?.isDone == true)
        #expect(step?.target == .text(text.id))
    }

    @Test("Anything written today ticks Write off; a chat from yesterday moves on to the next friend")
    func writing() {
        let writtenToday = steps(.init(sessions: [SessionRecord(kind: .writing, title: "Lena", date: today)]))
        #expect(writtenToday.first { $0.part == .write }?.isDone == true)

        let earlier = steps(.init(sessions: [SessionRecord(kind: .writing, title: "Lena", date: yesterday)]))
        let next = earlier.first { $0.part == .write }
        #expect(next?.isDone == false)
        #expect(next?.target == .chat("wg"))
    }

    @Test("Mistakes join the lesson only when some are due, and count once practised today")
    func mistakes() {
        #expect(steps(.init(dueMistakes: 3)).last?.part == .mistakes)
        #expect(steps(.init(dueMistakes: 3)).last?.isDone == false)
        #expect(steps(.init(dueMistakes: 1, fixedMistakesToday: true)).last?.isDone == true)
        #expect(!steps(.init(dueMistakes: 0)).contains { $0.part == .mistakes })
    }

    @Test("Minutes left count only the steps not done, and a finished lesson has no current step")
    func minutesAndFinish() {
        let lesson = steps(.init(dueMistakes: 2))
        #expect(DailyLesson.minutesLeft(in: lesson) == lesson.map(\.minutes).reduce(0, +))
        #expect((10...20).contains(DailyLesson.minutesLeft(in: lesson)))
        let done = lesson.map {
            LessonStep(part: $0.part, target: $0.target, title: $0.title, preview: $0.preview,
                       systemImage: $0.systemImage, minutes: $0.minutes, isDone: true)
        }
        #expect(DailyLesson.current(in: done) == nil)
        #expect(DailyLesson.minutesLeft(in: done) == 0)
    }
}
