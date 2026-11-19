//
//  ArticleClueDesigns.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

// Temporary: three ways to show a clue's parts, behind a "‹ n / 3 ›" switcher
// in the sheet's title. The maintainer picks one; the others and the switcher
// go before the PR is merged.

/// The designs to choose from.
enum ArticleClueDesign: Int, CaseIterable {
    /// Grammar's cheat sheet card: the picture, then a row per noun.
    case pictures
    /// The picture on a card, then the nouns as a grid of glass tiles.
    case tiles
    /// The picture and the nouns as big cards in a row to swipe through.
    case cards

    var name: String {
        switch self {
        case .pictures: "Pictures"
        case .tiles: "Tiles"
        case .cards: "Cards"
        }
    }
}

/// "‹ 1 / 3 ›" with the design's name under it.
struct ArticleClueDesignSwitcher: View {
    @Binding var design: Int

    private var count: Int { ArticleClueDesign.allCases.count }

    var body: some View {
        HStack(spacing: 4) {
            Button { design = (design + count - 1) % count } label: {
                Image(systemName: "chevron.left")
            }
            .accessibilityLabel(Text(verbatim: "Previous design"))
            VStack(spacing: 0) {
                Text(verbatim: "\(design + 1) / \(count)")
                    .font(.subheadline.weight(.semibold).monospacedDigit())
                Text(verbatim: (ArticleClueDesign(rawValue: design) ?? .pictures).name)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
            }
            .frame(minWidth: 64)
            Button { design = (design + 1) % count } label: {
                Image(systemName: "chevron.right")
            }
            .accessibilityLabel(Text(verbatim: "Next design"))
        }
    }
}

/// A part's title and picture on a glass card, then each noun as a glass tile
/// with a big symbol.
struct ArticleClueTiles: View {
    let part: CheatSheet.Part
    @ScaledMetric(relativeTo: .title) private var symbolSize: CGFloat = 36

    var body: some View {
        VStack(spacing: Spacing.grid) {
            VStack(alignment: .leading, spacing: 0) {
                ArticleCluePartTitle(title: part.title)
                RuleScene(visual: part.picture)
                    .padding(.vertical, 14)
            }
            .padding(Spacing.cardLarge)
            .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))

            GlassEffectContainer {
                LazyVGrid(columns: [GridItem(.flexible(), spacing: Spacing.grid), GridItem(.flexible())],
                          spacing: Spacing.grid) {
                    ForEach(Array(part.rows.enumerated()), id: \.offset) { _, row in
                        VStack(spacing: 8) {
                            Image(systemName: row.systemImage)
                                .font(.system(size: symbolSize))
                                .symbolRenderingMode(.hierarchical)
                                .foregroundStyle(.accent)
                                .frame(height: symbolSize * 1.3)
                                .accessibilityHidden(true)
                            Text(row.highlighted)
                                .font(.headline)
                                .environment(\.locale, Locale(identifier: "de_DE"))
                            Text(row.meaning)
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                        }
                        .multilineTextAlignment(.center)
                        .padding(14)
                        .frame(maxWidth: .infinity, minHeight: 140)
                        .glassEffect(.regular, in: .rect(cornerRadius: 26, style: .continuous))
                        .accessibilityElement(children: .combine)
                    }
                }
            }
        }
    }
}

/// A part's title, then its picture and its nouns as big glass cards in a row
/// to swipe through, one noun per card.
struct ArticleClueCards: View {
    let part: CheatSheet.Part
    @ScaledMetric(relativeTo: .largeTitle) private var symbolSize: CGFloat = 58

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ArticleCluePartTitle(title: part.title)
            ScrollView(.horizontal) {
                LazyHStack(spacing: Spacing.grid) {
                    card {
                        RuleScene(visual: part.picture)
                    }
                    ForEach(Array(part.rows.enumerated()), id: \.offset) { _, row in
                        card {
                            VStack(spacing: 10) {
                                Image(systemName: row.systemImage)
                                    .font(.system(size: symbolSize))
                                    .symbolRenderingMode(.hierarchical)
                                    .foregroundStyle(.accent)
                                    .frame(height: symbolSize * 1.3)
                                    .accessibilityHidden(true)
                                Text(row.highlighted)
                                    .font(.title2.weight(.semibold))
                                    .environment(\.locale, Locale(identifier: "de_DE"))
                                Text(row.meaning)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            .multilineTextAlignment(.center)
                            .accessibilityElement(children: .combine)
                        }
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.viewAligned)
            .contentMargins(.horizontal, Spacing.onboarding, for: .scrollContent)
            .padding(.horizontal, -Spacing.onboarding)
            .scrollEdgeEffectStyle(.soft, for: .all)
            .scrollIndicators(.hidden)
        }
    }

    private func card(@ViewBuilder content: () -> some View) -> some View {
        content()
            .padding(Spacing.cardLarge)
            .frame(maxWidth: .infinity, minHeight: 220)
            .containerRelativeFrame(.horizontal) { width, _ in width * 0.72 }
            .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }
}

/// A part's title, small and in capitals, as on a cheat sheet's card.
private struct ArticleCluePartTitle: View {
    let title: LocalizedStringResource

    var body: some View {
        Text(title)
            .font(.footnote.weight(.semibold))
            .foregroundStyle(.secondary)
            .textCase(.uppercase)
            .accessibilityAddTraits(.isHeader)
            .padding(.bottom, 6)
    }
}

#Preview {
    ArticleRuleSheet(rule: ArticleRule.feminine)
}
