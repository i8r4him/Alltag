//
//  WordCollectionsC1C2Tests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import Testing
import UIKit
@testable import Alltag

@MainActor
struct WordCollectionsC1C2Tests {
    @Test("C1 and C2 have words in every topic, fifteen per collection", arguments: [Level.c1, .c2])
    func everyTopicHasWords(level: Level) {
        let own = level == .c1 ? WordCollections.c1 : WordCollections.c2
        let atLevel = WordCollections.all.filter { $0.level == level }
        #expect(atLevel.map(\.id) == own.map(\.id))
        for collection in own {
            #expect(collection.words.count == 15, "\(collection.id) has \(collection.words.count) words")
        }
        for category in CollectionCategory.allCases {
            let ready = WordCollections.collections(at: level, in: category).filter(\.isReady)
            #expect(!ready.isEmpty, "\(level.title) has no words for \(category)")
        }
    }

    @Test("No word is in two collections of the same level", arguments: [Level.c1, .c2])
    func noRepeats(level: Level) {
        let words = WordCollections.all.filter { $0.level == level }.flatMap(\.words).map(\.word)
        let repeated = Dictionary(grouping: words) { $0 }.filter { $0.value.count > 1 }.keys.sorted()
        #expect(repeated.isEmpty, "in two collections: \(repeated)")
    }

    @Test("No C1 or C2 word is in a collection of another level, so Memory never skips it", arguments: [Level.c1, .c2])
    func newToLevel(level: Level) {
        let others = Set(WordCollections.all.filter { $0.level != level }.flatMap(\.words).map { $0.word.lowercased() })
        let own = WordCollections.all.filter { $0.level == level }.flatMap(\.words).map(\.word)
        let repeated = own.filter { others.contains($0.lowercased()) }
        #expect(repeated.isEmpty, "also at another level: \(repeated)")
    }

    @Test("Every C1 and C2 sentence is a full sentence, and every symbol exists", arguments: [Level.c1, .c2])
    func sentencesAndSymbols(level: Level) {
        for collection in WordCollections.all where collection.level == level {
            #expect(UIImage(systemName: collection.systemImage) != nil, "\(collection.id): \(collection.systemImage)")
            for word in collection.words {
                let german = word.example
                let english = word.exampleMeaning
                let startsWell = german.first?.isUppercase == true && english.first?.isUppercase == true
                let endsWell = [german, english].allSatisfy { sentence in sentence.last.map { ".?!".contains($0) } == true }
                #expect(startsWell && endsWell, "\(word.word): \(german) / \(english)")
            }
        }
    }
}
