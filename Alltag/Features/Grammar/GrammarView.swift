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
/// level, and all rules by level. The rules of a level open in order.
struct GrammarView: View {
    @Environment(AppState.self) private var appState
    @Query private var solved: [SolvedRule]
    @Query private var profiles: [UserProfile]
    @State private var opened = 0

    private var learnerLevel: Level { GrammarProgress.initialLevel(for: profiles.first?.level) }

    var body: some View {
        let progress = GrammarProgress(solved: solved)
        let next = progress.nextRule(at: learnerLevel)
        LearnScreen(title: "Grammar") {
            LearnSection(title: "Your next rule") {
                NextRuleCard(level: learnerLevel, next: next) { open($0.id) }
            }

            if let next, let sentence = RealLifeSentence.sentence(for: next.rule.id) {
                RuleInRealLifeSection(sentence: sentence)
            }

            CheatSheetsSection(level: learnerLevel)

            AllRulesSection(progress: progress, learnerLevel: learnerLevel, onOpen: open)
        }
        .sensoryFeedback(.impact(weight: .medium), trigger: opened)
    }

    private func open(_ ruleID: String) {
        opened += 1
        appState.open(.rule(id: ruleID))
    }
}

/// All rules, one level at a time. The chosen level lives here, so switching
/// levels redraws only this list, not the cards above it.
private struct AllRulesSection: View {
    let progress: GrammarProgress
    let learnerLevel: Level
    let onOpen: (String) -> Void
    @State private var level: Level?

    private var shownLevel: Level { level ?? learnerLevel }

    var body: some View {
        let topics = MockLevels.topics(for: shownLevel)
        let blockers = progress.blockers(at: shownLevel)
        LearnSection(title: "All rules",
                     note: Text("\(progress.solvedCount(at: shownLevel)) of \(topics.count) solved")) {
            VStack(alignment: .leading, spacing: Spacing.grid) {
                LevelChooser(selection: Binding(get: { shownLevel }, set: { level = $0 })) { level in
                    (progress.solvedCount(at: level), MockLevels.topics(for: level).count)
                }
                VStack(spacing: 0) {
                    ForEach(Array(topics.enumerated()), id: \.offset) { index, topic in
                        if index > 0 { Divider().padding(.leading, 40) }
                        TopicRow(topic: topic, status: progress.status(of: topic),
                                 blocker: topic.ruleID.flatMap { blockers[$0] }) {
                            if let id = topic.ruleID { onOpen(id) }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .glassEffect(.regular, in: .rect(cornerRadius: Radius.card, style: .continuous))
            }
            .animation(.easeOut(duration: 0.2), value: shownLevel)
        }
    }
}

/// A topic with its status dot. Only topics with a full rule open, and a
/// rule only once the rules before it at its level are solved: until then it
/// shows a lock and the rule to solve first.
private struct TopicRow: View {
    let topic: GrammarTopic
    let status: GrammarTopic.Status
    /// The rule to solve before this one opens, if it is locked.
    let blocker: GrammarRule?
    let onOpen: () -> Void

    private var hasRule: Bool { topic.ruleID != nil }
    private var opens: Bool { hasRule && blocker == nil }

    var body: some View {
        Button(action: onOpen) {
            HStack(spacing: 12) {
                if blocker == nil {
                    Circle()
                        .fill(dotColor)
                        .frame(width: 10, height: 10)
                        .accessibilityHidden(true)
                } else {
                    Image(systemName: "lock.fill")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .frame(width: 10)
                        .accessibilityHidden(true)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(verbatim: topic.title)
                        .font(.headline)
                        .foregroundStyle(opens ? .primary : .secondary)
                    detail
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                if opens {
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
        .allowsHitTesting(opens)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(opens ? .isButton : [])
    }

    private var detail: Text {
        if let blocker { return Text("Locked · solve “\(blocker.title)” first") }
        return hasRule ? Text(status.label) : Text("\(Text(status.label)) · lesson in a later version")
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
