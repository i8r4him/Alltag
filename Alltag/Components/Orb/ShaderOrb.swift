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

    @Environment(\.reducesMotion) private var reduceMotion
    @State private var isVisible = true
    /// Flow time, advanced by `speed` so speed changes don't jump.
    @State private var clock = OrbClock()

    var body: some View {
        TimelineView(.animation(paused: reduceMotion || !isVisible)) { context in
            let time = clock.advance(to: context.date, speed: reduceMotion ? 0 : dynamics.speed)
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

    private var shader: ShaderFunction {
        switch style {
        case .sphere: ShaderLibrary.orb
        case .ribbon: ShaderLibrary.ribbonOrb
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

/// The golden ribbon ring: one line to drop in, e.g. `RibbonOrb().frame(width: 200)`.
struct RibbonOrb: View {
    var dynamics = OrbDynamics(state: .idle)

    var body: some View {
        ShaderOrb(style: .ribbon, dynamics: dynamics, palette: .gold)
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
    @State private var style = OrbStyle.ribbon
    @State private var state = VoiceOrbState.idle
    @State private var level = 0.5
    @State private var glow = 0.5
    @State private var size: CGFloat = 220

    var body: some View {
        VStack(spacing: 24) {
            Spacer(minLength: 0)
            ShaderOrb(style: style, dynamics: OrbDynamics(state: state, level: level),
                      palette: style == .ribbon ? .gold : .amber, glow: glow)
                .frame(width: size, height: size)
                .animation(.easeInOut(duration: 0.4), value: state)
            Spacer(minLength: 0)

            VStack(alignment: .leading, spacing: 12) {
                Picker(selection: $style) {
                    Text(verbatim: "Ribbon").tag(OrbStyle.ribbon)
                    Text(verbatim: "Sphere").tag(OrbStyle.sphere)
                } label: { Text(verbatim: "Style") }
                .pickerStyle(.segmented)
                Picker(selection: $state) {
                    ForEach(VoiceOrbState.allCases, id: \.self) { Text(verbatim: "\($0)").tag($0) }
                } label: { Text(verbatim: "State") }
                .pickerStyle(.segmented)
                // Developer-only: not localised.
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
