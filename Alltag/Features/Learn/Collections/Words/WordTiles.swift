//
//  WordTiles.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Layout 2: every word as a glass tile in two columns, the article in the
/// theme colour. Tap a tile to turn it over for the sentence.
struct WordTiles: View {
    let words: [CollectionWord]

    @State private var turned: Set<String> = []
    private let columns = [GridItem(.flexible(), spacing: Spacing.grid),
                           GridItem(.flexible(), spacing: Spacing.grid)]

    var body: some View {
        LazyVGrid(columns: columns, spacing: Spacing.grid) {
            ForEach(words) { word in
                WordTile(word: word, isTurned: turned.contains(word.id))
                    .onTapGesture {
                        withAnimation(.smooth(duration: 0.35)) {
                            turned.formSymmetricDifference([word.id])
                        }
                    }
            }
        }
        .sensoryFeedback(.impact(weight: .medium), trigger: turned)
    }
}

private struct WordTile: View {
    let word: CollectionWord
    let isTurned: Bool

    @ScaledMetric(relativeTo: .headline) private var height: CGFloat = 120

    var body: some View {
        ZStack(alignment: .topLeading) {
            if isTurned {
                VStack(alignment: .leading, spacing: 4) {
                    Text(verbatim: word.example)
                        .font(.footnote.weight(.medium))
                        .lineLimit(4)
                        .minimumScaleFactor(0.8)
                    Spacer(minLength: 0)
                    Text(verbatim: word.exampleMeaning)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                .transition(.opacity)
            } else {
                VStack(alignment: .leading, spacing: 4) {
                    Text(verbatim: word.isNoun ? word.article.trimmingCharacters(in: .whitespaces) : " ")
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.accent)
                    Spacer(minLength: 0)
                    Text(verbatim: word.word)
                        .font(.headline)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                    Text(verbatim: word.meaning)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                .transition(.opacity)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, minHeight: height, maxHeight: height, alignment: .topLeading)
        .glassEffect(.regular.interactive(), in: .rect(cornerRadius: Radius.option, style: .continuous))
        .contentShape(.rect(cornerRadius: Radius.option, style: .continuous))
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
    }
}
