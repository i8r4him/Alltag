//
//  Colors.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI
import UIKit

// Brand colours live in the asset catalog with a light and a dark variant.
// Xcode generates their symbols from the colour-set names:
//
//   .accent      AccentColor  accent for text, icons and tint (readable on any surface)
//   .accentFill  AccentFill   bright amber for filled buttons and glows
//   .onAccent    OnAccent     text and icons on top of `.accentFill`
//   .success     Success      right answers, "good" feedback, confident
//   .mistake     Mistake      wrong answers, "fix" feedback, shaky
//   .resultCard  ResultCard   translation result card
//
// Neutral surfaces map to iOS semantic colours, which adapt to light and dark
// mode. In dark mode they match the prototype exactly.

extension Color {
    /// Screen background. Dark `#000000`.
    static let screenBackground = Color(uiColor: .systemGroupedBackground)
    /// Cards. Dark `#1C1C1E`.
    static let surface = Color(uiColor: .secondarySystemGroupedBackground)
    /// Inner tiles and pressed rows. Dark `#2C2C2E`.
    static let surfaceSecondary = Color(uiColor: .tertiarySystemGroupedBackground)
    /// Bars, keys and inactive elements. Dark `#3A3A3C`.
    static let surfaceTertiary = Color(uiColor: .systemGray4)
}

extension ShapeStyle where Self == Color {
    static var screenBackground: Color { Color.screenBackground }
    static var surface: Color { Color.surface }
    static var surfaceSecondary: Color { Color.surfaceSecondary }
    static var surfaceTertiary: Color { Color.surfaceTertiary }
}

/// Opacities used with the accent colour for tints and glows.
enum AccentTint {
    /// Selected backgrounds, e.g. a selected option card.
    static let selected: Double = 0.10
    /// Border of a selected option card.
    static let selectedBorder: Double = 0.55
    /// Soft radial glow in the top-right of hero cards.
    static let glow: Double = 0.22
}
