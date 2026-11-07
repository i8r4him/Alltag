//
//  PlaceholderScreens.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftData
import SwiftUI

/// Stand-in for a pushed screen that hasn't been built yet.
struct PlaceholderScreen: View {
    let title: LocalizedStringResource
    /// GitHub issue that builds the real screen.
    let issue: Int

    var body: some View {
        ContentUnavailableView {
            Label(title, systemImage: "hammer")
        } description: {
            Text("This screen is built in #\(issue).")
        }
        .background(.screenBackground)
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.large)
    }
}

/// Stand-in for a full-screen flow, with a close button.
struct FullScreenPlaceholder: View {
    /// Content title (scenario or activity), shown as is.
    let title: String
    let issue: Int
    @Environment(AppState.self) private var appState

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                GlassButton(systemImage: "xmark", accessibilityLabel: "Close") {
                    appState.dismissFullScreen()
                }
                Spacer()
            }
            .padding(.horizontal, Spacing.screen)
            ContentUnavailableView {
                Label {
                    Text(verbatim: title)
                } icon: {
                    Image(systemName: "hammer")
                }
            } description: {
                Text("This flow is built in #\(issue).")
            }
        }
        .background(.screenBackground)
    }
}

/// Stand-in for onboarding (#20–#22): finishing creates a sample profile.
struct OnboardingPlaceholder: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(AppState.self) private var appState
    @Query private var profiles: [UserProfile]

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Spacer()
            Eyebrow(title: "Alltag")
            Text("Learn German through the life you already live.")
                .textRole(.hero)
            Text("Onboarding is built in #20–#22.")
                .textRole(.body)
                .foregroundStyle(.secondary)
            Spacer()
            Button("Get started", action: finish)
                .buttonStyle(.primary)
        }
        .padding(Spacing.onboarding)
        .background(.screenBackground)
    }

    private func finish() {
        if let profile = profiles.first {
            profile.hasCompletedOnboarding = true
        } else {
            modelContext.insert(UserProfile(name: "Mara", level: .b1, interests: Interest.defaultSelection,
                                            hasCompletedOnboarding: true))
        }
        appState.dismissFullScreen()
    }
}
