//
//  CheatSheetCards.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// One part of a sheet on a glass card: its title, its picture (in the look
/// of a rule's picture), then each everyday example with its symbol and what
/// it means.
struct CheatSheetPartCard: View {
    let part: CheatSheet.Part

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(part.title)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
                .accessibilityAddTraits(.isHeader)
                .padding(.bottom, 6)

            RuleScene(visual: part.picture)
                .padding(.vertical, 14)

            ForEach(Array(part.rows.enumerated()), id: \.offset) { _, row in
                Divider()
                CheatSheetRowView(row: row)
            }
        }
        .padding(Spacing.cardLarge)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }
}

/// One example: an everyday symbol, the German with the words it's about in
/// the theme colour, and what it means.
private struct CheatSheetRowView: View {
    let row: CheatSheet.Row
    @ScaledMetric(relativeTo: .title3) private var symbolWidth: CGFloat = 32

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            Image(systemName: row.systemImage)
                .font(.title3)
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.accent)
                .frame(width: symbolWidth)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 3) {
                Text(Self.highlighted(row))
                    .font(.title3.weight(.medium))
                    .environment(\.locale, Locale(identifier: "de_DE"))
                Text(row.meaning)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .fixedSize(horizontal: false, vertical: true)
        .padding(.vertical, 12)
        .accessibilityElement(children: .combine)
    }

    /// The German with the marked words in the theme colour (the last match,
    /// so an ending can be marked by itself). Without a mark the whole line
    /// is in the theme colour.
    static func highlighted(_ row: CheatSheet.Row) -> AttributedString {
        var text = AttributedString(row.german)
        guard let marked = row.marked, let range = text.range(of: marked, options: .backwards) else {
            text.foregroundColor = AppTheme.shared.palette.accent
            return text
        }
        text[range].foregroundColor = AppTheme.shared.palette.accent
        text[range].inlinePresentationIntent = .stronglyEmphasized
        return text
    }
}
