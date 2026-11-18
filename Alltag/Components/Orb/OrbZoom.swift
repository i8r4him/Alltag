//
//  OrbZoom.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// A tap on Today's orb opens the conversation by zooming out of it (#424, the maintainer's pick).
/// As the page grows, the conversation's orb rides it from where Today's orb was down to
/// its place at the bottom, and lands there with a small squash.
enum OrbZoom {
    /// Today's orb, as the source of the zoom.
    static let sourceID = "today-orb"

    /// When the zoom has carried the orb to its place, so it lands.
    static let landing: Duration = .milliseconds(380)
    /// How long it stays squashed before it springs back.
    static let squash: Duration = .milliseconds(110)
}

extension EnvironmentValues {
    /// Shared by Today's orb and the conversation that zooms out of it.
    @Entry var orbZoom: Namespace.ID?
    /// The conversation zoomed out of Today's orb, so its orb lands when it appears.
    @Entry var orbLands = false
}

extension View {
    /// After the zoom, the orb lands in its place with a squash and springs back.
    func orbLands(_ isActive: Bool, reduceMotion: Bool) -> some View {
        modifier(OrbLanding(isActive: isActive && !reduceMotion, reduceMotion: reduceMotion))
    }
}

private struct OrbLanding: ViewModifier {
    let isActive: Bool
    let reduceMotion: Bool
    @State private var isSquashed = false

    func body(content: Content) -> some View {
        content
            .orbSquash(isPressed: isSquashed, reduceMotion: reduceMotion)
            .task {
                guard isActive else { return }
                try? await Task.sleep(for: OrbZoom.landing)
                isSquashed = true
                try? await Task.sleep(for: OrbZoom.squash)
                isSquashed = false
            }
    }
}
