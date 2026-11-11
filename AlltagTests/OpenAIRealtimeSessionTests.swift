//
//  OpenAIRealtimeSessionTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import Testing
@testable import Alltag

@Suite("OpenAI Realtime WebSocket", .timeLimit(.minutes(1)))
@MainActor
struct OpenAIRealtimeSessionTests {
    @Test("Streams PCM, emits both transcripts and truncates interrupted playback")
    func conversation() async throws {
        let socket = StubRealtimeSocket()
        let audio = StubRealtimeAudio()
        let session = makeSession(socket: socket, audio: audio)
        var captions: [String] = []
        var interrupted: [String] = []
        socket.onSend = { event in
            switch event["type"] as? String {
            case "session.update":
                socket.push(#"{"type":"session.updated"}"#)
            case "input_audio_buffer.append":
                socket.push(#"{"type":"input_audio_buffer.committed","item_id":"learner"}"#)
                socket.push(#"{"type":"conversation.item.input_audio_transcription.completed","item_id":"learner","transcript":"Morgen?"}"#)
                socket.push(#"{"type":"response.output_audio_transcript.delta","item_id":"reply","delta":"Ja"}"#)
                socket.push(#"{"type":"response.output_audio.delta","item_id":"reply","delta":"AQI="}"#)
                socket.push(#"{"type":"input_audio_buffer.speech_started"}"#)
            case "conversation.item.truncate":
                socket.push(#"{"type":"error","error":{"code":"invalid_request_error","message":"Audio was already truncated"}}"#)
                socket.push(#"{"type":"response.output_audio.delta","item_id":"reply","delta":"AwQ="}"#)
                socket.push(#"{"type":"response.output_audio_transcript.done","item_id":"reply","transcript":"Ja, gerne."}"#)
                socket.push(#"{"type":"input_audio_buffer.speech_stopped"}"#)
            default:
                break
            }
        }
        socket.push(#"{"type":"session.created"}"#)
        do {
            try await session.run { event in
                switch event {
                case let .transcript(_, _, text, _) where !text.isEmpty:
                    captions.append(text)
                case .interruptTranscript(let id):
                    interrupted.append(id)
                case .phase(.thinking):
                    session.stop()
                default:
                    break
                }
            }
        } catch is CancellationError {}

        #expect(captions == ["Morgen?", "Ja"])
        #expect(interrupted == ["reply"])
        #expect(audio.played == [Data([1, 2])])
        #expect(audio.stops == 1)
        #expect(socket.closes == 1)
        #expect(socket.sent.compactMap { $0["type"] as? String } == [
            "session.update", "response.create", "input_audio_buffer.append", "conversation.item.truncate"
        ])
        #expect(socket.sent.first { $0["type"] as? String == "input_audio_buffer.append" }?["audio"] as? String == "BQY=")
        let truncate = try #require(socket.sent.last)
        #expect(truncate["item_id"] as? String == "reply")
        #expect(truncate["audio_end_ms"] as? Int == 120)

        let update = try #require(socket.sent.first?["session"] as? [String: Any])
        let configuration = try #require(update["audio"] as? [String: Any])
        let input = try #require(configuration["input"] as? [String: Any])
        let format = try #require(input["format"] as? [String: Any])
        #expect(format["type"] as? String == "audio/pcm")
        #expect(format["rate"] as? Int == 24_000)
    }

    @Test("Authenticates with a bearer header and closes the transport on a setup error")
    func serverError() async throws {
        let socket = StubRealtimeSocket()
        let audio = StubRealtimeAudio()
        let session = makeSession(socket: socket, audio: audio)
        socket.push(#"{"type":"session.created"}"#)
        socket.push(#"{"type":"error","error":{"code":"invalid_request_error"}}"#)

        await #expect(throws: RealtimeServiceError.upstream) { try await session.run { _ in } }

        let request = try #require(socket.request)
        #expect(request.url?.absoluteString == "wss://api.openai.com/v1/realtime?model=server-selected-model")
        #expect(request.value(forHTTPHeaderField: "Authorization") == "Bearer ek_test")
        #expect(request.value(forHTTPHeaderField: "Sec-WebSocket-Protocol") == nil)
        #expect(socket.closes == 1)
        #expect(audio.starts == 0)
    }

    @Test("Incomplete and cancelled responses return to listening without closing the session", arguments: ["incomplete", "cancelled"])
    func unfinishedResponse(status: String) async throws {
        let socket = StubRealtimeSocket()
        let audio = StubRealtimeAudio()
        let session = makeSession(socket: socket, audio: audio)
        socket.push(#"{"type":"session.created"}"#)
        socket.push(#"{"type":"session.updated"}"#)
        socket.push(#"{"type":"response.created","response":{"status":"in_progress"}}"#)
        socket.push(#"{"type":"response.done","response":{"status":"\#(status)"}}"#)
        socket.push(#"{"type":"response.output_audio_transcript.done","item_id":"next","transcript":"Weiter."}"#)
        var isListening = false
        var nextTranscript: String?

        try await session.run { event in
            switch event {
            case .phase(.listening):
                isListening = true
            case .transcript(_, _, let text, _):
                nextTranscript = text
                session.stop()
            default:
                break
            }
        }

        #expect(isListening)
        #expect(nextTranscript == "Weiter.")
    }

    @Test("A failed response closes an established session")
    func failedResponse() async {
        let socket = StubRealtimeSocket()
        let audio = StubRealtimeAudio()
        let session = makeSession(socket: socket, audio: audio)
        socket.push(#"{"type":"session.created"}"#)
        socket.push(#"{"type":"session.updated"}"#)
        socket.push(#"{"type":"response.done","response":{"status":"failed"}}"#)

        await #expect(throws: RealtimeServiceError.upstream) { try await session.run { _ in } }

        #expect(audio.starts == 1)
        #expect(audio.stops == 1)
    }

    private func makeSession(socket: StubRealtimeSocket, audio: StubRealtimeAudio) -> OpenAIRealtimeSession {
        let context = RealtimeConversationContext(scenario: MockScenarios.dentist, level: .a2, slowerSpeech: false)
        return OpenAIRealtimeSession(
            context: context,
            credentials: { _ in
                RealtimeCredentials(clientSecret: "ek_test", expiresAt: .greatestFiniteMagnitude,
                                    model: "server-selected-model", voice: "marin")
            },
            audio: audio,
            connect: { request in
                socket.request = request
                return socket
            }
        )
    }
}

@MainActor
private final class StubRealtimeSocket: RealtimeSocket {
    private let incoming = AsyncThrowingStream.makeStream(of: Data.self)
    private var iterator: AsyncThrowingStream<Data, any Error>.Iterator?
    var request: URLRequest?
    var onSend: (([String: Any]) -> Void)?
    private(set) var sent: [[String: Any]] = []
    private(set) var closes = 0

    func push(_ event: String) { incoming.continuation.yield(Data(event.utf8)) }

    func send(_ data: Data) async throws {
        let event = try #require(try JSONSerialization.jsonObject(with: data) as? [String: Any])
        sent.append(event)
        onSend?(event)
    }

    func receive() async throws -> Data {
        var active = iterator ?? incoming.stream.makeAsyncIterator()
        defer { iterator = active }
        guard let event = try await active.next() else { throw CancellationError() }
        return event
    }

    func close() {
        closes += 1
        onSend = nil
        incoming.continuation.finish()
    }
}

@MainActor
private final class StubRealtimeAudio: RealtimeAudio {
    private(set) var starts = 0
    private(set) var stops = 0
    private(set) var played: [Data] = []
    private var item: String?
    private let samples = AsyncThrowingStream.makeStream(of: Data.self)

    var hasPlayback: Bool { item != nil }

    func requestPermission() async -> Bool { true }

    func start() async throws -> AsyncThrowingStream<Data, any Error> {
        starts += 1
        samples.continuation.yield(Data([5, 6]))
        return samples.stream
    }

    func play(_ data: Data, item: String, onPlayed: @escaping @MainActor @Sendable () -> Void) throws {
        played.append(data)
        self.item = item
    }

    func interrupt() -> (item: String, milliseconds: Int)? {
        guard let item else { return nil }
        self.item = nil
        return (item, 120)
    }

    func stop() {
        stops += 1
        samples.continuation.finish()
    }
}
