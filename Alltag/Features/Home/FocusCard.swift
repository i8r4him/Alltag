//
//  FocusCard.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// "Today's Focus": the one thing to do today, with a big Start talking button.
struct FocusCard: View {
    let action: () -> Void

    var body: some View {
        // One container for the card, the pill and the button: their glass is
        // rendered together instead of each sampling the screen on its own.
        GlassEffectContainer(spacing: 0) {
            content
                .padding(Spacing.cardLarge)
                .frame(maxWidth: .infinity, alignment: .leading)
                .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
        }
        .fontDesign(.rounded)
    }

    private var content: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Today's focus")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.accent)
                Spacer(minLength: 8)
                Label("5 min", systemImage: "clock")
                    .labelStyle(.titleAndIcon)
                    .font(.footnote.weight(.semibold))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .glassEffect(.regular, in: .capsule)
            }

            VStack(alignment: .leading, spacing: 12) {
                Text("Moving an appointment")
                    .textRole(.title2)
                    .fixedSize(horizontal: false, vertical: true)

                VStack(alignment: .leading, spacing: 6) {
                    Label("Practises the word order you mixed up yesterday", systemImage: "calendar")
                }
                .textRole(.body)
                .foregroundStyle(.secondary)
                .labelStyle(FocusDetailLabelStyle())
            }

            Button(action: action) {
                Label("Start talking", systemImage: "waveform")
                    .font(.title3.weight(.bold))
                    .fontDesign(.rounded)
                    .frame(maxWidth: .infinity, minHeight: 34)
            }
            .buttonStyle(AmberButtonStyle())
            .accessibilityHint("Starts a conversation at the dentist.")
        }
    }
}

/// The Start talking button, shared by every Focus card design.
struct StartTalkingButton: View {
    let action: () -> Void

    var body: some View {
        GlassEffectContainer {
            Button(action: action) {
                Label("Start talking", systemImage: "waveform")
                    .font(.title3.weight(.bold))
                    .fontDesign(.rounded)
                    .frame(maxWidth: .infinity, minHeight: 34)
            }
            .buttonStyle(AmberButtonStyle())
            .accessibilityHint("Starts a conversation at the dentist.")
        }
    }
}

/// A glass capsule with two soft amber lights rising from its bottom edge.
private struct AmberButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(.white)
            .padding(.vertical, 12)
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
            }
            // Interactive glass animates the press itself (scale and glow); a second
            // scale animation on the same layer fights it and drops frames.
            .glassEffect(.regular.interactive(), in: .capsule)
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

/// An icon in a fixed-width column, so both detail lines start at the same edge.
private struct FocusDetailLabelStyle: LabelStyle {
    @ScaledMetric(relativeTo: .body) private var iconWidth: CGFloat = 22

    func makeBody(configuration: Configuration) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 10) {
            configuration.icon
                .font(.subheadline)
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.accent)
                .frame(width: iconWidth)
            configuration.title
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview {
    FocusCard {}
        .padding(Spacing.screen)
        .background(.screenBackground)
}
