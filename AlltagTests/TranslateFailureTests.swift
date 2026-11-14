//
//  TranslateFailureTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import Testing
@testable import Alltag

/// Fails every translation with the given error.
private final class FailingTranslation: TranslationService {
    let error: any Error
    init(_ error: any Error) { self.error = error }

    func translate(_ text: String) async throws -> TranslationResult? { throw error }
    func explain(_ result: TranslationResult) async -> TranslationResult { result }
}

@MainActor
struct TranslateFailureTests {
    private func model(failingWith error: any Error) -> TranslateModel {
        let mock = AppServices.mock()
        let services = AppServices(speech: mock.speech, voice: mock.voice, translation: FailingTranslation(error),
                                   companion: mock.companion, calendar: mock.calendar, notifications: mock.notifications)
        return TranslateModel(text: "I will call you later", services: services)
    }

    @Test("Translate says why it failed, and a new text clears it",
          arguments: [(URLError(.notConnectedToInternet) as any Error, CloudFailure.offline),
                      (RealtimeServiceError.unavailable, .cloudOff),
                      (RealtimeServiceError.dailyLimit, .dailyLimit),
                      (RealtimeServiceError.upstream, .other)])
    func failure(error: any Error, expected: CloudFailure) async {
        let model = model(failingWith: error)
        await model.translate()
        #expect(model.result == nil)
        #expect(model.failure == expected)

        model.clearResult()
        #expect(model.failure == nil)
    }
}
