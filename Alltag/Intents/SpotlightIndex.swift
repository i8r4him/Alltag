//
//  SpotlightIndex.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import AppIntents
import CoreSpotlight
import OSLog
import SwiftData

extension WordEntity: IndexedEntity {}
extension PhraseEntity: IndexedEntity {}
extension ScenarioEntity: IndexedEntity {}
extension GrammarRuleEntity: IndexedEntity {}

/// Puts the learner's words and phrases, the conversations and the grammar
/// rules into Spotlight, so Siri and Apple Intelligence can use them as
/// personal context.
enum SpotlightIndex {
    struct Entities {
        var words: [WordEntity]
        var phrases: [PhraseEntity]
        var scenarios: [ScenarioEntity]
        var rules: [GrammarRuleEntity]

        var count: Int { words.count + phrases.count + scenarios.count + rules.count }
    }

    private static let logger = Logger(subsystem: "i8r4him.Alltag", category: "Spotlight")

    /// Everything that is indexed.
    static func entities(in context: ModelContext) throws -> Entities {
        Entities(
            words: try context.fetch(FetchDescriptor<MemoryItem>()).map { WordEntity($0) },
            phrases: try context.fetch(FetchDescriptor<Phrase>()).map { PhraseEntity($0) },
            scenarios: MockScenarios.all.map { ScenarioEntity($0) },
            rules: MockRules.all.map { GrammarRuleEntity($0) }
        )
    }

    /// Replaces the index with the current content, so deleted words disappear too.
    static func reindex(_ container: ModelContainer) async {
        do {
            let entities = try entities(in: container.mainContext)
            let index = CSSearchableIndex.default()
            try await index.deleteAllSearchableItems()
            try await index.indexAppEntities(entities.words)
            try await index.indexAppEntities(entities.phrases)
            try await index.indexAppEntities(entities.scenarios)
            try await index.indexAppEntities(entities.rules)
            logger.info("Indexed \(entities.count) entities")
        } catch {
            logger.error("Spotlight indexing failed: \(error.localizedDescription)")
        }
    }
}
