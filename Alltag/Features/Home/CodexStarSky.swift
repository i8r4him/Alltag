//
//  CodexStarSky.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

enum CodexSkyStyle: Int, CaseIterable {
    case crescent, meteors, orbits, softFocus

    var name: String {
        switch self {
        case .crescent: "Crescent"
        case .meteors: "Meteors"
        case .orbits: "Orbits"
        case .softFocus: "Soft focus"
        }
    }
}

struct CodexStarSky: View {
    let style: CodexSkyStyle

    var body: some View {
        let colour = Color.accentFill
        Canvas { context, size in
            guard size.width > 0, size.height > 0 else { return }
            var sky = Drawing(context: context, size: size, colour: colour,
                              random: SeededRandom(seed: 147 + UInt64(style.rawValue)))
            sky.scatter()
            switch style {
            case .crescent: sky.crescent()
            case .meteors: sky.meteors()
            case .orbits: sky.orbits()
            case .softFocus: sky.softFocus()
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    private struct Drawing {
        let context: GraphicsContext
        let size: CGSize
        let colour: Color
        var random: SeededRandom

        /// Small points give the four foreground motifs a shared sense of depth.
        mutating func scatter() {
            for _ in 0..<48 {
                let point = scatteredPoint()
                let radius = random.next(in: 0.35...0.85)
                let opacity = random.next(in: 0.2...0.55)
                dot(at: point, radius: radius, opacity: opacity)
            }
        }

        /// A small sliver of moon high on one side, with a bright companion star.
        func crescent() {
            let centre = CGPoint(x: size.width * 0.78, y: size.height * 0.14)
            let radius: CGFloat = 13
            let tip = CGPoint(x: centre.x + radius * 0.46, y: centre.y - radius)
            let base = CGPoint(x: tip.x, y: centre.y + radius)
            var moon = Path()
            moon.move(to: tip)
            moon.addCurve(to: base,
                          control1: CGPoint(x: centre.x - radius * 1.4, y: centre.y - radius),
                          control2: CGPoint(x: centre.x - radius * 1.4, y: centre.y + radius))
            moon.addCurve(to: tip,
                          control1: CGPoint(x: centre.x - radius * 0.48, y: centre.y + radius * 0.58),
                          control2: CGPoint(x: centre.x - radius * 0.48, y: centre.y - radius * 0.58))
            moon.closeSubpath()
            context.fill(moon, with: .color(colour.opacity(0.62 * fade(at: centre))))
            dot(at: CGPoint(x: centre.x + radius * 1.35, y: centre.y - radius * 0.35),
                radius: 1.25, opacity: 0.8)
        }

        /// Four short trails with a bright head and a tail that vanishes.
        mutating func meteors() {
            for index in 0..<4 {
                let across = (CGFloat(index) + random.next(in: 0.28...0.64)) / 4
                let head = CGPoint(x: size.width * across, y: size.height * random.next(in: 0.06...0.35))
                let length = random.next(in: 22...48)
                let tail = CGPoint(x: head.x + length, y: head.y - length * 0.45)
                let brightness = fade(at: head)
                var trail = Path()
                trail.move(to: tail)
                trail.addLine(to: head)
                context.stroke(trail, with: .linearGradient(
                    Gradient(colors: [colour.opacity(0), colour.opacity(0.8 * brightness)]),
                    startPoint: tail, endPoint: head
                ), style: StrokeStyle(lineWidth: 0.8, lineCap: .round))
                dot(at: head, radius: 1.1, opacity: 0.9)
            }
        }

        /// Dots trace three unconnected arcs above the orb.
        mutating func orbits() {
            for ring in 0..<3 {
                let horizontalRadius = size.width * (0.23 + CGFloat(ring) * 0.12)
                let verticalRadius = size.height * (0.12 + CGFloat(ring) * 0.08)
                let count = 16 + ring * 6
                for index in 0..<count {
                    let progress = (CGFloat(index) + random.next(in: 0.1...0.9)) / CGFloat(count)
                    let angle = 0.12 + progress * (.pi - 0.24)
                    let point = CGPoint(x: size.width * 0.5 + cos(angle) * horizontalRadius,
                                        y: size.height * 0.35 - sin(angle) * verticalRadius)
                    let radius = random.next(in: 0.45...1.05)
                    let opacity = random.next(in: 0.35...0.7)
                    dot(at: point, radius: radius, opacity: opacity)
                }
            }
        }

        /// Out-of-focus discs behind the small, sharp stars.
        mutating func softFocus() {
            for _ in 0..<16 {
                let point = scatteredPoint()
                let radius = random.next(in: 3...9)
                let strength = random.next(in: 0.14...0.34) * fade(at: point)
                context.fill(disc(at: point, radius: radius), with: .radialGradient(
                    Gradient(stops: [
                        .init(color: colour.opacity(strength), location: 0),
                        .init(color: colour.opacity(strength * 0.6), location: 0.45),
                        .init(color: colour.opacity(0), location: 1)
                    ]),
                    center: point, startRadius: 0, endRadius: radius
                ))
            }
        }

        private mutating func scatteredPoint() -> CGPoint {
            CGPoint(x: random.next(in: 0...1) * size.width,
                    y: pow(random.next(in: 0...1), 1.5) * size.height * 0.66)
        }

        private func fade(at point: CGPoint) -> CGFloat {
            let remaining = max(0, 1 - point.y / (size.height * 0.66))
            return remaining * remaining
        }

        private func dot(at point: CGPoint, radius: CGFloat, opacity: CGFloat) {
            context.fill(disc(at: point, radius: radius), with: .color(colour.opacity(opacity * fade(at: point))))
        }

        private func disc(at point: CGPoint, radius: CGFloat) -> Path {
            Path(ellipseIn: CGRect(x: point.x - radius, y: point.y - radius,
                                   width: radius * 2, height: radius * 2))
        }
    }
}
