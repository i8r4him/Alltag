//
//  LineReviewer.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 11.11.26.
//

import Foundation

/// Checks the learner's lines of a live conversation with the on-device
/// companion, one at a time, while the conversation goes on. That way most of
/// the checking is done before the summary appears.
final class LineReviewer {
    struct Result {
        let german: String
        let english: String
        let feedback: Feedback
    }

    private struct Line {
        let id: UUID
        let german: String
        let previous: String?
    }

    private let companion: any CompanionService
    private let scenario: Scenario
    private var queue: [Line] = []
    private var asked: [UUID: String] = [:]
    private var task: Task<Void, Never>?
    private(set) var results: [UUID: Result] = [:]
    /// Called after each checked line, and once more when nothing is left.
    var onProgress: (() -> Void)?

    init(companion: any CompanionService, scenario: Scenario) {
        self.companion = companion
        self.scenario = scenario
    }

    var isBusy: Bool { task != nil }

    /// Queues a line unless the same words were queued before, or there is
    /// nothing in them to correct.
    func check(id: UUID, german: String, replyingTo previous: String?) {
        guard companion.canCheckSentences, Self.isWorthChecking(german), asked[id] != german else { return }
        asked[id] = german
        queue.append(Line(id: id, german: german, previous: previous))
        guard task == nil else { return }
        task = Task { [weak self] in await self?.run() }
    }

    func wait() async {
        await task?.value
    }

    func cancel() {
        task?.cancel()
        queue.removeAll()
    }

    private func run() async {
        while !Task.isCancelled, !queue.isEmpty {
            let line = queue.removeFirst()
            guard let own = try? await companion.feedback(on: line.german, in: scenario, replyingTo: line.previous),
                  own.feedback != MockCompanionService.ownSentenceNote else { continue }
            results[line.id] = Result(german: line.german, english: own.english, feedback: own.feedback)
            onProgress?()
        }
        task = nil
        onProgress?()
    }

    /// One- and two-word answers ("Ja, gerne.") have nothing to correct.
    static func isWorthChecking(_ german: String) -> Bool {
        german.split(whereSeparator: \.isWhitespace).count >= 3
    }
}
