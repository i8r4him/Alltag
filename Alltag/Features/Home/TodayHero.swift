//
//  TodayHero.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 08.11.26.
//

import SwiftUI

/// The top of Today: the glowing orb that starts today's conversation, and
/// three numbers that open Progress.
struct TodayHero: View {
    let words: Int
    let minutesSpoken: Int
    let level: Level
    let onStart: () -> Void
    let onProgress: () -> Void

    @ScaledMetric(relativeTo: .largeTitle) private var orbSize: CGFloat = 230

    /// Counts taps, to play haptic feedback.
    @State private var starts = 0
    @State private var progressTaps = 0

    var body: some View {
        VStack(spacing: 32) {
            Button {
                starts += 1
                onStart()
            } label: {
                // The companion; its look is edited in Settings › Developer.
                CompanionOrb()
                    .frame(width: orbSize, height: orbSize)
            }
                .buttonStyle(.card)
                .sensoryFeedback(.impact(weight: .medium), trigger: starts)
                .accessibilityLabel("Start today's conversation")

            Button {
                progressTaps += 1
                onProgress()
            } label: {
                HStack(alignment: .top) {
                    stat("Words", value: Text(words, format: .number), tint: .accent)
                    stat("Spoken", value: Text("\(minutesSpoken) min"), tint: .success)
                    stat("Level", value: Text(verbatim: level.title), tint: .secondary)
                }
                .fontDesign(.rounded)
                .contentShape(.rect)
            }
            .buttonStyle(.tile)
            .sensoryFeedback(.impact(weight: .light), trigger: progressTaps)
            .accessibilityElement(children: .combine)
            .accessibilityHint("Opens your progress.")
        }
        .frame(maxWidth: .infinity)
    }

    private func stat(_ title: LocalizedStringResource, value: Text, tint: Color) -> some View {
        VStack(spacing: 6) {
            Text(title)
                .textRole(.eyebrow)
                .textCase(.uppercase)
                .foregroundStyle(tint)
            value
                .textRole(.title2)
                .monospacedDigit()
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    TodayHero(words: 18, minutesSpoken: 42, level: .b1, onStart: {}, onProgress: {})
        .padding(Spacing.screen)
        .background(.screenBackground)
}
