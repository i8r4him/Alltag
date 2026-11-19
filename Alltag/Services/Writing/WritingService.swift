//
//  WritingService.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// One sentence of the learner's text, as the teacher marked it.
struct WritingSentence: Hashable, Identifiable, Sendable {
    /// Its place in the text, from 0.
    let id: Int
    /// Exactly as the learner wrote it.
    let original: String
    let feedback: Feedback
    /// What it means in English.
    let english: String
}

/// The whole correction of a text.
struct WritingCheck: Hashable, Sendable {
    /// Whether the text says one of the task's points.
    struct Point: Hashable, Sendable {
        let covered: Bool
        let note: String
    }

    let sentences: [WritingSentence]
    /// The text as it should read, from the server.
    let corrected: String
    /// One for each of the task's points, in order.
    let points: [Point]
    /// What went well and the one thing to practise next.
    let summary: String

    var fixCount: Int { sentences.filter { $0.feedback.kind == .fix }.count }

    /// The learner's own text with each marked sentence replaced by its correction,
    /// so the line breaks and everything that was right stay exactly as written.
    /// Falls back to the server's version when a sentence can't be found in the text.
    func correctedText(of text: String) -> String {
        var result = ""
        var rest = text[...]
        for sentence in sentences {
            guard let range = rest.range(of: sentence.original) else { return corrected }
            result += rest[..<range.lowerBound]
            result += sentence.feedback.correction ?? sentence.original
            rest = rest[range.upperBound...]
        }
        return result + rest
    }
}

/// One message in a chat with a friend.
struct ChatMessage: Identifiable, Hashable, Sendable {
    let id: UUID
    /// Who wrote it: the friend's name (in a group, the flatmate's); `nil` for the learner.
    let from: String?
    let text: String
    /// What it means in English.
    var english = ""
    /// For the learner's messages: how a German friend would read it.
    var feedback: Feedback?

    init(id: UUID = UUID(), from: String?, text: String, english: String = "", feedback: Feedback? = nil) {
        self.id = id
        self.from = from
        self.text = text
        self.english = english
        self.feedback = feedback
    }

    var isLearner: Bool { from == nil }
}

/// The friend's answer to the learner's last message, and the check of that message.
struct ChatTurn: Hashable, Sendable {
    let replies: [ChatMessage]
    let feedback: Feedback
    /// What the learner's message means in English.
    let english: String
}

/// Learn › Write's teacher: corrects a text, and plays the friend in a chat.
protocol WritingService {
    /// Corrects `text`, written for `brief`. `onProgress` gets the sentences checked so far, as they arrive.
    func check(_ text: String, for brief: WritingBrief,
               onProgress: @escaping ([WritingSentence]) -> Void) async throws -> WritingCheck
    /// The friend's answer to `messages` (the last one is the learner's) in `chat`, at the learner's `level`.
    /// With `wrapUp`, the friend ends the chat.
    func reply(to messages: [ChatMessage], in chat: WritingChat, level: Level, wrapUp: Bool) async throws -> ChatTurn
}

/// Asks the `write` Edge Function, which asks OpenAI. Only when the learner has allowed cloud use.
///
/// The text goes straight to OpenAI: the on-device model can't mark a whole text or play a
/// friend in casual German well enough, and Apple's cloud model is switched off until the app
/// has its entitlement (`PrivateCloudLanguageModelClient.isEntitled`).
struct CloudWritingService: WritingService {
    typealias Send = ([String: String]) async throws -> Data
    typealias Stream = ([String: String], (String) throws -> Void) async throws -> Void

    var send: Send = { try await SupabaseRealtimeClient.shared.post(to: "write", body: $0) }
    var stream: Stream = { try await SupabaseRealtimeClient.shared.stream(to: "write", body: $0, onLine: $1) }
    var allowed: () -> Bool = { UserDefaults.standard.bool(forKey: "usesCloudForPro") }

