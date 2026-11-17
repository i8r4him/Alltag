//
//  PlacePin.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// The round sign of a place, in its sheet: its symbol on the theme's light,
/// with the place's ring around it. Dim while the place is "soon" or locked.
struct PlaceDisc: View {
    let place: TownPlace
    let level: Level
    /// `nil` draws no ring (the station, or a place that is "soon").
    let fraction: Double?
    var isDim = false
    var size: CGFloat = 74

    var body: some View {
        ZStack {
            Circle()
                .fill(isDim ? AnyShapeStyle(Color.primary.opacity(0.14)) : AnyShapeStyle(light))
                .padding(size * 0.14)
                .shadow(color: .accentFill.opacity(isDim ? 0 : 0.5), radius: size * 0.14)
            Image(systemName: place.systemImage(at: level))
                .symbolVariant(.fill)
                .font(.system(size: size * 0.3, weight: .semibold))
                .foregroundStyle(.white.opacity(isDim ? 0.55 : 1))
            if let fraction {
                LevelRing(fraction: fraction, lineWidth: size * 0.085)
            }
        }
        .frame(width: size, height: size)
    }

    private var light: LinearGradient {
        LinearGradient(colors: [.accentFill, AppTheme.shared.palette.deep],
                       startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}

/// A place on the map: its neon sign, and what it holds under it.
/// The sign switches on, with a flicker, the first time its town is on
/// screen; a place that is "soon", and the locked station, stay dark.
struct PlacePin: View {
    let place: TownPlace
    let level: Level
    /// `nil` for the station.
    let progress: PlaceProgress?
    let isHere: Bool
    let nextLevel: Level?
    /// Whether this town is the one on screen.
    let isShown: Bool
    /// When this sign switches on after its town arrives, 0 first.
    let order: Int
    @State private var isSwitchedOn = false
    @Environment(\.reducesMotion) private var reducesMotion

    var body: some View {
        VStack(spacing: 6) {
            NeonSign(name: place.germanName(at: level), systemImage: place.systemImage(at: level),
                     bulbs: bulbs, isLit: isOpen && isSwitchedOn, tilt: place.tilt)
                .overlay(alignment: .top) {
                    if isHere {
                        HereTag().offset(y: -30)
                    }
                }
            caption
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .fixedSize()
        }
        .fontDesign(.rounded)
        .contentShape(.rect)
        .onChange(of: isShown, initial: true) { _, shown in
            if shown && !isSwitchedOn { switchOn() }
        }
    }

    private var isOpen: Bool {
        progress?.isOpen ?? false
    }

    private var bulbs: NeonSign.Bulbs? {
        guard let progress, progress.isOpen, progress.totalCount > 0 else { return nil }
        return NeonSign.Bulbs(done: progress.doneCount, total: progress.totalCount)
    }

    /// On, off for a moment, on again: the way a neon tube starts.
    private func switchOn() {
        guard !reducesMotion else {
            isSwitchedOn = true
            return
        }
        Task {
            try? await Task.sleep(for: .milliseconds(250 + order * 110))
            isSwitchedOn = true
            try? await Task.sleep(for: .milliseconds(90))
            isSwitchedOn = false
            try? await Task.sleep(for: .milliseconds(70))
            isSwitchedOn = true
        }
    }

    @ViewBuilder
    private var caption: some View {
        if let progress {
            if progress.isOpen {
                Text("\(Text(place.subject)) · \(progress.doneCount) of \(progress.totalCount)")
            } else {
                Text("\(Text(place.subject)) · soon")
            }
        } else if let nextLevel {
            Text("\(nextLevel.title) test · locked")
        } else {
            Text("You're at the top")
        }
    }
}

/// "You are here", above the next place.
private struct HereTag: View {
    var body: some View {
        Text("You are here")
            .font(.caption.weight(.heavy))
            .foregroundStyle(Color.screenBackground)
            .padding(.horizontal, 9)
            .padding(.vertical, 4)
            .background(.primary, in: .capsule)
            .fixedSize()
    }
}
