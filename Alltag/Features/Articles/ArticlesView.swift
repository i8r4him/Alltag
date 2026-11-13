//
//  ArticlesView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 13.11.26.
//

import SwiftData
import SwiftUI

/// Learn › Articles: a round of der, die, das to play, a word to look up,
/// and a few clues about which article a noun takes. Today's look: the sky,
/// clear glass cards, rounded type and the big button.
struct ArticlesView: View {
    var level: Level = .a1
    @Environment(AppState.self) private var appState

    var body: some View {
        LearnScreen(title: "Articles") {
            ArticlesHeroCard(level: level) { appState.present(.articles) }
            LearnSection(title: "Look up a word") {
                ArticleLookupCard(level: level)
            }
            LearnSection(title: "A few useful clues") {
                ArticleRules()
            }
        }
        .scrollDismissesKeyboard(.interactively)
    }
}

/// The Focus card's layout: what a round is, its artwork, and the big button.
private struct ArticlesHeroCard: View {
    let level: Level
    let action: () -> Void

    @ScaledMetric(relativeTo: .title3) private var artworkSize: CGFloat = 96

    var body: some View {
        VStack(spacing: 18) {
            HStack(alignment: .center, spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(verbatim: "der, die, das?")
                        .font(.title3.weight(.semibold))
                    Text("Ten nouns for your level. The ones you get wrong come back until you know them.")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityElement(children: .combine)
                // "Abc" is wider than the other symbols; at the default size it runs off the tile.
                ScenarioArtwork(systemImage: "textformat.abc", symbolSize: 38)
                    .frame(width: artworkSize, height: artworkSize)
            }
            GlassEffectContainer {
                Button(action: action) {
                    Label("Start a round", systemImage: "play.fill")
                }
                .buttonStyle(.primary)
            }
        }
        .padding(Spacing.cardLarge)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }
}

#Preview {
    NavigationStack { ArticlesView(level: .b1) }
        .environment(AppState())
        .modelContainer(AlltagStore.preview)
}
