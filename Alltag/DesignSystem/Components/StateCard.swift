//
//  StateCard.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// A state that isn't the answer (nothing found, offline, the cloud off, a
/// limit reached), in the Focus card's layout: what happened on the left, the
/// theme's artwork on the right, and a glass button under it when there is
/// something to do.
struct StateCard: View {
    /// The button under the card.
    struct Action {
        let title: LocalizedStringResource
        let systemImage: String
        let run: () -> Void

        static func tryAgain(_ run: @escaping () -> Void) -> Action {
            Action(title: "Try again", systemImage: "arrow.clockwise", run: run)
        }
    }

    let systemImage: String
    let title: Text
    let explanation: Text
    var action: Action?

    @ScaledMetric(relativeTo: .title3) private var artworkSize: CGFloat = 72

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .center, spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    title.font(.title3.weight(.semibold))
                    explanation
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityElement(children: .combine)
                ScenarioArtwork(systemImage: systemImage, symbolSize: 34, cornerRadius: 16)
                    .frame(width: artworkSize, height: artworkSize)
            }
            if let action {
                Button(action: action.run) {
                    Label { Text(action.title) } icon: { Image(systemName: action.systemImage) }
                        .font(.headline)
                        .frame(maxWidth: .infinity, minHeight: 34)
                }
                .buttonStyle(.glass)
            }
        }
        .padding(Spacing.cardLarge)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }
}

/// The state card for a failed request to the server.
struct CloudFailureCard: View {
    let failure: CloudFailure
    /// What couldn't be done, for the "other" case ("Couldn't look it up").
    let failedTitle: Text
    let onRetry: () -> Void

    var body: some View {
        switch failure {
        case .offline:
            StateCard(systemImage: "wifi.slash", title: Text("You’re offline"),
                      explanation: Text("This needs the internet. Connect to Wi‑Fi or mobile data."),
                      action: .tryAgain(onRetry))
        case .cloudOff:
            StateCard(systemImage: "icloud.slash", title: Text("Online help is off"),
                      explanation: Text("Turn on “Talk and get corrections online” in Settings to use this."))
        case .dailyLimit:
            StateCard(systemImage: "hourglass", title: Text("That’s all for today"),
                      explanation: Text("You’ve used today’s online help. Try again tomorrow."))
        case .other:
            StateCard(systemImage: "exclamationmark.triangle", title: failedTitle,
                      explanation: Text("Something went wrong on the way. Try again in a moment."),
                      action: .tryAgain(onRetry))
        }
    }
}
