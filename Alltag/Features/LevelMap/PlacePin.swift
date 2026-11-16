//
//  PlacePin.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// The round sign of a place: its symbol on the theme's light, with the
/// place's ring around it. Dim while the place is "soon" or locked.
struct PlaceDisc: View {
    let place: TownPlace
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
            Image(systemName: place.systemImage)
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

/// A place on the map: its sign, and a glass label with what it holds.
struct PlacePin: View {
    let place: TownPlace
    /// `nil` for the station.
    let progress: PlaceProgress?
    let isHere: Bool
    let nextLevel: Level?

    var body: some View {
        VStack(spacing: 6) {
            PlaceDisc(place: place, fraction: ring, isDim: isDim)
                .overlay(alignment: .top) {
                    if isHere {
                        HereTag().offset(y: -24)
                    }
                }
            VStack(spacing: 1) {
                Text(place.name)
                    .font(.subheadline.weight(.bold))
                caption
                    .font(.caption2.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
            .lineLimit(1)
            .fixedSize()
            .padding(.horizontal, 11)
            .padding(.vertical, 5)
            .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 14, style: .continuous))
        }
        .fontDesign(.rounded)
        .contentShape(.rect)
    }

    private var ring: Double? {
        guard let progress, progress.isOpen else { return nil }
        return progress.fraction
    }

    private var isDim: Bool {
        guard let progress else { return true }
        return !progress.isOpen
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
