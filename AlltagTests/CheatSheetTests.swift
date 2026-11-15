//
//  CheatSheetTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import Testing
@testable import Alltag

@Suite("Grammar cheat sheets")
@MainActor
struct CheatSheetTests {
    @Test("Cases and word order have parts, each with examples that highlight something",
          arguments: [GrammarCheatSheet.cases, .wordOrder])
    func parts(sheet: GrammarCheatSheet) {
        #expect(!sheet.parts.isEmpty)
        for part in sheet.parts {
            #expect(!part.examples.isEmpty)
            for example in part.examples {
                #expect(CheatSheetPart.runs(of: example).contains { $0.isHighlighted }, "\(example)")
                #expect(example.filter { $0 == "*" }.count.isMultiple(of: 2), "\(example)")
            }
        }
    }

    @Test("Part ids are unique, so the sheet lists each part once", arguments: [GrammarCheatSheet.cases, .wordOrder])
    func uniqueParts(sheet: GrammarCheatSheet) {
        #expect(Set(sheet.parts.map(\.id)).count == sheet.parts.count)
    }

    @Test("Highlighted runs come out in order, without the asterisks")
    func runs() {
        let runs = CheatSheetPart.runs(of: "Morgen *fahre* ich nach Berlin.")
        #expect(runs.map(\.text) == ["Morgen ", "fahre", " ich nach Berlin."])
        #expect(runs.map(\.isHighlighted) == [false, true, false])
        #expect(CheatSheetPart.runs(of: "*Kommst* du?").map(\.isHighlighted) == [true, false])
    }

    @Test("The case table has four cases with four articles each")
    func caseTable() {
        #expect(GrammarCheatSheet.caseTable.count == 4)
        #expect(GrammarCheatSheet.caseTable.allSatisfy { $0.articles.count == 4 })
        #expect(GrammarCheatSheet.caseTable.map(\.articles[0]) == ["der", "den", "dem", "des"])
    }
}
