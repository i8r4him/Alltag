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
    @Query private var profiles: [UserProfile]

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

    /// Each feature issue replaces its placeholder here with the real screen.
    @ViewBuilder
    private func destination(_ route: Route) -> some View {
        let screen = PlaceholderScreen(title: route.placeholder.title, issue: route.placeholder.issue)
        if let context = route.smartBarContext {
            screen.smartBar(context)
        } else {
            screen
        }
    }

    @ViewBuilder
    private func fullScreen(_ route: FullScreenRoute) -> some View {
        switch route {
        case .conversation(let id):
            FullScreenPlaceholder(title: MockScenarios.scenario(id).title, issue: 29)
        case .activity(let id):
            FullScreenPlaceholder(title: MockActivities.activity(id).title, issue: 35)
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
