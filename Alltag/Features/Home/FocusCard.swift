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
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .top, spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    Eyebrow(title: "Today's focus")
                    Text("Moving an appointment")
                        .textRole(.cardTitle)
                    Text("A phone call at the dentist. Picks up the word order you mixed up yesterday.")
                        .textRole(.bodySmall)
                        .foregroundStyle(.secondary)
                }
                Spacer(minLength: 0)
                Pill(title: "5 min")
            }

            Button(action: action) {
                Label("Start talking", systemImage: "waveform")
                    .font(.body.weight(.semibold))
                    .frame(maxWidth: .infinity, minHeight: 34)
            }
            .buttonStyle(.glassProminent)
            .tint(.accentFill)
            .foregroundStyle(.onAccent)
            .accessibilityHint("Starts a conversation at the dentist.")
        }
        .padding(Spacing.cardLarge)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }
}

#Preview {
    FocusCard {}
        .padding(Spacing.screen)
        .background(.screenBackground)
}
