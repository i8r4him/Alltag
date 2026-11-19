//
//  ArticleRuleSheet.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// A clue opened from its tile, in Today's look: the sky, the artwork, the
/// clue, its parts with a picture and everyday nouns with symbols, and the big
/// button on to the next clue.
struct ArticleRuleSheet: View {
    let rule: ArticleRule
    @Environment(\.dismiss) private var dismiss
    /// Which of the designs to try is shown; temporary, until one is picked.
    @AppStorage("articleClueDesign") private var design = 0
    @State private var current: ArticleRule.ID?
    @State private var turns = 0

    private var shown: ArticleRule { ArticleRule.all.first { $0.id == current } ?? rule }

    var body: some View {
        NavigationStack {
            ArticleRuleFocusSheet(rule: shown, design: ArticleClueDesign(rawValue: design) ?? .pictures, onNext: next)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .skyBackground()
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) {
                        Button("Close", systemImage: "xmark") { dismiss() }
                    }
                    ToolbarItem(placement: .principal) {
                        ArticleClueDesignSwitcher(design: $design)
                    }
                }
        }
        .fontDesign(.rounded)
        .presentationDetents([.large])
        .sensoryFeedback(.impact(weight: .medium), trigger: turns)
        .sensoryFeedback(.selection, trigger: design)
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
    let design: ArticleClueDesign
    let onNext: () -> Void

    var body: some View {
        ScrollView {
            ArticleRuleContent(rule: rule, design: design)
                .id(rule.id)
                .transition(.opacity)
                .padding(.horizontal, Spacing.onboarding)
                .padding(.top, 8)
                .padding(.bottom, 24)
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

/// The artwork and title, the clue, and its parts in the chosen design.
private struct ArticleRuleContent: View {
    let rule: ArticleRule
    let design: ArticleClueDesign

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

            ForEach(Array(rule.parts.enumerated()), id: \.offset) { _, part in
                switch design {
                case .pictures: CheatSheetPartCard(part: part)
                case .tiles: ArticleClueTiles(part: part)
                case .cards: ArticleClueCards(part: part)
                }
            }
        }
    }
}

#Preview {
    Color.clear
        .sheet(isPresented: .constant(true)) {
            ArticleRuleSheet(rule: ArticleRule.all[1])
        }
}
