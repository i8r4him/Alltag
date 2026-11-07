//
//  OpenRuleIntent.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import AppIntents

/// Opens a grammar rule, e.g. "Explain verb at the end after weil in Alltag".
struct OpenRuleIntent: OpenIntent {
    static let title: LocalizedStringResource = "Open Grammar Rule"
    static let description = IntentDescription("Opens a grammar rule in Alltag, with a real example and a short task.")

    @Parameter(title: "Rule")
    var target: GrammarRuleEntity

    @Dependency private var appState: AppState

    init() {}

    init(rule: GrammarRuleEntity) {
        target = rule
    }

    @MainActor
    func perform() async throws -> some IntentResult {
        Self.open(target, in: appState)
        return .result()
    }

    static func open(_ rule: GrammarRuleEntity, in appState: AppState) {
        appState.show(.rule(id: rule.id))
    }
}
