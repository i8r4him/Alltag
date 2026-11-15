//
//  GrammarView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftData
import SwiftUI

/// Learn › Grammar: the next rule to learn, all rules from the learner's
/// level, and the cheat sheets. Today's look: the sky, clear glass cards,
/// rounded type and the big button. Only real data: solved comes from
/// `SolvedRule`, and nothing claims a mistake the learner didn't make.
struct GrammarView: View {
    @Environment(AppState.self) private var appState
    @Query private var solved: [SolvedRule]
    @Query private var profiles: [UserProfile]
    @State private var opened = 0

    private var startLevel: Level { GrammarProgress.startLevel(for: profiles.first?.level) }

    var body: some View {
        let progress = GrammarProgress(solved: solved)
        LearnScreen(title: "Grammar") {
            NextRuleCard(rule: progress.nextRule(from: startLevel)) { open($0) }
            LearnSection(title: "All rules",
                         note: Text("\(progress.solvedCount) of \(progress.rules.count) solved")) {
                RuleList(rules: progress.ordered(from: startLevel), isSolved: progress.isSolved) { open($0) }
            }
            LearnSection(title: "Cheat sheets") {
                GrammarCheatSheets()
            }
        }
        .sensoryFeedback(.impact(weight: .medium), trigger: opened)
    }

    private func open(_ rule: GrammarRule) {
        opened += 1
        appState.open(.rule(id: rule.id))
    }
}

/// The Focus card's layout: the next rule, its artwork, and the big button.
/// When every rule is solved, it says so and has no button.
private struct NextRuleCard: View {
    let rule: GrammarRule?
    let onOpen: (GrammarRule) -> Void

    @ScaledMetric(relativeTo: .title3) private var artworkSize: CGFloat = 96

    var body: some View {
        VStack(spacing: 18) {
            HStack(alignment: .center, spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    if let rule {
                        Text("Your next rule · \(rule.level.title)")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.accent)
                        Text(verbatim: rule.title)
                            .font(.title3.weight(.semibold))
                        Text("It starts from a real moment, then you put a sentence in order yourself.")
                            .font(.body)
                            .foregroundStyle(.secondary)
                    } else {
                        Text("Every rule solved")
                            .font(.title3.weight(.semibold))
                        Text("More rules come in an update. Open any rule to practise it again.")
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }
                }
                .fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityElement(children: .combine)
                ScenarioArtwork(systemImage: rule?.systemImage ?? "checkmark.seal.fill")
                    .frame(width: artworkSize, height: artworkSize)
            }
            if let rule {
                GlassEffectContainer {
                    Button { onOpen(rule) } label: {
                        Label("Start this rule", systemImage: "play.fill")
                    }
                    .buttonStyle(.primary)
                }
            }
        }
        .padding(Spacing.cardLarge)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }
}

/// Every rule on one glass card, a row each with its level and whether it's solved.
private struct RuleList: View {
    let rules: [GrammarRule]
    let isSolved: (GrammarRule) -> Bool
    let onOpen: (GrammarRule) -> Void

    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(rules.enumerated()), id: \.element.id) { index, rule in
                if index > 0 { Divider().padding(.leading, 82) }
                RuleRow(rule: rule, isSolved: isSolved(rule)) { onOpen(rule) }
            }
        }
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }
}

private struct RuleRow: View {
    let rule: GrammarRule
    let isSolved: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                ScenarioArtwork(systemImage: rule.systemImage, symbolSize: 22, cornerRadius: 12)
                    .frame(width: 52, height: 52)
                VStack(alignment: .leading, spacing: 3) {
                    Text(verbatim: rule.title)
                        .font(.headline)
                    Group {
                        if isSolved {
                            Text("\(rule.level.title) · Solved")
                        } else {
                            Text("\(rule.level.title) · \(Text(rule.level.summary))")
                        }
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                if isSolved {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundStyle(.success)
                        .accessibilityHidden(true)
                }
                LearnChevron()
            }
            .multilineTextAlignment(.leading)
            .padding(Spacing.card)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    NavigationStack { GrammarView() }
        .environment(AppState())
        .modelContainer(AlltagStore.preview)
}
