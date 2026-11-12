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
/// The scripted and live voice paths share the transcript and controls.
@Observable
final class ConversationModel {
    enum Mode: Equatable {
        case voice
        case text
    }

    /// A line in the transcript.
    struct Message: Identifiable, Equatable {
        let id = UUID()
        var line: ConversationLine
        /// The learner typed their own sentence instead of the scripted one.
        var isCustom = false
        var realtimeID: String?
    }

    /// Pauses between steps. Zero in tests.
    struct Timing {
        /// After the last word is heard, before thinking starts.
        var afterListening: Duration = .milliseconds(450)
        /// After the companion's last line, before the summary.
        var beforeFinish: Duration = .milliseconds(900)
        var realtimeLimit: Duration = .seconds(600)

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
    var mode: Mode = .voice {
        didSet {
            if mode == .text, isUsingCloudVoice { fallBackFromCloud() }
        }
    }
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
    private let realtime: any RealtimeConversationService
    private let level: Level
    private var usesCloudVoice: Bool
    private var hasFallenBack = false
    private var cloudSession: (any RealtimeConversationSession)?
    /// The live voice has been asked for but hasn't said or heard anything yet.
    private(set) var isConnecting = false
    /// Free talk was refused because today's live conversations are used up.
    private(set) var hasReachedLimit = false
    private(set) var finishedLiveConversation = false
    /// Checking a finished live conversation for mistakes.
    private(set) var liveReview: LiveReview = .none
    @ObservationIgnored private lazy var reviewer = LineReviewer(companion: companion, scenario: scenario)

    enum LiveReview: Equatable {
        case none
        case reviewing
        case done
    }
    @ObservationIgnored private var listenTask: Task<Void, Never>?
    @ObservationIgnored private var cloudTask: Task<Void, Never>?
    @ObservationIgnored private var cloudDeadline: Task<Void, Never>?
    /// When the learner started talking, and when the conversation ended,
    /// for the minutes practised.
    @ObservationIgnored private(set) var startedAt: Date?
    @ObservationIgnored private(set) var endedAt: Date?
    @ObservationIgnored var hasRecordedPractice = false
    /// The saved copy of this conversation (see `ConversationModel+History.swift`).
    @ObservationIgnored var sessionRecord: SessionRecord?

    init(scenario: Scenario, services: AppServices, timing: Timing = Timing(), usesCloudVoice: Bool = false, level: Level = .a1) {
        self.scenario = scenario
        self.speech = services.speech
        self.companion = services.companion
        self.voice = services.voice
        self.timing = timing
        self.realtime = services.realtime
        self.usesCloudVoice = usesCloudVoice
        self.level = level
        if let first = scenario.script.first, first.speaker == .companion {
            messages = [Message(line: first)]
        }
    }

    // MARK: State

    /// Learner lines of the script, in order.
    private var learnerLines: [ConversationLine] { scenario.script.filter { $0.speaker == .learner } }

    /// The scripted line the learner is expected to say next, if any.
    var expectedLine: ConversationLine? {
        !isUsingCloudVoice && learnerLines.indices.contains(learnerTurn) ? learnerLines[learnerTurn] : nil
    }

    var isUsingCloudVoice: Bool { cloudSession != nil }

    /// Whether the learner can start speaking or send text now. Free talk has
    /// no script, so it can only start the live voice.
    var canRespond: Bool {
        phase == .idle && !isFinished && (expectedLine != nil || (scenario.isLiveOnly && canStartCloudVoice))
    }

    /// Free talk needs the live voice, which the learner hasn't allowed yet.
    var needsCloudConsent: Bool { scenario.isLiveOnly && !usesCloudVoice }

    private var canStartCloudVoice: Bool { usesCloudVoice && !hasFallenBack && mode == .voice }

    /// Under the orb: "Tap to speak", "Listening… tap when done", …
    var stateLabel: LocalizedStringResource? {
        if isUsingCloudVoice {
            if isConnecting { return "Connecting…" }
            switch phase {
            case .idle, .listening: return "Live voice · Tap to finish"
            case .thinking: return "Thinking…"
            case .speaking: return "Speaking…"
            }
        }
        switch phase {
        case .idle where isFinished || needsCloudConsent: return nil
        case .idle: return canStartCloudVoice ? "Tap for live voice" : "Tap to speak"
        case .listening: return "Listening… tap when done"
        case .thinking: return "Thinking…"
        case .speaking: return "Speaking…"
        }
    }

    // MARK: Summary

    var turnCount: Int { messages.filter { $0.line.speaker == .learner && !$0.line.german.isEmpty }.count }
    var fixCount: Int { messages.filter { $0.line.feedback?.kind == .fix }.count }
    var savedPhraseCount: Int { scenario.savedPhrases.count }

    // MARK: Actions

