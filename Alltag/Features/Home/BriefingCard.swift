//
//  BriefingCard.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 09.11.26.
//

import SwiftUI

/// "Your briefing": a big "60 seconds" like the Today numbers, the text, and a
/// play button, on the Focus card's surface.
struct BriefingCard: View {
    let words: Int
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
                Text("Your briefing")
                    .font(.title3.weight(.semibold))
                Text("Built from ^[\(words) word](inflect: true) you are learning.")
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
            .accessibilityLabel("Listen to your 60-second briefing")
        }
        .padding(Spacing.cardLarge)
        .frame(maxWidth: .infinity)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
        .fontDesign(.rounded)
        .sensoryFeedback(.impact(weight: .light), trigger: taps)
    }
}

#Preview {
    BriefingCard(words: 6) {}
        .padding(Spacing.screen)
        .background(.screenBackground)
}
