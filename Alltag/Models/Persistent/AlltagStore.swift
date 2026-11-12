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

/// Version 2 adds `PracticeSession`, behind the streak and the minutes spoken.
nonisolated enum AlltagSchemaV2: VersionedSchema {
    static let versionIdentifier = Schema.Version(2, 0, 0)

    static var models: [any PersistentModel.Type] {
        AlltagSchemaV1.models + [PracticeSession.self]
    }
}

/// Version 3 adds `CustomSituation`, the situations a learner adds themselves.
nonisolated enum AlltagSchemaV3: VersionedSchema {
    static let versionIdentifier = Schema.Version(3, 0, 0)

    static var models: [any PersistentModel.Type] {
        AlltagSchemaV2.models + [CustomSituation.self]
    }
}

/// Version 4 adds `SessionRecord`, the copy of every session the learner can reread.
nonisolated enum AlltagSchemaV4: VersionedSchema {
    static let versionIdentifier = Schema.Version(4, 0, 0)

    static var models: [any PersistentModel.Type] {
        AlltagSchemaV3.models + [SessionRecord.self]
    }
}

/// Every model in the current schema has to follow CloudKit's rules, so iCloud
/// sync (#54) can be switched on without changing them: every property optional
/// or with a default, nothing unique, every relationship optional.
/// `SwiftDataTests` checks this.
nonisolated enum AlltagMigrationPlan: SchemaMigrationPlan {
    static var schemas: [any VersionedSchema.Type] { [AlltagSchemaV1.self, AlltagSchemaV2.self, AlltagSchemaV3.self, AlltagSchemaV4.self] }
    static var stages: [MigrationStage] {
        [.lightweight(fromVersion: AlltagSchemaV1.self, toVersion: AlltagSchemaV2.self),
         .lightweight(fromVersion: AlltagSchemaV2.self, toVersion: AlltagSchemaV3.self),
         .lightweight(fromVersion: AlltagSchemaV3.self, toVersion: AlltagSchemaV4.self)]
    }
}

/// Creates the app's model container and fills it with sample data.
enum AlltagStore {
    /// The current schema.
    static var schema: Schema { Schema(versionedSchema: AlltagSchemaV4.self) }

    /// The container used by the app, or an in-memory one for previews and tests.
    /// `url` places the store somewhere else, for migration tests.
    /// iCloud sync stays off until the last step of `3 · Memory` (#54).
    static func makeContainer(inMemory: Bool = false, url: URL? = nil) throws -> ModelContainer {
        let configuration = if let url {
            ModelConfiguration(schema: schema, url: url, cloudKitDatabase: .none)
        } else {
            ModelConfiguration(schema: schema, isStoredInMemoryOnly: inMemory, cloudKitDatabase: .none)
        }
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
            for daysAgo in 0..<3 {
                let date = Calendar.current.date(byAdding: .day, value: -daysAgo, to: .now) ?? .now
                container.mainContext.insert(PracticeSession(kind: .conversation, secondsSpoken: 180, date: date))
            }
            return container
        } catch {
            fatalError("Could not create the preview container: \(error)")
        }
    }()
}
