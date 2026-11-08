//
//  ShaderOrb.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 08.11.26.
//

import SwiftUI

/// The orb's colours, darkest to brightest, plus the light around its edge.
struct OrbPalette: Equatable {
    var deep: Color
    var mid: Color
    var light: Color
    var rim: Color

    /// Alltag's amber: copper depths, honey highlights, a warm rim.
    static let amber = OrbPalette(
        deep: Color(red: 0.54, green: 0.22, blue: 0.06),  // #8A380F
        mid: Color(red: 0.95, green: 0.60, blue: 0.27),   // #F29945
        light: Color(red: 1.00, green: 0.93, blue: 0.76), // #FFEDC2
        rim: Color(red: 1.00, green: 0.76, blue: 0.46)    // #FFC275
    )
}

extension OrbPalette {
    /// Bright gold for the ribbon ring.
    static let gold = OrbPalette(
        deep: Color(red: 0.80, green: 0.42, blue: 0.04),  // #CC6B0A
        mid: Color(red: 1.00, green: 0.72, blue: 0.16),   // #FFB829
        light: Color(red: 1.00, green: 0.95, blue: 0.72), // #FFF2B8
        rim: Color(red: 1.00, green: 0.62, blue: 0.10)    // #FF9E1A
    )
}

/// The orb's look.
enum OrbStyle {
    /// A glassy sphere with colour flowing inside.
    case sphere
    /// A glowing ring of twisting translucent ribbons.
    case ribbon
    /// Clouds of warm light inside a dark glass sphere, Siri-like.
    case glow
    /// A dark glass bubble with a golden rim and wisps of silk inside.
    case bubble
}

/// How the orb moves in each conversation state. Pure, so it can be tested.
struct OrbDynamics: Equatable {
    /// How fast the colour flows (1 = the shader's natural pace).
    var speed: Double
    /// 0 calm … 1 excited.
    var energy: Double

