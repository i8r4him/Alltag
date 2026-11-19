//
//  WriteModel.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import SwiftData

/// One text the learner writes: writing, the check, and what is kept.
/// The fixes go to Fix your mistakes and the text with its feedback to Your sessions,
/// like a conversation's.
@Observable
final class WriteModel {
    enum Phase: Equatable {
        case writing
        /// The sentences arrive one by one.
        case checking
        case checked
        case failed(CloudFailure)
    }

    let brief: WritingBrief
    var text = ""
    /// What the learner put in the form's short fields, by field.
    var fields: [String: String] = [:]
    private(set) var phase = Phase.writing
    /// The sentences checked so far, then all of them.
    private(set) var sentences: [WritingSentence] = []
    private(set) var check: WritingCheck?
    /// The text that was checked, for the correction to be laid over.
    private(set) var checkedText = ""
    /// How many fixes were new to Fix your mistakes.
    private(set) var savedMistakes = 0

    @ObservationIgnored private let service: any WritingService
    @ObservationIgnored private var record: SessionRecord?
    @ObservationIgnored private let startedAt: Date

    init(brief: WritingBrief, service: any WritingService, now: Date = .now) {
        self.brief = brief
        self.service = service
        self.startedAt = now
    }

    var wordCount: Int { Self.words(in: text) }
    /// A few words at least, and not while a check is on its way.
    var canCheck: Bool { wordCount >= 3 && phase != .checking }
    var hasEnoughWords: Bool { wordCount >= brief.enoughWords }

    /// The learner's text with every fix and note applied.
    var correctedText: String { check?.correctedText(of: checkedText) ?? "" }

    func runCheck() async {
        guard canCheck else { return }
        let written = text.trimmingCharacters(in: .whitespacesAndNewlines)
        checkedText = written
        sentences = []
        check = nil
        phase = .checking
        do {
            let result = try await service.check(written, for: brief) { [weak self] sentences in
                self?.sentences = sentences
            }
            sentences = result.sentences
            check = result
            phase = .checked
        } catch is CancellationError {
            phase = .writing
        } catch {
            phase = .failed(CloudFailure(error))
        }
    }

    /// Back to the text, to change it and check again.
    func edit() {
        phase = .writing
    }

    /// Keeps the checked text in Your sessions and its fixes in Fix your mistakes.
    /// Checking again after an edit updates the same session.
    func save(in context: ModelContext, now: Date = .now) {
        guard let check, phase == .checked else { return }
        let lines = check.sentences.map {
            SessionLine(isLearner: true, german: $0.original, english: $0.english, feedback: .init($0.feedback))
        }
        if let record {
            record.lines = lines
        } else {
            let record = SessionRecord(kind: .writing, title: brief.title, lines: lines, date: startedAt)
            context.insert(record)
            context.insert(PracticeSession(kind: .writing, date: startedAt))
            self.record = record
        }
        let items = check.sentences.compactMap {
            MistakePractice.item(said: $0.original, feedback: $0.feedback, sourceDetail: brief.title, source: .writing, at: now)
        }
        savedMistakes += MistakePractice.save(items, in: context)
        try? context.save()
    }

    static func words(in text: String) -> Int {
        text.split(whereSeparator: { $0.isWhitespace || $0.isNewline }).count { $0.contains(where: \.isLetter) }
    }
}
