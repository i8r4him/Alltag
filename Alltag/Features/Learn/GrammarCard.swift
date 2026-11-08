//
//  GrammarCard.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// The Grammar entry: summary and a tiny sentence showing a rule.
struct GrammarCard: View {
    let rulesWorthALook: Int

    /// Grammar topics where the learner made a mistake, across all levels.
    static func rulesWithMistakes() -> Int {
        Level.selectable.flatMap { MockLevels.topics(for: $0) }.filter { $0.status == .mistake }.count
    }
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 14) {
                HStack(spacing: 10) {
                    Image(systemName: "text.badge.checkmark")
                        .font(.system(size: 22))
                        .accessibilityHidden(true)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Grammar").textRole(.cardTitle)
                        Text("A1–C1 · ^[\(rulesWorthALook) rule](inflect: true) worth a look")
                            .textRole(.meta)
                            .foregroundStyle(.secondary)
                    }
                    Spacer(minLength: 8)
                    Image(systemName: "chevron.right")
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(.tertiary)
                        .accessibilityHidden(true)
                }
                // German example, shown as is.
                HStack(spacing: 6) {
                    Text(verbatim: "… weil ich krank")
                        .foregroundStyle(.secondary)
                    Text(verbatim: "bin")
                        .fontWeight(.semibold)
                        .foregroundStyle(.accent)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(.accentFill.opacity(0.18), in: .rect(cornerRadius: 7, style: .continuous))
                    Spacer(minLength: 8)
                    Text("Verb at the end")
                        .textRole(.caption)
                        .foregroundStyle(.tertiary)
                }
                .textRole(.bodySmall)
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(.surfaceSecondary, in: .rect(cornerRadius: Radius.tile, style: .continuous))
            }
            .multilineTextAlignment(.leading)
            .padding(Spacing.card)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.surface, in: .rect(cornerRadius: Radius.card, style: .continuous))
            .contentShape(.rect(cornerRadius: Radius.card, style: .continuous))
        }
        .buttonStyle(.card)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    GrammarCard(rulesWorthALook: 2) {}
        .padding(Spacing.screen)
        .background(.screenBackground)
}
