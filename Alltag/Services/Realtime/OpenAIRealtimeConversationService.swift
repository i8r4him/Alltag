//
//  OpenAIRealtimeConversationService.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import OSLog

struct OpenAIRealtimeConversationService: RealtimeConversationService {
    private let client = SupabaseRealtimeClient.shared

    func makeSession(for context: RealtimeConversationContext) -> any RealtimeConversationSession {
        OpenAIRealtimeSession(context: context, credentials: client.credentials, audio: SystemRealtimeAudio())
    }
}

protocol RealtimeSocket: AnyObject {
    func send(_ data: Data) async throws
    func receive() async throws -> Data
    func close()
}

private final class URLSessionRealtimeSocket: RealtimeSocket {
    private let task: URLSessionWebSocketTask

    init(request: URLRequest) {
        task = URLSession.shared.webSocketTask(with: request)
        task.resume()
    }

    func send(_ data: Data) async throws {
        guard let text = String(data: data, encoding: .utf8) else { throw RealtimeServiceError.unexpectedResponse }
        try await task.send(.string(text))
    }

    func receive() async throws -> Data {
        switch try await task.receive() {
        case .string(let text): Data(text.utf8)
        case .data(let data): data
        @unknown default: throw RealtimeServiceError.unexpectedResponse
        }
    }

    func close() {
        task.cancel(with: .normalClosure, reason: nil)
    }
}

final class OpenAIRealtimeSession: RealtimeConversationSession {
    typealias Credentials = (RealtimeConversationContext) async throws -> RealtimeCredentials
    typealias Connect = @MainActor (URLRequest) -> any RealtimeSocket

    private struct ServerEvent: Decodable {
        let type: String
        let itemID: String?
        let delta: String?
        let transcript: String?
        let response: Response?
        let error: ServerError?

        struct Response: Decodable {
            let status: String
        }

        struct ServerError: Decodable {
            let code: String?
            let message: String?
        }

        enum CodingKeys: String, CodingKey {
            case type, delta, transcript, response, error
            case itemID = "item_id"
        }
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
    private var discardedItems: Set<String> = []

    init(context: RealtimeConversationContext, credentials: @escaping Credentials, audio: any RealtimeAudio,
         connect: Connect? = nil) {
        self.context = context
        self.credentials = credentials
        self.audio = audio
        self.connect = connect ?? { URLSessionRealtimeSocket(request: $0) }
    }

    func run(emit: @escaping (RealtimeConversationEvent) -> Void) async throws {
        defer { stop() }
        guard !isStopped, await audio.requestPermission() else { throw RealtimeServiceError.unavailable }
        try checkRunning()
        let ticket = try await credentials(context)
        try checkRunning()
        let socket = connect(try Self.request(for: ticket))
        self.socket = socket

        try await configure(socket, voice: ticket.voice)
        try checkRunning()
        let samples = try await audio.start()
        try await send(["type": "response.create"], over: socket)
        try checkRunning()

        upload = Task {
            do {
                for try await chunk in samples {
                    try checkRunning()
                    try await send(["type": "input_audio_buffer.append", "audio": chunk.base64EncodedString()], over: socket)
                }
            } catch {
                socket.close()
            }
        }
        while !isStopped {
            let event = try await receive(from: socket)
            try checkRunning()
            try await handle(event, socket: socket, emit: emit)
        }
    }

    func stop() {
        guard !isStopped else { return }
        isStopped = true
        upload?.cancel()
        upload = nil
        socket?.close()
        socket = nil
        audio.stop()
    }

    private func configure(_ socket: any RealtimeSocket, voice: String) async throws {
        let timeout = Task {
            do {
                try await Task.sleep(for: .seconds(15))
                socket.close()
            } catch {
                return
            }
        }
        defer { timeout.cancel() }
        guard try await receive(from: socket, duringSetup: true).type == "session.created" else {
            throw RealtimeServiceError.unexpectedResponse
        }
        let format: [String: Any] = ["type": "audio/pcm", "rate": SystemRealtimeAudio.sampleRate]
        let input: [String: Any] = [
            "format": format,
            // The learner's mistakes have to stay in the transcript, not be tidied up.
            "transcription": ["model": "gpt-transcribe", "language": "de", "prompt": Self.transcriptionPrompt],
            "noise_reduction": ["type": "near_field"],
            "turn_detection": ["type": "semantic_vad", "eagerness": "low", "interrupt_response": true, "create_response": true]
        ]
        let output: [String: Any] = ["format": format, "voice": voice, "speed": context.slowerSpeech ? 0.8 : 1.0]
        let session: [String: Any] = ["type": "realtime", "output_modalities": ["audio"],
                                     "audio": ["input": input, "output": output]]
        try await send(["type": "session.update", "session": session], over: socket)
        while try await receive(from: socket, duringSetup: true).type != "session.updated" {
            try checkRunning()
        }
    }

