//
//  FieldFocusEffect.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

// What happens when the learner taps a field at the top of a page ("How do
// I say …?" on Learn, "Look up a word" in Articles), so the keyboard doesn't
// just pop up on its own: the field comes forward and glows in the theme
// colour, and the rest of the page darkens and sinks back a little, like a
// card behind a sheet. Tapping the page behind puts the keyboard away.
// The maintainer picked it on 17 Nov from five designs (Spotlight and Depth
// together). With Reduce Motion nothing grows or shrinks; it only fades.
//
// The field calls `.fieldFocusEffect(isActive:)` and the rest of the page
// `.fieldFocusBackdrop(isActive:onTapOutside:)`.

extension View {
    /// The field that the learner is typing in: it comes forward and glows
    /// while active.
    func fieldFocusEffect(isActive: Bool) -> some View {
        modifier(FieldFocusField(isActive: isActive))
    }

    /// Everything on the page except the field: it darkens and sinks back
    /// while the field is active, and a tap on it calls `onTapOutside` (put
    /// the keyboard away) instead of reaching what is under it. Scrolling
    /// still works.
    func fieldFocusBackdrop(isActive: Bool, onTapOutside: @escaping () -> Void) -> some View {
        modifier(FieldFocusBackdrop(isActive: isActive, onTapOutside: onTapOutside))
    }
}

private enum FieldFocus {
    static func animation(reduceMotion: Bool) -> Animation {
        reduceMotion ? .easeInOut(duration: 0.2) : Motion.easeOut(duration: 0.35)
    }
}

private struct FieldFocusField: ViewModifier {
    let isActive: Bool
    @Environment(\.reducesMotion) private var reduceMotion

    func body(content: Content) -> some View {
        content
            .scaleEffect(isActive && !reduceMotion ? 1.02 : 1)
            .shadow(color: isActive ? .accentFill.opacity(0.45) : .clear, radius: 22)
            .animation(FieldFocus.animation(reduceMotion: reduceMotion), value: isActive)
    }
}

private struct FieldFocusBackdrop: ViewModifier {
    let isActive: Bool
    let onTapOutside: () -> Void
    @Environment(\.reducesMotion) private var reduceMotion

    func body(content: Content) -> some View {
        content
            .blur(radius: isActive ? 4 : 0)
            .opacity(isActive ? 0.3 : 1)
            .scaleEffect(isActive && !reduceMotion ? 0.94 : 1, anchor: .top)
            .allowsHitTesting(!isActive)
            .overlay {
                if isActive {
                    Color.clear
                        .contentShape(.rect)
                        .onTapGesture(perform: onTapOutside)
                        .accessibilityHidden(true)
                }
            }
            .animation(FieldFocus.animation(reduceMotion: reduceMotion), value: isActive)
    }
}
