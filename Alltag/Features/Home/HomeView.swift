//
//  HomeView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftData
import SwiftUI

/// Home: Today's Focus, Coming up, the entry grid, Grammar, From your day and
/// Learning beyond the app. The greeting is the large navigation title; the
/// toolbar holds Profile and Settings.
struct HomeView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.services) private var services
    @Query private var profiles: [UserProfile]
    @Query private var memoryItems: [MemoryItem]
    @Query private var translations: [SavedTranslation]
    @State private var events: [CalendarEvent] = []

    private var name: String { profiles.first?.name ?? "" }
    private var newReadingWords: Int { HomeGreeting.newReadingWords(in: memoryItems) }

    private var status: HomeStatus {
        HomeStatus(translations: translations, memoryItems: memoryItems, level: profiles.first?.level ?? .a1)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.section) {
                VStack(spacing: Spacing.grid) {
                    FocusCard { appState.present(.conversation(MockScenarios.todaysFocus)) }
                    if !events.isEmpty {
                        ComingUpCard(events: events) { event in
                            if let scenario = event.scenario { appState.present(.conversation(scenario)) }
                        }
                    }
                    EntryGrid(status: status) { appState.open($0) }
                    GrammarCard(rulesWorthALook: status.mistakeRules) { appState.open(.grammar) }
                }

                VStack(spacing: Spacing.grid) {
                    FromYourDayList(briefingWords: MockBriefing.briefing.words.count,
                                    newReadingWords: newReadingWords,
                                    writingMistakes: FromYourDay.writingMistakes(in: memoryItems),
                                    onOpen: { appState.open($0) },
                                    onPresent: { appState.present($0) })
                    BeyondRow { appState.open(.beyond) }
                }
            }
            .padding(Spacing.screen)
        }
        .scrollIndicators(.hidden)
        .scrollEdgeEffectStyle(.soft, for: .all)
        .readableContentMargins()
        .background(.screenBackground)
        .navigationTitle(Text(HomeGreeting.title(for: HomeGreeting.PartOfDay(date: .now), name: name)))
        .navigationBarTitleDisplayMode(.large)
        .navigationSubtitle(Text(HomeGreeting.subtitle(newWords: newReadingWords)))
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button { appState.open(.profile) } label: { profileLabel }
                    .accessibilityLabel("Profile")
            }

            ToolbarItem(placement: .topBarTrailing) {
                Button("Settings", systemImage: "gearshape") { appState.open(.settings) }
            }
        }
        .smartBar(.home)
        .task { events = (try? await services.calendar.upcomingEvents()) ?? [] }
    }

    /// The learner's initial, or the person symbol before a name is set.
    @ViewBuilder
    private var profileLabel: some View {
        if let initial = name.trimmingCharacters(in: .whitespaces).first {
            Text(verbatim: String(initial).uppercased())
                .fontWeight(.semibold)
        } else {
            Image(systemName: "person.crop.circle")
        }
    }
}

#Preview {
    NavigationStack { HomeView() }
        .environment(AppState())
        .modelContainer(AlltagStore.preview)
}
