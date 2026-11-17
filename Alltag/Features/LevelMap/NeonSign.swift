//
//  NeonSign.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// A place's sign on the night map: its symbol and German name as glowing
/// tubes in the theme's light, on a dark plate, hanging a little askew. A row
/// of bulbs under the name lights up as the learner finishes what's inside.
/// Switched off, the tubes are grey glass and nothing glows.
struct NeonSign: View {
    /// How many bulbs a sign has and how many are lit.
    struct Bulbs: Equatable {
        /// A sign never has more bulbs than this; each one then stands for several things to do.
        static let maximum = 8

        let count: Int
        let lit: Int

        /// One bulb per thing to do, up to `maximum`. A start lights the
        /// first bulb, and the last one lights only when everything is done.
        init(done: Int, total: Int) {
            count = min(max(total, 0), Self.maximum)
            guard count > 0, done > 0 else {
                lit = 0
                return
            }
            if done >= total {
                lit = count
            } else {
                let share = Int((Double(done) / Double(total) * Double(count)).rounded())
                lit = min(max(share, 1), count - 1)
            }
        }
    }

    let name: String
    let systemImage: String
    /// `nil` hangs no bulbs (the station, a place that is "soon").
    let bulbs: Bulbs?
    let isLit: Bool
    var tilt: Double = 0

    var body: some View {
        VStack(spacing: 3) {
            Image(systemName: systemImage)
                .font(.system(size: 24, weight: .medium))
            Text(verbatim: name)
                .font(.subheadline.weight(.heavy))
                .lineLimit(1)
                .fixedSize()
            if let bulbs {
                BulbRow(bulbs: bulbs, isLit: isLit)
                    .padding(.top, 3)
            }
        }
        .foregroundStyle(isLit ? AnyShapeStyle(.primary) : AnyShapeStyle(.tertiary))
        .shadow(color: glow, radius: 2)
        .shadow(color: glow, radius: 8)
        .padding(.horizontal, 14)
        .padding(.vertical, 9)
        .background(Color.screenBackground.opacity(0.78), in: plate)
        .overlay {
            plate
                .strokeBorder(isLit ? AnyShapeStyle(.accentFill) : AnyShapeStyle(.quaternary), lineWidth: 2)
                .shadow(color: glow, radius: 6)
        }
        .shadow(color: glow.opacity(0.35), radius: 18)
        .rotationEffect(.degrees(tilt))
        // A neon sign is a light at night, in light mode too.
        .environment(\.colorScheme, .dark)
        .animation(.easeOut(duration: 0.08), value: isLit)
    }

    private var glow: Color {
        isLit ? .accentFill : .clear
    }

    private var plate: RoundedRectangle {
        RoundedRectangle(cornerRadius: 16, style: .continuous)
    }
}

/// The bulbs under a sign's name.
private struct BulbRow: View {
    let bulbs: NeonSign.Bulbs
    let isLit: Bool

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<bulbs.count, id: \.self) { index in
                let isOn = isLit && index < bulbs.lit
                Circle()
                    .fill(isOn ? AnyShapeStyle(.primary) : AnyShapeStyle(.quaternary))
                    .frame(width: 6, height: 6)
                    .shadow(color: isOn ? .accentFill : .clear, radius: 3)
            }
        }
        .accessibilityHidden(true)
    }
}

#Preview {
    VStack(spacing: 30) {
        NeonSign(name: "Die Grundschule", systemImage: "pencil.and.ruler",
                 bulbs: .init(done: 9, total: 20), isLit: true, tilt: -3)
        NeonSign(name: "Der Bücherschrank", systemImage: "book.closed", bulbs: nil, isLit: false, tilt: -2)
    }
    .padding(40)
    .background(Color.screenBackground)
}
