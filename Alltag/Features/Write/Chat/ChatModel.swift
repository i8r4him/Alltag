//
//  ChatModel.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import SwiftData

/// A chat with a German friend, or the flat's group: the learner texts, the friend
/// answers in casual German at the learner's level, and each of the learner's
/// messages is checked quietly. After `limit` messages the friend says goodbye.
/// The chat is kept in Your sessions and its fixes in Fix your mistakes, turn by turn.
@Observable
final class ChatModel {
    enum Phase: Equatable {
        case idle
        /// The friend is typing.
        case waiting
        case failed(CloudFailure)
        /// The friend said goodbye.
        case ended
    }

    /// How many messages the learner writes before the friend ends the chat.
    static let limit = 8

    let chat: WritingChat
    let level: Level
    var draft = ""
    private(set) var messages: [ChatMessage]
    private(set) var phase = Phase.idle
    /// How many fixes were new to Fix your mistakes.
    private(set) var savedMistakes = 0

    @ObservationIgnored private let service: any WritingService
    /// The wait between two of the friend's messages, so they arrive like texts.
    @ObservationIgnored private let pause: Duration
    @ObservationIgnored private var record: SessionRecord?
    @ObservationIgnored private let startedAt: Date

    init(chat: WritingChat, level: Level, service: any WritingService, pause: Duration = .milliseconds(900),
         now: Date = .now) {
        self.chat = chat
        self.level = level
        self.service = service
        self.pause = pause
        self.startedAt = now
        // The friend's last message, as the list shows it, starts the chat.
        let opener = chat.groupImage == nil ? chat.contact : WritingChat.groupOpener
        messages = [ChatMessage(from: opener, text: chat.preview)]
    }

    var learnerCount: Int { messages.count { $0.isLearner } }
    var fixCount: Int { messages.count { $0.feedback?.kind == .fix } }
    var canSend: Bool {
        phase != .waiting && phase != .ended && !draft.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    /// Sends the draft and waits for the friend.
    func send(in context: ModelContext? = nil) async {
        guard canSend else { return }
        let text = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        draft = ""
        messages.append(ChatMessage(from: nil, text: text))
        await answer(in: context)
    }

    /// Asks again after a failure, for the message that is still unanswered.
    func retry(in context: ModelContext? = nil) async {
        guard case .failed = phase, messages.last?.isLearner == true else { return }
        await answer(in: context)
    }

    private func answer(in context: ModelContext?) async {
        phase = .waiting
        let wrapUp = learnerCount >= Self.limit
        do {
            let turn = try await service.reply(to: messages, in: chat, level: level, wrapUp: wrapUp)
            if let index = messages.indices.last {
                messages[index].feedback = turn.feedback
                messages[index].english = turn.english
            }
            for (number, reply) in turn.replies.enumerated() {
                if number > 0 { try await Task.sleep(for: pause) }
                messages.append(reply)
            }
            phase = wrapUp ? .ended : .idle
            if let context { save(in: context) }
        } catch is CancellationError {
            phase = .idle
        } catch {
            phase = .failed(CloudFailure(error))
        }
    }

    /// Keeps the chat in Your sessions and the fixes in Fix your mistakes. Each turn updates the same session.
    func save(in context: ModelContext, now: Date = .now) {
        guard learnerCount > 0 else { return }
        let lines = messages.map {
            SessionLine(isLearner: $0.isLearner, german: $0.text, english: $0.english, feedback: $0.feedback.map { .init($0) })
        }
        if let record {
            record.lines = lines
        } else {
            let record = SessionRecord(kind: .writing, title: chat.contact, lines: lines, date: startedAt)
            context.insert(record)
            context.insert(PracticeSession(kind: .writing, date: startedAt))
            self.record = record
        }
        let items = messages.filter(\.isLearner).compactMap { message in
            message.feedback.flatMap { feedback in
                MistakePractice.item(said: message.text, feedback: feedback, sourceDetail: chat.contact, source: .writing, at: now)
            }
        }
        savedMistakes += MistakePractice.save(items, in: context)
        try? context.save()
    }
}
