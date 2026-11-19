//
//  CompanionOrb.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 08.11.26.
//

import SwiftUI

/// How the companion moves in each conversation state. Pure, so it can be tested.
struct OrbDynamics: Equatable {
    /// Who is talking, which sets how the orb and its eyes react.
    var state: VoiceOrbState = .idle
    /// How fast the silk drifts (1 = the shader's natural pace).
    var speed: Double
    /// 0 calm … 1 excited.
    var energy: Double

    /// The motion for `state`, with `level` the current voice loudness (0…1).
    init(state: VoiceOrbState, level: Double = 0) {
        let level = min(max(level, 0), 1)
        self.state = state
        switch state {
        case .idle: (speed, energy) = (0.35, 0)
        case .listening: (speed, energy) = (0.6, 0.15 + level * 0.7)
        case .thinking: (speed, energy) = (1.6, 0.45)
        case .speaking: (speed, energy) = (0.9, 0.3 + level * 0.6)
        }
    }

    init(speed: Double, energy: Double) {
        self.speed = speed
        self.energy = energy
    }
}

/// How the orb answers the voice it hears, for one frame. Pure, so it can be tested.
///
/// Listening, it swells with the learner's voice; speaking, its edge ripples
/// and glows with the companion's; thinking, it breathes quickly; waiting,
/// it breathes slowly.
struct OrbReaction: Equatable {
    /// The orb's size, 1 at rest.
    var scale: Double
    /// Added to the shader's energy: brighter silk, rim and halo.
    var glow: Double
    /// 0 round … 1 the edge ripples like a voice.
    var wobble: Double

    /// `voice` is the smoothed loudness (0…1) and `time` seconds of wall time.
    init(state: VoiceOrbState, voice: Double, time: Double) {
        let voice = min(max(voice, 0), 1)
        switch state {
        case .idle: (scale, glow, wobble) = (1 + 0.015 * sin(time * 1.8), 0, 0)
        case .listening: (scale, glow, wobble) = (1 + 0.1 * voice, 0.6 * voice, 0.35 * voice)
        case .thinking: (scale, glow, wobble) = (1 + 0.025 * sin(time * 5), 0.15, 0)
        case .speaking: (scale, glow, wobble) = (1 + 0.045 * voice, 0.7 * voice, voice)
        }
    }

    /// At rest: still, as on Today.
    static let still = OrbReaction(state: .listening, voice: 0, time: 0)

    /// Whose voice the orb follows in `state`, if anyone's.
    static func source(for state: VoiceOrbState) -> VoiceMeter.Source? {
        switch state {
        case .listening: .learner
        case .speaking: .companion
        case .idle, .thinking: nil
        }
    }
}

/// The companion: a dark glass bubble with a golden rim, smoky silk inside and
/// two glowing eyes that blink and glance around. Drawn by a Metal shader.
///
/// In a conversation (`isLive`) it shows who is talking: see `OrbReaction`.
///
/// One line to drop in: `CompanionOrb().frame(width: 220, height: 220)`.
/// Its look comes from `CompanionLook` (Settings › Developer).
struct CompanionOrb: View {
    var dynamics = OrbDynamics(state: .idle)
    /// Always drifts (in a conversation), even when the Look setting keeps it still.
    var isLive = false
    /// The loudness it reacts to.
    var meter: VoiceMeter = .shared
    /// Extra light from inside, 0…1: a moment's glow, like landing in a conversation.
    var flash: Double = 0

    @AppStorage(CompanionLook.Key.rim) private var rim = 1.0
    @AppStorage(CompanionLook.Key.silk) private var silk = 1.0
    @AppStorage(CompanionLook.Key.halo) private var halo = 1.0
    @AppStorage(CompanionLook.Key.eyeSize) private var eyeSize = 1.0
    @AppStorage(CompanionLook.Key.eyeSpacing) private var eyeSpacing = 1.0
    @AppStorage(CompanionLook.Key.lively) private var lively = true
    /// Whether the silk drifts. Off: one still frame, never redrawn.
    @AppStorage(CompanionLook.Key.drifts) private var drifts = false

