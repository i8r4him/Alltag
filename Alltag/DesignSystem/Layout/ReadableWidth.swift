//
//  ReadableWidth.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Keeps content at a comfortable width on an unfolded foldable iPhone.
/// On iPhone (narrower than the limit) nothing changes.
enum ReadableWidth {
    /// The extra side margin that centres content of at most `limit` in `width`.
    static func sideMargin(for width: CGFloat, limit: CGFloat = Spacing.readableWidth) -> CGFloat {
        max(0, (width - limit) / 2).rounded(.down)
    }
}

private struct ReadableContentMargins: ViewModifier {
    let limit: CGFloat
    @State private var width: CGFloat = 0

    func body(content: Content) -> some View {
        content
            .contentMargins(.horizontal, ReadableWidth.sideMargin(for: width, limit: limit), for: .scrollContent)
            .onGeometryChange(for: CGFloat.self) { $0.size.width } action: { width = $0 }
    }
}

extension View {
    /// For a `ScrollView`: centres the scrolling content at a readable width
    /// while the scroll indicator stays at the screen edge.
    ///
    /// Not for inset-grouped lists: content margins replace their own inset,
    /// and the system already keeps them readable at regular width.
    /// Nested scroll views inherit the margins; reset them with
    /// `.contentMargins(.horizontal, 0, for: .scrollContent)`.
    func readableContentMargins(_ limit: CGFloat = Spacing.readableWidth) -> some View {
        modifier(ReadableContentMargins(limit: limit))
    }

    /// For content that doesn't scroll: at most `limit` wide, centred.
    func readableWidth(_ limit: CGFloat = Spacing.readableWidth) -> some View {
        frame(maxWidth: limit).frame(maxWidth: .infinity)
    }
}
