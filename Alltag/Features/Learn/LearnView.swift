//
//  LearnView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftData
import SwiftUI

/// Learn: everything apart from speaking (that's on Today). Your mistakes first,
/// then Read, Write, Listen and Grammar.
struct LearnView: View {
    @Environment(AppState.self) private var appState
    @State private var toolTaps = 0

    /// How to say it and Articles get their screens next; for now they give feedback only.
    private func open(_ tool: LearnTool) {
        switch tool {
        case .translate: appState.open(.translate())
        case .howToSay, .articles: toolTaps += 1
        }
    }

    private func open(_ skill: LearnSkill) {
        switch skill {
        case .read: appState.open(.read)
        case .write: appState.open(.write)
        case .listen: appState.open(.listen)
        case .grammar: appState.open(.grammar)
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.section) {
                ToolsSection(onOpen: open)
                LearnSection(title: "Fix your mistakes", note: Text("1 min")) {
                    MistakesCard { appState.present(.activity(.mistakes)) }
                    SessionsLink { appState.open(.sessions) }
                }
                .fontDesign(.rounded)
                SkillsSection(onOpen: open)
            }
            .padding(.horizontal, Spacing.screen)
            .padding(.top, 8)
            .padding(.bottom, 24)
        }
        .readableContentMargins()
        .skyBackground()
        .navigationTitle("Learn")
        .toolbarTitleDisplayMode(.inlineLarge)
        .scrollEdgeEffectStyle(.soft, for: .all)
        .sensoryFeedback(.impact(weight: .light), trigger: toolTaps)
    }
}

#Preview {
    NavigationStack { LearnView() }
        .environment(AppState())
        .modelContainer(AlltagStore.preview)
}
