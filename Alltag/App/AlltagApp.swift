//
//  AlltagApp.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import AppIntents
import SwiftData
import SwiftUI
import OSLog

@main
struct AlltagApp: App {
    private let container: ModelContainer
    @State private var appState: AppState
    private let services = AppServices.live()
    @Environment(\.scenePhase) private var scenePhase

    init() {
        do {
            container = try AlltagStore.makeContainer()
        } catch {
            fatalError("Could not open the Alltag store: \(error)")
        }
        _ = try? AlltagStore.repairDuplicateIDs(container.mainContext)
        #if DEBUG
        try? AlltagStore.seedSampleDataIfEmpty(container.mainContext)
        #endif

        // Shared with App Intents (`@Dependency`), so Siri and Shortcuts see
        // the same data and drive the same navigation.
        let state = AppState()
        _appState = State(initialValue: state)
        let container = container
        AppDependencyManager.shared.add(dependency: container)
        AppDependencyManager.shared.add(dependency: state)
        // Lets Siri phrases name a conversation or rule ("Practise At the dentist").
        AlltagShortcuts.updateAppShortcutParameters()
    }

    private func importTranslations() {
        UserDefaults(suiteName: TranslationInbox.group)?.set(AppTheme.shared.palette.rawValue, forKey: CompanionLook.Key.palette)
        do { try TranslationInbox.importSaved(into: container.mainContext) } catch {
            let logger = Logger(subsystem: "i8r4him.Alltag", category: "TranslationInbox")
            logger.error("Import deferred: \(error.localizedDescription, privacy: .public)")
        }
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(appState)
                .environment(\.services, services)
                .task {
                    importTranslations()
                    await SpotlightIndex.reindex(container)
                }
        }
        // Words saved during a session reach Spotlight when the app is left.
        .onChange(of: scenePhase) { _, phase in
            if phase == .active { importTranslations() }
            guard phase == .background else { return }
            Task { await SpotlightIndex.reindex(container) }
        }
        .onChange(of: AppTheme.shared.palette) { _, palette in
            UserDefaults(suiteName: TranslationInbox.group)?.set(palette.rawValue, forKey: CompanionLook.Key.palette)
        }
        .modelContainer(container)
    }
}
