//
//  CompanionOrb.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 08.11.26.
//

import SwiftUI

/// The companion's adjustable look, saved in UserDefaults so edits made in
/// Settings › Developer show up on Today at once.
enum CompanionLook {
    enum Key {
        static let rim = "companion.rim"
        static let silk = "companion.silk"
        static let halo = "companion.halo"
        static let eyeSize = "companion.eyeSize"
        static let eyeSpacing = "companion.eyeSpacing"
        static let lively = "companion.lively"
        static let drifts = "companion.drifts"
        static let palette = "companion.palette"
    }

    /// The range of every amount and size: 1 is the designed look.
    static let range: ClosedRange<Double> = 0...2
    static let eyeRange: ClosedRange<Double> = 0.6...1.6
}

/// The companion's colours (glass, silk, highlights, rim and eyes), which
/// also set the app's theme: see `AppTheme`.
enum CompanionPalette: String, CaseIterable, Identifiable {
    case gold
    case copper
    case roseGold
    case champagne
    case pearl
    case coral
    case lavender

    var id: Self { self }

    /// Shown in Settings › Appearance.
    var title: LocalizedStringResource {
        switch self {
        case .gold: "Gold"
        case .copper: "Copper"
        case .roseGold: "Rose gold"
        case .champagne: "Champagne"
        case .pearl: "Pearl"
        case .coral: "Coral"
        case .lavender: "Lavender"
        }
    }

    /// Darkest: tints the glass.
    var deep: Color {
        switch self {
        case .gold: Color(red: 0.80, green: 0.42, blue: 0.04)       // #CC6B0A
        case .copper: Color(red: 0.54, green: 0.23, blue: 0.07)     // #8A3A12
        case .roseGold: Color(red: 0.48, green: 0.23, blue: 0.20)   // #7A3A34
        case .champagne: Color(red: 0.43, green: 0.34, blue: 0.20)  // #6E5634
        case .pearl: Color(red: 0.22, green: 0.27, blue: 0.37)      // #39445E
        case .coral: Color(red: 0.54, green: 0.18, blue: 0.12)      // #8A2E1E
        case .lavender: Color(red: 0.24, green: 0.18, blue: 0.48)   // #3E2E7A
        }
    }

    /// The silk.
    var mid: Color {
        switch self {
        case .gold: Color(red: 1.00, green: 0.72, blue: 0.16)       // #FFB829
        case .copper: Color(red: 0.78, green: 0.39, blue: 0.18)     // #C8642E
        case .roseGold: Color(red: 0.85, green: 0.51, blue: 0.43)   // #D9826E
        case .champagne: Color(red: 0.85, green: 0.73, blue: 0.54)  // #D8B98A
        case .pearl: Color(red: 0.72, green: 0.77, blue: 0.88)      // #B8C4E0
        case .coral: Color(red: 0.91, green: 0.42, blue: 0.31)      // #E86A4E
        case .lavender: Color(red: 0.56, green: 0.45, blue: 0.91)   // #8E72E8
        }
    }

    /// Highlights and the reflection.
    var light: Color {
        switch self {
        case .gold: Color(red: 1.00, green: 0.95, blue: 0.72)       // #FFF2B8
        case .copper: Color(red: 0.96, green: 0.82, blue: 0.69)     // #F6D2B0
        case .roseGold: Color(red: 0.98, green: 0.88, blue: 0.84)   // #FBE0D6
        case .champagne: Color(red: 1.00, green: 0.96, blue: 0.88)  // #FFF4E0
        case .pearl: Color(red: 1.00, green: 1.00, blue: 1.00)      // #FFFFFF
        case .coral: Color(red: 1.00, green: 0.88, blue: 0.82)      // #FFE0D2
        case .lavender: Color(red: 0.93, green: 0.91, blue: 1.00)   // #EEE8FF
        }
    }

    /// The rim, the halo and the eyes' glow.
    var rim: Color {
        switch self {
        case .gold: Color(red: 1.00, green: 0.62, blue: 0.10)       // #FF9E1A
        case .copper: Color(red: 0.91, green: 0.54, blue: 0.29)     // #E8894A
        case .roseGold: Color(red: 0.95, green: 0.65, blue: 0.56)   // #F2A58E
        case .champagne: Color(red: 0.95, green: 0.87, blue: 0.72)  // #F3DDB8
        case .pearl: Color(red: 0.92, green: 0.94, blue: 1.00)      // #EAF0FF
        case .coral: Color(red: 1.00, green: 0.54, blue: 0.42)      // #FF8A6B
        case .lavender: Color(red: 0.73, green: 0.64, blue: 1.00)   // #B9A3FF
        }
    }
}

/// How the companion moves in each conversation state. Pure, so it can be tested.
struct OrbDynamics: Equatable {
    /// How fast the silk drifts (1 = the shader's natural pace).
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

/// The companion: a dark glass bubble with a golden rim, smoky silk inside and
/// two glowing eyes that blink and glance around. Drawn by a Metal shader.
///
/// One line to drop in: `CompanionOrb().frame(width: 220, height: 220)`.
/// Its look comes from `CompanionLook` (Settings › Developer).
struct CompanionOrb: View {
    var dynamics = OrbDynamics(state: .idle)
    /// Always drifts (in a conversation), even when the Look setting keeps it still.
    var isLive = false

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

    var body: some View {
        let animates = (drifts || isLive) && !reduceMotion && isVisible
        TimelineView(.animation(paused: !animates)) { context in
            let time = animates ? clock.advance(to: context.date, speed: dynamics.speed) : Self.stillTime
            GeometryReader { proxy in
                Rectangle()
                    .colorEffect(ShaderLibrary.bubbleOrb(
                        .float2(proxy.size),
                        .float(time),
                        .float(dynamics.energy),
                        .float(rim),
                        .float(silk),
                        .float(halo),
                        .color(palette.deep),
                        .color(palette.mid),
                        .color(palette.light),
                        .color(palette.rim)
                    ))
            }
        }
        .aspectRatio(1, contentMode: .fit)
        .overlay {
            CompanionEyes(lively: lively, size: eyeSize, spacing: eyeSpacing, glow: palette.rim)
        }
        .onScrollVisibilityChange(threshold: 0.01) { isVisible = $0 }
        .onDisappear { isVisible = false }
        .onAppear { isVisible = true }
        .accessibilityHidden(true)
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

    @Environment(\.reducesMotion) private var reduceMotion
    @State private var isBlinking = false
    @State private var gaze = CGSize.zero
    private let eye = Color(red: 1.0, green: 0.96, blue: 0.86)  // warm cream

    var body: some View {
        GeometryReader { proxy in
            let side = min(proxy.size.width, proxy.size.height)
            HStack(spacing: side * 0.12 * spacing) {
                ForEach(0..<2, id: \.self) { _ in
                    Capsule()
                        .fill(eye)
                        .frame(width: side * 0.07 * size, height: side * 0.15 * size)
                        .scaleEffect(x: 1, y: isBlinking ? 0.1 : 1)
                        .shadow(color: glow.opacity(0.9), radius: side * 0.04)
                        .shadow(color: eye.opacity(0.6), radius: side * 0.015)
                }
            }
            .offset(x: gaze.width * side, y: gaze.height * side)
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
        .accessibilityHidden(true)
        // Cancelled when the orb leaves the screen (e.g. another tab).
        .task(id: lively && !reduceMotion) {
            guard lively, !reduceMotion else {
                gaze = .zero
                return
            }
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
