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
    @Environment(\.reducesMotion) private var reduceMotion
    /// The conversation zooms out of the orb.
    @Environment(\.orbZoom) private var orbZoom
    @Namespace private var ownZoom

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
                .buttonStyle(.orbPress(reduceMotion: reduceMotion))
                .matchedTransitionSource(id: OrbZoom.sourceID, in: orbZoom ?? ownZoom)
                .sensoryFeedback(.impact(weight: .medium), trigger: starts)
                .accessibilityLabel("Talk with your companion")

            Button {
                progressTaps += 1
                onProgress()
            } label: {
                HStack(alignment: .top) {
                    stat(Text(words, format: BigNumber.style(for: words)), label: "WORDS",
                         symbol: "character.book.closed.fill")
                    stat(Text(minutesSpoken, format: BigNumber.style(for: minutesSpoken)), label: "MINUTES",
                         symbol: "waveform")
                    stat(Text(verbatim: level.title), label: "LEVEL",
                         symbol: "chart.bar.fill")
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

    /// A big number with its word and symbol underneath, in the theme colour.
    private func stat(_ value: Text, label: LocalizedStringResource, symbol: String) -> some View {
        VStack(spacing: 4) {
            value
                .font(.system(size: 40, weight: .bold, design: .rounded))
                .monospacedDigit()
                .lineLimit(1)
                .minimumScaleFactor(0.6)
            Label { Text(label) } icon: { Image(systemName: symbol) }
                .font(.headline)
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.accent)
        }
        .frame(maxWidth: .infinity)
    }
}

/// How the big numbers on Today and the profile are written: in full below
/// 1,000, then short where the language has it ("1.2k" in English; German
/// writes thousands in full), so three still fit side by side.
enum BigNumber {
    static func style(for value: Int, locale: Locale = .autoupdatingCurrent) -> IntegerFormatStyle<Int> {
        let style = IntegerFormatStyle<Int>(locale: locale)
        return abs(value) < 1_000 ? style : style.notation(.compactName)
    }
}

#Preview("Large numbers") {
    TodayHero(words: 12_480, minutesSpoken: 1_250, level: .c1, onStart: {}, onProgress: {})
        .padding(Spacing.screen)
        .background(.screenBackground)
}

#Preview {
    TodayHero(words: 18, minutesSpoken: 42, level: .b1, onStart: {}, onProgress: {})
        .padding(Spacing.screen)
        .background(.screenBackground)
}
