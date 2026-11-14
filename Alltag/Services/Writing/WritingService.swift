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

/// Learn › Write's teacher: new tasks for the learner's level, and the correction of a text.
protocol WritingService {
    /// A new task for `level`, unlike the tasks titled in `excluding`.
    func task(for level: Level, excluding: [String]) async throws -> WritingTask
    /// Corrects `text`, written for `task`. `onProgress` gets the sentences checked so far, as they arrive.
    func check(_ text: String, for task: WritingTask,
               onProgress: @escaping ([WritingSentence]) -> Void) async throws -> WritingCheck
}

/// Asks the `write` Edge Function, which asks OpenAI. Only when the learner has allowed cloud use.
///
/// The text goes straight to OpenAI: the on-device model can't mark a whole text well enough,
/// and Apple's cloud model is switched off until the app has its entitlement
/// (`PrivateCloudLanguageModelClient.isEntitled`). When it is on, it can take the check here first.
struct CloudWritingService: WritingService {
    typealias Send = ([String: String]) async throws -> Data
    typealias Stream = ([String: String], (String) throws -> Void) async throws -> Void

    var send: Send = { try await SupabaseRealtimeClient.shared.post(to: "write", body: $0) }
    var stream: Stream = { try await SupabaseRealtimeClient.shared.stream(to: "write", body: $0, onLine: $1) }
    var allowed: () -> Bool = { UserDefaults.standard.bool(forKey: "usesCloudForPro") }

    func task(for level: Level, excluding: [String]) async throws -> WritingTask {
        guard allowed() else { throw RealtimeServiceError.unavailable }
        let body = ["action": "task", "level": level.rawValue, "exclude": excluding.suffix(20).joined(separator: "; ")]
        let task = try JSONDecoder().decode(ServerWritingTask.self, from: await send(body))
        return try task.task(for: level)
    }

    func check(_ text: String, for task: WritingTask,
               onProgress: @escaping ([WritingSentence]) -> Void) async throws -> WritingCheck {
        guard allowed() else { throw RealtimeServiceError.unavailable }
        let body = ["action": "check", "level": task.level.rawValue, "task": task.brief, "text": text, "stream": "true"]
        var reader = WritingCheckStream()
        try await stream(body) { line in
            if let sentences = try reader.receive(line) { onProgress(sentences) }
        }
        return try reader.finish()
    }
}

/// A task as the server writes it.
struct ServerWritingTask: Decodable {
    let title: String
    let situation: String
    let recipient: String
    let register: String
    let points: [String]
    let minWords: Int
    let maxWords: Int
    let symbol: String
    let phrases: [WritingTask.Phrase]

    enum CodingKeys: String, CodingKey {
        case title, situation, recipient, register, points, symbol, phrases
        case minWords = "min_words", maxWords = "max_words"
    }

    func task(for level: Level) throws -> WritingTask {
        guard !title.isEmpty, !situation.isEmpty, points.count >= 2 else { throw RealtimeServiceError.unexpectedResponse }
        let range = WritingTask.wordRange(for: level)
        // The server keeps to the level's range; a number out of it is the model's slip, not the task.
        let minimum = range.contains(minWords) ? minWords : range.lowerBound
        let maximum = range.contains(maxWords) && maxWords > minimum ? maxWords : range.upperBound
        return WritingTask(id: "new-\(UUID().uuidString)", level: level, title: title, situation: situation,
                           recipient: recipient, register: register == "informal" ? .informal : .formal,
                           points: Array(points.prefix(3)), minWords: minimum, maxWords: maximum,
                           systemImage: symbol.isEmpty ? "square.and.pencil" : symbol,
                           phrases: Array(phrases.prefix(4)), isGenerated: true)
    }
}

/// Shows sample tasks and a sample correction, for previews.
struct MockWritingService: WritingService {
    func task(for level: Level, excluding: [String]) async throws -> WritingTask {
        try await Task.sleep(for: .milliseconds(800))
        var task = WritingTasks.tasks(for: level).last ?? WritingTasks.a2[0]
        task.isGenerated = true
        return task
    }

    func check(_ text: String, for task: WritingTask,
               onProgress: @escaping ([WritingSentence]) -> Void) async throws -> WritingCheck {
        let sentences = [
            WritingSentence(id: 0, original: "Liebe Frau Schmidt,",
                            feedback: Feedback(kind: .good, title: "A friendly greeting", note: "Right for a neighbour."),
                            english: "Dear Frau Schmidt,"),
            WritingSentence(id: 1, original: "ich möchte sie am Sonntag zu Kaffee einladen.",
                            feedback: Feedback(kind: .fix, title: "Sie and zum",
                                               note: "Write „Sie“ with a capital, and say „zum Kaffee“.",
                                               correction: "ich möchte Sie am Sonntag zum Kaffee einladen."),
                            english: "I'd like to invite you for coffee on Sunday.")
        ]
        for count in sentences.indices {
            try await Task.sleep(for: .milliseconds(600))
            onProgress(Array(sentences.prefix(count + 1)))
        }
        return WritingCheck(sentences: sentences,
                            corrected: "Liebe Frau Schmidt,\nich möchte Sie am Sonntag zum Kaffee einladen.",
                            points: [.init(covered: true, note: "You say Sunday."), .init(covered: false, note: "No time yet."),
                                     .init(covered: false, note: "Ask her to answer by Friday.")],
                            summary: "A warm start. Next, remember the capital in „Sie“.")
    }
}
