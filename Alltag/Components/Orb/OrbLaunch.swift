//
//  OrbLaunch.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// How Today's orb carries the learner into the conversation (#424).
///
/// Three versions for the maintainer to pick from, behind the "‹ n / 3 ›" switcher
/// on Today. The switcher and the versions not picked are removed before merging.
enum OrbLaunchStyle: Int, CaseIterable, Identifiable {
    /// It squashes, hops up, falls to its place at the bottom and lands with a squash.
    case hop
    /// It glides down to its place in a soft arc.
    case glide
    /// The page zooms out of it, and the orb drops into its place with a bounce.
    case zoom

    var id: Self { self }

    /// Shown on the temporary switcher only, so not localised.
    var title: String {
        switch self {
        case .hop: "Hop"
        case .glide: "Glide"
        case .zoom: "Zoom"
        }
    }

    static let storageKey = "debug.orbLaunchStyle"
}

/// Where Today's orb was when it was tapped, so the conversation's orb can come from there.
struct OrbLaunch: Equatable {
    /// In global coordinates.
    let frame: CGRect
    let style: OrbLaunchStyle

    /// Today's orb, which the conversation zooms out of.
    static let zoomID = "today-orb"
}

extension EnvironmentValues {
    /// The conversation's orb waits, hidden, while Today's orb flies to it.
    @Entry var orbIsLanding = false
    /// The conversation's orb drops into its place when it appears.
    @Entry var orbDropsIn = false
    /// Shared by Today's orb and the conversation that zooms out of it.
    @Entry var orbZoom: Namespace.ID?
}

/// Where the conversation's orb sits, for the flight to end there.
struct OrbSlotKey: PreferenceKey {
    static let defaultValue: Anchor<CGRect>? = nil

    static func reduce(value: inout Anchor<CGRect>?, nextValue: () -> Anchor<CGRect>?) {
        value = value ?? nextValue()
    }
}

/// One moment of the flight. Pure, so it can be tested.
struct OrbFlightPose: Equatable {
    /// 0 at Today's orb … 1 in its place in the conversation.
    var progress: Double = 0
    /// Up (negative) or down from the straight path, in points.
    var lift: Double = 0
    var stretchX: Double = 1
    var stretchY: Double = 1

    /// How long the flight takes before the real orb shows.
    static func duration(of style: OrbLaunchStyle) -> Double {
        style == .hop ? 1 : 0.72
    }

    /// The pose `time` seconds after the tap.
    init(at time: Double, style: OrbLaunchStyle) {
        let time = min(max(time, 0), Self.duration(of: style))
        switch style {
        case .hop: self = Self.hop(at: time)
        case .glide, .zoom:
            progress = Self.easeInOut(time / Self.duration(of: style))
            lift = -28 * sin(.pi * progress)
        }
    }

    init() {}

    /// Squash, hop up, fall into place, land with a squash and wobble back.
    private static func hop(at time: Double) -> OrbFlightPose {
        var pose = OrbFlightPose()
        pose.progress = time < 0.26 ? 0 : easeIn(min((time - 0.26) / 0.5, 1))
        switch time {
        case ..<0.1: pose.lift = 0
        case ..<0.28: pose.lift = -56 * easeOut((time - 0.1) / 0.18)
        case ..<0.76: pose.lift = -56 * (1 - easeIn((time - 0.28) / 0.48))
        default: pose.lift = 0
        }
        switch time {
        case ..<0.1: pose.stretchY = 1 - 0.16 * time / 0.1
        case ..<0.26: pose.stretchY = 0.84 + 0.26 * (time - 0.1) / 0.16
        case ..<0.76: pose.stretchY = 1.1 - 0.1 * (time - 0.26) / 0.5
        case ..<0.84: pose.stretchY = 1 - 0.2 * (time - 0.76) / 0.08
        default:
            // A damped wobble back to round.
            let since = (time - 0.84) / 0.16
            pose.stretchY = 1 - 0.2 * cos(since * .pi * 2.5) * exp(-since * 4)
        }
        // Wider when flatter, so it keeps its volume.
        pose.stretchX = 1 + (1 - pose.stretchY) * 0.7
        return pose
    }

    private static func easeIn(_ value: Double) -> Double { value * value }
    private static func easeOut(_ value: Double) -> Double { 1 - (1 - value) * (1 - value) }
    private static func easeInOut(_ value: Double) -> Double { value * value * (3 - 2 * value) }
}

/// Today's orb on its way to its place in the conversation, drawn above the page.
struct OrbFlight: View {
    let launch: OrbLaunch
    let target: Anchor<CGRect>?
    let onLanded: () -> Void

    @State private var start = Date.now

    var body: some View {
        GeometryReader { proxy in
            if let target {
                let origin = proxy.frame(in: .global).origin
                let from = launch.frame.offsetBy(dx: -origin.x, dy: -origin.y)
                let to = proxy[target]
                TimelineView(.animation) { context in
                    let pose = OrbFlightPose(at: context.date.timeIntervalSince(start), style: launch.style)
                    let side = from.width + (to.width - from.width) * pose.progress
                    CompanionOrb(isLive: true)
                        .frame(width: side, height: side)
                        .scaleEffect(x: pose.stretchX, y: pose.stretchY, anchor: .bottom)
                        .position(x: from.midX + (to.midX - from.midX) * pose.progress,
                                  y: from.midY + (to.midY - from.midY) * pose.progress + pose.lift)
                }
            }
        }
        .ignoresSafeArea()
        .allowsHitTesting(false)
        .accessibilityHidden(true)
        .task {
            start = .now
            try? await Task.sleep(for: .seconds(OrbFlightPose.duration(of: launch.style)))
            onLanded()
        }
    }
}

extension View {
    /// After the zoom, the orb falls into its place from above and bounces.
    func orbDropsIn(_ isActive: Bool) -> some View {
        modifier(OrbDrop(isActive: isActive))
    }
}

private struct OrbDrop: ViewModifier {
    let isActive: Bool
    @State private var hasDropped = false

    func body(content: Content) -> some View {
        content
            .offset(y: isActive && !hasDropped ? -160 : 0)
            .scaleEffect(isActive && !hasDropped ? 1.3 : 1)
            .onAppear {
                guard isActive else { return }
                withAnimation(.spring(duration: 0.6, bounce: 0.45).delay(0.25)) { hasDropped = true }
            }
    }
}
