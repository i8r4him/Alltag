//
//  TranslationServiceTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import FoundationModels
import Testing
@testable import Alltag

/// Translates everything to a fixed result, or fails, and explains with fixed details.
private final class StubTranslation: TranslationService {
    let outcome: Result<TranslationResult, TranslationServiceError>
    private(set) var explained = 0
    init(_ outcome: Result<TranslationResult, TranslationServiceError>) { self.outcome = outcome }

    func translate(_ text: String) async throws -> TranslationResult? { try outcome.get() }
    func explain(_ result: TranslationResult) async -> TranslationResult {
        explained += 1
        return TranslationResult(english: result.english, german: result.german,
                                 words: [.init(word: "der Hund", grammar: "noun", meaning: "the dog")],
                                 tones: [], note: "", examples: [])
    }
}

/// A model that must never be asked.
private struct UnusedModel: LanguageModelClient {
    func generate<Content: Generable>(_ type: Content.Type, instructions: String, prompt: String) async throws -> Content {
        Issue.record("The model was asked")
        throw CancellationError()
    }
}

@Suite("Translation")
@MainActor
struct TranslationServiceTests {
    private let plain = TranslationResult(english: "The dog is sleeping.", german: "Der Hund schläft.",
                                          words: [], tones: [], note: "", examples: [])

    private func model(_ service: StubTranslation, text: String = "The dog is sleeping.") -> TranslateModel {
        let mock = AppServices.mock()
        let services = AppServices(speech: mock.speech, voice: mock.voice, translation: service,
                                   companion: mock.companion, calendar: mock.calendar, notifications: mock.notifications)
        return TranslateModel(text: text, services: services)
    }

    @Test("German and English are told apart", arguments: [
        ("Können wir den Termin verschieben?", true),
        ("Ich mache jetzt Feierabend.", true),
        ("Can we move the appointment?", false),
        ("Let me know when you're free.", false)
    ])
    func language(text: String, isGerman: Bool) {
        #expect(SystemTranslationService.isGerman(text) == isGerman)
    }

    @Test("The samples keep their hand-written explanations")
    func samples() async throws {
        let service = SystemTranslationService(client: UnusedModel(), isModelAvailable: { true })
        let result = try await service.translate("can we move the appointment to tomorrow")
        #expect(result == MockTranslations.moveAppointment)
        #expect(await service.explain(MockTranslations.moveAppointment) == MockTranslations.moveAppointment)
    }

    @Test("Without Apple Intelligence the plain translation is shown")
    func plainWithoutModel() async {
        let service = SystemTranslationService(client: UnusedModel(), isModelAvailable: { false })
        #expect(await service.explain(plain) == plain)
    }

    @Test("A translation is shown first, then explained")
    func explains() async {
        let service = StubTranslation(.success(plain))
        let model = model(service)
        await model.translate()
        #expect(model.resultText == "Der Hund schläft.")
        #expect(model.result?.words.map(\.word) == ["der Hund"])
        #expect(service.explained == 1)
        #expect(!model.isExplaining)
    }

    @Test("Missing languages offer a download, then translate")
    func download() async {
        let english = Locale.Language(identifier: "en"), german = Locale.Language(identifier: "de")
        let model = model(StubTranslation(.failure(.needsDownload(source: english, target: german))))
        await model.translate()
        #expect(model.result == nil)
        #expect(model.missingLanguages?.source == english)
        #expect(model.missingLanguages?.target == german)
    }

    @Test("Generated details map onto the result, tones in order")
    func mapping() {
        let details = GeneratedTranslationDetails(
            words: [.init(word: "der Hund", grammar: "noun · pl. Hunde", meaning: "the dog")],
            tones: [.init(register: .formal, german: "Der Hund schläft."),
                    .init(register: .casual, german: "Der Hund pennt.")],
            note: "Neutral in any situation.",
            examples: [.init(german: "Der Hund bellt.", english: "The dog is barking.")])
        let result = TranslationResult(plain, details)
        #expect(result.german == plain.german)
        #expect(result.tones.map(\.tone) == [.formal, .casual])
        #expect(result.words.first?.grammar == "noun · pl. Hunde")
        #expect(result.isExplained)
    }
}
