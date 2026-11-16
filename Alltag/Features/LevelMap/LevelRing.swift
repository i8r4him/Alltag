//
//  LevelRing.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftData
import SwiftUI

/// A progress ring like the Apple Watch's activity rings, in the theme colour:
/// a thick round line that brightens from the theme's deep tone to its light
/// as it goes round, over a dim track of the same colour. At zero a dot marks the start.
struct LevelRing: View {
    /// Done, from 0 to 1.
    let fraction: Double
    var lineWidth: CGFloat = 4

    var body: some View {
        let done = max(0, min(fraction, 1))
        ZStack {
            Circle()
                .stroke(Color.accentFill.opacity(0.22), lineWidth: lineWidth)
            if done > 0 {
                Circle()
                    .trim(from: 0, to: done)
                    .stroke(gradient(to: done), style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                    .rotationEffect(.degrees(-90))
            } else {
                Circle()
                    .fill(AppTheme.shared.palette.deep)
                    .frame(width: lineWidth, height: lineWidth)
                    .frame(maxHeight: .infinity, alignment: .top)
                    .offset(y: -lineWidth / 2)
            }
        }
        .padding(lineWidth / 2)
        .accessibilityHidden(true)
    }

    /// From the deep tone at the start to the full light at the end of the line.
    private func gradient(to done: Double) -> AngularGradient {
        AngularGradient(colors: [AppTheme.shared.palette.deep, .accentFill],
                        center: .center, startAngle: .zero, endAngle: .degrees(360 * done))
    }
}

/// The ring in Learn's toolbar, on its own like an Apple Watch ring (no glass
/// behind it), with the percentage inside: how close the learner is to the next level. Tapping it opens
/// the level map, which zooms out of it.
///
/// It reads its own data, so a new solved rule redraws the ring, not Learn.
struct LevelRingButton: View {
    static let zoomID = "levelMap"

    @Environment(AppState.self) private var appState
    @Query private var solved: [SolvedRule]
    @Query private var sessions: [SessionRecord]
    @Query private var profiles: [UserProfile]
    @State private var taps = 0

    var body: some View {
        let map = LevelMap(level: profiles.first?.level ?? .a1, solved: solved, sessions: sessions)
        Button {
            taps += 1
            appState.open(.levelMap)
        } label: {
            ZStack {
                LevelRing(fraction: map.fraction, lineWidth: 5)
                Text("\(map.percent)%")
                    .font(.system(size: 10, weight: .heavy, design: .rounded))
                    .monospacedDigit()
                    .lineLimit(1)
                    .minimumScaleFactor(0.6)
                    .padding(6)
            }
            .frame(width: 36, height: 36)
                .frame(width: Spacing.minTouchTarget, height: Spacing.minTouchTarget)
                .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text("Your level map"))
        .accessibilityValue(Text("\(map.level.title), \(map.percent) percent"))
        .sensoryFeedback(.impact(weight: .medium), trigger: taps)
    }
}

extension EnvironmentValues {
    /// The namespace Learn's ring and the level map share, so the map can zoom out of the ring.
    @Entry var levelMapZoom: Namespace.ID?
}
