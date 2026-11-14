//
//  MistakeDesign.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 14.11.26.
//

import SwiftUI

/// TEMPORARY (#251): the parts of Fix your mistakes whose design is still
/// open. The maintainer picks one of each with the switcher next to the part;
/// then the others and this file are removed.
enum MistakeDesign: String {
    case question, end

    var key: String { "mistakes.design.\(rawValue)" }

    /// Not localised: it never ships.
    var name: String {
        switch self {
        case .question: "Question"
        case .end: "End of the round"
        }
    }

    var options: [String] {
        switch self {
        case .question: ["Which sounds natural?", "Tap the wrong word", "Build it from tiles",
                            "Fill the gap", "Type what’s missing", "Flashcard: do you know it?"]
        case .end: ["Numbers", "Two lists", "Steps to learned", "Ring", "Before and after", "Timeline"]
        }
    }

    func clamped(_ value: Int) -> Int { min(max(value, 1), options.count) }
}

/// The temporary "‹ n / N ›" glass switcher for one part.
struct MistakeDesignSwitcher: View {
    let part: MistakeDesign
    @AppStorage private var stored: Int

    init(_ part: MistakeDesign) {
        self.part = part
        _stored = AppStorage(wrappedValue: 1, part.key)
    }

    private var count: Int { part.options.count }
    private var selection: Int { part.clamped(stored) }

    var body: some View {
        HStack(spacing: 8) {
            VStack(alignment: .leading, spacing: 0) {
                Text(verbatim: part.name).font(.caption.weight(.semibold))
                Text(verbatim: part.options[selection - 1]).font(.caption2).foregroundStyle(.secondary)
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
        .accessibilityLabel(Text(verbatim: offset < 0 ? "Previous \(part.name) design" : "Next \(part.name) design"))
    }
}
