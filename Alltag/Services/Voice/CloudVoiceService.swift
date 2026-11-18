//
//  CloudVoiceService.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import OSLog

/// Speaks German with a natural cloud voice: Gemini TTS through the server's `speak`
/// function (#422), in place of the iPhone's voice.
///
/// - Each sentence is fetched once and kept on the iPhone (`SpeechAudioCache`), so a replay is
///   instant and free. The server keeps it too, for everyone.
/// - A long text is spoken sentence by sentence; the next sentence loads while one plays.
/// - "Slowly" plays the same audio slower, with no new request.
/// - Offline, it says so (`notice`) instead of falling back to the iPhone's voice. When the
///   learner switched cloud use off, or the server can't answer, the iPhone's voice speaks.
@Observable
final class CloudVoiceService: VoiceService {
    typealias Fetch = (String) async throws -> Data

    private(set) var isSpeaking = false
    var prefersSlowerSpeech = false {
        didSet { fallback.prefersSlowerSpeech = prefersSlowerSpeech }
    }
    /// A short message when listening can't work right now, shown as a toast.
    var notice: ToastMessage?

    @ObservationIgnored private let fetch: Fetch
    @ObservationIgnored private let cache: SpeechAudioCache
    @ObservationIgnored private let player: any SpeechAudioPlayer
    @ObservationIgnored private let fallback: any VoiceService
    @ObservationIgnored private let isAllowed: () -> Bool
    /// Counts `speak` calls, so a stopped or replaced one ends quietly.
    @ObservationIgnored private var generation = 0
    @ObservationIgnored private let logger = Logger(subsystem: "i8r4him.Alltag", category: "Voice")

    init(fetch: @escaping Fetch = { text in
             try await SupabaseRealtimeClient.shared.post(to: "speak", body: ["text": text])
         },
         cache: SpeechAudioCache = SpeechAudioCache(),
         player: any SpeechAudioPlayer = SystemSpeechAudioPlayer(),
         fallback: any VoiceService = SystemVoiceService(),
         isAllowed: @escaping () -> Bool = CloudVoiceService.cloudIsAllowed) {
        self.fetch = fetch
        self.cache = cache
        self.player = player
        self.fallback = fallback
        self.isAllowed = isAllowed
    }

    /// The natural voice is used unless the learner switched cloud use off in Settings.
    /// It only sends German text to be spoken, never anything about the learner.
    nonisolated static func cloudIsAllowed() -> Bool {
        UserDefaults.standard.object(forKey: "usesCloudForPro") as? Bool ?? true
    }

    func speak(_ text: String, rate: SpeechRate) async {
        stop()
        generation += 1
        let current = generation
        let rate = rate.adjusted(prefersSlower: prefersSlowerSpeech)
        guard isAllowed() else {
            await fallback.speak(text, rate: rate)
            return
        }
        let parts = SpeechChunks.split(text)
        guard !parts.isEmpty else { return }

        isSpeaking = true
        defer { if generation == current { isSpeaking = false } }
        var next: Task<URL, any Error>? = Task { try await self.audio(for: parts[0]) }
        for index in parts.indices {
            guard let pending = next, generation == current else { return }
            let url: URL
            do {
                url = try await pending.value
            } catch {
                guard generation == current else { return }
                await failed(error, remaining: parts[index...].joined(separator: " "), rate: rate)
                return
            }
            next = parts.indices.contains(index + 1) ? Task { [parts] in try await self.audio(for: parts[index + 1]) } : nil
            guard generation == current else {
                next?.cancel()
                return
            }
            do {
                try await player.play(url, rate: rate)
            } catch {
                logger.error("Couldn't play spoken audio: \(error.localizedDescription, privacy: .public)")
            }
        }
    }

    func stop() {
        generation += 1
        player.stop()
        fallback.stop()
        isSpeaking = false
    }

    /// The audio for one sentence: from the iPhone's cache, or from the server once.
    private func audio(for sentence: String) async throws -> URL {
        if let url = cache.url(for: sentence) { return url }
        let data = try await fetch(sentence)
        return try cache.store(data, for: sentence)
    }

    private func failed(_ error: any Error, remaining: String, rate: SpeechRate) async {
        let failure = CloudFailure(error)
        logger.error("Natural voice unavailable (\(String(describing: failure), privacy: .public))")
        if failure == .offline {
            notice = ToastMessage(text: "Listening needs the internet", systemImage: "wifi.slash", isProblem: true)
        } else {
            // The daily limit, a busy or refusing server: the iPhone's voice keeps the button working.
            await fallback.speak(remaining, rate: rate)
        }
    }
}
