//
//  WordCollectionSheet.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftData
import SwiftUI

/// One collection's page, opened from its card and zooming out of it: the
/// words as a scene of chat bubbles (`ScenePage`).
struct WordCollectionSheet: View {
    let collection: WordCollection

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Query(filter: #Predicate<MemoryItem> { $0.sourceRaw == "collection" }) private var collectionWords: [MemoryItem]
    @State private var saves = 0

    var body: some View {
        let page = CollectionPage(
            collection: collection,
            saved: Set(collectionWords.filter { $0.sourceDetail == collection.title }.map(\.displayWord)),
            toggle: toggle
        )
        NavigationStack {
            ScenePage(page: page)
            .fontDesign(.rounded)
            .skyBackground()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close", systemImage: "xmark") { dismiss() }
                }
            }
        }
        .sensoryFeedback(.impact(weight: .medium), trigger: saves)
    }

    /// Saves all the words, or takes them out of Memory again.
    private func toggle() {
        saves += 1
        if collectionWords.contains(where: { $0.sourceDetail == collection.title }) {
            try? CollectionMemory.remove(collection, in: context)
        } else {
            try? CollectionMemory.add(collection, in: context)
        }
    }
}

/// What the page shows and does: the collection, which of its words are in
/// Memory, and saving or removing them.
struct CollectionPage {
    let collection: WordCollection
    /// The collection's words in Memory, by "die Praxis".
    let saved: Set<String>
    /// Saves all the words, or takes them all out again.
    let toggle: () -> Void

    var isAdded: Bool { !saved.isEmpty }
    var words: [CollectionWord] { collection.words }

    func isSaved(_ word: CollectionWord) -> Bool {
        saved.contains(word.displayWord)
    }
}

/// The big button that saves every word to Memory, or takes them out again.
struct SaveCollectionButton: View {
    let page: CollectionPage

    var body: some View {
        Button(action: page.toggle) {
            if page.isAdded {
                Label("Remove from Memory", systemImage: "checkmark")
            } else {
                Label("Save to Memory", systemImage: "plus")
            }
        }
        .buttonStyle(.primary)
    }
}

#Preview {
    WordCollectionSheet(collection: WordCollections.doctor)
        .modelContainer(AlltagStore.preview)
}
