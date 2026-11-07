//
//  SmartBarModifier.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

private struct SmartBarModifier: ViewModifier {
    let context: SmartBarContext
    let onSearch: ((String) -> Void)?

    @Environment(AppState.self) private var appState
    @State private var isOpen = false

    func body(content: Content) -> some View {
        content
            .overlay {
                if isOpen {
                    Color.black.opacity(0.5)
                        .ignoresSafeArea()
                        .onTapGesture { isOpen = false }
                        .accessibilityLabel("Close actions")
                        .accessibilityAddTraits(.isButton)
                        .transition(.opacity)
                }
            }
            .animation(.easeOut(duration: 0.25), value: isOpen)
            // Sits above the home indicator, and above the keyboard while typing.
            .safeAreaInset(edge: .bottom) {
                SmartBar(context: context, isOpen: $isOpen, onAction: handle)
                    .readableWidth()
            }
    }

    private func handle(_ action: SmartBarAction) {
        switch SmartBarRouting.destination(for: action, in: context) {
        case .push(let route): appState.open(route)
        case .present(let route): appState.present(route)
        case .search(let text): onSearch?(text)
        }
    }
}

extension View {
    /// Adds the Smart Bar to the bottom of a screen. `onSearch` receives
    /// submitted text on screens that filter instead of translating (Memory).
    func smartBar(_ context: SmartBarContext, onSearch: ((String) -> Void)? = nil) -> some View {
        modifier(SmartBarModifier(context: context, onSearch: onSearch))
    }
}
