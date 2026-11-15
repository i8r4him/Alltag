//
//  CheatSheetView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// A cheat sheet opened from its tile, in the look of the article clues: the
/// sky, the artwork and title, then one glass card per part with its German
/// examples, the words the rule is about in the theme colour.
struct CheatSheetView: View {
    let sheet: GrammarCheatSheet
    @Environment(\.dismiss) private var dismiss

    @ScaledMetric(relativeTo: .largeTitle) private var artworkSize: CGFloat = 112

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Spacing.grid) {
                    header
                        .padding(.bottom, 12)
                    if sheet == .cases {
                        CaseTable()
                    }
                    ForEach(sheet.parts) { part in
                        CheatSheetPartCard(part: part)
                    }
                }
                .padding(.horizontal, Spacing.onboarding)
                .padding(.top, 8)
                .padding(.bottom, 24)
            }
            .scrollIndicators(.hidden)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            .skyBackground()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close", systemImage: "xmark") { dismiss() }
                }
            }
        }
        .fontDesign(.rounded)
        .presentationDetents([.large])
    }

    private var header: some View {
        VStack(spacing: 14) {
            ScenarioArtwork(systemImage: sheet.systemImage, symbolSize: 54, cornerRadius: 28)
                .frame(width: artworkSize, height: artworkSize)
            Text(sheet.title)
                .font(.title.weight(.bold))
                .accessibilityAddTraits(.isHeader)
            Text(sheet.intro)
                .font(.title3)
                .foregroundStyle(.secondary)
        }
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
    }
}

/// One part: its title, the rule in a line, and the examples one per row.
private struct CheatSheetPartCard: View {
    let part: CheatSheetPart

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(part.title)
                .font(.headline)
                .accessibilityAddTraits(.isHeader)
            Text(part.explanation)
                .font(.body)
                .foregroundStyle(.secondary)
                .padding(.bottom, 4)
            ForEach(Array(part.examples.enumerated()), id: \.offset) { index, example in
                if index > 0 { Divider() }
                Text(Self.highlighted(example))
                    .font(.title3.weight(.medium))
                    .environment(\.locale, ArticleNounDetail.german)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 8)
            }
        }
        .fixedSize(horizontal: false, vertical: true)
        .padding(Spacing.cardLarge)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }

    /// The example with the words the rule is about bold in the theme colour.
    static func highlighted(_ example: String) -> AttributedString {
        CheatSheetPart.runs(of: example).reduce(into: AttributedString()) { text, run in
            var piece = AttributedString(run.text)
            if run.isHighlighted {
                piece.foregroundColor = AppTheme.shared.palette.accent
                piece.inlinePresentationIntent = .stronglyEmphasized
            }
            text += piece
        }
    }
}

/// The articles by case: a row per case, a column per gender and the plural.
/// An article that differs from the nominative is in the theme colour.
private struct CaseTable: View {
    private let columns: [LocalizedStringResource] = ["Masc.", "Fem.", "Neut.", "Plural"]
    private var nominative: [String] { GrammarCheatSheet.caseTable.first?.articles ?? [] }

    var body: some View {
        Grid(alignment: .leading, horizontalSpacing: 10, verticalSpacing: 12) {
            GridRow {
                Color.clear.gridCellUnsizedAxes([.horizontal, .vertical])
                ForEach(Array(columns.enumerated()), id: \.offset) { _, column in
                    Text(column)
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                }
            }
            .accessibilityHidden(true)
            ForEach(Array(GrammarCheatSheet.caseTable.enumerated()), id: \.offset) { _, row in
                Divider().gridCellColumns(5)
                GridRow {
                    Text(row.name)
                        .font(.subheadline.weight(.semibold))
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                    ForEach(Array(row.articles.enumerated()), id: \.offset) { index, article in
                        Text(verbatim: article)
                            .font(.title3.weight(article == nominative[safe: index] ? .regular : .bold))
                            .foregroundStyle(article == nominative[safe: index] ? AnyShapeStyle(.primary) : AnyShapeStyle(.accent))
                    }
                }
                .accessibilityElement(children: .combine)
            }
        }
        .padding(Spacing.cardLarge)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }
}

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

#Preview("Cases") {
    Color.clear
        .sheet(isPresented: .constant(true)) { CheatSheetView(sheet: .cases) }
}

#Preview("Word order") {
    Color.clear
        .sheet(isPresented: .constant(true)) { CheatSheetView(sheet: .wordOrder) }
}
