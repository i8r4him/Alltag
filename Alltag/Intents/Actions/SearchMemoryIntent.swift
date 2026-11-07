//
//  SearchMemoryIntent.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import AppIntents

/// Searches the learner's words and phrases. Conforms to the system search
/// schema, so Siri and Apple Intelligence can search Alltag directly.
@AppIntent(schema: .system.searchInApp)
struct SearchMemoryIntent: ShowInAppSearchResultsIntent {
    static let searchScopes: [StringSearchScope] = [.general]

    var criteria: StringSearchCriteria

    @Dependency private var appState: AppState

    @MainActor
    func perform() async throws -> some IntentResult {
        appState.show(.memory(search: criteria.term))
        return .result()
    }
}
