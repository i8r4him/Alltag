//
//  DataExport.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import CoreTransferable
import Foundation
import SwiftData
import UniformTypeIdentifiers

/// Everything Alltag stores about the learner, as JSON, for Settings · Export my data.
struct DataExport: Codable, Equatable {
    struct Profile: Codable, Equatable {
        let name: String
        let nativeLanguage: String
        let goal: String
        let level: String
        let dailyMinutes: Int
        let interests: [String]
        let learningSince: Date
    }

    struct Word: Codable, Equatable {
        let word: String
        let meaning: String
        let context: String
        let source: String
        let strength: Int
        let addedAt: Date
    }

    struct SavedPhrase: Codable, Equatable {
        let german: String
        let english: String
        let place: String
    }

    struct Rule: Codable, Equatable {
        let id: String
        let solvedAt: Date
    }

    struct Translation: Codable, Equatable {
        let english: String
        let german: String
        let savedAt: Date
    }

    var exportedAt: Date
    var profile: Profile?
    var words: [Word]
    var phrases: [SavedPhrase]
    var solvedRules: [Rule]
    var translations: [Translation]

    /// Reads everything from `context`, oldest first.
    init(context: ModelContext, now: Date = .now) throws {
        exportedAt = now
        profile = try context.fetch(FetchDescriptor<UserProfile>()).first.map { Profile($0) }
        words = try context.fetch(FetchDescriptor<MemoryItem>(sortBy: [SortDescriptor(\.createdAt)])).map { Word($0) }
        phrases = try context.fetch(FetchDescriptor<Phrase>(sortBy: [SortDescriptor(\.createdAt)])).map { SavedPhrase($0) }
        solvedRules = try context.fetch(FetchDescriptor<SolvedRule>(sortBy: [SortDescriptor(\.solvedAt)])).map { Rule($0) }
        translations = try context.fetch(FetchDescriptor<SavedTranslation>(sortBy: [SortDescriptor(\.savedAt)]))
            .map { Translation($0) }
    }

    func jsonData() throws -> Data {
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        return try encoder.encode(self)
    }
}

extension DataExport.Profile {
    init(_ profile: UserProfile) {
        self.init(
            name: profile.name,
            nativeLanguage: profile.nativeLanguageRaw,
            goal: profile.goalRaw,
            level: profile.levelRaw,
            dailyMinutes: profile.dailyMinutes,
            interests: profile.interestsRaw,
            learningSince: profile.learningSince
        )
    }
}

extension DataExport.Word {
    init(_ item: MemoryItem) {
        self.init(word: item.displayWord, meaning: item.meaning, context: item.context,
                  source: item.sourceRaw, strength: item.strength, addedAt: item.createdAt)
    }
}

extension DataExport.SavedPhrase {
    init(_ phrase: Phrase) {
        self.init(german: phrase.german, english: phrase.english, place: phrase.place)
    }
}

extension DataExport.Rule {
    init(_ rule: SolvedRule) {
        self.init(id: rule.ruleID, solvedAt: rule.solvedAt)
    }
}

extension DataExport.Translation {
    init(_ translation: SavedTranslation) {
        self.init(english: translation.english, german: translation.german, savedAt: translation.savedAt)
    }
}

/// The export as a file for `ShareLink`, read from the store when shared.
struct DataExportFile: Transferable {
    let container: ModelContainer

    static var transferRepresentation: some TransferRepresentation {
        DataRepresentation(exportedContentType: .json) { file in
            try await MainActor.run { try DataExport(context: file.container.mainContext).jsonData() }
        }
        .suggestedFileName("Alltag export.json")
    }
}
