//
//  WordCollectionSheet.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftData
import SwiftUI

/// A collection's words, opened from its card: the topic at the top, the big
/// button to add them to Memory, and the words with a sentence from real life.
///
/// The four ways to show the words sit behind a temporary ‹ n / 4 › switcher
/// until Ibrahim picks one (#386); the others and the switcher go before merging.
struct WordCollectionSheet: View {
    let collection: WordCollection

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Query(filter: #Predicate<MemoryItem> { $0.sourceRaw == "collection" }) private var collectionWords: [MemoryItem]
    @AppStorage("learn.collectionWordsLayout") private var layout = CollectionWordsLayout.flashcards
    @State private var toggles = 0

    private var isAdded: Bool {
        CollectionMemory.addedTitles(collectionWords).contains(collection.title)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: Spacing.section) {
                    header
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Text("Words")
                                .textRole(.sectionHeader)
                            Spacer()
                            WordsLayoutSwitcher(layout: $layout)
                        }
                        .padding(.horizontal, 4)
                        words
                    }
                }
                .padding(.horizontal, Spacing.screen)
                .padding(.top, 8)
                .padding(.bottom, 24)
            }
            .scrollIndicators(.hidden)
            .scrollEdgeEffectStyle(.soft, for: .all)
            .fontDesign(.rounded)
            .skyBackground()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close", systemImage: "xmark") { dismiss() }
                }
            }
        }
        .sensoryFeedback(.impact(weight: .medium), trigger: toggles)
    }

    @ViewBuilder private var words: some View {
        switch layout {
        case .flashcards: FlashcardWords(words: collection.words)
        case .tiles: WordTiles(words: collection.words)
        case .grouped: GroupedWords(words: collection.words)
        case .sentences: SentenceWords(words: collection.words)
        }
    }

    private var header: some View {
        VStack(spacing: 18) {
            HStack(alignment: .center, spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(verbatim: collection.title)
                        .font(.title2.weight(.bold))
                    Text(collection.subtitle)
                        .font(.title3)
                        .foregroundStyle(.secondary)
                    CollectionMeta(collection: collection)
                        .padding(.top, 4)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityElement(children: .combine)
                CollectionArtwork(collection: collection, size: 88)
            }
            Button(action: toggle) {
                if isAdded {
                    Label("Remove from Memory", systemImage: "checkmark")
                } else {
                    Label("Save to Memory", systemImage: "plus")
                }
            }
            .buttonStyle(.primary)
        }
        .padding(Spacing.cardLarge)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }

    private func toggle() {
        toggles += 1
        if isAdded {
            try? CollectionMemory.remove(collection, in: context)
        } else {
            try? CollectionMemory.add(collection, in: context)
        }
    }
}

#Preview {
    WordCollectionSheet(collection: WordCollections.doctor)
        .modelContainer(AlltagStore.preview)
}
