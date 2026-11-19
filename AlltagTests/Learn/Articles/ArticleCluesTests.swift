//
//  ArticleCluesTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import Testing
import UIKit
@testable import Alltag

@Suite("Article clues")
@MainActor
struct ArticleCluesTests {
    @Test("Every clue has parts, every symbol exists and every mark is in its German")
    func symbolsAndMarks() {
        #expect(ArticleRule.all.count == 6)
        #expect(Set(ArticleRule.all.map(\.id)).count == ArticleRule.all.count)
        for rule in ArticleRule.all {
            #expect(!rule.parts.isEmpty, "\(rule.id)")
            for part in rule.parts {
                #expect(!part.rows.isEmpty, "\(rule.id)")
                for side in [part.picture.source, part.picture.target] {
                    #expect(UIImage(systemName: side.systemImage) != nil, "\(rule.id): \(side.systemImage)")
                    if let marked = side.marked {
                        #expect(side.german.contains(marked), "\(rule.id): \(side.german)")
                    }
                }
                for row in part.rows {
                    #expect(UIImage(systemName: row.systemImage) != nil, "\(rule.id): \(row.systemImage)")
                    #expect(row.marked != nil, "\(rule.id): \(row.german) has no mark")
                    if let marked = row.marked {
                        #expect(row.german.contains(marked), "\(rule.id): \(row.german)")
                    }
                }
            }
        }
    }

    @Test("Each noun starts with its article")
    func nounsHaveArticles() {
        for rule in ArticleRule.all {
            for row in rule.parts.flatMap(\.rows) {
                let first = row.german.split(separator: " ").first.map(String.init) ?? ""
                #expect(Article(rawValue: first) != nil, "\(rule.id): \(row.german)")
            }
        }
    }
}
