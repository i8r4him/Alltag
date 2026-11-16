//
//  WordCollectionSheet.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftData
import SwiftUI

/// A collection's words, opened from its card: the topic at the top, the big
/// button to add them to Memory, and each word with a sentence from real life.
struct WordCollectionSheet: View {
    let collection: WordCollection

    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Query(filter: #Predicate<MemoryItem> { $0.sourceRaw == "collection" }) private var collectionWords: [MemoryItem]
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
                        Text("Words")
                            .textRole(.sectionHeader)
                            .padding(.horizontal, 4)
                        VStack(spacing: 0) {
                            ForEach(Array(collection.words.enumerated()), id: \.element.id) { index, word in
                                if index > 0 { Divider().padding(.leading, Spacing.card) }
                                CollectionWordRow(word: word)
                            }
                        }
                        .glassEffect(.regular, in: .rect(cornerRadius: Radius.card, style: .continuous))
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

/// A word with its article, its meaning, and the sentence it's used in.
private struct CollectionWordRow: View {
    let word: CollectionWord

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .firstTextBaseline) {
                Text(verbatim: word.displayWord)
                    .font(.headline)
                Spacer(minLength: 8)
                Text(verbatim: word.meaning)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.trailing)
            }
            Text(verbatim: word.example)
                .font(.subheadline)
                .foregroundStyle(.accent)
            Text(verbatim: word.exampleMeaning)
                .font(.footnote)
                .foregroundStyle(.tertiary)
        }
        .padding(Spacing.card)
        .frame(maxWidth: .infinity, alignment: .leading)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    WordCollectionSheet(collection: WordCollections.doctor)
        .modelContainer(AlltagStore.preview)
}
