//
//  GeminiLiveTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 14.11.26.
//

import Foundation
import Testing
@testable import Alltag

/// Plays a scripted Gemini Live server: hands out its messages in order, then fails
/// like a closed connection. Keeps what the app sent.
private final class ScriptedSocket: RealtimeSocket {
    private var incoming: [Data]
    private(set) var sent: [[String: Any]] = []
    private(set) var isClosed = false

    init(_ messages: [String]) {
        incoming = messages.map { Data($0.utf8) }
    }

    func send(_ data: Data) async throws {
        sent.append((try JSONSerialization.jsonObject(with: data) as? [String: Any]) ?? [:])
    }

    func receive() async throws -> Data {
        await Task.yield()
        guard !incoming.isEmpty else { throw RealtimeServiceError.unavailable }
        return incoming.removeFirst()
    }

    func close() { isClosed = true }
}

/// A silent microphone and speaker that remember what was played.
private final class SilentAudio: RealtimeAudio {
    private(set) var played: [(data: Data, item: String)] = []
    var microphone: [Data] = []
    var hasPlayback: Bool { false }

    func requestPermission() async -> Bool { true }

    func start() async throws -> AsyncThrowingStream<Data, any Error> {
        AsyncThrowingStream { continuation in
            for chunk in microphone { continuation.yield(chunk) }
        }
    }

    func play(_ data: Data, item: String, onPlayed: @escaping @MainActor @Sendable () -> Void) throws {
        played.append((data, item))
    }

    func interrupt() -> (item: String, milliseconds: Int)? {
        played.last.map { ($0.item, 400) }
    }

    func stop() {}
}

@Suite("Live voice with Gemini")
@MainActor
struct GeminiLiveTests {
    static let ticket = GeminiLiveCredentials(token: "auth_tokens/abc", expiresAt: Date.now.timeIntervalSince1970 + 600,
                                              model: "gemini-3.8-live", voice: "Kore")
    static let voice = Data([1, 2, 3, 4]).base64EncodedString()

    static func says(_ text: String, audio: Bool = true) -> String {
        let part = audio ? #""modelTurn":{"parts":[{"inlineData":{"mimeType":"audio/pcm;rate=24000","data":"\#(voice)"}}]},"# : ""
        return #"{"serverContent":{\#(part)"outputTranscription":{"text":"\#(text)"}}}"#
    }

    /// Runs a session against `script` and returns the events it emitted.
    private func run(_ script: [String], audio: SilentAudio? = nil,
                     holdsToTalk: Bool = false) async -> ([RealtimeConversationEvent], ScriptedSocket) {
        let socket = ScriptedSocket(script)
        let audio = audio ?? SilentAudio()
        var context = RealtimeConversationContext(scenario: MockScenarios.all[0], level: .a2, slowerSpeech: false)
        context.holdsToTalk = holdsToTalk
        let session = GeminiLiveSession(context: context, credentials: { _ in Self.ticket }, audio: audio, connect: { _ in socket })
        var events: [RealtimeConversationEvent] = []
        // The script ends like a closed connection; what was emitted before is the point.
        try? await session.run { events.append($0) }
        return (events, socket)
    }

    private func transcripts(_ events: [RealtimeConversationEvent]) -> [String] {
        events.compactMap {
            if case let .transcript(id, speaker, text, replaces) = $0 {
                "\(id)|\(speaker == .learner ? "L" : "C")|\(text)|\(replaces)"
            } else {
                nil
            }
        }
    }

