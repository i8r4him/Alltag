//
//  ProfileTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import Testing
@testable import Alltag

@Suite("Profile")
@MainActor
struct ProfileTests {
    let now = Calendar.current.date(from: DateComponents(year: 2026, month: 11, day: 7, hour: 19)) ?? .now

    @Test("Words met this week are the ones added in the last seven days")
    func wordsThisWeek() {
        let items = [
            MemoryItem(word: "a", meaning: "a", kind: .saved, source: .translate, createdAt: now),
            MemoryItem(word: "b", meaning: "b", kind: .saved, source: .translate, createdAt: now.addingTimeInterval(-6 * 86_400)),
            MemoryItem(word: "c", meaning: "c", kind: .saved, source: .translate, createdAt: now.addingTimeInterval(-9 * 86_400))
        ]
        #expect(ProfileStats.wordsThisWeek(in: items, now: now) == 2)
    }

    @Test("Situations are summarised with the confident part in bold, and the first shaky one is next")
    func situations() {
        let report = MockProgress.report
        let summary = ProfileStats.situationsSummary(report)
        #expect(String(summary.characters) == "2 confident · 2 getting there · 2 shaky")
        let bold = summary.runs.filter { $0.inlinePresentationIntent == .stronglyEmphasized }
        #expect(bold.map { String(summary[$0.range].characters) } == ["2 confident"])
        #expect(report.nextToWorkOn?.name == "Landlord & contracts")
    }

    @Test("Every goal has a statement", arguments: Goal.allCases)
    func goalStatements(goal: Goal) {
        #expect(!String(localized: goal.statement).isEmpty)
    }
}
