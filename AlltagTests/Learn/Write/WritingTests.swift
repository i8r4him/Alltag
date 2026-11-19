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

/// Answers with a fixed correction, handing the sentences on one by one, and with a fixed chat turn.
@MainActor
final class StubWriting: WritingService {
    var check: WritingCheck
    var turn: ChatTurn
    var error: (any Error)?
    private(set) var progress: [[WritingSentence]] = []
    private(set) var briefs: [WritingBrief] = []
    private(set) var chats: [(messages: [ChatMessage], wrapUp: Bool)] = []

    init(_ check: WritingCheck = WritingTests.check, turn: ChatTurn = ChatModelTests.turn) {
        self.check = check
        self.turn = turn
    }

    func check(_ text: String, for brief: WritingBrief,
               onProgress: @escaping ([WritingSentence]) -> Void) async throws -> WritingCheck {
        briefs.append(brief)
        if let error { throw error }
        for count in check.sentences.indices {
            let sentences = Array(check.sentences.prefix(count + 1))
            progress.append(sentences)
            onProgress(sentences)
        }
        return check
    }

    func reply(to messages: [ChatMessage], in chat: WritingChat, level: Level, wrapUp: Bool) async throws -> ChatTurn {
        chats.append((messages, wrapUp))
        if let error { throw error }
        return turn
    }
}

@Suite("Learn › Write")
@MainActor
struct WritingTests {
    static let text = "Sehr geehrte Frau Weber,\nich bin krank. Ich kann morgen nicht komme.\nViele Grüße"

    static let check = WritingCheck(
        sentences: [
            WritingSentence(id: 0, original: "Sehr geehrte Frau Weber,", feedback: Feedback(kind: .good, title: "Greeting", note: "Good."),
                            english: "Dear Ms Weber,"),
            WritingSentence(id: 1, original: "ich bin krank.", feedback: Feedback(kind: .good, title: "Clear", note: "Good."),
                            english: "I'm ill."),
            WritingSentence(id: 2, original: "Ich kann morgen nicht komme.",
                            feedback: Feedback(kind: .fix, title: "Infinitive after „kann“", note: "Say „kommen“.",
                                               correction: "Ich kann morgen nicht kommen."),
                            english: "I can't come tomorrow."),
            WritingSentence(id: 3, original: "Viele Grüße", feedback: Feedback(kind: .good, title: "Sign-off", note: "Good."),
                            english: "Best wishes")
        ],
        corrected: "Sehr geehrte Frau Weber, ich bin krank. Ich kann morgen nicht kommen. Viele Grüße",
        points: [.init(covered: true, note: "Yes."), .init(covered: false, note: "No."), .init(covered: false, note: "No.")],
        summary: "Clear and polite.")

    // MARK: The written content

    @Test("Every level has a formal email with points, topics and chats the server knows")
    func content() {
        for level in Level.allCases {
            let task = WritingContent.formalTask(at: level)
            #expect(task != nil)
            #expect((task?.points.count ?? 0) >= 3)
            #expect(!(task?.title.isEmpty ?? true))
            #expect(WritingContent.topics(at: level).count == 3)
            let chats = WritingContent.chats(at: level)
            // The `write` function plays exactly these three.
            #expect(chats.map(\.id) == ["lena", "wg", "jonas"])
            #expect(chats.allSatisfy { !$0.preview.isEmpty })
        }
    }

    @Test("The topic of the day stays the same all day and changes the next")
    func topicOfTheDay() throws {
        let calendar = Calendar(identifier: .gregorian)
        let morning = try #require(calendar.date(from: DateComponents(year: 2026, month: 11, day: 19, hour: 8)))
        let evening = morning.addingTimeInterval(12 * 3600)
        let tomorrow = morning.addingTimeInterval(24 * 3600)
        let today = WritingContent.topic(at: .b1, on: morning, calendar: calendar)
        #expect(today == WritingContent.topic(at: .b1, on: evening, calendar: calendar))
        #expect(today != WritingContent.topic(at: .b1, on: tomorrow, calendar: calendar))
        #expect(WritingContent.topic(at: .c2, on: morning, calendar: calendar)?.level == .c1)
    }