    @Environment(\.reducesMotion) private var reduceMotion
    @State private var isVisible = true

    /// The colours follow the app's theme.
    private var palette: CompanionPalette { AppTheme.shared.palette }
    @State private var clock = OrbClock()
    @State private var voice = OrbVoice()

    var body: some View {
        let animates = (drifts || isLive) && !reduceMotion && isVisible
        TimelineView(.animation(paused: !animates)) { context in
            let time = animates ? clock.advance(to: context.date, speed: dynamics.speed) : Self.stillTime
            let loudness = animates ? voice.advance(to: context.date, target: target) : 0
            let reaction = animates
                ? OrbReaction(state: dynamics.state, voice: loudness, time: context.date.timeIntervalSinceReferenceDate)
                : .still
            ZStack {
                GeometryReader { proxy in
                    Rectangle()
                        .colorEffect(shader(size: proxy.size, time: time, reaction: reaction))
                }
                CompanionEyes(lively: lively, size: eyeSize, spacing: eyeSpacing, glow: palette.rim,
                              state: dynamics.state, voice: loudness)
            }
            .scaleEffect(reaction.scale)
        }
        .aspectRatio(1, contentMode: .fit)
        .onScrollVisibilityChange(threshold: 0.01) { isVisible = $0 }
        .onDisappear { isVisible = false }
        .onAppear { isVisible = true }
        .accessibilityHidden(true)
    }

    /// The loudness of whoever is talking now.
    private var target: Double {
        OrbReaction.source(for: dynamics.state).map { meter.level(of: $0) } ?? 0
    }

    private func shader(size: CGSize, time: Float, reaction: OrbReaction) -> Shader {
        ShaderLibrary.bubbleOrb(
            .float2(size),
            .float(time),
            .float(dynamics.energy + reaction.glow + flash),
            .float(reaction.wobble),
            .float(rim),
            .float(silk),
            .float(halo),
            .color(palette.deep),
            .color(palette.mid),
            .color(palette.light),
            .color(palette.rim)
        )
    }

    /// The moment shown when the silk doesn't drift: a balanced pose.
    private static let stillTime: Float = 2.2
}

/// Accumulates time at a changing speed. A class, so advancing it while
/// drawing doesn't invalidate the view.
final class OrbClock {
    private var last: Date?
    private(set) var time: Double = 0

    func advance(to date: Date, speed: Double) -> Float {
        if let last { time += date.timeIntervalSince(last) * speed }
        last = date
        // Wrap, so Float stays precise in long sessions.
        time = time.truncatingRemainder(dividingBy: 10_000)
        return Float(time)
    }
}

/// Follows the loudness smoothly: quick to rise with a voice, slower to fall,
/// so the orb doesn't flicker between syllables. A class, like `OrbClock`.
final class OrbVoice {
    private var last: Date?
    private(set) var value: Double = 0

    func advance(to date: Date, target: Double) -> Double {
        let step = last.map { min(max(date.timeIntervalSince($0), 0), 0.1) } ?? 0
        last = date
        let rate = target > value ? 22.0 : 7.0
        value += (min(max(target, 0), 1) - value) * (1 - exp(-step * rate))
        return value
    }
}

/// How the eyes look in each state. Pure, so it can be tested.
struct EyeLook: Equatable {
    /// The eyes' size, 1 as designed.
    var scale: Double
    /// How open they are: 1 open, smaller narrows them.
    var openness: Double
    /// Where they look, as a fraction of the orb's size.
    var gaze: CGSize

    init(state: VoiceOrbState) {
        switch state {
        // Waiting: as designed, glancing around now and then.
        case .idle: (scale, openness, gaze) = (1, 1, .zero)
        // Listening: wide awake, looking at the learner.
        case .listening: (scale, openness, gaze) = (1.12, 1, CGSize(width: 0, height: -0.01))
        // Thinking: narrowed, looking up to one side.
        case .thinking: (scale, openness, gaze) = (1, 0.5, CGSize(width: 0.045, height: -0.04))
        // Speaking: a friendly squint.
        case .speaking: (scale, openness, gaze) = (1, 0.8, .zero)
        }
    }
}

