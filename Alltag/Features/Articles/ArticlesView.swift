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
    @State private var lookup = ArticleLookupModel()
    @State private var isShowingHistory = false
    @FocusState private var isSearchFocused: Bool
    @Environment(\.reducesMotion) private var reduceMotion
    @Namespace private var transition

    var body: some View {
        LearnScreen(title: "Articles") {
            ArticlesHeroCard(level: level) { appState.present(.articles) }
                .fieldFocusBackdrop(isActive: isSearchFocused) { isSearchFocused = false }
            // TEMPORARY (#397): the opening effects to choose from, the same as on Learn.
            FieldFocusEffectSwitcher()
                .frame(maxWidth: .infinity)
            LearnSection(title: "Look up a word") {
                ArticleLookupCard(level: level, model: lookup, isFieldFocused: $isSearchFocused)
            }
            LearnSection(title: "A few useful clues") {
                ArticleRules()
            }
            .fieldFocusBackdrop(isActive: isSearchFocused) { isSearchFocused = false }
        }
        // Any scroll lowers the keyboard, as does a tap on the page behind the field (fieldFocusBackdrop).
        .scrollDismissesKeyboard(.immediately)
        // On the whole screen, so the clues below move with the cards instead of jumping.
        .animation(ArticleLookupMotion.change(reduceMotion: reduceMotion), value: lookup.phase)
        .onDisappear { isSearchFocused = false }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Looked up", systemImage: "clock.arrow.circlepath") {
                    isSearchFocused = false
                    isShowingHistory = true
                }
            }
            .matchedTransitionSource(id: Self.historyTransition, in: transition)
        }
        // The history grows out of its button and shrinks back into it.
        .sheet(isPresented: $isShowingHistory) {
            ArticleLookupHistory(model: lookup)
                .navigationTransition(.zoom(sourceID: Self.historyTransition, in: transition))
        }
        .sensoryFeedback(.impact(weight: .medium), trigger: isShowingHistory) { _, isShowing in isShowing }
        // On the screen, not the card, so it sits at the bottom above the tab bar.
        .toast($lookup.notice)
    }

    private static let historyTransition = "history"
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
                    Text("Nouns fall, a little faster each time. Tap der, die or das before they land.")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityElement(children: .combine)
                ScenarioArtwork(systemImage: LearnTool.articles.systemImage)
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
