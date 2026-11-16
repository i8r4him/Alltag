//
//  CloudCompanionTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 13.11.26.
//

import Foundation
import FoundationModels
import Testing
@testable import Alltag

@MainActor
struct CloudCompanionTests {
    private let fixAnswer = Data("""
        {"kind": "fix", "title": "Verb comes second", "note": "After „Am Wochenende“ the verb comes next.",
         "english": "At the weekend I often go to the park.", "correction": "Am Wochenende gehe ich oft in den Park."}
        """.utf8)

    @Test("With cloud use allowed, the server judges the sentence and gets its context")
    func serverChecks() async throws {
        var asked: [SentenceCheckRequest] = []
        let companion = makeCompanion { request in
            asked.append(request)
            return fixAnswer
        }
        #expect(companion.canCheckSentences)
        #expect(!companion.usesOnDeviceModel)

        let answer = try await companion.feedback(on: "Am Wochenende ich gehe oft in den Park.", in: MockScenarios.dentist,
                                                  replyingTo: "Was machen Sie am Wochenende?")

        #expect(answer.feedback.kind == .fix)
        #expect(answer.feedback.correction == "Am Wochenende gehe ich oft in den Park.")
        #expect(answer.english == "At the weekend I often go to the park.")
        #expect(asked.count == 1)
        #expect(asked.first?.sentence == "Am Wochenende ich gehe oft in den Park.")
        #expect(asked.first?.previous == "Was machen Sie am Wochenende?")
        #expect(asked.first?.context.contains(MockScenarios.dentist.title) == true)
        #expect(asked.first?.body["previous"] == "Was machen Sie am Wochenende?")
    }

    @Test("A good sentence comes back without a correction")
    func goodSentence() async throws {
        let good = Data(#"{"kind": "good", "title": "Natural", "note": "Well said.", "english": "I live.", "correction": ""}"#.utf8)
        let companion = makeCompanion { _ in good }

        let answer = try await companion.feedback(on: "Ich wohne in Berlin.", in: MockScenarios.dentist, replyingTo: nil)

        #expect(answer.feedback.kind == .good)
        #expect(answer.feedback.correction == nil)
    }

    @Test("When the server fails, the on-device companion checks instead", arguments: [
        RealtimeServiceError.upstream, .dailyLimit, .busy, .unavailable
    ])
    func fallsBack(error: RealtimeServiceError) async throws {
        let companion = makeCompanion { _ in
            throw error
        }

        let answer = try await companion.feedback(on: "Ich wohne in Berlin.", in: MockScenarios.dentist, replyingTo: nil)

        #expect(answer.feedback == MockCompanionService.ownSentenceNote)
    }

    @Test("Without the learner's permission nothing is sent to the server")
    func notAllowed() async throws {
        var calls = 0
        let companion = makeCompanion(allowed: false) { _ in
            calls += 1
            return fixAnswer
        }
        #expect(!companion.canCheckSentences)

        let answer = try await companion.feedback(on: "Am Wochenende ich gehe.", in: MockScenarios.dentist, replyingTo: nil)

        #expect(calls == 0)
        #expect(answer.feedback == MockCompanionService.ownSentenceNote)
    }

    @Test("Apple's cloud model checks first, and OpenAI isn't asked")
    func appleCloudFirst() async throws {
        var serverCalls = 0
        let fix = GeneratedFeedback(kind: .fix, title: "Verb comes second", note: "After „Heute“ the verb comes next.",
                                    english: "Today the weather is nice.", correction: "Heute ist das Wetter schön.")
        let apple = StubAppleCloud(answers: [.success(fix)])
        let companion = CloudCompanionService(onDevice: MockCompanionService(thinkingTime: .zero), appleCloud: apple,
                                              isAppleCloudAvailable: { true }, isAllowed: { true }, check: { _ in
            serverCalls += 1
            return fixAnswer
        })
        #expect(companion.canCheckSentences)

        let answer = try await companion.feedback(on: "Heute das Wetter ist schön.", in: MockScenarios.dentist, replyingTo: nil)

        #expect(answer.feedback.correction == "Heute ist das Wetter schön.")
        #expect(serverCalls == 0)
        #expect(apple.prompts.first?.contains("Heute das Wetter ist schön.") == true)
        #expect(apple.instructions.first == CompanionPrompt.checkInstructions)
    }

    @Test("Apple's cloud model is asked twice before OpenAI takes over")
    func appleCloudFails() async throws {
        let apple = StubAppleCloud(answers: [.failure(CocoaError(.featureUnsupported)), .failure(CocoaError(.featureUnsupported))])
        let companion = CloudCompanionService(onDevice: MockCompanionService(thinkingTime: .zero), appleCloud: apple,
                                              isAppleCloudAvailable: { true }, isAllowed: { true }, check: { _ in fixAnswer })

        let answer = try await companion.feedback(on: "Am Wochenende ich gehe.", in: MockScenarios.dentist, replyingTo: nil)

        #expect(apple.prompts.count == 2)
        #expect(answer.feedback.correction == "Am Wochenende gehe ich oft in den Park.")
    }

    @Test("A first failure of Apple's cloud model is tried again and can succeed")
    func appleCloudWakesUp() async throws {
        let good = GeneratedFeedback(kind: .good, title: "Natural", note: "Well said.", english: "I live in Berlin.", correction: "")
        let apple = StubAppleCloud(answers: [.failure(CocoaError(.featureUnsupported)), .success(good)])
        let companion = CloudCompanionService(onDevice: MockCompanionService(thinkingTime: .zero), appleCloud: apple,
                                              isAppleCloudAvailable: { true }, isAllowed: { false }, check: { _ in fixAnswer })

        let answer = try await companion.feedback(on: "Ich wohne in Berlin.", in: MockScenarios.dentist, replyingTo: nil)

        #expect(answer.feedback.kind == .good)
    }

    private func makeCompanion(allowed: Bool = true, check: @escaping CloudCompanionService.Check) -> CloudCompanionService {
        CloudCompanionService(onDevice: MockCompanionService(thinkingTime: .zero), appleCloud: StubAppleCloud(answers: []),
                              isAppleCloudAvailable: { false }, isAllowed: { allowed }, check: check)
    }
}

/// Apple's cloud model, answering from a list.
private final class StubAppleCloud: LanguageModelClient {
    private var answers: [Result<GeneratedFeedback, any Error>]
    private(set) var prompts: [String] = []
    private(set) var instructions: [String] = []

    init(answers: [Result<GeneratedFeedback, any Error>]) {
        self.answers = answers
    }

    func generate<Content: Generable>(_ type: Content.Type, instructions: String, prompt: String) async throws -> Content {
        prompts.append(prompt)
        self.instructions.append(instructions)
        guard !answers.isEmpty, let answer = try answers.removeFirst().get() as? Content else {
            throw CocoaError(.featureUnsupported)
        }
        return answer
    }
}
