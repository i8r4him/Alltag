//
//  ArticleRules.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 13.11.26.
//

import SwiftUI

/// A clue about which article a noun takes: a short title, the clue, and
/// examples in German.
struct ArticleRule: Identifiable {
    let id: String
    let title: LocalizedStringResource
    let explanation: LocalizedStringResource
    let example: String
    let systemImage: String

    static let all: [ArticleRule] = [
        ArticleRule(id: "genders", title: "Three genders",
                    explanation: """
                        Der is masculine, die is feminine and das is neuter. They are grammatical, \
                        so they say little about the thing itself.
                        """,
                    example: "der Tisch · die Tür · das Fenster", systemImage: "tag.fill"),
        ArticleRule(id: "feminine", title: "Feminine endings",
                    explanation: "Nouns ending in -ung, -heit, -keit and -schaft are feminine.",
                    example: "die Wohnung · die Freiheit · die Möglichkeit · die Freundschaft", systemImage: "text.append"),
        ArticleRule(id: "small", title: "Small things: -chen and -lein",
                    explanation: "Diminutives ending in -chen or -lein are neuter, even when they are people.",
                    example: "das Mädchen · das Häuschen · das Büchlein", systemImage: "textformat.size.smaller"),
        ArticleRule(id: "compound", title: "The last noun decides",
                    explanation: "A compound noun takes the article of its last part.",
                    example: "die Tür → die Haustür · das Haus → das Krankenhaus", systemImage: "puzzlepiece.fill"),
        ArticleRule(id: "plural", title: "The plural is always die",
                    explanation: "Every plural takes die, so it doesn't tell you the singular's article.",
                    example: "der Tisch → die Tische · das Kind → die Kinder", systemImage: "square.stack.fill"),
        ArticleRule(id: "senses", title: "Some words have two",
                    explanation: "The article can change with the meaning. Look the word up to see each meaning on its own.",
                    example: "der See: lake · die See: sea", systemImage: "arrow.left.arrow.right")
    ]
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
