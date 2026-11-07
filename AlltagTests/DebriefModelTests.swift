//
//  DebriefModelTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import SwiftData
import Testing
@testable import Alltag

@Suite("Debrief model")
@MainActor
struct DebriefModelTests {
    func makeModel() -> DebriefModel {
        let services = AppServices(
            speech: MockSpeechService(),
            voice: MockVoiceService(),
            translation: MockTranslationService(delay: .zero),
            companion: MockCompanionService(thinkingTime: .zero),
            calendar: MockCalendarService(),
            notifications: MockNotificationService()
        )
        return DebriefModel(services: services)
    }

    @Test("Starts with the prototype's sample input, ready to find the words")
    func start() {
        let model = makeModel()
        #expect(model.input.hasPrefix("I wanted to ask if the bread has nuts"))
        #expect(model.phase == .input)
        #expect(model.canFind)
    }

    @Test("Finding the words shows the suggested phrases")
    func find() async {
        let model = makeModel()
        await model.findWords()
        #expect(model.phase == .result)
        #expect(model.result?.phrases.map(\.german) == ["Sind da Nüsse drin?", "Ich bin allergisch gegen Nüsse."])
    }

    @Test("Editing the text goes back to the input; empty text can't be sent")
    func editing() async {
        let model = makeModel()
        await model.findWords()
        model.input = "Something else"
        #expect(model.phase == .input)
        model.input = "   "
        #expect(!model.canFind)
    }

    @Test("Saving adds the phrases to a NEW bakery group, which comes first; saving again removes them")
    func save() async throws {
        let container = try AlltagStore.makeContainer(inMemory: true)
        let context = container.mainContext
        try AlltagStore.seedSampleDataIfEmpty(context)
        let model = makeModel()
        await model.findWords()

        #expect(model.toggleSave(in: context))
        var phrases = try context.fetch(FetchDescriptor<Phrase>())
        #expect(model.isSaved(in: phrases))
        let group = try #require(PhrasebookGroup.groups(from: phrases).first)
        #expect(group.place == "At the bakery")
        #expect(group.isNew)
        #expect(group.phrases.count == 2)

        #expect(!model.toggleSave(in: context))
        phrases = try context.fetch(FetchDescriptor<Phrase>())
        #expect(!model.isSaved(in: phrases))
        #expect(phrases.count == 8)
    }

    @Test("The grammar tip is bold up to the plus sign")
    func tip() throws {
        let tip = DebriefModel.styledTip("allergisch gegen + accusative.")
        let bold = try #require(tip.runs.first)
        #expect(String(tip[bold.range].characters) == "allergisch gegen")
        #expect(bold.inlinePresentationIntent == .stronglyEmphasized)
    }
}
