//
//  VoiceOrb.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// The state of a conversation turn, shown by the Voice Orb.
enum VoiceOrbState: Equatable, CaseIterable {
    /// Waiting for the learner: grey sphere with a mic, breathing slowly.
    case idle
    /// Hearing the learner: amber sphere with two expanding rings.
    case listening
    /// Preparing a reply: smaller amber sphere with a spinner.
    case thinking
    /// The companion is talking: amber sphere wobbling.
    case speaking
}

/// The 132pt orb in the middle of a conversation.
///
/// Continuous motion comes from one `TimelineView`; state changes (colour,
/// size) animate over 0.5s. With Reduce Motion nothing moves continuously.
struct VoiceOrb: View {
    let state: VoiceOrbState
    /// Hides the mic once the conversation is over.
    var isFinished = false
    var size: CGFloat = 132

    @Environment(\.reducesMotion) private var reduceMotion

    private var isLive: Bool { state != .idle }

    var body: some View {
        TimelineView(.animation(paused: reduceMotion)) { context in
            let time = context.date.timeIntervalSinceReferenceDate
            ZStack {
                ring(time: time, delay: 0)
                ring(time: time, delay: 0.8)
                spinner(time: time)
                core(time: time)
            }
            .frame(width: size, height: size)
        }
        .animation(.easeInOut(duration: 0.5), value: state)
        .sensoryFeedback(.impact(weight: .light), trigger: state)
        .accessibilityElement()
        .accessibilityLabel("Voice")
        .accessibilityValue(accessibilityValue)
    }

    // MARK: Layers

    private func ring(time: TimeInterval, delay: TimeInterval) -> some View {
        let motion = OrbMotion.ring(time: time, delay: delay)
        return Circle()
            .stroke(.accentFill, lineWidth: 1.5)
            .frame(width: size - 32, height: size - 32)
            .scaleEffect(reduceMotion ? 1 : motion.scale)
            .opacity(state == .listening ? (reduceMotion ? 1 : motion.opacity) : 0)
    }

    private func spinner(time: TimeInterval) -> some View {
        Circle()
            .trim(from: 0, to: 0.25)
            .stroke(.accentFill, style: StrokeStyle(lineWidth: 2, lineCap: .round))
            .frame(width: size - 12, height: size - 12)
            .rotationEffect(.degrees(reduceMotion ? 0 : OrbMotion.spinnerAngle(time: time)))
            .opacity(state == .thinking ? 1 : 0)
    }

    private func core(time: TimeInterval) -> some View {
        let diameter = size - 36
        return ZStack {
            Circle().fill(Self.idleGradient)
            Circle().fill(Self.liveGradient).opacity(isLive ? 1 : 0)
            if state == .idle && !isFinished {
                Image(systemName: "mic.fill")
                    .font(.system(size: 30, weight: .medium))
                    .foregroundStyle(Color(red: 0.11, green: 0.11, blue: 0.12))
                    .transition(.opacity)
            }
        }
        .frame(width: diameter, height: diameter)
        .shadow(color: isLive ? Color.accentFill.opacity(0.35) : Color.white.opacity(0.08), radius: 25, y: 12)
        .scaleEffect(state == .thinking ? 0.8 : 1)
        .scaleEffect(reduceMotion ? 1 : continuousScale(time: time))
    }

    private func continuousScale(time: TimeInterval) -> CGFloat {
        switch state {
        case .idle: OrbMotion.breathe(time: time)
        case .speaking: OrbMotion.talk(time: time)
        case .listening, .thinking: 1
        }
    }

    private var accessibilityValue: Text {
        switch state {
        case .idle: Text("Ready")
        case .listening: Text("Listening")
        case .thinking: Text("Thinking")
        case .speaking: Text("Speaking")
        }
    }

    // Light from the top-left, as in the prototype.
    private static let idleGradient = RadialGradient(
        stops: [.init(color: Color(red: 0.98, green: 0.98, blue: 0.98), location: 0),
                .init(color: Color(red: 0.72, green: 0.72, blue: 0.74), location: 0.6),
                .init(color: Color(red: 0.42, green: 0.42, blue: 0.44), location: 1)],
        center: UnitPoint(x: 0.35, y: 0.3), startRadius: 0, endRadius: 70)

    private static let liveGradient = RadialGradient(
        stops: [.init(color: Color(red: 1, green: 0.973, blue: 0.918), location: 0),        // #FFF8EA
                .init(color: Color(red: 0.973, green: 0.765, blue: 0.475), location: 0.45), // #F8C379
                .init(color: Color(red: 0.71, green: 0.424, blue: 0.176), location: 1)],    // #B56C2D
        center: UnitPoint(x: 0.35, y: 0.3), startRadius: 0, endRadius: 70)
}

/// The orb's motion curves as plain functions of time, so they can be tested.
enum OrbMotion {
    /// Idle breathing: 1 → 1.04 → 1 over 4 seconds.
    static func breathe(time: TimeInterval) -> CGFloat {
        let phase = time.truncatingRemainder(dividingBy: 4) / 4
        return 1 + 0.02 * (1 - cos(2 * .pi * phase))
    }

    /// Talking: 1 → 1.07 → 0.97 → 1.05 → 1 over 1.1 seconds, eased between keyframes.
    static func talk(time: TimeInterval) -> CGFloat {
        let keyframes: [CGFloat] = [1, 1.07, 0.97, 1.05, 1]
        let phase = time.truncatingRemainder(dividingBy: 1.1) / 1.1 * 4
        let index = min(Int(phase), 3)
        let fraction = phase - Double(index)
        let eased = fraction * fraction * (3 - 2 * fraction)
        return keyframes[index] + (keyframes[index + 1] - keyframes[index]) * eased
    }

    /// A listening ring: grows to 1.45× and fades out over 1.6 seconds, eased out.
    static func ring(time: TimeInterval, delay: TimeInterval) -> (scale: CGFloat, opacity: Double) {
        var phase = (time - delay).truncatingRemainder(dividingBy: 1.6) / 1.6
        if phase < 0 { phase += 1 }
        let eased = 1 - pow(1 - phase, 3)
        return (1 + 0.45 * eased, 0.7 * (1 - phase))
    }

    /// The thinking spinner: one turn per second.
    static func spinnerAngle(time: TimeInterval) -> Double {
        time.truncatingRemainder(dividingBy: 1) * 360
    }
}

#Preview {
    Grid(horizontalSpacing: 24, verticalSpacing: 24) {
        GridRow {
            VoiceOrb(state: .idle)
            VoiceOrb(state: .listening)
        }
        GridRow {
            VoiceOrb(state: .thinking)
            VoiceOrb(state: .speaking)
        }
    }
    .padding()
    .background(.screenBackground)
}
