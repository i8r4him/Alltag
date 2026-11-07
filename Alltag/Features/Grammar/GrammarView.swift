//
//  GrammarView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftData
import SwiftUI

/// Grammar: rules from the learner's mistakes, and all topics by level.
struct GrammarView: View {
    @Environment(AppState.self) private var appState
    @Query private var solved: [SolvedRule]
    @Query private var profiles: [UserProfile]
    @State private var level: Level?

    private var progress: GrammarProgress { GrammarProgress(solved: solved) }
    private var shownLevel: Level { level ?? GrammarProgress.initialLevel(for: profiles.first?.level) }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                Eyebrow(title: "From your mistakes", tone: .mistake)
                    .padding(.horizontal, 4)
                    .padding(.top, 8)
                focusCard

                Picker("Level", selection: Binding(get: { shownLevel }, set: { level = $0 })) {
                    ForEach(Level.selectable) { Text(verbatim: $0.title).tag($0) }
                }
                .pickerStyle(.segmented)
                .padding(.top, 14)

                HStack(alignment: .firstTextBaseline) {
                    Text("\(shownLevel.title) · \(Text(shownLevel.summary))")
                        .textRole(.bodySmall)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text("\(progress.solvedCount(at: shownLevel)) of \(MockLevels.topics(for: shownLevel).count) solved")
                        .textRole(.meta)
                        .foregroundStyle(.tertiary)
                }
                .padding(.horizontal, 4)
                .padding(.top, 4)

                topicsCard

                Text("Topics follow the CEFR. Chapter references to your two grammar books get mapped in once the books are added.")
                    .textRole(.caption)
                    .foregroundStyle(.tertiary)
                    .padding(.horizontal, 4)
                    .padding(.top, 2)
            }
            .padding(.horizontal, Spacing.screen)
            .padding(.bottom, 24)
            .animation(.easeOut(duration: 0.2), value: shownLevel)
        }
        .readableContentMargins()
        .background(.screenBackground)
        .navigationTitle("Grammar")
        .navigationBarTitleDisplayMode(.large)
        .navigationSubtitle(Text("A1 to C1. Every rule starts with a real moment."))
        .smartBar(.grammar)
    }

    // MARK: Cards

    private var focusCard: some View {
        VStack(spacing: 0) {
            ForEach(Array(MockLevels.focus.enumerated()), id: \.offset) { index, focus in
                if let rule = MockRules.rule(id: focus.ruleID) {
                    if index > 0 { Divider().padding(.leading, 58) }
                    Button { appState.open(.rule(id: rule.id)) } label: {
                        HStack(spacing: 12) {
                            Text(verbatim: rule.level.title)
                                .textRole(.caption)
                                .fontWeight(.bold)
                                .frame(width: 30, height: 30)
                                .background(.surfaceSecondary, in: .rect(cornerRadius: 9, style: .continuous))
                            VStack(alignment: .leading, spacing: 2) {
                                Text(verbatim: rule.title).textRole(.body).fontWeight(.medium)
                                Text(verbatim: focus.reason).textRole(.meta).foregroundStyle(.secondary)
                            }
                            .multilineTextAlignment(.leading)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            chevron
                        }
                        .padding(.horizontal, Spacing.card)
                        .padding(.vertical, 14)
                        .contentShape(.rect)
                    }
                    .buttonStyle(.plain)
                    .accessibilityElement(children: .combine)
                }
            }
        }
        .background(.surface, in: .rect(cornerRadius: Radius.card, style: .continuous))
    }

    private var topicsCard: some View {
        VStack(spacing: 0) {
            ForEach(Array(MockLevels.topics(for: shownLevel).enumerated()), id: \.offset) { index, topic in
                if index > 0 { Divider().padding(.leading, 36) }
                TopicRow(topic: topic, status: progress.status(of: topic)) {
                    if let id = topic.ruleID { appState.open(.rule(id: id)) }
                }
            }
        }
        .background(.surface, in: .rect(cornerRadius: Radius.card, style: .continuous))
    }

    private var chevron: some View {
        Image(systemName: "chevron.right")
            .font(.footnote.weight(.semibold))
            .foregroundStyle(.tertiary)
            .accessibilityHidden(true)
    }
}

/// A topic with its status dot. Only topics with a full rule open.
private struct TopicRow: View {
    let topic: GrammarTopic
    let status: GrammarTopic.Status
    let onOpen: () -> Void

    private var hasRule: Bool { topic.ruleID != nil }

    var body: some View {
        Button(action: onOpen) {
            HStack(spacing: 12) {
                Circle()
                    .fill(dotColor)
                    .frame(width: 8, height: 8)
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 2) {
                    Text(verbatim: topic.title)
                        .textRole(.body)
                        .fontWeight(.medium)
                        .foregroundStyle(hasRule ? .primary : .secondary)
                    (hasRule ? Text(status.label) : Text("\(Text(status.label)) · lesson in a later version"))
                        .textRole(.meta)
                        .foregroundStyle(.tertiary)
                }
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                if hasRule {
                    Image(systemName: "chevron.right")
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(.tertiary)
                        .accessibilityHidden(true)
                }
            }
            .padding(.horizontal, Spacing.card)
            .padding(.vertical, 14)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .allowsHitTesting(hasRule)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(hasRule ? .isButton : [])
    }

    private var dotColor: Color {
        switch status {
        case .solved: .success
        case .learning: .accentFill
        case .mistake: .mistake
        case .new: .surfaceTertiary
        }
    }
}

#Preview {
    NavigationStack { GrammarView() }
        .environment(AppState())
        .modelContainer(AlltagStore.preview)
}
