//
//  TranslateDesign.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 14.11.26.
//

import SwiftUI

/// TEMPORARY (#296): the part of Translate whose design is still open. It
/// has four options; the maintainer picks one with the switcher next to
/// the part, and the others and this file are removed before the PR is merged.
enum TranslateDesignPart: String, CaseIterable {
    case start

    var key: String { "translate.design.\(rawValue)" }

    var count: Int { 4 }

    /// Not localised: it never ships.
    var name: String { "Empty start" }

    /// What each option is, shown beside the switcher.
    var options: [String] { ["Welcome card", "One merged card", "Prompts as chips", "Field only"] }

    /// The stored choice, kept inside the part's range.
    func clamped(_ value: Int) -> Int { min(max(value, 1), count) }
}

/// The temporary "‹ n / N ›" glass switcher for one part.
struct DesignSwitcher: View {
    let part: TranslateDesignPart
    @AppStorage private var stored: Int

    init(_ part: TranslateDesignPart) {
        self.part = part
        _stored = AppStorage(wrappedValue: 1, part.key)
    }

    private var selection: Int { part.clamped(stored) }

    var body: some View {
        HStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 0) {
                Text(verbatim: part.name)
                    .font(.caption.weight(.semibold))
                Text(verbatim: part.options[selection - 1])
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            Spacer(minLength: 8)
            HStack(spacing: 2) {
                step("chevron.left", by: -1)
                Text(verbatim: "\(selection) / \(part.count)")
                    .font(.caption.weight(.semibold))
                    .monospacedDigit()
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
            stored = (selection - 1 + offset + part.count) % part.count + 1
        } label: {
            Image(systemName: systemImage)
                .font(.caption.weight(.bold))
                .frame(width: 32, height: 32)
                .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text(verbatim: offset < 0 ? "Previous \(part.name) design" : "Next \(part.name) design"))
    }
}
