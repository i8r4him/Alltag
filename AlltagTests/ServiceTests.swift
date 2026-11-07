//
//  ServiceTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import AVFoundation
import Foundation
import Testing
@testable import Alltag

@Suite("Services")
@MainActor
struct ServiceTests {
    @Test("Simulated speech reveals the expected line one word at a time")
    func speechRevealsWords() async {
        let speech = MockSpeechService(wordInterval: .zero)
        var transcripts: [String] = []
        for await partial in speech.listen(expected: "Können wir den Termin verschieben?") {
            transcripts.append(partial)
        }
        #expect(transcripts == [
            "Können", "Können wir", "Können wir den", "Können wir den Termin", "Können wir den Termin verschieben?"
        ])
    }

    @Test("Speech permission becomes granted after asking")
    func speechAuthorization() async {
        let speech = MockSpeechService()
        #expect(speech.authorizationStatus == .notDetermined)
        #expect(await speech.requestAuthorization() == .granted)
    }

    @Test("The companion gives the scripted feedback and next line for each turn")
    func companionFollowsScript() async throws {
        let companion = MockCompanionService(thinkingTime: .zero)
        let scenario = MockScenarios.dentist

        let first = try await companion.respond(to: "…", in: scenario, turn: 0)
        #expect(first.feedback?.kind == .good)
        #expect(first.reply?.german == "Natürlich. Morgen hätten wir um 10:30 Uhr oder um 15 Uhr etwas frei.")

        let second = try await companion.respond(to: "…", in: scenario, turn: 1)
        #expect(second.feedback?.kind == .fix)
        #expect(second.reply?.german == "Prima, dann trage ich Sie für morgen um 15 Uhr ein. Bis morgen!")

        let beyond = try await companion.respond(to: "…", in: scenario, turn: 2)
        #expect(beyond == CompanionResponse())
    }

    @Test("Debrief returns the bakery phrases")
    func companionDebrief() async throws {
        let debrief = try await MockCompanionService(thinkingTime: .zero).debrief("nuts?")
        #expect(debrief.phrases.count == 2)
    }

    @Test("Translation knows the three samples and nothing else")
    func translation() async throws {
        let service = MockTranslationService(delay: .zero)
        #expect(try await service.translate("Let me know when you're free.") == MockTranslations.letMeKnow)
        #expect(try await service.translate("Ich mache jetzt Feierabend.") == MockTranslations.callingItADay)
        #expect(try await service.translate("Where is the toilet?") == nil)
    }

    @Test("Calendar lists dentist tomorrow first, each event linked to a scenario")
    func calendar() async throws {
        let calendar = MockCalendarService()
        #expect(await calendar.requestAccess() == .granted)

        let events = try await calendar.upcomingEvents()
        #expect(events.count == 3)
        #expect(events.first?.scenario == .dentist)
        #expect(events.map(\.start) == events.map(\.start).sorted())
        #expect(Set(events.compactMap(\.scenario)) == Set(Scenario.ID.allCases))
    }

    @Test("Calendar order holds on every day of the week", arguments: 0..<7)
    func calendarOrderEveryDay(offset: Int) async throws {
        // 7 Nov 2026 is a Saturday; check the following seven days.
        let saturday = try #require(Calendar.current.date(from: DateComponents(year: 2026, month: 11, day: 7, hour: 9)))
        let day = try #require(Calendar.current.date(byAdding: .day, value: offset, to: saturday))
        let events = try await MockCalendarService(now: { day }).upcomingEvents()

        #expect(events.map(\.id) == ["dentist", "train", "package"])
        #expect(events.allSatisfy { $0.start > day })
    }

    @Test("The daily nudge is scheduled and cancelled")
    func notifications() async throws {
        let notifications = MockNotificationService()
        try await notifications.scheduleDailyNudge(at: .morning)
        #expect(notifications.scheduledNudge == .morning)
        await notifications.cancelDailyNudge()
        #expect(notifications.scheduledNudge == nil)
    }

    @Test("The mock voice records text and speed")
    func mockVoice() async {
        let voice = MockVoiceService()
        await voice.speak("Hallo", rate: .slow)
        #expect(voice.spoken.map(\.text) == ["Hallo"])
        #expect(voice.spoken.map(\.rate) == [.slow])
        #expect(!voice.isSpeaking)
    }

    @Test("The system voice speaks German, slower when asked")
    func systemVoiceUtterance() {
        let normal = SystemVoiceService.utterance(for: "Guten Tag", rate: .normal)
        let slow = SystemVoiceService.utterance(for: "Guten Tag", rate: .slow)
        #expect(normal.speechString == "Guten Tag")
        #expect(normal.voice?.language.hasPrefix("de") == true)
        #expect(slow.rate < normal.rate)
    }
}
