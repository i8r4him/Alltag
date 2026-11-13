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

    static let all: [ArticleRule] = [
        ArticleRule(id: "genders", title: "Three genders",
                    explanation: """
                        Der is masculine, die is feminine and das is neuter. They are grammatical, \
                        so they say little about the thing itself.
                        """,
                    example: "der Tisch · die Tür · das Fenster"),
        ArticleRule(id: "feminine", title: "Feminine endings",
                    explanation: "Nouns ending in -ung, -heit, -keit and -schaft are feminine.",
                    example: "die Wohnung · die Freiheit · die Möglichkeit · die Freundschaft"),
        ArticleRule(id: "small", title: "Small things: -chen and -lein",
                    explanation: "Diminutives ending in -chen or -lein are neuter, even when they are people.",
                    example: "das Mädchen · das Häuschen · das Büchlein"),
        ArticleRule(id: "compound", title: "The last noun decides",
                    explanation: "A compound noun takes the article of its last part.",
                    example: "die Tür → die Haustür · das Haus → das Krankenhaus"),
        ArticleRule(id: "plural", title: "The plural is always die",
                    explanation: "Every plural takes die, so it doesn't tell you the singular's article.",
                    example: "der Tisch → die Tische · das Kind → die Kinder"),
        ArticleRule(id: "senses", title: "Some words have two",
                    explanation: "The article can change with the meaning. Look the word up to see each meaning on its own.",
                    example: "der See: lake · die See: sea")
    ]
}

/// The clues as rows on one glass card; tap a row to read it.
struct ArticleRules: View {
    @State private var expanded: Set<String> = []

    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(ArticleRule.all.enumerated()), id: \.element.id) { index, rule in
                if index > 0 { Divider().padding(.leading, Spacing.cardLarge) }
                ArticleRuleRow(rule: rule, isExpanded: expanded.contains(rule.id)) {
                    if expanded.contains(rule.id) { expanded.remove(rule.id) } else { expanded.insert(rule.id) }
                }
            }
        }
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.card, style: .continuous))
        .animation(.easeOut(duration: 0.25), value: expanded)
    }
}

private struct ArticleRuleRow: View {
    let rule: ArticleRule
    let isExpanded: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 12) {
                    Text(rule.title)
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image(systemName: "chevron.down")
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(.tertiary)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                        .accessibilityHidden(true)
                }
                Text(verbatim: rule.example)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.accent)
                    .environment(\.locale, Locale(identifier: "de"))
                if isExpanded {
                    Text(rule.explanation)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.top, 2)
                        .transition(.opacity)
                }
            }
            .multilineTextAlignment(.leading)
            .padding(.horizontal, Spacing.cardLarge)
            .padding(.vertical, Spacing.card)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(isExpanded ? [.isButton, .isSelected] : .isButton)
        .sensoryFeedback(.selection, trigger: isExpanded)
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
