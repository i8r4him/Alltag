//
//  GrammarContentTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import Testing
import UIKit
@testable import Alltag

@Suite("Grammar content")
@MainActor
struct GrammarContentTests {
    @Test("Every rule has real-life sentences, and their marked words are in them, in order")
    func realLifeSentences() throws {
        for rule in MockRules.all {
            let sentences = try #require(RealLifeSentence.byRule[rule.id], "No sentences for \(rule.id)")
            #expect(sentences.count >= 3)
            for sentence in sentences {
                #expect(!sentence.marked.isEmpty)
                var rest = Substring(sentence.german)
                for word in sentence.marked {
                    let range = try #require(rest.range(of: word), "„\(word)“ not in „\(sentence.german)“")
                    rest = rest[range.upperBound...]
                }
            }
        }
    }

    @Test("The sentence of the day stays all day and changes the next day")
    func sentenceOfTheDay() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = try #require(TimeZone(identifier: "Europe/Berlin"))
        let morning = try #require(calendar.date(from: DateComponents(year: 2026, month: 11, day: 16, hour: 8)))
        let evening = try #require(calendar.date(byAdding: .hour, value: 12, to: morning))
        let tomorrow = try #require(calendar.date(byAdding: .day, value: 1, to: morning))

        let today = RealLifeSentence.sentence(for: "akkusativ", on: morning, calendar: calendar)
        #expect(today?.id == RealLifeSentence.sentence(for: "akkusativ", on: evening, calendar: calendar)?.id)
        #expect(today?.id != RealLifeSentence.sentence(for: "akkusativ", on: tomorrow, calendar: calendar)?.id)
        #expect(RealLifeSentence.sentence(for: "unknown") == nil)
    }

    @Test("Each level has three cheat sheets of its own")
    func cheatSheetsPerLevel() {
        for level in Level.selectable {
            let sheets = CheatSheet.sheets(for: level)
            #expect(sheets.count == 3, "\(level)")
            #expect(sheets.allSatisfy { !$0.parts.isEmpty && $0.parts.allSatisfy { !$0.rows.isEmpty } }, "\(level)")
        }
    }

    @Test("Cheat sheets have unique IDs and leave der, die, das to Articles")
    func cheatSheetsUnique() {
        let ids = CheatSheet.all.map(\.id)
        #expect(Set(ids).count == ids.count)
        #expect(!CheatSheet.all.contains { $0.label == "der · die · das" })
    }

    @Test("Cheat sheet symbols exist, and the marked words are in their German")
    func cheatSheetSymbolsAndMarks() {
        for sheet in CheatSheet.all {
            for part in sheet.parts {
                for side in [part.picture.source, part.picture.target] {
                    #expect(UIImage(systemName: side.systemImage) != nil, "\(sheet.id): \(side.systemImage)")
                    if let marked = side.marked {
                        #expect(side.german.contains(marked), "\(sheet.id): \(side.german)")
                    }
                }
                for row in part.rows {
                    #expect(UIImage(systemName: row.systemImage) != nil, "\(sheet.id): \(row.systemImage)")
                    if let marked = row.marked {
                        #expect(row.german.contains(marked), "\(sheet.id): \(row.german)")
                    }
                }
            }
        }
    }
}
