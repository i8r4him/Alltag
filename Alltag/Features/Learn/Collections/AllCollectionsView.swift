//
//  AllCollectionsView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftData
import SwiftUI

/// Learn › Word collections: every collection, by level and topic. The level
/// chips on top start at the learner's level; each topic is a sideways row
/// of stacked cards, as on Learn. Topics without words yet say "Coming soon".
struct AllCollectionsView: View {
    @Environment(\.modelContext) private var context
    @Query(filter: #Predicate<MemoryItem> { $0.sourceRaw == "collection" }) private var collectionWords: [MemoryItem]
    @State private var level: Level
    @State private var opened: WordCollection?
    @State private var toggles = 0
    @State private var notice: ToastMessage?
    @Namespace private var zoom

    init(level: Level) {
        _level = State(initialValue: Level.selectable.contains(level) ? level : .b1)
    }

    var body: some View {
        let added = CollectionMemory.addedTitles(collectionWords)
        let topics = CollectionCategory.allCases
            .map { CollectionTopic(category: $0, collections: WordCollections.collections(at: level, in: $0)) }
            .filter { !$0.collections.isEmpty }
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.section) {
                CollectionLevelChips(selection: $level)
                if topics.isEmpty {
                    ContentUnavailableView("No collections at this level yet",
                                           systemImage: "square.stack",
                                           description: Text("Choose another level."))
                }
                ForEach(topics) { topic in
                    VStack(alignment: .leading, spacing: 12) {
                        Text(topic.category.title)
                            .textRole(.sectionHeader)
                            .padding(.horizontal, 4)
                        FannedRowStack(deck: CollectionDeck(collections: topic.collections, added: added, zoom: zoom,
                                                            open: { opened = $0 }, toggle: toggle))
                    }
                }
            }
            .padding(.horizontal, Spacing.screen)
            .padding(.top, 8)
            .padding(.bottom, 24)
        }
        .scrollIndicators(.hidden)
        .fontDesign(.rounded)
        .readableContentMargins()
        .skyBackground()
        .navigationTitle("Word collections")
        .toolbarTitleDisplayMode(.inlineLarge)
        .scrollEdgeEffectStyle(.soft, for: .all)
        .sheet(item: $opened) { collection in
            WordCollectionSheet(collection: collection)
                .navigationTransition(.zoom(sourceID: collection.id, in: zoom))
        }
        .sensoryFeedback(.impact(weight: .medium), trigger: opened?.id) { _, id in id != nil }
        .sensoryFeedback(.impact(weight: .medium), trigger: toggles)
        .toast($notice)
    }

    private func toggle(_ collection: WordCollection) {
        toggles += 1
        notice = CollectionMemory.toggle(collection, in: context)
    }
}

/// One topic's collections at the chosen level.
private struct CollectionTopic: Identifiable {
    let category: CollectionCategory
    let collections: [WordCollection]
    var id: CollectionCategory { category }
}

/// A1 to C1 as glass chips; the chosen one is outlined in the theme colour.
private struct CollectionLevelChips: View {
    @Binding var selection: Level

    var body: some View {
        ScrollView(.horizontal) {
            GlassEffectContainer(spacing: 8) {
                HStack(spacing: 8) {
                    ForEach(Level.selectable) { level in
                        Button {
                            withAnimation(.snappy) { selection = level }
                        } label: {
                            Text(verbatim: level.title)
                                .font(.headline)
                                .foregroundStyle(level == selection ? Color.accent : Color.primary)
                                .padding(.horizontal, 14)
                                .frame(minWidth: 56, minHeight: 40)
                                .overlay {
                                    Capsule().strokeBorder(Color.accentFill, lineWidth: level == selection ? 2 : 0)
                                }
                        }
                        .buttonStyle(.plain)
                        .glassEffect(.regular.interactive(), in: .capsule)
                        .accessibilityAddTraits(level == selection ? .isSelected : [])
                    }
                }
            }
            .padding(.vertical, 2)
        }
        .scrollIndicators(.hidden)
        .scrollEdgeEffectStyle(.soft, for: .all)
        .scrollClipDisabled()
        .sensoryFeedback(.selection, trigger: selection)
    }
}

#Preview {
    NavigationStack { AllCollectionsView(level: .a2) }
        .modelContainer(AlltagStore.preview)
}
