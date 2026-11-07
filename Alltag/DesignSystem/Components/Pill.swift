//
//  Pill.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// A small capsule label, e.g. "5 min", "MISTAKE" or "NEW".
struct Pill: View {
    enum Tone { case neutral, accent, success, mistake }

    let title: LocalizedStringKey
    var systemImage: String?
    var tone: Tone = .neutral

    var body: some View {
        HStack(spacing: 4) {
            if let systemImage {
                Image(systemName: systemImage).imageScale(.small)
            }
            Text(title)
        }
        .textRole(.caption)
        .fontWeight(.semibold)
        .foregroundStyle(foreground)
        .padding(.horizontal, 10)
        .padding(.vertical, 4)
        .background(background, in: .capsule)
    }

    private var foreground: Color {
        switch tone {
        case .neutral: .secondary
        case .accent: .accent
        case .success: .success
        case .mistake: .mistake
        }
    }

    private var background: Color {
        switch tone {
        case .neutral: .controlFill
        case .accent: .accentFill.opacity(0.18)
        case .success: .success.opacity(0.16)
        case .mistake: .mistake.opacity(0.16)
        }
    }
}

/// A tappable chip, e.g. Memory filters or onboarding interests.
/// Selected chips are inverted (label colour fill, background-coloured text).
struct ChipButtonStyle: ButtonStyle {
    var isSelected: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .textRole(.meta)
            .fontWeight(.medium)
            .foregroundStyle(isSelected ? AnyShapeStyle(.background) : AnyShapeStyle(.primary))
            .padding(.horizontal, 14)
            .frame(minHeight: 32)
            .background(isSelected ? AnyShapeStyle(.primary) : AnyShapeStyle(.controlFill), in: .capsule)
            .contentShape(.capsule)
            .padding(.vertical, 6) // 44pt tap target
            .opacity(configuration.isPressed ? 0.7 : 1)
            .accessibilityAddTraits(isSelected ? .isSelected : [])
    }
}

extension ButtonStyle where Self == ChipButtonStyle {
    static func chip(isSelected: Bool) -> ChipButtonStyle { ChipButtonStyle(isSelected: isSelected) }
}
