//
//  MistakesCard.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 10.11.26.
//

import SwiftUI

/// "Fix your mistakes": a stack of cards, one per mistake, the first on top
/// with your sentence and the mistake underlined in coral.
struct MistakesCard: View {
    let action: () -> Void

    @State private var taps = 0

    private var mistakes: [SampleMistake] { SampleMistake.all }
    private var first: SampleMistake { SampleMistake.all[0] }

    var body: some View {
        Button {
            taps += 1
            action()
        } label: {
            VStack(alignment: .leading, spacing: 14) {
                HStack {
                    Label { Text(first.source) } icon: { Image(systemName: first.systemImage) }
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.accent)
                    Spacer()
                    Text("1 of ^[\(mistakes.count) mistake](inflect: true)")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                first.quote
                    .font(.title2.weight(.semibold))
                Text("Tap to fix it")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .multilineTextAlignment(.leading)
            .padding(Spacing.cardLarge)
            .frame(maxWidth: .infinity, alignment: .leading)
            .learnSurface()
            .background(alignment: .bottom) {
                ZStack(alignment: .bottom) {
                    RoundedRectangle(cornerRadius: Radius.hero, style: .continuous)
                        .fill(.white.opacity(0.07))
                        .padding(.horizontal, 28)
                        .offset(y: 20)
                    RoundedRectangle(cornerRadius: Radius.hero, style: .continuous)
                        .fill(.white.opacity(0.12))
                        .padding(.horizontal, 14)
                        .offset(y: 10)
                }
            }
            .padding(.bottom, 20)
        }
        .buttonStyle(.plain)
        .fontDesign(.rounded)
        .sensoryFeedback(.impact(weight: .light), trigger: taps)
        .accessibilityElement(children: .combine)
        .accessibilityHint("Starts a one-minute exercise on your mistakes.")
    }
}

/// One of the learner's mistakes (mock content until the logic is built).
private struct SampleMistake {
    let before: String
    let wrong: String
    let after: String
    let source: LocalizedStringResource
    let systemImage: String

    static let all = [
        SampleMistake(before: "Ich wohne hier ", wrong: "für drei Jahren", after: ".",
                      source: "Messages · yesterday", systemImage: "message.fill"),
        SampleMistake(before: "… wenn ", wrong: "das passt mir", after: ".",
                      source: "Conversation · dentist", systemImage: "waveform")
    ]

    /// The sentence with the mistake underlined in coral.
    var quote: Text {
        var opening = AttributedString("„" + before)
        opening.foregroundColor = .secondary
        var mistake = AttributedString(wrong)
        mistake.foregroundColor = .primary
        mistake.underlineStyle = Text.LineStyle(pattern: .solid, color: .mistake)
        var closing = AttributedString(after + "“")
        closing.foregroundColor = .secondary
        return Text(opening + mistake + closing)
    }
}

#Preview {
    MistakesCard {}
        .padding(Spacing.screen)
        .background(.screenBackground)
}
