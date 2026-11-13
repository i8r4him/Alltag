//
//  CloudCompanionService.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 13.11.26.
//

import Foundation
import FoundationModels
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

/// The companion with a better ear for mistakes. A sentence is judged by the
/// cheapest model that is good enough, in this order:
/// 1. **Apple's cloud model** (Private Cloud Compute), when it is available. It
///    costs the app nothing; the learner has a daily quota from Apple.
/// 2. **OpenAI** through the `check-german` Edge Function, when the learner has
///    allowed cloud use.
/// 3. **The on-device companion.**
/// Each one that fails or isn't allowed hands on to the next. Everything else
/// is the on-device companion's.
final class CloudCompanionService: CompanionService {
    typealias Check = (SentenceCheckRequest) async throws -> Data

    private let onDevice: any CompanionService
    private let appleCloud: any LanguageModelClient
    private let isAppleCloudAvailable: () -> Bool
    private let isAllowed: () -> Bool
    private let check: Check
    private let logger = Logger(subsystem: "i8r4him.Alltag", category: "Companion")

    init(onDevice: any CompanionService = OnDeviceCompanionService(),
         appleCloud: any LanguageModelClient = PrivateCloudLanguageModelClient(),
         isAppleCloudAvailable: @escaping () -> Bool = { PrivateCloudLanguageModelClient.isAvailable },
         isAllowed: @escaping () -> Bool = { UserDefaults.standard.bool(forKey: "usesCloudForPro") },
         check: @escaping Check = { try await SupabaseRealtimeClient.shared.post(to: "check-german", body: $0.body) }) {
        self.onDevice = onDevice
        self.appleCloud = appleCloud
        self.isAppleCloudAvailable = isAppleCloudAvailable
        self.isAllowed = isAllowed
        self.check = check
    }

    var usesOnDeviceModel: Bool { onDevice.usesOnDeviceModel }
    var canCheckSentences: Bool { isAppleCloudAvailable() || isAllowed() || onDevice.canCheckSentences }

    func respond(to learnerText: String, in scenario: Scenario, turn: Int) async throws -> CompanionResponse {
        try await onDevice.respond(to: learnerText, in: scenario, turn: turn)
    }

    func feedback(on sentence: String, in scenario: Scenario, replyingTo previous: String?) async throws -> SentenceFeedback {
        if isAppleCloudAvailable() {
            do {
                let prompt = CompanionPrompt.feedback(on: sentence, in: scenario, replyingTo: previous)
                return SentenceFeedback(try await askAppleCloud(prompt))
            } catch is CancellationError {
                throw CancellationError()
            } catch {
                logger.error("Apple's cloud model didn't check the sentence: \(String(describing: error), privacy: .public)")
            }
        }
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

    /// The model's first request after a while can fail while it wakes up, so it is asked twice.
    private func askAppleCloud(_ prompt: String) async throws -> GeneratedFeedback {
        do {
            return try await appleCloud.generate(GeneratedFeedback.self, instructions: CompanionPrompt.checkInstructions, prompt: prompt)
        } catch is CancellationError {
            throw CancellationError()
        } catch {
            return try await appleCloud.generate(GeneratedFeedback.self, instructions: CompanionPrompt.checkInstructions, prompt: prompt)
        }
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
