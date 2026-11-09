//
//  StarSky.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 09.11.26.
//

import SwiftUI

/// A soft wash from above the screen with a few faint, stationary stars.
struct StarSky: View {
    var body: some View {
        let colour = Color.accentFill
        Canvas { context, size in
            guard size.width > 0, size.height > 0 else { return }
            let radius = min(size.width * 0.72, size.height * 0.42)
            let centre = CGPoint(x: size.width * 0.48, y: -radius * 0.18)
            let edge = CGPoint(x: size.width * 0.78, y: radius * 0.04)
            Self.glow(in: context, at: centre, radius: radius, colour: colour.opacity(0.14))
            Self.glow(in: context, at: edge, radius: radius * 0.55, colour: colour.opacity(0.045))

            // Keep the same star positions as the selected Night haze design.
            var random = SeededRandom(seed: 151)
            for _ in 0..<14 {
                let point = CGPoint(x: size.width * random.next(in: 0.05...0.95),
                                    y: size.height * pow(random.next(in: 0...1), 1.4) * 0.29)
                let starRadius = random.next(in: 1...2.2)
                let remaining = max(0, 1 - point.y / (size.height * 0.66))
                let strength = random.next(in: 0.06...0.17) * (remaining * remaining)
                Self.glow(in: context, at: point, radius: starRadius, colour: colour.opacity(strength))
            }
        }
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    private static func glow(in context: GraphicsContext, at point: CGPoint, radius: CGFloat, colour: Color) {
        let disc = CGRect(x: point.x - radius, y: point.y - radius, width: radius * 2, height: radius * 2)
        context.fill(Path(ellipseIn: disc), with: .radialGradient(
            Gradient(stops: [
                .init(color: colour, location: 0),
                .init(color: colour.opacity(0.6), location: 0.45),
                .init(color: colour.opacity(0), location: 1)
            ]),
            center: point, startRadius: 0, endRadius: radius
        ))
    }
}

/// Repeatable random numbers (SplitMix64), so the stars stay where they are.
private struct SeededRandom {
    private var state: UInt64

    init(seed: UInt64) { state = seed }

    mutating func next(in range: ClosedRange<CGFloat>) -> CGFloat {
        state &+= 0x9E37_79B9_7F4A_7C15
        var mixed = state
        mixed = (mixed ^ (mixed >> 30)) &* 0xBF58_476D_1CE4_E5B9
        mixed = (mixed ^ (mixed >> 27)) &* 0x94D0_49BB_1331_11EB
        let unit = CGFloat((mixed ^ (mixed >> 31)) >> 11) / CGFloat(1 << 53)
        return range.lowerBound + unit * (range.upperBound - range.lowerBound)
    }
}

#Preview {
    ZStack {
        Color.screenBackground
        StarSky()
    }
    .ignoresSafeArea()
}
