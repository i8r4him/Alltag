//
//  SituationsView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 12.11.26.
//

import SwiftData
import SwiftUI

/// Every situation to train, grouped by where in life it happens: Alltag's
/// own and the ones the learner added with "+". Tapping one starts its
/// conversation with the live voice.
struct SituationsView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \CustomSituation.createdAt, order: .reverse) private var custom: [CustomSituation]
    @State private var isAdding = false

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.section) {
                ForEach(Situation.Category.allCases) { category in
                    let own = custom.filter { $0.category == category }
                    let situations = own.map(\.situation) + SituationCatalogue.situations(in: category)
                    if !situations.isEmpty {
                        section(category, situations: situations, own: own)
                    }
                }
            }
            .padding(Spacing.screen)
        }
        .fontDesign(.rounded)
        .scrollIndicators(.hidden)
        .scrollEdgeEffectStyle(.soft, for: .all)
        .readableContentMargins()
        .skyBackground()
        .navigationTitle("Life's Situations")
        .toolbarTitleDisplayMode(.inlineLarge)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Add a situation", systemImage: "plus") { isAdding = true }
            }
        }
        .sheet(isPresented: $isAdding) {
            NewSituationSheet { title, detail, category in
                modelContext.insert(CustomSituation(title: title, detail: detail, category: category))
                try? modelContext.save()
            }
        }
    }

    private func section(_ category: Situation.Category, situations: [Situation], own: [CustomSituation]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(category.title)
                .textRole(.sectionHeader)
                .padding(.horizontal, 4)
                .accessibilityAddTraits(.isHeader)
            VStack(spacing: 0) {
                ForEach(Array(situations.enumerated()), id: \.element.id) { index, situation in
                    if index > 0 { Divider().padding(.leading, 72) }
                    let mine = own.first { $0.situationID == situation.id }
                    HStack(spacing: 0) {
                        Button { appState.present(.situation(situation.id)) } label: {
                            SituationRow(situation: situation)
                        }
                        .buttonStyle(.plain)
                        // Only the learner's own situations can be removed.
                        if let mine {
                            Menu {
                                Button("Delete", systemImage: "trash", role: .destructive) { delete(mine) }
                            } label: {
                                Image(systemName: "ellipsis")
                                    .font(.body.weight(.semibold))
                                    .foregroundStyle(.secondary)
                                    .frame(width: Spacing.minTouchTarget, height: Spacing.minTouchTarget)
                                    .contentShape(.rect)
                            }
                            .accessibilityLabel(Text("More for \(String(localized: situation.title))"))
                            .padding(.trailing, 6)
                        }
                    }
                    .contextMenu {
                        if let mine {
                            Button("Delete", systemImage: "trash", role: .destructive) { delete(mine) }
                        }
                    }
                }
            }
            .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
        }
    }

    private func delete(_ situation: CustomSituation) {
        withAnimation {
            modelContext.delete(situation)
            try? modelContext.save()
        }
    }
}

/// "+": the learner names a situation, says what they want to do there and files it under a category.
private struct NewSituationSheet: View {
    let onAdd: (_ title: String, _ detail: String, _ category: Situation.Category) -> Void

    @Environment(\.dismiss) private var dismiss
    @State private var title = ""
    @State private var detail = ""
    @State private var category = Situation.Category.other
    @FocusState private var isTitleFocused: Bool

    private var canAdd: Bool { !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Situation", text: $title, prompt: Text("At the vet"))
                        .focused($isTitleFocused)
                    TextField("What do you want to do there?", text: $detail,
                              prompt: Text("Explain that my cat isn't eating"), axis: .vertical)
                        .lineLimit(2...4)
                } footer: {
                    Text("The companion plays the other person, in German.")
                }
                Section {
                    Picker("Category", selection: $category) {
                        ForEach(Situation.Category.allCases) { category in
                            Label { Text(category.title) } icon: { Image(systemName: category.systemImage) }
                                .tag(category)
                        }
                    }
                }
            }
            .navigationTitle("New situation")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        onAdd(title, detail, category)
                        dismiss()
                    }
                    .disabled(!canAdd)
                }
            }
            .onAppear { isTitleFocused = true }
        }
        .presentationDetents([.medium, .large])
    }
}

#Preview {
    NavigationStack { SituationsView() }
        .environment(AppState())
        .modelContainer(AlltagStore.preview)
}
