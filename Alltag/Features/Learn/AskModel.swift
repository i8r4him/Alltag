//
//  AskModel.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 14.11.26.
//

import Foundation
import Observation

/// "How do I say …?" answered where it is asked, on Learn. It is Translate's
/// model underneath; this adds when the server is asked: only when the
/// learner sends, never while they type.
@Observable
final class AskModel {
    /// The translation, its states, Listen and saving.
    let translate: TranslateModel
    /// Counts the questions sent, for the haptic.
    private(set) var sent = 0
    @ObservationIgnored private var task: Task<Void, Never>?

    init(services: AppServices, defaults: UserDefaults = .standard) {
        translate = TranslateModel(text: nil, services: services, defaults: defaults)
    }

    var text: String {
        get { translate.input }
        set { translate.input = newValue }
    }

    private var isEmpty: Bool { text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    var canSend: Bool { !isEmpty && !translate.isTranslating }
    /// Something to show under the field: the wait, the answer, or why there is none.
    var hasAnswer: Bool { translate.hasAttempted }
    /// Asked, and nothing came back: no answer and no failure either.
    var foundNothing: Bool {
        translate.hasAttempted && !translate.isTranslating && translate.result == nil
            && translate.failure == nil && translate.missingLanguages == nil
    }

    /// The words changed: what was shown answered other words. Asks nothing.
    func textChanged() {
        task?.cancel()
        translate.clearResult()
    }

    /// Asks the server for what is in the field. Returns the request, for tests to wait on.
    @discardableResult
    func send() -> Task<Void, Never>? {
        guard canSend else { return nil }
        task?.cancel()
        sent += 1
        let request = Task { await translate.translate() }
        task = request
        return request
    }

    /// Empties the field and takes the answer away, ready for the next question.
    func clear() {
        text = ""
        textChanged()
    }
}
