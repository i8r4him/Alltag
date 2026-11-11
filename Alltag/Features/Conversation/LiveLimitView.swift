//
//  LiveLimitView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 11.11.26.
//

import SwiftUI

/// Shown in free talk when today's live conversations are used up: what
/// happened, when it's possible again, and what still works.
struct LiveLimitView: View {
    let onDone: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            ContentUnavailableView {
                Label {
                    Text("That's all for today")
                } icon: {
                    Image(systemName: "moon.zzz.fill")
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.accent)
                }
            } description: {
                Text("You've used today's live conversations. You can talk again tomorrow.")
            }

            VStack(spacing: 12) {
                Label("Everything in Learn still works, as often as you like.", systemImage: "book.fill")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(Spacing.card)
                    .glassEffect(.regular, in: .rect(cornerRadius: Radius.card, style: .continuous))
                Button(action: onDone) { Text("Done") }
                    .buttonStyle(.primary)
            }
            .padding(.horizontal, 22)
            .padding(.bottom, 12)
        }
    }
}

/// The short notice when the live voice can't start or stops.
enum LiveVoiceNotice {
    static func text(for reason: RealtimeServiceError?, freeTalk: Bool) -> LocalizedStringResource {
        // Free talk has no script, so the companion can only be tried again.
        if freeTalk { return "I can't talk right now. Tap me to try again." }
        switch reason {
        case .dailyLimit: return "You've reached your live voice limit for today. Keep practising on your iPhone."
        case .busy: return "Live voice is busy right now. You can keep practising on your iPhone."
        default: return "Live voice is unavailable. You can keep practising on your iPhone."
        }
    }
}

#Preview {
    LiveLimitView {}
        .skyBackground()
}
