//
//  ContentEntities.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import AppIntents

/// A conversation scenario, e.g. "At the dentist", for Siri and Shortcuts.
struct ScenarioEntity: AppEntity {
    static let typeDisplayRepresentation: TypeDisplayRepresentation = "Conversation"
    static let defaultQuery = ScenarioEntityQuery()

    let id: String
    let title: String
    let goal: String
    let systemImage: String

    init(_ scenario: Scenario) {
        id = scenario.id.rawValue
        title = scenario.title
        goal = scenario.goal
        systemImage = scenario.systemImage
    }

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(title)", subtitle: "\(goal)", image: .init(systemName: systemImage))
    }
}

struct ScenarioEntityQuery: EnumerableEntityQuery {
    @MainActor
    func allEntities() async throws -> [ScenarioEntity] {
        MockScenarios.all.map(ScenarioEntity.init)
    }

    @MainActor
    func entities(for identifiers: [ScenarioEntity.ID]) async throws -> [ScenarioEntity] {
        MockScenarios.all.filter { identifiers.contains($0.id.rawValue) }.map(ScenarioEntity.init)
    }

    @MainActor
    func suggestedEntities() async throws -> [ScenarioEntity] {
        try await allEntities()
    }
}

/// A grammar rule, e.g. "Verb at the end after weil, wenn, dass".
struct GrammarRuleEntity: AppEntity {
    static let typeDisplayRepresentation: TypeDisplayRepresentation = "Grammar rule"
    static let defaultQuery = GrammarRuleEntityQuery()

    let id: String
    let title: String
    let level: String

    init(_ rule: GrammarRule) {
        id = rule.id
        title = rule.title
        level = rule.level.rawValue
    }

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(title)", subtitle: "\(level)", image: .init(systemName: "text.badge.checkmark"))
    }
}

struct GrammarRuleEntityQuery: EnumerableEntityQuery {
    @MainActor
    func allEntities() async throws -> [GrammarRuleEntity] {
        MockRules.all.map(GrammarRuleEntity.init)
    }

    @MainActor
    func entities(for identifiers: [GrammarRuleEntity.ID]) async throws -> [GrammarRuleEntity] {
        MockRules.all.filter { identifiers.contains($0.id) }.map(GrammarRuleEntity.init)
    }

    @MainActor
    func suggestedEntities() async throws -> [GrammarRuleEntity] {
        try await allEntities()
    }
}
