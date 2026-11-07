//
//  Spacing.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Spacing and sizing constants.
enum Spacing {
    /// Horizontal padding of a screen.
    static let screen: CGFloat = 16
    /// Horizontal padding of onboarding screens.
    static let onboarding: CGFloat = 20
    /// Padding inside a card.
    static let card: CGFloat = 16
    /// Padding inside large cards, e.g. hero cards.
    static let cardLarge: CGFloat = 22
    /// Gap between cards in a grid.
    static let grid: CGFloat = 12
    /// Gap between sections on a screen.
    static let section: CGFloat = 28
    /// Minimum height of a list row.
    static let rowMinHeight: CGFloat = 50
    /// Minimum size of anything tappable.
    static let minTouchTarget: CGFloat = 44
}
