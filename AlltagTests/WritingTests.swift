//
//  WritingTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import SwiftData
import Testing
@testable import Alltag

/// What the service sent to the server.
private final class Sent {
    var bodies: [[String: String]] = []
}

/// Answers with a fixed correction, handing the sentences on one by one.
private final class StubWriting: WritingService {
    var check: WritingCheck
    var error: (any Error)?
    private(set) var progress: [[WritingSentence]] = []

    init(_ check: WritingCheck) { self.check = check }

    func task(for level: Level, length: WritingLength, kind: WritingKind?, excluding: [String]) async throws -> WritingTask {
        WritingTasks.tasks(for: level)[0]
    }

    func check(_ text: String, for task: WritingTask,
               onProgress: @escaping ([WritingSentence]) -> Void) async throws -> WritingCheck {
        if let error { throw error }
        for count in check.sentences.indices {
            let sentences = Array(check.sentences.prefix(count + 1))
            progress.append(sentences)
            onProgress(sentences)
        }
        return check
    }
}

@Suite("Learn › Write")
@MainActor
struct WritingTests {
    static let text = "Liebe Frau Schmidt,\nich möchte sie zu Kaffee einladen. Es gibt Kuchen.\nViele Grüße"

    static let check = WritingCheck(
        sentences: [
            WritingSentence(id: 0, original: "Liebe Frau Schmidt,", feedback: Feedback(kind: .good, title: "Greeting", note: "Good."),
                            english: "Dear Frau Schmidt,"),
            WritingSentence(id: 1, original: "ich möchte sie zu Kaffee einladen.",
                            feedback: Feedback(kind: .fix, title: "Sie and zum", note: "Capital Sie; zum Kaffee.",
                                               correction: "ich möchte Sie zum Kaffee einladen."),
                            english: "I'd like to invite you for coffee."),
            WritingSentence(id: 2, original: "Es gibt Kuchen.", feedback: Feedback(kind: .good, title: "Clear", note: "Good."),
                            english: "There is cake."),
            WritingSentence(id: 3, original: "Viele Grüße", feedback: Feedback(kind: .good, title: "Sign-off", note: "Good."),
                            english: "Best wishes")
        ],
        corrected: "Liebe Frau Schmidt, ich möchte Sie zum Kaffee einladen. Es gibt Kuchen. Viele Grüße",
        points: [.init(covered: true, note: "Yes."), .init(covered: false, note: "No time."), .init(covered: false, note: "No.")],
        summary: "Warm and clear.")

    // MARK: The written set

    @Test("Every level has tasks of every kind, each with three points, phrases and the exam's length")
    func writtenSet() {
        for level in Level.selectable {
            let tasks = WritingTasks.tasks(for: level)
            #expect(tasks.count >= 8)
            #expect(Set(tasks.map(\.id)).count == tasks.count)
            for kind in WritingKind.ofTasks {
                #expect(!WritingTasks.tasks(for: level, kind: kind).isEmpty, "\(level) has no \(kind)")
            }
            #expect(WritingTasks.tasks(for: level, kind: .day).count == 2)
            for task in tasks {
                #expect(task.level == level || level == .c2)
                #expect(task.points.count == 3)
                #expect(task.phrases.count >= 3)
                #expect(task.recipient.isEmpty == (task.kind == .day))
                #expect(WritingLength.exam.wordRange(for: level) == task.minWords...task.maxWords)
            }
        }
    }

    // MARK: Length and kind

    @Test("Every level has a quick length of about five minutes, and each length is longer than the last")
    func lengths() {
        for level in Level.selectable {
            let quick = WritingLength.quick.wordRange(for: level)
            let standard = WritingLength.standard.wordRange(for: level)
            let exam = WritingLength.exam.wordRange(for: level)
            #expect(WritingLength.quick.minutes(for: level) <= 5)
            #expect(quick.upperBound < standard.upperBound && standard.upperBound < exam.upperBound)
            #expect(quick.lowerBound <= standard.lowerBound && standard.lowerBound <= exam.lowerBound)
        }
        #expect(WritingLength.quick.wordRange(for: .c1) == 50...75)
        #expect(WritingLength.exam.wordRange(for: .c1) == 180...250)
    }

    @Test("A quick task keeps two of its points and the quick range; the others keep all three")
    func sized() throws {
        let task = try #require(WritingTasks.c1.first)
        let quick = task.sized(.quick)
        #expect(quick.minWords == 50 && quick.maxWords == 75)
        #expect(quick.points == [task.points[1], task.points[2]])
        #expect(quick.minutes == 5)
        #expect(quick.brief.contains("50 to 75 words"))
        #expect(!quick.brief.contains("3. "))
        #expect(task.sized(.standard).points == task.points)
        #expect(task.sized(.exam) == task)
        for task in Level.selectable.flatMap({ WritingTasks.tasks(for: $0) }) {
            #expect(task.sized(.quick).points.count == 2)
        }
    }

    @Test("The task of the day keeps to the chosen kind")
    func pickedKind() {
        for kind in WritingKind.ofTasks {
            #expect(WritingTasks.picked(for: .b2, kind: kind).kind == kind)
        }
    }

