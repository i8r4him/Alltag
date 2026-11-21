//
//  KeyboardState.swift
//  AlltagKeyboard
//
//  Created by Ibrahim Abdullah on 21.11.26.
//

import CoreGraphics
import Foundation
import Observation

/// What the text field asks of the keyboard.
struct KeyboardTraits: Equatable {
    var capitalisation: AutoCapitalisation = .sentences
    var returnKey: ReturnKeyKind = .normal
    /// iOS shows its own globe under the keyboard on most iPhones; where it doesn't, the keyboard has to.
    var showsGlobe = false
    /// Off in fields for addresses, names and codes, where a dictionary only gets in the way.
    var offersSuggestions = true
    /// Some fields only take return once something is typed.
    var returnEnabled = true
}

/// What one key shows while a finger is on it. Each key watches only its own,
/// so a press redraws one key and not the whole keyboard.
@Observable
final class KeyState {
    var isPressed = false
}

/// The bubble over a pressed key: the key itself, larger, or the letters a long press offers.
struct KeyPopup: Equatable {
    let frame: KeyFrame
    /// One entry is the key itself; more are the alternates, the most wanted first.
    var options: [String]
    var isAlternates = false
    var selection = 0

    /// Alternates run away from the nearer edge, so the first one sits over the key.
    func runsLeft(in width: CGFloat) -> Bool { frame.frame.midX > width / 2 }

    var cellWidth: CGFloat { max(frame.frame.width, 36) }

    /// The left edge of the row of options.
    func minX(in width: CGFloat) -> CGFloat {
        let total = cellWidth * CGFloat(options.count)
        let start = runsLeft(in: width) ? frame.frame.maxX - total : frame.frame.minX
        return min(max(start, 2), max(width - total - 2, 2))
    }

    /// The option under a finger at `x`.
    func option(at x: CGFloat, in width: CGFloat) -> Int {
        let cell = Int(((x - minX(in: width)) / cellWidth).rounded(.down))
        let position = min(max(cell, 0), options.count - 1)
        return runsLeft(in: width) ? options.count - 1 - position : position
    }
}
