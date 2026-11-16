//
//  GroupedWords.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Layout 3: the nouns on one card and the verbs and other words on another.
/// Each row shows the word and its meaning; tap it to open the sentence.
struct GroupedWords: View {
    let words: [CollectionWord]

    @State private var open: String?

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.section) {
            group(title: "Nouns", words: words.filter(\.isNoun))
            group(title: "Verbs and other words", words: words.filter { !$0.isNoun })
        }
        .sensoryFeedback(.impact(weight: .medium), trigger: open)
    }

    @ViewBuilder
    private func group(title: LocalizedStringResource, words: [CollectionWord]) -> some View {
        if !words.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                HStack(alignment: .firstTextBaseline) {
                    Text(title)
                        .textRole(.sectionHeader)
                    Spacer()
                    Text(verbatim: "\(words.count)")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 4)
                VStack(spacing: 0) {
                    ForEach(Array(words.enumerated()), id: \.element.id) { index, word in
                        if index > 0 { Divider().padding(.leading, Spacing.card) }
                        GroupedWordRow(word: word, isOpen: open == word.id) {
                            withAnimation(.smooth) { open = open == word.id ? nil : word.id }
                        }
                    }
                }
                .glassEffect(.regular, in: .rect(cornerRadius: Radius.card, style: .continuous))
            }
        }
    }
}

private struct GroupedWordRow: View {
    let word: CollectionWord
    let isOpen: Bool
    let action: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Button(action: action) {
                HStack(spacing: 10) {
                    ArticleWord(word: word)
                    Spacer(minLength: 8)
                    Text(verbatim: word.meaning)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                    Image(systemName: "chevron.down")
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(.tertiary)
                        .rotationEffect(.degrees(isOpen ? 180 : 0))
                        .accessibilityHidden(true)
                }
                .contentShape(.rect)
            }
            .buttonStyle(.plain)
            if isOpen {
                HStack(alignment: .top, spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(word.highlightedExample)
                            .font(.subheadline)
                        Text(verbatim: word.exampleMeaning)
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    SpeakButton(text: word.example)
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(.horizontal, Spacing.card)
        .padding(.vertical, 14)
    }
}
