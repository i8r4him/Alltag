//
//  AppIntentsTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import AppIntents
import Foundation
import SwiftData
import Testing
@testable import Alltag

@Suite("App Intents")
@MainActor
struct AppIntentsTests {
    /// Kept as a property: a `ModelContext` crashes if its container is deallocated.
    let container: ModelContainer
    var context: ModelContext { container.mainContext }

    init() throws {
        container = try AlltagStore.makeContainer(inMemory: true)
        try AlltagStore.seedSampleDataIfEmpty(container.mainContext)
    }

    @Test("Words are found by German or English text, ignoring case")
    func wordSearch() throws {
        #expect(try MemoryLookup.words(matching: "feierabend", in: context).map(\.word) == ["Feierabend"])
        #expect(try MemoryLookup.words(matching: "notice period", in: context).map(\.word) == ["Kündigungsfrist"])
        #expect(try MemoryLookup.words(matching: "", in: context).count == 10)
    }

    @Test("Words are found again by their stable ID")
    func wordsByID() throws {
        let item = try #require(try MemoryLookup.words(matching: "Rechnung", in: context).first)
        let found = try MemoryLookup.words(ids: [item.uuid], in: context)
        #expect(found.map(\.word) == ["Rechnung"])
        #expect(WordEntity(item).id == item.uuid)
        #expect(WordEntity(item).word == "die Rechnung")
    }

    @Test("Suggested words are the six due for review, oldest first")
    func dueWords() throws {
        let due = try MemoryLookup.dueWords(in: context)
        #expect(due.count == 6)
        #expect(due.map(\.nextReview) == due.map(\.nextReview).sorted())
    }

    @Test("Phrases are found by text and by ID")
    func phrases() throws {
        let matches = try MemoryLookup.phrases(matching: "Gleis", in: context)
        #expect(matches.map(\.german) == ["Von welchem Gleis fährt der Zug ab?"])
        let phrase = try #require(matches.first)
        #expect(try MemoryLookup.phrases(ids: [phrase.uuid], in: context).count == 1)
        #expect(PhraseEntity(phrase).english == "Which platform does the train leave from?")
    }

    @Test("Every scenario and rule is offered as an entity")
    func staticEntities() async throws {
        let scenarios = try await ScenarioEntityQuery().allEntities()
        #expect(scenarios.map(\.id) == Scenario.ID.allCases.map(\.rawValue))

        let rules = try await GrammarRuleEntityQuery().entities(for: ["weil", "missing"])
        #expect(rules.map(\.title) == ["Verb at the end after weil, wenn, dass"])
    }

    @Test("Showing a screen from Siri closes flows and opens it above Home")
    func showFromOutside() {
        let state = AppState()
        state.open(.grammar)
        state.present(.conversation(.dentist))

        state.show(.memory())
        #expect(state.fullScreen == nil)
        #expect(state.path == [.memory()])
    }

    @Test("Each memory item gets its own stable ID")
    func uniqueIDs() throws {
        let items = try context.fetch(FetchDescriptor<MemoryItem>())
        #expect(Set(items.map(\.uuid)).count == items.count)
    }
}
