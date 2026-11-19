//
//  HomeView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftData
import SwiftUI

/// Today: the orb and three numbers, Today's Focus, Situations, From your day,
/// Your sessions and Learning beyond the app. The title is "Alltag";
/// the toolbar holds Translate and a profile menu (Profile, Progress, Settings).
struct HomeView: View {
    @Environment(AppState.self) private var appState
    @Query private var profiles: [UserProfile]
    @Query private var memoryItems: [MemoryItem]
    @Query private var sessions: [PracticeSession]
    @Query private var records: [SessionRecord]

    @Environment(\.reducesMotion) private var reduceMotion

    private var name: String { profiles.first?.name ?? "" }

    /// Today's orb carries the learner into the conversation; with Reduce Motion, the page just opens.
    private func startTalking(from frame: CGRect) {
        appState.talk(from: reduceMotion ? nil : OrbLaunch(frame: frame))
    }

    /// The orb is moving into the conversation, which shows Today through it while it fades in.
    private var isOrbAway: Bool {
        appState.fullScreen == .conversation(.freeTalk) && appState.orbLaunch != nil
    }
    private var newReadingWords: Int { FromYourDay.newReadingWords(in: memoryItems) }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.section) {
                TodayHero(words: memoryItems.count, minutesSpoken: sessions.minutesSpoken, level: level,
                          isOrbAway: isOrbAway, onStart: startTalking, onProgress: { appState.open(.progress) })

                    FocusCard(focus: focus, isDone: focus.isDone(in: records)) { appState.present(focus.route) }
                    TodaySituations(situations: SituationCatalogue.suggestions(),
                                   onShowAll: { appState.open(.situations) },
                                   onSelect: { appState.present(.situation($0.id)) })

                    FromYourDayList(newReadingWords: newReadingWords,
                                    writingMistakes: FromYourDay.writingMistakes(in: memoryItems),
                                    onOpen: { appState.open($0) },
                                    onPresent: { appState.present($0) })
                    SessionsLink { appState.open(.sessions) }
                        .fontDesign(.rounded)
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
                StreakButton()
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
    }

    private var level: Level { profiles.first?.level ?? .a1 }

    /// Today's Focus: the situation of the day.
    private var focus: TodayFocus { .make() }

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
