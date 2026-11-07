//
//  ReviewWordsIntent.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import AppIntents

/// Starts reviewing the words due today.
struct ReviewWordsIntent: AppIntent {
    static let title: LocalizedStringResource = "Review My Words"
    static let description = IntentDescription("Starts a short review of the words you saved in Alltag.")
    static let supportedModes: IntentModes = .foreground(.immediate)

    @Dependency private var appState: AppState

    @MainActor
    func perform() async throws -> some IntentResult {
        Self.start(in: appState)
        return .result()
    }

    static func start(in appState: AppState) {
        appState.present(.activity(.recall))
    }
}
