//
//  GeminiLiveMessage.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 14.11.26.
//

import Foundation

/// One message from Gemini Live, reduced to what the conversation needs: the voice,
/// what was said and heard, and where the turn stands.
struct GeminiLiveMessage {
    enum Activity { case started, ended }

    /// The session is set up and can be spoken to.
    var isSetupComplete = false
    /// The companion's voice: 24 kHz PCM, in the order to play it.
    var audio: [Data] = []
    /// A piece of what the companion says.
    var spoken: String?
    /// A piece of what the learner said.
    var heard: String?
    /// The learner talked over the companion, whose answer is dropped from here.
    var isInterrupted = false
    /// The companion has said all of its answer.
    var isTurnComplete = false
    /// The learner started or stopped talking.
    var activity: Activity?
    /// The server is about to close the connection, in this many seconds.
    var secondsLeft: Double?

    init(_ data: Data) throws {
        let wire = try JSONDecoder().decode(Wire.self, from: data)
        isSetupComplete = wire.setupComplete != nil
        if let content = wire.serverContent {
            audio = try (content.modelTurn?.parts ?? []).compactMap { $0.inlineData?.data }.map { chunk in
                guard let bytes = Data(base64Encoded: chunk) else { throw RealtimeServiceError.unexpectedResponse }
                return bytes
            }
            spoken = content.outputTranscription?.text
            heard = content.inputTranscription?.text
            isInterrupted = content.interrupted ?? false
            isTurnComplete = content.turnComplete ?? false
        }
        switch wire.voiceActivity?.type {
        case "ACTIVITY_START": activity = .started
        case "ACTIVITY_END": activity = .ended
        default: activity = nil
        }
        if let left = wire.goAway?.timeLeft { secondsLeft = Double(left.dropLast(left.hasSuffix("s") ? 1 : 0)) ?? 0 }
    }

    private struct Wire: Decodable {
        var setupComplete: Empty?
        var serverContent: Content?
        var voiceActivity: VoiceActivity?
        var goAway: GoAway?

        struct Empty: Decodable {}

        struct Content: Decodable {
            var modelTurn: Turn?
            var inputTranscription: Transcription?
            var outputTranscription: Transcription?
            var interrupted: Bool?
            var turnComplete: Bool?
        }

        struct Turn: Decodable {
            var parts: [Part]?
        }

        struct Part: Decodable {
            var inlineData: Blob?
        }

        struct Blob: Decodable {
            var data: String
        }

        struct Transcription: Decodable {
            var text: String?
        }

        struct VoiceActivity: Decodable {
            var type: String?
        }

        struct GoAway: Decodable {
            var timeLeft: String?
        }
    }
}
