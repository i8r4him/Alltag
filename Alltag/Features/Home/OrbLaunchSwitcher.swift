//
//  OrbLaunchSwitcher.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Temporary (#424): "‹ n / 3 ›" under Today's orb, to try each way the orb carries
/// the learner into the conversation. Removed with the versions not picked.
struct OrbLaunchSwitcher: View {
    @AppStorage(OrbLaunchStyle.storageKey) private var launchStyle = OrbLaunchStyle.hop.rawValue

    private var style: OrbLaunchStyle { OrbLaunchStyle(rawValue: launchStyle) ?? .hop }
    private var count: Int { OrbLaunchStyle.allCases.count }

    var body: some View {
        GlassEffectContainer {
            HStack(spacing: 12) {
                Button { step(by: -1) } label: { Image(systemName: "chevron.left") }
                    .buttonStyle(.glass)
                    .buttonBorderShape(.circle)
                Text(verbatim: "\(style.rawValue + 1) / \(count) · \(style.title)")
                    .font(.subheadline.weight(.semibold))
                    .monospacedDigit()
                    .padding(.horizontal, 14)
                    .padding(.vertical, 8)
                    .glassEffect(.regular, in: .capsule)
                Button { step(by: 1) } label: { Image(systemName: "chevron.right") }
                    .buttonStyle(.glass)
                    .buttonBorderShape(.circle)
            }
        }
        .frame(maxWidth: .infinity)
        .fontDesign(.rounded)
        .sensoryFeedback(.selection, trigger: launchStyle)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text(verbatim: "Orb animation \(style.title)"))
        .accessibilityAdjustableAction { direction in
            step(by: direction == .increment ? 1 : -1)
        }
    }

    private func step(by offset: Int) {
        launchStyle = (style.rawValue + offset + count) % count
    }
}