    @Test("The learner's own topic has no task, no points, and the chosen length")
    func ownTopic() {
        let own = WritingTask.own(level: .c1, length: .quick)
        #expect(own.kind == .own)
        #expect(own.points.isEmpty && own.phrases.isEmpty && own.recipient.isEmpty)
        #expect(own.minWords == 50 && own.maxWords == 75)
        #expect(own.brief.isEmpty)
    }

    @Test("A text about the day names no recipient in its brief")
    func dayBrief() throws {
        let day = try #require(WritingTasks.tasks(for: .a2, kind: .day).first)
        #expect(day.brief.contains("no recipient"))
        #expect(!day.brief.contains("Register"))
    }

    @Test("A new task is asked for at the chosen length and kind; a check of the learner's own topic sends no task")
    func requests() async throws {
        let sent = Sent()
        let answer = """
        {"title": "Tell a friend", "situation": "You are late.", "recipient": "", "register": "informal", "kind": "day",
         "points": ["a", "b", "c"], "min_words": 0, "max_words": 0, "symbol": "calendar", "phrases": []}
        """
        let service = CloudWritingService(
            send: { body in
                sent.bodies.append(body)
                return Data(answer.utf8)
            },
            stream: { body, _ in sent.bodies.append(body) },
            allowed: { true })
        let task = try await service.task(for: .c1, length: .quick, kind: .day, excluding: ["One", "Two"])
        #expect(sent.bodies[0] == ["action": "task", "level": "C1", "length": "quick", "kind": "day", "exclude": "One; Two"])
        #expect(task.kind == .day)
        #expect(task.points == ["a", "b"])
        #expect(task.minWords == 50 && task.maxWords == 75)

        _ = try await service.task(for: .a1, length: .exam, kind: nil, excluding: [])
        #expect(sent.bodies[1]["kind"] == nil)
        #expect(sent.bodies[1]["length"] == "exam")

        // The stream is empty here, so the check itself fails; what was sent is the point.
        _ = try? await service.check("Heute war ein guter Tag.", for: .own(level: .b1, length: .standard)) { _ in }
        #expect(sent.bodies[2]["task"] == "")
        #expect(sent.bodies[2]["text"] == "Heute war ein guter Tag.")
        #expect(sent.bodies[2]["level"] == "B1")
    }

    @Test("A checked text on the learner's own topic is kept like any other")
    func savesOwnTopic() async throws {
        let store = try AlltagStore.makeContainer(inMemory: true)
        let context = store.mainContext
        let check = WritingCheck(sentences: Self.check.sentences, corrected: Self.check.corrected, points: [], summary: "Good.")
        let model = WriteModel(task: .own(level: .a2, length: .quick), service: StubWriting(check))
        model.text = Self.text
        await model.runCheck()
        model.save(in: context)
        #expect(model.phase == .checked)
        #expect(model.savedMistakes == 1)
        let records = try context.fetch(FetchDescriptor<SessionRecord>())
        #expect(records.count == 1)
        #expect(records.first?.kind == .writing)
    }

    @Test("The task of the day stays the same all day and changes the next")
    func pickedTask() {
        let calendar = Calendar(identifier: .gregorian)
        let morning = Date(timeIntervalSince1970: 1_794_640_000)
        let evening = morning.addingTimeInterval(8 * 3600)
        let tomorrow = morning.addingTimeInterval(24 * 3600)
        let picked = { (date: Date) in WritingTasks.picked(for: .b1, on: date, calendar: calendar) }
        #expect(picked(morning) == picked(evening))
        #expect(picked(morning) != picked(tomorrow))
    }

    @Test("The brief the server reads names the points, the register and the length")
    func brief() {
        let brief = WritingTasks.a2[0].brief
        #expect(brief.contains("1. "))
        #expect(brief.contains("3. "))
        #expect(brief.contains("formal (Sie)"))
        #expect(brief.contains("40 to 70 words"))
    }

    // MARK: The server's answers

    @Test("A new task keeps to the level's length and three points, whatever the model wrote")
    func serverTask() throws {
        let json = """
        {"title": "Ask about a flat", "situation": "You saw an advert.", "recipient": "Herr Lenz", "register": "formal",
         "points": ["a", "b", "c", "d"], "min_words": 10, "max_words": 500, "symbol": "house.fill",
         "phrases": [{"german": "Sehr geehrter Herr Lenz,", "english": "Dear Herr Lenz,"}]}
        """
        let task = try JSONDecoder().decode(ServerWritingTask.self, from: Data(json.utf8)).task(for: .b1)
        // A server that doesn't name the kind yet: a message.
        #expect(task.kind == .message)
        #expect(task.isGenerated)
        #expect(task.points == ["a", "b", "c"])
        #expect(task.minWords == 80 && task.maxWords == 120)
        #expect(task.register == .formal)
    }

