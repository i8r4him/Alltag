//
//  LearnView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftData
import SwiftUI

/// Learn: something new to learn. Under the tools, Today's lesson plays one
/// thing from each part; the parts themselves follow. Speaking is on Today, and keeping
/// and reviewing (your mistakes too) is in Memory.
struct LearnView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.services) private var services
    @Environment(\.reducesMotion) private var reduceMotion
    @Query private var profiles: [UserProfile]
    @State private var toolTaps = 0
    @State private var notice: ToastMessage?
    @Environment(\.levelMapZoom) private var levelMapZoom
    /// Used only when no screen above shares a namespace (previews).
    @Namespace private var ownZoom
    /// "How do I say …?": kept here so the whole page can step back while the
    /// learner types and move with the answer.
    @State private var ask: AskModel?
    @FocusState private var isAsking: Bool

    private var level: Level { profiles.first?.level ?? .a1 }

    private func open(_ tool: LearnTool) {
        isAsking = false
        switch tool {
        case .translate: appState.open(.translate())
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
            VStack(spacing: Spacing.grid) {
                AskInPlace(model: ask, isFocused: $isAsking)
                VStack(spacing: Spacing.section) {
                    ToolsSection(onOpen: open)
                    DailyLessonSection(level: level)
                    WordCollectionsSection(level: level, notice: $notice)
                    SkillsSection(level: level, onOpen: open)
                }
                .fieldFocusBackdrop(isActive: isAsking) { isAsking = false }
            }
            .animation(AskMotion.answer(reduceMotion: reduceMotion), value: ask?.layout)
            .padding(.horizontal, Spacing.screen)
            .padding(.top, 8)
            .padding(.bottom, 24)
        }
        .scrollIndicators(.hidden)
        .scrollDismissesKeyboard(.interactively)
        .readableContentMargins()
        .skyBackground()
        .navigationTitle("Learn")
        .toolbarTitleDisplayMode(.inlineLarge)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                LevelRingButton()
            }
            .sharedBackgroundVisibility(.hidden)
            .matchedTransitionSource(id: LevelRingButton.zoomID, in: levelMapZoom ?? ownZoom)
        }
        .scrollEdgeEffectStyle(.soft, for: .all)
        .sensoryFeedback(.impact(weight: .light), trigger: toolTaps)
        // On the screen, not a card, so it sits at the bottom above the tab bar.
        .toast($notice)
        .onAppear {
            if ask == nil { ask = AskModel(services: services) }
        }
        // Leaving Learn (another tab, a pushed screen) puts the keyboard away.
        .onDisappear { isAsking = false }
    }
}

#Preview {
    NavigationStack { LearnView() }
        .environment(AppState())
        .modelContainer(AlltagStore.preview)
}
