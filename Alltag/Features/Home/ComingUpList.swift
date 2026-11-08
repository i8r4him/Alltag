//
//  ComingUpList.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 08.11.26.
//

import SwiftUI

/// Everything coming up in the learner's calendar, grouped by day.
/// Tapping an event rehearses its conversation.
struct ComingUpList: View {
    @Environment(AppState.self) private var appState
    @Environment(\.services) private var services
    @State private var events: [CalendarEvent]?

    var body: some View {
        Group {
            if let events, events.isEmpty {
                ContentUnavailableView("Nothing coming up", systemImage: "calendar",
                                       description: Text("Events from your Calendar will appear here to rehearse."))
            } else {
                List {
                    ForEach(ComingUp.days(events ?? []), id: \.day) { group in
                        Section {
                            ForEach(group.events) { event in
                                Button { start(event) } label: { EventRow(event: event) }
                                    .disabled(event.scenario == nil)
                                    // Rows keep their own colours, not the list's tint.
                                    .tint(.primary)
                            }
                        } header: {
                            Text(group.day, format: .dateTime.weekday(.wide).day().month(.wide))
                        }
                    }
                }
            }
        }
        .navigationTitle("Coming up")
        .toolbarTitleDisplayMode(.inlineLarge)
        .scrollEdgeEffectStyle(.soft, for: .all)
        .task { events = (try? await services.calendar.upcomingEvents()) ?? [] }
    }

    private func start(_ event: CalendarEvent) {
        if let scenario = event.scenario { appState.present(.conversation(scenario)) }
    }
}

private struct EventRow: View {
    let event: CalendarEvent

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: event.systemImage)
                .font(.title3)
                .frame(width: 40, height: 40)
                .background(.controlFill, in: .rect(cornerRadius: 10, style: .continuous))
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 2) {
                Text(verbatim: event.title)
                    .font(.body.weight(.semibold))
                    .foregroundStyle(.primary)
                Text(event.start, format: .dateTime.hour().minute())
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer(minLength: 8)
            if event.scenario != nil {
                Label("\(event.rehearsalMinutes) min", systemImage: "waveform")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.accent)
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityHint(event.scenario == nil ? Text(verbatim: "") : Text("Rehearse this conversation."))
    }
}

#Preview {
    NavigationStack { ComingUpList() }
        .environment(AppState())
}
