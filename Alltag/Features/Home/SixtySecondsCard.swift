//
//  SixtySecondsCard.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 09.11.26.
//

import SwiftUI

/// "60 seconds": a big 60 like the Today numbers, what it is, and a play
/// button that starts a minute of talking about a random topic.
struct SixtySecondsCard: View {
    let action: () -> Void

    @State private var taps = 0

    var body: some View {
        HStack(alignment: .center, spacing: 18) {
            VStack(spacing: 0) {
                Text(60, format: .number)
                    .font(.system(size: 56, weight: .bold, design: .rounded))
                    .foregroundStyle(LinearGradient(colors: [.accentFill, AppTheme.shared.palette.deep],
                                                    startPoint: .top, endPoint: .bottom))
                Text("SECONDS")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.accent)
            }
            .accessibilityHidden(true)

            VStack(alignment: .leading, spacing: 4) {
                Text("Talk for a minute")
                    .font(.title3.weight(.semibold))
                Text("A random topic. Your mistakes get fixed afterwards.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .fixedSize(horizontal: false, vertical: true)
            .accessibilityElement(children: .combine)

            Button {
                taps += 1
                action()
            } label: {
                Image(systemName: "play.fill")
                    .font(.title3)
                    .frame(width: 34, height: 34)
            }
            .buttonStyle(.glassProminent)
            .buttonBorderShape(.circle)
            .tint(Color.accentFill)
            .accessibilityLabel("Start 60 seconds of talking")
        }
        .padding(Spacing.cardLarge)
        .frame(maxWidth: .infinity)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
        .fontDesign(.rounded)
        .sensoryFeedback(.impact(weight: .light), trigger: taps)
    }
}

#Preview {
    SixtySecondsCard {}
        .padding(Spacing.screen)
        .background(.screenBackground)
}
