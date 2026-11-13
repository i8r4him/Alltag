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
    @Test("The noun lists: 200 different nouns, each level's own, earlier levels kept in practice")
    func nouns() {
        #expect(Nouns.all.count == 200)
        #expect(Set(Nouns.all.map(\.word)).count == 200)
        #expect(Nouns.a1.allSatisfy { $0.level == .a1 })
        #expect(Nouns.nouns(upTo: .a1) == Nouns.a1)
        #expect(Nouns.nouns(upTo: .a2).count == Nouns.a1.count + Nouns.a2.count)
        #expect(Nouns.nouns(upTo: .c2).count == 200)
        #expect(Nouns.all.allSatisfy { !$0.word.isEmpty && !$0.meaning.isEmpty && !$0.plural.isEmpty })
    }

    @Test("The learner's saved words with an article are nouns to train")
    func savedNouns() {
        let items = [
            MemoryItem(article: "die ", word: "Kündigungsfrist", meaning: "notice period", kind: .saved, source: .safari),
            MemoryItem(article: "die ", word: "Kündigungsfrist", meaning: "notice period", kind: .saved, source: .translate),
            MemoryItem(word: "verschieben", meaning: "to postpone", kind: .saved, source: .conversation),
            MemoryItem(article: "der ", word: "Fehler", meaning: "x", kind: .mistake, source: .conversation)
        ]
        let nouns = Nouns.saved(in: items)
        #expect(nouns.map(\.word) == ["Kündigungsfrist"])
        #expect(nouns.first?.article == .die)
    }

    @Test("A word is found in Alltag's nouns whatever its case, with an article typed, or by its meaning")
    func localLookup() {
        #expect(ArticleLookup.local("tisch", in: Nouns.all)?.article == .der)
        #expect(ArticleLookup.local("  die Apotheke ", in: Nouns.all)?.word == "Apotheke")
        #expect(ArticleLookup.local("pharmacy", in: Nouns.all)?.word == "Apotheke")
        #expect(ArticleLookup.local("Quatsch", in: Nouns.all) == nil)
        #expect(ArticleLookup.local("", in: Nouns.all) == nil)
    }

    @Test("Any other word gets its article from the translation")
    func translatedLookup() {
        let word = TranslationResult.WordBreakdown(word: "die Kündigungsfrist", grammar: "noun · pl. Kündigungsfristen",
                                                   meaning: "notice period")
        let noun = TranslationResult(english: "notice period", german: "Kündigungsfrist", words: [word],
                                     tones: [], note: "", examples: [])
        #expect(ArticleLookup.answer(from: noun) == .found(Noun(.die, "Kündigungsfrist", "Kündigungsfristen", "notice period")))

        let plain = TranslationResult(english: "the weather", german: "das Wetter", words: [], tones: [], note: "", examples: [])
        #expect(ArticleLookup.answer(from: plain) == .found(Noun(.das, "Wetter", "", "the weather")))

        let verb = TranslationResult(english: "to postpone", german: "verschieben",
                                     words: [.init(word: "verschieben", grammar: "verb", meaning: "to postpone")],
                                     tones: [], note: "", examples: [])
        #expect(ArticleLookup.answer(from: verb) == .notANoun(german: "verschieben", meaning: "to postpone"))
        #expect(ArticleLookup.plural(in: "noun · pl. Termine") == "Termine")
        #expect(ArticleLookup.plural(in: "noun") == "")
    }

    @Test("A wrong answer brings the noun back in the round and first in the next one, until it is right")
    func trainer() throws {
        let defaults = try #require(UserDefaults(suiteName: "ArticlesTests-\(UUID().uuidString)"))
        var generator = SystemRandomNumberGenerator()
        let trainer = ArticleTrainer(nouns: Nouns.a1, defaults: defaults, using: &generator)
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
        defaults.set(["Tisch", "Bett"], forKey: ArticleTrainer.missedKey)
        var generator = SystemRandomNumberGenerator()

        let trainer = ArticleTrainer(nouns: Nouns.a1, defaults: defaults, using: &generator)

        #expect(trainer.queue.contains { $0.word == "Tisch" })
        #expect(trainer.queue.contains { $0.word == "Bett" })
        #expect(trainer.total == ArticleTrainer.roundSize)
    }
}
