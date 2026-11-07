//
//  ConversationModelTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import Testing
@testable import Alltag

@Suite("Conversation model")
@MainActor
struct ConversationModelTests {
    let voice = MockVoiceService()

    func makeModel(_ scenario: Scenario? = nil, wordInterval: Duration = .zero) -> ConversationModel {
        let services = AppServices(
            speech: MockSpeechService(wordInterval: wordInterval),
            voice: voice,
            translation: MockTranslationService(delay: .zero),
            companion: MockCompanionService(thinkingTime: .zero),
            calendar: MockCalendarService(),
            notifications: MockNotificationService()
        )
        return ConversationModel(scenario: scenario ?? MockScenarios.dentist, services: services, timing: .instant)
    }

    @Test("Starts idle with the companion's first line and waits for the learner")
    func start() throws {
        let model = makeModel()
        #expect(model.messages.map(\.line.speaker) == [.companion])
        #expect(model.phase == .idle)
        #expect(model.canRespond)
        #expect(model.expectedLine?.german == "Können wir den Termin auf morgen verschieben?")
        #expect(String(localized: try #require(model.stateLabel)) == "Tap to speak")
    }

    @Test("A full voice conversation: two turns, feedback, replies spoken, then finished",
          arguments: MockScenarios.all)
    func fullConversation(scenario: Scenario) async throws {
        let model = makeModel(scenario)

        model.orbTapped()
        await model.waitForTurn()
        #expect(model.messages.count == 3)
        #expect(model.phase == .idle)
        #expect(!model.isFinished)
        #expect(model.messages[1].line.feedback == scenario.script[1].feedback)

        model.orbTapped()
        await model.waitForTurn()
        #expect(model.messages.map(\.line.german) == scenario.script.map(\.german))
        #expect(model.isFinished)
        #expect(!model.canRespond)
        #expect(model.stateLabel == nil)
        #expect(model.turnCount == 2)
        #expect(model.fixCount == 1)
        #expect(model.savedPhraseCount == 2)
        #expect(voice.spoken.map(\.text) == [scenario.script[2].german, scenario.script[4].german])
    }

    @Test("Typing the scripted line with different case and punctuation counts as the script")
    func textScripted() async {
        let model = makeModel()
        model.mode = .text
        model.draft = "können wir den termin auf morgen verschieben"
        await model.send()

        let said = model.messages[1]
        #expect(!said.isCustom)
        #expect(said.line.german == "Können wir den Termin auf morgen verschieben?")
        #expect(said.line.feedback?.kind == .good)
        #expect(model.draft.isEmpty)
    }

    @Test("An empty draft sends the scripted line")
    func textEmpty() async {
        let model = makeModel()
        await model.send()
        #expect(model.messages[1].line.german == "Können wir den Termin auf morgen verschieben?")
    }

    @Test("Your own sentence is kept, with a note instead of scripted feedback")
    func textCustom() async {
        let model = makeModel()
        model.draft = "  Ich möchte morgen kommen.  "
        await model.send()

        let said = model.messages[1]
        #expect(said.isCustom)
        #expect(said.line.german == "Ich möchte morgen kommen.")
        #expect(said.line.english.isEmpty)
        #expect(said.line.feedback?.kind == .note)
        // The conversation still continues with the scripted reply.
        #expect(model.messages[2].line.speaker == .companion)
    }

    @Test("Tapping while listening stops early and uses the whole line")
    func stopEarly() async throws {
        let model = makeModel(wordInterval: .milliseconds(200))
        model.orbTapped()
        // Wait for the first word rather than a fixed time, so a busy CI machine can't break it.
        let deadline = ContinuousClock.now + .seconds(2)
        while model.heardText.isEmpty, ContinuousClock.now < deadline {
            try await Task.sleep(for: .milliseconds(20))
        }
        #expect(model.phase == .listening)
        #expect(model.heardText == "Können")

        model.orbTapped()
        await model.waitForTurn()
        #expect(model.messages[1].line.german == "Können wir den Termin auf morgen verschieben?")
        #expect(model.phase == .idle)
    }

    @Test("Taps are ignored once the conversation is finished")
    func ignoresTapsWhenFinished() async {
        let model = makeModel()
        model.orbTapped()
        await model.waitForTurn()
        model.orbTapped()
        await model.waitForTurn()
        #expect(model.isFinished)

        model.orbTapped()
        await model.waitForTurn()
        await model.send()
        #expect(model.messages.count == 5)
    }

    @Test("Sentences are compared without case and punctuation")
    func normalized() {
        #expect(ConversationModel.normalized("Wann fährt der Zug ab?") == ConversationModel.normalized("wann FÄHRT der zug ab"))
    }
}
