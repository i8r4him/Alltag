//
//  ArticleRules.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 13.11.26.
//

import SwiftUI

/// A clue about which article a noun takes: a short title, the clue, and
/// parts that each open with a picture and go on with everyday nouns, each
/// with a symbol and what it means (the look of Grammar's cheat sheets).
struct ArticleRule: Identifiable {
    let id: String
    let title: LocalizedStringResource
    let explanation: LocalizedStringResource
    let systemImage: String
    let parts: [CheatSheet.Part]
}

/// "A few useful clues": a grid of glass tiles; tap one to read the clue in a
/// sheet that grows out of the tile.
struct ArticleRules: View {
    @State private var open: ArticleRule.ID?
    @Namespace private var transition

    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: Spacing.grid), GridItem(.flexible())], spacing: Spacing.grid) {
            ForEach(ArticleRule.all) { rule in
                Button { open = rule.id } label: {
                    VStack(alignment: .leading, spacing: 10) {
                        Image(systemName: rule.systemImage)
                            .font(.title3)
                            .foregroundStyle(.accent)
                            .frame(width: 44, height: 44)
                            .glassEffect(.regular, in: .circle)
                        Text(rule.title)
                            .font(.headline)
                            .multilineTextAlignment(.leading)
                        Spacer(minLength: 0)
                    }
                    .padding(Spacing.card)
                    .frame(maxWidth: .infinity, minHeight: 140, alignment: .topLeading)
                    .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
                }
                .buttonStyle(.plain)
                .matchedTransitionSource(id: rule.id, in: transition)
            }
        }
        // The clue grows out of its tile and shrinks back into it.
        .sheet(item: Binding(get: { ArticleRule.all.first { $0.id == open } }, set: { open = $0?.id })) { rule in
            ArticleRuleSheet(rule: rule)
                .navigationTransition(.zoom(sourceID: rule.id, in: transition))
        }
        .sensoryFeedback(.impact(weight: .medium), trigger: open) { _, opened in opened != nil }
    }
}

#Preview {
    ScrollView {
        ArticleRules()
            .padding(Spacing.screen)
    }
    .skyBackground()
    .fontDesign(.rounded)
}
