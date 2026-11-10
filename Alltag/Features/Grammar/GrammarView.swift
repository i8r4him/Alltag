//
//  GrammarView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftData
import SwiftUI

/// Learn › Grammar: the rules you get wrong, cheat sheets, and all rules by level.
struct GrammarView: View {
    @Environment(AppState.self) private var appState
    @Query private var solved: [SolvedRule]
    @Query private var profiles: [UserProfile]
    @State private var level: Level?

    private var progress: GrammarProgress { GrammarProgress(solved: solved) }
    private var shownLevel: Level { level ?? GrammarProgress.initialLevel(for: profiles.first?.level) }

    @State private var taps = 0

    private var focusRules: [(rule: GrammarRule, reason: String)] {
        MockLevels.focus.compactMap { focus in MockRules.rule(id: focus.ruleID).map { ($0, focus.reason) } }
    }

    var body: some View {
        LearnScreen(title: "Grammar") {
            if let first = focusRules.first {
                LearnSection(title: "Worth a look") {
                    VStack(spacing: Spacing.grid) {
                        LearnHeroCard(title: Text(verbatim: first.rule.title),
                                      detail: Text(verbatim: first.reason),
                                      systemImage: "text.badge.checkmark",
                                      buttonTitle: "Practise this rule",
                                      buttonImage: "arrow.trianglehead.counterclockwise",
                                      isProminent: true) { open(first.rule.id) }
                        if focusRules.count > 1 {
                            LearnList {
                                ForEach(focusRules.dropFirst(), id: \.rule.id) { focus in
                                    LearnRow(systemImage: "exclamationmark.bubble.fill",
                                             title: Text(verbatim: focus.rule.title),
                                             detail: Text(verbatim: focus.reason)) { open(focus.rule.id) }
                                }
                            }
                        }
                    }
                }
            }

            LearnSection(title: "Cheat sheets") {
                HStack(spacing: Spacing.grid) {
                    CheatSheetTile(german: "der · die · das", title: "Articles") { taps += 1 }
                    CheatSheetTile(german: "Akk · Dat", title: "Cases") { taps += 1 }
                    CheatSheetTile(german: "Verb 2", title: "Word order") { taps += 1 }
                }
            }

            LearnSection(title: "All rules",
                         note: Text("\(progress.solvedCount(at: shownLevel)) of \(MockLevels.topics(for: shownLevel).count) solved")) {
                VStack(alignment: .leading, spacing: Spacing.grid) {
                    Picker("Level", selection: Binding(get: { shownLevel }, set: { level = $0 })) {
                        ForEach(Level.selectable) { Text(verbatim: $0.title).tag($0) }
                    }
                    .pickerStyle(.segmented)
                    Text(shownLevel.summary)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 4)
                    VStack(spacing: 0) {
                        ForEach(Array(MockLevels.topics(for: shownLevel).enumerated()), id: \.offset) { index, topic in
                            if index > 0 { Divider().padding(.leading, 40) }
                            TopicRow(topic: topic, status: progress.status(of: topic)) {
                                if let id = topic.ruleID { open(id) }
                            }
                        }
                    }
                    .learnSurface(radius: Radius.card)
                }
                .animation(.easeOut(duration: 0.2), value: shownLevel)
            }
        }
        .sensoryFeedback(.impact(weight: .light), trigger: taps)
    }

    private func open(_ ruleID: String) {
        taps += 1
        appState.open(.rule(id: ruleID))
    }
}

/// A small square with a German pattern and what it's about. The sheets come later.
private struct CheatSheetTile: View {
    let german: String
    let title: LocalizedStringResource
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 4) {
                Spacer(minLength: 0)
                Text(verbatim: german)
                    .font(.headline)
                    .foregroundStyle(.accent)
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                Text(title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(14)
            .frame(maxWidth: .infinity, alignment: .leading)
            .aspectRatio(1, contentMode: .fit)
            .learnSurface(radius: 26)
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
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