    @Test("The stream hands on each sentence as soon as it is complete, however the pieces are cut")
    func stream() throws {
        let answer = """
        {"sentences":[{"original":"Hallo Tim,","kind":"good","title":"Greeting","note":"Fine.","correction":"","english":"Hi Tim,"},\
        {"original":"Ich komme {später}.","kind":"fix","title":"Word \\"order\\"","note":"Say „später“.",\
        "correction":"Ich komme später.","english":"I'm coming later."}],"corrected":"Hallo Tim,\\nIch komme später.",\
        "points":[{"covered":true,"note":"Yes."}],"summary":"Good."}
        """
        var reader = WritingCheckStream()
        var seen: [Int] = []
        // Seven characters at a time, so pieces end inside strings, escapes and braces.
        var rest = Substring(answer)
        while !rest.isEmpty {
            let piece = String(rest.prefix(7))
            rest = rest.dropFirst(7)
            let event = try JSONSerialization.data(withJSONObject: ["type": "response.output_text.delta", "delta": piece])
            let line = "data: " + (String(bytes: event, encoding: .utf8) ?? "")
            if let sentences = try reader.receive(line) { seen.append(sentences.count) }
        }
        #expect(seen == [1, 2])
        #expect(throws: RealtimeServiceError.self) { try reader.finish() }
        _ = try reader.receive(#"data: {"type":"response.completed"}"#)
        let check = try reader.finish()
        #expect(check.sentences.map(\.feedback.kind) == [.good, .fix])
        #expect(check.sentences[1].feedback.correction == "Ich komme später.")
        #expect(check.sentences[0].feedback.correction == nil)
        #expect(check.points.count == 1)
    }

    @Test("A failed answer stops the stream")
    func streamFailure() {
        var reader = WritingCheckStream()
        #expect(throws: RealtimeServiceError.self) { _ = try reader.receive(#"data: {"type":"response.failed"}"#) }
    }

    @Test("The corrected text keeps the learner's line breaks and what was right")
    func correctedText() {
        #expect(Self.check.correctedText(of: Self.text)
                == "Liebe Frau Schmidt,\nich möchte Sie zum Kaffee einladen. Es gibt Kuchen.\nViele Grüße")
        // A sentence the server wrote differently can't be laid over the text: its own version is used.
        #expect(Self.check.correctedText(of: "Something else") == Self.check.corrected)
    }

    @Test("Without cloud use, nothing is sent")
    func cloudOff() async {
        var sent = false
        let service = CloudWritingService(send: { _ in sent = true; return Data() },
                                          stream: { _, _ in sent = true }, allowed: { false })
        await #expect(throws: RealtimeServiceError.self) { try await service.task(for: .a1, length: .standard, kind: nil, excluding: []) }
        await #expect(throws: RealtimeServiceError.self) {
            try await service.check("Hallo", for: WritingTasks.a1[0]) { _ in }
        }
        #expect(!sent)
    }

    // MARK: Writing and saving

    @Test("Counting words leaves out punctuation on its own")
    func words() {
        #expect(WriteModel.words(in: "Hallo Tim , wie geht's?\n\nBis bald – Anna") == 7)
        #expect(WriteModel.words(in: "   ") == 0)
    }

    @Test("A checked text is kept in Your sessions and its fixes in Fix your mistakes, once")
    func savesSessionAndMistakes() async throws {
        let container = try AlltagStore.makeContainer(inMemory: true)
        let context = container.mainContext
        let stub = StubWriting(Self.check)
        let model = WriteModel(task: WritingTasks.a2[2], service: stub)
        model.text = Self.text
        await model.runCheck()
        #expect(model.phase == .checked)
        #expect(stub.progress.map(\.count) == [1, 2, 3, 4])
        model.save(in: context)

        let records = try context.fetch(FetchDescriptor<SessionRecord>())
        #expect(records.count == 1)
        #expect(records.first?.kind == .writing)
        #expect(records.first?.fixCount == 1)
        let mistakes = try context.fetch(FetchDescriptor<MemoryItem>())
        #expect(mistakes.map(\.mistakeOriginal) == ["ich möchte sie zu Kaffee einladen."])
        #expect(mistakes.first?.source == .writing)
        #expect(model.savedMistakes == 1)

        // Checking again after an edit updates the same session and saves no mistake twice.
        model.edit()
        await model.runCheck()
        model.save(in: context)
        #expect(try context.fetch(FetchDescriptor<SessionRecord>()).count == 1)
        #expect(try context.fetch(FetchDescriptor<MemoryItem>()).count == 1)
        #expect(try context.fetch(FetchDescriptor<PracticeSession>()).count == 1)
    }

    @Test("A failed check says why and keeps the text")
    func failure() async {
        let stub = StubWriting(Self.check)
        stub.error = URLError(.notConnectedToInternet)
        let model = WriteModel(task: WritingTasks.a1[0], service: stub)
        model.text = "Hallo Lena, kommst du?"
        await model.runCheck()
        #expect(model.phase == .failed(.offline))
        #expect(model.text == "Hallo Lena, kommst du?")
    }

    @Test("Two words are too few to check")
    func tooShort() {
        let model = WriteModel(task: WritingTasks.a1[0], service: StubWriting(Self.check))
        model.text = "Hallo Lena"
        #expect(!model.canCheck)
    }
}
