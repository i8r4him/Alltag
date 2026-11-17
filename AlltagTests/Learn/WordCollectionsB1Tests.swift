//
//  WordCollectionsB1Tests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Testing
import UIKit
@testable import Alltag

struct WordCollectionsB1Tests {
    private let b1 = WordCollections.all.filter { $0.level == .b1 }

    @Test("B1 has words in every topic and nothing still coming soon")
    func coversEveryTopic() {
        let topics = Set(b1.map(\.category))
        #expect(topics.count == CollectionCategory.allCases.count)
        let allReady = b1.allSatisfy(\.isReady)
        #expect(allReady)
        #expect(b1.map(\.id) == WordCollections.b1.map(\.id))
    }

    @Test("Every B1 collection has twenty words, and none appears in two of them")
    func twentyWordsEach() {
        for collection in b1 {
            #expect(collection.words.count == 20, "\(collection.id)")
        }
        let words = b1.flatMap(\.words).map(\.word)
        let repeated = Dictionary(grouping: words, by: { $0 }).filter { $0.value.count > 1 }.keys.sorted()
        #expect(repeated.isEmpty, "Repeated: \(repeated)")
    }

    @Test("Every B1 sentence is a full sentence and every symbol exists")
    func sentencesAndSymbols() {
        for collection in b1 {
            #expect(UIImage(systemName: collection.systemImage) != nil, "\(collection.id): \(collection.systemImage)")
            for word in collection.words {
                let ends = [".", "!", "?"]
                #expect(ends.contains { word.example.hasSuffix($0) }, "\(word.id): \(word.example)")
                #expect(ends.contains { word.exampleMeaning.hasSuffix($0) }, "\(word.id): \(word.exampleMeaning)")
                #expect(word.example.first?.isUppercase == true, "\(word.id)")
            }
        }
    }
}
