//
//  HomeView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftData
import SwiftUI

/// Today: the orb and three numbers, Today's Focus, Situations, From your day
/// and Learning beyond the app. The title is "Alltag";
/// the toolbar holds Translate and a profile menu (Profile, Progress, Settings).
struct HomeView: View {
    @Environment(AppState.self) private var appState
    @Query private var profiles: [UserProfile]
    @Query private var memoryItems: [MemoryItem]
    @Query private var sessions: [PracticeSession]
    @Query private var records: [SessionRecord]
    // Temporary: the maintainer picks what Today's Focus is, then the others and the switcher go.
    @AppStorage("focusKind") private var focusKind = 0

    private var name: String { profiles.first?.name ?? "" }
    private var newReadingWords: Int { FromYourDay.newReadingWords(in: memoryItems) }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.section) {
                TodayHero(words: memoryItems.count, minutesSpoken: sessions.minutesSpoken, level: level,
                          onStart: { appState.present(.conversation(.freeTalk)) }, onProgress: { appState.open(.progress) })

                    VStack(alignment: .trailing, spacing: 8) {
                        focusSwitcher
                        FocusCard(focus: focus, isDone: focus.isDone(in: records)) { appState.present(focus.route) }
                    }
                    TodaySituations(situations: SituationCatalogue.suggestions(),
                                   onShowAll: { appState.open(.situations) },
                                   onSelect: { appState.present(.situation($0.id)) })

                    FromYourDayList(newReadingWords: newReadingWords,
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

    /// Today's Focus, of the kind being tried.
    private var focus: TodayFocus {
        let mistake = memoryItems.filter { $0.kind == .mistake && !$0.mistakeOriginal.isEmpty }.max { $0.createdAt < $1.createdAt }
        return .make(TodayFocus.Kind(rawValue: focusKind) ?? .situation, level: level, latestMistake: mistake)
    }

    private var focusSwitcher: some View {
        let count = TodayFocus.Kind.allCases.count
        return HStack(spacing: 10) {
            Button { focusKind = (focusKind + count - 1) % count } label: { Image(systemName: "chevron.left") }
            Text(verbatim: "\(focusKind + 1) / \(count)").monospacedDigit()
            Button { focusKind = (focusKind + 1) % count } label: { Image(systemName: "chevron.right") }
        }
        .font(.footnote.weight(.semibold))
        .padding(.horizontal, 12)
        .padding(.vertical, 7)
        .glassEffect(.regular, in: .capsule)
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
