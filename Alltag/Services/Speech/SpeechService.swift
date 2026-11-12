//
//  SpeechService.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// Why listening couldn't start or stopped.
enum SpeechError: Error, Equatable {
    /// Microphone or speech recognition access was refused.
    case notAuthorized
    /// This device can't recognise German speech.
    case unsupported
}

/// Turns the learner's spoken German into text.
protocol SpeechService: AnyObject {
    var authorizationStatus: PermissionStatus { get }
    func requestAuthorization() async -> PermissionStatus
    /// Listens and yields the growing transcript until the learner stops.
    ///
    /// `expected` is the scripted line; only the simulated service uses it.
    /// Throws a `SpeechError` when listening isn't possible.
    ///
    /// With `recording`, what the microphone hears is also written to that file
    /// (AAC in an `.m4a`), so the learner can listen to themselves afterwards.
    func listen(expected: String, recordingTo recording: URL?) -> AsyncThrowingStream<String, any Error>
    /// Ends listening; the stream yields the final transcript and finishes.
    func stopListening()
}

extension SpeechService {
    /// Listens without keeping a recording.
    func listen(expected: String) -> AsyncThrowingStream<String, any Error> {
        listen(expected: expected, recordingTo: nil)
    }
}

/// Simulated recognition: reveals `expected` one word at a time (230ms per
/// word in the prototype), as if the learner were saying it. Stopping early
/// counts as having said the whole line.
@Observable
final class MockSpeechService: SpeechService {
    private(set) var authorizationStatus: PermissionStatus = .notDetermined
    @ObservationIgnored private var task: Task<Void, Never>?
    @ObservationIgnored private var finishEarly: (() -> Void)?
    private let wordInterval: Duration

    init(wordInterval: Duration = .milliseconds(230)) {
        self.wordInterval = wordInterval
    }

    func requestAuthorization() async -> PermissionStatus {
        authorizationStatus = .granted
        return authorizationStatus
    }

    /// Nothing is recorded: there is no microphone behind the simulated speech.
    func listen(expected: String, recordingTo recording: URL?) -> AsyncThrowingStream<String, any Error> {
        cancel()
        let words = expected.split(separator: " ").map(String.init)
        let interval = wordInterval
        let (stream, continuation) = AsyncThrowingStream.makeStream(of: String.self)
        task = Task {
            for count in 1...max(words.count, 1) {
                try? await Task.sleep(for: interval)
                if Task.isCancelled { return }
                continuation.yield(words.prefix(count).joined(separator: " "))
            }
            continuation.finish()
        }
        finishEarly = {
            continuation.yield(expected)
            continuation.finish()
        }
        continuation.onTermination = { [task] _ in task?.cancel() }
        return stream
    }

    func stopListening() {
        let finish = finishEarly
        cancel()
        finish?()
    }

    private func cancel() {
        task?.cancel()
        task = nil
        finishEarly = nil
    }
}
