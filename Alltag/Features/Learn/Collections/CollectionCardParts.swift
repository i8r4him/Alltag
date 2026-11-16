//
//  CollectionCardParts.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// What every stack design needs: the collections in order, which are in
/// Memory, and what a tap on a card or its + does.
struct CollectionDeck {
    let collections: [WordCollection]
    /// Titles of the collections whose words are in Memory.
    let added: Set<String>
    /// The sheet zooms out of the card it was opened from.
    let zoom: Namespace.ID
    let open: (WordCollection) -> Void
    let toggle: (WordCollection) -> Void

    func isAdded(_ collection: WordCollection) -> Bool {
        added.contains(collection.title)
    }
}

/// The + in a card's corner: a plus when the collection isn't in Memory, a
/// tick when it is. Tapping the tick takes the words out again.
struct AddCollectionButton: View {
    let isAdded: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: isAdded ? "checkmark" : "plus")
                .font(.headline.weight(.bold))
                .foregroundStyle(isAdded ? Color.accent : Color.primary)
                .contentTransition(.symbolEffect(.replace))
                .frame(width: 44, height: 44)
        }
        .buttonStyle(.plain)
        .glassEffect(.regular.interactive(), in: .circle)
        .accessibilityLabel(isAdded ? Text("Remove from Memory") : Text("Save to Memory"))
    }
}

/// The level as a small tinted capsule, e.g. "A2".
struct CollectionLevelBadge: View {
    let level: Level

    var body: some View {
        Text(verbatim: level.title)
            .font(.caption.weight(.bold))
            .foregroundStyle(.accent)
            .padding(.horizontal, 7)
            .padding(.vertical, 2)
            .background(.accentFill.opacity(0.18), in: .capsule)
    }
}

/// "15 words" and the level, the footer of every card.
struct CollectionMeta: View {
    let collection: WordCollection

    var body: some View {
        HStack(spacing: 6) {
            Text("^[\(collection.words.count) word](inflect: true)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            CollectionLevelBadge(level: collection.level)
        }
    }
}

/// The collection's symbol on the theme's gradient, as on Today's cards.
struct CollectionArtwork: View {
    let collection: WordCollection
    var size: CGFloat = 56

    var body: some View {
        ScenarioArtwork(systemImage: collection.systemImage, symbolSize: size * 0.46, cornerRadius: size * 0.3)
            .frame(width: size, height: size)
    }
}

/// Paper-like cards fanned out behind a card, so it reads as a stack.
struct StackLayers: View {
    var radius: CGFloat = Radius.card
    var angles: [Double] = [-5, 4]

    var body: some View {
        ZStack {
            ForEach(Array(angles.enumerated()), id: \.offset) { index, angle in
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .fill(.white.opacity(0.05 + 0.02 * Double(index)))
                    .overlay {
                        RoundedRectangle(cornerRadius: radius, style: .continuous)
                            .strokeBorder(.white.opacity(0.08), lineWidth: 1)
                    }
                    .rotationEffect(.degrees(angle))
            }
        }
        .accessibilityHidden(true)
    }
}
