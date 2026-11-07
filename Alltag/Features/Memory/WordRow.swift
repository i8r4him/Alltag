//
//  WordRow.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// A word in Memory: article and word, meaning, mistake badge and strength.
/// Expanded, it shows the example, the source, Listen and Practise.
struct WordRow: View {
    let item: MemoryItem
    let isExpanded: Bool
    let onToggle: () -> Void
    let onListen: () -> Void
    let onPractise: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: onToggle) {
                HStack(spacing: 12) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("\(Text(verbatim: item.article).fontWeight(.regular).foregroundStyle(.tertiary))\(Text(verbatim: item.word))")
                            .textRole(.cardTitle)
                        Text(verbatim: item.meaning)
                            .textRole(.bodySmall)
                            .foregroundStyle(.secondary)
                    }
                    .multilineTextAlignment(.leading)
                    Spacer(minLength: 8)
                    if item.kind == .mistake {
                        Pill(title: "Mistake", tone: .mistake)
                            .textCase(.uppercase)
                    }
                    StrengthDots(strength: item.strength)
                }
                .padding(.horizontal, Spacing.card)
                .padding(.vertical, 14)
                .contentShape(.rect)
            }
            .buttonStyle(.plain)
            .accessibilityElement(children: .combine)
            .accessibilityHint(isExpanded ? Text("Hides the example") : Text("Shows an example"))

            if isExpanded {
                details
                    .padding(.horizontal, Spacing.card)
                    .padding(.bottom, Spacing.card)
                    .transition(.opacity)
            }
        }
    }

    private var details: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text(verbatim: item.context).textRole(.body)
                Text(verbatim: item.contextNote).textRole(.meta).foregroundStyle(.secondary)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.surfaceSecondary, in: .rect(cornerRadius: Radius.tile, style: .continuous))

            HStack(spacing: 8) {
                Label {
                    Text("\(Text(item.source.title)) · \(item.sourceDetail)")
                } icon: {
                    Image(systemName: item.source.systemImage)
                }
                .textRole(.meta)
                .foregroundStyle(.tertiary)
                .frame(maxWidth: .infinity, alignment: .leading)

                Button("Listen", systemImage: "speaker.wave.2", action: onListen)
                    .labelStyle(.iconOnly)
                    .frame(width: 36, height: 36)
                    .background(.controlFill, in: .circle)
                    .buttonStyle(.plain)
                Button("Practise", action: onPractise)
                    .buttonStyle(.chip(isSelected: false))
            }
        }
    }
}
