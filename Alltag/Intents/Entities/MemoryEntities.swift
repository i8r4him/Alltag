//
//  MemoryEntities.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import AppIntents
import Foundation
import SwiftData

/// A word or phrase from the learner's Memory, for Siri and Shortcuts.
struct WordEntity: AppEntity {
    static let typeDisplayRepresentation: TypeDisplayRepresentation = "Word"
    static let defaultQuery = WordEntityQuery()

    let id: UUID
    let word: String
    let meaning: String

    init(_ item: MemoryItem) {
        id = item.uuid
        word = item.displayWord
        meaning = item.meaning
    }

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(word)", subtitle: "\(meaning)")
    }
}

struct WordEntityQuery: EntityStringQuery {
    @Dependency private var container: ModelContainer

    @MainActor
    func entities(for identifiers: [WordEntity.ID]) async throws -> [WordEntity] {
        try MemoryLookup.words(ids: identifiers, in: container.mainContext).map(WordEntity.init)
    }

    @MainActor
    func entities(matching string: String) async throws -> [WordEntity] {
        try MemoryLookup.words(matching: string, in: container.mainContext).map(WordEntity.init)
    }

    /// Words due for review come first.
    @MainActor
    func suggestedEntities() async throws -> [WordEntity] {
        try MemoryLookup.dueWords(in: container.mainContext).map(WordEntity.init)
    }
}

/// A phrase from the Phrasebook.
struct PhraseEntity: AppEntity {
    static let typeDisplayRepresentation: TypeDisplayRepresentation = "Phrase"
    static let defaultQuery = PhraseEntityQuery()

    let id: UUID
    let german: String
    let english: String

    init(_ phrase: Phrase) {
        id = phrase.uuid
        german = phrase.german
        english = phrase.english
    }

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(german)", subtitle: "\(english)")
    }
}

struct PhraseEntityQuery: EntityStringQuery {
    @Dependency private var container: ModelContainer

    @MainActor
    func entities(for identifiers: [PhraseEntity.ID]) async throws -> [PhraseEntity] {
        try MemoryLookup.phrases(ids: identifiers, in: container.mainContext).map(PhraseEntity.init)
    }

    @MainActor
    func entities(matching string: String) async throws -> [PhraseEntity] {
        try MemoryLookup.phrases(matching: string, in: container.mainContext).map(PhraseEntity.init)
    }

    @MainActor
    func suggestedEntities() async throws -> [PhraseEntity] {
        try MemoryLookup.phrases(matching: "", in: container.mainContext).map(PhraseEntity.init)
    }
}

/// SwiftData lookups behind the entity queries, separate so they can be tested
/// with an in-memory store.
enum MemoryLookup {
    static func words(ids: [UUID], in context: ModelContext) throws -> [MemoryItem] {
        try context.fetch(FetchDescriptor<MemoryItem>(predicate: #Predicate { ids.contains($0.uuid) }))
    }

    /// Words whose German or English contains `text`, ignoring case. Empty text matches everything.
    static func words(matching text: String, in context: ModelContext) throws -> [MemoryItem] {
        let descriptor = FetchDescriptor<MemoryItem>(
            predicate: #Predicate {
                text.isEmpty || $0.word.localizedStandardContains(text) || $0.meaning.localizedStandardContains(text)
            },
            sortBy: [SortDescriptor(\.word)]
        )
        return try context.fetch(descriptor)
    }

    static func dueWords(in context: ModelContext, at date: Date = .now) throws -> [MemoryItem] {
        let descriptor = FetchDescriptor<MemoryItem>(
            predicate: #Predicate { $0.nextReview <= date },
            sortBy: [SortDescriptor(\.nextReview)]
        )
        return try context.fetch(descriptor)
    }

    static func phrases(ids: [UUID], in context: ModelContext) throws -> [Phrase] {
        try context.fetch(FetchDescriptor<Phrase>(predicate: #Predicate { ids.contains($0.uuid) }))
    }

    static func phrases(matching text: String, in context: ModelContext) throws -> [Phrase] {
        let descriptor = FetchDescriptor<Phrase>(
            predicate: #Predicate {
                text.isEmpty || $0.german.localizedStandardContains(text) || $0.english.localizedStandardContains(text)
            },
            sortBy: [SortDescriptor(\.place), SortDescriptor(\.createdAt)]
        )
        return try context.fetch(descriptor)
    }
}
