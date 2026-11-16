//
//  CollectionMemory.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import SwiftData

/// Adds a collection's words to Memory, or takes them out again. The words go
/// in as saved words with the collection as their source, so Memory's own
/// review picks them up. A word already in Memory isn't added twice.
enum CollectionMemory {
    static func add(_ collection: WordCollection, in context: ModelContext) throws {
        try add(collection.words, of: collection, in: context)
    }

    /// Adds some of a collection's words, skipping the ones already in Memory.
    static func add(_ words: [CollectionWord], of collection: WordCollection, in context: ModelContext) throws {
        let existing = try Set(context.fetch(FetchDescriptor<MemoryItem>()).map(\.displayWord))
        for word in words where !existing.contains(word.displayWord) {
            context.insert(MemoryItem(article: word.article, word: word.word, meaning: word.meaning,
                                      context: word.example, contextNote: word.exampleMeaning,
                                      kind: .saved, source: .collection, sourceDetail: collection.title))
        }
        try context.save()
    }

    /// Saves the collection's words, or takes them out when they're in Memory,
    /// and says what happened in a toast.
    static func toggle(_ collection: WordCollection, in context: ModelContext) -> ToastMessage {
        do {
            if try isAdded(collection, in: context) {
                try remove(collection, in: context)
                return ToastMessage(text: "Removed from Memory", systemImage: "bookmark.slash.fill")
            }
            try add(collection, in: context)
            return ToastMessage(text: "Saved to Memory")
        } catch {
            return ToastMessage(text: "Couldn’t save it. Try again.", systemImage: "exclamationmark.triangle")
        }
    }

    /// Takes out the words this collection added; words saved some other way stay.
    static func remove(_ collection: WordCollection, in context: ModelContext) throws {
        for item in try context.fetch(FetchDescriptor(predicate: predicate(for: collection))) {
            context.delete(item)
        }
        try context.save()
    }

    static func isAdded(_ collection: WordCollection, in context: ModelContext) throws -> Bool {
        try context.fetchCount(FetchDescriptor(predicate: predicate(for: collection))) > 0
    }

    /// The titles of the collections with words in Memory, from the items a
    /// `@Query` on `MemorySource.collection` returns.
    static func addedTitles(_ items: [MemoryItem]) -> Set<String> {
        Set(items.filter { $0.source == .collection }.map(\.sourceDetail))
    }

    private static func predicate(for collection: WordCollection) -> Predicate<MemoryItem> {
        let source = MemorySource.collection.rawValue
        let title = collection.title
        return #Predicate<MemoryItem> { $0.sourceRaw == source && $0.sourceDetail == title }
    }
}
