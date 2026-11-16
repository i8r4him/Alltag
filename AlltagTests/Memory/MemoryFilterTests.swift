//
//  MemoryFilterTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import Testing
@testable import Alltag

@Suite("Memory filters and search")
@MainActor
struct MemoryFilterTests {
    let now = Calendar.current.date(from: DateComponents(year: 2026, month: 11, day: 7, hour: 19)) ?? .now
    var items: [MemoryItem] { MockMemoryItems.make(now: now) }

    @Test("Each filter shows the prototype's items",
          arguments: [(MemoryFilter.all, 10), (.fromYourDay, 5), (.saved, 3), (.mistakes, 2), (.due, 6)])
    func filters(filter: MemoryFilter, expected: Int) {
        #expect(filter.apply(to: items, query: "", at: now).count == expected)
    }

    @Test("Search matches German or English, ignoring case and umlauts",
          arguments: [("frist", "Kündigungsfrist"), ("KUNDIGUNG", "Kündigungsfrist"), ("bill", "Rechnung"), ("die Rech", "Rechnung")])
    func search(query: String, expected: String) {
        #expect(MemoryFilter.all.apply(to: items, query: query, at: now).map(\.word) == [expected])
    }

    @Test("Search and filter combine")
    func searchWithinFilter() {
        #expect(MemoryFilter.mistakes.apply(to: items, query: "Jahren", at: now).map(\.word) == ["seit drei Jahren"])
        #expect(MemoryFilter.saved.apply(to: items, query: "Jahren", at: now).isEmpty)
    }

    @Test("Due items come first")
    func order() {
        let shown = MemoryFilter.all.apply(to: items, query: "", at: now)
        #expect(shown.prefix(6).allSatisfy { $0.isDue(at: now) })
        #expect(shown.dropFirst(6).allSatisfy { !$0.isDue(at: now) })
    }

    @Test("Opening Memory with a kind preselects its filter")
    func initialFilter() {
        #expect(MemoryFilter(kind: nil) == .all)
        #expect(MemoryFilter(kind: .fromYourDay) == .fromYourDay)
        #expect(MemoryFilter(kind: .mistake) == .mistakes)
    }

    @Test("The review card counts due items and own mistakes")
    func review() {
        let summary = ReviewSummary(items: items, at: now)
        #expect(summary.count == 6)
        #expect(summary.mistakes == 2)
        #expect(summary.minutes == 3)
        #expect(!summary.isEmpty)
        #expect(ReviewSummary(items: [], at: now).isEmpty)
    }
}
