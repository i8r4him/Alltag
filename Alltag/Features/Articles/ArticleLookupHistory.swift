//
//  ArticleLookupHistory.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// The words looked up before, newest first, as glass cards on the sky, like
/// Translate's history. Tap one to see it again without asking the server;
/// press and hold to remove it, or clear them all.
struct ArticleLookupHistory: View {
    let model: ArticleLookupModel

    var body: some View {
        HistorySheet(text: HistoryText(title: "Looked up", emptyTitle: "No words yet",
                                       emptyDescription: "The words you look up appear here.",
                                       clearQuestion: "Clear the words you looked up?"),
                     items: model.history, onChoose: model.show, onRemove: model.removeHistory, onClear: model.clearHistory) { lookup in
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 6) {
                    Label {
                        Text(verbatim: lookup.query).lineLimit(1)
                    } icon: {
                        Image(systemName: "magnifyingglass")
                    }
                    Spacer()
                    Text(lookup.date, format: .relative(presentation: .named))
                        .foregroundStyle(.tertiary)
                }
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.secondary)
                Text(verbatim: lookup.nouns.map { "\($0.article.rawValue) \($0.word)" }.joined(separator: " · "))
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.accent)
                    .lineLimit(2)
                    .environment(\.locale, ArticleNounDetail.german)
                Text(verbatim: lookup.nouns.map(\.meaning).joined(separator: " · "))
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }
        }
    }
}
