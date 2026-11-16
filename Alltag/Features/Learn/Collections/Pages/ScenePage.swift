//
//  ScenePage.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Page design 2, "A scene": the words as things you'd hear and say at the
/// place, as chat bubbles taking turns. Tap a bubble for the English and the
/// word it teaches. The button to save stays at the bottom.
struct ScenePage: View {
    let page: CollectionPage

    @State private var open: Set<String> = []

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                HStack(spacing: 14) {
                    CollectionArtwork(collection: page.collection, size: 64)
                    VStack(alignment: .leading, spacing: 3) {
                        Text(verbatim: page.collection.title)
                            .font(.title2.weight(.bold))
                        Text(page.collection.subtitle)
                            .foregroundStyle(.secondary)
                        CollectionMeta(collection: page.collection)
                    }
                }
                .accessibilityElement(children: .combine)
                Text("Things you hear and say there. Tap one for the English.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                ForEach(Array(page.words.enumerated()), id: \.element.id) { index, word in
                    SceneBubble(word: word, isMine: !index.isMultiple(of: 2), isOpen: open.contains(word.id),
                                isSaved: page.isSaved(word)) {
                        withAnimation(.smooth) { open.formSymmetricDifference([word.id]) }
                    }
                }
            }
            .padding(.horizontal, Spacing.screen)
            .padding(.bottom, 24)
        }
        .scrollIndicators(.hidden)
        .scrollEdgeEffectStyle(.soft, for: .all)
        .safeAreaInset(edge: .bottom) {
            SaveCollectionButton(page: page)
                .padding(.horizontal, Spacing.screen)
                .padding(.bottom, 8)
        }
        .sensoryFeedback(.impact(weight: .medium), trigger: open)
    }
}

private struct SceneBubble: View {
    let word: CollectionWord
    /// The learner's turn: on the right, in the theme colour.
    let isMine: Bool
    let isOpen: Bool
    let isSaved: Bool
    let action: () -> Void

    var body: some View {
        HStack(alignment: .bottom, spacing: 8) {
            if isMine { Spacer(minLength: 40) }
            VStack(alignment: isMine ? .trailing : .leading, spacing: 8) {
                Button(action: action) {
                    Text(word.highlightedExample)
                        .font(.body)
                        .multilineTextAlignment(.leading)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background {
                            if isMine {
                                RoundedRectangle(cornerRadius: 22, style: .continuous)
                                    .fill(Color.accentFill.opacity(0.22))
                            }
                        }
                        .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 22, style: .continuous))
                }
                .buttonStyle(.plain)
                if isOpen {
                    VStack(alignment: isMine ? .trailing : .leading, spacing: 6) {
                        Text(verbatim: word.exampleMeaning)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        HStack(spacing: 8) {
                            ArticleWord(word: word, font: .subheadline.weight(.semibold))
                            Text(verbatim: "· \(word.meaning)")
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                            if isSaved {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.accent)
                                    .accessibilityLabel(Text("Saved to Memory"))
                            }
                        }
                        SpeakButton(text: word.example)
                    }
                    .padding(.horizontal, 6)
                    .transition(.opacity.combined(with: .scale(scale: 0.95, anchor: isMine ? .topTrailing : .topLeading)))
                }
            }
            if !isMine { Spacer(minLength: 40) }
        }
    }
}
