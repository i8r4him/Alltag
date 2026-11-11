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

/// The Start talking button: the app's big button with a waveform.
struct StartTalkingButton: View {
    let action: () -> Void

    var body: some View {
        GlassEffectContainer {
            Button(action: action) {
                Label("Start talking", systemImage: "waveform")
            }
            .buttonStyle(.primary)
            .accessibilityHint("Starts a conversation at the dentist.")
        }
    }
}

#Preview {
    FocusCard {}
        .padding(Spacing.screen)
        .background(.screenBackground)
}