/// Where the eyes look, as a fraction of the orb's size. Pure, so it can be tested.
enum CompanionGaze {
    static let horizontal: ClosedRange<Double> = -0.06...0.06
    static let vertical: ClosedRange<Double> = -0.035...0.025

    /// A glance somewhere nearby, never straight ahead.
    static func random(using generator: inout some RandomNumberGenerator) -> CGSize {
        var x = Double.random(in: horizontal, using: &generator)
        if abs(x) < 0.02 { x = x < 0 ? -0.03 : 0.03 }
        return CGSize(width: x, height: Double.random(in: vertical, using: &generator))
    }
}

/// Two soft, glowing capsules, sized to the orb, that blink and glance around.
private struct CompanionEyes: View {
    var lively = true
    /// 1 is the designed size and gap.
    var size = 1.0
    var spacing = 1.0
    /// The light around the eyes, from the palette's rim.
    var glow = CompanionPalette.gold.rim
    var state = VoiceOrbState.idle
    /// The smoothed loudness of whoever is talking.
    var voice = 0.0

    @Environment(\.reducesMotion) private var reduceMotion
    @State private var isBlinking = false
    @State private var gaze = CGSize.zero
    private let eye = Color(red: 1.0, green: 0.96, blue: 0.86)  // warm cream

    var body: some View {
        GeometryReader { proxy in
            let side = min(proxy.size.width, proxy.size.height)
            let look = EyeLook(state: state)
            // Speaking, the eyes squint a little more on each loud syllable; listening, they lift.
            let openness = look.openness - (state == .speaking ? voice * 0.25 : 0)
            let lift = state == .listening ? voice * 0.012 : 0
            HStack(spacing: side * 0.12 * spacing) {
                ForEach(0..<2, id: \.self) { _ in
                    Capsule()
                        .fill(eye)
                        .frame(width: side * 0.07 * size * look.scale, height: side * 0.15 * size * look.scale)
                        .scaleEffect(x: 1, y: isBlinking ? 0.1 : openness)
                        .shadow(color: glow.opacity(0.9), radius: side * 0.04)
                        .shadow(color: eye.opacity(0.6), radius: side * 0.015)
                }
            }
            .offset(x: (gaze.width + look.gaze.width) * side, y: (gaze.height + look.gaze.height - lift) * side)
            .animation(.spring(duration: 0.45, bounce: 0.25), value: state)
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
        .accessibilityHidden(true)
        // Cancelled when the orb leaves the screen (e.g. another tab).
        .task(id: Behaviour(lively: lively && !reduceMotion, glances: state == .idle)) {
            guard lively, !reduceMotion else {
                gaze = .zero
                return
            }
            if state != .idle {
                withAnimation(.spring(duration: 0.4)) { gaze = .zero }
            }
            await live(glances: state == .idle)
        }
    }

    private struct Behaviour: Equatable {
        let lively: Bool
        let glances: Bool
    }

    /// Blinks, and glances while waiting, at natural, irregular moments until cancelled.
    private func live(glances: Bool) async {
        var generator = SystemRandomNumberGenerator()
        while !Task.isCancelled {
            guard await pause(2.5...5.5) else { return }
            if glances, Double.random(in: 0...1, using: &generator) < 0.35 {
                withAnimation(.spring(duration: 0.45, bounce: 0.2)) {
                    gaze = CompanionGaze.random(using: &generator)
                }
                guard await pause(1.0...2.4) else { return }
                withAnimation(.spring(duration: 0.5, bounce: 0.15)) { gaze = .zero }
            } else {
                await blink()
                if Double.random(in: 0...1, using: &generator) < 0.2 {
                    guard await pause(0.12...0.18) else { return }
                    await blink()
                }
            }
        }
    }

    private func blink() async {
        withAnimation(.easeIn(duration: 0.07)) { isBlinking = true }
        _ = await pause(0.09...0.09)
        withAnimation(.easeOut(duration: 0.13)) { isBlinking = false }
    }

    /// Sleeps for a random time in `range`; `false` once cancelled.
    private func pause(_ range: ClosedRange<Double>) async -> Bool {
        (try? await Task.sleep(for: .seconds(Double.random(in: range)))) != nil
    }
}

#if DEBUG
/// Settings › Developer: edit the companion; Today shows the changes at once.
struct CompanionEditor: View {
    @AppStorage(CompanionLook.Key.rim) private var rim = 1.0
    @AppStorage(CompanionLook.Key.silk) private var silk = 1.0
    @AppStorage(CompanionLook.Key.halo) private var halo = 1.0
    @AppStorage(CompanionLook.Key.eyeSize) private var eyeSize = 1.0
    @AppStorage(CompanionLook.Key.eyeSpacing) private var eyeSpacing = 1.0
    @AppStorage(CompanionLook.Key.lively) private var lively = true
    @AppStorage(CompanionLook.Key.drifts) private var drifts = false
    @Bindable private var theme = AppTheme.shared

