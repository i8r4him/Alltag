//
//  TranslateIntent.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import AppIntents

/// Opens Translate with a phrase, in either direction.
struct TranslateIntent: AppIntent {
    static let title: LocalizedStringResource = "Translate"
    static let description = IntentDescription("Translates between English and German in Alltag, with tone and examples.")
    static let supportedModes: IntentModes = .foreground(.immediate)

    @Parameter(title: "Text", description: "English or German.", inputOptions: String.IntentInputOptions(multiline: true))
    var text: String

    @Dependency private var appState: AppState

    init() {}

    init(text: String) {
        self.text = text
    }

    static var parameterSummary: some ParameterSummary {
        Summary("Translate \(\.$text)")
    }

    @MainActor
    func perform() async throws -> some IntentResult {
        Self.open(text, in: appState)
        return .result()
    }

    /// Opens Translate with `text`, trimmed; empty text opens it blank.
    static func open(_ text: String, in appState: AppState) {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        appState.show(.translate(text: trimmed.isEmpty ? nil : trimmed))
    }
}
