//
//  PlaceholderScreens.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

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
