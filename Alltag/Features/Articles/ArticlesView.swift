//
//  ArticlesView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 14.11.26.
//

import SwiftUI

struct ArticlesView: View {
    var level: Level = .a1
    @Environment(AppState.self) private var appState
    @State private var section = Section.rules

    enum Section: String, CaseIterable { case rules, play, lookup }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.section) {
                Text("Learn the patterns. Try the articles. Find a word.")
                    .font(.title3).foregroundStyle(.secondary)
                Picker("Articles", selection: $section) {
                    Text("Rules").tag(Section.rules)
                    Text("Play").tag(Section.play)
                    Text("Look up").tag(Section.lookup)
                }.pickerStyle(.segmented)
                switch section {
                case .rules: ArticleRules()
                case .play: ArticleGameCard(level: level)
                case .lookup: ArticleLookupCard(level: level)
                }
            }
            .padding(Spacing.screen)
        }
        .fontDesign(.rounded)
        .skyBackground()
        .scrollIndicators(.hidden)
        .scrollDismissesKeyboard(.interactively)
        .readableContentMargins()
        .navigationTitle("Articles")
        .toolbarTitleDisplayMode(.inlineLarge)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button("Learn", systemImage: "chevron.backward") { appState.popToRoot() }
            }
        }
    }
}
