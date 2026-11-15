//
//  SessionDetailView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 12.11.26.
//

import SwiftData
import SwiftUI

/// One saved session: what was said, line by line, with the fixes; and for a
/// 60-second talk, the recording to listen to.
struct SessionDetailView: View {
    @Environment(AppState.self) private var appState
    @Query private var sessions: [SessionRecord]
    @State private var player = RecordingPlayer()

    init(id: UUID) {
        _sessions = Query(filter: #Predicate<SessionRecord> { $0.uuid == id })
    }

    var body: some View {
        Group {
            if let session = sessions.first {
                content(session)
            } else {
                ContentUnavailableView("Session not found", systemImage: "clock.arrow.circlepath",
                                       description: Text("This session isn't on this iPhone any more."))
            }
        }
        .fontDesign(.rounded)
        .skyBackground()
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear { player.stop() }
    }

    private func content(_ session: SessionRecord) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(verbatim: session.title)
                        .font(.title2.weight(.bold))
                        .accessibilityAddTraits(.isHeader)
                    Text(session.date, format: .dateTime.weekday(.wide).day().month(.wide).hour().minute())
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 4)

                if let url = SessionHistory.audioURL(of: session) {
                    Button { player.toggle(url) } label: {
                        HStack(spacing: Spacing.grid) {
                            Image(systemName: player.isPlaying ? "stop.fill" : "play.fill")
                                .font(.title3)
                                .frame(width: 34, height: 34)
                                .contentTransition(.symbolEffect(.replace))
                            Text(player.isPlaying ? "Stop" : "Listen to yourself")
                                .font(.headline)
                            Spacer(minLength: 0)
                            Text(Duration.seconds(session.secondsSpoken), format: .time(pattern: .minuteSecond))
                                .font(.subheadline)
                                .monospacedDigit()
                                .foregroundStyle(.secondary)
                        }
                        .padding(Spacing.card)
                        .contentShape(.rect)
                    }
                    .buttonStyle(.plain)
                    .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
                }

                VStack(alignment: .leading, spacing: 14) {
                    ForEach(Array(session.lines.enumerated()), id: \.offset) { _, line in
                        SessionLineView(line: line)
                    }
                }
                .padding(Spacing.cardLarge)
                .frame(maxWidth: .infinity, alignment: .leading)
                .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
            }
            .padding(Spacing.screen)
        }
        .scrollEdgeEffectStyle(.soft, for: .all)
        .scrollIndicators(.hidden)
        .readableContentMargins()
        .safeAreaInset(edge: .bottom) {
            if session.fixCount > 0 {
                Button { appState.present(.activity(.mistakes)) } label: { Text("Practise your fixes") }
                    .buttonStyle(.primary)
                    .padding(.horizontal, 22)
                    .padding(.bottom, 12)
            }
        }
    }
}

/// The companion's lines plain, the learner's in the theme-tinted bubble with their feedback.
private struct SessionLineView: View {
    let line: SessionLine

    var body: some View {
        if line.isLearner {
            VStack(alignment: .leading, spacing: 8) {
                Text(verbatim: line.german)
                    .font(.title3)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 11)
                    .background {
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .fill(.accentFill.opacity(0.22))
                            .overlay {
                                RoundedRectangle(cornerRadius: 22, style: .continuous)
                                    .strokeBorder(.accent.opacity(0.35), lineWidth: 1)
                            }
                    }
                if let feedback = line.feedback?.feedback, feedback.kind != .good {
                    FeedbackCard(feedback: feedback)
                }
            }
            .textSelection(.enabled)
            .environment(\.locale, Locale(identifier: "de"))
            .accessibilityElement(children: .combine)
        } else {
            Text(verbatim: line.german)
                .font(.title3)
                .foregroundStyle(.secondary)
                .textSelection(.enabled)
                .environment(\.locale, Locale(identifier: "de"))
        }
    }
}
