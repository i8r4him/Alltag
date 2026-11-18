//
//  OrbZoom.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// A tap on Today's orb opens the conversation by zooming out of it, and the
/// conversation's orb falls into its place at the bottom (#424, the maintainer's pick).
enum OrbZoom {
    /// Today's orb, as the source of the zoom.
    static let sourceID = "today-orb"

    /// How far above its place the conversation's orb starts, and how big.
    static let dropHeight: CGFloat = 120
    static let dropScale: CGFloat = 1.2

    /// The fall: it leaves at once with the zoom, picks up speed and lands with a small bounce.
    static let drop = Animation.spring(duration: 0.55, bounce: 0.28)
}

extension EnvironmentValues {
    /// Shared by Today's orb and the conversation that zooms out of it.
    @Entry var orbZoom: Namespace.ID?
    /// The conversation's orb falls into its place when it appears.
    @Entry var orbDropsIn = false
}

extension View {
    /// After the tap on Today's orb, the orb falls into its place from above.
    func orbDropsIn(_ isActive: Bool) -> some View {
        modifier(OrbDrop(isActive: isActive))
    }
}

private struct OrbDrop: ViewModifier {
    let isActive: Bool
    @State private var hasDropped = false

    func body(content: Content) -> some View {
        content
            .offset(y: isActive && !hasDropped ? -OrbZoom.dropHeight : 0)
            .scaleEffect(isActive && !hasDropped ? OrbZoom.dropScale : 1)
            .onAppear {
                guard isActive else { return }
                // No delay: the orb moves the moment the page starts to zoom.
                withAnimation(OrbZoom.drop) { hasDropped = true }
            }
    }
}
