//
//  ChatModelTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import SwiftData
import Testing
@testable import Alltag

@Suite("Learn › Write › Text a friend")
@MainActor
struct ChatModelTests {
    static let turn = ChatTurn(
        replies: [ChatMessage(from: "Lena", text: "Super! 😊", english: "Great!"),
                  ChatMessage(from: "Lena", text: "Um acht?", english: "At eight?")],
        feedback: Feedback(kind: .fix, title: "Infinitive after „will“", note: "Say „sehen“.",
                           correction: "ich will den film sehen"),
        english: "I want to see the film")

    private var lena: WritingChat { WritingContent.chats(at: .b1)[0] }

    @Test("The friend's last message starts the chat")
    func opener() {
        let model = ChatModel(chat: lena, level: .b1, service: StubWriting(), pause: .zero)
        #expect(model.messages.count == 1)
        #expect(model.messages.first?.from == "Lena")
        #expect(model.messages.first?.text == lena.preview)
        let group = ChatModel(chat: WritingContent.chats(at: .b1)[1], level: .b1, service: StubWriting(), pause: .zero)
        #expect(group.messages.first?.from == WritingChat.groupOpener)
    }

    @Test("Sending adds the learner's message, its check and the friend's replies")
    func send() async {
        let stub = StubWriting()
        let model = ChatModel(chat: lena, level: .b1, service: stub, pause: .zero)
        model.draft = "  ich will den film sieht  "
        await model.send()
        #expect(model.draft.isEmpty)
        #expect(model.phase == .idle)
        #expect(model.messages.map(\.text) == [lena.preview, "ich will den film sieht", "Super! 😊", "Um acht?"])
        #expect(model.messages[1].feedback?.kind == .fix)
        #expect(model.messages[1].english == "I want to see the film")
        #expect(stub.chats.first?.messages.last?.isLearner == true)
        #expect(stub.chats.first?.wrapUp == false)
        #expect(model.fixCount == 1)
    }

    @Test("An empty message isn't sent")
    func empty() async {
        let stub = StubWriting()
        let model = ChatModel(chat: lena, level: .b1, service: stub, pause: .zero)
        model.draft = "   "
        #expect(!model.canSend)
        await model.send()
        #expect(stub.chats.isEmpty)
    }

    @Test("After the last message the friend wraps up and the chat ends")
    func wrapUp() async {
        let stub = StubWriting()
        let model = ChatModel(chat: lena, level: .b1, service: stub, pause: .zero)
        for number in 1...ChatModel.limit {
            model.draft = "Nachricht \(number)"
            await model.send()
        }
        #expect(stub.chats.map(\.wrapUp) == Array(repeating: false, count: ChatModel.limit - 1) + [true])
        #expect(model.phase == .ended)
        model.draft = "Noch was"
        #expect(!model.canSend)
    }

    @Test("A failed reply keeps the message and asks again on retry")
    func failure() async {
        let stub = StubWriting()
        stub.error = URLError(.notConnectedToInternet)
        let model = ChatModel(chat: lena, level: .b1, service: stub, pause: .zero)
        model.draft = "Hallo!"
        await model.send()
        #expect(model.phase == .failed(.offline))
        #expect(model.messages.last?.text == "Hallo!")
        stub.error = nil
        await model.retry()
        #expect(model.phase == .idle)
        #expect(stub.chats.count == 2)
        #expect(model.messages.count == 4)
    }

    @Test("The chat is kept in Your sessions and its fixes in Fix your mistakes, turn by turn")
    func saves() async throws {
        let container = try AlltagStore.makeContainer(inMemory: true)
        let context = container.mainContext
        let model = ChatModel(chat: lena, level: .b1, service: StubWriting(), pause: .zero)
        model.draft = "ich will den film sieht"
        await model.send(in: context)
        model.draft = "ich will den film sieht"
        await model.send(in: context)

        let records = try context.fetch(FetchDescriptor<SessionRecord>())
        #expect(records.count == 1)
        #expect(records.first?.kind == .writing)
        #expect(records.first?.title == "Lena")
        #expect(records.first?.lines.count == 7)
        let mistakes = try context.fetch(FetchDescriptor<MemoryItem>())
        #expect(mistakes.count == 1)
        #expect(mistakes.first?.source == .writing)
        #expect(mistakes.first?.sourceDetail == "Lena")
        #expect(model.savedMistakes == 1)
    }

    @Test("The chat request names the friend, the chat so far and the wrap-up")
    func request() async throws {
        var sent: [String: String] = [:]
        let answer = """
        {"replies":[{"from":"Mia","text":"Ich kaufe Milch 🥛","english":"I'll buy milk"},{"from":"","text":"Danke!","english":"Thanks!"}],
        "check":{"kind":"note","title":"Too formal","note":"Friends say „Kannst du…“.","correction":"kannst du milch kaufen?",
        "english":"Could you buy milk?"},"usage":{"model":"gpt-6-luna"}}
        """
        let service = CloudWritingService(send: { body in sent = body; return Data(answer.utf8) },
                                          stream: { _, _ in }, allowed: { true })
        let group = WritingContent.chats(at: .a2)[1]
        let messages = [ChatMessage(from: "Mia", text: group.preview),
                        ChatMessage(from: nil, text: "Könnten Sie bitte Milch kaufen?")]
        let turn = try await service.reply(to: messages, in: group, level: .a2, wrapUp: true)
        #expect(sent["action"] == "chat")
        #expect(sent["contact"] == "wg")
        #expect(sent["level"] == "A2")
        #expect(sent["wrap_up"] == "true")
        let lines = try JSONDecoder().decode([ServerChat.Line].self, from: Data((sent["messages"] ?? "").utf8))
        #expect(lines.map(\.from) == ["Mia", "me"])
        #expect(turn.replies.map(\.from) == ["Mia", WritingChat.groupOpener])
        #expect(turn.feedback.kind == .note)
        #expect(turn.feedback.correction == "kannst du milch kaufen?")
        #expect(turn.english == "Could you buy milk?")
    }

    @Test("An answer without replies is not a turn")
    func emptyAnswer() {
        let answer = ServerChat(replies: [], check: CheckedSentence(kind: "good", title: "", note: "", english: "", correction: ""))
        #expect(throws: RealtimeServiceError.self) { try answer.turn(friend: "Lena") }
    }
}
