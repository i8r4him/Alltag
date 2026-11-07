//
//  AlltagStore.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import SwiftData

/// Version 1 of the SwiftData schema. When a model changes, add a
/// `AlltagSchemaV2` and a migration stage instead of editing this one.
nonisolated enum AlltagSchemaV1: VersionedSchema {
    static let versionIdentifier = Schema.Version(1, 0, 0)

    static var models: [any PersistentModel.Type] {
        [UserProfile.self, MemoryItem.self, Phrase.self, SolvedRule.self, SavedTranslation.self]
    }
}

nonisolated enum AlltagMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] { [AlltagSchemaV1.self] }
    static var stages: [MigrationStage] { [] }
}

/// Creates the app's model container and fills it with sample data.
enum AlltagStore {
    /// The container used by the app, or an in-memory one for previews and tests.
    /// iCloud sync stays off until the paid Developer Program is active (#54).
    static func makeContainer(inMemory: Bool = false) throws -> ModelContainer {
        let schema = Schema(versionedSchema: AlltagSchemaV1.self)
        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: inMemory,
            cloudKitDatabase: .none
        )
        return try ModelContainer(for: schema, migrationPlan: AlltagMigrationPlan.self, configurations: configuration)
    }

    /// Inserts the prototype's memory items and phrasebook when the store has none.
    /// Safe to call on every launch.
    static func seedSampleDataIfEmpty(_ context: ModelContext, now: Date = .now) throws {
        guard try context.fetchCount(FetchDescriptor<MemoryItem>()) == 0 else { return }
        MockMemoryItems.make(now: now).forEach(context.insert)
        MockPhrasebook.make(now: now).forEach(context.insert)
        try context.save()
    }

    /// Gives every memory item and phrase its own `uuid`.
    ///
    /// A store created before `uuid` existed gets the same value in every row
    /// when SwiftData adds the column, and iCloud merges can duplicate rows too.
    /// Safe to call on every launch; returns how many IDs were replaced.
    @discardableResult
    static func repairDuplicateIDs(_ context: ModelContext) throws -> Int {
        var repaired = 0
        var seen = Set<UUID>()
        for item in try context.fetch(FetchDescriptor<MemoryItem>()) where !seen.insert(item.uuid).inserted {
            item.uuid = UUID()
            seen.insert(item.uuid)
            repaired += 1
        }
        seen.removeAll()
        for phrase in try context.fetch(FetchDescriptor<Phrase>()) where !seen.insert(phrase.uuid).inserted {
            phrase.uuid = UUID()
            seen.insert(phrase.uuid)
            repaired += 1
        }
        if repaired > 0 { try context.save() }
        return repaired
    }

    /// In-memory container with sample data and a sample profile, for `#Preview`s.
    static let preview: ModelContainer = {
        do {
            let container = try makeContainer(inMemory: true)
            try seedSampleDataIfEmpty(container.mainContext)
            let mara = UserProfile(name: "Mara", level: .b1, interests: Interest.defaultSelection, hasCompletedOnboarding: true)
            container.mainContext.insert(mara)
            return container
        } catch {
            fatalError("Could not create the preview container: \(error)")
        }
    }()
}
