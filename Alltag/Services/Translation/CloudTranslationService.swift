//
//  CloudTranslationService.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 13.11.26.
//

import Foundation
import OSLog

/// Translates with OpenAI through the `translate` Edge Function when the
/// learner has allowed cloud use: natural German with the words explained, in
/// one answer. Without permission, offline or when the server fails, the
/// on-device service (Apple's Translation) translates instead.
final class CloudTranslationService: TranslationService {
    typealias Send = (_ body: [String: String]) async throws -> Data
    typealias Stream = (_ body: [String: String], _ onLine: (String) throws -> Void) async throws -> Void

    private let onDevice: any TranslationService
    private let isAllowed: () -> Bool
    private let send: Send
    private let stream: Stream
    private let logger = Logger(subsystem: "i8r4him.Alltag", category: "Translation")

    init(onDevice: any TranslationService = SystemTranslationService(),
         isAllowed: @escaping () -> Bool = { UserDefaults.standard.bool(forKey: "usesCloudForPro") },
         send: @escaping Send = { try await SupabaseRealtimeClient.shared.post(to: "translate", body: $0) },
         stream: @escaping Stream = { try await SupabaseRealtimeClient.shared.stream(to: "translate", body: $0, onLine: $1) }) {
        self.onDevice = onDevice
        self.isAllowed = isAllowed
        self.send = send
        self.stream = stream
    }

    func translate(_ text: String) async throws -> TranslationResult? {
        if isAllowed() {
            do {
                let data = try await send(["text": text, "language": Self.learnerLanguage])
                return TranslationResult(try JSONDecoder().decode(ServerTranslation.self, from: data))
            } catch is CancellationError {
                throw CancellationError()
            } catch {
                logger.error("The server's translation failed, translating on device: \(String(describing: error), privacy: .public)")
            }
        }
        return try await onDevice.translate(text)
    }

    func translate(_ text: String, onUpdate: @escaping (TranslationResult) -> Void) async throws -> TranslationResult? {
        guard isAllowed() else { throw RealtimeServiceError.unavailable }
        var parser = TranslationStream()
        var last: TranslationResult?
        try await stream([
            "text": text, "language": Self.learnerLanguage, "stream": "true"
        ]) { line in
            if let partial = try parser.receive(line), partial != last {
                last = partial
                onUpdate(partial)
            }
        }
        return try parser.finish()
    }

    /// The server supplies its own explanations.
    func explain(_ result: TranslationResult) async -> TranslationResult {
        result
    }

    /// The learner's language by its English name ("English", "Arabic"), for the
    /// server's instructions. A German iPhone still gets English: nobody learns German from German.
    static var learnerLanguage: String {
        let code = Locale.current.language.languageCode
        guard let code, code != .german,
              let name = Locale(identifier: "en").localizedString(forLanguageCode: code.identifier) else { return "English" }
        return name
    }
}

/// The `translate` function's answer.
struct ServerTranslation: Decodable {
    struct Word: Decodable {
        let word: String
        let grammar: String
        let meaning: String
    }

    struct Tone: Decodable {
        let tone: String
        let german: String
    }

    struct Example: Decodable {
        let german: String
        let other: String
    }

    let german: String
    let other: String
    let note: String
    let words: [Word]
    let tones: [Tone]
    let examples: [Example]
}

extension TranslationResult {
    init(_ server: ServerTranslation) {
        self.init(
            english: server.other,
            german: server.german,
            words: server.words.map { WordBreakdown(word: $0.word, grammar: $0.grammar, meaning: $0.meaning) },
            tones: server.tones.compactMap { tone in
                ToneVariant.Tone.allCases.first { $0.rawValue.lowercased() == tone.tone }
                    .map { ToneVariant(tone: $0, german: tone.german) }
            },
            note: server.note,
            examples: server.examples.map { Example(german: $0.german, english: $0.other) }
        )
    }
}
