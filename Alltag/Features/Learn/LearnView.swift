//
//  LearnView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftData
import SwiftUI

/// Learn: something new to learn. Speaking is on Today, and keeping and
/// reviewing (your mistakes too) is in Memory.
struct LearnView: View {
    @Environment(AppState.self) private var appState
    @State private var toolTaps = 0
    @Environment(\.levelMapZoom) private var levelMapZoom
    /// Used only when no screen above shares a namespace (previews).
    @Namespace private var ownZoom

    private func open(_ tool: LearnTool) {
        switch tool {
        case .translate: appState.open(.translate())
        case .howToSay: appState.open(.howToSay)
        case .articles: appState.open(.articles)
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
                SkillsSection(onOpen: open)
            }
            .padding(.horizontal, Spacing.screen)
            .padding(.top, 8)
            .padding(.bottom, 24)
        }
        .scrollIndicators(.hidden)
        .readableContentMargins()
        .skyBackground()
        .navigationTitle("Learn")
        .toolbarTitleDisplayMode(.inlineLarge)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                LevelRingButton()
            }
            .matchedTransitionSource(id: LevelRingButton.zoomID, in: levelMapZoom ?? ownZoom)
        }
        .scrollEdgeEffectStyle(.soft, for: .all)
        .sensoryFeedback(.impact(weight: .light), trigger: toolTaps)
    }
}

#Preview {
    NavigationStack { LearnView() }
        .environment(AppState())
        .modelContainer(AlltagStore.preview)
}
