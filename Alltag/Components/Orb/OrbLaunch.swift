//
//  OrbLaunch.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// A tap on Today's orb carries the learner into the conversation (#424, the maintainer's
/// description and picks, 18–19 Nov): the orb crouches, grows and flies down in an arc to
/// its place, lands with a squash, a glow, a little bounce and a tap on the hand, while
/// Today sinks back and the conversation fades in around it; the rest of the page rises
/// once it has landed. When the talk ends, the orb flies back to Today.
struct OrbLaunch: Equatable {
    /// Where Today's orb was, in global coordinates.
    let frame: CGRect
}

extension EnvironmentValues {
    /// The conversation's orb waits, hidden, while Today's orb moves to it or back.
    @Entry var orbIsLanding = false
    /// The rest of the conversation waits for the orb to land, and leaves before it flies back.
    @Entry var orbHoldsPage = false
}

/// Where the conversation's orb sits, for the flight to end there.
nonisolated struct OrbSlotKey: PreferenceKey {
    static var defaultValue: Anchor<CGRect>? { nil }

    static func reduce(value: inout Anchor<CGRect>?, nextValue: () -> Anchor<CGRect>?) {
        value = value ?? nextValue()
    }
}

/// One moment of the flight there or back. Pure, so it can be tested.
struct OrbFlightPose: Equatable {
    /// 0 at Today's orb … 1 in its place in the conversation.
    var progress: Double = 0
    /// Up (negative) from where the path puts it, in points: the bounce.
    var lift: Double = 0
    /// How much bigger than its size on the way the orb is drawn.
    var growth: Double = 1
    var stretchX: Double = 1
    var stretchY: Double = 1
    /// The light it gives off as it lands.
    var glow: Double = 0

    /// The orb reaches its place this long after the tap.
    static let touchdown = 0.74
    /// How long the flight takes, bounce included, before the real orb shows.
    static let duration = 1.05
    /// How long the flight back to Today takes.
    static let returnDuration = 0.7
    /// How much the orb grows as it sets off.
    static let peakGrowth = 0.22
    /// The path bends towards this point, given from Today's orb: up and to the right, so the
    /// orb rises a little before it falls, like something thrown, and comes back the same way.
    static let bend = CGSize(width: 50, height: -120)

    /// Where the orb is at `progress` on its path from `source` to `place` (both centres):
    /// a curve through `bend`, not a straight line.
    static func point(at progress: Double, from source: CGPoint, to place: CGPoint) -> CGPoint {
        let control = CGPoint(x: source.x + bend.width, y: source.y + bend.height)
        let rest = 1 - progress
        return CGPoint(x: rest * rest * source.x + 2 * rest * progress * control.x + progress * progress * place.x,
                       y: rest * rest * source.y + 2 * rest * progress * control.y + progress * progress * place.y)
    }

    init() {}

    /// The pose `time` seconds after the tap. It starts squashed under the finger, crouches
    /// a little more, springs up growing and flies along its curve, shrinking back to its
    /// size there; it lands with a squash and a glow, then bounces once.
    init(at time: Double) {
        let time = min(max(time, 0), Self.duration)
        progress = Self.easeInOut(Self.fraction(time, from: 0.12, to: Self.touchdown))
        let grown = Self.easeOut(Self.fraction(time, from: 0.08, to: 0.24))
        growth = 1 + Self.peakGrowth * grown * (1 - progress)
        switch time {
        case ..<0.1: stretchY = 0.9 - 0.06 * Self.easeOut(time / 0.1)
        case ..<0.2: stretchY = 0.84 + 0.24 * Self.easeOut((time - 0.1) / 0.1)
        case ..<Self.touchdown: stretchY = 1.08 - 0.08 * (time - 0.2) / (Self.touchdown - 0.2)
        case ..<0.86: stretchY = 1 - 0.2 * sin(.pi * (time - Self.touchdown) / 0.12)
        default:
            let bounce = (time - 0.86) / (Self.duration - 0.86)
            stretchY = 1 + 0.03 * sin(.pi * bounce)
            lift = -14 * sin(.pi * bounce)
        }
        // Wider when flatter, narrower when taller, so it keeps its volume.
        stretchX = 1 + (1 - stretchY) * 0.7
        if time > Self.touchdown {
            let since = time - Self.touchdown
            glow = 0.9 * min(since / 0.04, 1) * exp(-since * 9)
        }
    }

    /// The pose `time` seconds into the flight back along the same curve: a little bigger
    /// on the way, and a soft squash as it settles on Today.
    init(returningAt time: Double) {
        let time = min(max(time, 0), Self.returnDuration)
        let travel = Self.easeInOut(Self.fraction(time, from: 0, to: 0.55))
        progress = 1 - travel
        growth = 1 + 0.12 * sin(.pi * travel)
        if time > 0.55 {
            stretchY = 1 - 0.12 * sin(.pi * (time - 0.55) / (Self.returnDuration - 0.55))
            stretchX = 1 + (1 - stretchY) * 0.7
        }
    }

    private static func fraction(_ time: Double, from start: Double, to end: Double) -> Double {
        min(max((time - start) / (end - start), 0), 1)
    }

    private static func easeOut(_ value: Double) -> Double { 1 - (1 - value) * (1 - value) }
    private static func easeInOut(_ value: Double) -> Double { value * value * (3 - 2 * value) }
}

/// Today's orb on its way to its place in the conversation, or back, drawn above the page.
struct OrbFlight: View {
    let launch: OrbLaunch
    let target: Anchor<CGRect>?
    var isReturning = false
    var onTouchdown: () -> Void = {}
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
                let pose = pose(after: start.map { context.date.timeIntervalSince($0) } ?? 0)
                let side = source.width + (place.width - source.width) * pose.progress
                let point = OrbFlightPose.point(at: pose.progress, from: CGPoint(x: source.midX, y: source.midY),
                                                to: CGPoint(x: place.midX, y: place.midY))
                CompanionOrb(isLive: true, flash: pose.glow)
                    .frame(width: side, height: side)
                    .scaleEffect(pose.growth)
                    .scaleEffect(x: pose.stretchX, y: pose.stretchY, anchor: .bottom)
                    .position(x: point.x, y: point.y + pose.lift)
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
            guard start != nil else {
                try? await Task.sleep(for: .seconds(1))
                if !Task.isCancelled { onLanded() }
                return
            }
            if isReturning {
                try? await Task.sleep(for: .seconds(OrbFlightPose.returnDuration))
            } else {
                try? await Task.sleep(for: .seconds(OrbFlightPose.touchdown))
                if Task.isCancelled { return }
                onTouchdown()
                try? await Task.sleep(for: .seconds(OrbFlightPose.duration - OrbFlightPose.touchdown))
            }
            if !Task.isCancelled { onLanded() }
        }
    }

    private func pose(after time: Double) -> OrbFlightPose {
        isReturning ? OrbFlightPose(returningAt: time) : OrbFlightPose(at: time)
    }
}

extension View {
    /// A part of the conversation besides its orb: it rises into place once the orb has
    /// landed, and sinks away before the orb flies back to Today.
    func waitsForOrb() -> some View {
        modifier(WaitsForOrb())
    }
}

private struct WaitsForOrb: ViewModifier {
    @Environment(\.orbHoldsPage) private var isHeld

    func body(content: Content) -> some View {
        content
            .opacity(isHeld ? 0 : 1)
            .offset(y: isHeld ? 16 : 0)
            .allowsHitTesting(!isHeld)
            .animation(.spring(duration: 0.45, bounce: 0.2), value: isHeld)
    }
}
