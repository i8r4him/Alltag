//
//  TodayHero.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 08.11.26.
//

import SwiftUI

/// The top of Today: the companion that starts today's conversation, and
/// the numbers that open Progress.
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
                    stat(Text(words, format: .number), label: "words",
                         symbol: "character.book.closed.fill", tint: .accent)
                    stat(Text(minutesSpoken, format: .number), label: "minutes",
                         symbol: "waveform", tint: .success)
                    stat(Text(verbatim: level.title), label: "level",
                         symbol: "chart.bar.fill", tint: Self.levelTint)
                }
                .contentShape(.rect)
            }
            .buttonStyle(.tile)
            .accessibilityElement(children: .combine)
            .accessibilityHint("Opens your progress.")
            .sensoryFeedback(.impact(weight: .light), trigger: progressTaps)
        }
        .frame(maxWidth: .infinity)
        .fontDesign(.rounded)
    }

    /// A soft blue for the level, next to the theme colour and green.
    private static let levelTint = Color(hex: 0x8E9BFF)

    /// A big number with its coloured word and symbol underneath.
    private func stat(_ value: Text, label: LocalizedStringResource, symbol: String, tint: Color) -> some View {
        VStack(spacing: 4) {
            value
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .monospacedDigit()
            Label { Text(label) } icon: { Image(systemName: symbol) }
                .font(.headline)
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(tint)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    TodayHero(words: 18, minutesSpoken: 42, level: .b1, onStart: {}, onProgress: {})
        .padding(Spacing.screen)
        .background(.screenBackground)
}
