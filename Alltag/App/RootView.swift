//
//  RootView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftData
import SwiftUI

/// The app's root: first-run onboarding, then Home in a `NavigationStack`
/// with pushed screens and full-screen flows.
struct RootView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.accessibilityReduceMotion) private var systemReduceMotion
    @Environment(\.services) private var services
    @Query private var profiles: [UserProfile]
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        Group {
            if AppState.needsOnboarding(profiles) {
                OnboardingFlow()
                    .transition(.opacity)
            } else {
                navigation
                    .transition(.opacity)
            }
        }
        .animation(Motion.modal(reduceMotion: reducesMotion), value: AppState.needsOnboarding(profiles))
        .environment(\.reducesMotion, reducesMotion)
        .onChange(of: appState.settings.slowerSpeech, initial: true) { _, slower in
            services.voice.prefersSlowerSpeech = slower
        }
    }

    private var navigation: some View {
        @Bindable var appState = appState
        return NavigationStack(path: $appState.path) {
            HomeView()
                .navigationDestination(for: Route.self, destination: destination)
        }
        .fullScreenCover(item: $appState.fullScreen, content: fullScreen)
    }

    private var reducesMotion: Bool {
        appState.reducesMotion(system: systemReduceMotion)
    }

    @ViewBuilder
    private func destination(_ route: Route) -> some View {
        switch route {
        case .translate(let text):
            TranslateView(initialText: text)
        case let .memory(kind, search):
            MemoryView(kind: kind, search: search)
        case .learn:
            LearnView()
        case .grammar:
            GrammarView()
        case .debrief:
            DebriefView(services: services)
        case .briefing:
            BriefingView(services: services)
        case .progress:
            ProgressOverviewView()
        case .profile:
            ProfileView()
        case .settings:
            SettingsView(services: services)
        case .beyond:
            BeyondView()
        case .rule(let id):
            if let rule = MockRules.rule(id: id) {
                RuleView(rule: rule)
            } else {
                ContentUnavailableView("Rule not found", systemImage: "book.closed",
                                       description: Text("This rule isn't available any more."))
            }
        }
    }

    @ViewBuilder
    private func fullScreen(_ route: FullScreenRoute) -> some View {
        switch route {
        case .conversation(let id):
            ConversationView(scenario: MockScenarios.scenario(id), level: profiles.first?.level ?? .a1)
        case .activity(let id):
            ActivityView(activity: id == .mistakes
                         ? MistakePractice.activity(in: modelContext) ?? MockActivities.mistakes
                         : MockActivities.activity(id))
        case .onboarding:
            OnboardingFlow(model: profiles.first.map { OnboardingModel(profile: $0) } ?? OnboardingModel())
        }
    }
}

#Preview("Home") {
    RootView()
        .environment(AppState())
        .modelContainer(AlltagStore.preview)
}

#Preview("First run") {
    RootView()
        .environment(AppState())
        .modelContainer(try! AlltagStore.makeContainer(inMemory: true)) // swiftlint:disable:this force_try
}
