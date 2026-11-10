//
//  RootView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftData
import SwiftUI

/// The app's root: first-run onboarding, then three tabs (Today, Learn,
/// Memory), each with its own `NavigationStack`, and full-screen flows above them.
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
        // System controls (toggles, sliders, links) follow the theme.
        .tint(Color.accent)
        .onChange(of: appState.settings.slowerSpeech, initial: true) { _, slower in
            services.voice.prefersSlowerSpeech = slower
        }
    }

    private var navigation: some View {
        @Bindable var appState = appState
        return TabView(selection: $appState.tab) {
            Tab("Today", systemImage: "sun.horizon", value: AppTab.today) { stack(.today) }
            Tab("Learn", systemImage: "bolt", value: AppTab.learn) { stack(.learn) }
            Tab("Memory", systemImage: "book", value: AppTab.memory) { stack(.memory) }
        }
        .fullScreenCover(item: $appState.fullScreen, content: fullScreen)
    }

    /// A tab's own navigation stack, starting at its root.
    private func stack(_ tab: AppTab) -> some View {
        let path = Binding { appState.paths[tab] ?? [] } set: { appState.paths[tab] = $0 }
        return NavigationStack(path: path) {
            Group {
                if let root = appState.root(of: tab) {
                    destination(root).id(root)
                } else {
                    HomeView()
                }
            }
            .navigationDestination(for: Route.self, destination: destination)
        }
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
        case .read:
            ReadView()
        case .grammar:
            GrammarView()
        case .debrief:
            DebriefView(services: services)
        case .briefing:
            BriefingView(services: services)
        case .comingUp:
            ComingUpList()
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
