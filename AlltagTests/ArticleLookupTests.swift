//
//  ArticleLookupTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import SwiftData
import Testing
@testable import Alltag

/// Answers a look-up with the given nouns, or throws the given error.
private struct LookupStub: ArticleService {
    var nouns: [Noun] = [Noun(.die, "Wohnung", "Wohnungen", "flat")]
    var error: (any Error)?

    func request(word: String?, level: Level, excluding: [String]) async throws -> ArticleAnswer {
        if let error { throw error }
        return ArticleAnswer(nouns: nouns, note: "")
    }
}

@MainActor
struct ArticleLookupTests {
    private func defaults() throws -> UserDefaults {
        try #require(UserDefaults(suiteName: "ArticleLookupTests-\(UUID().uuidString)"))
    }

    private func lookUp(_ word: String, in model: ArticleLookupModel) async {
        await lookUp(word, in: model, with: LookupStub())
    }

    private func lookUp(_ word: String, in model: ArticleLookupModel, with service: LookupStub) async {
        model.text = word
        model.lookUp(level: .a2, with: service)
        while model.isLookingUp { await Task.yield() }
    }

    @Test("Looked-up words are kept newest first, each once, and come back after a restart")
    func history() async throws {
        let defaults = try defaults()
        let model = ArticleLookupModel(defaults: defaults)
        await lookUp("Wohnung", in: model)
        await lookUp("Haus", in: model, with: LookupStub(nouns: [Noun(.das, "Haus", "Häuser", "house")]))
        await lookUp("wohnung", in: model)
        #expect(model.history.map(\.query) == ["wohnung", "Haus"])

        let restarted = ArticleLookupModel(defaults: defaults)
        #expect(restarted.history.map(\.query) == ["wohnung", "Haus"])
        restarted.removeHistory(at: [0])
        #expect(ArticleLookupModel(defaults: defaults).history.map(\.query) == ["Haus"])
    }

    @Test("A word with no noun is not kept in the history")
    func nothingFound() async throws {
        let model = ArticleLookupModel(defaults: try defaults())
        await lookUp("schnell", in: model, with: LookupStub(nouns: []))
        #expect(model.foundNothing)
        #expect(model.history.isEmpty)
    }

    @Test("A word from the history shows again without asking the server")
    func showFromHistory() async throws {
        let model = ArticleLookupModel(defaults: try defaults())
        await lookUp("Wohnung", in: model)
        model.text = ""
        model.textChanged()
        #expect(model.answer == nil)

        model.show(try #require(model.history.first))
        #expect(model.text == "Wohnung")
        #expect(model.answer?.nouns.first?.word == "Wohnung")
        #expect(!model.isLookingUp)
    }

    @Test("Each failure gets its own reason, and changing the word clears it",
          arguments: [(URLError(.notConnectedToInternet) as any Error, CloudFailure.offline),
                      (RealtimeServiceError.unavailable, .cloudOff),
                      (RealtimeServiceError.dailyLimit, .dailyLimit),
                      (RealtimeServiceError.upstream, .other)])
    func failure(error: any Error, expected: CloudFailure) async throws {
        let model = ArticleLookupModel(defaults: try defaults())
        await lookUp("Wohnung", in: model, with: LookupStub(error: error))
        #expect(model.failure == expected)
        #expect(model.history.isEmpty)

        model.text = "Haus"
        model.textChanged()
        #expect(model.failure == nil)
    }

    @Test("Saving a word to Memory can be undone")
    func undoSave() async throws {
        let container = try AlltagStore.makeContainer(inMemory: true)
        let model = ArticleLookupModel(defaults: try defaults())
        await lookUp("Wohnung", in: model)
        let noun = try #require(model.answer?.nouns.first)

        model.toggleSave(noun, in: container.mainContext)
        #expect(model.saved.contains(noun.id))
        #expect(try ArticleMemory.isSaved(noun, in: container.mainContext))

        model.toggleSave(noun, in: container.mainContext)
        #expect(!model.saved.contains(noun.id))
        #expect(try !ArticleMemory.isSaved(noun, in: container.mainContext))
        #expect(try container.mainContext.fetch(FetchDescriptor<MemoryItem>()).isEmpty)
    }

    @Test("A word saved earlier shows as saved when it is looked up again")
    func savedEarlier() async throws {
        let container = try AlltagStore.makeContainer(inMemory: true)
        try ArticleMemory.save(Noun(.die, "Wohnung", "Wohnungen", "flat"), in: container.mainContext)
        let model = ArticleLookupModel(defaults: try defaults())
        await lookUp("Wohnung", in: model)
        model.refreshSaved(in: container.mainContext)
        #expect(model.saved == ["die|Wohnung"])
    }
}
