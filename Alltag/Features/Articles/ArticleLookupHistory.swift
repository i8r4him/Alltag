//
//  ArticleLookupHistory.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// The words looked up before, newest first. Tap one to see it again
/// without asking the server; swipe to remove it.
struct ArticleLookupHistory: View {
    let model: ArticleLookupModel
    @Environment(\.dismiss) private var dismiss
    @State private var isConfirmingClear = false
    @State private var taps = 0

    var body: some View {
        NavigationStack {
            List {
                ForEach(model.history) { lookup in
                    Button {
                        taps += 1
                        model.show(lookup)
                        dismiss()
                    } label: {
                        row(for: lookup)
                    }
                    .tint(.primary)
                }
                .onDelete(perform: model.removeHistory)
            }
            .overlay {
                if model.history.isEmpty {
                    ContentUnavailableView("No words yet", systemImage: "clock.arrow.circlepath",
                                           description: Text("The words you look up appear here."))
                }
            }
            .navigationTitle("Looked up")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done", systemImage: "checkmark") { dismiss() }
                }
                if !model.history.isEmpty {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Clear", role: .destructive) { isConfirmingClear = true }
                            .confirmationDialog("Clear the words you looked up?", isPresented: $isConfirmingClear,
                                                titleVisibility: .visible) {
                                Button("Clear all", role: .destructive) { model.clearHistory() }
                            }
                    }
                }
            }
        }
        .fontDesign(.rounded)
        .sensoryFeedback(.impact(weight: .medium), trigger: taps)
        .presentationDetents([.medium, .large])
    }

    private func row(for lookup: ArticleLookup) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text(verbatim: lookup.nouns.map { "\($0.article.rawValue) \($0.word)" }.joined(separator: " · "))
                    .font(.headline)
                    .environment(\.locale, ArticleNounDetail.german)
                Text(verbatim: lookup.nouns.map(\.meaning).joined(separator: " · "))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Text(lookup.date, format: .relative(presentation: .named))
                .font(.footnote)
                .foregroundStyle(.tertiary)
        }
        .accessibilityElement(children: .combine)
    }
}
