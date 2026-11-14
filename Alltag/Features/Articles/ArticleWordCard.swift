//
//  ArticleWordCard.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// A looked-up noun on a clear glass card, like a dictionary entry: the
/// article as a filled chip over the word, the facts as rows, and a bookmark
/// in the corner that saves it to Memory and takes it out again.
struct ArticleWordCard: View {
    let noun: Noun
    let isSaved: Bool
    let onToggleSave: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 6) {
                Text(verbatim: noun.article.rawValue)
                    .font(.headline)
                    .foregroundStyle(.onAccent)
                    .padding(.horizontal, 14)
                    .padding(.vertical, 4)
                    .background(.accentFill, in: .capsule)
                Text(verbatim: noun.word)
                    .font(.largeTitle.weight(.bold))
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)
                Text(verbatim: noun.meaning)
                    .font(.title3)
                    .foregroundStyle(.secondary)
            }
            .environment(\.locale, ArticleNounDetail.german)
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .padding(.top, 8)
            ArticleWordRows(noun: noun)
        }
        .overlay(alignment: .topTrailing) {
            ArticleBookmarkButton(isSaved: isSaved, action: onToggleSave)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.cardLarge)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }
}

/// Plural, example and why as rows with a divider between them, each with its symbol.
private struct ArticleWordRows: View {
    let noun: Noun

    @ScaledMetric(relativeTo: .subheadline) private var labelWidth: CGFloat = 104

    var body: some View {
        VStack(spacing: 0) {
            if noun.hasPlural {
                row(Text("Plural"), systemImage: "square.stack", value: Text(verbatim: "die \(noun.plural)"), german: true)
            }
            if !noun.example.isEmpty {
                row(Text("Example"), systemImage: "quote.opening", value: Text(verbatim: noun.example).italic(), german: true)
            }
            if !noun.explanation.isEmpty {
                row(Text("Why"), systemImage: "lightbulb", value: Text(verbatim: noun.explanation))
            }
        }
    }

    private func row(_ label: Text, systemImage: String, value: Text, german: Bool = false) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Divider()
            HStack(alignment: .firstTextBaseline, spacing: 12) {
                Label {
                    label.foregroundStyle(.secondary)
                } icon: {
                    Image(systemName: systemImage).foregroundStyle(.accent)
                }
                .font(.subheadline.weight(.semibold))
                .frame(width: labelWidth, alignment: .leading)
                value
                    .font(.subheadline)
                    .environment(\.locale, german ? ArticleNounDetail.german : .current)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.vertical, 12)
            .accessibilityElement(children: .combine)
        }
    }
}

/// The bookmark in the card's corner: empty when the word isn't in Memory, filled when it is.
/// Tapping it again takes the word out of Memory.
private struct ArticleBookmarkButton: View {
    let isSaved: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                .font(.title3.weight(.semibold))
                .foregroundStyle(.accent)
                .contentTransition(.symbolEffect(.replace))
                .frame(width: 44, height: 44)
        }
        .buttonStyle(.plain)
        .glassEffect(.regular.interactive(), in: .circle)
        .accessibilityLabel(isSaved ? Text("Remove from Memory") : Text("Save to Memory"))
    }
}

#Preview {
    var noun = Noun(.die, "Wohnung", "Wohnungen", "flat, apartment")
    noun.example = "Die Wohnung hat zwei Zimmer."
    noun.explanation = "Nouns ending in -ung are feminine."
    return ScrollView {
        VStack(spacing: 16) {
            ArticleWordCard(noun: noun, isSaved: false) {}
            ArticleWordCard(noun: noun, isSaved: true) {}
        }
        .padding(Spacing.screen)
    }
    .skyBackground()
    .fontDesign(.rounded)
}
