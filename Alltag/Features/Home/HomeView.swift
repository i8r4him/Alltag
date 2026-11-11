//
//  HomeView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftData
import SwiftUI

/// Today: the orb and three numbers, Today's Focus, Coming up, From your day
/// and Learning beyond the app. The title is "Alltag";
/// the toolbar holds Translate and a profile menu (Profile, Progress, Settings).
struct HomeView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.services) private var services
    @Query private var profiles: [UserProfile]
    @Query private var memoryItems: [MemoryItem]
    @Query private var sessions: [PracticeSession]
    @State private var showsStreak = false
    @State private var events: [CalendarEvent] = []

    private var name: String { profiles.first?.name ?? "" }
    private var newReadingWords: Int { FromYourDay.newReadingWords(in: memoryItems) }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.section) {
                TodayHero(words: memoryItems.count, minutesSpoken: MockProgress.report.minutesSpoken, level: level,
                          onStart: startFocus, onProgress: { appState.open(.progress) })

                    FocusCard(action: startFocus)
                    if !events.isEmpty {
                        ComingUpCard(events: events, onShowAll: { appState.open(.comingUp) }, onSelect: { event in
                            if let scenario = event.scenario { appState.present(.conversation(scenario)) }
                        })
                    }

                    FromYourDayList(briefingWords: MockBriefing.briefing.words.count,
                                    newReadingWords: newReadingWords,
                                    writingMistakes: FromYourDay.writingMistakes(in: memoryItems),
                                    onOpen: { appState.open($0) },
                                    onPresent: { appState.present($0) })
                    BeyondRow { appState.open(.beyond) }
            }
            .padding(Spacing.screen)
        }
        .scrollIndicators(.hidden)
        .scrollEdgeEffectStyle(.soft, for: .all)
        .readableContentMargins()
        .skyBackground()
        .navigationTitle("Alltag")
        .toolbarTitleDisplayMode(.inlineLarge)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showsStreak = true
                } label: {
                    // Not a Label: toolbars show labels as icons only.
                    HStack(spacing: 4) {
                        Image(systemName: "flame.fill")
                            .foregroundStyle(
                                .linearGradient(colors: [.yellow, .orange], startPoint: .top, endPoint: .bottom)
                            )
                        Text(streak, format: .number)
                            .monospacedDigit()
                    }
                }
                .accessibilityLabel(Text("^[\(streak) day](inflect: true) in a row"))
                .popover(isPresented: $showsStreak) {
                    StreakPopover(days: streak, week: Streak.week(activity: sessions.map(\.date)))
                        .presentationCompactAdaptation(.popover)
                }
                .sensoryFeedback(.impact(weight: .light), trigger: showsStreak) { _, shows in shows }
            }
            ToolbarSpacer(.fixed, placement: .topBarTrailing)
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button { appState.open(.profile) } label: {
                        Label {
                            Text(name.isEmpty ? String(localized: "Profile") : name)
                            Text("View profile")
                        } icon: {
                            Image(systemName: "person.fill")
                        }
                    }
                    Divider()
                    Button("Progress", systemImage: "chart.line.uptrend.xyaxis") { appState.open(.progress) }
                    Divider()
                    Button("Share", systemImage: "square.and.arrow.up") {}
                    Button("Settings", systemImage: "gearshape.fill") { appState.open(.settings) }
                } label: {
                    profileLabel
                }
                .accessibilityLabel("Profile and settings")
            }
        }
        .task { events = (try? await services.calendar.upcomingEvents()) ?? [] }
    }

    private var level: Level { profiles.first?.level ?? .a1 }

    /// Days in a row with practice.
    private var streak: Int { Streak.days(activity: sessions.map(\.date)) }

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
