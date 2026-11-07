//
//  EqualizerBars.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Twenty bars that bounce while audio plays, for listening activities and the briefing.
struct EqualizerBars: View {
    let isPlaying: Bool
    var height: CGFloat = 36

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    /// Resting heights from the prototype, as fractions of the full height.
    private static let levels: [CGFloat] = [0.4, 0.7, 0.5, 0.9, 0.6, 1, 0.7, 0.45, 0.8, 0.55,
                                            0.95, 0.6, 0.4, 0.75, 0.5, 0.85, 0.6, 0.4, 0.7, 0.5]

    var body: some View {
        TimelineView(.animation(paused: !isPlaying || reduceMotion)) { context in
            let time = context.date.timeIntervalSinceReferenceDate
            HStack(alignment: .center, spacing: 3) {
                ForEach(Self.levels.indices, id: \.self) { index in
                    Capsule()
                        .fill(isPlaying ? AnyShapeStyle(.accentFill) : AnyShapeStyle(.tertiary))
                        .frame(height: height * barScale(index: index, time: time))
                }
            }
            .frame(height: height)
        }
        .accessibilityHidden(true)
    }

    /// Each bar bounces at its own speed while playing, like the prototype's `eq` animation.
    private func barScale(index: Int, time: TimeInterval) -> CGFloat {
        let level = Self.levels[index]
        guard isPlaying, !reduceMotion else { return level }
        let period = 0.6 + Double(index % 4) * 0.15
        let phase = (time + Double(index) * 0.04).truncatingRemainder(dividingBy: period) / period
        let bounce = 0.35 + 0.65 * (0.5 - 0.5 * cos(2 * .pi * phase))
        return level * bounce
    }
}

#Preview {
    VStack(spacing: 24) {
        EqualizerBars(isPlaying: true)
        EqualizerBars(isPlaying: false)
    }
    .padding()
    .background(.screenBackground)
}
