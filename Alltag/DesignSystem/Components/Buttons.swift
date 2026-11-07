//
//  Buttons.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

// MARK: - Primary

/// The amber capsule button: full-width 54pt call to action ("Continue"),
/// or compact inside cards ("Start review").
struct PrimaryButtonStyle: ButtonStyle {
    enum Size { case large, compact }

    var size: Size = .large

    func makeBody(configuration: Configuration) -> some View {
        PrimaryButtonBody(configuration: configuration, size: size)
    }
}

private struct PrimaryButtonBody: View {
    let configuration: ButtonStyleConfiguration
    let size: PrimaryButtonStyle.Size
    @Environment(\.isEnabled) private var isEnabled

    var body: some View {
        configuration.label
            .textRole(size == .large ? .cardTitle : .bodySmall)
            .fontWeight(.semibold)
            .foregroundStyle(isEnabled ? AnyShapeStyle(.onAccent) : AnyShapeStyle(.tertiary))
            .frame(maxWidth: size == .large ? .infinity : nil)
            .frame(minHeight: size == .large ? 54 : Spacing.minTouchTarget)
            .padding(.horizontal, size == .large ? 24 : 16)
            .background(isEnabled ? AnyShapeStyle(.accentFill) : AnyShapeStyle(.surfaceTertiary), in: .capsule)
            .contentShape(.capsule)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .opacity(configuration.isPressed ? 0.85 : 1)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {
    /// Full-width amber capsule, 54pt high.
    static var primary: PrimaryButtonStyle { PrimaryButtonStyle() }
    /// Compact amber capsule for use inside cards.
    static var primaryCompact: PrimaryButtonStyle { PrimaryButtonStyle(size: .compact) }
}

// MARK: - Outline

/// Capsule with a hairline border, e.g. "Not sure? Find out in one question".
struct OutlineButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .textRole(.bodySmall)
            .fontWeight(.medium)
            .foregroundStyle(.primary)
            .frame(maxWidth: .infinity, minHeight: Spacing.minTouchTarget)
            .padding(.horizontal, 16)
            .overlay { Capsule().strokeBorder(.separator, lineWidth: 1) }
            .contentShape(.capsule)
            .opacity(configuration.isPressed ? 0.6 : 1)
    }
}

extension ButtonStyle where Self == OutlineButtonStyle {
    static var outline: OutlineButtonStyle { OutlineButtonStyle() }
}

// MARK: - Glass

/// A circular glass button with an SF Symbol, e.g. back, close or settings.
struct GlassButton: View {
    let systemImage: String
    let accessibilityLabel: LocalizedStringKey
    var diameter: CGFloat = 36
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: diameter * 0.42, weight: .semibold))
                .foregroundStyle(.primary)
                .frame(width: diameter, height: diameter)
                .glassEffect(.regular.interactive(), in: .circle)
                // Keeps the tap area at least 44pt even for small buttons.
                .frame(minWidth: Spacing.minTouchTarget, minHeight: Spacing.minTouchTarget)
                .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(accessibilityLabel)
    }
}
