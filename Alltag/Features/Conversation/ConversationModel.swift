//
//  ConversationModel.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import Observation
import SwiftData

/// The conversation state machine:
///
///     idle ─tap→ listening ─(all words / tap)→ thinking → speaking → idle … → finished
///
/// Speech, the companion's replies and the voice come from services, so the
/// same model runs simulated today and live later.
@Observable
final class ConversationModel {
    enum Mode: Equatable {
        case voice
        case text
    }

    /// A line in the transcript.
    struct Message: Identifiable, Equatable {
        let id = UUID()
        let line: ConversationLine
        /// The learner typed their own sentence instead of the scripted one.
        var isCustom = false
    }

    /// Pauses between steps. Zero in tests.
    struct Timing {
        /// After the last word is heard, before thinking starts.
        var afterListening: Duration = .milliseconds(450)
        /// After the companion's last line, before the summary.
        var beforeFinish: Duration = .milliseconds(900)

        static let instant = Timing(afterListening: .zero, beforeFinish: .zero)
    }

    let scenario: Scenario
    private(set) var messages: [Message] = []
    private(set) var phase: VoiceOrbState = .idle
    /// What has been heard so far of the current learner line.
    private(set) var heardText = ""
    private(set) var isFinished = false
    /// Index of the next learner turn (0-based).
    private(set) var learnerTurn = 0
    var mode: Mode = .voice
    var showsHint = false
    /// The text field in text mode.
    var draft = ""
    /// Shown as a toast, e.g. when nothing was heard.
    var notice: ToastMessage?
    /// Slower speech (Settings · Accessibility).
    var speechRate: SpeechRate = .normal

    private let speech: any SpeechService
    private let companion: any CompanionService
    private let voice: any VoiceService
    private let timing: Timing
    @ObservationIgnored private var listenTask: Task<Void, Never>?

    init(scenario: Scenario, services: AppServices, timing: Timing = Timing()) {
        self.scenario = scenario
        self.speech = services.speech
        self.companion = services.companion
        self.voice = services.voice
        self.timing = timing
        if let first = scenario.script.first, first.speaker == .companion {
            messages = [Message(line: first)]
        }
    }

    // MARK: State

    /// Learner lines of the script, in order.
    private var learnerLines: [ConversationLine] { scenario.script.filter { $0.speaker == .learner } }

    /// The scripted line the learner is expected to say next, if any.
    var expectedLine: ConversationLine? {
        learnerLines.indices.contains(learnerTurn) ? learnerLines[learnerTurn] : nil
    }

    /// Whether the learner can start speaking or send text now.
    var canRespond: Bool { phase == .idle && !isFinished && expectedLine != nil }

    /// Under the orb: "Tap to speak", "Listening… tap when done", …
    var stateLabel: LocalizedStringResource? {
        switch phase {
        case .idle: isFinished ? nil : "Tap to speak"
        case .listening: "Listening… tap when done"
        case .thinking: "Thinking…"
        case .speaking: "Speaking…"
        }
    }

    // MARK: Summary

    var turnCount: Int { messages.filter { $0.line.speaker == .learner }.count }
    var fixCount: Int { messages.filter { $0.line.feedback?.kind == .fix }.count }
    var savedPhraseCount: Int { scenario.savedPhrases.count }

    // MARK: Actions

    /// The orb: starts listening, or stops listening early.
    func orbTapped() {
        switch phase {
        case .listening:
            // The listening task notices the stream ending and finishes the turn.
            speech.stopListening()
        case .idle where canRespond:
            showsHint = false
            listenTask = Task { await listen() }
        default:
            break
        }
    }

    /// Text mode: sends the draft. An empty draft or the scripted line counts as
    /// the script; anything else is the learner's own sentence.
    func send() async {
        guard canRespond, let line = expectedLine else { return }
        let text = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        draft = ""
        let isCustom = !text.isEmpty && Self.normalized(text) != Self.normalized(line.german)
        await finishTurn(saying: isCustom ? text : line.german, isCustom: isCustom)
    }

