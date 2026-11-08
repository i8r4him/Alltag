//
//  FocusCard.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// "Today's Focus": the one thing to do today. The title and a short line on
/// the left, the scenario's artwork on the right, and the Start talking button.
struct FocusCard: View {
    let action: () -> Void

    @ScaledMetric(relativeTo: .title3) private var artworkSize: CGFloat = 96

    var body: some View {
        VStack(spacing: 18) {
            HStack(alignment: .center, spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("Moving an appointment")
                        .font(.title3.weight(.semibold))
                        .fixedSize(horizontal: false, vertical: true)
                    Text("A short phone call at the dentist.")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityElement(children: .combine)
                ScenarioArtwork(systemImage: "cross.case.fill")
                    .frame(width: artworkSize, height: artworkSize)
            }
            StartTalkingButton(action: action)
        }
        .padding(Spacing.cardLarge)
        .background {
            RoundedRectangle(cornerRadius: Radius.hero, style: .continuous)
                .fill(.surface)
                .overlay {
                    RoundedRectangle(cornerRadius: Radius.hero, style: .continuous)
                        .strokeBorder(.white.opacity(0.06), lineWidth: 1)
                }
        }
        .fontDesign(.rounded)
    }
}

/// A small square illustration of a scenario: a soft wash in the theme colour
/// with a large symbol, fading out at the bottom like a photo.
private struct ScenarioArtwork: View {
    let systemImage: String

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.accentFill.opacity(0.85), Color.accentFill.opacity(0.25)],
                           startPoint: .topTrailing, endPoint: .bottomLeading)
            RadialGradient(colors: [.white.opacity(0.35), .clear],
                           center: UnitPoint(x: 0.25, y: 0.2), startRadius: 0, endRadius: 60)
            Image(systemName: systemImage)
                .font(.system(size: 52, weight: .light))
                .foregroundStyle(.white.opacity(0.85))
                .rotationEffect(.degrees(-12))
                .offset(x: 8, y: 6)
        }
        .clipShape(.rect(cornerRadius: 18, style: .continuous))
        // Fades out at the bottom, into the card.
        .mask {
            LinearGradient(stops: [.init(color: .black, location: 0.55), .init(color: .clear, location: 1)],
                           startPoint: .top, endPoint: .bottom)
        }
        .accessibilityHidden(true)
    }
}

/// The Start talking button: glass with two soft lights rising from its bottom edge.
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

#Preview {
    FocusCard {}
        .padding(Spacing.screen)
        .background(.screenBackground)
}
