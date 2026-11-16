//
//  PiledStacks.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

// Designs 2 and 3 for the word collections (#386): one pile to swipe
// through, and cards tucked into each other like a wallet.

/// Design 2: the collections as one pile. The top card is big; the next two
/// peek out underneath. Swipe sideways to put the top card at the back.
struct SwipeDeckStack: View {
    let deck: CollectionDeck

    @State private var top = 0
    @State private var drag: CGFloat = 0

    private var count: Int { deck.collections.count }

    var body: some View {
        VStack(spacing: 14) {
            ZStack(alignment: .top) {
                ForEach(visible) { slot in
                    DeckCard(collection: slot.collection, deck: deck)
                        .scaleEffect(1 - 0.06 * CGFloat(slot.depth), anchor: .bottom)
                        .offset(y: 14 * CGFloat(slot.depth))
                        .offset(x: slot.depth == 0 ? drag : 0)
                        .rotationEffect(.degrees(slot.depth == 0 ? Double(drag) / 25 : 0), anchor: .bottom)
                        .zIndex(Double(-slot.depth))
                        .allowsHitTesting(slot.depth == 0)
                        .accessibilityHidden(slot.depth != 0)
                }
            }
            .padding(.bottom, 28)
            .simultaneousGesture(swipe)
            .accessibilityAdjustableAction { direction in
                switch direction {
                case .increment: move(by: 1)
                case .decrement: move(by: -1)
                @unknown default: break
                }
            }
            PageDots(count: count, current: top)
        }
        .sensoryFeedback(.selection, trigger: top)
    }

    /// The top card and the two under it.
    private var visible: [DeckSlot] {
        guard !deck.collections.isEmpty else { return [] }
        return (0..<min(3, count)).map { DeckSlot(depth: $0, collection: deck.collections[(top + $0) % count]) }
    }

    private var swipe: some Gesture {
        DragGesture(minimumDistance: 16)
            .onChanged { value in
                guard abs(value.translation.width) > abs(value.translation.height) else { return }
                drag = value.translation.width
            }
            .onEnded { _ in
                withAnimation(.snappy) {
                    if abs(drag) > 80 { move(by: drag < 0 ? 1 : -1) }
                    drag = 0
                }
            }
    }

    private func move(by step: Int) {
        guard !deck.collections.isEmpty else { return }
        withAnimation(.snappy) { top = (top + step + count) % count }
    }
}

private struct DeckSlot: Identifiable {
    let depth: Int
    let collection: WordCollection
    var id: String { collection.id }
}

private struct DeckCard: View {
    let collection: WordCollection
    let deck: CollectionDeck

    @ScaledMetric(relativeTo: .title2) private var height: CGFloat = 196

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Button { deck.open(collection) } label: {
                HStack(alignment: .bottom, spacing: 12) {
                    VStack(alignment: .leading, spacing: 4) {
                        CollectionLevelBadge(level: collection.level)
                        Spacer(minLength: 16)
                        Text(verbatim: collection.title)
                            .font(.title2.weight(.bold))
                            .lineLimit(2)
                        Text(collection.subtitle)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text("^[\(collection.words.count) word](inflect: true)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    CollectionArtwork(collection: collection, size: 96)
                }
                .multilineTextAlignment(.leading)
                .padding(Spacing.cardLarge)
                .frame(maxWidth: .infinity, minHeight: height)
                .background { PileSurface(shade: 1) }
                .contentShape(.rect(cornerRadius: Radius.card, style: .continuous))
                .matchedTransitionSource(id: collection.id, in: deck.zoom)
            }
            .buttonStyle(.card)
            AddCollectionButton(isAdded: deck.isAdded(collection)) { deck.toggle(collection) }
                .padding(14)
        }
    }
}

/// Small dots under the pile: which card is on top.
private struct PageDots: View {
    let count: Int
    let current: Int

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<count, id: \.self) { index in
                Circle()
                    .fill(index == current ? Color.accent : Color.controlFill)
                    .frame(width: 7, height: 7)
            }
        }
        .frame(maxWidth: .infinity)
        .accessibilityHidden(true)
    }
}

/// Design 3: cards tucked into each other like a wallet. Each shows its top
/// edge; tap one to pull it out, tap it again to open it.
struct WalletStack: View {
    let deck: CollectionDeck

    @State private var selected: String?
    @ScaledMetric(relativeTo: .headline) private var peek: CGFloat = 78
    @ScaledMetric(relativeTo: .headline) private var full: CGFloat = 196

    var body: some View {
        let open = selected ?? deck.collections.last?.id
        VStack(spacing: 0) {
            ForEach(Array(deck.collections.enumerated()), id: \.element.id) { index, collection in
                let isOpen = collection.id == open
                let isLast = index == deck.collections.count - 1
                WalletCard(collection: collection, deck: deck, shade: index) {
                    if isOpen {
                        deck.open(collection)
                    } else {
                        withAnimation(.snappy) { selected = collection.id }
                    }
                }
                .frame(height: full)
                // Only the top edge shows, unless it is pulled out or last.
                .frame(height: isLast ? full : (isOpen ? full + 10 : peek), alignment: .top)
            }
        }
        .sensoryFeedback(.selection, trigger: selected)
    }
}

private struct WalletCard: View {
    let collection: WordCollection
    let deck: CollectionDeck
    let shade: Int
    let action: () -> Void

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Button(action: action) {
                VStack(alignment: .leading, spacing: 14) {
                    HStack(spacing: 12) {
                        CollectionArtwork(collection: collection, size: 46)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(verbatim: collection.title)
                                .font(.headline)
                                .lineLimit(1)
                            CollectionMeta(collection: collection)
                        }
                        Spacer(minLength: 52)
                    }
                    Text(collection.subtitle)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    FlowLayout(spacing: 6) {
                        ForEach(collection.words.prefix(4)) { word in
                            Text(verbatim: word.displayWord)
                                .font(.caption.weight(.medium))
                                .lineLimit(1)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(.accentFill.opacity(0.16), in: .capsule)
                        }
                    }
                }
                .multilineTextAlignment(.leading)
                .padding(Spacing.card)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .background { PileSurface(shade: shade) }
                .contentShape(.rect(cornerRadius: Radius.card, style: .continuous))
                .matchedTransitionSource(id: collection.id, in: deck.zoom)
            }
            .buttonStyle(.card)
            AddCollectionButton(isAdded: deck.isAdded(collection)) { deck.toggle(collection) }
                .padding(12)
        }
        .shadow(color: .black.opacity(0.3), radius: 10, y: -3)
    }
}

/// A solid card for piles, so the cards underneath don't show through: the
/// dark surface with the theme's light from one corner and a thin edge.
private struct PileSurface: View {
    let shade: Int

    var body: some View {
        let shape = RoundedRectangle(cornerRadius: Radius.card, style: .continuous)
        shape
            .fill(.surface)
            .overlay {
                shape.fill(LinearGradient(colors: [Color.accentFill.opacity(0.16 + 0.06 * Double(shade % 4)), .clear],
                                          startPoint: .topTrailing, endPoint: .bottomLeading))
            }
            .overlay {
                shape.strokeBorder(.white.opacity(0.08), lineWidth: 1)
            }
    }
}
