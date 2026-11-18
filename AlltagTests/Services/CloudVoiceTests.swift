//
//  CloudVoiceTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import Testing
@testable import Alltag

@Suite("Cloud voice")
@MainActor
struct CloudVoiceTests {
    /// Records what would play, without a sound.
    final class SilentPlayer: SpeechAudioPlayer {
        private(set) var played: [(url: URL, rate: SpeechRate)] = []
        private(set) var stops = 0

        func play(_ url: URL, rate: SpeechRate) async throws {
            played.append((url, rate))
        }

        func stop() {
            stops += 1
        }
    }

    /// Answers with the text as bytes and counts what the server was asked.
    final class Server {
        private(set) var asked: [String] = []
        var error: (any Error)?

        func fetch(_ text: String) async throws -> Data {
            asked.append(text)
            if let error { throw error }
            return Data(text.utf8)
        }
    }

    private static func freshCache() -> SpeechAudioCache {
        SpeechAudioCache(directory: FileManager.default.temporaryDirectory
            .appending(path: "SpeechTests-\(UUID().uuidString)", directoryHint: .isDirectory))
    }

    private static func voice(server: Server, player: SilentPlayer, fallback: MockVoiceService = MockVoiceService(),
                              cache: SpeechAudioCache = freshCache(), allowed: Bool = true) -> CloudVoiceService {
        CloudVoiceService(fetch: { try await server.fetch($0) }, cache: cache, player: player,
                          fallback: fallback, isAllowed: { allowed })
    }

    @Test("A sentence is fetched once; the second time it plays from the iPhone's cache")
    func cachesSentences() async {
        let server = Server()
        let player = SilentPlayer()
        let voice = Self.voice(server: server, player: player)
        await voice.speak("Guten Morgen!", rate: .normal)
        await voice.speak("Guten  Morgen!", rate: .normal)
        #expect(server.asked == ["Guten Morgen!"])
        #expect(player.played.count == 2)
        #expect(player.played.first?.url == player.played.last?.url)
        #expect(!voice.isSpeaking)
    }

    @Test("A long text is spoken sentence by sentence, in order")
    func speaksSentences() async {
        let server = Server()
        let player = SilentPlayer()
        let voice = Self.voice(server: server, player: player)
        await voice.speak("Der Zug hat Verspätung. Er fährt von Gleis 12. Wir bitten um Entschuldigung.", rate: .normal)
        #expect(server.asked == ["Der Zug hat Verspätung.", "Er fährt von Gleis 12.", "Wir bitten um Entschuldigung."])
        #expect(player.played.count == 3)
    }

    @Test("Slowly plays the same audio slower, without asking again")
    func slowUsesSameAudio() async {
        let server = Server()
        let player = SilentPlayer()
        let voice = Self.voice(server: server, player: player)
        await voice.speak("Bitte langsam.", rate: .normal)
        await voice.speak("Bitte langsam.", rate: .slow)
        #expect(server.asked.count == 1)
        #expect(player.played.map(\.rate) == [.normal, .slow])
    }

    @Test("Slower speech in Settings makes every sentence slow")
    func prefersSlower() async {
        let player = SilentPlayer()
        let voice = Self.voice(server: Server(), player: player)
        voice.prefersSlowerSpeech = true
        await voice.speak("Hallo", rate: .normal)
        #expect(player.played.map(\.rate) == [.slow])
    }

    @Test("Offline, it says so instead of using the iPhone's voice")
    func offlineShowsNotice() async {
        let server = Server()
        server.error = URLError(.notConnectedToInternet)
        let fallback = MockVoiceService()
        let voice = Self.voice(server: server, player: SilentPlayer(), fallback: fallback)
        await voice.speak("Hallo", rate: .normal)
        #expect(voice.notice?.isProblem == true)
        #expect(fallback.spoken.isEmpty)
    }

    @Test("When the server can't answer, the iPhone's voice speaks the rest")
    func serverFailureFallsBack() async {
        let server = Server()
        server.error = RealtimeServiceError.dailyLimit
        let fallback = MockVoiceService()
        let voice = Self.voice(server: server, player: SilentPlayer(), fallback: fallback)
        await voice.speak("Eins. Zwei.", rate: .slow)
        #expect(fallback.spoken.map(\.text) == ["Eins. Zwei."])
        #expect(fallback.spoken.map(\.rate) == [.slow])
        #expect(voice.notice == nil)
    }

    @Test("With cloud use switched off, the iPhone's voice speaks and nothing is sent")
    func cloudOffUsesFallback() async {
        let server = Server()
        let fallback = MockVoiceService()
        let voice = Self.voice(server: server, player: SilentPlayer(), fallback: fallback, allowed: false)
        await voice.speak("Hallo", rate: .normal)
        #expect(server.asked.isEmpty)
        #expect(fallback.spoken.map(\.text) == ["Hallo"])
    }

    @Test("Long sentences are split between words, within the server's limit")
    func splitsLongSentences() {
        let long = Array(repeating: "Wort", count: 120).joined(separator: " ") + "."
        let pieces = SpeechChunks.split(long)
        #expect(pieces.count > 1)
        #expect(pieces.allSatisfy { $0.count <= SpeechChunks.limit })
        #expect(pieces.joined(separator: " ") == long)
        #expect(SpeechChunks.split("   ").isEmpty)
    }

    @Test("The cache drops the oldest sentences when it grows too big")
    func cacheTrims() throws {
        let cache = SpeechAudioCache(directory: Self.freshCache().directory, limit: 10)
        let old = try cache.store(Data(repeating: 1, count: 8), for: "alt")
        try FileManager.default.setAttributes([.modificationDate: Date.distantPast], ofItemAtPath: old.path())
        try cache.store(Data(repeating: 2, count: 8), for: "neu")
        #expect(cache.url(for: "alt") == nil)
        #expect(cache.url(for: "neu") != nil)
    }
}
