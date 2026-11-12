//
//  SpeechTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import Testing
@testable import Alltag

/// Speech that "hears" a fixed transcript, or fails.
private final class StubSpeech: SpeechService {
    let result: Result<String, SpeechError>
    init(_ result: Result<String, SpeechError>) { self.result = result }

    var authorizationStatus: PermissionStatus { .granted }
    func requestAuthorization() async -> PermissionStatus { .granted }
    func stopListening() {}
    func listen(expected: String, recordingTo recording: URL?) -> AsyncThrowingStream<String, any Error> {
        let result = result
        return AsyncThrowingStream { continuation in
            switch result {
            case .success(let text):
                if !text.isEmpty { continuation.yield(text) }
                continuation.finish()
            case .failure(let error):
                continuation.finish(throwing: error)
            }
        }
    }
}

@Suite("Speech")
@MainActor
struct SpeechTests {
    private func model(hearing result: Result<String, SpeechError>) -> ConversationModel {
        let mock = AppServices.mock()
        let services = AppServices(speech: StubSpeech(result), voice: mock.voice, translation: mock.translation,
                                   companion: MockCompanionService(thinkingTime: .zero),
                                   calendar: mock.calendar, notifications: mock.notifications)
        return ConversationModel(scenario: MockScenarios.dentist, services: services, timing: .instant)
    }

    private func speak(_ model: ConversationModel) async {
        model.orbTapped()
        await model.waitForTurn()
    }

    @Test("Close enough counts as the scripted line", arguments: [
        "können wir den Termin auf morgen verschieben",
        "Können wir den Termin morgen verschieben?",
        "Also, können wir den Termin auf morgen verschieben?"
    ])
    func closeEnough(heard: String) {
        #expect(ConversationModel.isScripted(heard, "Können wir den Termin auf morgen verschieben?"))
    }

    @Test("A different sentence is the learner's own", arguments: [
        "Ich möchte morgen kommen.",
        "Können wir",
        "Können wir den Termin auf morgen verschieben, weil ich heute leider gar keine Zeit habe?"
    ])
    func different(heard: String) {
        #expect(!ConversationModel.isScripted(heard, "Können wir den Termin auf morgen verschieben?"))
    }

    @Test("Saying the line continues the scripted conversation")
    func saysLine() async {
        let model = model(hearing: .success("können wir den termin auf morgen verschieben"))
        await speak(model)
        #expect(!model.messages[1].isCustom)
        #expect(model.messages[1].line.german == "Können wir den Termin auf morgen verschieben?")
        #expect(model.messages[1].line.feedback?.kind == .good)
    }

    @Test("Saying something else gets feedback on your own sentence")
    func saysOwnSentence() async {
        let model = model(hearing: .success("Ich möchte lieber am Freitag kommen."))
        await speak(model)
        #expect(model.messages[1].isCustom)
        #expect(model.messages[1].line.german == "Ich möchte lieber am Freitag kommen.")
        #expect(model.messages[1].line.feedback == MockCompanionService.ownSentenceNote)
        #expect(model.messages[2].line.speaker == .companion)
    }

    @Test("Hearing nothing asks to try again")
    func hearsNothing() async {
        let model = model(hearing: .success(""))
        await speak(model)
        #expect(model.messages.count == 1)
        #expect(model.phase == .idle)
        #expect(model.notice != nil)
        #expect(model.mode == .voice)
    }

    @Test("Without access, the keyboard takes over", arguments: [SpeechError.notAuthorized, .unsupported])
    func cannotListen(error: SpeechError) async {
        let model = model(hearing: .failure(error))
        await speak(model)
        #expect(model.messages.count == 1)
        #expect(model.phase == .idle)
        #expect(model.mode == .text)
        #expect(model.notice != nil)
    }
}
