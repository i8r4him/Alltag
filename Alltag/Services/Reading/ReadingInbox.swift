//
//  ReadingInbox.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// Links shared to Alltag from other apps, waiting in the App Group until the
/// learner opens Read: one small file per link, written by the share extension.
/// Built into the app and the extension.
nonisolated enum ReadingInbox {
    static let group = "group.i8r4him.Alltag"

    struct Entry: Codable, Hashable, Sendable {
        var id: UUID = UUID()
        let url: URL
        var sharedAt: Date = .now
    }

    static func directory() throws -> URL {
        guard let root = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: group) else {
            throw CocoaError(.fileNoSuchFile)
        }
        let directory = root.appending(path: "ReadingInbox", directoryHint: .isDirectory)
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        return directory
    }

    static func save(_ url: URL, to directory: URL? = nil) throws {
        let directory = try directory ?? self.directory()
        let entry = Entry(url: url)
        let file = directory.appending(path: entry.id.uuidString + ".json")
        try JSONEncoder().encode(entry).write(to: file, options: [.atomic, .completeFileProtectionUntilFirstUserAuthentication])
    }

    /// The links waiting, newest first; one per link.
    static func entries(in directory: URL? = nil) -> [Entry] {
        guard let directory = try? directory ?? self.directory(),
              let files = try? FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)
        else { return [] }
        let entries = files.filter { $0.pathExtension == "json" }
            .compactMap { try? JSONDecoder().decode(Entry.self, from: Data(contentsOf: $0)) }
            .sorted { $0.sharedAt > $1.sharedAt }
        var seen = Set<URL>()
        return entries.filter { seen.insert($0.url).inserted }
    }

    /// Takes every entry for a link out, once the app has kept the article.
    static func remove(_ url: URL, from directory: URL? = nil) {
        guard let directory = try? directory ?? self.directory(),
              let files = try? FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: nil)
        else { return }
        for file in files where file.pathExtension == "json" {
            if let entry = try? JSONDecoder().decode(Entry.self, from: Data(contentsOf: file)), entry.url == url {
                try? FileManager.default.removeItem(at: file)
            }
        }
    }
}
