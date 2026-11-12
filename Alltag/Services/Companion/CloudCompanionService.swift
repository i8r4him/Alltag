//
//  CloudCompanionService.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 13.11.26.
//

import Foundation
import OSLog

/// What the server's sentence check is asked: text only, never audio.
struct SentenceCheckRequest: Equatable, Sendable {
    var sentence: String
    /// What the other person said before, when there was someone.
    var previous: String?
    /// The situation or topic, in a few words.
    var context: String

    var body: [String: String] {
        var body = ["sentence": sentence, "context": context]
        if let previous { body["previous"] = previous }
        return body
    }
}

/// The companion with a better ear for mistakes: sentences are judged by
/// OpenAI through the `check-german` Edge Function when the learner has
/// allowed cloud use, and by the on-device companion otherwise or when the
/// server can't be reached. Everything else is the on-device companion's.
final class CloudCompanionService: CompanionService {
    typealias Check = (SentenceCheckRequest) async throws -> Data

    private let onDevice: any CompanionService
    private let isAllowed: () -> Bool
    private let check: Check
    private let logger = Logger(subsystem: "i8r4him.Alltag", category: "Companion")

    init(onDevice: any CompanionService = OnDeviceCompanionService(),
         isAllowed: @escaping () -> Bool = { UserDefaults.standard.bool(forKey: "usesCloudForPro") },
         check: @escaping Check = { try await SupabaseRealtimeClient.shared.post(to: "check-german", body: $0.body) }) {
        self.onDevice = onDevice
        self.isAllowed = isAllowed
        self.check = check
    }

    var usesOnDeviceModel: Bool { onDevice.usesOnDeviceModel }
    var canCheckSentences: Bool { isAllowed() || onDevice.canCheckSentences }

    func respond(to learnerText: String, in scenario: Scenario, turn: Int) async throws -> CompanionResponse {
        try await onDevice.respond(to: learnerText, in: scenario, turn: turn)
    }

    func feedback(on sentence: String, in scenario: Scenario, replyingTo previous: String?) async throws -> SentenceFeedback {
        if isAllowed() {
            do {
                let context = [scenario.title, scenario.goal].filter { !$0.isEmpty }.joined(separator: ". ")
                let data = try await check(SentenceCheckRequest(sentence: sentence, previous: previous, context: context))
                return SentenceFeedback(try JSONDecoder().decode(CheckedSentence.self, from: data))
            } catch is CancellationError {
                throw CancellationError()
            } catch {
                logger.error("The server's check failed, checking on device: \(String(describing: error), privacy: .public)")
            }
        }
        return try await onDevice.feedback(on: sentence, in: scenario, replyingTo: previous)
    }

    func debrief(_ input: String, about moment: Debrief) async throws -> Debrief {
        try await onDevice.debrief(input, about: moment)
    }
}

/// The server's answer about one sentence.
struct CheckedSentence: Decodable {
    let kind: String
    let title: String
    let note: String
    let english: String
    let correction: String
}

extension SentenceFeedback {
    init(_ checked: CheckedSentence) {
        let kind: Feedback.Kind = switch checked.kind {
        case "fix": .fix
        case "note": .note
        default: .good
        }
        let correction = checked.correction.trimmingCharacters(in: .whitespacesAndNewlines)
        self.init(feedback: Feedback(kind: kind, title: checked.title, note: checked.note,
                                     correction: kind == .good || correction.isEmpty ? nil : correction),
                  english: checked.english)
    }
}
