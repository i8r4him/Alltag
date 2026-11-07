//
//  ProgressTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import Testing
@testable import Alltag

@Suite("Progress")
@MainActor
struct ProgressTests {
    @Test("The track fills to the level plus the way to the next",
          arguments: [(Level.a1, 0.0, 0.0), (.b1, 0.62, 0.524), (.c1, 1.0, 1.0), (.c2, 0.5, 1.0)])
    func track(level: Level, toNext: Double, expected: Double) {
        #expect(abs(ProgressReport.trackFraction(level: level, progressToNext: toNext) - expected) < 0.001)
    }

    @Test("The prototype's numbers: six situations, four skills, 86% stuck")
    func sample() {
        let report = MockProgress.report
        #expect(report.situations.map(\.confidence.rawValue) == [3, 3, 2, 2, 1, 1])
        #expect(report.skills.map(\.change) == [6, 4, 9, 0])
        #expect(report.wordsStuck == 0.86)
        #expect(report.wordsStuckHistory.last == report.wordsStuck)
    }

    @Test("Insights keep their bold parts")
    func insight() {
        let text = ProgressOverviewView.insight("Most come from **reading in Safari** — 70%.")
        let bold = text.runs
            .filter { $0.inlinePresentationIntent?.contains(.stronglyEmphasized) == true }
            .map { String(text[$0.range].characters) }
        #expect(bold == ["reading in Safari"])
        #expect(String(text.characters) == "Most come from reading in Safari — 70%.")
    }
}
