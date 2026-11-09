//
//  StarSky.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 09.11.26.
//

import SwiftUI

/// Temporary: four star skies for Today's background, to compare.
enum StarSkyStyle: Int, CaseIterable {
    case dust, constellations, milkyWay, sparkle

    var name: String {
        switch self {
        case .dust: "Fine dust"
        case .constellations: "Constellations"
        case .milkyWay: "Milky Way"
        case .sparkle: "Sparkle"
        }
    }
}

/// Stars in one colour (the theme's), densest at the top and fading towards
/// the bottom. Drawn once: positions come from a fixed seed, nothing animates.
struct StarSky: View {
    let style: StarSkyStyle

    var body: some View {
        Canvas { context, size in
            var random = SeededRandom(seed: 42 + UInt64(style.rawValue))
            let colour = Color.accentFill
            switch style {
            case .dust: Self.dust(in: &context, size: size, colour: colour, random: &random)
            case .constellations: Self.constellations(in: &context, size: size, colour: colour, random: &random)
            case .milkyWay: Self.milkyWay(in: &context, size: size, colour: colour, random: &random)
            case .sparkle: Self.sparkle(in: &context, size: size, colour: colour, random: &random)
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    // MARK: Styles

    /// Hundreds of tiny, faint stars.
    private static func dust(in context: inout GraphicsContext, size: CGSize, colour: Color,
                             random: inout SeededRandom) {
        for _ in 0..<280 {
            let point = randomPoint(in: size, random: &random)
            star(in: &context, at: point, radius: random.next(in: 0.4...1.2),
                 opacity: random.next(in: 0.2...0.85) * fade(point, size), colour: colour)
        }
    }

    /// A light scatter of stars, with four small constellations joined by fine lines.
    private static func constellations(in context: inout GraphicsContext, size: CGSize, colour: Color,
                                       random: inout SeededRandom) {
        for _ in 0..<90 {
            let point = randomPoint(in: size, random: &random)
            star(in: &context, at: point, radius: random.next(in: 0.5...1.3),
                 opacity: random.next(in: 0.2...0.7) * fade(point, size), colour: colour)
        }
        for _ in 0..<4 {
            let centre = CGPoint(x: random.next(in: 0.1...0.9) * size.width,
                                 y: random.next(in: 0.04...0.4) * size.height)
            var points = [centre]
            for _ in 0..<4 {
                let last = points[points.count - 1]
                points.append(CGPoint(x: last.x + random.next(in: -60...60), y: last.y + random.next(in: -40...40)))
            }
            var line = Path()
            line.addLines(points)
            let strength = fade(centre, size)
            context.stroke(line, with: .color(colour.opacity(0.28 * strength)), lineWidth: 0.7)
            for point in points {
                halo(in: &context, at: point, radius: 6, opacity: 0.35 * strength, colour: colour)
                star(in: &context, at: point, radius: 1.8, opacity: strength, colour: colour)
            }
        }
    }

    /// A soft diagonal band of light, thick with stars.
    private static func milkyWay(in context: inout GraphicsContext, size: CGSize, colour: Color,
                                 random: inout SeededRandom) {
        let start = CGPoint(x: -0.1 * size.width, y: 0.05 * size.height)
        let end = CGPoint(x: 1.1 * size.width, y: 0.42 * size.height)
        var band = Path()
        band.move(to: start)
        band.addQuadCurve(to: end, control: CGPoint(x: 0.5 * size.width, y: 0.12 * size.height))
        context.drawLayer { layer in
            layer.addFilter(.blur(radius: 34))
            layer.stroke(band, with: .color(colour.opacity(0.16)), lineWidth: 90)
        }
        for _ in 0..<520 {
            let along = random.next(in: 0...1)
            let curve = quadPoint(start, CGPoint(x: 0.5 * size.width, y: 0.12 * size.height), end, along)
            let spread = random.gaussian() * 38
            let point = CGPoint(x: curve.x + spread * 0.45, y: curve.y + spread)
            star(in: &context, at: point, radius: random.next(in: 0.3...1.1),
                 opacity: random.next(in: 0.25...0.9) * fade(point, size), colour: colour)
        }
        for _ in 0..<60 {
            let point = randomPoint(in: size, random: &random)
            star(in: &context, at: point, radius: random.next(in: 0.4...1.0),
                 opacity: random.next(in: 0.2...0.6) * fade(point, size), colour: colour)
        }
    }

    /// Fewer stars, with a handful of bright ones that glint.
    private static func sparkle(in context: inout GraphicsContext, size: CGSize, colour: Color,
                                random: inout SeededRandom) {
        for _ in 0..<110 {
            let point = randomPoint(in: size, random: &random)
            star(in: &context, at: point, radius: random.next(in: 0.5...1.3),
                 opacity: random.next(in: 0.25...0.8) * fade(point, size), colour: colour)
        }
        for _ in 0..<9 {
            let point = CGPoint(x: random.next(in: 0.05...0.95) * size.width,
                                y: random.next(in: 0.03...0.45) * size.height)
            let strength = fade(point, size)
            let length = random.next(in: 7...13)
            halo(in: &context, at: point, radius: length * 0.9, opacity: 0.3 * strength, colour: colour)
            glint(in: &context, at: point, length: length, opacity: strength, colour: colour)
        }
    }

    // MARK: Drawing

    private static func star(in context: inout GraphicsContext, at point: CGPoint, radius: CGFloat,
                             opacity: CGFloat, colour: Color) {
        let rect = CGRect(x: point.x - radius, y: point.y - radius, width: radius * 2, height: radius * 2)
        context.fill(Path(ellipseIn: rect), with: .color(colour.opacity(opacity)))
    }

    private static func halo(in context: inout GraphicsContext, at point: CGPoint, radius: CGFloat,
                             opacity: CGFloat, colour: Color) {
        let rect = CGRect(x: point.x - radius, y: point.y - radius, width: radius * 2, height: radius * 2)
        context.fill(Path(ellipseIn: rect), with: .radialGradient(
            Gradient(colors: [colour.opacity(opacity), colour.opacity(0)]),
            center: point, startRadius: 0, endRadius: radius))
    }

    /// A four-pointed glint: two thin diamonds crossing.
    private static func glint(in context: inout GraphicsContext, at point: CGPoint, length: CGFloat,
                              opacity: CGFloat, colour: Color) {
        let thin = length * 0.14
        var path = Path()
        path.move(to: CGPoint(x: point.x, y: point.y - length))
        path.addLine(to: CGPoint(x: point.x + thin, y: point.y))
        path.addLine(to: CGPoint(x: point.x, y: point.y + length))
        path.addLine(to: CGPoint(x: point.x - thin, y: point.y))
        path.closeSubpath()
        path.move(to: CGPoint(x: point.x - length, y: point.y))
        path.addLine(to: CGPoint(x: point.x, y: point.y + thin))
        path.addLine(to: CGPoint(x: point.x + length, y: point.y))
        path.addLine(to: CGPoint(x: point.x, y: point.y - thin))
        path.closeSubpath()
        context.fill(path, with: .color(colour.opacity(opacity)))
    }

    // MARK: Helpers

    /// More stars near the top: y is skewed upwards.
    private static func randomPoint(in size: CGSize, random: inout SeededRandom) -> CGPoint {
        CGPoint(x: random.next(in: 0...1) * size.width, y: pow(random.next(in: 0...1), 1.6) * size.height)
    }

    /// Full strength at the top, gone by two thirds of the way down.
    private static func fade(_ point: CGPoint, _ size: CGSize) -> CGFloat {
        max(0, 1 - point.y / (size.height * 0.68))
    }

    private static func quadPoint(_ from: CGPoint, _ control: CGPoint, _ end: CGPoint, _ progress: CGFloat) -> CGPoint {
        let rest = 1 - progress
        let (first, middle, last) = (rest * rest, 2 * rest * progress, progress * progress)
        return CGPoint(x: first * from.x + middle * control.x + last * end.x,
                       y: first * from.y + middle * control.y + last * end.y)
    }
}

/// Repeatable random numbers (SplitMix64), so the stars stay where they are.
struct SeededRandom {
    private var state: UInt64

    init(seed: UInt64) { state = seed }

    mutating func next() -> UInt64 {
        state &+= 0x9E37_79B9_7F4A_7C15
        var mixed = state
        mixed = (mixed ^ (mixed >> 30)) &* 0xBF58_476D_1CE4_E5B9
        mixed = (mixed ^ (mixed >> 27)) &* 0x94D0_49BB_1331_11EB
        return mixed ^ (mixed >> 31)
    }

    mutating func next(in range: ClosedRange<CGFloat>) -> CGFloat {
        let unit = CGFloat(next() >> 11) / CGFloat(1 << 53)
        return range.lowerBound + unit * (range.upperBound - range.lowerBound)
    }

    /// Roughly normal, mean 0, deviation 1.
    mutating func gaussian() -> CGFloat {
        (0..<4).reduce(0) { sum, _ in sum + next(in: -1...1) } * 0.87
    }
}

/// Temporary: all eight skies, four by Claude and four by Codex, in one list.
enum SkyChoice: Hashable, CaseIterable {
    case claude(StarSkyStyle)
    case codex(CodexSkyStyle)

    static let allCases: [SkyChoice] = StarSkyStyle.allCases.map(SkyChoice.claude)
        + CodexSkyStyle.allCases.map(SkyChoice.codex)

    var name: String {
        switch self {
        case .claude(let style): "\(style.name) · Claude"
        case .codex(let style): "\(style.name) · Codex"
        }
    }
}

/// The chosen sky.
struct SkyBackground: View {
    let choice: SkyChoice

    var body: some View {
        switch choice {
        case .claude(let style): StarSky(style: style)
        case .codex(let style): CodexStarSky(style: style)
        }
    }
}

/// Temporary: ‹ Sky 3 / 8 · Milky Way · Claude › to step through the skies.
struct StarSkySwitcher: View {
    @Binding var choice: SkyChoice

    var body: some View {
        let all = SkyChoice.allCases
        let index = all.firstIndex(of: choice) ?? 0
        HStack(spacing: 12) {
            Button { step(-1) } label: { Image(systemName: "chevron.left") }
            Text(verbatim: "Sky \(index + 1) / \(all.count) · \(choice.name)")
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .frame(minWidth: 210)
            Button { step(1) } label: { Image(systemName: "chevron.right") }
        }
        .font(.footnote.weight(.semibold))
        .buttonStyle(.glass)
        .frame(maxWidth: .infinity)
        .sensoryFeedback(.selection, trigger: choice)
    }

    private func step(_ offset: Int) {
        let all = SkyChoice.allCases
        let index = all.firstIndex(of: choice) ?? 0
        withAnimation(.easeInOut(duration: 0.3)) { choice = all[(index + offset + all.count) % all.count] }
    }
}

#Preview {
    ZStack {
        Color.black
        StarSky(style: .sparkle)
    }
    .ignoresSafeArea()
}
