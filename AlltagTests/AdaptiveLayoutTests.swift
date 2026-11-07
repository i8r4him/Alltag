//
//  AdaptiveLayoutTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import Testing
@testable import Alltag

@Suite("Adaptive layout")
@MainActor
struct AdaptiveLayoutTests {
    @Test("Content is centred only when the screen is wider than the readable width",
          arguments: [(CGFloat(393), CGFloat(0)), (720, 0), (820, 50), (1032, 156), (1033, 156)])
    func sideMargin(width: CGFloat, expected: CGFloat) {
        #expect(ReadableWidth.sideMargin(for: width) == expected)
    }

    @Test("Every section opens from the sidebar and is found again from its route")
    func sectionsRoundTrip() {
        for item in SidebarItem.allCases {
            let path = item.route.map { [$0] } ?? []
            #expect(SidebarItem.selection(for: path) == item)
        }
        #expect(SidebarItem.main + SidebarItem.personal == SidebarItem.allCases)
    }

    @Test("A filtered section keeps its filter as the detail root")
    func filteredRoot() {
        let path: [Route] = [.memory(kind: .fromYourDay)]
        #expect(SidebarItem.root(of: path) == .memory(kind: .fromYourDay))
        #expect(SidebarItem.selection(for: path) == .memory)
        #expect(SidebarItem.detailPath(of: path).isEmpty)
    }

    @Test("Screens pushed on a section stay above it; screens from Today stay above Today")
    func detailPath() {
        let onGrammar: [Route] = [.grammar, .rule(id: "weil")]
        #expect(SidebarItem.root(of: onGrammar) == .grammar)
        #expect(SidebarItem.detailPath(of: onGrammar) == [.rule(id: "weil")])
        #expect(SidebarItem.path(root: .grammar, detail: [.rule(id: "weil")]) == onGrammar)

        let fromToday: [Route] = [.debrief]
        #expect(SidebarItem.root(of: fromToday) == nil)
        #expect(SidebarItem.selection(for: fromToday) == .home)
        #expect(SidebarItem.detailPath(of: fromToday) == fromToday)
        #expect(SidebarItem.path(root: nil, detail: fromToday) == fromToday)
    }
}
