//
//  ArticlesTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 14.11.26.
//

import Foundation
import SwiftData
import Testing
@testable import Alltag

@MainActor
struct ArticlesTests {
    private var fixtures: [Noun] {
        (0..<10).map { Noun(.der, "Testwort\($0)", "Testwörter", "test word") }
    }

    @Test("A wrong answer brings the noun back in the round and first in the next one, until it is right")
    func trainer() throws {
        let defaults = try #require(UserDefaults(suiteName: "ArticlesTests-\(UUID().uuidString)"))
        var generator = SystemRandomNumberGenerator()
        let trainer = ArticleTrainer(nouns: fixtures, defaults: defaults, using: &generator)
        #expect(trainer.total == ArticleTrainer.roundSize)
        #expect(Set(trainer.queue).count == ArticleTrainer.roundSize)

        let first = try #require(trainer.current)
        let wrong = try #require(Article.allCases.first { $0 != first.article })
        trainer.next()
        #expect(trainer.index == 0)

        trainer.pick(wrong)
        trainer.pick(first.article)
        #expect(trainer.isRight == false)
        #expect(trainer.queue.count == ArticleTrainer.roundSize + 1)
        #expect(trainer.queue.last == first)
        #expect(defaults.stringArray(forKey: ArticleTrainer.missedKey) == [first.id])
        trainer.next()

        while let noun = trainer.current {
            trainer.pick(noun.article)
            trainer.next()
        }
        #expect(trainer.isDone)
        #expect(trainer.rightFirstTime == ArticleTrainer.roundSize - 1)
        #expect(trainer.missed == [first])
        // Answered right when it came back: it is learned.
        #expect(defaults.stringArray(forKey: ArticleTrainer.missedKey) == [])

        let container = try AlltagStore.makeContainer(inMemory: true)
        trainer.recordPractice(in: container.mainContext)
        trainer.recordPractice(in: container.mainContext)
        #expect(try container.mainContext.fetch(FetchDescriptor<PracticeSession>()).map(\.kind) == [.review])
    }

    @Test("Nouns missed before come first in the next round")
    func missedComeFirst() throws {
        let defaults = try #require(UserDefaults(suiteName: "ArticlesTests-\(UUID().uuidString)"))
        defaults.set(["der|Testwort0", "der|Testwort1"], forKey: ArticleTrainer.missedKey)
        var generator = SystemRandomNumberGenerator()

        let trainer = ArticleTrainer(nouns: fixtures, defaults: defaults, using: &generator)

        #expect(trainer.queue.contains { $0.word == "Testwort0" })
        #expect(trainer.queue.contains { $0.word == "Testwort1" })
        #expect(trainer.total == ArticleTrainer.roundSize)
    }
}

@MainActor
struct ArticleFlowTests {
    @Test("Wrong articles become practiceable mistakes without duplicates")
    func mistakeHandoff() throws {
        let container = try AlltagStore.makeContainer(inMemory: true)
        let noun = Noun(.die, "Wohnung", "Wohnungen", "flat")
        try ArticleMemory.mistake(noun, picked: .der, in: container.mainContext)
        try ArticleMemory.mistake(noun, picked: .der, in: container.mainContext)
        try ArticleMemory.mistake(noun, picked: .die, in: container.mainContext)
        let items = try container.mainContext.fetch(FetchDescriptor<MemoryItem>())
        #expect(items.count == 1)
        #expect(items.first?.mistakeOriginal == "der Wohnung")
        #expect(items.first?.context == "die Wohnung")
        #expect(MistakePractice.activity(in: container.mainContext)?.questions.count == 1)
    }

    @Test("Lookup nouns save to Memory once and retain their article")
    func saveLookup() throws {
        let container = try AlltagStore.makeContainer(inMemory: true)
        let noun = Noun(.das, "Haus", "Häuser", "house")
        try ArticleMemory.save(noun, in: container.mainContext)
        try ArticleMemory.save(noun, in: container.mainContext)
        let items = try container.mainContext.fetch(FetchDescriptor<MemoryItem>())
        #expect(items.count == 1)
        #expect(items.first?.article == "das ")
        #expect(items.first?.kind == .saved)
    }

