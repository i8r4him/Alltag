//
//  TranslateHistorySheet.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 14.11.26.
//

import SwiftUI

/// The texts translated before, newest first. Tap one to see it again
/// without asking the server; remove one, or clear them all.
///
/// TEMPORARY (#296): two designs to choose from.
/// 1 a plain list, like Articles' "Looked up"; 2 glass cards on the sky.
struct TranslateHistorySheet: View {
    let history: TranslationHistory
    let onChoose: (TranslationLookup) -> Void
    @Environment(\.dismiss) private var dismiss
    @AppStorage(TranslateDesignPart.history.key) private var storedDesign = 1
    @State private var isConfirmingClear = false
    @State private var taps = 0

    private var design: Int { TranslateDesignPart.history.clamped(storedDesign) }

    var body: some View {
        NavigationStack {
            Group {
                if design == 2 { cards } else { list }
            }
            .overlay {
                if history.lookups.isEmpty {
                    ContentUnavailableView("No translations yet", systemImage: "clock.arrow.circlepath",
                                           description: Text("The texts you translate appear here."))
                }
            }
            .safeAreaInset(edge: .bottom) {
                DesignSwitcher(.history)
                    .padding(.horizontal, Spacing.screen)
                    .padding(.vertical, 8)
            }
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done", systemImage: "checkmark") { dismiss() }
                }
                if !history.lookups.isEmpty {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Clear", role: .destructive) { isConfirmingClear = true }
                            .confirmationDialog("Clear your translations?", isPresented: $isConfirmingClear,
                                                titleVisibility: .visible) {
                                Button("Clear all", role: .destructive) { history.clear() }
                            }
                    }
                }
            }
        }
        .fontDesign(.rounded)
        .sensoryFeedback(.impact(weight: .medium), trigger: taps)
        .presentationDetents([.medium, .large])
    }

    private func choose(_ lookup: TranslationLookup) {
        taps += 1
        onChoose(lookup)
        dismiss()
    }

    // MARK: 1 · List

    private var list: some View {
        List {
            ForEach(history.lookups) { lookup in
                Button { choose(lookup) } label: {
                    HStack(alignment: .firstTextBaseline, spacing: 12) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(verbatim: lookup.input)
                                .font(.headline)
                                .lineLimit(2)
                            Text(verbatim: lookup.translation)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        Text(lookup.date, format: .relative(presentation: .named))
                            .font(.footnote)
                            .foregroundStyle(.tertiary)
                    }
                    .accessibilityElement(children: .combine)
                }
                .tint(.primary)
            }
            .onDelete(perform: history.remove)
        }
    }

    // MARK: 2 · Cards

    private var cards: some View {
        ScrollView {
            LazyVStack(spacing: Spacing.grid) {
                ForEach(history.lookups) { lookup in
                    Button { choose(lookup) } label: { card(for: lookup) }
                        .buttonStyle(.card)
                        .contextMenu {
                            Button("Remove", systemImage: "trash", role: .destructive) { history.remove(lookup) }
                        }
                }
            }
            .padding(.horizontal, Spacing.screen)
            .padding(.vertical, Spacing.grid)
            .animation(.easeOut(duration: 0.25), value: history.lookups)
        }
        .skyBackground()
    }

    private func card(for lookup: TranslationLookup) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 6) {
                Text(lookup.sourceIsGerman ? "German" : "English")
                Image(systemName: "arrow.right").accessibilityHidden(true)
                Text(lookup.sourceIsGerman ? "English" : "German")
                Spacer()
                Text(lookup.date, format: .relative(presentation: .named))
                    .foregroundStyle(.tertiary)
            }
            .font(.footnote.weight(.semibold))
            .foregroundStyle(.secondary)
            Text(verbatim: lookup.input)
                .foregroundStyle(.secondary)
                .lineLimit(2)
            Text(verbatim: lookup.translation)
                .font(.title3.weight(.semibold))
                .foregroundStyle(.accent)
                .lineLimit(3)
        }
        .multilineTextAlignment(.leading)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.cardLarge)
        .glassEffect(.regular.interactive(), in: .rect(cornerRadius: Radius.hero, style: .continuous))
        .accessibilityElement(children: .combine)
    }
}
