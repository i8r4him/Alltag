//
//  ExamCard.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftData
import SwiftUI

/// The end of a rule with an exam: what the exam is, and the big button that
/// opens it. The exam zooms out of the button. It keeps its own state, so
/// opening it doesn't redraw the rule.
struct ExamCard: View {
    let rule: GrammarRule
    let isSolved: Bool

    @State private var isOpen = false
    @Namespace private var transition

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading, spacing: 6) {
                if isSolved {
                    Label("Passed", systemImage: "checkmark.circle.fill")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.accent)
                }
                Text("Three questions: easy, medium and hard")
                    .font(.title3.weight(.semibold))
                Group {
                    if isSolved {
                        Text("You can take it again whenever you like.")
                    } else {
                        Text("Get all three right to solve the rule.")
                    }
                }
                .font(.title3)
                .foregroundStyle(.secondary)
            }
            .fixedSize(horizontal: false, vertical: true)
            .accessibilityElement(children: .combine)
            // No GlassEffectContainer: the exam needs the button alone to zoom out of.
            Button { isOpen = true } label: {
                if isSolved {
                    Label("Take the exam again", systemImage: "checklist")
                } else {
                    Label("Start the exam", systemImage: "checklist")
                }
            }
            .buttonStyle(.primary)
            .matchedTransitionSource(id: rule.id, in: transition)
        }
        .padding(Spacing.cardLarge)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
        .fullScreenCover(isPresented: $isOpen) {
            ExamView(rule: rule)
                .navigationTransition(.zoom(sourceID: rule.id, in: transition))
        }
    }
}

/// A rule that isn't open yet: the rules of a level open in order.
struct LockedRuleCard: View {
    /// The rule to solve first.
    let blocker: GrammarRule

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Label("Locked", systemImage: "lock.fill")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.accent)
            Text("The rules of a level open in order.")
                .font(.title3.weight(.semibold))
            Text("Solve “\(blocker.title)” first.")
                .font(.title3)
                .foregroundStyle(.secondary)
        }
        .fixedSize(horizontal: false, vertical: true)
        .padding(Spacing.cardLarge)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    VStack(spacing: Spacing.grid) {
        ExamCard(rule: MockRules.accusative, isSolved: false)
        LockedRuleCard(blocker: MockRules.verbSecond)
    }
    .padding(Spacing.screen)
    .skyBackground()
    .fontDesign(.rounded)
    .modelContainer(AlltagStore.preview)
}
