//
//  WordCollectionsSection.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftData
import SwiftUI

/// "Word collections" on Learn: ready-made words by everyday topic and level,
/// shown as a sideways row of stacked cards. A card opens its words; its +
/// adds them to Memory.
struct WordCollectionsSection: View {
    let level: Level
    @Binding var notice: ToastMessage?

    @Environment(\.modelContext) private var context
    @Environment(AppState.self) private var appState
    /// The words collections added to Memory, to show which cards are in it.
    @Query(filter: #Predicate<MemoryItem> { $0.sourceRaw == "collection" }) private var collectionWords: [MemoryItem]
    @State private var opened: WordCollection?
    @State private var toggles = 0
    @State private var opens = 0
    @Namespace private var zoom

    var body: some View {
        let deck = CollectionDeck(collections: WordCollections.ordered(for: level),
                                  added: CollectionMemory.addedTitles(collectionWords),
                                  zoom: zoom, open: { opened = $0 }, toggle: toggle)
        VStack(alignment: .leading, spacing: 12) {
            Button {
                opens += 1
                appState.open(.collections)
            } label: {
                HStack(spacing: 6) {
                    Text("Word collections")
                        .textRole(.sectionHeader)
                    Image(systemName: "chevron.right")
                        .font(.headline.weight(.bold))
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 4)
                .contentShape(.rect)
            }
            .buttonStyle(.plain)
            .accessibilityHint(Text("Shows all collections"))
            FannedRowStack(deck: deck)
        }
        .fontDesign(.rounded)
        .sheet(item: $opened) { collection in
            WordCollectionSheet(collection: collection)
                .navigationTransition(.zoom(sourceID: collection.id, in: zoom))
        }
        .sensoryFeedback(.impact(weight: .medium), trigger: opened?.id) { _, id in id != nil }
        .sensoryFeedback(.impact(weight: .medium), trigger: toggles)
        .sensoryFeedback(.impact(weight: .medium), trigger: opens)
    }

    private func toggle(_ collection: WordCollection) {
        toggles += 1
        notice = CollectionMemory.toggle(collection, in: context)
    }
}