    /// Saves the scenario's phrases to Memory, skipping ones already there.
    /// Returns how many were added.
    @discardableResult
    func savePhrases(in context: ModelContext) -> Int {
        let existing = Set(((try? context.fetch(FetchDescriptor<MemoryItem>())) ?? []).map { $0.word.lowercased() })
        let new = scenario.savedPhrases.filter { !existing.contains($0.german.lowercased()) }
        for phrase in new {
            let example = scenario.script.first { $0.speaker == .learner && $0.german.localizedCaseInsensitiveContains(phrase.german) }
            context.insert(MemoryItem(word: phrase.german, meaning: phrase.english,
                                      context: example?.german ?? "", contextNote: example?.english ?? "",
                                      kind: .saved, source: .conversation, sourceDetail: scenario.title))
        }
        try? context.save()
        return new.count
    }

    /// Stops listening and speaking, e.g. when the conversation is closed.
    func stop() {
        listenTask?.cancel()
        speech.stopListening()
        voice.stop()
    }

    /// Waits for a running listen–reply cycle to complete (used by tests).
    func waitForTurn() async {
        await listenTask?.value
    }

    // MARK: Flow

    private func listen() async {
        guard let line = expectedLine else { return }
        phase = .listening
        heardText = ""
        do {
            for try await partial in speech.listen(expected: line.german) {
                heardText = partial
            }
        } catch {
            stopListening(notice: notice(for: error))
            return
        }
        guard !Task.isCancelled else { return }

        let heard = heardText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !heard.isEmpty else {
            stopListening(notice: ToastMessage(text: "I didn't catch that. Tap and try again.", systemImage: "ear"))
            return
        }
        let isScripted = Self.isScripted(heard, line.german)
        if heard == line.german {
            try? await Task.sleep(for: timing.afterListening)
        }
        await finishTurn(saying: isScripted ? line.german : heard, isCustom: !isScripted)
    }

    private func stopListening(notice: ToastMessage) {
        phase = .idle
        heardText = ""
        self.notice = notice
    }

    /// When listening isn't possible, the keyboard takes over.
    private func notice(for error: any Error) -> ToastMessage {
        mode = .text
        let text: LocalizedStringResource = (error as? SpeechError) == .notAuthorized
            ? "Allow the microphone and speech recognition in the Settings app to speak. You can type for now."
            : "Speech recognition isn't available right now. You can type instead."
        return ToastMessage(text: text, systemImage: "mic.slash")
    }

    private func finishTurn(saying text: String, isCustom: Bool) async {
        guard let line = expectedLine else { return }
        phase = .thinking
        heardText = ""

        let response = try? await companion.respond(to: text, in: scenario, turn: learnerTurn)
        var said = ConversationLine(speaker: .learner, german: text, english: line.english, feedback: response?.feedback)
        if isCustom {
            let own = try? await companion.feedback(on: text, in: scenario, turn: learnerTurn)
            said = ConversationLine(speaker: .learner, german: text, english: own?.english ?? "",
                                    feedback: own?.feedback ?? MockCompanionService.ownSentenceNote)
        }
        messages.append(Message(line: said, isCustom: isCustom))
        learnerTurn += 1

        guard let reply = response?.reply else {
            phase = .idle
            isFinished = true
            return
        }
        messages.append(Message(line: reply))
        phase = .speaking
        await voice.speak(reply.german, rate: speechRate)
        phase = .idle

        if expectedLine == nil {
            try? await Task.sleep(for: timing.beforeFinish)
            isFinished = true
        }
    }

    /// Whether what was heard is close enough to the scripted line to count as
    /// it: at least 80% of its words, in any order. Recognition can drop a short
    /// word or write numbers as digits, so an exact match would be too strict.
    static func isScripted(_ heard: String, _ line: String) -> Bool {
        let expected = normalized(line).split(separator: " ")
        guard !expected.isEmpty else { return false }
        var heardWords = normalized(heard).split(separator: " ")
        var found = 0
        for word in expected {
            if let index = heardWords.firstIndex(of: word) {
                heardWords.remove(at: index)
                found += 1
            }
        }
        return Double(found) / Double(expected.count) >= 0.8 && heardWords.count <= 2
    }

    /// Lowercased letters, digits and spaces only, for comparing sentences.
    static func normalized(_ text: String) -> String {
        text.lowercased()
            .filter { $0.isLetter || $0.isNumber || $0 == " " }
            .trimmingCharacters(in: .whitespaces)
    }
}
