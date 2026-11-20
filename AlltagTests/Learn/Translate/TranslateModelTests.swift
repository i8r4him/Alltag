//
//  TranslateModelTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import SwiftData
import Testing
@testable import Alltag

@Suite("Translate model")
@MainActor
struct TranslateModelTests {
    let voice = MockVoiceService()
    /// The history's own store, so the tests leave the app's alone.
    let defaults: UserDefaults

    init() throws {
        let suite = "TranslateModelTests.\(UUID().uuidString)"
        defaults = try #require(UserDefaults(suiteName: suite))
        defaults.removePersistentDomain(forName: suite)
    }

    func makeModel(_ text: String? = nil) -> TranslateModel {
        let services = AppServices(
            speech: MockSpeechService(),
            voice: voice,
            translation: MockTranslationService(delay: .zero),
            companion: MockCompanionService(thinkingTime: .zero),
            notifications: MockNotificationService()
        )
        return TranslateModel(text: text, services: services, defaults: defaults)
    }

    @Test("Without text it starts empty")
    func defaultInput() async {
        let model = makeModel(nil)
        #expect(model.input.isEmpty)
        await model.translate()
        #expect(model.result == nil)
    }

    @Test("German text translates to English")
    func germanSource() async {
        let model = makeModel("Ich mache jetzt Feierabend.")
        await model.translate()
        #expect(model.sourceIsGerman)
        #expect(String(localized: model.sourceLabel) == "German")
        #expect(model.resultText == "I'm calling it a day.")
    }

    @Test("Swapping puts the translation in the field and flips the direction")
    func swap() async {
        let model = makeModel("Can we move the appointment to tomorrow?")
        await model.translate()
        model.swap()
        await model.translate()
        #expect(model.input == "Können wir den Termin auf morgen verschieben?")
        #expect(model.sourceIsGerman)
        #expect(model.resultText == "Can we move the appointment to tomorrow?")
    }

    @Test("Unknown text has no result; swap still flips the labels")
    func unknown() async {
        let model = makeModel("Where is the station?")
        await model.translate()
        #expect(model.result == nil)
        #expect(model.resultText == nil)
        #expect(String(localized: model.sourceLabel) == "English")
        model.swap()
        #expect(String(localized: model.sourceLabel) == "German")
    }

    @Test("Tapping a sample replaces the text")
    func useSample() async {
        let model = makeModel("Where is the station?")
        model.use(MockTranslations.letMeKnow)
        await model.translate()
        #expect(model.resultText == "Sag mir Bescheid, wann du Zeit hast.")
    }

    @Test("Saving adds a saved translation; saving again removes it")
    func save() async throws {
        let container = try AlltagStore.makeContainer(inMemory: true)
        let context = container.mainContext
        let model = makeModel("Can we move the appointment to tomorrow?")
        await model.translate()

        #expect(model.toggleSave(in: context))
        var saved = try context.fetch(FetchDescriptor<SavedTranslation>())
        #expect(saved.map(\.german) == ["Können wir den Termin auf morgen verschieben?"])
        #expect(model.isSaved(in: saved))

        #expect(!model.toggleSave(in: context))
        saved = try context.fetch(FetchDescriptor<SavedTranslation>())
        #expect(saved.isEmpty)
        #expect(!model.isSaved(in: saved))
    }

    @Test("Listen speaks the German side, slowly when asked, whatever the direction")
    func listen() async {
        let model = makeModel("Ich mache jetzt Feierabend.")
        await model.translate()
        await model.listen()
        await model.listen(slowly: true)
        #expect(voice.spoken.map(\.text) == ["Ich mache jetzt Feierabend.", "Ich mache jetzt Feierabend."])
        #expect(voice.spoken.map(\.rate) == [.normal, .slow])
    }

    @Test("A translation is kept in the history, newest first, each text once")
    func history() async {
        let model = makeModel("Ich mache jetzt Feierabend.")
        await model.translate()
        model.input = "Can we move the appointment to tomorrow?"
        await model.translate()
        model.input = "Ich mache jetzt Feierabend."
        await model.translate()
        #expect(model.history.lookups.map(\.input) == ["Ich mache jetzt Feierabend.", "Can we move the appointment to tomorrow?"])
        #expect(model.history.lookups.first?.translation == "I'm calling it a day.")

        // Unknown text has no translation to keep.
        model.input = "Where is the station?"
        await model.translate()
        #expect(model.history.lookups.count == 2)
    }

    @Test("The history survives a new model and can be removed from and cleared")
    func historyIsStored() async {
        let model = makeModel("Ich mache jetzt Feierabend.")
        await model.translate()
        let later = makeModel()
        #expect(later.history.lookups.map(\.input) == ["Ich mache jetzt Feierabend."])
        later.history.lookups.first.map(later.history.remove)
        #expect(makeModel().history.lookups.isEmpty)
        await model.translate()
        model.history.clear()
        #expect(makeModel().history.lookups.isEmpty)
    }

    @Test("Showing a translation from the history needs no request and keeps its details")
    func showFromHistory() async throws {
        let model = makeModel("Can we move the appointment to tomorrow?")
        await model.translate()
        let lookup = try #require(model.history.lookups.first)
        model.input = ""
        model.clearResult()

        model.show(lookup)
        #expect(model.input == "Can we move the appointment to tomorrow?")
        #expect(model.restoredInput == model.input)
        #expect(model.result == lookup.result)
        #expect(model.resultText == "Können wir den Termin auf morgen verschieben?")
        #expect(!model.isTranslating)

        // Typing something else afterwards clears it like any other result.
        model.clearResult()
        #expect(model.restoredInput == nil)
    }
}