    @Test("Practice sends the learner's exact level and recent words to the server")
    func generatedRound() async throws {
        var body: [String: String] = [:]
        let service = CloudArticleService(send: { request in
            body = request
            return Data(#"""
                {"nouns":[
                {"article":"das","word":"Haus","plural":"Häuser","meaning":"house"},
                {"article":"die","word":"Tür","plural":"Türen","meaning":"door"},
                {"article":"der","word":"Tisch","plural":"Tische","meaning":"table"}],"note":""}
                """#.utf8)
        }, allowed: { true })
        let answer = try await service.request(word: nil, level: .b2, excluding: ["Haus"])
        #expect(answer.nouns.count == 3)
        #expect(body["level"] == "B2")
        #expect(body["action"] == "practice")
        #expect(body["exclude"] == "Haus")
    }

    @Test("The Learn tab remains a dashboard and Articles opens inside it")
    func learnNavigation() {
        let state = AppState()
        state.show(.articles)
        #expect(state.tab == .learn)
        #expect(state.root(of: .learn) == .learn)
        state.popToRoot()
        #expect(state.path.isEmpty)
    }
}

/// Answers with the same nouns every time, or fails.
private struct StubArticleService: ArticleService {
    var nouns: [Noun] = [Noun(.die, "Wohnung", "Wohnungen", "flat"), Noun(.das, "Haus", "Häuser", "house"),
                         Noun(.der, "Tisch", "Tische", "table")]
    var fails = false

    func request(word: String?, level: Level, excluding: [String]) async throws -> ArticleAnswer {
        if fails { throw RealtimeServiceError.unavailable }
        return ArticleAnswer(nouns: nouns, note: "")
    }
}

@MainActor
struct ArticleRoundModelTests {
    private func services(_ articles: StubArticleService) -> AppServices {
        var services = AppServices.mock()
        services.articles = articles
        return services
    }

    @Test("A round loads, keeps a wrong answer as a mistake, and counts as practice when it ends")
    func round() async throws {
        let defaults = try #require(UserDefaults(suiteName: "ArticleRoundModelTests-\(UUID().uuidString)"))
        let container = try AlltagStore.makeContainer(inMemory: true)
        let model = ArticleRoundModel(services: services(StubArticleService()), level: .a2, defaults: defaults)
        #expect(model.phase == .loading)

        model.start()
        while model.phase == .loading { await Task.yield() }
        #expect(model.phase == .playing)
        #expect(model.asked == 3)
        #expect(defaults.stringArray(forKey: ArticleRoundModel.recentKey)?.count == 3)

        let first = try #require(model.current)
        let wrong = try #require(Article.allCases.first { $0 != first.article })
        model.pick(wrong, in: container.mainContext)
        #expect(model.isRight == false)
        #expect(model.saveFailed == false)
        #expect(try container.mainContext.fetch(FetchDescriptor<MemoryItem>()).count == 1)

        model.next(in: container.mainContext)
        while let noun = model.current {
            model.pick(noun.article, in: container.mainContext)
            model.next(in: container.mainContext)
        }
        #expect(model.phase == .done)
        #expect(model.rightFirstTime == 2)
        #expect(model.missedCount == 1)
        #expect(try container.mainContext.fetch(FetchDescriptor<PracticeSession>()).map(\.kind) == [.review])
    }

    @Test("When the nouns don't arrive, the round says so and can be tried again")
    func failure() async throws {
        let defaults = try #require(UserDefaults(suiteName: "ArticleRoundModelTests-\(UUID().uuidString)"))
        let model = ArticleRoundModel(services: services(StubArticleService(fails: true)), level: .a1, defaults: defaults)
        model.start()
        while model.phase == .loading { await Task.yield() }
        #expect(model.phase == .failed)
        #expect(model.current == nil)
    }
}
