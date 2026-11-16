//
//  ScrollingStacks.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

// Designs 1, 4 and 5 for the word collections (#386): a sideways row of
// fanned stacks, a carousel, and a grid of index-card stacks.

/// Design 1: square glass cards in a sideways row, each with two cards fanned
/// out behind it, so every collection reads as a stack.
struct FannedRowStack: View {
    let deck: CollectionDeck

    @ScaledMetric(relativeTo: .headline) private var side: CGFloat = 172

    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 20) {
                ForEach(Array(deck.collections.enumerated()), id: \.element.id) { index, collection in
                    FannedCard(collection: collection, deck: deck, tilt: index.isMultiple(of: 2) ? 1 : -1)
                        .frame(width: side, height: side)
                }
            }
            .padding(.vertical, 16)
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
        .contentMargins(.horizontal, Spacing.screen, for: .scrollContent)
        .scrollIndicators(.hidden)
        .scrollEdgeEffectStyle(.soft, for: .all)
        .padding(.horizontal, -Spacing.screen)
    }
}

private struct FannedCard: View {
    let collection: WordCollection
    let deck: CollectionDeck
    /// 1 or -1, so neighbouring stacks fan out the other way.
    let tilt: Double

    var body: some View {
        ZStack(alignment: .topTrailing) {
            StackLayers(angles: [-4 * tilt, 3 * tilt])
            Button { deck.open(collection) } label: {
                VStack(alignment: .leading, spacing: 6) {
                    CollectionArtwork(collection: collection, size: 52)
                    Spacer(minLength: 8)
                    Text(verbatim: collection.title)
                        .font(.headline)
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                    CollectionMeta(collection: collection)
                }
                .multilineTextAlignment(.leading)
                .padding(Spacing.card)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .glassEffect(.regular, in: .rect(cornerRadius: Radius.card, style: .continuous))
                .contentShape(.rect(cornerRadius: Radius.card, style: .continuous))
                .matchedTransitionSource(id: collection.id, in: deck.zoom)
            }
            .buttonStyle(.tile)
            AddCollectionButton(isAdded: deck.isAdded(collection)) { deck.toggle(collection) }
                .padding(10)
        }
    }
}

/// Design 4: one big card in the middle and its neighbours turned away, like
/// flicking through a box of cards. Two cards peek out under each one.
struct CarouselStack: View {
    let deck: CollectionDeck

    @ScaledMetric(relativeTo: .title2) private var height: CGFloat = 232

    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 14) {
                ForEach(deck.collections) { collection in
                    CarouselCard(collection: collection, deck: deck)
                        .frame(height: height)
                        .containerRelativeFrame(.horizontal)
                        .scrollTransition(axis: .horizontal) { content, phase in
                            content
                                .scaleEffect(phase.isIdentity ? 1 : 0.88)
                                .rotation3DEffect(.degrees(phase.value * -16), axis: (x: 0, y: 1, z: 0))
                                .opacity(phase.isIdentity ? 1 : 0.65)
                        }
                }
            }
            .padding(.top, 4)
            .padding(.bottom, 20)
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
        .safeAreaPadding(.horizontal, 44)
        .scrollIndicators(.hidden)
        .scrollEdgeEffectStyle(.soft, for: .all)
        .padding(.horizontal, -Spacing.screen)
    }
}

private struct CarouselCard: View {
    let collection: WordCollection
    let deck: CollectionDeck

    var body: some View {
        ZStack(alignment: .topTrailing) {
            // The cards under it: narrower, a little lower.
            ZStack(alignment: .bottom) {
                ForEach([2, 1], id: \.self) { depth in
                    RoundedRectangle(cornerRadius: Radius.card, style: .continuous)
                        .fill(.white.opacity(0.04 + 0.02 * Double(2 - depth)))
                        .overlay {
                            RoundedRectangle(cornerRadius: Radius.card, style: .continuous)
                                .strokeBorder(.white.opacity(0.07), lineWidth: 1)
                        }
                        .padding(.horizontal, 14 * CGFloat(depth))
                        .offset(y: 9 * CGFloat(depth))
                }
            }
            .accessibilityHidden(true)

            Button { deck.open(collection) } label: {
                VStack(alignment: .leading, spacing: 4) {
                    CollectionArtwork(collection: collection, size: 72)
                    Spacer(minLength: 10)
                    Text(verbatim: collection.title)
                        .font(.title2.weight(.bold))
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                    Text(collection.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    CollectionMeta(collection: collection)
                        .padding(.top, 4)
                }
                .multilineTextAlignment(.leading)
                .padding(Spacing.cardLarge)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
                .glassEffect(.regular, in: .rect(cornerRadius: Radius.card, style: .continuous))
                .contentShape(.rect(cornerRadius: Radius.card, style: .continuous))
                .matchedTransitionSource(id: collection.id, in: deck.zoom)
            }
            .buttonStyle(.card)
            AddCollectionButton(isAdded: deck.isAdded(collection)) { deck.toggle(collection) }
                .padding(14)
        }
    }
}

/// Design 5: two columns of small stacks of index cards. The top card shows
/// the collection's first word, so you see what's inside before opening it.
struct IndexCardGrid: View {
    let deck: CollectionDeck

    private let columns = [GridItem(.flexible(), spacing: Spacing.grid),
                           GridItem(.flexible(), spacing: Spacing.grid)]

    var body: some View {
        LazyVGrid(columns: columns, alignment: .leading, spacing: 22) {
            ForEach(deck.collections) { collection in
                IndexCardTile(collection: collection, deck: deck)
            }
        }
        .padding(.top, 6)
    }
}

private struct IndexCardTile: View {
    let collection: WordCollection
    let deck: CollectionDeck

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Button { deck.open(collection) } label: {
                VStack(alignment: .leading, spacing: 12) {
                    IndexCards(collection: collection)
                        .matchedTransitionSource(id: collection.id, in: deck.zoom)
                    VStack(alignment: .leading, spacing: 3) {
                        Text(verbatim: collection.title)
                            .font(.headline)
                            .lineLimit(2)
                        CollectionMeta(collection: collection)
                    }
                    .padding(.horizontal, 4)
                }
                .multilineTextAlignment(.leading)
                .contentShape(.rect)
            }
            .buttonStyle(.tile)
            AddCollectionButton(isAdded: deck.isAdded(collection)) { deck.toggle(collection) }
                .padding(6)
        }
    }
}

/// The little stack: two cards fanned behind, the first word on top.
private struct IndexCards: View {
    let collection: WordCollection

    @ScaledMetric(relativeTo: .headline) private var height: CGFloat = 124

    var body: some View {
        ZStack {
            StackLayers(radius: Radius.option, angles: [-6, 5])
            VStack(alignment: .leading, spacing: 2) {
                Image(systemName: collection.systemImage)
                    .font(.title3)
                    .foregroundStyle(.accent)
                    .accessibilityHidden(true)
                Spacer(minLength: 6)
                if let first = collection.words.first {
                    Text(verbatim: first.displayWord)
                        .font(.headline)
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                    Text(verbatim: first.meaning)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
            .padding(14)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .glassEffect(.regular, in: .rect(cornerRadius: Radius.option, style: .continuous))
        }
        .frame(height: height)
    }
}
