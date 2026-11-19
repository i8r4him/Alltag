//
//  OrbPress.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// A tap squashes the orb a little, like jelly, on Today and in a conversation.
struct OrbPressStyle: ButtonStyle {
    let reduceMotion: Bool

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .orbSquash(isPressed: configuration.isPressed, reduceMotion: reduceMotion)
            .contentShape(.circle)
    }
}

extension ButtonStyle where Self == OrbPressStyle {
    static func orbPress(reduceMotion: Bool) -> OrbPressStyle { OrbPressStyle(reduceMotion: reduceMotion) }
}

extension View {
    /// Pressed, the orb gets wider and flatter; let go, it springs back with a wobble.
    func orbSquash(isPressed: Bool, reduceMotion: Bool) -> some View {
        scaleEffect(x: isPressed ? 1.06 : 1, y: isPressed ? 0.9 : 1, anchor: .bottom)
            .animation(reduceMotion ? .easeOut(duration: 0.15) : .spring(duration: 0.4, bounce: 0.55), value: isPressed)
    }
}
