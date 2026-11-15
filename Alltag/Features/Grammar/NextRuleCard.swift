//
//  NextRuleCard.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// "Your next rule": the learner's next rule at their level, in order, on
/// Today's clear glass card with the artwork and the big button. When the
/// level is done it says so and goes on to the level above; when every rule
/// is done it says that instead.
struct NextRuleCard: View {
    /// The learner's own level.
    let level: Level
    /// `nil` once every rule is done.
    let next: NextRule?
    let onOpen: (GrammarRule) -> Void

    @ScaledMetric(relativeTo: .title3) private var artworkSize: CGFloat = 96

    var body: some View {
        VStack(spacing: 18) {
            HStack(alignment: .center, spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    eyebrow
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.accent)
                    if let next {
                        Text(verbatim: next.rule.title)
                            .font(.title3.weight(.semibold))
                            .fixedSize(horizontal: false, vertical: true)
                        Text(verbatim: next.rule.place)
                            .font(.title3)
                            .foregroundStyle(.secondary)
                    } else {
                        Text("Every rule is done")
                            .font(.title3.weight(.semibold))
                        Text("New rules come with updates.")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityElement(children: .combine)
                ScenarioArtwork(systemImage: next?.rule.systemImage ?? "checkmark.seal")
                    .frame(width: artworkSize, height: artworkSize)
            }
            if let next {
                GlassEffectContainer {
                    Button { onOpen(next.rule) } label: {
                        Label("Start this rule", systemImage: "text.badge.checkmark")
                    }
                    .buttonStyle(.primary)
                }
            }
        }
        .padding(Spacing.cardLarge)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }

    /// "A2 · Rule 1 of 2", or "A2 done · B1, rule 1 of 1" once the level is done.
    @ViewBuilder
    private var eyebrow: some View {
        if let next, next.isLevelDone {
            Label {
                Text("\(level.title) done · \(next.rule.level.title), rule \(next.number) of \(next.count)")
            } icon: {
                Image(systemName: "checkmark.circle.fill")
            }
        } else if let next {
            Text("\(level.title) · Rule \(next.number) of \(next.count)")
        } else {
            Label {
                Text("\(level.title) done")
            } icon: {
                Image(systemName: "checkmark.circle.fill")
            }
        }
    }
}

#Preview {
    VStack(spacing: Spacing.grid) {
        NextRuleCard(level: .a2, next: GrammarProgress(solved: []).nextRule(at: .a2)) { _ in }
        NextRuleCard(level: .c1, next: nil) { _ in }
    }
    .padding(Spacing.screen)
    .skyBackground()
    .fontDesign(.rounded)
}
