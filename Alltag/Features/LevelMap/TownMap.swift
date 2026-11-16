//
//  TownMap.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// The town under the level map, at night: blocks of houses, a few big
/// streets, a park and a river, in faint lines of the theme, laid out by the
/// level's `TownLayout`. Drawn in a `Canvas` with no progress in it, so it
/// never redraws when progress changes.
struct TownGround: View {
    let layout: TownLayout
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Canvas { context, size in
            let ink: Color = colorScheme == .dark ? .white : .black
            drawBlocks(in: &context, size: size, ink: ink)
            drawPark(in: &context, size: size)
            drawStreets(in: &context, size: size, ink: ink)
            drawRiver(in: &context, size: size, ink: ink)
        }
        .background(Color.screenBackground)
        .overlay {
            RadialGradient(colors: [.accentFill.opacity(0.18), .clear], center: .top, startRadius: 0, endRadius: 420)
        }
        .accessibilityHidden(true)
    }

    /// A grid of houses, turned a little, each block slightly different.
    private func drawBlocks(in context: inout GraphicsContext, size: CGSize, ink: Color) {
        var blocks = context
        blocks.translateBy(x: size.width / 2, y: size.height / 2)
        blocks.rotate(by: .degrees(layout.blockAngle))
        blocks.translateBy(x: -size.width / 2, y: -size.height / 2)
        var row = 0
        for y in stride(from: -80.0, to: size.height + 80, by: 58) {
            var column = 0
            for x in stride(from: -80.0, to: size.width + 80, by: 66) {
                let jitter = Self.jitter(row + layout.seed, column)
                // The bigger the town, the fewer empty plots.
                guard Self.jitter(column + layout.seed, row + 101) < layout.density else {
                    column += 1
                    continue
                }
                let rect = CGRect(x: x + 6 + jitter * 4, y: y + 6 + jitter * 3,
                                  width: 50 + jitter * 6, height: 42 + (1 - jitter) * 6)
                blocks.fill(Path(roundedRect: rect, cornerRadius: 6), with: .color(ink.opacity(0.05)))
                column += 1
            }
            row += 1
        }
    }

    private func drawPark(in context: inout GraphicsContext, size: CGSize) {
        let park = CGRect(x: size.width * layout.park.minX, y: size.height * layout.park.minY,
                          width: size.width * layout.park.width, height: size.height * layout.park.height)
        context.fill(Path(roundedRect: park, cornerRadius: 40), with: .color(.accentFill.opacity(0.06)))
        for index in 0..<12 {
            let jitter = Self.jitter(index + layout.seed, 7)
            let tree = CGRect(x: park.minX + 14 + Self.jitter(3, index + layout.seed) * (park.width - 40),
                              y: park.minY + 10 + jitter * (park.height - 26), width: 10 + jitter * 6, height: 10 + jitter * 6)
            context.fill(Path(ellipseIn: tree), with: .color(.accentFill.opacity(0.08)))
        }
    }

    private func drawStreets(in context: inout GraphicsContext, size: CGSize, ink: Color) {
        let width = size.width, height = size.height
        var streets = Path()
        streets.move(to: CGPoint(x: -20, y: height * 0.4))
        streets.addLine(to: CGPoint(x: width + 20, y: height * 0.32))
        streets.move(to: CGPoint(x: width * 0.15, y: -20))
        streets.addLine(to: CGPoint(x: width * 0.33, y: height + 20))
        streets.move(to: CGPoint(x: -20, y: height * 0.84))
        streets.addQuadCurve(to: CGPoint(x: width + 20, y: height * 0.82), control: CGPoint(x: width * 0.5, y: height * 0.76))
        streets.move(to: CGPoint(x: width * 0.78, y: -20))
        streets.addQuadCurve(to: CGPoint(x: width * 0.84, y: height + 20), control: CGPoint(x: width * 0.66, y: height * 0.5))
        if layout.isMirrored {
            streets = streets.applying(CGAffineTransform(a: -1, b: 0, c: 0, d: 1, tx: width, ty: 0))
        }
        context.stroke(streets, with: .color(ink.opacity(0.08)), style: StrokeStyle(lineWidth: 11, lineCap: .round))
    }

    private func drawRiver(in context: inout GraphicsContext, size: CGSize, ink: Color) {
        var river = Path()
        let enter = size.height * layout.riverIn, leave = size.height * layout.riverOut
        river.move(to: CGPoint(x: -40, y: enter))
        river.addCurve(to: CGPoint(x: size.width + 40, y: leave),
                       control1: CGPoint(x: size.width * 0.3, y: enter - size.height * 0.08),
                       control2: CGPoint(x: size.width * 0.6, y: leave + size.height * 0.1))
        context.stroke(river, with: .color(.accentFill.opacity(0.09)), lineWidth: 42)
        context.stroke(river, with: .color(ink.opacity(0.06)), style: StrokeStyle(lineWidth: 1.5, dash: [6, 10]))
    }

    /// A repeatable number from 0 to 1 for a block, so the town looks the same every time.
    private static func jitter(_ first: Int, _ second: Int) -> CGFloat {
        let value = sin(Double(first) * 12.9898 + Double(second) * 78.233) * 43_758.5453
        return CGFloat(value - value.rounded(.down))
    }
}

/// The walk through town: a dotted path from place to place up to the
/// station, solid as far as "You are here", and the railway leaving town.
struct TownRoute: View {
    let layout: TownLayout
    /// How many places of `TownPlace.route` the solid part reaches, from the first.
    let walkedTo: Int

    var body: some View {
        Canvas { context, size in
            let points = TownPlace.route.map { place in
                let spot = layout.spot(of: place)
                return CGPoint(x: spot.x * size.width, y: spot.y * size.height)
            }
            if let station = points.last {
                var railway = Path()
                railway.move(to: station)
                railway.addLine(to: CGPoint(x: station.x + 60, y: -size.height * 0.3))
                context.stroke(railway, with: .color(.accentFill.opacity(0.25)), lineWidth: 6)
                context.stroke(railway, with: .color(.accentFill.opacity(0.5)), style: StrokeStyle(lineWidth: 10, dash: [2, 9]))
            }
            context.stroke(Self.path(through: points), with: .color(.accentFill.opacity(0.85)),
                           style: StrokeStyle(lineWidth: 4, lineCap: .round, dash: [2, 10]))
            let walked = Self.path(through: points, segments: walkedTo)
            var glow = context
            glow.addFilter(.shadow(color: .accentFill, radius: 5))
            glow.stroke(walked, with: .color(.accentFill), style: StrokeStyle(lineWidth: 4, lineCap: .round))
        }
        .accessibilityHidden(true)
    }

    /// A smooth line through the points (Catmull-Rom as cubic curves). With
    /// `segments`, only that many parts from the start, lying exactly on the whole line.
    static func path(through points: [CGPoint], segments: Int? = nil) -> Path {
        var path = Path()
        guard let first = points.first else { return path }
        path.move(to: first)
        for index in points.indices.dropFirst().prefix(segments ?? points.count) {
            let previous = points[max(index - 2, 0)], start = points[index - 1]
            let end = points[index], next = points[min(index + 1, points.count - 1)]
            let control1 = CGPoint(x: start.x + (end.x - previous.x) / 6, y: start.y + (end.y - previous.y) / 6)
            let control2 = CGPoint(x: end.x - (next.x - start.x) / 6, y: end.y - (next.y - start.y) / 6)
            path.addCurve(to: end, control1: control1, control2: control2)
        }
        return path
    }
}
