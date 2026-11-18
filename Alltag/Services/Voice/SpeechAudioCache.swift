//
//  SpeechAudioCache.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import CryptoKit
import Foundation

/// Spoken sentences kept on the iPhone, so a sentence heard once plays again at once and
/// costs nothing. Files are named by a hash of the text; the oldest go when the cache grows
/// past `limit` bytes. It lives in Caches, so the system may clear it when space runs low.
struct SpeechAudioCache {
    let directory: URL
    let limit: Int

    init(directory: URL = URL.cachesDirectory.appending(path: "Speech", directoryHint: .isDirectory),
         limit: Int = 60_000_000) {
        self.directory = directory
        self.limit = limit
    }

    /// The same sentence with other spaces is the same sentence, as on the server.
    static func normalised(_ text: String) -> String {
        text.split(whereSeparator: \.isWhitespace).joined(separator: " ")
    }

    func url(for text: String) -> URL? {
        let url = fileURL(for: text)
        return FileManager.default.fileExists(atPath: url.path(percentEncoded: false)) ? url : nil
    }

    @discardableResult
    func store(_ data: Data, for text: String) throws -> URL {
        try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        let url = fileURL(for: text)
        try data.write(to: url, options: .atomic)
        trim(keeping: url)
        return url
    }

    /// Removes the oldest files until the cache fits `limit` again.
    func trim(keeping kept: URL? = nil) {
        let keys: [URLResourceKey] = [.fileSizeKey, .contentModificationDateKey]
        guard let files = try? FileManager.default.contentsOfDirectory(at: directory, includingPropertiesForKeys: keys)
        else { return }
        let entries = files.compactMap { url -> Entry? in
            guard let values = try? url.resourceValues(forKeys: Set(keys)) else { return nil }
            return Entry(url: url, size: values.fileSize ?? 0, date: values.contentModificationDate ?? .distantPast)
        }
        var total = entries.reduce(0) { $0 + $1.size }
        for entry in entries.sorted(by: { $0.date < $1.date }) where total > limit {
            guard entry.url != kept else { continue }
            try? FileManager.default.removeItem(at: entry.url)
            total -= entry.size
        }
    }

    private struct Entry {
        let url: URL
        let size: Int
        let date: Date
    }

    private func fileURL(for text: String) -> URL {
        let digest = SHA256.hash(data: Data("v1|\(Self.normalised(text))".utf8))
        let name = digest.map { String(format: "%02x", $0) }.joined()
        return directory.appending(path: "\(name).wav")
    }
}
