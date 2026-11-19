//
//  GeminiLiveConversationService.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 14.11.26.
//

import Foundation
import OSLog

/// The live voice with Google's Gemini Live API (#309), chosen over OpenAI's Realtime
/// for its sound and its price. The `gemini-live-session` Edge Function hands out a short-lived token that
/// is locked to the model, the voice, the instructions and the thinking pause, so this
/// side only connects, sends the microphone and plays what comes back.
struct GeminiLiveConversationService: RealtimeConversationService {
    private let client = SupabaseRealtimeClient.shared

    func makeSession(for context: RealtimeConversationContext) -> any RealtimeConversationSession {
        GeminiLiveSession(context: context, credentials: client.geminiCredentials, audio: SystemRealtimeAudio())
    }
}

/// What `gemini-live-session` answers with.
struct GeminiLiveCredentials: Decodable {
    let token: String
    let expiresAt: TimeInterval
    let model: String
    let voice: String

    enum CodingKeys: String, CodingKey {
        case token, model, voice
        case expiresAt = "expires_at"
    }
}

final class GeminiLiveSession: RealtimeConversationSession {
    typealias Credentials = (RealtimeConversationContext) async throws -> GeminiLiveCredentials
    typealias Connect = @MainActor (URLRequest) -> any RealtimeSocket

    /// The learner's line being heard: its row, what was heard so far, and whether
    /// the companion's answer has ended, so the next words start a new line.
    private struct LearnerLine {
        let id: String
        var text = ""
        var isClosed = false
    }

    private let context: RealtimeConversationContext
    private let credentials: Credentials
    private let audio: any RealtimeAudio
    private let connect: Connect
    private let logger = Logger(subsystem: "Alltag", category: "Realtime")
    private var socket: (any RealtimeSocket)?
    private var upload: Task<Void, Never>?
    private var isStopped = false
    private var isResponding = false
    private var isListening = false
    /// Hold to talk: the learner is holding the orb.
    private var isHolding = false
    /// Hold to talk: Gemini was told the turn started, so the microphone goes out.
    private var isTurnOpen = false
    /// Hold to talk: the start and end of turns, sent one after the other.
    private var turnMessages: Task<Void, Never>?
    private var emit: ((RealtimeConversationEvent) -> Void)?
    private var turns = 0
    /// The companion's line being spoken, if one is.
    private var companionItem: String?
    private var learner: LearnerLine?

    init(context: RealtimeConversationContext, credentials: @escaping Credentials, audio: any RealtimeAudio,
         connect: Connect? = nil) {
        self.context = context
        self.credentials = credentials
        self.audio = audio
        self.connect = connect ?? { URLSessionRealtimeSocket(request: $0) }
    }

    func run(emit: @escaping (RealtimeConversationEvent) -> Void) async throws {
        defer { stop() }
        guard !isStopped else { throw RealtimeServiceError.unavailable }
        guard await audio.requestPermission() else { throw RealtimeServiceError.microphoneDenied }
        try checkRunning()
        let ticket = try await credentials(context)
        try checkRunning()
        let socket = connect(try Self.request(for: ticket))
        self.socket = socket

        try await configure(socket, model: ticket.model)
        try checkRunning()
        let samples = try await audio.start()
        self.emit = emit
        // The model waits to be spoken to. A line of text makes it open the conversation,
        // as its instructions say; it is not shown and not spoken. Holding to talk, Gemini
        // doesn't listen for pauses, so the line is marked as a whole turn.
        let opening = Self.opening(history: context.history)
        if context.holdsToTalk {
            let turn: [[String: Any]] = [Self.activity(.start), ["realtimeInput": ["text": opening]], Self.activity(.end)]
            for message in turn { try await send(message, over: socket) }
        } else {
            try await send(["realtimeInput": ["text": opening]], over: socket)
        }
        try checkRunning()

        upload = Task {
            do {
                for try await chunk in samples {
                    try checkRunning()
                    // Holding to talk, only what is said while the orb is held goes out.
                    if context.holdsToTalk, !isTurnOpen { continue }
                    let audio = ["data": chunk.base64EncodedString(), "mimeType": Self.inputFormat]
                    try await send(["realtimeInput": ["audio": audio]], over: socket)
                }
            } catch {
                socket.close()
            }
        }
        while !isStopped {
            let message = try GeminiLiveMessage(await socket.receive())
            try checkRunning()
            try handle(message, emit: emit)
        }
    }

    func beginTurn() {
        guard context.holdsToTalk, !isStopped, !isHolding, let socket, let emit else { return }
        isHolding = true
        // Talking over the companion stops it, as when Gemini hears it in hands-free.
        if let cut = audio.interrupt() { emit(.interruptTranscript(id: cut.item)) }
        endCompanionTurn()
        emit(.phase(.listening))
        let previous = turnMessages
        turnMessages = Task {
            await previous?.value
            try? await send(Self.activity(.start), over: socket)
            // Only now does the microphone go out, so it can't arrive before the start.
            isTurnOpen = isHolding && !isStopped
        }
    }

    func endTurn() {
        guard context.holdsToTalk, isHolding, let socket, let emit else { return }
        isHolding = false
        isTurnOpen = false
        emit(.phase(.thinking))
        let previous = turnMessages
        turnMessages = Task {
            await previous?.value
            try? await send(Self.activity(.end), over: socket)
        }
    }

    func stop() {
        guard !isStopped else { return }
        isStopped = true
        emit = nil
        turnMessages?.cancel()
        upload?.cancel()
        upload = nil
        socket?.close()
        socket = nil
        audio.stop()
    }