    /// The orb: starts listening, or stops listening early.
    func orbTapped() {
        if isUsingCloudVoice {
            finishCloudConversation()
            return
        }
        switch phase {
        case .listening:
            // The listening task notices the stream ending and finishes the turn.
            speech.stopListening()
        case .idle where canRespond:
            startedAt = startedAt ?? .now
            showsHint = false
            if canStartCloudVoice {
                startCloudConversation()
            } else {
                listenTask = Task { await listen() }
            }
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

    /// Saves each fix the learner got to Memory › Mistakes, skipping ones already there.
    /// Returns how many were added.
    @discardableResult
    func saveMistakes(in context: ModelContext) -> Int {
        let items = messages.compactMap { message -> MemoryItem? in
            guard message.line.speaker == .learner, let feedback = message.line.feedback else { return nil }
            return MistakePractice.item(said: message.line.german, feedback: feedback, scenario: scenario)
        }
        return MistakePractice.save(items, in: context)
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
        endedAt = endedAt ?? .now
        reviewer.cancel()
        endCloudSession()
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
            let previous = messages.last { $0.line.speaker == .companion }?.line.german
            let own = try? await companion.feedback(on: text, in: scenario, replyingTo: previous)
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
            endedAt = endedAt ?? .now
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

extension ConversationModel {
    func setCloudVoiceConsent(_ allowed: Bool) {
        usesCloudVoice = allowed
        if !allowed, isUsingCloudVoice { fallBackFromCloud() }
    }

    func suspendCloudVoice() {
        if isUsingCloudVoice { fallBackFromCloud() }
    }

    func waitForCloudConversation() async {
        await cloudTask?.value
    }

    /// Waits for the check of a finished live conversation (used by tests).
    func waitForReview() async {
        await reviewer.wait()
    }

    private func startCloudConversation() {
        let context = RealtimeConversationContext(scenario: scenario, level: level,
                                                  slowerSpeech: speechRate == .slow || voice.prefersSlowerSpeech)
        let session = realtime.makeSession(for: context)
        cloudSession = session
        if messages.count == 1, messages[0].realtimeID == nil { messages.removeAll() }
        phase = .thinking
        isConnecting = true
        notice = nil
        cloudTask = Task { [weak self, session] in
            do {
                try await session.run { [weak self, weak session = session] event in
                    guard let self, let session, cloudSession === session else { return }
                    applyCloudEvent(event)
                }
                self?.cloudFailed(RealtimeServiceError.unavailable, session: session)
            } catch {
                self?.cloudFailed(error, session: session)
            }
        }
        let limit = timing.realtimeLimit
        cloudDeadline = Task { [weak self] in
            do {
                try await Task.sleep(for: limit)
                guard let self, cloudSession === session else { return }
                finishCloudConversation()
                notice = ToastMessage(text: "Live voice has reached its 10-minute limit.", systemImage: "timer")
            } catch {
                return
            }
        }
    }

    private func applyCloudEvent(_ event: RealtimeConversationEvent) {
        isConnecting = false
        switch event {
        case .phase(let phase):
            self.phase = phase
        case let .transcript(id, speaker, text, replacesPrevious):
            if let index = messages.firstIndex(where: { $0.realtimeID == id }) {
                let german = replacesPrevious ? text : messages[index].line.german + text
                messages[index].line = ConversationLine(speaker: speaker, german: german, english: "", feedback: nil)
            } else {
                let line = ConversationLine(speaker: speaker, german: text, english: "", feedback: nil)
                messages.append(Message(line: line, realtimeID: id))
            }
            // A learner line that replaces its drafts is final: check it while they talk on.
            if speaker == .learner, replacesPrevious, let message = messages.first(where: { $0.realtimeID == id }) {
                review(message)
            }
        case .interruptTranscript(let id):
            guard let index = messages.firstIndex(where: { $0.realtimeID == id }) else { return }
            let line = messages[index].line
            let text = line.german.trimmingCharacters(in: .whitespaces)
            guard !text.isEmpty, !".?!…".contains(text.last ?? ".") else { return }
            messages[index].line = ConversationLine(speaker: line.speaker, german: text + "…", english: "", feedback: nil)
        }
    }

    private func cloudFailed(_ error: any Error, session: any RealtimeConversationSession) {
        guard cloudSession === session else { return }
        fallBackFromCloud()
        let reason = error as? RealtimeServiceError
        // Free talk has no script to fall back to, so the limit gets its own screen.
        hasReachedLimit = scenario.isLiveOnly && reason == .dailyLimit
        guard !hasReachedLimit else { return }
        notice = ToastMessage(text: LiveVoiceNotice.text(for: reason, freeTalk: scenario.isLiveOnly),
                              systemImage: "waveform.slash")
    }

    private func fallBackFromCloud() {
        // Free talk has no script to fall back to, so the orb can try again.
        hasFallenBack = !scenario.isLiveOnly
        endCloudSession()
        if let first = scenario.script.first, first.speaker == .companion, messages.last?.line != first {
            messages.append(Message(line: first))
        }
    }

    private func finishCloudConversation() {
        endedAt = endedAt ?? .now
        endCloudSession()
        hasFallenBack = true
        finishedLiveConversation = true
        if companion.usesOnDeviceModel, turnCount > 0 {
            // Lines whose final transcript never arrived are checked now.
            for message in messages where message.line.speaker == .learner { review(message) }
            reviewProgressed()
        }
        isFinished = true
    }

    // MARK: Checking a live conversation

    /// Hands a learner line to the reviewer.
    private func review(_ message: Message) {
        guard let index = messages.firstIndex(where: { $0.id == message.id }) else { return }
        let previous = messages[..<index].last { $0.line.speaker == .companion }?.line.german
        reviewer.onProgress = { [weak self] in self?.reviewProgressed() }
        reviewer.check(id: message.id, german: message.line.german, replyingTo: previous)
    }

    /// Shows the checked lines' feedback, but only once they've stopped talking.
    private func reviewProgressed() {
        guard finishedLiveConversation else { return }
        for index in messages.indices {
            let line = messages[index].line
            guard line.feedback == nil, let checked = reviewer.results[messages[index].id],
                  checked.german == line.german else { continue }
            messages[index].line = ConversationLine(speaker: .learner, german: line.german,
                                                    english: checked.english, feedback: checked.feedback)
        }
        liveReview = reviewer.isBusy ? .reviewing : .done
    }

    private func endCloudSession() {
        guard let session = cloudSession else { return }
        cloudSession = nil
        session.stop()
        cloudTask?.cancel()
        cloudTask = nil
        cloudDeadline?.cancel()
        cloudDeadline = nil
        isConnecting = false
        messages.removeAll { $0.line.german.isEmpty }
        phase = .idle
    }
}
