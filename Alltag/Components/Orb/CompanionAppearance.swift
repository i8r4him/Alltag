//
//  CompanionAppearance.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 13.11.26.
//

import SwiftUI

/// The companion's adjustable look, saved in UserDefaults so edits made in
/// Settings › Developer show up on Today at once.
enum CompanionLook {
    enum Key {
        static let rim = "companion.rim"
        static let silk = "companion.silk"
        static let halo = "companion.halo"
        static let eyeSize = "companion.eyeSize"
        static let eyeSpacing = "companion.eyeSpacing"
        static let lively = "companion.lively"
        static let drifts = "companion.drifts"
        static let palette = "companion.palette"
    }

    /// The range of every amount and size: 1 is the designed look.
    static let range: ClosedRange<Double> = 0...2
    static let eyeRange: ClosedRange<Double> = 0.6...1.6
}

/// The companion's colours (glass, silk, highlights, rim and eyes), which
/// also set the app's theme: see `AppTheme`.
enum CompanionPalette: String, CaseIterable, Identifiable {
    case gold
    case copper
    case roseGold
    case champagne
    case pearl
    case coral
    case lavender

    var id: Self { self }

    /// Shown in Settings › Appearance.
    var title: LocalizedStringResource {
        switch self {
        case .gold: "Gold"
        case .copper: "Copper"
        case .roseGold: "Rose gold"
        case .champagne: "Champagne"
        case .pearl: "Pearl"
        case .coral: "Coral"
        case .lavender: "Lavender"
        }
    }

    /// Darkest: tints the glass.
    var deep: Color {
        switch self {
        case .gold: Color(red: 0.80, green: 0.42, blue: 0.04)       // #CC6B0A
        case .copper: Color(red: 0.54, green: 0.23, blue: 0.07)     // #8A3A12
        case .roseGold: Color(red: 0.48, green: 0.23, blue: 0.20)   // #7A3A34
        case .champagne: Color(red: 0.43, green: 0.34, blue: 0.20)  // #6E5634
        case .pearl: Color(red: 0.22, green: 0.27, blue: 0.37)      // #39445E
        case .coral: Color(red: 0.54, green: 0.18, blue: 0.12)      // #8A2E1E
        case .lavender: Color(red: 0.24, green: 0.18, blue: 0.48)   // #3E2E7A
        }
    }

    /// The silk.
    var mid: Color {
        switch self {
        case .gold: Color(red: 1.00, green: 0.72, blue: 0.16)       // #FFB829
        case .copper: Color(red: 0.78, green: 0.39, blue: 0.18)     // #C8642E
        case .roseGold: Color(red: 0.85, green: 0.51, blue: 0.43)   // #D9826E
        case .champagne: Color(red: 0.85, green: 0.73, blue: 0.54)  // #D8B98A
        case .pearl: Color(red: 0.72, green: 0.77, blue: 0.88)      // #B8C4E0
        case .coral: Color(red: 0.91, green: 0.42, blue: 0.31)      // #E86A4E
        case .lavender: Color(red: 0.56, green: 0.45, blue: 0.91)   // #8E72E8
        }
    }

    /// Highlights and the reflection.
    var light: Color {
        switch self {
        case .gold: Color(red: 1.00, green: 0.95, blue: 0.72)       // #FFF2B8
        case .copper: Color(red: 0.96, green: 0.82, blue: 0.69)     // #F6D2B0
        case .roseGold: Color(red: 0.98, green: 0.88, blue: 0.84)   // #FBE0D6
        case .champagne: Color(red: 1.00, green: 0.96, blue: 0.88)  // #FFF4E0
        case .pearl: Color(red: 1.00, green: 1.00, blue: 1.00)      // #FFFFFF
        case .coral: Color(red: 1.00, green: 0.88, blue: 0.82)      // #FFE0D2
        case .lavender: Color(red: 0.93, green: 0.91, blue: 1.00)   // #EEE8FF
        }
    }

    /// The rim, the halo and the eyes' glow.
    var rim: Color {
        switch self {
        case .gold: Color(red: 1.00, green: 0.62, blue: 0.10)       // #FF9E1A
        case .copper: Color(red: 0.91, green: 0.54, blue: 0.29)     // #E8894A
        case .roseGold: Color(red: 0.95, green: 0.65, blue: 0.56)   // #F2A58E
        case .champagne: Color(red: 0.95, green: 0.87, blue: 0.72)  // #F3DDB8
        case .pearl: Color(red: 0.92, green: 0.94, blue: 1.00)      // #EAF0FF
        case .coral: Color(red: 1.00, green: 0.54, blue: 0.42)      // #FF8A6B
        case .lavender: Color(red: 0.73, green: 0.64, blue: 1.00)   // #B9A3FF
        }
    }
}
