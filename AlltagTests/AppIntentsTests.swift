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

    @Test("Showing a screen from Siri closes flows and selects its tab")
    func showFromOutside() {
        let state = AppState()
        state.open(.profile)
        state.present(.conversation(.dentist))

        state.show(.memory())
        #expect(state.fullScreen == nil)
        #expect(state.tab == .memory)
        #expect(state.path.isEmpty)

        state.show(.settings)
        #expect(state.tab == .today)
        #expect(state.path == [.settings])
    }

    @Test("Each memory item gets its own stable ID")
    func uniqueIDs() throws {
        let items = try context.fetch(FetchDescriptor<MemoryItem>())
        #expect(Set(items.map(\.uuid)).count == items.count)
    }

    @Test("Siri intents open the matching flow")
    func intentsNavigate() throws {
        let state = AppState(settings: AppSettings(defaults: .ephemeral()))

        let station = try #require(MockScenarios.all.first { $0.id == .station })
        StartConversationIntent.start(ScenarioEntity(station), in: state)
        #expect(state.fullScreen == .conversation(.station))
        StartConversationIntent.start(nil, in: state)
        #expect(state.fullScreen == .conversation(MockScenarios.todaysFocus))

        ReviewWordsIntent.start(in: state)
        #expect(state.fullScreen == .activity(.recall))

        TranslateIntent.open("  I'm running late  ", in: state)
        #expect(state.fullScreen == nil)
        #expect(state.tab == .translate)
        #expect(state.root(of: .translate) == .translate(text: "I'm running late"))
        TranslateIntent.open(" ", in: state)
        #expect(state.root(of: .translate) == .translate(text: nil))

        let rule = try #require(MockRules.all.first)
        OpenRuleIntent.open(GrammarRuleEntity(rule), in: state)
        #expect(state.tab == .learn)
        #expect(state.path == [.rule(id: rule.id)])
    }

    @Test("Searching from Siri opens Memory with the search filled in")
    func searchRoute() {
        let state = AppState(settings: AppSettings(defaults: .ephemeral()))
        state.show(.memory(search: "Termin"))
        #expect(state.tab == .memory)
        #expect(state.root(of: .memory) == .memory(kind: nil, search: "Termin"))
    }

    @Test("Spotlight gets every word, phrase, conversation and rule")
    func spotlightEntities() throws {
        let entities = try SpotlightIndex.entities(in: context)
        #expect(entities.words.count == (try context.fetchCount(FetchDescriptor<MemoryItem>())))
        #expect(entities.phrases.count == (try context.fetchCount(FetchDescriptor<Phrase>())))
        #expect(entities.scenarios.count == MockScenarios.all.count)
        #expect(entities.rules.count == MockRules.all.count)
        #expect(entities.count == entities.words.count + entities.phrases.count + entities.scenarios.count + entities.rules.count)
    }
}
