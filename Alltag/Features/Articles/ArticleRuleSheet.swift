//
//  ArticleRuleSheet.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// A clue opened from its tile, in Today's look: the sky, the artwork, the
/// clue, its examples one per row with the article in the theme colour, and
/// the big button on to the next clue.
struct ArticleRuleSheet: View {
    let rule: ArticleRule
    @Environment(\.dismiss) private var dismiss
    @State private var current: ArticleRule.ID?
    @State private var turns = 0

    private var shown: ArticleRule { ArticleRule.all.first { $0.id == current } ?? rule }

    var body: some View {
        NavigationStack {
            ArticleRuleFocusSheet(rule: shown, onNext: next)
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
        .sensoryFeedback(.impact(weight: .medium), trigger: turns)
        .onChange(of: current) { _, _ in turns += 1 }
    }

    private func next() {
        let rules = ArticleRule.all
        let index = rules.firstIndex { $0.id == shown.id } ?? 0
        withAnimation(.easeOut(duration: 0.25)) { current = rules[(index + 1) % rules.count].id }
    }
}

/// One clue, and the big button for the next.
private struct ArticleRuleFocusSheet: View {
    let rule: ArticleRule
    let onNext: () -> Void

    var body: some View {
        ScrollView {
            ArticleRuleContent(rule: rule)
                .id(rule.id)
                .transition(.opacity)
                .padding(.horizontal, Spacing.onboarding)
                .padding(.top, 8)
        }
        .scrollEdgeEffectStyle(.soft, for: .all)
        .scrollIndicators(.hidden)
        .safeAreaInset(edge: .bottom) {
            Button(action: onNext) {
                Label("Next clue", systemImage: "arrow.right")
            }
            .buttonStyle(.primary)
            .padding(.horizontal, Spacing.onboarding)
            .padding(.bottom, 8)
        }
    }
}

// MARK: - Shared

/// The artwork and title, the clue, and the examples on one glass card.
private struct ArticleRuleContent: View {
    let rule: ArticleRule

    @ScaledMetric(relativeTo: .largeTitle) private var artworkSize: CGFloat = 112

    var body: some View {
        VStack(spacing: 24) {
            VStack(spacing: 14) {
                ScenarioArtwork(systemImage: rule.systemImage, symbolSize: 54, cornerRadius: 28)
                    .frame(width: artworkSize, height: artworkSize)
                Text(rule.title)
                    .font(.title.weight(.bold))
                    .accessibilityAddTraits(.isHeader)
                Text(rule.explanation)
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)

            VStack(alignment: .leading, spacing: 0) {
                Text("Examples")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)
                    .padding(.bottom, 6)
                ForEach(Array(examples.enumerated()), id: \.offset) { index, example in
                    if index > 0 { Divider() }
                    Text(Self.highlighted(example))
                        .font(.title3.weight(.medium))
                        .environment(\.locale, ArticleNounDetail.german)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.vertical, 12)
                }
            }
            .padding(Spacing.cardLarge)
            .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
        }
    }

    /// "der Tisch · die Tür" → one example per row.
    private var examples: [String] {
        rule.example.components(separatedBy: " · ")
    }

    /// The example with every der, die and das bold in the theme colour.
    static func highlighted(_ example: String) -> AttributedString {
        var text = AttributedString(example)
        for article in Article.allCases {
            var searchStart = text.startIndex
            while let range = text[searchStart...].range(of: article.rawValue) {
                let before = range.lowerBound == text.startIndex
                    || text.characters[text.index(beforeCharacter: range.lowerBound)] == " "
                let after = range.upperBound == text.endIndex || text.characters[range.upperBound] == " "
                if before && after {
                    text[range].foregroundColor = AppTheme.shared.palette.accent
                    text[range].inlinePresentationIntent = .stronglyEmphasized
                }
                searchStart = range.upperBound
            }
        }
        return text
    }
}

#Preview {
    Color.clear
        .sheet(isPresented: .constant(true)) {
            ArticleRuleSheet(rule: ArticleRule.all[1])
        }
}
