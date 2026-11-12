//
//  SessionRecord.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 12.11.26.
//

import Foundation
import SwiftData

/// A copy of one time the learner talked: what was said, line by line, with
/// the feedback, so they can open it again from Learn and learn from it.
/// A 60-second talk also keeps its recording, as a file next to the store.
///
/// Like every model, it follows CloudKit's rules so iCloud sync can be
/// switched on later: every property has a default and nothing is unique.
@Model
final class SessionRecord {
    var uuid: UUID = UUID()
    var date: Date = Date.now
    /// Raw value of `kind`.
    var kindRaw: String = PracticeKind.conversation.rawValue
    /// "Just talk", "At the doctor", "60 seconds · Meine Familie".
    var title: String = ""
    var secondsSpoken: Int = 0
    /// How many of the learner's lines got a fix; kept apart so lists needn't decode the lines.
    var fixCount: Int = 0
    /// The lines as JSON (`[SessionLine]`).
    var linesData: Data = Data()
    /// The recording's file name in `SessionHistory.audioFolder`, or empty.
    var audioFileName: String = ""

    var kind: PracticeKind {
        get { PracticeKind(rawValue: kindRaw) ?? .conversation }
        set { kindRaw = newValue.rawValue }
    }

    var lines: [SessionLine] {
        get { (try? JSONDecoder().decode([SessionLine].self, from: linesData)) ?? [] }
        set {
            linesData = (try? JSONEncoder().encode(newValue)) ?? Data()
            fixCount = newValue.filter { $0.feedback?.kind == .fix }.count
        }
    }

    init(uuid: UUID = UUID(), kind: PracticeKind, title: String, secondsSpoken: Int = 0,
         lines: [SessionLine] = [], audioFileName: String = "", date: Date = .now) {
        self.uuid = uuid
        self.date = date
        self.kindRaw = kind.rawValue
        self.title = title
        self.secondsSpoken = max(0, secondsSpoken)
        self.audioFileName = audioFileName
        self.lines = lines
    }
}

/// One line of a saved session.
struct SessionLine: Codable, Hashable, Sendable {
    var isLearner: Bool
    var german: String
    var english = ""
    var feedback: SavedFeedback?

    /// Feedback in a form that can be stored.
    struct SavedFeedback: Codable, Hashable, Sendable {
        enum Kind: String, Codable, Sendable { case good, fix, note }
        var kind: Kind
        var title: String
        var note: String
        var correction: String?
    }
}

extension SessionLine {
    init(_ line: ConversationLine) {
        self.init(isLearner: line.speaker == .learner, german: line.german, english: line.english,
                  feedback: line.feedback.map { SavedFeedback($0) })
    }
}

extension SessionLine.SavedFeedback {
    init(_ feedback: Feedback) {
        let kind: Kind = switch feedback.kind {
        case .good: .good
        case .fix: .fix
        case .note: .note
        }
        self.init(kind: kind, title: feedback.title, note: feedback.note, correction: feedback.correction)
    }

    /// The feedback as the transcript's card shows it.
    var feedback: Feedback {
        let kind: Feedback.Kind = switch kind {
        case .good: .good
        case .fix: .fix
        case .note: .note
        }
        return Feedback(kind: kind, title: title, note: note, correction: correction)
    }
}

/// Where the recordings live, and deleting sessions together with them.
enum SessionHistory {
    /// A folder in Application Support, next to the store. Not backed up to iCloud by SwiftData.
    static var audioFolder: URL {
        let folder = URL.applicationSupportDirectory.appending(path: "Sessions", directoryHint: .isDirectory)
        try? FileManager.default.createDirectory(at: folder, withIntermediateDirectories: true)
        return folder
    }

    static func audioFileName(for uuid: UUID) -> String { "\(uuid.uuidString).m4a" }

    static func audioURL(named name: String) -> URL { audioFolder.appending(path: name) }

    /// The recording of `record`, when it has one that is still on the device.
    static func audioURL(of record: SessionRecord) -> URL? {
        guard !record.audioFileName.isEmpty else { return nil }
        let url = audioURL(named: record.audioFileName)
        return FileManager.default.fileExists(atPath: url.path) ? url : nil
    }

    static func delete(_ record: SessionRecord, in context: ModelContext) {
        if !record.audioFileName.isEmpty { try? FileManager.default.removeItem(at: audioURL(named: record.audioFileName)) }
        context.delete(record)
        try? context.save()
    }

    static func deleteAll(in context: ModelContext) {
        for record in (try? context.fetch(FetchDescriptor<SessionRecord>())) ?? [] {
            if !record.audioFileName.isEmpty { try? FileManager.default.removeItem(at: audioURL(named: record.audioFileName)) }
            context.delete(record)
        }
        try? context.save()
    }
}