    @Test("A message carries the voice, what was said and heard, and where the turn stands")
    func message() throws {
        let spoken = try GeminiLiveMessage(Data(Self.says("Guten Tag!").utf8))
        #expect(spoken.audio == [Data([1, 2, 3, 4])])
        #expect(spoken.spoken == "Guten Tag!")
        #expect(!spoken.isTurnComplete && !spoken.isInterrupted && !spoken.isSetupComplete)

        let heard = try GeminiLiveMessage(Data(#"{"serverContent":{"inputTranscription":{"text":"Ich habe Zahnschmerzen."}}}"#.utf8))
        #expect(heard.heard == "Ich habe Zahnschmerzen.")
        #expect(heard.audio.isEmpty)

        let cut = try GeminiLiveMessage(Data(#"{"serverContent":{"interrupted":true,"turnComplete":true}}"#.utf8))
        #expect(cut.isInterrupted && cut.isTurnComplete)

        #expect(try GeminiLiveMessage(Data(#"{"setupComplete":{}}"#.utf8)).isSetupComplete)
        #expect(try GeminiLiveMessage(Data(#"{"voiceActivity":{"type":"ACTIVITY_START","audioOffset":"0.2s"}}"#.utf8)).activity == .started)
        #expect(try GeminiLiveMessage(Data(#"{"voiceActivity":{"type":"ACTIVITY_END"}}"#.utf8)).activity == .ended)
        #expect(try GeminiLiveMessage(Data(#"{"goAway":{"timeLeft":"9.5s"}}"#.utf8)).secondsLeft == 9.5)
        // Messages the app has no use for are read without complaint.
        #expect(try GeminiLiveMessage(Data(#"{"sessionResumptionUpdate":{"resumable":true}}"#.utf8)).audio.isEmpty)
    }

    @Test("Voice that isn't base64 is refused")
    func badAudio() {
        let bad = #"{"serverContent":{"modelTurn":{"parts":[{"inlineData":{"data":"***"}}]}}}"#
        #expect(throws: RealtimeServiceError.self) { try GeminiLiveMessage(Data(bad.utf8)) }
    }

    @Test("The app names the model, asks the companion to begin, and sends the microphone at its own rate")
    func setup() async {
        let audio = SilentAudio()
        audio.microphone = [Data([9, 9])]
        let (_, socket) = await run([#"{"setupComplete":{}}"#, Self.says("Hallo!"), Self.says(" Wie geht's?")], audio: audio)
        #expect((socket.sent.first?["setup"] as? [String: String]) == ["model": "models/gemini-3.8-live"])
        let inputs = socket.sent.compactMap { $0["realtimeInput"] as? [String: Any] }
        #expect(inputs.first?["text"] as? String == GeminiLiveSession.opening)
        let chunk = inputs.compactMap { $0["audio"] as? [String: String] }.first
        #expect(chunk == ["data": Data([9, 9]).base64EncodedString(), "mimeType": "audio/pcm;rate=24000"])
        #expect(audio.played.map(\.item) == ["gemini-companion-1", "gemini-companion-1"])
    }

    @Test("Holding to talk, the opening is one marked turn and the microphone waits for the orb")
    func holdToTalk() async {
        let audio = SilentAudio()
        audio.microphone = [Data([9, 9])]
        let (events, socket) = await run([#"{"setupComplete":{}}"#, Self.says("Hallo!")], audio: audio, holdsToTalk: true)
        let inputs = socket.sent.compactMap { $0["realtimeInput"] as? [String: Any] }
        #expect(inputs.map { $0.keys.sorted() } == [["activityStart"], ["text"], ["activityEnd"]])
        #expect(inputs[1]["text"] as? String == GeminiLiveSession.opening)
        #expect(!events.contains { if case .phase(.listening) = $0 { true } else { false } })
    }

    @Test("Reconnecting, the opening carries the conversation so far")
    func reconnectOpening() {
        #expect(GeminiLiveSession.opening(history: "") == GeminiLiveSession.opening)
        let opening = GeminiLiveSession.opening(history: "You: Hallo!\nLearner: Hi!")
        #expect(opening.contains("You: Hallo!\nLearner: Hi!"))
        #expect(opening.contains("don't greet again"))
    }

    @Test("The companion's words join into one line, and the learner's line is final when the answer begins")
    func conversation() async {
        let (events, _) = await run([
            #"{"setupComplete":{}}"#,
            Self.says("Praxis Dr. Müller,"), Self.says(" guten Tag!"),
            #"{"serverContent":{"turnComplete":true}}"#,
            #"{"voiceActivity":{"type":"ACTIVITY_START"}}"#,
            #"{"serverContent":{"inputTranscription":{"text":"Ich habe "}}}"#,
            #"{"serverContent":{"inputTranscription":{"text":"Zahnschmerzen. "}}}"#,
            #"{"voiceActivity":{"type":"ACTIVITY_END"}}"#,
            Self.says("Oh je!"),
            #"{"serverContent":{"turnComplete":true}}"#,
            #"{"serverContent":{"inputTranscription":{"text":"Danke."}}}"#
        ])
        #expect(transcripts(events) == [
            "gemini-companion-1|C|Praxis Dr. Müller,|false",
            "gemini-companion-1|C| guten Tag!|false",
            "gemini-learner-2|L|Ich habe |false",
            "gemini-learner-2|L|Zahnschmerzen. |false",
            // Final, so it is checked for mistakes.
            "gemini-learner-2|L|Ich habe Zahnschmerzen.|true",
            "gemini-companion-3|C|Oh je!|false",
            // After the answer, the learner's next words are a new line.
            "gemini-learner-4|L|Danke.|false"
        ])
        let phases = events.compactMap { if case .phase(let phase) = $0 { phase } else { nil } }
        #expect(phases.contains(.speaking) && phases.contains(.thinking) && phases.last == .listening)
    }

    @Test("Words heard after the answer began still belong to the learner's line")
    func lateWords() async {
        let (events, _) = await run([
            #"{"setupComplete":{}}"#,
            #"{"serverContent":{"inputTranscription":{"text":"Guten "}}}"#,
            Self.says("Hallo!"),
            #"{"serverContent":{"inputTranscription":{"text":"Tag."}}}"#
        ])
        #expect(transcripts(events).last == "gemini-learner-1|L|Guten Tag.|true")
    }

    @Test("Talking over the companion cuts its line and goes back to listening")
    func interruption() async {
        let (events, _) = await run([
            #"{"setupComplete":{}}"#,
            Self.says("Guten Tag und herzlich"),
            #"{"voiceActivity":{"type":"ACTIVITY_START"}}"#,
            #"{"serverContent":{"interrupted":true}}"#,
            #"{"serverContent":{"turnComplete":true}}"#,
            Self.says("Ja, bitte?")
        ])
        let cuts = events.compactMap { if case .interruptTranscript(let id) = $0 { id } else { nil } }
        #expect(cuts == ["gemini-companion-1"])
        // The next answer is a new line, not more of the one that was cut.
        #expect(transcripts(events).last == "gemini-companion-2|C|Ja, bitte?|false")
    }

    @Test("The connection carries the token, and a token that has run out isn't used")
    func request() throws {
        let url = try #require(try GeminiLiveSession.request(for: Self.ticket).url)
        #expect(url.scheme == "wss")
        #expect(url.host() == "generativelanguage.googleapis.com")
        #expect(url.path().hasSuffix("BidiGenerateContentConstrained"))
        #expect(url.query()?.contains("access_token=auth_tokens") == true)
        let old = GeminiLiveCredentials(token: "t", expiresAt: 10, model: "m", voice: "v")
        #expect(throws: RealtimeServiceError.self) { try GeminiLiveSession.request(for: old) }
    }

    @Test("The server's answer is read")
    func provider() throws {
        let json = #"{"token":"auth_tokens/x","expires_at":1794680592,"model":"gemini-3.8-live","voice":"Kore"}"#
        let ticket = try JSONDecoder().decode(GeminiLiveCredentials.self, from: Data(json.utf8))
        #expect(ticket.token == "auth_tokens/x" && ticket.expiresAt == 1_794_680_592)
    }
}
