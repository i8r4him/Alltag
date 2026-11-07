//
//  HomeView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftData
import SwiftUI

/// Home: top bar, greeting and — until #24–#26 add the cards — a temporary
/// list of every route so all screens and flows can be reached.
struct HomeView: View {
    @Environment(AppState.self) private var appState
    @Query private var profiles: [UserProfile]
    @Query private var memoryItems: [MemoryItem]
    @Environment(\.services) private var services
    @State private var events: [CalendarEvent] = []

    private var name: String { profiles.first?.name ?? "" }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.section) {
                HomeGreetingView(name: name, newWords: HomeGreeting.newReadingWords(in: memoryItems))
                VStack(spacing: Spacing.grid) {
                    FocusCard { appState.present(.conversation(.dentist)) }
                    if !events.isEmpty {
                        ComingUpCard(events: events) { event in
                            if let scenario = event.scenario { appState.present(.conversation(scenario)) }
                        }
                    }
                }
                Text("Temporary until the Home cards are built (#24–#26).")
                    .textRole(.meta)
                    .foregroundStyle(.tertiary)
                group("Screens", entries: Self.screens.map { entry in
                    Entry(title: entry.title, symbol: entry.symbol) { appState.open(entry.route) }
                })
                group("Full-screen flows", entries: Self.flows.map { entry in
                    Entry(title: entry.title, symbol: entry.symbol) { appState.present(entry.route) }
                })
            }
            .padding(Spacing.screen)
        }
        .background(.screenBackground)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button { appState.open(.profile) } label: {
                    Avatar(name: name, diameter: 36)
                }
                .accessibilityLabel("Profile")
            }
            // A plain circle, as in the design, instead of a glass capsule.
            .sharedBackgroundVisibility(.hidden)

            ToolbarItem(placement: .topBarTrailing) {
                Button("Settings", systemImage: "gearshape") { appState.open(.settings) }
            }
        }
        .smartBar(.home)
        .task { events = (try? await services.calendar.upcomingEvents()) ?? [] }
    }

    private struct Entry {
        let title: LocalizedStringKey
        let symbol: String
        let action: () -> Void
    }

    private struct Destination<Target> {
        let title: LocalizedStringKey
        let symbol: String
        let route: Target
    }

    private func group(_ title: LocalizedStringKey, entries: [Entry]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            SectionHeader(title, style: .grouped)
            VStack(spacing: 0) {
                ForEach(entries.indices, id: \.self) { index in
                    let entry = entries[index]
                    Button(action: entry.action) {
                        CardRow(title: entry.title, systemImage: entry.symbol)
                    }
                    .buttonStyle(.plain)
                    if index < entries.count - 1 {
                        Divider().padding(.leading, 42)
                    }
                }
            }
            .padding(.horizontal, Spacing.card)
            .background(.surface, in: .rect(cornerRadius: Radius.card, style: .continuous))
        }
    }

    private static let screens: [Destination<Route>] = [
        Destination(title: "Translate", symbol: "translate", route: .translate()),
        Destination(title: "Memory", symbol: "book", route: .memory),
        Destination(title: "Learn", symbol: "bolt", route: .learn),
        Destination(title: "Grammar", symbol: "text.badge.checkmark", route: .grammar),
        Destination(title: "Rule · weil", symbol: "text.alignleft", route: .rule(id: "weil")),
        Destination(title: "Progress", symbol: "chart.line.uptrend.xyaxis", route: .progress),
        Destination(title: "Profile", symbol: "person.crop.circle", route: .profile),
        Destination(title: "Settings", symbol: "gearshape", route: .settings),
        Destination(title: "Beyond the app", symbol: "sparkles", route: .beyond),
        Destination(title: "Debrief", symbol: "text.bubble", route: .debrief),
        Destination(title: "Briefing", symbol: "headphones", route: .briefing)
    ]

    private static let flows: [Destination<FullScreenRoute>] = [
        Destination(title: "Conversation · dentist", symbol: "waveform", route: .conversation(.dentist)),
        Destination(title: "Activity · fix your mistakes", symbol: "checkmark.circle", route: .activity(.mistakes)),
        Destination(title: "Replay onboarding", symbol: "arrow.counterclockwise", route: .onboarding)
    ]
}

#Preview {
    NavigationStack { HomeView() }
        .environment(AppState())
        .modelContainer(AlltagStore.preview)
}
