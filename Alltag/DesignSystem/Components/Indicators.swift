//
//  Indicators.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// A row of thin segments showing progress through steps, e.g. onboarding
/// or an activity. Completed segments are accent-coloured.
struct ProgressSegments: View {
    let total: Int
    let completed: Int
    var height: CGFloat = 3

    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<max(total, 0), id: \.self) { index in
                Capsule()
                    .fill(index < clampedCompleted ? AnyShapeStyle(.accentFill) : AnyShapeStyle(.surfaceTertiary))
                    .frame(height: height)
            }
        }
        .animation(.easeOut(duration: 0.3), value: completed)
        .accessibilityElement()
        .accessibilityLabel("Progress")
        .accessibilityValue("\(clampedCompleted) of \(total)")
    }

    private var clampedCompleted: Int { min(max(completed, 0), total) }
}

/// Four dots showing how well a word is remembered (0–4).
struct StrengthDots: View {
    static let maximum = 4
    let strength: Int

    var body: some View {
        HStack(spacing: 3) {
            ForEach(0..<Self.maximum, id: \.self) { index in
                Circle()
                    .fill(index < clamped ? AnyShapeStyle(.accentFill) : AnyShapeStyle(.surfaceTertiary))
                    .frame(width: 5, height: 5)
            }
        }
        .accessibilityElement()
        .accessibilityLabel("Strength")
        .accessibilityValue("\(clamped) of \(Self.maximum)")
    }

    private var clamped: Int { min(max(strength, 0), Self.maximum) }
}
