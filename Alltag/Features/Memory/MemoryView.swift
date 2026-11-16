//
//  MemoryView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftData
import SwiftUI

/// Memory: the learner's words (#32) and phrasebook (#33).
struct MemoryView: View {
    enum Tab: Hashable {
        case words
        case phrasebook
    }

    @Environment(AppState.self) private var appState
    @Environment(\.services) private var services
    @Query private var items: [MemoryItem]
    @Query private var phrases: [Phrase]

    @State private var tab: Tab = .words
    @State private var filter: MemoryFilter
    @State private var query = ""
    @State private var expandedID: PersistentIdentifier?

    init(kind: MemoryKind? = nil, search: String? = nil) {
        _filter = State(initialValue: MemoryFilter(kind: kind))
        _query = State(initialValue: search ?? "")
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                Picker("Section", selection: $tab) {
                    Text("Words").tag(Tab.words)
                    Text("Phrasebook").tag(Tab.phrasebook)
                }
                .pickerStyle(.segmented)

                switch tab {
                case .words: words
                case .phrasebook:
                    PhrasebookTab(phrases: shownPhrases) { german in
                        Task { await services.voice.speak(german, rate: .normal) }
                    }
                }
            }
            .padding(.horizontal, Spacing.screen)
            .padding(.bottom, 24)
            .animation(.easeOut(duration: 0.25), value: filter)
            .animation(.easeOut(duration: 0.25), value: expandedID)
        }
        .scrollIndicators(.hidden)
        .scrollEdgeEffectStyle(.soft, for: .all)
        .readableContentMargins()
        .skyBackground()
        .navigationTitle("Memory")
        .toolbarTitleDisplayMode(.inlineLarge)
        .searchable(text: $query, placement: .navigationBarDrawer(displayMode: .always), prompt: Text("Search your memory"))
        // NEW badges clear once the learner has seen them.
        .onChange(of: tab) { old, _ in
            if old == .phrasebook { markPhrasesSeen() }
        }
        .onDisappear { if tab == .phrasebook { markPhrasesSeen() } }
        .onscreenEntity(expandedWord.map { WordEntity($0) }, title: expandedWord?.displayWord ?? "")
    }

    /// The word opened in the list, linked for Siri and Apple Intelligence.
    private var expandedWord: MemoryItem? {
        items.first { $0.id == expandedID }
    }

    private func markPhrasesSeen() {
        phrases.filter(\.isNew).forEach { $0.isNew = false }
    }

    /// "18 words and phrases, gathered from your days."
    private var subtitle: Text {
        let total = items.count + phrases.count
        return total == 1
            ? Text("1 word or phrase, gathered from your days.")
            : Text("\(total) words and phrases, gathered from your days.")
    }

    // MARK: Words

    private var shownItems: [MemoryItem] { filter.apply(to: items, query: query) }

    /// Phrases matching the search, in German or English.
    private var shownPhrases: [Phrase] {
        let query = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return phrases }
        return phrases.filter { $0.german.localizedStandardContains(query) || $0.english.localizedStandardContains(query) }
    }

    @ViewBuilder
    private var words: some View {
        MemoryFolders(items: items, filter: $filter)

        let review = ReviewSummary(items: items)
        if filter == .all, query.isEmpty, !review.isEmpty {
            ReviewCard(summary: review) { appState.present(.activity(.recall)) }
        }

        if shownItems.isEmpty {
            ContentUnavailableView.search(text: query)
        } else {
            VStack(spacing: 0) {
                ForEach(Array(shownItems.enumerated()), id: \.element.id) { index, item in
                    if index > 0 { Divider().padding(.leading, Spacing.card) }
                    WordRow(item: item, isExpanded: expandedID == item.id,
                            onToggle: { expandedID = expandedID == item.id ? nil : item.id },
                            onListen: { Task { await services.voice.speak(item.displayWord, rate: .normal) } },
                            onPractise: { appState.present(.activity(item.kind == .mistake ? .mistakes : .recall)) })
                }
            }
            .background(.surface, in: .rect(cornerRadius: Radius.card, style: .continuous))
            .clipShape(.rect(cornerRadius: Radius.card, style: .continuous))
        }
    }
}

/// "Ready to review": how many items are due, with a button to start.
private struct ReviewCard: View {
    let summary: ReviewSummary
    let onStart: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                Eyebrow(title: "Ready to review")
                Text("^[\(summary.count) item](inflect: true), about ^[\(summary.minutes) minute](inflect: true)")
                    .textRole(.sectionHeader)
                Text(summary.mistakes > 0
                     ? "Mostly words from your reading, plus ^[\(summary.mistakes) of your own mistakes](inflect: true)."
                     : "Words from your reading and conversations.")
                    .textRole(.bodySmall)
                    .foregroundStyle(.secondary)
            }
            Button(action: onStart) { Text("Start review") }
                .buttonStyle(.primaryCompact)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: Radius.card, style: .continuous)
                .fill(.surface)
                .overlay {
                    RadialGradient(colors: [.accentFill.opacity(0.14), .clear],
                                   center: .topTrailing, startRadius: 0, endRadius: 240)
                        .clipShape(.rect(cornerRadius: Radius.card, style: .continuous))
                }
        }
    }
}

#Preview {
    NavigationStack { MemoryView() }
        .environment(AppState())
        .modelContainer(AlltagStore.preview)
}
