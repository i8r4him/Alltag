//
//  WordCollectionsSection.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftData
import SwiftUI

/// "Word collections" on Learn: ready-made words by everyday topic and level,
/// shown as a stack of cards. A card opens its words; its + adds them to Memory.
///
/// The five stack designs sit behind a temporary ‹ n / 5 › switcher until
/// Ibrahim picks one (#386); the others and the switcher go before merging.
struct WordCollectionsSection: View {
    let level: Level
    @Binding var notice: ToastMessage?

    @Environment(\.modelContext) private var context
    /// The words collections added to Memory, to show which cards are in it.
    @Query(filter: #Predicate<MemoryItem> { $0.sourceRaw == "collection" }) private var collectionWords: [MemoryItem]
    @AppStorage("learn.collectionsDesign") private var design = CollectionStackDesign.fanned
    @State private var opened: WordCollection?
    @State private var toggles = 0
    @Namespace private var zoom

    var body: some View {
        let deck = CollectionDeck(collections: WordCollections.ordered(for: level),
                                  added: CollectionMemory.addedTitles(collectionWords),
                                  zoom: zoom, open: { opened = $0 }, toggle: toggle)
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .center) {
                Text("Word collections")
                    .textRole(.sectionHeader)
                Spacer()
                DesignSwitcher(design: $design)
            }
            .padding(.horizontal, 4)

            Group {
                switch design {
                case .fanned: FannedRowStack(deck: deck)
                case .deck: SwipeDeckStack(deck: deck)
                case .wallet: WalletStack(deck: deck)
                case .carousel: CarouselStack(deck: deck)
                case .grid: IndexCardGrid(deck: deck)
                }
            }
            .transition(.opacity)
        }
        .fontDesign(.rounded)
        .animation(.smooth, value: design)
        .sheet(item: $opened) { collection in
            WordCollectionSheet(collection: collection)
                .navigationTransition(.zoom(sourceID: collection.id, in: zoom))
        }
        .sensoryFeedback(.impact(weight: .medium), trigger: opened?.id) { _, id in id != nil }
        .sensoryFeedback(.impact(weight: .medium), trigger: toggles)
    }

    private func toggle(_ collection: WordCollection) {
        toggles += 1
        do {
            if try CollectionMemory.isAdded(collection, in: context) {
                try CollectionMemory.remove(collection, in: context)
                notice = ToastMessage(text: "Removed from Memory", systemImage: "bookmark.slash.fill")
            } else {
                try CollectionMemory.add(collection, in: context)
                notice = ToastMessage(text: "Saved to Memory")
            }
        } catch {
            notice = ToastMessage(text: "Couldn’t save it. Try again.", systemImage: "exclamationmark.triangle")
        }
    }
}

/// The five stack designs to choose from (#386). Temporary.
enum CollectionStackDesign: Int, CaseIterable {
    case fanned, deck, wallet, carousel, grid
}

/// The temporary ‹ n / 5 › glass switcher between the designs.
private struct DesignSwitcher: View {
    @Binding var design: CollectionStackDesign

    var body: some View {
        let all = CollectionStackDesign.allCases
        GlassEffectContainer(spacing: 4) {
            HStack(spacing: 4) {
                Button("Previous design", systemImage: "chevron.left") {
                    design = all[(design.rawValue + all.count - 1) % all.count]
                }
                Text(verbatim: "\(design.rawValue + 1) / \(all.count)")
                    .font(.subheadline.weight(.semibold).monospacedDigit())
                    .frame(minWidth: 40)
                Button("Next design", systemImage: "chevron.right") {
                    design = all[(design.rawValue + 1) % all.count]
                }
            }
            .labelStyle(.iconOnly)
            .buttonStyle(.glass)
        }
        .sensoryFeedback(.selection, trigger: design)
    }
}