    /// The motion for `state`, with `level` the current voice loudness (0…1).
    init(state: VoiceOrbState, level: Double = 0) {
        let level = min(max(level, 0), 1)
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

/// A 3D-looking orb drawn by a Metal shader: colour flows inside a glowing
/// sphere lit from the top left.
///
/// It animates only while on screen, and stands still with Reduce Motion.
struct ShaderOrb: View {
    var style = OrbStyle.sphere
    var dynamics = OrbDynamics(state: .idle)
    var palette = OrbPalette.amber
    /// The soft light around the orb, 0…1.
    var glow = 0.5
    /// `false` draws one still frame and never redraws.
    var animates = true

    @Environment(\.reducesMotion) private var reduceMotion
    @State private var isVisible = true
    /// Flow time, advanced by `speed` so speed changes don't jump.
    @State private var clock = OrbClock()

    var body: some View {
        TimelineView(.animation(paused: !animates || reduceMotion || !isVisible)) { context in
            let time = animates
                ? clock.advance(to: context.date, speed: reduceMotion ? 0 : dynamics.speed)
                : Self.stillTime
            GeometryReader { proxy in
                Rectangle()
                    .colorEffect(shader(
                        .float2(proxy.size),
                        .float(time),
                        .float(dynamics.energy),
                        .color(palette.deep),
                        .color(palette.mid),
                        .color(palette.light),
                        .color(palette.rim)
                    ))
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .background {
            // The ribbon draws its own glow.
            if style == .sphere { glowLight }
        }
        .onScrollVisibilityChange(threshold: 0.01) { isVisible = $0 }
        .onDisappear { isVisible = false }
        .onAppear { isVisible = true }
        .accessibilityHidden(true)
    }

    /// The moment shown when the orb doesn't move: a balanced pose.
    private static let stillTime: Float = 2.2

    private var shader: ShaderFunction {
        switch style {
        case .sphere: ShaderLibrary.orb
        case .ribbon: ShaderLibrary.ribbonOrb
        case .glow: ShaderLibrary.glowOrb
        case .bubble: ShaderLibrary.bubbleOrb
        }
    }

    private var glowLight: some View {
        Circle()
            .fill(palette.mid)
            .scaleEffect(1.15)
            .blur(radius: 40)
            .opacity(glow * (0.5 + dynamics.energy * 0.5))
    }
}

/// The companion: a glass bubble with golden silk inside and two glowing eyes.
/// One line to drop in, e.g. `CompanionOrb().frame(width: 220)`.
/// The bubble is still by default (`animates: true` lets the silk drift);
/// the eyes blink and glance around now and then unless `lively` is off.
struct CompanionOrb: View {
    var dynamics = OrbDynamics(state: .idle)
    var animates = false
    var lively = true

    var body: some View {
        ShaderOrb(style: .bubble, dynamics: dynamics, palette: .gold, animates: animates)
            .overlay { CompanionEyes(lively: lively) }
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
struct CompanionEyes: View {
    var lively = true

    @Environment(\.reducesMotion) private var reduceMotion
    @State private var isBlinking = false
    @State private var gaze = CGSize.zero
    private let eye = Color(red: 1.0, green: 0.96, blue: 0.86)  // warm cream

    var body: some View {
        GeometryReader { proxy in
            let side = min(proxy.size.width, proxy.size.height)
            HStack(spacing: side * 0.12) {
                ForEach(0..<2, id: \.self) { _ in
                    Capsule()
                        .fill(eye)
                        .frame(width: side * 0.07, height: side * 0.15)
                        .scaleEffect(x: 1, y: isBlinking ? 0.1 : 1)
                        .shadow(color: OrbPalette.gold.rim.opacity(0.9), radius: side * 0.04)
                        .shadow(color: eye.opacity(0.6), radius: side * 0.015)
                }
            }
            .offset(x: gaze.width * side, y: gaze.height * side)
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
        .accessibilityHidden(true)
        // Cancelled when the orb leaves the screen (e.g. another tab).
        .task(id: lively && !reduceMotion) {
            guard lively, !reduceMotion else { return }
            await live()
        }
    }

    /// Blinks and glances at natural, irregular moments until cancelled.
    private func live() async {
        var generator = SystemRandomNumberGenerator()
        while !Task.isCancelled {
            guard await pause(2.5...5.5) else { return }
            if Double.random(in: 0...1, using: &generator) < 0.35 {
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

/// Clouds of warm light in a dark glass sphere: one line to drop in, e.g.
/// `GlowOrb().frame(width: 220)`. Still by default; `animates: true` lets the light drift.
struct GlowOrb: View {
    var dynamics = OrbDynamics(state: .idle)
    var animates = false

    var body: some View {
        ShaderOrb(style: .glow, dynamics: dynamics, palette: .gold, animates: animates)
    }
}

/// The golden ribbon ring: one line to drop in, e.g. `RibbonOrb().frame(width: 200)`.
/// Still by default; `animates: true` lets it turn.
struct RibbonOrb: View {
    var dynamics = OrbDynamics(state: .idle)
    var animates = false

    var body: some View {
        ShaderOrb(style: .ribbon, dynamics: dynamics, palette: .gold, animates: animates)
    }
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

#if DEBUG
/// Tune the orb on a device: state, voice level, glow and size.
struct OrbPlayground: View {
    @State private var style = OrbStyle.bubble
    @State private var animates = true
    @State private var state = VoiceOrbState.idle
    @State private var level = 0.5
    @State private var glow = 0.5
    @State private var size: CGFloat = 220

    var body: some View {
        VStack(spacing: 24) {
            Spacer(minLength: 0)
            ShaderOrb(style: style, dynamics: OrbDynamics(state: state, level: level),
                      palette: style == .sphere ? .amber : .gold, glow: glow, animates: animates)
                .overlay { if style == .bubble { CompanionEyes() } }
                .frame(width: size, height: size)
                .animation(.easeInOut(duration: 0.4), value: state)
            Spacer(minLength: 0)

            VStack(alignment: .leading, spacing: 12) {
                Picker(selection: $style) {
                    Text(verbatim: "Companion").tag(OrbStyle.bubble)
                    Text(verbatim: "Glow").tag(OrbStyle.glow)
                    Text(verbatim: "Ribbon").tag(OrbStyle.ribbon)
                    Text(verbatim: "Sphere").tag(OrbStyle.sphere)
                } label: { Text(verbatim: "Style") }
                .pickerStyle(.segmented)
                Picker(selection: $state) {
                    ForEach(VoiceOrbState.allCases, id: \.self) { Text(verbatim: "\($0)").tag($0) }
                } label: { Text(verbatim: "State") }
                .pickerStyle(.segmented)
                // Developer-only: not localised.
                Toggle(isOn: $animates) { Text(verbatim: "Moves") }
                LabeledContent { Slider(value: $level) } label: { Text(verbatim: "Voice level") }
                LabeledContent { Slider(value: $glow) } label: { Text(verbatim: "Glow") }
                LabeledContent { Slider(value: $size, in: 80...320) } label: { Text(verbatim: "Size") }
            }
            .padding(Spacing.card)
            .glassEffect(.regular, in: .rect(cornerRadius: Radius.card, style: .continuous))
        }
        .padding(Spacing.screen)
        .background(.screenBackground)
        .navigationTitle(Text(verbatim: "Orb playground"))
    }
}

#Preview("Playground") {
    NavigationStack { OrbPlayground() }
        .preferredColorScheme(.dark)
}
#endif

#Preview("States") {
    HStack(spacing: 12) {
        ForEach(VoiceOrbState.allCases, id: \.self) { state in
            ShaderOrb(dynamics: OrbDynamics(state: state, level: 0.6)).frame(width: 80)
        }
    }
    .padding()
    .background(.black)
}
