//
//  CoverPage.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Page design 1, "Cover": a big picture of the place on top, the button to
/// save, the flashcards to practise, and every word in a short list.
struct CoverPage: View {
    let page: CollectionPage

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.section) {
                CoverArt(collection: page.collection)
                SaveCollectionButton(page: page)
                LearnSection(title: "Practise") {
                    FlashcardWords(words: page.words)
                }
                LearnSection(title: "All words") {
                    VStack(spacing: 0) {
                        ForEach(Array(page.words.enumerated()), id: \.element.id) { index, word in
                            if index > 0 { Divider().padding(.leading, Spacing.card) }
                            HStack(spacing: 10) {
                                ArticleWord(word: word)
                                Spacer(minLength: 8)
                                Text(verbatim: word.meaning)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .lineLimit(1)
                                if page.isSaved(word) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundStyle(.accent)
                                        .accessibilityLabel(Text("Saved to Memory"))
                                }
                            }
                            .padding(.horizontal, Spacing.card)
                            .padding(.vertical, 13)
                        }
                    }
                    .glassEffect(.regular, in: .rect(cornerRadius: Radius.card, style: .continuous))
                }
            }
            .padding(.horizontal, Spacing.screen)
            .padding(.bottom, 24)
        }
        .scrollIndicators(.hidden)
        .scrollEdgeEffectStyle(.soft, for: .all)
    }
}

/// The cover: the theme's two lights, the topic's symbol large in a corner,
/// and the name at the bottom.
private struct CoverArt: View {
    let collection: WordCollection

    @ScaledMetric(relativeTo: .largeTitle) private var height: CGFloat = 250

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            LinearGradient(colors: [Color.accentFill, AppTheme.shared.palette.deep],
                           startPoint: .topTrailing, endPoint: .bottomLeading)
            RadialGradient(colors: [.white.opacity(0.35), .clear],
                           center: UnitPoint(x: 0.8, y: 0.15), startRadius: 0, endRadius: 180)
            Image(systemName: collection.systemImage)
                .font(.system(size: 130, weight: .light))
                .foregroundStyle(.white.opacity(0.28))
                .rotationEffect(.degrees(-12))
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .offset(x: 18, y: -6)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 6) {
                CollectionLevelBadge(level: collection.level)
                Text(verbatim: collection.title)
                    .font(.largeTitle.weight(.bold))
                    .lineLimit(2)
                    .minimumScaleFactor(0.7)
                Text(collection.subtitle)
                    .font(.title3)
                    .opacity(0.85)
                Text("^[\(collection.words.count) word](inflect: true)")
                    .font(.subheadline.weight(.semibold))
                    .opacity(0.75)
            }
            .foregroundStyle(.white)
            .padding(Spacing.cardLarge)
        }
        .frame(height: height)
        .clipShape(.rect(cornerRadius: Radius.hero, style: .continuous))
        .accessibilityElement(children: .combine)
    }
}
