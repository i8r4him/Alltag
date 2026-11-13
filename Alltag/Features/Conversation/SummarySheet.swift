//
//  SummarySheet.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Shown after the last line: what happened, what was saved, and what to do next.
struct SummarySheet: View {
    let scenario: Scenario
    let turns: Int
    let fixes: Int
    var wasLive = false
    /// Checking a live conversation for mistakes.
    var review: ConversationModel.LiveReview = .none
    let onPractise: () -> Void
    let onDone: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading, spacing: 6) {
                if wasLive {
                    Text("Live practice ended")
                        .textRole(.title2)
                        .accessibilityAddTraits(.isHeader)
                } else {
                    Eyebrow(title: "Conversation complete")
                    Text(verbatim: scenario.completion)
                        .textRole(.title2)
                        .accessibilityAddTraits(.isHeader)
                }
            }

            HStack(spacing: 8) {
                // The number is shown large, so the labels carry only the words.
                StatTile(value: turns, label: turns == 1 ? Text("turn spoken") : Text("turns spoken"))
                if showsFixes { StatTile(value: fixes, label: fixes == 1 ? Text("thing to fix") : Text("things to fix")) }
                if !scenario.savedPhrases.isEmpty {
                    StatTile(value: scenario.savedPhrases.count,
                             label: scenario.savedPhrases.count == 1 ? Text("phrase saved") : Text("phrases saved"))
                }
            }

            if !scenario.savedPhrases.isEmpty {
                savedLine
                    .textRole(.bodySmall)
                    .foregroundStyle(.secondary)
            }

            if review == .reviewing {
                Label {
                    Text("Checking your German on your iPhone…")
                } icon: {
                    ProgressView().controlSize(.small)
                }
                .textRole(.bodySmall)
                .foregroundStyle(.secondary)
            }

            VStack(spacing: 8) {
                if showsFixes, fixes > 0 {
                    Button(action: onPractise) {
                        Text("Practise your fixes · 1 min")
                    }
                    .buttonStyle(.primary)
                }
                Button(action: onDone) {
                    Text("Done").frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .buttonBorderShape(.capsule)
                .controlSize(.extraLarge)
                .tint(.primary)
            }
        }
        .padding(.horizontal, 22)
        .padding(.top, 24)
        .frame(maxHeight: .infinity, alignment: .top)
        .presentationDetents([.medium])
        .presentationDragIndicator(.visible)
        .presentationBackground(.surface)
    }

    /// Scripted conversations always know the fixes; live ones once they've been checked.
    private var showsFixes: Bool { !wasLive || review == .done }

    /// "Saved to Memory: **verschieben**, **wenn mir das passt**."
    private var savedLine: Text {
        let phrases = scenario.savedPhrases.map { Text(verbatim: $0.german).bold().foregroundStyle(.primary) }
        let joined = phrases.dropFirst().reduce(phrases.first ?? Text(verbatim: "")) { Text("\($0), \($1)") }
        return Text("Saved to Memory: \(joined).")
    }
}

/// A number with a label, e.g. "2 · turns spoken".
private struct StatTile: View {
    let value: Int
    let label: Text

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(value, format: .number)
                .textRole(.sectionHeader)
                .accessibilityHidden(true)
            label
                .textRole(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(12)
        .background(.surfaceSecondary, in: .rect(cornerRadius: Radius.tile, style: .continuous))
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    Color.black
        .sheet(isPresented: .constant(true)) {
            SummarySheet(scenario: MockScenarios.dentist, turns: 2, fixes: 1, onPractise: {}, onDone: {})
        }
}
