//
//  GrammarCheatSheets.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// A cheat sheet on Grammar: one page to look something up quickly.
enum GrammarCheatSheet: String, CaseIterable, Identifiable {
    case articles
    case cases
    case wordOrder

    var id: String { rawValue }

    /// The German on the tile.
    var german: String {
        switch self {
        case .articles: "der · die · das"
        case .cases: "Akk · Dat"
        case .wordOrder: "Verb 2"
        }
    }

    var title: LocalizedStringResource {
        switch self {
        case .articles: "Articles"
        case .cases: "Cases"
        case .wordOrder: "Word order"
        }
    }

    var systemImage: String {
        switch self {
        case .articles: "tag.fill"
        case .cases: "arrow.triangle.branch"
        case .wordOrder: "text.alignleft"
        }
    }
}

/// "Cheat sheets": three glass tiles side by side; each opens its sheet,
/// which grows out of the tile and shrinks back into it.
struct GrammarCheatSheets: View {
    @State private var open: GrammarCheatSheet?
    @Namespace private var transition

    var body: some View {
        GlassEffectContainer(spacing: Spacing.grid) {
            HStack(spacing: Spacing.grid) {
                ForEach(GrammarCheatSheet.allCases) { sheet in
                    CheatSheetTile(sheet: sheet) { open = sheet }
                        .matchedTransitionSource(id: sheet.id, in: transition)
                }
            }
        }
        .sheet(item: $open) { sheet in
            Group {
                switch sheet {
                case .articles:
                    ArticleRuleSheet(rule: ArticleRule.all[0])
                case .cases, .wordOrder:
                    CheatSheetView(sheet: sheet)
                }
            }
            .navigationTransition(.zoom(sourceID: sheet.id, in: transition))
        }
        .sensoryFeedback(.impact(weight: .medium), trigger: open) { _, opened in opened != nil }
    }
}

/// A square glass tile: the symbol, the German pattern and what it's about.
private struct CheatSheetTile: View {
    let sheet: GrammarCheatSheet
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 4) {
                Image(systemName: sheet.systemImage)
                    .font(.title3)
                    .foregroundStyle(.accent)
                    .accessibilityHidden(true)
                Spacer(minLength: 0)
                Text(verbatim: sheet.german)
                    .font(.headline)
                    .foregroundStyle(.accent)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                Text(sheet.title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .aspectRatio(1, contentMode: .fit)
            .contentShape(.rect(cornerRadius: 26, style: .continuous))
            .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 26, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityHint("Opens the cheat sheet.")
    }
}
