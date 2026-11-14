//
//  AskDesign.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 14.11.26.
//

import SwiftUI

/// TEMPORARY (#304): how "How do I say …?" answers on Learn. The maintainer
/// picks one with the switcher under the field; then the others and this
/// file are removed.
enum AskDesign {
    static let key = "ask.design"
    /// Not localised: it never ships.
    static let options = ["Answer grows under the field", "Spotlight over Learn", "Answer in a sheet"]

    static func clamped(_ value: Int) -> Int { min(max(value, 1), options.count) }
}

/// The temporary "‹ n / N ›" glass switcher.
struct AskDesignSwitcher: View {
    @AppStorage(AskDesign.key) private var stored = 1

    private var count: Int { AskDesign.options.count }
    private var selection: Int { AskDesign.clamped(stored) }

    var body: some View {
        HStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 0) {
                Text(verbatim: "How do I say …?").font(.caption.weight(.semibold))
                Text(verbatim: AskDesign.options[selection - 1]).font(.caption2).foregroundStyle(.secondary)
            }
            Spacer(minLength: 8)
            HStack(spacing: 2) {
                step("chevron.left", by: -1)
                Text(verbatim: "\(selection) / \(count)").font(.caption.weight(.semibold)).monospacedDigit()
                step("chevron.right", by: 1)
            }
            .padding(.horizontal, 4)
            .glassEffect(.regular.interactive(), in: .capsule)
        }
        .padding(.horizontal, 4)
        .sensoryFeedback(.selection, trigger: stored)
    }

    private func step(_ systemImage: String, by offset: Int) -> some View {
        Button {
            // Wraps round: after the last option comes the first.
            stored = (selection - 1 + offset + count) % count + 1
        } label: {
            Image(systemName: systemImage)
                .font(.caption.weight(.bold))
                .foregroundStyle(.primary)
                .frame(width: 32, height: 32)
                .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text(verbatim: offset < 0 ? "Previous design" : "Next design"))
    }
}
