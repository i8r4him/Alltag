//
//  OrbLaunch.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// A tap on Today's orb carries the learner into the conversation (#424, the maintainer's
/// description): the orb itself grows, moves down to its place at the bottom and lands,
/// while Today fades away and the conversation fades in around it.
struct OrbLaunch: Equatable {
    /// Where Today's orb was, in global coordinates.
    let frame: CGRect
}

extension EnvironmentValues {
    /// The conversation's orb waits, hidden, while Today's orb moves to it.
    @Entry var orbIsLanding = false
}

/// Where the conversation's orb sits, for the flight to end there.
nonisolated struct OrbSlotKey: PreferenceKey {
    static var defaultValue: Anchor<CGRect>? { nil }

    static func reduce(value: inout Anchor<CGRect>?, nextValue: () -> Anchor<CGRect>?) {
        value = value ?? nextValue()
    }
}

/// One moment of the flight. Pure, so it can be tested.
struct OrbFlightPose: Equatable {
    /// 0 at Today's orb … 1 in its place in the conversation.
    var progress: Double = 0
    /// How much bigger than its size on the way the orb is drawn.
    var growth: Double = 1
    var stretchX: Double = 1
    var stretchY: Double = 1

    /// How long the flight takes before the real orb shows.
    static let duration = 0.9
    /// How much the orb grows as it sets off.
    static let peakGrowth = 0.22

    init() {}

    /// The pose `time` seconds after the tap: it grows at once, moves down while it
    /// shrinks back to its size there, then lands with a squash and settles.
    init(at time: Double) {
        let time = min(max(time, 0), Self.duration)
        let grown = Self.easeOut(min(time / 0.2, 1))
        progress = Self.easeInOut(min(max((time - 0.08) / 0.62, 0), 1))
        growth = 1 + Self.peakGrowth * grown * (1 - progress)
        if time > 0.7 {
            let landed = (time - 0.7) / 0.2
            stretchY = 1 - 0.2 * sin(.pi * landed) * (1 - landed)
            // Wider when flatter, so it keeps its volume.
            stretchX = 1 + (1 - stretchY) * 0.7
        }
    }

    private static func easeOut(_ value: Double) -> Double { 1 - (1 - value) * (1 - value) }
    private static func easeInOut(_ value: Double) -> Double { value * value * (3 - 2 * value) }
}

/// Today's orb on its way to its place in the conversation, drawn above the page.
struct OrbFlight: View {
    let launch: OrbLaunch
    let target: Anchor<CGRect>?
    let onLanded: () -> Void

    /// When the flight set off: once the conversation's orb has a place to go to.
    /// Until then the orb waits where Today's orb was, so it never blinks out.
    @State private var start: Date?

    var body: some View {
        GeometryReader { proxy in
            let origin = proxy.frame(in: .global).origin
            let source = launch.frame.offsetBy(dx: -origin.x, dy: -origin.y)
            let place = target.map { proxy[$0] } ?? source
            TimelineView(.animation(paused: start == nil)) { context in
                let pose = OrbFlightPose(at: start.map { context.date.timeIntervalSince($0) } ?? 0)
                let side = source.width + (place.width - source.width) * pose.progress
                CompanionOrb(isLive: true)
                    .frame(width: side, height: side)
                    .scaleEffect(pose.growth)
                    .scaleEffect(x: pose.stretchX, y: pose.stretchY, anchor: .bottom)
                    .position(x: source.midX + (place.midX - source.midX) * pose.progress,
                              y: source.midY + (place.midY - source.midY) * pose.progress)
            }
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
        .accessibilityHidden(true)
        .onChange(of: target != nil, initial: true) { _, hasPlace in
            if hasPlace, start == nil { start = .now }
        }
        .task(id: start) {
            // With nowhere to go (the page shows a problem instead of its orb), it doesn't wait forever.
            try? await Task.sleep(for: .seconds(start == nil ? 1 : OrbFlightPose.duration))
            if !Task.isCancelled { onLanded() }
        }
    }
}
