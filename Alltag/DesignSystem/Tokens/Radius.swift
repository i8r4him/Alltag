//
//  Radius.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Corner radii. Always use them with the `.continuous` corner style, e.g.
/// `.clipShape(.rect(cornerRadius: Radius.card, style: .continuous))`.
/// Chips and pills use `Capsule()`, glass buttons use `Circle()`.
enum Radius {
    /// Hero cards, e.g. Today's Focus.
    static let hero: CGFloat = 38
    /// Cards.
    static let card: CGFloat = 38
    /// Cards inside cards.
    static let innerCard: CGFloat = 38
    /// Option buttons and option cards.
    static let option: CGFloat = 18
    /// Tiles, e.g. Coming up tiles and word tiles.
    static let tile: CGFloat = 16
}
