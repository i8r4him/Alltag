//
//  HomeView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftData
import SwiftUI

/// Today: the orb and three numbers, Today's Focus, Coming up, From your day
/// and Learning beyond the app. The greeting is the large navigation title;
/// the toolbar's profile menu holds Profile, Progress and Settings.
struct HomeView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.services) private var services
    @Query private var profiles: [UserProfile]
    @Query private var memoryItems: [MemoryItem]
    @State private var events: [CalendarEvent] = []

    private var name: String { profiles.first?.name ?? "" }
    private var newReadingWords: Int { HomeGreeting.newReadingWords(in: memoryItems) }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.section) {
                TodayHero(words: memoryItems.count, minutesSpoken: MockProgress.report.minutesSpoken, level: level,
                          onStart: startFocus, onProgress: { appState.open(.progress) })

                VStack(spacing: Spacing.grid) {
                    FocusCard(action: startFocus)
                    if !events.isEmpty {
                        ComingUpCard(events: events) { event in
                            if let scenario = event.scenario { appState.present(.conversation(scenario)) }
                        }
                    }
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
        .background {
            // A warm glow behind the orb, fading into the screen.
            RadialGradient(colors: [.accentFill.opacity(0.22), .clear],
                           center: .top, startRadius: 0, endRadius: 420)
                .ignoresSafeArea()
                .background(.screenBackground)
        }
        .navigationTitle(Text(HomeGreeting.title(for: HomeGreeting.PartOfDay(date: .now), name: name)))
        .navigationBarTitleDisplayMode(.large)
        .navigationSubtitle(Text(HomeGreeting.subtitle(newWords: newReadingWords)))
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button { appState.open(.profile) } label: {
                        Label {
                            Text(name.isEmpty ? String(localized: "Profile") : name)
                            Text("View profile")
                        } icon: {
                            Image(systemName: "person.crop.circle")
                        }
                    }
                    Button("Progress", systemImage: "chart.line.uptrend.xyaxis") { appState.open(.progress) }
                    Divider()
                    Button("Settings", systemImage: "gearshape") { appState.open(.settings) }
                } label: {
                    profileLabel
                }
                .accessibilityLabel("Profile and settings")
            }
        }
        .task { events = (try? await services.calendar.upcomingEvents()) ?? [] }
    }

    private var level: Level { profiles.first?.level ?? .a1 }

    private func startFocus() {
        appState.present(.conversation(MockScenarios.todaysFocus))
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
