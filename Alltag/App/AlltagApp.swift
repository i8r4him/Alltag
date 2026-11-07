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
    }

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(appState)
                .environment(\.services, services)
        }
        .modelContainer(container)
    }
}
