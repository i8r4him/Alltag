//
//  WordCollectionsB2Tests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import Testing
@testable import Alltag

@MainActor
struct WordCollectionsB2Tests {
    @Test("B2 has words in every topic, fifteen or more per collection")
    func everyTopicHasWords() {
        let b2 = WordCollections.all.filter { $0.level == .b2 }
        #expect(b2.map(\.id) == WordCollections.b2.map(\.id))
        for collection in b2 {
            #expect(collection.words.count >= 15, "\(collection.id) has only \(collection.words.count) words")
        }
        for category in CollectionCategory.allCases {
            let ready = WordCollections.collections(at: .b2, in: category).filter(\.isReady)
            #expect(!ready.isEmpty, "B2 has no words for \(category)")
        }
    }

    @Test("No word is in two B2 collections")
    func noRepeats() {
        let words = WordCollections.b2.flatMap(\.words).map(\.word)
        let repeated = Dictionary(grouping: words) { $0 }.filter { $0.value.count > 1 }.keys.sorted()
        #expect(repeated.isEmpty, "in two collections: \(repeated)")
    }

    @Test("No B2 word is in a collection of another level, so Memory never skips it")
    func newToB2() {
        let others = Set(WordCollections.all.filter { $0.level != .b2 }.flatMap(\.words).map { $0.word.lowercased() })
        let repeated = WordCollections.b2.flatMap(\.words).map(\.word).filter { others.contains($0.lowercased()) }
        #expect(repeated.isEmpty, "also at another level: \(repeated)")
    }

    @Test("Every B2 sentence is a full sentence in both languages")
    func sentencesAreComplete() {
        for word in WordCollections.b2.flatMap(\.words) {
            let german = word.example
            let english = word.exampleMeaning
            let startsWell = german.first?.isUppercase == true && english.first?.isUppercase == true
            let endsWell = [german, english].allSatisfy { sentence in sentence.last.map { ".?!".contains($0) } == true }
            #expect(startsWell && endsWell, "\(word.word): \(german) / \(english)")
        }
    }
}
