//
//  LearnView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftData
import SwiftUI

/// Learn: conversations for you, short practice moments from the learner's week,
/// Grammar and Progress.
struct LearnView: View {
    @Environment(AppState.self) private var appState
    @Query private var profiles: [UserProfile]

    private var level: Level { profiles.first?.level ?? .a1 }

    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.grid) {
                ForYouCarousel(scenarios: MockScenarios.all) { appState.present(.conversation($0)) }
                    .padding(.bottom, Spacing.grid)
                MistakesCard { appState.present(.activity(.mistakes)) }
                    .padding(.bottom, 8)
                LearnRow(title: "Recall \(MockActivities.recall.questions.count) words from Safari",
                         subtitle: "In the sentences where you found them",
                         systemImage: "brain", minutes: 2) {
                    appState.present(.activity(.recall))
                }
                LearnRow(title: "Listen: platform change",
                         subtitle: "For your trip to Munich on Friday",
                         systemImage: "ear", minutes: 1) {
                    appState.present(.activity(.listen))
                }
                LearnRow(title: "Speak: moving an appointment",
                         subtitle: "Today's focus · a phone call scenario",
                         systemImage: "waveform", minutes: 5) {
                    appState.present(.conversation(.dentist))
                }
                GrammarCard(rulesWorthALook: GrammarCard.rulesWithMistakes()) { appState.open(.grammar) }
                    .padding(.top, 8)
                LearnRow(title: "Your progress",
                         subtitle: "\(level.title) · what you can handle now",
                         systemImage: "chart.line.uptrend.xyaxis", minutes: nil) {
                    appState.open(.progress)
                }
            }
            .padding(.horizontal, Spacing.screen)
            .padding(.top, 8)
            .padding(.bottom, 24)
        }
        .readableContentMargins()
        .background(.screenBackground)
        .navigationTitle("Learn")
        .navigationBarTitleDisplayMode(.large)
        .navigationSubtitle(Text("Short moments, picked from your week."))
    }
}

/// "Fix your mistakes": the learner's own sentence with the mistake underlined.
private struct MistakesCard: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 18) {
                HStack {
                    Eyebrow(title: "Fix your mistakes", tone: .mistake)
                    Spacer()
                    Pill(title: "1 min")
                }
                quote
                    .font(.system(.title2, weight: .semibold))
                Text("You wrote this in Messages yesterday · plus one from a conversation")
                    .textRole(.bodySmall)
                    .foregroundStyle(.tertiary)
            }
            .multilineTextAlignment(.leading)
            .padding(Spacing.cardLarge)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.surface, in: .rect(cornerRadius: Radius.hero, style: .continuous))
            .contentShape(.rect(cornerRadius: Radius.hero, style: .continuous))
        }
        .buttonStyle(.card)
        .accessibilityElement(children: .combine)
        .accessibilityHint("Starts a one-minute exercise on your mistakes.")
    }

    /// „Ich wohne hier **für drei Jahren**." — the mistake bright, underlined in coral.
    /// Built as an attributed string: it's German content, not catalog text.
    private var quote: Text {
        var opening = AttributedString("„Ich wohne hier ")
        opening.foregroundColor = .secondary
        var mistake = AttributedString("für drei Jahren")
        mistake.foregroundColor = .primary
        mistake.underlineStyle = Text.LineStyle(pattern: .solid, color: .mistake)
        var closing = AttributedString(".“")
        closing.foregroundColor = .secondary
        return Text(opening + mistake + closing)
    }
}

/// A practice moment: symbol tile, title, subtitle and length.
private struct LearnRow: View {
    let title: LocalizedStringResource
    let subtitle: LocalizedStringResource
    let systemImage: String
    /// The length, or `nil` for a screen rather than an exercise (shows a chevron).
    let minutes: Int?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: systemImage)
                    .font(.system(size: 22))
                    .frame(width: 48, height: 48)
                    .background(.surfaceSecondary, in: .rect(cornerRadius: 14, style: .continuous))
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .textRole(.body)
                        .fontWeight(.semibold)
                    Text(subtitle)
                        .textRole(.meta)
                        .foregroundStyle(.secondary)
                }
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                if let minutes {
                    Text("\(minutes) min")
                        .textRole(.meta)
                        .foregroundStyle(.tertiary)
                } else {
                    Image(systemName: "chevron.right")
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(.tertiary)
                        .accessibilityHidden(true)
                }
            }
            .padding(Spacing.card)
            .background(.surface, in: .rect(cornerRadius: Radius.card, style: .continuous))
            .contentShape(.rect(cornerRadius: Radius.card, style: .continuous))
        }
        .buttonStyle(.card)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    NavigationStack { LearnView() }
        .environment(AppState())
        .modelContainer(AlltagStore.preview)
}
