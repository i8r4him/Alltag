//
//  AlltagApp.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftData
import SwiftUI

@main
struct AlltagApp: App {
    private let container: ModelContainer
    @State private var appState = AppState()
    private let services = AppServices.live()

    init() {
        do {
            container = try AlltagStore.makeContainer()
        } catch {
            fatalError("Could not open the Alltag store: \(error)")
        }
        #if DEBUG
        try? AlltagStore.seedSampleDataIfEmpty(container.mainContext)
        #endif
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
