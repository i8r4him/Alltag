//
//  ArticleMemory.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 14.11.26.
//

import Foundation
import SwiftData

enum ArticleMemory {
    static func save(_ noun: Noun, in context: ModelContext) throws {
        let word = noun.word
        let article = noun.article.rawValue + " "
        let saved = MemoryKind.saved.rawValue
        let predicate = #Predicate<MemoryItem> { $0.word == word && $0.article == article && $0.kindRaw == saved }
        guard try context.fetchCount(FetchDescriptor(predicate: predicate)) == 0 else {
            try context.save()
            return
        }
        context.insert(MemoryItem(article: article, word: word, meaning: noun.meaning,
                                  context: noun.example, contextNote: noun.explanation, kind: .saved, source: .translate))
        try context.save()
    }

    static func mistake(_ noun: Noun, picked: Article, in context: ModelContext) throws {
        guard picked != noun.article else { return }
        let correct = "\(noun.article.rawValue) \(noun.word)"
        let original = "\(picked.rawValue) \(noun.word)"
        let kind = MemoryKind.mistake.rawValue
        let predicate = #Predicate<MemoryItem> {
            $0.kindRaw == kind && $0.context == correct && $0.mistakeOriginal == original
        }
        guard try context.fetchCount(FetchDescriptor(predicate: predicate)) == 0 else {
            try context.save()
            return
        }
        context.insert(MemoryItem(word: correct, meaning: noun.meaning, context: correct,
                                  contextNote: noun.explanation, kind: .mistake, source: .translate,
                                  sourceDetail: String(localized: "Articles"), mistakeOriginal: original))
        try context.save()
    }
}
