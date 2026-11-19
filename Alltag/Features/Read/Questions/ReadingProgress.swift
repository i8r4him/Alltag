//
//  ReadingProgress.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import CryptoKit
import Foundation
import SwiftData

/// Which texts the learner has read: a text counts once its three questions
/// were all right at the first try. Each read text is kept in Your sessions,
/// under an ID made from the text's own, so no new model is needed and
/// reading it again only moves its date.
enum ReadingProgress {
    /// The same UUID for a text every time, on every iPhone.
    static func recordID(for textID: String) -> UUID {
        let digest = Array(SHA256.hash(data: Data("alltag-read:\(textID)".utf8)))
        var bytes = Array(digest.prefix(16))
        bytes[6] = (bytes[6] & 0x0F) | 0x50 // version 5 style: name-based
        bytes[8] = (bytes[8] & 0x3F) | 0x80 // RFC 4122 variant
        return UUID(uuid: (bytes[0], bytes[1], bytes[2], bytes[3], bytes[4], bytes[5], bytes[6], bytes[7],
                           bytes[8], bytes[9], bytes[10], bytes[11], bytes[12], bytes[13], bytes[14], bytes[15]))
    }

    /// Every text by its record's ID, made once.
    private static let textIDsByRecord: [UUID: String] = Dictionary(
        ReadingTexts.all.map { (recordID(for: $0.id), $0.id) }, uniquingKeysWith: { first, _ in first })

    /// The IDs of the texts read, from Your sessions.
    static func readIDs(in sessions: [SessionRecord]) -> Set<String> {
        Set(sessions.filter { $0.kind == .reading }.compactMap { textIDsByRecord[$0.uuid] })
    }

    /// The first text at the level not read yet, in order.
    static func next(at level: Level, read: Set<String>) -> ReadingText? {
        ReadingTexts.texts(at: level).first { !read.contains($0.id) }
    }

    /// Keeps the text in Your sessions, or moves it to now when it was read before.
    static func markRead(_ text: ReadingText, in context: ModelContext, date: Date = .now) throws {
        let id = recordID(for: text.id)
        let existing = try context.fetch(FetchDescriptor<SessionRecord>(predicate: #Predicate { $0.uuid == id }))
        if let record = existing.first {
            record.date = date
        } else {
            let lines = text.german.split(separator: "\n").map { SessionLine(isLearner: false, german: String($0)) }
            context.insert(SessionRecord(uuid: id, kind: .reading, title: String(localized: text.title),
                                         lines: lines, date: date))
        }
        context.insert(PracticeSession(kind: .reading, date: date))
        try context.save()
    }
}