    /// Tells the transcription model to write down exactly what the learner said.
    static let transcriptionPrompt = "Ein Deutschlerner spricht. Schreibe genau auf, was gesagt wird, "
        + "Wort für Wort, auch mit Grammatikfehlern. Korrigiere nichts."

    private func handle(_ event: ServerEvent, socket: any RealtimeSocket,
                        emit: @escaping (RealtimeConversationEvent) -> Void) async throws {
        switch event.type {
        case "input_audio_buffer.speech_started":
            isListening = true
            if let cut = audio.interrupt() {
                discardedItems.insert(cut.item)
                emit(.interruptTranscript(id: cut.item))
                try await send(["type": "conversation.item.truncate", "item_id": cut.item,
                                "content_index": 0, "audio_end_ms": cut.milliseconds], over: socket)
            }
            emit(.phase(.listening))
        case "input_audio_buffer.speech_stopped":
            isListening = false
            emit(.phase(.thinking))
        case "input_audio_buffer.committed":
            if let id = event.itemID { emit(.transcript(id: id, speaker: .learner, text: "", replacesPrevious: false)) }
        case "conversation.item.input_audio_transcription.delta", "conversation.item.input_audio_transcription.completed":
            emitTranscript(event, speaker: .learner, emit: emit)
        case "response.output_audio_transcript.delta", "response.output_audio_transcript.done":
            emitTranscript(event, speaker: .companion, emit: emit)
        case "response.created":
            isResponding = true
        case "response.output_audio.delta":
            guard let id = event.itemID, let delta = event.delta, let data = Data(base64Encoded: delta) else {
                throw RealtimeServiceError.unexpectedResponse
            }
            guard !discardedItems.contains(id) else { return }
            try audio.play(data, item: id) { [weak self] in self?.finishPlayback(emit: emit) }
            emit(.phase(.speaking))
        case "response.done":
            isResponding = false
            if event.response?.status == "failed" { throw RealtimeServiceError.upstream }
            finishPlayback(emit: emit)
        case "conversation.item.input_audio_transcription.failed":
            throw RealtimeServiceError.upstream
        default:
            break
        }
    }

    private func emitTranscript(_ event: ServerEvent, speaker: ConversationLine.Speaker,
                                emit: (RealtimeConversationEvent) -> Void) {
        guard let id = event.itemID, !discardedItems.contains(id), let text = event.transcript ?? event.delta else { return }
        emit(.transcript(id: id, speaker: speaker, text: text, replacesPrevious: event.transcript != nil))
    }

    private func finishPlayback(emit: (RealtimeConversationEvent) -> Void) {
        if !isStopped, !isResponding, !isListening, !audio.hasPlayback { emit(.phase(.listening)) }
    }

    private func checkRunning() throws {
        try Task.checkCancellation()
        if isStopped { throw CancellationError() }
    }

    private func receive(from socket: any RealtimeSocket, duringSetup: Bool = false) async throws -> ServerEvent {
        let event = try JSONDecoder().decode(ServerEvent.self, from: await socket.receive())
        if event.type == "error" {
            let code = event.error?.code ?? "unknown"
            let message = event.error?.message ?? "No message"
            logger.error("Realtime error (\(code, privacy: .public)): \(message, privacy: .private)")
            if duringSetup { throw RealtimeServiceError.upstream }
        }
        return event
    }

    private func send(_ event: [String: Any], over socket: any RealtimeSocket) async throws {
        try await socket.send(JSONSerialization.data(withJSONObject: event))
    }

    private static func request(for ticket: RealtimeCredentials) throws -> URLRequest {
        guard ticket.expiresAt > Date.now.timeIntervalSince1970,
              let url = URL(string: "wss://api.openai.com/v1/realtime")?
                .appending(queryItems: [URLQueryItem(name: "model", value: ticket.model)]) else {
            throw RealtimeServiceError.unexpectedResponse
        }
        var request = URLRequest(url: url)
        request.setValue("Bearer \(ticket.clientSecret)", forHTTPHeaderField: "Authorization")
        return request
    }
}
