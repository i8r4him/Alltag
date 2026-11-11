//
//  Buttons.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

// MARK: - Primary

/// The app's big button: a glass capsule with two soft lights in the theme
/// colour rising from its bottom edge ("Start talking", "Continue").
/// `.primaryCompact` is the small filled capsule inside cards ("Start review").
struct PrimaryButtonStyle: ButtonStyle {
    enum Size { case large, compact }

    var size: Size = .large

    func makeBody(configuration: Configuration) -> some View {
        switch size {
        case .large: BigButtonBody(configuration: configuration)
        case .compact: CompactButtonBody(configuration: configuration)
        }
    }
}

private struct BigButtonBody: View {
    let configuration: ButtonStyleConfiguration
    @Environment(\.isEnabled) private var isEnabled
    @Environment(\.colorScheme) private var colorScheme

    /// White on the dark glass; the theme's deep tone on the light glass, where white can't be read.
    private var labelColour: Color {
        colorScheme == .dark ? .white : AppTheme.shared.palette.deep
    }

    var body: some View {
        configuration.label
            .font(.title3.weight(.bold))
            .fontDesign(.rounded)
            .foregroundStyle(labelColour.opacity(isEnabled ? 1 : 0.45))
            .frame(maxWidth: .infinity, minHeight: 34)
            .padding(.vertical, 12)
            .padding(.horizontal, 20)
            .background {
                ZStack {
                    BottomLight(color: Self.honey, x: 0.3)
                    BottomLight(color: Self.orange, x: 0.78)
                }
                .clipShape(.capsule)
                .overlay {
                    // The rim: faint white at the top, the lights' colours along the bottom.
                    Capsule().strokeBorder(
                        LinearGradient(colors: [.white.opacity(0.18), .clear],
                                       startPoint: .top, endPoint: .center),
                        lineWidth: 1)
                    Capsule().strokeBorder(
                        LinearGradient(colors: [.clear, Self.honey.opacity(0.7), Self.orange.opacity(0.8), .clear],
                                       startPoint: .leading, endPoint: .trailing),
                        lineWidth: 1)
                        .mask {
                            LinearGradient(colors: [.clear, .black], startPoint: .center, endPoint: .bottom)
                        }
                }
                // Disabled: the lights go out.
                .opacity(isEnabled ? 1 : 0.25)
            }
            // Interactive glass animates the press itself (scale and glow); a second
            // scale animation on the same layer fights it and drops frames.
            .glassEffect(isEnabled ? .regular.interactive() : .regular, in: .capsule)
            .contentShape(.capsule)
            .sensoryFeedback(.impact(weight: .medium), trigger: configuration.isPressed) { _, pressed in pressed }
    }

    /// The two lights, from the theme. Gold keeps its original honey and orange.
    static var honey: Color {
        AppTheme.shared.palette == .gold ? Color(hex: 0xFFCC7A) : AppTheme.shared.palette.mid
    }
    static var orange: Color {
        AppTheme.shared.palette == .gold ? Color(hex: 0xF28C38) : AppTheme.shared.palette.rim
    }
}

/// A soft light centred just below the bottom edge, fading upwards.
private struct BottomLight: View {
    let color: Color
    let x: CGFloat

    var body: some View {
        RadialGradient(colors: [color.opacity(0.55), color.opacity(0.18), .clear],
                       center: UnitPoint(x: x, y: 1.1),
                       startRadius: 0, endRadius: 140)
    }
}

private struct CompactButtonBody: View {
    let configuration: ButtonStyleConfiguration
    @Environment(\.isEnabled) private var isEnabled

    var body: some View {
        configuration.label
            .textRole(.bodySmall)
            .fontWeight(.semibold)
            .foregroundStyle(isEnabled ? AnyShapeStyle(.onAccent) : AnyShapeStyle(.tertiary))
            .frame(minHeight: Spacing.minTouchTarget)
            .padding(.horizontal, 16)
            .background(isEnabled ? AnyShapeStyle(.accentFill) : AnyShapeStyle(.surfaceTertiary), in: .capsule)
            .contentShape(.capsule)
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .opacity(configuration.isPressed ? 0.85 : 1)
            .animation(.easeOut(duration: 0.15), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == PrimaryButtonStyle {
    /// The big button: full-width glass capsule with the theme's lights.
    static var primary: PrimaryButtonStyle { PrimaryButtonStyle() }
    /// Compact filled capsule for use inside cards.
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

// MARK: - Card

/// For whole cards and tiles that are tappable: shrinks slightly while pressed.
struct PressableCardStyle: ButtonStyle {
    var pressedScale: CGFloat = 0.98

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? pressedScale : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == PressableCardStyle {
    /// Cards: shrink to 98% while pressed.
    static var card: PressableCardStyle { PressableCardStyle() }
    /// Small tiles: shrink to 96% while pressed.
    static var tile: PressableCardStyle { PressableCardStyle(pressedScale: 0.96) }
}