    // Developer-only screen: the labels are not localised.
    var body: some View {
        List {
            Section {
                CompanionOrb()
                    .frame(width: 200, height: 200)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 12)
                    .listRowBackground(Color.black)
            }
            Section {
                ThemePicker()
            } header: {
                Text(verbatim: "Theme")
            } footer: {
                Text(verbatim: "The companion and the app's accent colour.")
            }
            Section(header: Text(verbatim: "Glass")) {
                slider("Rim", value: $rim, in: CompanionLook.range)
                slider("Silk", value: $silk, in: CompanionLook.range)
                slider("Halo", value: $halo, in: CompanionLook.range)
                Toggle(isOn: $drifts) { Text(verbatim: "Silk drifts") }
            }
            Section(header: Text(verbatim: "Eyes")) {
                slider("Size", value: $eyeSize, in: CompanionLook.eyeRange)
                slider("Spacing", value: $eyeSpacing, in: CompanionLook.eyeRange)
                Toggle(isOn: $lively) { Text(verbatim: "Blink and glance") }
            }
            Section {
                Button(role: .destructive) { reset() } label: { Text(verbatim: "Reset to default") }
            } footer: {
                Text(verbatim: values)
                    .monospaced()
                    .textSelection(.enabled)
            }
        }
        .scrollIndicators(.hidden)
        .scrollEdgeEffectStyle(.soft, for: .all)
        .navigationTitle(Text(verbatim: "Companion"))
    }

    private func slider(_ title: String, value: Binding<Double>, in range: ClosedRange<Double>) -> some View {
        LabeledContent {
            Slider(value: value, in: range)
        } label: {
            Text(verbatim: "\(title) \(value.wrappedValue.formatted(.number.precision(.fractionLength(2))))")
                .monospacedDigit()
        }
    }

    /// The current values, to copy into the defaults once they're right.
    private var values: String {
        let numbers = [("rim", rim), ("silk", silk), ("halo", halo), ("eyeSize", eyeSize), ("eyeSpacing", eyeSpacing)]
            .map { "\($0.0) \($0.1.formatted(.number.precision(.fractionLength(2))))" }
        return (["palette \(theme.palette.rawValue)"] + numbers + ["lively \(lively)", "drifts \(drifts)"])
            .joined(separator: " · ")
    }

    private func reset() {
        (rim, silk, halo, eyeSize, eyeSpacing) = (1, 1, 1, 1, 1)
        lively = true
        drifts = false
        theme.palette = .gold
    }
}

#Preview("Editor") {
    NavigationStack { CompanionEditor() }
        .preferredColorScheme(.dark)
}
#endif

#Preview {
    CompanionOrb()
        .frame(width: 240, height: 240)
        .padding()
        .background(.black)
}
