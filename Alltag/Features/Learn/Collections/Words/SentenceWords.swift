//
//  SentenceWords.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Layout 4: sentence first. Each word is learnt in the sentence it's used
/// in: the sentence big, the word picked out, and the word and its meaning
/// underneath.
struct SentenceWords: View {
    let words: [CollectionWord]

    var body: some View {
        VStack(spacing: Spacing.grid) {
            ForEach(words) { word in
                SentenceCard(word: word)
            }
        }
    }
}

private struct SentenceCard: View {
    let word: CollectionWord

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .top, spacing: 12) {
                Text(word.highlightedExample)
                    .font(.title3.weight(.medium))
                    .frame(maxWidth: .infinity, alignment: .leading)
                SpeakButton(text: word.example)
            }
            Text(verbatim: word.exampleMeaning)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            HStack(spacing: 8) {
                ArticleWord(word: word, font: .subheadline.weight(.semibold))
                Text(verbatim: "·")
                    .foregroundStyle(.tertiary)
                Text(verbatim: word.meaning)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 6)
            .background(.accentFill.opacity(0.12), in: .capsule)
        }
        .padding(Spacing.cardLarge)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.card, style: .continuous))
    }
}
