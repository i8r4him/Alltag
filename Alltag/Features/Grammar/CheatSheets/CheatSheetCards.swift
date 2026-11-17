//
//  CheatSheetCards.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// The designs of a sheet's cards, to choose from on the branch. Temporary:
/// the one that's picked stays, the others and the switcher go.
enum CheatSheetDesign: Int, CaseIterable {
    case symbols, pictures, key

    var name: String {
        switch self {
        case .symbols: "Symbols"
        case .pictures: "Pictures"
        case .key: "Symbol key"
        }
    }
}

/// One part of a sheet on a glass card: its title, its picture in the
/// Pictures design, then each German example with its symbol and what it means.
struct CheatSheetPartCard: View {
    let part: CheatSheet.Part
    let sheet: CheatSheet
    let design: CheatSheetDesign

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 6) {
                if design == .key, let key = sheet.key(part.key) {
                    Image(systemName: key.systemImage)
                        .foregroundStyle(.accent)
                        .accessibilityHidden(true)
                }
                Text(part.title)
            }
            .font(.footnote.weight(.semibold))
            .foregroundStyle(.secondary)
            .textCase(.uppercase)
            .accessibilityAddTraits(.isHeader)
            .padding(.bottom, 6)

            if design == .pictures, let picture = part.picture {
                RuleScene(visual: picture)
                    .padding(.vertical, 14)
                Divider()
            }

            ForEach(Array(part.rows.enumerated()), id: \.offset) { index, row in
                if index > 0 { Divider() }
                CheatSheetRowView(row: row, key: design == .key ? sheet.key(row.key) : nil)
            }
        }
        .padding(Spacing.cardLarge)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }
}

/// One example: an everyday symbol, the German with the words it's about in
/// the theme colour, and what it means. In the Symbol key design the key's
/// symbol sits on the right.
private struct CheatSheetRowView: View {
    let row: CheatSheet.Row
    let key: CheatSheet.Key?
    @ScaledMetric(relativeTo: .title3) private var symbolWidth: CGFloat = 32

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            if let symbol = row.systemImage {
                Image(systemName: symbol)
                    .font(.title3)
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(.accent)
                    .frame(width: symbolWidth)
                    .accessibilityHidden(true)
            }
            VStack(alignment: .leading, spacing: 3) {
                Text(Self.highlighted(row))
                    .font(.title3.weight(.medium))
                    .environment(\.locale, Locale(identifier: "de_DE"))
                Text(row.meaning)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            if let key {
                Image(systemName: key.systemImage)
                    .font(.title3)
                    .foregroundStyle(.accent)
                    .accessibilityLabel(Text(verbatim: key.german))
            }
        }
        .fixedSize(horizontal: false, vertical: true)
        .padding(.vertical, 12)
        .accessibilityElement(children: .combine)
    }

    /// The German with the marked words in the theme colour. Without a mark
    /// the whole line is in the theme colour.
    static func highlighted(_ row: CheatSheet.Row) -> AttributedString {
        var text = AttributedString(row.german)
        guard let marked = row.marked, let range = text.range(of: marked) else {
            text.foregroundColor = AppTheme.shared.palette.accent
            return text
        }
        text[range].foregroundColor = AppTheme.shared.palette.accent
        text[range].inlinePresentationIntent = .stronglyEmphasized
        return text
    }
}

/// The Symbol key design: what each symbol on the sheet stands for, before
/// the parts that use them.
struct CheatSheetKeyCard: View {
    let keys: [CheatSheet.Key]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("What the symbols mean")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.secondary)
                .textCase(.uppercase)
                .accessibilityAddTraits(.isHeader)
                .padding(.bottom, 6)
            ForEach(Array(keys.enumerated()), id: \.offset) { index, key in
                if index > 0 { Divider() }
                HStack(spacing: 14) {
                    Image(systemName: key.systemImage)
                        .font(.title)
                        .foregroundStyle(.accent)
                        .accessibilityHidden(true)
                    VStack(alignment: .leading, spacing: 2) {
                        Text(verbatim: key.german)
                            .font(.headline)
                            .environment(\.locale, Locale(identifier: "de_DE"))
                        Text(key.meaning)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .fixedSize(horizontal: false, vertical: true)
                .padding(.vertical, 10)
                .accessibilityElement(children: .combine)
            }
        }
        .padding(Spacing.cardLarge)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }
}

/// A temporary "‹ n / N ›" glass switcher for choosing a design on the branch.
struct CheatSheetDesignSwitcher: View {
    @Binding var design: CheatSheetDesign

    var body: some View {
        HStack(spacing: 2) {
            arrow("chevron.left", step: -1)
            Text(verbatim: "\(design.rawValue + 1) / \(CheatSheetDesign.allCases.count) · \(design.name)")
                .font(.subheadline.weight(.semibold))
                .monospacedDigit()
            arrow("chevron.right", step: 1)
        }
        .padding(.horizontal, 4)
        .glassEffect(.regular.interactive(), in: .capsule)
        .sensoryFeedback(.selection, trigger: design)
    }

    private func arrow(_ symbol: String, step: Int) -> some View {
        Button {
            let count = CheatSheetDesign.allCases.count
            withAnimation(.snappy) {
                design = CheatSheetDesign(rawValue: (design.rawValue + step + count) % count) ?? .symbols
            }
        } label: {
            Image(systemName: symbol)
                .font(.headline)
                .frame(width: 44, height: 44)
                .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(Text(verbatim: step < 0 ? "Previous design" : "Next design"))
    }
}
