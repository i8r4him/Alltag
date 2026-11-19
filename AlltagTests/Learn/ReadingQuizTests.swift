//
//  ReadingQuizTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import SwiftData
import Testing
@testable import Alltag

@MainActor
struct ReadingQuizTests {
    private let text = ReadingTexts.a2Water

    @Test("A wrong pick lights up the answer's sentence; the right pick then doesn't count as a first try")
    func wrongThenRight() throws {
        let quiz = ReadingQuiz(questions: text.questions)
        let question = try #require(quiz.current)
        let wrong = (question.answer + 1) % question.options.count
        #expect(quiz.evidence == nil)
        #expect(!quiz.pick(wrong))
        #expect(quiz.evidence == question.evidence)
        #expect(quiz.pick(question.answer))
        #expect(quiz.firstTries == [false])
        quiz.next()
        #expect(quiz.index == 1)
        #expect(quiz.evidence == nil)
    }

    @Test("Three right at the first try pass; one wrong doesn't, and Try again starts over")
    func passing() {
        let quiz = ReadingQuiz(questions: text.questions)
        for question in text.questions {
            quiz.pick(question.answer)
            quiz.next()
        }
        #expect(quiz.isFinished)
        #expect(quiz.isPassed)

        quiz.restart()
        quiz.pick((text.questions[0].answer + 1) % 3)
        for question in text.questions {
            quiz.pick(question.answer)
            quiz.next()
        }
        #expect(quiz.isFinished)
        #expect(quiz.score == 2)
        #expect(!quiz.isPassed)
    }

    @Test("Next waits for the right answer")
    func nextWaits() {
        let quiz = ReadingQuiz(questions: text.questions)
        quiz.next()
        #expect(quiz.index == 0)
    }

    @Test("The answer's sentence is found word by word in the text")
    func litWords() throws {
        let paragraphs = ReadingWords.paragraphs(of: text.german)
        let evidence = text.questions[0].evidence
        let ids = ReadingWords.wordIDs(of: evidence, in: paragraphs)
        let words = paragraphs.flatMap(\.words).filter { ids.contains($0.id) }.map(\.written)
        #expect(words.joined(separator: " ") == evidence)
        #expect(ReadingWords.wordIDs(of: "Nicht im Text.", in: paragraphs).isEmpty)
    }

    @Test("Every text has its own record ID, the same every time")
    func recordIDs() {
        let ids = ReadingTexts.all.map { ReadingProgress.recordID(for: $0.id) }
        #expect(Set(ids).count == ids.count)
        #expect(ReadingProgress.recordID(for: "a1-parcel") == ReadingProgress.recordID(for: "a1-parcel"))
    }

    @Test("A text read is kept once in Your sessions and counts as read")
    func markRead() throws {
        let container = try AlltagStore.makeContainer(inMemory: true)
        let context = container.mainContext
        try ReadingProgress.markRead(text, in: context, date: Date(timeIntervalSince1970: 0))
        try ReadingProgress.markRead(text, in: context, date: Date(timeIntervalSince1970: 100))
        let records = try context.fetch(FetchDescriptor<SessionRecord>())
        #expect(records.count == 1)
        #expect(records.first?.kind == .reading)
        #expect(records.first?.date == Date(timeIntervalSince1970: 100))
        #expect(ReadingProgress.readIDs(in: records) == [text.id])
        #expect(ReadingProgress.next(at: .a2, read: [text.id])?.id != text.id)
    }

    @Test("The reader saves the text as read once the questions are passed")
    func readerSaves() throws {
        let container = try AlltagStore.makeContainer(inMemory: true)
        let model = ReaderModel(text: text)
        model.showQuestions()
        for question in text.questions {
            model.quiz.pick(question.answer)
            model.nextQuestion(in: container.mainContext)
        }
        #expect(model.quiz.isPassed)
        let records = try container.mainContext.fetch(FetchDescriptor<SessionRecord>())
        #expect(ReadingProgress.readIDs(in: records) == [text.id])
    }
}
