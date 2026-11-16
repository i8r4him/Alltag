//
//  GrammarView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftData
import SwiftUI

/// Learn › Grammar, on Today's clear glass: the learner's next rule at their
/// level, that rule in a real sentence of the day, the cheat sheets of their
/// level, and all rules by level.
struct GrammarView: View {
    @Environment(AppState.self) private var appState
    @Query private var solved: [SolvedRule]
    @Query private var profiles: [UserProfile]
    @State private var level: Level?
    @State private var opened = 0

    private var progress: GrammarProgress { GrammarProgress(solved: solved) }
    private var learnerLevel: Level { GrammarProgress.initialLevel(for: profiles.first?.level) }
    private var shownLevel: Level { level ?? learnerLevel }
    private var next: NextRule? { progress.nextRule(at: learnerLevel) }

    var body: some View {
        LearnScreen(title: "Grammar") {
            LearnSection(title: "Your next rule") {
                NextRuleCard(level: learnerLevel, next: next) { open($0.id) }
            }

            if let next, let sentence = RealLifeSentence.sentence(for: next.rule.id) {
                RuleInRealLifeSection(sentence: sentence)
            }

            CheatSheetsSection(level: learnerLevel)

            LearnSection(title: "All rules",
                         note: Text("\(progress.solvedCount(at: shownLevel)) of \(MockLevels.topics(for: shownLevel).count) solved")) {
                VStack(alignment: .leading, spacing: Spacing.grid) {
                    LevelChooser(selection: Binding(get: { shownLevel }, set: { level = $0 })) { level in
                        (progress.solvedCount(at: level), MockLevels.topics(for: level).count)
                    }
                    VStack(spacing: 0) {
                        ForEach(Array(MockLevels.topics(for: shownLevel).enumerated()), id: \.offset) { index, topic in
                            if index > 0 { Divider().padding(.leading, 40) }
                            TopicRow(topic: topic, status: progress.status(of: topic)) {
                                if let id = topic.ruleID { open(id) }
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .glassEffect(.regular, in: .rect(cornerRadius: Radius.card, style: .continuous))
                }
                .animation(.easeOut(duration: 0.2), value: shownLevel)
            }
        }
        .sensoryFeedback(.impact(weight: .medium), trigger: opened)
    }

    private func open(_ ruleID: String) {
        opened += 1
        appState.open(.rule(id: ruleID))
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
                    .frame(width: 10, height: 10)
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 2) {
                    Text(verbatim: topic.title)
                        .font(.headline)
                        .foregroundStyle(hasRule ? .primary : .secondary)
                    (hasRule ? Text(status.label) : Text("\(Text(status.label)) · lesson in a later version"))
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
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
