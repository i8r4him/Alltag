//
//  HistorySheet.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 14.11.26.
//

import SwiftUI

/// What a history sheet says: its title, its empty state and the question before clearing.
struct HistoryText {
    let title: LocalizedStringResource
    let emptyTitle: LocalizedStringResource
    let emptyDescription: LocalizedStringResource
    let clearQuestion: LocalizedStringResource
}

/// Things looked up before, newest first, as glass cards on the sky. Tap one
/// to see it again; press and hold to remove it, or clear them all. Translate
/// and Articles share it; each supplies what goes on a card.
struct HistorySheet<Item: Identifiable & Equatable, Content: View>: View {
    let text: HistoryText
    let items: [Item]
    let onChoose: (Item) -> Void
    let onRemove: (Item) -> Void
    let onClear: () -> Void
    @ViewBuilder let content: (Item) -> Content

    @Environment(\.dismiss) private var dismiss
    @State private var isConfirmingClear = false
    @State private var taps = 0

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: Spacing.grid) {
                    ForEach(items) { item in
                        Button {
                            taps += 1
                            onChoose(item)
                            dismiss()
                        } label: {
                            content(item)
                                .multilineTextAlignment(.leading)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(Spacing.cardLarge)
                                .glassEffect(.regular.interactive(), in: .rect(cornerRadius: Radius.hero, style: .continuous))
                                .accessibilityElement(children: .combine)
                        }
                        .buttonStyle(.card)
                        .contextMenu {
                            Button("Remove", systemImage: "trash", role: .destructive) { onRemove(item) }
                        }
                    }
                }
                .padding(.horizontal, Spacing.screen)
                .padding(.vertical, Spacing.grid)
                .animation(.easeOut(duration: 0.25), value: items)
            }
            .scrollEdgeEffectStyle(.soft, for: .all)
            .skyBackground()
            .overlay {
                if items.isEmpty {
                    ContentUnavailableView {
                        Label { Text(text.emptyTitle) } icon: { Image(systemName: "clock.arrow.circlepath") }
                    } description: {
                        Text(text.emptyDescription)
                    }
                }
            }
            .navigationTitle(Text(text.title))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done", systemImage: "checkmark") { dismiss() }
                }
                if !items.isEmpty {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Clear", role: .destructive) { isConfirmingClear = true }
                            .confirmationDialog(Text(text.clearQuestion), isPresented: $isConfirmingClear,
                                                titleVisibility: .visible) {
                                Button("Clear all", role: .destructive, action: onClear)
                            }
                    }
                }
            }
        }
        .fontDesign(.rounded)
        .sensoryFeedback(.impact(weight: .medium), trigger: taps)
        .presentationDetents([.medium, .large])
    }
}
