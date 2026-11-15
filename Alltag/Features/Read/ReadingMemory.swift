//
//  ReadingMemory.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import SwiftData

/// Words saved from the reader: in Memory with the sentence they were read in.
/// A word saved elsewhere (Translate, Articles) counts as saved here too.
enum ReadingMemory {
    static func save(_ meaning: ReadingMeaning, sentence: String, from title: String, in context: ModelContext) throws {
        guard try !isSaved(meaning, in: context) else { return }
        context.insert(MemoryItem(article: meaning.article, word: meaning.word, meaning: meaning.meaning,
                                  context: sentence, kind: .saved, source: .read, sourceDetail: title))
        try context.save()
    }

    static func isSaved(_ meaning: ReadingMeaning, in context: ModelContext) throws -> Bool {
        try context.fetchCount(FetchDescriptor(predicate: predicate(for: meaning))) > 0
    }

    /// Takes the word out of the learner's saved words again.
    static func remove(_ meaning: ReadingMeaning, in context: ModelContext) throws {
        for item in try context.fetch(FetchDescriptor(predicate: predicate(for: meaning))) {
            context.delete(item)
        }
        try context.save()
    }

    private static func predicate(for meaning: ReadingMeaning) -> Predicate<MemoryItem> {
        let word = meaning.word
        let article = meaning.article
        let saved = MemoryKind.saved.rawValue
        return #Predicate<MemoryItem> { $0.word == word && $0.article == article && $0.kindRaw == saved }
    }
}
