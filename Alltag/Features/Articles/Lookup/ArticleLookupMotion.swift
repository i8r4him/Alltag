//
//  ArticleLookupMotion.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// How "Look up a word" moves: one soft spring for every change of what is
/// shown, so the field, the cards and the clues below move together; the
/// cards come in out of a light blur, one after the other. With Reduce
/// Motion, plain fades.
enum ArticleLookupMotion {
    /// What is shown changes: searching, the answer, nothing found, cleared.
    static func change(reduceMotion: Bool) -> Animation {
        reduceMotion ? .easeInOut(duration: 0.2) : .smooth(duration: 0.4)
    }

    /// A card arriving: out of a light blur, the n-th a moment after the one before.
    /// It leaves with a plain fade, so clearing collapses in one movement.
    static func card(index: Int = 0, reduceMotion: Bool) -> AnyTransition {
        guard !reduceMotion else { return .opacity }
        let insertion = AnyTransition(.blurReplace)
            .combined(with: .offset(y: 12))
            .animation(.smooth(duration: 0.45).delay(Double(index) * stagger))
        return .asymmetric(insertion: insertion, removal: .opacity)
    }

    /// Between one card and the next.
    static let stagger: TimeInterval = 0.07
}

extension View {
    /// A tap here lowers the keyboard. Simultaneous, so buttons inside still work.
    func lowersKeyboard(_ isFocused: FocusState<Bool>.Binding) -> some View {
        contentShape(.rect)
            .simultaneousGesture(TapGesture().onEnded { isFocused.wrappedValue = false })
    }
}
