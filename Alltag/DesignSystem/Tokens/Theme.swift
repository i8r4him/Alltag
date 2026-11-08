//
//  Theme.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 08.11.26.
//

import Observation
import SwiftUI
import UIKit

/// The app's colour theme, chosen with the companion's colour.
///
/// The accent colours (`.accent`, `.accentFill`, `.onAccent`) read it, so every
/// view that uses them follows a change at once. Gold is the original look.
@Observable
final class AppTheme {
    static let shared = AppTheme()

    var palette: CompanionPalette {
        didSet { defaults.set(palette.rawValue, forKey: CompanionLook.Key.palette) }
    }

    @ObservationIgnored private let defaults: UserDefaults

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        palette = defaults.string(forKey: CompanionLook.Key.palette).flatMap(CompanionPalette.init) ?? .gold
    }
}

extension CompanionPalette {
    /// Text, icons and tint: readable on any surface, in light and dark mode.
    var accent: Color {
        switch self {
        case .gold: Color(.accent)
        case .copper: Color(light: 0x9C4A1E, dark: 0xE8894A)
        case .roseGold: Color(light: 0x9A4E42, dark: 0xF2A58E)
        case .champagne: Color(light: 0x7D6236, dark: 0xE6CFA3)
        case .pearl: Color(light: 0x4C5A7A, dark: 0xC9D4EE)
        case .coral: Color(light: 0xA8402A, dark: 0xFF8A6B)
        case .lavender: Color(light: 0x5B45B8, dark: 0xB9A3FF)
        }
    }

    /// Filled buttons and glows.
    var accentFill: Color {
        switch self {
        case .gold: Color(.accentFill)
        case .copper: Color(hex: 0xE07B45)
        case .roseGold: Color(hex: 0xEBA08A)
        case .champagne: Color(hex: 0xE3C894)
        case .pearl: Color(hex: 0xD5DEF2)
        case .coral: Color(hex: 0xFF8466)
        case .lavender: Color(hex: 0x9C83F0)
        }
    }

    /// Text and icons on top of `accentFill`.
    var onAccent: Color {
        switch self {
        case .gold: Color(.onAccent)
        case .copper: Color(hex: 0x1F0E05)
        case .roseGold: Color(hex: 0x2A1410)
        case .champagne: Color(hex: 0x241B0C)
        case .pearl: Color(hex: 0x151A26)
        case .coral: Color(hex: 0x2A0C05)
        case .lavender: Color(hex: 0xFFFFFF)
        }
    }
}

extension Color {
    /// Accent for text, icons and tint, from the current theme.
    static var accent: Color { AppTheme.shared.palette.accent }
    /// Filled buttons and glows, from the current theme.
    static var accentFill: Color { AppTheme.shared.palette.accentFill }
    /// Text and icons on `accentFill`, from the current theme.
    static var onAccent: Color { AppTheme.shared.palette.onAccent }

    /// A colour from `0xRRGGBB`.
    init(hex: UInt32) {
        self.init(red: Double((hex >> 16) & 0xFF) / 255,
                  green: Double((hex >> 8) & 0xFF) / 255,
                  blue: Double(hex & 0xFF) / 255)
    }

    /// A colour with a light and a dark variant.
    init(light: UInt32, dark: UInt32) {
        self.init(uiColor: UIColor { traits in
            UIColor(Color(hex: traits.userInterfaceStyle == .dark ? dark : light))
        })
    }
}

extension ShapeStyle where Self == Color {
    static var accent: Color { Color.accent }
    static var accentFill: Color { Color.accentFill }
    static var onAccent: Color { Color.onAccent }
}
