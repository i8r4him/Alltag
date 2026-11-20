//
//  CompanionTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import FoundationModels
import Testing
@testable import Alltag

/// A companion that judges every own sentence the same way.
private final class StubCompanion: CompanionService {
    let script = MockCompanionService(thinkingTime: .zero)
    let answer: SentenceFeedback
    init(_ answer: SentenceFeedback) { self.answer = answer }

    var usesOnDeviceModel: Bool { true }
    func respond(to learnerText: String, in scenario: Scenario, turn: Int) async throws -> CompanionResponse {
        try await script.respond(to: learnerText, in: scenario, turn: turn)
    }
    func feedback(on sentence: String, in scenario: Scenario, replyingTo previous: String?) async throws -> SentenceFeedback {
        answer
    }
    func debrief(_ input: String, about moment: Debrief) async throws -> Debrief { moment }
}

/// A model that always fails with `error`, counting the requests.
private final class FailingModel: LanguageModelClient {
    let error: any Error
    private(set) var requests = 0
    init(_ error: any Error) { self.error = error }

    func generate<Content: Generable>(_ type: Content.Type, instructions: String, prompt: String) async throws -> Content {
        requests += 1
        throw error
    }
}

/// Live model tests run only on request: `TEST_RUNNER_ALLTAG_LIVE_MODEL=1 xcodebuild test …`.
/// The simulator can report the model as available without its assets.
private let runsLiveModelTests = ProcessInfo.processInfo.environment["ALLTAG_LIVE_MODEL"] == "1"
    && SystemLanguageModel.default.isAvailable

@Suite("On-device companion")
@MainActor
struct CompanionTests {
    private let fallback = MockCompanionService(thinkingTime: .zero)

    @Test("Without Apple Intelligence it falls back to the samples")
    func fallsBack() async throws {
        let companion = OnDeviceCompanionService(fallback: fallback, isModelAvailable: { false })
        #expect(!companion.usesOnDeviceModel)

        let own = try await companion.feedback(on: "Ich komme morgen.", in: MockScenarios.dentist, replyingTo: nil)
        #expect(own.feedback == MockCompanionService.ownSentenceNote)
        #expect(try await companion.debrief("nuts?", about: MockDebrief.bakery) == MockDebrief.bakery)
    }

    @Test("A broken model is left alone until relaunch, with the samples instead")
    func stopsAfterFailure() async throws {
        let model = FailingModel(CocoaError(.featureUnsupported))
        let companion = OnDeviceCompanionService(fallback: fallback, client: model, isModelAvailable: { true })
        #expect(companion.usesOnDeviceModel)

        #expect(try await companion.debrief("nuts?", about: MockDebrief.bakery) == MockDebrief.bakery)
        #expect(!companion.usesOnDeviceModel)
        _ = try await companion.feedback(on: "Hallo", in: MockScenarios.dentist, replyingTo: nil)
        #expect(model.requests == 1)
    }

    @Test("Conversations keep their scripted replies even with the model")
    func keepsScript() async throws {
        let companion = OnDeviceCompanionService(fallback: fallback, isModelAvailable: { true })
        let response = try await companion.respond(to: "Hallo", in: MockScenarios.dentist, turn: 0)
        #expect(response == (try await fallback.respond(to: "Hallo", in: MockScenarios.dentist, turn: 0)))
    }

    @Test("The feedback prompt gives the situation and what was just said")
    func feedbackPrompt() {
        let scenario = MockScenarios.dentist
        let previous = "Natürlich. Morgen hätten wir um 10:30 Uhr oder um 15 Uhr etwas frei."
        let prompt = CompanionPrompt.feedback(on: "Geht 15 Uhr?", in: scenario, replyingTo: previous)
        #expect(prompt.contains(scenario.title))
        #expect(prompt.contains("Natürlich. Morgen hätten wir um 10:30 Uhr oder um 15 Uhr etwas frei."))
        #expect(prompt.contains("„Geht 15 Uhr?“"))
    }

    @Test("Generated answers map onto the app's feedback and debrief")
    func mapping() {
        let feedback = SentenceFeedback(GeneratedFeedback(kind: .fix, title: "Verb second",
                                                          note: "Time first, then the verb.", english: "I'm coming tomorrow.",
                                                          correction: " Morgen komme ich. "))
        #expect(feedback.feedback.kind == .fix)
        #expect(feedback.feedback.correction == "Morgen komme ich.")
        let good = SentenceFeedback(GeneratedFeedback(kind: .good, title: "Natural", note: "Well said.",
                                                      english: "Hello", correction: "Hallo"))
        #expect(good.feedback.correction == nil)
        #expect(feedback.english == "I'm coming tomorrow.")

        let moment = MockDebrief.bakery
        let generated = GeneratedDebrief(phrases: [.init(german: "Ist da Milch drin?", english: "Is there milk in it?")],
                                         grammarTip: "drin + sein. Short for „darin“.")
        let debrief = Debrief(generated, for: moment)
        #expect(debrief.event == moment.event)
        #expect(debrief.phrasebookPlace == moment.phrasebookPlace)
        #expect(debrief.phrases.map(\.german) == ["Ist da Milch drin?"])
    }

    @Test("Your own sentence gets the companion's feedback and meaning")
    func conversationUsesFeedback() async {
        let answer = SentenceFeedback(feedback: Feedback(kind: .good, title: "Natural", note: "Well said."),
                                      english: "I'd like to come tomorrow.")
        let mock = AppServices.mock()
        let services = AppServices(speech: mock.speech, voice: mock.voice, translation: mock.translation,
                                   companion: StubCompanion(answer),
                                   notifications: mock.notifications)
        let model = ConversationModel(scenario: MockScenarios.dentist, services: services, timing: .instant)
        model.draft = "Ich möchte morgen kommen."
        await model.send()

        #expect(model.messages[1].line.feedback == answer.feedback)
        #expect(model.messages[1].line.english == answer.english)
        #expect(model.messages[2].line.speaker == .companion)
    }

    @Test("The on-device model writes a debrief", .enabled(if: runsLiveModelTests),
          .timeLimit(.minutes(1)))
    func liveDebrief() async throws {
        let companion = OnDeviceCompanionService(fallback: fallback)
        let debrief = try await companion.debrief("I wanted to ask if the bread is from today.", about: MockDebrief.bakery)
        #expect(debrief.phrases.count == 2)
        #expect(!debrief.grammarTip.isEmpty)
        #expect(debrief.phrases != MockDebrief.bakery.phrases, "Fell back to the sample")
    }

    @Test("The on-device model judges your own sentence", .enabled(if: runsLiveModelTests),
          .timeLimit(.minutes(1)))
    func liveFeedback() async throws {
        let companion = OnDeviceCompanionService(fallback: fallback)
        let own = try await companion.feedback(on: "Ich will kommen morgen um drei Uhr.", in: MockScenarios.dentist,
                                               replyingTo: "Morgen hätten wir um 10:30 Uhr oder um 15 Uhr etwas frei.")
        #expect(own.feedback != MockCompanionService.ownSentenceNote, "Fell back to the sample")
        #expect(!own.feedback.title.isEmpty && !own.english.isEmpty)
    }
}
