//
//  AskModelTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 14.11.26.
//

import Foundation
import Testing
@testable import Alltag

/// Counts the requests and the registers asked for, and answers from the sample translations.
private final class CountingTranslation: TranslationService {
    private(set) var requests: [String] = []
    private(set) var registers: [GermanRegister?] = []
    var error: (any Error)?

    func translate(_ text: String) async throws -> TranslationResult? {
        requests.append(text)
        if let error { throw error }
        return MockTranslations.match(text)
    }

    func translate(_ text: String, register: GermanRegister?,
                   onUpdate: @escaping (TranslationResult) -> Void) async throws -> TranslationResult? {
        registers.append(register)
        return try await translate(text)
    }

    func explain(_ result: TranslationResult) async -> TranslationResult { result }
}

@Suite("How do I say …? in place")
@MainActor
struct AskModelTests {
    private let translation = CountingTranslation()
    let defaults: UserDefaults

    init() throws {
        let suite = "AskModelTests.\(UUID().uuidString)"
        defaults = try #require(UserDefaults(suiteName: suite))
        defaults.removePersistentDomain(forName: suite)
    }

    func makeModel() -> AskModel {
        let services = AppServices(
            speech: MockSpeechService(),
            voice: MockVoiceService(),
            translation: translation,
            companion: MockCompanionService(thinkingTime: .zero),
            calendar: MockCalendarService(),
            notifications: MockNotificationService()
        )
        return AskModel(services: services, defaults: defaults)
    }

    @Test("Typing asks nothing; sending asks once, for what is in the field")
    func asksOnlyWhenSent() async {
        let model = makeModel()
        for text in ["Can", "Can we move", "Can we move the appointment to tomorrow?"] {
            model.text = text
            model.textChanged()
        }
        #expect(translation.requests.isEmpty)
        #expect(!model.hasAnswer)

        await model.send()?.value
        #expect(translation.requests == ["Can we move the appointment to tomorrow?"])
        #expect(model.sent == 1)
        #expect(model.hasAnswer)
        #expect(model.translate.resultText == "Können wir den Termin auf morgen verschieben?")
    }

    @Test("An empty field sends nothing")
    func emptySendsNothing() {
        let model = makeModel()
        model.text = "   "
        #expect(!model.canSend)
        #expect(model.send() == nil)
        #expect(translation.requests.isEmpty)
        #expect(model.sent == 0)
    }

    @Test("Changing the words takes the answer away without asking again; clearing empties the field")
    func editingAndClearing() async {
        let model = makeModel()
        model.text = "Can we move the appointment to tomorrow?"
        await model.send()?.value
        model.text = "Can we move the appointment"
        model.textChanged()
        #expect(!model.hasAnswer)
        #expect(model.translate.result == nil)
        #expect(translation.requests.count == 1)

        await model.send()?.value
        model.clear()
        #expect(model.text.isEmpty)
        #expect(!model.hasAnswer)
        #expect(!model.canSend)
    }

    @Test("A failure is kept to show, and sending again retries")
    func failure() async {
        let model = makeModel()
        translation.error = URLError(.notConnectedToInternet)
        model.text = "Can we move the appointment to tomorrow?"
        await model.send()?.value
        #expect(model.hasAnswer)
        #expect(model.translate.failure == .offline)
        #expect(!model.foundNothing)

        translation.error = nil
        await model.send()?.value
        #expect(model.translate.failure == nil)
        #expect(model.translate.resultText == "Können wir den Termin auf morgen verschieben?")
        #expect(translation.requests.count == 2)
    }

    @Test("Words nothing comes back for are said so, not left blank")
    func foundNothing() async {
        let model = makeModel()
        model.text = "Where is the station?"
        await model.send()?.value
        #expect(model.foundNothing)
        #expect(model.translate.result == nil)
    }

    @Test("The German is everyday unless the learner chooses formal")
    func everydayByDefault() async {
        let model = makeModel()
        #expect(model.register == .everyday)
        model.text = "Can we move the appointment to tomorrow?"
        await model.send()?.value
        #expect(translation.registers == [.everyday])
    }

    @Test("Choosing a register with an answer shown asks again in it; without one it asks nothing")
    func choosingTheRegister() async {
        let model = makeModel()
        #expect(model.choose(.formal) == nil)
        #expect(model.register == .formal)
        #expect(translation.requests.isEmpty)

        model.text = "Can we move the appointment to tomorrow?"
        await model.send()?.value
        #expect(model.choose(.formal) == nil)
        let request = model.choose(.everyday)
        // The answer shown stays until the new one arrives.
        #expect(model.translate.resultText == "Können wir den Termin auf morgen verschieben?")
        await request?.value
        #expect(translation.registers == [.formal, .everyday])
        #expect(model.translate.resultText == "Können wir den Termin auf morgen verschieben?")
        // Choosing doesn't count as sending: no second haptic.
        #expect(model.sent == 1)
    }
}
