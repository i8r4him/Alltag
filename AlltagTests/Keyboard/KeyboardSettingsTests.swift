//
//  KeyboardSettingsTests.swift
//  AlltagTests
//
//  Created by Ibrahim Abdullah on 21.11.26.
//

import Foundation
import Testing
@testable import Alltag

/// Keeps the settings in memory.
@MainActor
final class MemorySettingsStore: KeyboardSettingsStore {
    var kept = KeyboardSettings()

    func load() -> KeyboardSettings { kept }

    func save(_ settings: KeyboardSettings) {
        kept = settings
    }
}

@Suite("Keyboard settings")
@MainActor
struct KeyboardSettingsTests {
    let document = FakeDocument()
    let model = KeyboardModel()
    let store = MemorySettingsStore()

    init() {
        model.document = document
        model.suggester = FixedWords(words: ["ha": ["hallo"]])
        model.settingsStore = store
        model.documentChanged(KeyboardTraits())
    }

    @Test("Everything is on at first, and a change is kept")
    func kept() {
        #expect(KeyboardSettings.Option.allCases.allSatisfy { model.settings[$0] })
        model.set(.sound, to: false)
        #expect(!store.kept[.sound])
        #expect(store.kept[.haptics])

        // The next keyboard starts with what was kept.
        let next = KeyboardModel()
        next.settingsStore = store
        #expect(!next.settings[.sound])
    }

    @Test("The defaults keep what is switched off")
    func defaults() throws {
        let name = "keyboard-settings-\(UUID().uuidString)"
        let defaults = try #require(UserDefaults(suiteName: name))
        defer { defaults.removePersistentDomain(forName: name) }
        let store = DefaultsKeyboardSettingsStore(defaults: defaults)
        #expect(store.load() == KeyboardSettings())
        var settings = KeyboardSettings()
        settings[.haptics] = false
        settings[.fullStopShortcut] = false
        store.save(settings)
        #expect(store.load() == settings)
        settings[.haptics] = true
        store.save(settings)
        #expect(store.load()[.haptics])
    }

    @Test("Without auto-capitalisation a sentence starts small")
    func capitals() {
        #expect(model.shift == .once)
        model.set(.autoCapitals, to: false)
        #expect(model.shift == .off)
        model.activate(.character("h"))
        #expect(document.before == "h")
        model.set(.autoCapitals, to: true)
        model.activate(.character("."))
        model.activate(.space)
        #expect(model.shift == .once)
    }

    @Test("Without the shortcut two spaces stay two spaces")
    func fullStop() {
        model.set(.autoCapitals, to: false)
        model.activate(.character("h"))
        model.activate(.space)
        model.activate(.space)
        #expect(document.before == "h. ")
        model.set(.fullStopShortcut, to: false)
        model.activate(.character("a"))
        model.activate(.space)
        model.activate(.space)
        #expect(document.before == "h. a  ")
    }

    @Test("Without word suggestions none are offered")
    func suggestions() {
        model.set(.autoCapitals, to: false)
        model.activate(.character("h"))
        model.activate(.character("a"))
        model.refreshSuggestions()
        #expect(model.suggestions == ["hallo"])
        model.set(.suggestions, to: false)
        #expect(model.suggestions.isEmpty)
        model.refreshSuggestions()
        #expect(model.suggestions.isEmpty)
    }

    @Test("The orb opens the settings and closes a tool")
    func open() async {
        let changes = Counter()
        model.onSettingsChanged = { _ in changes.count += 1 }
        await model.tools.fix()
        #expect(model.tools.panel != nil)
        model.openSettings()
        #expect(model.showsSettings)
        #expect(model.tools.panel == nil)
        model.set(.haptics, to: false)
        model.set(.haptics, to: false)
        #expect(changes.count == 1)
        model.closeSettings()
        #expect(!model.showsSettings)
    }
}

@MainActor
private final class Counter {
    var count = 0
}
