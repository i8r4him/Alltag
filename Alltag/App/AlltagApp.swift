//
//  AlltagApp.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import AppIntents
import SwiftData
import SwiftUI

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

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(appState)
                .environment(\.services, services)
                .task { await SpotlightIndex.reindex(container) }
        }
        // Words saved during a session reach Spotlight when the app is left.
        .onChange(of: scenePhase) { _, phase in
            guard phase == .background else { return }
            Task { await SpotlightIndex.reindex(container) }
        }
        .modelContainer(container)
    }
}
