//
//  DesignSwitcher.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Temporary "‹ n / N ›" glass switcher between design options. It is removed,
/// with the options not chosen, before the PR is merged, so its text isn't localised.
struct DesignSwitcher: View {
    @Binding var selection: Int
    let count: Int

    var body: some View {
        HStack(spacing: 2) {
            Button { selection = (selection + count - 1) % count } label: {
                Image(systemName: "chevron.left")
                    .frame(width: 32, height: 32)
            }
            .accessibilityLabel(Text(verbatim: "Previous design"))
            Text(verbatim: "\(selection + 1) / \(count)")
                .font(.subheadline.weight(.semibold).monospacedDigit())
            Button { selection = (selection + 1) % count } label: {
                Image(systemName: "chevron.right")
                    .frame(width: 32, height: 32)
            }
            .accessibilityLabel(Text(verbatim: "Next design"))
        }
        .font(.subheadline.weight(.semibold))
        .foregroundStyle(.accent)
        .padding(.horizontal, 4)
        .glassEffect(.regular.interactive(), in: .capsule)
        .buttonStyle(.plain)
        .sensoryFeedback(.selection, trigger: selection)
    }
}
