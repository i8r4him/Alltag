//
//  AlltagShortcuts.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import AppIntents

/// App Shortcuts: available in Siri, Spotlight and the Shortcuts app without
/// any setup. Phrases are localized in `AppShortcuts.xcstrings`.
struct AlltagShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: StartConversationIntent(),
            phrases: [
                "Start a German speaking session in \(.applicationName)",
                "Practise speaking in \(.applicationName)",
                "Practise \(\.$scenario) in \(.applicationName)",
                "Rehearse \(\.$scenario) with \(.applicationName)"
            ],
            shortTitle: "Speak",
            systemImageName: "mic"
        )
        AppShortcut(
            intent: ReviewWordsIntent(),
            phrases: [
                "Review my saved words in \(.applicationName)",
                "Practise my words in \(.applicationName)",
                "Start a \(.applicationName) review"
            ],
            shortTitle: "Review Words",
            systemImageName: "rectangle.stack"
        )
        AppShortcut(
            intent: TranslateIntent(),
            phrases: [
                "Translate with \(.applicationName)",
                "Translate into German with \(.applicationName)"
            ],
            shortTitle: "Translate",
            systemImageName: "translate"
        )
        AppShortcut(
            intent: OpenRuleIntent(),
            phrases: [
                "Explain \(\.$target) in \(.applicationName)",
                "Open the grammar rule \(\.$target) in \(.applicationName)"
            ],
            shortTitle: "Grammar Rule",
            systemImageName: "text.badge.checkmark"
        )
        AppShortcut(
            intent: OpenMemoryIntent(),
            phrases: [
                "Open my words in \(.applicationName)",
                "Show my \(.applicationName) memory",
                "What am I learning in \(.applicationName)"
            ],
            shortTitle: "My Words",
            systemImageName: "book"
        )
    }

    static let shortcutTileColor: ShortcutTileColor = .orange
}
