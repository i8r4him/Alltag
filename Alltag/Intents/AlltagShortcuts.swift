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
