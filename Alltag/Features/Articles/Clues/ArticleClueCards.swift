//
//  ArticleClueCards.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

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