    @Test("The brief the server reads names the email, the points and the length")
    func brief() throws {
        let task = try #require(WritingContent.formalTask(at: .b2))
        let brief = WritingBrief(task, level: .b2)
        #expect(brief.words == 100)
        #expect(brief.task.contains("about 100 words"))
        #expect(brief.task.contains("Hausverwaltung Becker"))
        #expect(brief.task.contains("1. Sie sind an diesem Vormittag nicht zu Hause"))
        #expect(brief.task.contains("4. Um eine schnelle Lösung bitten"))

        let topic = WritingBrief(try #require(WritingContent.topics(at: .a1).first), level: .a1)
        #expect(topic.points.isEmpty)
        #expect(topic.task.contains("No numbered points."))
        #expect(topic.words == 30)

        let form = WritingBrief(WritingContent.form, level: .a2)
        #expect(form.fields == ["Name", "Kurs"])
        #expect(form.task.contains("Warum möchten Sie Deutsch lernen?"))
        // C2 writes C1's letter, at C2's length.
        let letter = WritingBrief(try #require(WritingContent.formalTask(at: .c2)), level: .c2)
        #expect(letter.level == .c2)
        #expect(letter.words == 150)
    }

    // MARK: The server

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

    @Test("A check sends the level, the brief and the text, streamed")
    func checkRequest() async throws {
        var sent: [String: String] = [:]
        let service = CloudWritingService(send: { _ in Data() }, stream: { body, _ in sent = body }, allowed: { true })
        let brief = WritingBrief(WritingContent.form, level: .a1)
        _ = try? await service.check("Ich lerne Deutsch für die Arbeit.", for: brief) { _ in }
        #expect(sent["action"] == "check")
        #expect(sent["level"] == "A1")
        #expect(sent["task"] == brief.task)
        #expect(sent["stream"] == "true")
    }

    @Test("Without cloud use, nothing is sent")
    func cloudOff() async throws {
        var sent = false
        let service = CloudWritingService(send: { _ in sent = true; return Data() },
                                          stream: { _, _ in sent = true }, allowed: { false })
        let chat = try #require(WritingContent.chats(at: .a1).first)
        await #expect(throws: RealtimeServiceError.self) {
            try await service.check("Hallo", for: WritingBrief(WritingContent.form, level: .a1)) { _ in }
        }
        await #expect(throws: RealtimeServiceError.self) {
            try await service.reply(to: [ChatMessage(from: nil, text: "Hallo")], in: chat, level: .a1, wrapUp: false)
        }
        #expect(!sent)
    }

    @Test("The corrected text keeps the learner's line breaks and what was right")
    func correctedText() {
        #expect(Self.check.correctedText(of: Self.text)
                == "Sehr geehrte Frau Weber,\nich bin krank. Ich kann morgen nicht kommen.\nViele Grüße")
        #expect(Self.check.correctedText(of: "Something else") == Self.check.corrected)
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
        let stub = StubWriting()
        let task = try #require(WritingContent.formalTask(at: .a1))
        let model = WriteModel(brief: WritingBrief(task, level: .a1), service: stub)
        model.text = Self.text
        await model.runCheck()
        #expect(model.phase == .checked)
        #expect(stub.progress.map(\.count) == [1, 2, 3, 4])
        model.save(in: context)

        let records = try context.fetch(FetchDescriptor<SessionRecord>())
        #expect(records.count == 1)
        #expect(records.first?.kind == .writing)
        #expect(records.first?.title == "Nachricht an Frau Weber")
        #expect(records.first?.fixCount == 1)
        let mistakes = try context.fetch(FetchDescriptor<MemoryItem>())
        #expect(mistakes.map(\.mistakeOriginal) == ["Ich kann morgen nicht komme."])
        #expect(mistakes.first?.source == .writing)
        #expect(model.savedMistakes == 1)

        // Checking again after an edit updates the same session and saves no mistake twice.
        model.edit()
        await model.runCheck()
        model.save(in: context)
        #expect(try context.fetch(FetchDescriptor<SessionRecord>()).count == 1)
        #expect(try context.fetch(FetchDescriptor<MemoryItem>()).count == 1)
        #expect(try context.fetch(FetchDescriptor<PracticeSession>()).count == 1)
        #expect(SkillProgress.writing(try context.fetch(FetchDescriptor<SessionRecord>())) == .written(1))
    }

    @Test("A failed check says why and keeps the text")
    func failure() async {
        let stub = StubWriting()
        stub.error = URLError(.notConnectedToInternet)
        let model = WriteModel(brief: WritingBrief(WritingContent.form, level: .a1), service: stub)
        model.text = "Ich lerne Deutsch für meine Arbeit."
        await model.runCheck()
        #expect(model.phase == .failed(.offline))
        #expect(model.text == "Ich lerne Deutsch für meine Arbeit.")
    }

    @Test("Two words are too few to check")
    func tooShort() {
        let model = WriteModel(brief: WritingBrief(WritingContent.form, level: .a1), service: StubWriting())
        model.text = "Hallo Lena"
        #expect(!model.canCheck)
    }
}
