//
//  LevelRing.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftData
import SwiftUI

/// A progress ring in the theme colour: a faint track and the part done.
struct LevelRing: View {
    /// Done, from 0 to 1.
    let fraction: Double
    var lineWidth: CGFloat = 4

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.accentFill.opacity(0.22), lineWidth: lineWidth)
            Circle()
                .trim(from: 0, to: max(0, min(fraction, 1)))
                .stroke(Color.accentFill, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
        }
        .padding(lineWidth / 2)
        .accessibilityHidden(true)
    }
}

/// The ring in Learn's toolbar: how close the learner is to the next level.
/// Tapping it opens the level map, which zooms out of it.
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
                LevelRing(fraction: map.fraction, lineWidth: 3.5)
                Text(verbatim: map.level.title)
                    .font(.caption2.weight(.heavy))
                    .fontDesign(.rounded)
            }
            .frame(width: 32, height: 32)
        }
        .accessibilityLabel(Text("Your level map"))
        .accessibilityValue(Text("\(map.level.title), \(map.percent) percent"))
        .sensoryFeedback(.impact(weight: .medium), trigger: taps)
    }
}

extension EnvironmentValues {
    /// The namespace Learn's ring and the level map share, so the map can zoom out of the ring.
    @Entry var levelMapZoom: Namespace.ID?
}
