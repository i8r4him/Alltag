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

    /// Read and Write get their screens next; for now they open nothing.
    private func open(_ skill: LearnSkill) {
        switch skill {
        case .listen: appState.present(.activity(.listen))
        case .grammar: appState.open(.grammar)
        case .read, .write: break
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: Spacing.section) {
                MistakesCard { appState.present(.activity(.mistakes)) }
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
    }
}

#Preview {
    NavigationStack { LearnView() }
        .environment(AppState())
        .modelContainer(AlltagStore.preview)
}
