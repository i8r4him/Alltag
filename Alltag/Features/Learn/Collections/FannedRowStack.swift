//
//  FannedRowStack.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// The collections as square glass cards in a sideways row, each with two
/// cards fanned out behind it, so every collection reads as a stack.
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
