//
//  WordCollectionsTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import SwiftData
import Testing
@testable import Alltag

@MainActor
struct WordCollectionsTests {
    @Test("Every collection has its own id and title, and complete words")
    func contentIsComplete() {
        let collections = WordCollections.all
        #expect(Set(collections.map(\.id)).count == collections.count)
        #expect(Set(collections.map(\.title)).count == collections.count)
        #expect(!WordCollections.ready.isEmpty)
        for collection in collections {
            #expect(collection.id.hasPrefix(collection.level.rawValue.lowercased() + "-"), "\(collection.id): level prefix")
            #expect(Set(collection.words.map(\.id)).count == collection.words.count, "\(collection.id) repeats a word")
            for word in collection.words {
                #expect(["der ", "die ", "das ", ""].contains(word.article), "\(word.id): odd article")
                #expect(!word.meaning.isEmpty && !word.example.isEmpty && !word.exampleMeaning.isEmpty, "\(word.id)")
            }
        }
    }

    @Test("A1 covers every topic with fifteen words each, and no word in two of its collections")
    func a1Coverage() {
        let a1 = WordCollections.ready.filter { $0.level == .a1 }
        #expect(a1.count == WordCollections.a1.count)
        #expect(Set(a1.map(\.category)) == Set(CollectionCategory.allCases))
        let sizes = a1.map(\.words.count)
        #expect(sizes.allSatisfy { $0 == 15 })
        // Memory skips a word it already has, so one word in two collections would go missing from one.
        let words = a1.flatMap(\.words).map(\.displayWord)
        #expect(Set(words).count == words.count)
    }

    @Test("Learn shows only collections with words, the learner's own level first")
    func ownLevelFirst() {
        #expect(WordCollections.ordered(for: .b1).first?.level == .b1)
        #expect(WordCollections.ordered(for: .a2).first?.level == .a2)
        #expect(WordCollections.ordered(for: .a1).first?.level == .a1)
        #expect(WordCollections.ordered(for: .a1).count == WordCollections.ready.count)
        let allReady = WordCollections.ordered(for: .a1).allSatisfy { $0.isReady }
        #expect(allReady)
    }

    @Test("A topic lists its collections with words before the ones coming soon")
    func readyFirstInTopic() {
        let paperwork = WordCollections.collections(at: .b1, in: .paperwork)
        #expect(paperwork.map(\.id) == ["b1-behoerden", "b1-bank"])
        #expect(WordCollections.collections(at: .c2, in: .health).map(\.id) == ["c2-ethik"])
    }

    @Test("Saving only some words adds just those")
    func saveSome() throws {
        let container = try AlltagStore.makeContainer(inMemory: true)
        let context = container.mainContext
        let collection = WordCollections.transport
        try CollectionMemory.add(Array(collection.words.prefix(2)), of: collection, in: context)
        #expect(try context.fetchCount(FetchDescriptor<MemoryItem>()) == 2)
        #expect(try CollectionMemory.isAdded(collection, in: context))
    }

    @Test("A collection's words go into Memory and come out again")
    func addAndRemove() throws {
        // Keep the container: a context whose container is gone saves nothing.
        let container = try AlltagStore.makeContainer(inMemory: true)
        let context = container.mainContext
        let collection = WordCollections.doctor

        try CollectionMemory.add(collection, in: context)
        let items = try context.fetch(FetchDescriptor<MemoryItem>())
        #expect(items.count == collection.words.count)
        #expect(items.allSatisfy { $0.kind == .saved && $0.source == .collection && $0.sourceDetail == collection.title })
        #expect(try CollectionMemory.isAdded(collection, in: context))
        #expect(CollectionMemory.addedTitles(items) == [collection.title])

        try CollectionMemory.remove(collection, in: context)
        #expect(try context.fetch(FetchDescriptor<MemoryItem>()).isEmpty)
        #expect(try !CollectionMemory.isAdded(collection, in: context))
    }

    @Test("A word already in Memory isn't added twice, and stays when the collection is removed")
    func keepsOwnWords() throws {
        // Keep the container: a context whose container is gone saves nothing.
        let container = try AlltagStore.makeContainer(inMemory: true)
        let context = container.mainContext
        let collection = WordCollections.flat
        let first = try #require(collection.words.first)
        context.insert(MemoryItem(article: first.article, word: first.word, meaning: first.meaning,
                                  kind: .saved, source: .translate))
        try context.save()

        try CollectionMemory.add(collection, in: context)
        #expect(try context.fetchCount(FetchDescriptor<MemoryItem>()) == collection.words.count)

        try CollectionMemory.remove(collection, in: context)
        let left = try context.fetch(FetchDescriptor<MemoryItem>())
        #expect(left.map(\.displayWord) == [first.displayWord])
        #expect(left.first?.source == .translate)
    }

    @Test("Grammar's progress counts only the solved rules of the learner's level")
    func grammarProgress() throws {
        let a2 = GrammarProgress.rules(at: .a2)
        let b1Rule = try #require(GrammarProgress.rules(at: .b1).first)
        let solved = Set(a2.prefix(3).map(\.id) + [b1Rule.id])

        let progress = SkillProgress.grammar(solvedRuleIDs: solved, level: .a2)
        #expect(progress == .rules(solved: 3, total: a2.count, level: .a2))
        #expect(progress.fraction == Double(3) / Double(a2.count))
        #expect(SkillProgress.grammar(solvedRuleIDs: [], level: .a2).fraction == 0)
    }

    @Test("Read's progress counts only the words saved from the reader")
    func readingProgress() {
        let items = [
            MemoryItem(word: "Frist", meaning: "deadline", kind: .saved, source: .read),
            MemoryItem(word: "Miete", meaning: "rent", kind: .saved, source: .translate)
        ]
        #expect(SkillProgress.reading(items) == .savedWords(1))
        #expect(SkillProgress.reading([]).fraction == nil)
    }
}
