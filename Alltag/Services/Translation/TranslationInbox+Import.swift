//
//  TranslationInbox+Import.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 13.11.26.
//

import Foundation
import SwiftData

extension TranslationInbox {
    /// Files remain available for retry until the database save succeeds.
    static func importSaved(into context: ModelContext, from directory: URL? = nil) throws {
        let directory = try directory ?? self.directory()
        for file in try FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)
            where file.pathExtension == "json" {
            let entry = try JSONDecoder().decode(Entry.self, from: Data(contentsOf: file))
            let german = entry.german
            let meaning = entry.meaning
            let predicate = #Predicate<MemoryItem> { $0.word == german && $0.meaning == meaning && $0.sourceRaw == "translate" }
            if try context.fetchCount(FetchDescriptor(predicate: predicate)) == 0 {
                let item = MemoryItem(word: german, meaning: meaning, kind: .saved, source: .translate,
                                      sourceDetail: String(localized: "Saved from another app"), createdAt: entry.savedAt)
                item.uuid = entry.id
                context.insert(item)
            }
            try context.save()
            try FileManager.default.removeItem(at: file)
        }
    }
}
