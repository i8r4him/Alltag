//
//  WordCollectionsA2Tests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Testing
@testable import Alltag

@MainActor
struct WordCollectionsA2Tests {
    private let a2 = WordCollections.all.filter { $0.level == .a2 }

    @Test("A2 covers every topic group with ready collections")
    func coversEveryGroup() {
        #expect(a2.count >= 20)
        let notReady = a2.filter { !$0.isReady }.map(\.id)
        #expect(notReady.isEmpty)
        let groups = Set(a2.map(\.category))
        let missing = CollectionCategory.allCases.filter { !groups.contains($0) }
        #expect(missing.isEmpty)
        #expect(WordCollections.a2.map(\.id) == a2.map(\.id), "every A2 collection is in the A2 list")
    }

    @Test("Each A2 collection has enough words, and no word is in two collections at any level")
    func wordsAreSound() {
        // Memory skips a word it already has, so a word in two collections would go missing from one.
        var seen: [String: String] = [:]
        for collection in WordCollections.all where collection.level != .a2 {
            for word in collection.words {
                seen[word.displayWord.lowercased()] = collection.id
            }
        }
        for collection in a2 {
            #expect(collection.words.count >= 12, "\(collection.id) has few words")
            for word in collection.words {
                let key = word.displayWord.lowercased()
                #expect(seen[key] == nil, "\(word.displayWord) is in \(seen[key] ?? "") and \(collection.id)")
                seen[key] = collection.id
                if !word.article.isEmpty {
                    #expect(word.word.first?.isUppercase == true, "\(word.displayWord): a noun starts with a capital")
                }
                let ending = word.example.last.map { ".!?".contains($0) } ?? false
                #expect(ending, "\(word.displayWord): the example is a whole sentence")
            }
        }
    }
}
