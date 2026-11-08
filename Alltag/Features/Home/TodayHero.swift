//
//  TodayHero.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 08.11.26.
//

import SwiftUI

/// The top of Today: the amber orb that starts today's conversation, and
/// three numbers that open Progress.
struct TodayHero: View {
    let words: Int
    let minutesSpoken: Int
    let level: Level
    let onStart: () -> Void
    let onProgress: () -> Void

    var body: some View {
        VStack(spacing: 32) {
            Button(action: onStart) { HeroOrb() }
                .buttonStyle(.card)
                .accessibilityLabel("Start today's conversation")

            Button(action: onProgress) {
                HStack(alignment: .top) {
                    stat("Words", value: Text(words, format: .number), tint: .accent)
                    stat("Spoken", value: Text("\(minutesSpoken) min"), tint: .success)
                    stat("Level", value: Text(verbatim: level.title), tint: .secondary)
                }
                .contentShape(.rect)
            }
            .buttonStyle(.tile)
            .accessibilityElement(children: .combine)
            .accessibilityHint("Opens your progress.")
        }
        .frame(maxWidth: .infinity)
    }

    private func stat(_ title: LocalizedStringResource, value: Text, tint: Color) -> some View {
        VStack(spacing: 6) {
            Text(title)
                .textRole(.eyebrow)
                .textCase(.uppercase)
                .foregroundStyle(tint)
            value
                .textRole(.title2)
                .monospacedDigit()
        }
        .frame(maxWidth: .infinity)
    }
}

/// A glowing amber sphere resting on a soft shadow. Drawn once, never animated.
private struct HeroOrb: View {
    @ScaledMetric(relativeTo: .largeTitle) private var size: CGFloat = 168

    var body: some View {
        ZStack {
            Circle()
                .fill(.accentFill)
                .frame(width: size * 1.35, height: size * 1.35)
                .blur(radius: size * 0.35)
                .opacity(0.35)

            Ellipse()
                .fill(.black.opacity(0.35))
                .frame(width: size * 0.75, height: size * 0.12)
                .blur(radius: 8)
                .offset(y: size * 0.56)

            Circle()
                .fill(Self.gradient)
                .overlay {
                    // Specular highlight, top left.
                    Ellipse()
                        .fill(.white.opacity(0.55))
                        .frame(width: size * 0.32, height: size * 0.2)
                        .blur(radius: size * 0.05)
                        .rotationEffect(.degrees(-30))
                        .offset(x: -size * 0.2, y: -size * 0.26)
                }
                .overlay {
                    Circle().strokeBorder(.white.opacity(0.22), lineWidth: 1)
                }
                .overlay {
                    Image(systemName: "waveform")
                        .font(.system(size: size * 0.22, weight: .semibold))
                        .foregroundStyle(.white.opacity(0.85))
                        .blendMode(.overlay)
                }
                .frame(width: size, height: size)
        }
        .frame(height: size * 1.25)
        .accessibilityHidden(true)
    }

    private static let gradient = RadialGradient(
        stops: [.init(color: Color(red: 1, green: 0.973, blue: 0.918), location: 0),        // #FFF8EA
                .init(color: Color(red: 0.973, green: 0.765, blue: 0.475), location: 0.42), // #F8C379
                .init(color: Color(red: 0.71, green: 0.424, blue: 0.176), location: 0.85),  // #B56C2D
                .init(color: Color(red: 0.36, green: 0.2, blue: 0.08), location: 1)],
        center: UnitPoint(x: 0.36, y: 0.3), startRadius: 0, endRadius: 120)
}

#Preview {
    TodayHero(words: 18, minutesSpoken: 42, level: .b1, onStart: {}, onProgress: {})
        .padding(Spacing.screen)
        .background(.screenBackground)
}
