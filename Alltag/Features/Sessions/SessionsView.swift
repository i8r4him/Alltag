//
//  SessionsView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 12.11.26.
//

import SwiftData
import SwiftUI

/// "Your sessions" under Fix your mistakes on Learn: how many there are, and the way to them.
struct SessionsLink: View {
    let action: () -> Void

    @Query private var sessions: [SessionRecord]

    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.grid) {
                Image(systemName: "clock.arrow.circlepath")
                    .font(.title3)
                    .foregroundStyle(.accent)
                    .frame(width: 34, height: 34)
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Your sessions")
                        .font(.headline)
                    Group {
                        if sessions.isEmpty {
                            Text("Everything you say is kept here to reread.")
                        } else {
                            Text("^[\(sessions.count) session](inflect: true) to reread")
                        }
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }
                .multilineTextAlignment(.leading)
                Spacer(minLength: 0)
                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.tertiary)
                    .accessibilityHidden(true)
            }
            .padding(Spacing.card)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
        .accessibilityElement(children: .combine)
    }
}

/// Every saved session, newest first. Swipe to delete one.
struct SessionsView: View {
    @Environment(AppState.self) private var appState
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \SessionRecord.date, order: .reverse) private var sessions: [SessionRecord]
    @State private var isConfirmingDeleteAll = false

    var body: some View {
        Group {
            if sessions.isEmpty {
                ContentUnavailableView("No sessions yet", systemImage: "clock.arrow.circlepath",
                                       description: Text("Talk to the companion or try 60 seconds. Every session is kept here."))
            } else {
                List {
                    ForEach(sessions) { session in
                        Button { appState.open(.session(session.uuid)) } label: { SessionRow(session: session) }
                            .tint(.primary)
                            .swipeActions {
                                Button("Delete", systemImage: "trash", role: .destructive) {
                                    SessionHistory.delete(session, in: modelContext)
                                }
                            }
                    }
                }
                .scrollIndicators(.hidden)
                .scrollEdgeEffectStyle(.soft, for: .all)
                .scrollContentBackground(.hidden)
            }
        }
        .fontDesign(.rounded)
        .skyBackground()
        .navigationTitle("Your sessions")
        .toolbarTitleDisplayMode(.inlineLarge)
        .toolbar {
            if !sessions.isEmpty {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu("More", systemImage: "ellipsis") {
                        Button("Delete all sessions", systemImage: "trash", role: .destructive) { isConfirmingDeleteAll = true }
                    }
                }
            }
        }
        .confirmationDialog("Delete all sessions?", isPresented: $isConfirmingDeleteAll, titleVisibility: .visible) {
            Button("Delete all", role: .destructive) { SessionHistory.deleteAll(in: modelContext) }
        } message: {
            Text("The texts and recordings are removed from this iPhone. Your saved fixes stay.")
        }
    }
}

private struct SessionRow: View {
    let session: SessionRecord

    var body: some View {
        HStack(spacing: 14) {
            Image(systemName: session.kind.systemImage)
                .font(.title3)
                .foregroundStyle(.accent)
                .frame(width: 40, height: 40)
                .background(.accent.opacity(AccentTint.selected), in: .rect(cornerRadius: 10, style: .continuous))
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 2) {
                Text(verbatim: session.title)
                    .font(.body.weight(.semibold))
                    .lineLimit(2)
                Text(session.date, format: .dateTime.weekday(.abbreviated).day().month(.abbreviated).hour().minute())
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer(minLength: 8)
            if session.fixCount > 0 {
                Text("^[\(session.fixCount) fix](inflect: true)")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.accent)
            }
        }
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    NavigationStack { SessionsView() }
        .environment(AppState())
        .modelContainer(AlltagStore.preview)
}
