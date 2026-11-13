//
//  FocusCard.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// "Today's Focus": the one thing to do today. The title and a short line on
/// the left, its artwork on the right, and the big button. Once it has been
/// done today, it says so and offers to do it again.
struct FocusCard: View {
    let focus: TodayFocus
    var isDone = false
    let action: () -> Void

    @ScaledMetric(relativeTo: .title3) private var artworkSize: CGFloat = 96

    var body: some View {
        VStack(spacing: 18) {
            HStack(alignment: .center, spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    if isDone {
                        Label("Done today", systemImage: "checkmark.circle.fill")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.accent)
                    }
                    Text(verbatim: focus.title)
                        .font(.title3.weight(.semibold))
                        .fixedSize(horizontal: false, vertical: true)
                    Text(verbatim: focus.line)
                        .font(.title3)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .environment(\.locale, focus.isGerman ? Locale(identifier: "de") : .current)
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityElement(children: .combine)
                ScenarioArtwork(systemImage: focus.systemImage)
                    .frame(width: artworkSize, height: artworkSize)
            }
            GlassEffectContainer {
                Button(action: action) {
                    Label {
                        Text(isDone ? "Do it again" : focus.buttonTitle)
                    } icon: {
                        Image(systemName: isDone ? "arrow.counterclockwise" : focus.buttonImage)
                    }
                }
                .buttonStyle(.primary)
            }
        }
        .padding(Spacing.cardLarge)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
        .fontDesign(.rounded)
    }
}

/// A small square illustration of a scenario: a soft wash in the theme colour
/// with a large symbol, fading out at the bottom like a photo.
struct ScenarioArtwork: View {
    let systemImage: String
    var symbolSize: CGFloat = 52
    var cornerRadius: CGFloat = 18

    var body: some View {
        ZStack {
            // Two colours from the theme: its bright accent into its deep tone.
            LinearGradient(colors: [Color.accentFill.opacity(0.95), AppTheme.shared.palette.deep.opacity(0.8)],
                           startPoint: .topTrailing, endPoint: .bottomLeading)
            RadialGradient(colors: [.white.opacity(0.35), .clear],
                           center: UnitPoint(x: 0.25, y: 0.2), startRadius: 0, endRadius: 60)
            Image(systemName: systemImage)
                .font(.system(size: symbolSize, weight: .light))
                .foregroundStyle(.white.opacity(0.85))
                .rotationEffect(.degrees(-12))
                .offset(x: 8, y: 6)
        }
        .clipShape(.rect(cornerRadius: cornerRadius, style: .continuous))
        // Fades out at the bottom, into the card.
        .mask {
            LinearGradient(stops: [.init(color: .black, location: 0.55), .init(color: .clear, location: 1)],
                           startPoint: .top, endPoint: .bottom)
        }
        .accessibilityHidden(true)
    }
}

#Preview {
    FocusCard(focus: .make(.situation, level: .b1)) {}
        .padding(Spacing.screen)
        .background(.screenBackground)
}
