//
//  SettingsTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import SwiftData
import Testing
@testable import Alltag

extension UserDefaults {
    /// Empty defaults that no other test or launch shares.
    static func ephemeral() -> UserDefaults {
        let name = "AlltagTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: name) ?? .standard
        defaults.removePersistentDomain(forName: name)
        return defaults
    }
}

/// Notifications that answer with a fixed status.
private final class StubPermissions: NotificationService {
    let answer: PermissionStatus
    init(_ answer: PermissionStatus) { self.answer = answer }

    var authorizationStatus: PermissionStatus { answer }
    func requestAuthorization() async -> PermissionStatus { answer }
    func scheduleDailyNudge(at time: NudgeTime) async throws {}
    func cancelDailyNudge() async {}
}

@Suite("Settings")
@MainActor
struct SettingsTests {
    private func services(_ answer: PermissionStatus) -> AppServices {
        let stub = StubPermissions(answer)
        let mock = AppServices.mock()
        return AppServices(speech: mock.speech, voice: mock.voice, translation: mock.translation,
                           companion: mock.companion, notifications: stub)
    }

    @Test("Settings persist across launches")
    func persistence() {
        let defaults = UserDefaults.ephemeral()
        let settings = AppSettings(defaults: defaults)
        #expect(!settings.reduceMotion && !settings.slowerSpeech)
        #expect(settings.learnsFromSafari && settings.quietEvenings)

        settings.reduceMotion = true
        settings.slowerSpeech = true
        settings.quietEvenings = false
        let relaunched = AppSettings(defaults: defaults)
        #expect(relaunched.reduceMotion && relaunched.slowerSpeech)
        #expect(!relaunched.quietEvenings)
        #expect(relaunched.defaultSpeechRate == .slow)
    }

    @Test("Slower speech slows everything that is spoken")
    func slowerSpeech() async {
        let voice = MockVoiceService()
        await voice.speak("Hallo", rate: .normal)
        voice.prefersSlowerSpeech = true
        await voice.speak("Tschüss", rate: .normal)
        await voice.speak("Bitte", rate: .slow)
        #expect(voice.spoken.map(\.rate) == [.normal, .slow, .slow])
    }

    @Test("A permission toggle stays on when access is granted")
    func permissionGranted() async {
        let model = SettingsModel(services: services(.granted))
        let profile = UserProfile(name: "Mara")
        await model.setRemindersEnabled(true, on: profile)
        #expect(profile.remindersEnabled)
        #expect(model.message == nil)
    }

    @Test("A permission toggle turns back off and explains when access is refused")
    func permissionDenied() async {
        let model = SettingsModel(services: services(.denied))
        let profile = UserProfile(name: "Mara")
        await model.setMorningBriefingEnabled(true, on: profile)
        #expect(!profile.morningBriefingEnabled)
        #expect(model.message != nil)

        model.message = nil
        profile.remindersEnabled = true
        await model.setRemindersEnabled(false, on: profile)
        #expect(!profile.remindersEnabled)
        #expect(model.message == nil)
    }

    @Test("Export contains the profile and everything saved, as JSON")
    func export() throws {
        let container = try AlltagStore.makeContainer(inMemory: true)
        let context = container.mainContext
        let now = Date(timeIntervalSince1970: 1_800_000_000)
        try AlltagStore.seedSampleDataIfEmpty(context, now: now)
        context.insert(UserProfile(name: "Mara", level: .b1, interests: [.housing]))
        context.insert(SolvedRule(ruleID: "verb-end", solvedAt: now))
        try context.save()

        let export = try DataExport(context: context, now: now)
        #expect(export.profile?.name == "Mara")
        #expect(export.profile?.level == "B1")
        #expect(export.words.count == (try context.fetchCount(FetchDescriptor<MemoryItem>())))
        #expect(!export.phrases.isEmpty)
        #expect(export.solvedRules.map(\.id) == ["verb-end"])

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let data = try export.jsonData()
        #expect(try decoder.decode(DataExport.self, from: data).jsonData() == data)
    }

    @Test("On-device AI status explains each case", arguments: [
        OnDeviceAIStatus.available, .notEnabled, .notReady, .notSupported
    ])
    func aiStatus(status: OnDeviceAIStatus) {
        #expect(!String(localized: status.detail).isEmpty)
        #expect(status.isAvailable == (status == .available))
    }
}
