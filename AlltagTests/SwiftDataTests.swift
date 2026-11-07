//
//  SwiftDataTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import SwiftData
import Testing
@testable import Alltag

@Suite("SwiftData store")
@MainActor
struct SwiftDataTests {
    let container: ModelContainer
    var context: ModelContext { container.mainContext }

    init() throws {
        container = try AlltagStore.makeContainer(inMemory: true)
    }

    @Test("A memory item is saved and fetched with all its fields")
    func insertAndFetch() throws {
        let item = MemoryItem(article: "der ", word: "Termin", meaning: "appointment",
                              context: "Ich habe morgen einen Termin.", kind: .saved,
                              source: .translate, strength: 2)
        context.insert(item)
        try context.save()

        let fetched = try #require(try context.fetch(FetchDescriptor<MemoryItem>()).first)
        #expect(fetched.displayWord == "der Termin")
        #expect(fetched.kind == .saved)
        #expect(fetched.source == .translate)
        #expect(fetched.strength == 2)
    }

    @Test("Strength is clamped to 0…4")
    func strengthIsClamped() {
        #expect(MemoryItem(word: "a", meaning: "a", kind: .saved, source: .translate, strength: 9).strength == 4)
        #expect(MemoryItem(word: "a", meaning: "a", kind: .saved, source: .translate, strength: -1).strength == 0)
    }

    @Test("Seeding inserts the prototype data once")
    func seedingIsIdempotent() throws {
        try AlltagStore.seedSampleDataIfEmpty(context)
        try AlltagStore.seedSampleDataIfEmpty(context)

        #expect(try context.fetchCount(FetchDescriptor<MemoryItem>()) == 10)
        #expect(try context.fetchCount(FetchDescriptor<Phrase>()) == 8)
    }

    @Test("Memory items can be filtered by kind in a predicate")
    func filterByKind() throws {
        try AlltagStore.seedSampleDataIfEmpty(context)
        let mistake = MemoryKind.mistake.rawValue
        let descriptor = FetchDescriptor<MemoryItem>(predicate: #Predicate { $0.kindRaw == mistake })

        #expect(try context.fetchCount(descriptor) == 2)
    }

    @Test("Six sample items are due for review")
    func dueItems() throws {
        let now = Date.now
        try AlltagStore.seedSampleDataIfEmpty(context, now: now)

        let items = try context.fetch(FetchDescriptor<MemoryItem>())
        #expect(items.filter { $0.isDue(at: now) }.count == 6)
    }

    @Test("Duplicate IDs from an upgraded store are repaired once")
    func repairDuplicateIDs() throws {
        let shared = UUID()
        for word in ["eins", "zwei", "drei"] {
            let item = MemoryItem(word: word, meaning: word, kind: .saved, source: .translate)
            item.uuid = shared
            context.insert(item)
        }
        let phrase = Phrase(german: "a", english: "a", place: "p", placeSymbol: "s")
        phrase.uuid = shared
        context.insert(phrase)

        #expect(try AlltagStore.repairDuplicateIDs(context) == 2)
        let ids = try context.fetch(FetchDescriptor<MemoryItem>()).map(\.uuid)
        #expect(Set(ids).count == 3)
        #expect(ids.contains(shared))
        #expect(try AlltagStore.repairDuplicateIDs(context) == 0)
    }

    @Test("Phrases are grouped into four places")
    func phrasebookGroups() throws {
        try AlltagStore.seedSampleDataIfEmpty(context)

        let places = Set(try context.fetch(FetchDescriptor<Phrase>()).map(\.place))
        #expect(places == ["At the doctor", "Trains & travel", "With my landlord", "At work"])
    }
}
