//
//  OpenMemoryIntent.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import AppIntents

/// Opens Memory, the learner's words and phrases.
struct OpenMemoryIntent: AppIntent {
    static let title: LocalizedStringResource = "Open My Words"
    static let description = IntentDescription("Opens your words and phrases in Alltag.")
    static let supportedModes: IntentModes = .foreground(.immediate)

    @Dependency private var appState: AppState

    @MainActor
    func perform() async throws -> some IntentResult {
        appState.show(.memory())
        return .result()
    }
}
