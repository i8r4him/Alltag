//
//  TranslateDesign.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 14.11.26.
//

import SwiftUI

/// TEMPORARY (#296): the parts of Translate whose design is still open. Each
/// has two to four options; the maintainer picks one with the switcher next to
/// the part, and the others and this file are removed before the PR is merged.
enum TranslateDesignPart: String, CaseIterable {
    case start, input, button, result, details, loading, history

    var key: String { "translate.design.\(rawValue)" }

    var count: Int {
        switch self {
        case .start: 4
        case .input: 3
        case .button: 4
        case .result: 3
        case .details: 4
        case .loading: 3
        case .history: 2
        }
    }

    /// Not localised: it never ships.
    var name: String {
        switch self {
        case .start: "Empty start"
        case .input: "Input"
        case .button: "Translate button"
        case .result: "Result"
        case .details: "Details"
        case .loading: "Loading"
        case .history: "History"
        }
    }

    /// What each option is, shown beside the switcher.
    var options: [String] {
        switch self {
        case .start: ["Welcome card", "One merged card", "Prompts as chips", "Field only"]
        case .input: ["Pair card", "Language bar", "Compact field"]
        case .button: ["Below the card", "In the card", "Pinned at the bottom", "Round arrow"]
        case .result: ["Circles", "Labelled row", "Listen + menu"]
        case .details: ["Three cards", "Segmented", "Collapsible", "Tone chips"]
        case .loading: ["Spinner", "Placeholder", "One by one"]
        case .history: ["List", "Cards"]
        }
    }

    /// The stored choice, kept inside the part's range.
    func clamped(_ value: Int) -> Int { min(max(value, 1), count) }
}

/// The temporary "‹ n / N ›" glass switcher for one part.
struct DesignSwitcher: View {
    let part: TranslateDesignPart
    /// Called after the choice changed, e.g. to preview a state that is otherwise brief.
    var onChange: () -> Void = {}
    @AppStorage private var stored: Int

    init(_ part: TranslateDesignPart, onChange: @escaping () -> Void = {}) {
        self.part = part
        self.onChange = onChange
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
            onChange()
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
