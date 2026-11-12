//
//  CloudCompanionTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 13.11.26.
//

import Foundation
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

    private func makeCompanion(allowed: Bool = true, check: @escaping CloudCompanionService.Check) -> CloudCompanionService {
        CloudCompanionService(onDevice: MockCompanionService(thinkingTime: .zero), isAllowed: { allowed }, check: check)
    }
}
