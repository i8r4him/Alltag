//
//  StartConversationIntent.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import AppIntents

/// Starts a speaking session, e.g. "Practise At the dentist in Alltag".
struct StartConversationIntent: AppIntent {
    static let title: LocalizedStringResource = "Start a Conversation"
    static let description = IntentDescription("Starts a German speaking session in Alltag.")
    static let supportedModes: IntentModes = .foreground(.immediate)

    @Parameter(title: "Conversation", description: "The situation to rehearse. Leave empty for today's focus.")
    var scenario: ScenarioEntity?

    @Dependency private var appState: AppState

    init() {}

    init(scenario: ScenarioEntity?) {
        self.scenario = scenario
    }

    static var parameterSummary: some ParameterSummary {
        Summary("Practise \(\.$scenario)")
    }

    @MainActor
    func perform() async throws -> some IntentResult {
        Self.start(scenario, in: appState)
        return .result()
    }

    /// Presents `scenario`, or today's focus when none is given.
    static func start(_ scenario: ScenarioEntity?, in appState: AppState) {
        let id = scenario.flatMap { Scenario.ID(rawValue: $0.id) } ?? MockScenarios.todaysFocus
        appState.present(.conversation(id))
    }
}