    static let opening = "(The learner has joined. Begin.)"

    /// The hidden line that opens the conversation. Reconnecting, it carries what was said,
    /// so the companion carries on instead of greeting again.
    static func opening(history: String) -> String {
        guard !history.isEmpty else { return opening }
        return "(The conversation so far:\n\(history)\nThe connection was renewed. Carry on from here; don't greet again.)"
    }

    private enum Activity { case start, end }

    /// Hold to talk: marks where the learner's turn starts and ends.
    private static func activity(_ activity: Activity) -> [String: Any] {
        ["realtimeInput": [activity == .start ? "activityStart" : "activityEnd": [String: Any]()]]
    }

    /// The microphone's format. Gemini listens at 16 kHz and resamples what says otherwise.
    static let inputFormat = "audio/pcm;rate=\(SystemRealtimeAudio.sampleRate)"

    /// The token carries the whole setup; the first message only names the model.
    private func configure(_ socket: any RealtimeSocket, model: String) async throws {
        let timeout = Task {
            do {
                try await Task.sleep(for: .seconds(15))
                socket.close()
            } catch {
                return
            }
        }
        defer { timeout.cancel() }
        try await send(["setup": ["model": "models/\(model)"]], over: socket)
        while try GeminiLiveMessage(await socket.receive()).isSetupComplete == false {
            try checkRunning()
        }
    }

    private func handle(_ message: GeminiLiveMessage, emit: @escaping (RealtimeConversationEvent) -> Void) throws {
        switch message.activity {
        case .started:
            isListening = true
            emit(.phase(.listening))
        case .ended:
            isListening = false
            emit(.phase(.thinking))
        case nil:
            break
        }
        if message.secondsLeft != nil { logger.info("Gemini Live is about to end the connection") }
        // The learner talked over the companion: its line stops where it was heard.
        if message.isInterrupted {
            if let cut = audio.interrupt() { emit(.interruptTranscript(id: cut.item)) }
            endCompanionTurn()
            emit(.phase(.listening))
        }
        if let heard = message.heard, !heard.isEmpty { hear(heard, emit: emit) }
        // Holding to talk over the companion: what it still sends of the cut answer isn't played.
        if !isHolding, !message.audio.isEmpty || message.spoken != nil {
            let item = beginCompanionTurn(emit: emit)
            for chunk in message.audio {
                try audio.play(chunk, item: item) { [weak self] in self?.finishPlayback(emit: emit) }
                emit(.phase(.speaking))
            }
            if let spoken = message.spoken, !spoken.isEmpty {
                emit(.transcript(id: item, speaker: .companion, text: spoken, replacesPrevious: false))
            }
        }
        if message.isTurnComplete {
            endCompanionTurn()
            finishPlayback(emit: emit)
        }
    }

    /// The learner's words arrive in pieces, without a last one that says "complete".
    private func hear(_ text: String, emit: (RealtimeConversationEvent) -> Void) {
        if learner == nil || learner?.isClosed == true {
            turns += 1
            learner = LearnerLine(id: "gemini-learner-\(turns)")
        }
        guard var line = learner else { return }
        line.text += text
        learner = line
        if isResponding {
            // Late words, after the answer began: the line was final already, so replace it whole.
            emit(.transcript(id: line.id, speaker: .learner, text: line.text.trimmed, replacesPrevious: true))
        } else {
            emit(.transcript(id: line.id, speaker: .learner, text: text, replacesPrevious: false))
        }
    }

    /// The companion starts to answer, so what the learner said is final and can be checked.
    private func beginCompanionTurn(emit: (RealtimeConversationEvent) -> Void) -> String {
        if let companionItem { return companionItem }
        turns += 1
        let item = "gemini-companion-\(turns)"
        companionItem = item
        isResponding = true
        if let line = learner, !line.isClosed, !line.text.trimmed.isEmpty {
            emit(.transcript(id: line.id, speaker: .learner, text: line.text.trimmed, replacesPrevious: true))
        }
        return item
    }

    private func endCompanionTurn() {
        guard companionItem != nil else { return }
        companionItem = nil
        isResponding = false
        learner?.isClosed = true
    }

    private func finishPlayback(emit: (RealtimeConversationEvent) -> Void) {
        guard !isStopped, !isResponding, !isListening, !isHolding, !audio.hasPlayback else { return }
        // Holding to talk, the companion waits for the orb to be held again.
        emit(.phase(context.holdsToTalk ? .idle : .listening))
    }

    private func checkRunning() throws {
        try Task.checkCancellation()
        if isStopped { throw CancellationError() }
    }

    private func send(_ message: [String: Any], over socket: any RealtimeSocket) async throws {
        try await socket.send(JSONSerialization.data(withJSONObject: message))
    }

    private static let endpoint = "wss://generativelanguage.googleapis.com/ws/"
        + "google.ai.generativelanguage.v1beta.GenerativeService.BidiGenerateContentConstrained"

    static func request(for ticket: GeminiLiveCredentials) throws -> URLRequest {
        guard ticket.expiresAt > Date.now.timeIntervalSince1970,
              let url = URL(string: endpoint)?.appending(queryItems: [URLQueryItem(name: "access_token", value: ticket.token)]) else {
            throw RealtimeServiceError.unexpectedResponse
        }
        return URLRequest(url: url)
    }
}

private extension String {
    var trimmed: String { trimmingCharacters(in: .whitespacesAndNewlines) }
}
