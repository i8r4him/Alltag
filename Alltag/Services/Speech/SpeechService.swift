//
//  SpeechService.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// Turns the learner's spoken German into text.
protocol SpeechService: AnyObject {
    var authorizationStatus: PermissionStatus { get }
    func requestAuthorization() async -> PermissionStatus
    /// Listens and yields the growing transcript until the learner stops.
    ///
    /// `expected` is the scripted line in the simulated conversation; the live
    /// service (SpeechAnalyzer, #48) ignores it.
    func listen(expected: String) -> AsyncStream<String>
    func stopListening()
}

/// Simulated recognition: reveals `expected` one word at a time (230ms per
/// word in the prototype), as if the learner were saying it.
@Observable
final class MockSpeechService: SpeechService {
    private(set) var authorizationStatus: PermissionStatus = .notDetermined
    @ObservationIgnored private var task: Task<Void, Never>?
    private let wordInterval: Duration

    init(wordInterval: Duration = .milliseconds(230)) {
        self.wordInterval = wordInterval
    }

    func requestAuthorization() async -> PermissionStatus {
        authorizationStatus = .granted
        return authorizationStatus
    }

    func listen(expected: String) -> AsyncStream<String> {
        stopListening()
        let words = expected.split(separator: " ").map(String.init)
        let interval = wordInterval
        return AsyncStream { continuation in
            let task = Task {
                for count in 1...max(words.count, 1) {
                    try? await Task.sleep(for: interval)
                    if Task.isCancelled { break }
                    continuation.yield(words.prefix(count).joined(separator: " "))
                }
                continuation.finish()
            }
            self.task = task
            continuation.onTermination = { _ in task.cancel() }
        }
    }

    func stopListening() {
        task?.cancel()
        task = nil
    }
}