    func check(_ text: String, for brief: WritingBrief,
               onProgress: @escaping ([WritingSentence]) -> Void) async throws -> WritingCheck {
        guard allowed() else { throw RealtimeServiceError.unavailable }
        let body = ["action": "check", "level": brief.level.rawValue, "task": brief.task, "text": text, "stream": "true"]
        var reader = WritingCheckStream()
        try await stream(body) { line in
            if let sentences = try reader.receive(line) { onProgress(sentences) }
        }
        return try reader.finish()
    }

    func reply(to messages: [ChatMessage], in chat: WritingChat, level: Level, wrapUp: Bool) async throws -> ChatTurn {
        guard allowed() else { throw RealtimeServiceError.unavailable }
        let lines = messages.map { ServerChat.Line(from: $0.from ?? "me", text: $0.text) }
        let encoded = String(bytes: try JSONEncoder().encode(lines), encoding: .utf8) ?? "[]"
        var body = ["action": "chat", "level": level.rawValue, "contact": chat.id, "messages": encoded]
        if wrapUp { body["wrap_up"] = "true" }
        // A reply without a name is from the friend, or in a group from whoever opened it.
        let friend = chat.groupImage == nil ? chat.contact : WritingChat.groupOpener
        return try JSONDecoder().decode(ServerChat.self, from: await send(body)).turn(friend: friend)
    }
}

/// A chat answer as the server writes it.
struct ServerChat: Decodable {
    struct Line: Codable {
        let from: String
        let text: String
        var english: String?
    }

    let replies: [Line]
    let check: CheckedSentence

    /// The answer for the app: at least one reply, each from someone with a name.
    func turn(friend: String) throws -> ChatTurn {
        let replies = replies.filter { !$0.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
        guard !replies.isEmpty else { throw RealtimeServiceError.unexpectedResponse }
        let messages = replies.map {
            ChatMessage(from: $0.from.isEmpty || $0.from == "me" ? friend : $0.from, text: $0.text, english: $0.english ?? "")
        }
        return ChatTurn(replies: messages, feedback: SentenceFeedback(check).feedback, english: check.english)
    }
}

/// A sample correction and a friend who answers the same way, for previews.
struct MockWritingService: WritingService {
    func check(_ text: String, for brief: WritingBrief,
               onProgress: @escaping ([WritingSentence]) -> Void) async throws -> WritingCheck {
        let sentences = [
            WritingSentence(id: 0, original: "Sehr geehrte Frau Weber,",
                            feedback: Feedback(kind: .good, title: "A formal greeting", note: "Right for a teacher."),
                            english: "Dear Ms Weber,"),
            WritingSentence(id: 1, original: "ich kann morgen nicht kommen, weil ich bin krank.",
                            feedback: Feedback(kind: .fix, title: "Verb at the end after „weil“",
                                               note: "After „weil“ the verb goes to the end.",
                                               correction: "ich kann morgen nicht kommen, weil ich krank bin."),
                            english: "I can't come tomorrow because I'm ill.")
        ]
        for count in sentences.indices {
            try await Task.sleep(for: .milliseconds(500))
            onProgress(Array(sentences.prefix(count + 1)))
        }
        return WritingCheck(sentences: sentences,
                            corrected: "Sehr geehrte Frau Weber,\nich kann morgen nicht kommen, weil ich krank bin.",
                            points: brief.points.indices.map { .init(covered: $0 == 0, note: $0 == 0 ? "You say why." : "Missing.") },
                            summary: "A clear start. Next, put the verb at the end after „weil“.")
    }

    func reply(to messages: [ChatMessage], in chat: WritingChat, level: Level, wrapUp: Bool) async throws -> ChatTurn {
        try await Task.sleep(for: .milliseconds(700))
        let friend = chat.groupImage == nil ? chat.contact : "Mia"
        let replies = wrapUp
            ? [ChatMessage(from: friend, text: "Ok, bis später! 👋", english: "OK, see you later!")]
            : [ChatMessage(from: friend, text: "Cool! 😊", english: "Cool!"),
               ChatMessage(from: friend, text: "Und wann hast du Zeit?", english: "And when are you free?")]
        return ChatTurn(replies: replies,
                        feedback: Feedback(kind: .fix, title: "Verb second", note: "In German the verb comes second.",
                                           correction: "Heute habe ich Zeit."),
                        english: "I have time today.")
    }
}
