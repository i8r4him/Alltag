//
//  TranslationInbox.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 13.11.26.
//

import Foundation

/// One atomic file per saved translation, shared without moving the existing database.
enum TranslationInbox {
    static let group = "group.i8r4him.Alltag"

    struct Entry: Codable {
        var id: UUID = UUID()
        let german: String
        let meaning: String
        var savedAt: Date = .now
    }

    static func directory() throws -> URL {
        guard let root = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: group) else {
            throw CocoaError(.fileNoSuchFile)
        }
        let directory = root.appending(path: "TranslationInbox", directoryHint: .isDirectory)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        return directory
    }

    static func save(_ entry: Entry, to directory: URL? = nil) throws {
        let directory = try directory ?? self.directory()
        let file = directory.appending(path: entry.id.uuidString + ".json")
        try JSONEncoder().encode(entry).write(to: file, options: [.atomic, .completeFileProtectionUntilFirstUserAuthentication])
    }
}
