//
//  RuleViewTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Testing
@testable import Alltag

@Suite("Rule presentation")
@MainActor
struct RuleViewTests {
    @Test("Tile roles map to styles: key outlined, verb and end highlighted",
          arguments: [(GrammarRule.Tile.Role.plain, WordTile.Style.plain), (.key, .key), (.verb, .highlighted), (.end, .highlighted)])
    func tileStyles(role: GrammarRule.Tile.Role, expected: WordTile.Style) {
        #expect(WordTile.style(for: role) == expected)
    }

    @Test("Every rule highlights something in its tiles and its pattern", arguments: MockRules.all)
    func highlights(rule: GrammarRule) {
        #expect(rule.tiles.contains { $0.role != .plain })
        #expect(rule.pattern.contains { $0.emphasis != .none })
    }
}
