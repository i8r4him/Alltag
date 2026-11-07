//
//  FocusCard.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// "Today's Focus": the one thing to do today, opening a conversation.
struct FocusCard: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Eyebrow(title: "Today's focus")
                    Spacer()
                    Pill(title: "5 min")
                }
                Spacer(minLength: 20)
                VStack(alignment: .leading, spacing: 6) {
                    Text("Speak German")
                        .textRole(.largeTitle)
                    Text("Real-life conversation · Moving an appointment")
                        .textRole(.bodySmall)
                        .foregroundStyle(.secondary)
                }
                Spacer(minLength: 20)
                HStack(alignment: .bottom, spacing: 16) {
                    Text("Picks up the word order you mixed up yesterday.")
                        .textRole(.meta)
                        .foregroundStyle(.tertiary)
                        .frame(maxWidth: 200, alignment: .leading)
                    Spacer(minLength: 0)
                    Image(systemName: "waveform")
                        .font(.system(size: 26, weight: .semibold))
                        .foregroundStyle(.onAccent)
                        .frame(width: 56, height: 56)
                        .background(.accentFill, in: .circle)
                        .accessibilityHidden(true)
                }
            }
            .multilineTextAlignment(.leading)
            .padding(Spacing.cardLarge)
            .frame(maxWidth: .infinity, minHeight: 214, alignment: .leading)
            .background {
                RoundedRectangle(cornerRadius: Radius.hero, style: .continuous)
                    .fill(.surface)
                    .overlay {
                        // Soft amber glow from the top-right corner.
                        RadialGradient(colors: [.accentFill.opacity(0.2), .clear],
                                       center: .topTrailing, startRadius: 0, endRadius: 260)
                            .clipShape(.rect(cornerRadius: Radius.hero, style: .continuous))
                    }
            }
            .contentShape(.rect(cornerRadius: Radius.hero, style: .continuous))
        }
        .buttonStyle(.card)
        .accessibilityElement(children: .combine)
        .accessibilityHint("Starts a conversation at the dentist.")
    }
}

#Preview {
    FocusCard {}
        .padding(Spacing.screen)
        .background(.screenBackground)
}
