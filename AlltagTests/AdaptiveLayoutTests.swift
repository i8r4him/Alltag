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
}
