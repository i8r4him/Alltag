//
//  TalkOrb.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// The companion at the bottom of a conversation. Hands-free, a tap starts and
/// stops listening; holding to talk, the learner holds it while they speak.
/// Either way it gives under the finger and springs back, and it shows who is
/// talking (see `OrbReaction`).
struct TalkOrb: View {
    let model: ConversationModel
    var size: CGFloat = 150

    /// The press lives here, so squashing the orb doesn't redraw the conversation.
    @State private var isHeld = false
    @State private var presses = 0
    @Environment(\.reducesMotion) private var reduceMotion
    /// The page zoomed out of Today's orb: this one lands in its place.
    @Environment(\.orbLands) private var lands

    var body: some View {
        Group {
            if model.holdsToTalk {
                orb(pressed: isHeld)
                    .contentShape(.circle)
                    .gesture(hold)
                    .accessibilityElement()
                    .accessibilityAddTraits(.isButton)
                    .accessibilityLabel(Text("Hold to talk"))
                    .accessibilityHint(Text(holdHint))
                    .accessibilityAction { model.phase == .listening ? model.orbReleased() : model.orbPressed() }
            } else {
                Button {
                    presses += 1
                    model.orbTapped()
                } label: {
                    orb(pressed: false)
                }
                .buttonStyle(.orbPress(reduceMotion: reduceMotion))
                .accessibilityLabel(Text(model.isUsingCloudVoice ? "End conversation" : model.stateLabel ?? "Voice"))
            }
        }
        .sensoryFeedback(.impact(weight: .medium), trigger: presses)
        // Not `.disabled`: that would dim the orb while thinking and speaking.
        .allowsHitTesting(model.isUsingCloudVoice || model.canRespond || model.phase == .listening)
    }

    private var holdHint: LocalizedStringResource {
        model.phase == .listening ? "Sends what you said." : "Starts listening."
    }

    private func orb(pressed: Bool) -> some View {
        CompanionOrb(dynamics: OrbDynamics(state: model.phase), isLive: !model.isFinished)
            .frame(width: size, height: size)
            .orbSquash(isPressed: pressed, reduceMotion: reduceMotion)
            .orbLands(lands, reduceMotion: reduceMotion)
    }

    /// Down: the learner starts talking. Up: they're done.
    private var hold: some Gesture {
        DragGesture(minimumDistance: 0)
            .onChanged { _ in
                guard !isHeld else { return }
                isHeld = true
                presses += 1
                model.orbPressed()
            }
            .onEnded { _ in
                isHeld = false
                model.orbReleased()
            }
    }
}
