//
//  EntryGrid.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// The 2×2 grid of entry points: Translate, Learn, Memory, Progress.
struct EntryGrid: View {
    let status: HomeStatus
    let onOpen: (Route) -> Void

    var body: some View {
        Grid(horizontalSpacing: Spacing.grid, verticalSpacing: Spacing.grid) {
            GridRow {
                EntryCard(title: "Translate", status: status.translate, systemImage: "translate") {
                    onOpen(.translate())
                }
                EntryCard(title: "Learn", status: status.learn, systemImage: "bolt") {
                    onOpen(.learn)
                }
            }
            GridRow {
                EntryCard(title: "Memory", status: status.memory, systemImage: "book") {
                    onOpen(.memory())
                }
                EntryCard(title: "Progress", status: status.progress, systemImage: "chart.line.uptrend.xyaxis") {
                    onOpen(.progress)
                }
            }
        }
    }
}

/// A tappable card with an icon at the top and a title and status at the bottom.
private struct EntryCard: View {
    let title: LocalizedStringResource
    let status: Text
    let systemImage: String
    let action: () -> Void

    @ScaledMetric(relativeTo: .headline) private var height: CGFloat = 124

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 0) {
                Image(systemName: systemImage)
                    .font(.system(size: 22))
                    .foregroundStyle(.primary)
                    .accessibilityHidden(true)
                Spacer(minLength: 12)
                Text(title)
                    .textRole(.cardTitle)
                status
                    .textRole(.meta)
                    .foregroundStyle(.secondary)
                    .padding(.top, 2)
            }
            .multilineTextAlignment(.leading)
            .padding(Spacing.card)
            .frame(maxWidth: .infinity, minHeight: height, alignment: .leading)
            .background(.surface, in: .rect(cornerRadius: Radius.card, style: .continuous))
            .contentShape(.rect(cornerRadius: Radius.card, style: .continuous))
        }
        .buttonStyle(.tile)
        .accessibilityElement(children: .combine)
    }
}

/// The Grammar entry: summary and a tiny sentence showing a rule.
struct GrammarCard: View {
    let rulesWorthALook: Int
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
    VStack(spacing: Spacing.grid) {
        EntryGrid(status: HomeStatus(savedThisWeek: 3, dueForReview: 6, level: .b1, mistakeRules: 2)) { _ in }
        GrammarCard(rulesWorthALook: 2) {}
    }
    .padding(Spacing.screen)
    .background(.screenBackground)
}
