//
//  WordCollectionSheet.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftData
import SwiftUI

/// One collection's page, opened from its card and zooming out of it.
///
/// Five page designs sit behind a temporary ‹ n / 5 › switcher in the toolbar
/// until Ibrahim picks one (#386); the others and the switcher go before merging.
struct WordCollectionSheet: View {
    let collection: WordCollection

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Query(filter: #Predicate<MemoryItem> { $0.sourceRaw == "collection" }) private var collectionWords: [MemoryItem]
    @AppStorage("learn.collectionPageDesign") private var design = CollectionPageDesign.cover
    @State private var saves = 0

    var body: some View {
        let page = CollectionPage(
            collection: collection,
            saved: Set(collectionWords.filter { $0.sourceDetail == collection.title }.map(\.displayWord)),
            toggle: toggle, save: save
        )
        NavigationStack {
            Group {
                switch design {
                case .cover: CoverPage(page: page)
                case .scene: ScenePage(page: page)
                case .path: PathPage(page: page)
                case .dictionary: DictionaryPage(page: page)
                case .sort: SortPage(page: page)
                }
            }
            .fontDesign(.rounded)
            .skyBackground()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    PageDesignSwitcher(design: $design)
                }
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

    private func save(_ words: [CollectionWord]) {
        saves += 1
        try? CollectionMemory.add(words, of: collection, in: context)
    }
}

/// What every page design gets: the collection, which of its words are in
/// Memory, and the two ways to save them.
struct CollectionPage {
    let collection: WordCollection
    /// The collection's words in Memory, by "die Praxis".
    let saved: Set<String>
    /// Saves all the words, or takes them all out again.
    let toggle: () -> Void
    /// Saves only these words.
    let save: ([CollectionWord]) -> Void

    var isAdded: Bool { !saved.isEmpty }
    var words: [CollectionWord] { collection.words }

    func isSaved(_ word: CollectionWord) -> Bool {
        saved.contains(word.displayWord)
    }
}

/// The five page designs to choose from (#386). Temporary.
enum CollectionPageDesign: Int, CaseIterable {
    case cover, scene, path, dictionary, sort
}

/// The temporary ‹ n / 5 › switcher in the page's toolbar.
private struct PageDesignSwitcher: View {
    @Binding var design: CollectionPageDesign

    var body: some View {
        let all = CollectionPageDesign.allCases
        HStack(spacing: 10) {
            Button("Previous design", systemImage: "chevron.left") {
                design = all[(design.rawValue + all.count - 1) % all.count]
            }
            Text(verbatim: "\(design.rawValue + 1) / \(all.count)")
                .font(.subheadline.weight(.semibold).monospacedDigit())
            Button("Next design", systemImage: "chevron.right") {
                design = all[(design.rawValue + 1) % all.count]
            }
        }
        .labelStyle(.iconOnly)
        .padding(.horizontal, 6)
        .sensoryFeedback(.selection, trigger: design)
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
