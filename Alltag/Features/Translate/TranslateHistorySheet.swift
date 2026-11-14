//
//  TranslateHistorySheet.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 14.11.26.
//

import SwiftUI

/// The texts translated before, newest first, as glass cards on the sky.
/// Tap one to see it again without asking the server; press and hold to
/// remove it, or clear them all.
struct TranslateHistorySheet: View {
    let history: TranslationHistory
    let onChoose: (TranslationLookup) -> Void

    var body: some View {
        HistorySheet(text: HistoryText(title: "History", emptyTitle: "No translations yet",
                                       emptyDescription: "The texts you translate appear here.",
                                       clearQuestion: "Clear your translations?"),
                     items: history.lookups, onChoose: onChoose, onRemove: history.remove, onClear: history.clear) { lookup in
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
        }
    }
}
