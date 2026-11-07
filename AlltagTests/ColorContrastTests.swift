//
//  ColorContrastTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Testing
import UIKit
@testable import Alltag

/// Checks that brand colours meet WCAG AA (4.5 : 1) for text in both appearances.
@Suite("Colour contrast")
struct ColorContrastTests {
    static let textColors = ["AccentColor", "Success", "Mistake"]

    @Test("Text colours are readable on light backgrounds", arguments: textColors)
    func lightMode(name: String) throws {
        let color = try resolved(name, .light)
        for background in [UIColor.white, UIColor.systemGroupedBackground.resolved(.light)] {
            #expect(contrast(color, background) >= 4.5, "\(name) on \(background)")
        }
    }

    @Test("Text colours are readable on dark backgrounds", arguments: textColors)
    func darkMode(name: String) throws {
        let color = try resolved(name, .dark)
        for background in [UIColor.black, UIColor.secondarySystemGroupedBackground.resolved(.dark)] {
            #expect(contrast(color, background) >= 4.5, "\(name) on \(background)")
        }
    }

    @Test("Text on the accent fill is readable", arguments: [UIUserInterfaceStyle.light, .dark])
    func onAccent(style: UIUserInterfaceStyle) throws {
        let fill = try resolved("AccentFill", style)
        let text = try resolved("OnAccent", style)
        #expect(contrast(text, fill) >= 4.5)
    }

    // MARK: - Helpers

    private func resolved(_ name: String, _ style: UIUserInterfaceStyle) throws -> UIColor {
        let color = try #require(UIColor(named: name, in: .main, compatibleWith: nil), "Missing colour set \(name)")
        return color.resolved(style)
    }

    private func contrast(_ first: UIColor, _ second: UIColor) -> Double {
        let (lighter, darker) = (max(first.luminance, second.luminance), min(first.luminance, second.luminance))
        return (lighter + 0.05) / (darker + 0.05)
    }
}

private extension UIColor {
    func resolved(_ style: UIUserInterfaceStyle) -> UIColor {
        resolvedColor(with: UITraitCollection(userInterfaceStyle: style))
    }

    /// WCAG relative luminance.
    var luminance: Double {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        func linear(_ channel: CGFloat) -> Double {
            let value = Double(channel)
            return value <= 0.04045 ? value / 12.92 : pow((value + 0.055) / 1.055, 2.4)
        }
        return 0.2126 * linear(red) + 0.7152 * linear(green) + 0.0722 * linear(blue)
    }
}
