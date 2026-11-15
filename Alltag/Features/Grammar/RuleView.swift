//
//  RuleView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftData
import SwiftUI

/// A grammar rule, taught from a real moment in numbered steps.
struct RuleView: View {
    let rule: GrammarRule
    @Environment(\.services) private var services
    @Query private var solved: [SolvedRule]
    @State private var task: RuleModel

    init(rule: GrammarRule) {
        self.rule = rule
        _task = State(initialValue: RuleModel(rule: rule))
    }

    private var isSolved: Bool { solved.contains { $0.ruleID == rule.id } }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                header
                RuleStepHeader(number: 1, title: "Heard in real life")
                heardCard
                RuleStepHeader(number: 2, title: "Notice")
                noticeCard
                RuleStepHeader(number: 3, title: "The rule")
                ruleCard
                if let mistake = rule.yourMistake {
                    RuleStepHeader(number: 4, title: "From your own German")
                    MistakeCard(mistake: mistake)
                }
                Text("Try it")
                    .textRole(.cardTitle)
                    .accessibilityAddTraits(.isHeader)
                    .padding(.horizontal, 4)
                    .padding(.top, 22)
                    .padding(.bottom, 10)
                WordOrderTask(model: task)
            }
            .padding(.horizontal, Spacing.screen)
            .padding(.bottom, 32)
        }
        .scrollEdgeEffectStyle(.soft, for: .all)
        .readableContentMargins()
        .background(.screenBackground)
        .navigationBarTitleDisplayMode(.inline)
        .onscreenEntity(GrammarRuleEntity(rule), title: rule.title)
    }

    // MARK: Header

    private var header: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Text(verbatim: rule.level.title)
                    .textRole(.caption)
                    .fontWeight(.bold)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    // On the screen background, so controlFill (surfaceSecondary vanishes in light mode).
                    .background(.controlFill, in: .rect(cornerRadius: 7, style: .continuous))
                if isSolved {
                    Text("Solved")
                        .textRole(.caption)
                        .fontWeight(.semibold)
                        .foregroundStyle(.success)
                }
            }
            Text(verbatim: rule.title)
                .textRole(.title2)
                .accessibilityAddTraits(.isHeader)
        }
        .padding(.top, 8)
    }

    // MARK: Steps

    private var heardCard: some View {
        Button {
            Task { await services.voice.speak(rule.german, rate: .normal) }
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 8) {
                    Label(rule.place, systemImage: rule.systemImage)
                        .textRole(.meta)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Image(systemName: "speaker.wave.2")
                        .foregroundStyle(.secondary)
                        .accessibilityHidden(true)
                }
                Text(verbatim: rule.german)
                    .font(.system(.title3, weight: .semibold))
                    .foregroundStyle(.primary)
                Text(verbatim: rule.english)
                    .textRole(.bodySmall)
                    .foregroundStyle(.secondary)
            }
            .multilineTextAlignment(.leading)
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background {
                RoundedRectangle(cornerRadius: Radius.card, style: .continuous)
                    .fill(.surface)
                    .overlay {
                        RadialGradient(colors: [.accentFill.opacity(0.12), .clear],
                                       center: .topTrailing, startRadius: 0, endRadius: 240)
                            .clipShape(.rect(cornerRadius: Radius.card, style: .continuous))
                    }
            }
            .contentShape(.rect(cornerRadius: Radius.card, style: .continuous))
        }
        .buttonStyle(.card)
        .accessibilityElement(children: .combine)
        .accessibilityHint("Plays the sentence.")
    }

    private var noticeCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            FlowLayout(spacing: 6) {
                ForEach(Array(rule.tiles.enumerated()), id: \.offset) { _, tile in
                    WordTile(tile)
                }
            }
            .accessibilityElement(children: .combine)
            Text(verbatim: rule.notice)
                .textRole(.bodySmall)
                .foregroundStyle(.secondary)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.surface, in: .rect(cornerRadius: Radius.card, style: .continuous))
    }

    private var ruleCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(verbatim: rule.rule)
                .textRole(.body)
            PatternBar(slots: rule.pattern)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.surface, in: .rect(cornerRadius: Radius.card, style: .continuous))
    }
}

/// A numbered step title: "① Heard in real life".
private struct RuleStepHeader: View {
    let number: Int
    let title: LocalizedStringResource

    var body: some View {
        HStack(spacing: 8) {
            Text(number, format: .number)
                .textRole(.caption)
                .fontWeight(.bold)
                .frame(width: 22, height: 22)
                .background(.controlFill, in: .circle)
                .accessibilityHidden(true)
            Text(title)
                .textRole(.cardTitle)
        }
        .padding(.horizontal, 4)
        .padding(.top, 22)
        .padding(.bottom, 10)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isHeader)
    }
}

/// The learner's own mistake, struck through, and the right version.
private struct MistakeCard: View {
    let mistake: GrammarRule.LearnerMistake

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline, spacing: 10) {
                Image(systemName: "xmark")
                    .foregroundStyle(.mistake)
                    .accessibilityLabel("Wrong")
                Text(verbatim: mistake.wrong)
                    .strikethrough(true, color: .mistake)
                    .foregroundStyle(.secondary)
            }
            HStack(alignment: .firstTextBaseline, spacing: 10) {
                Image(systemName: "checkmark")
                    .foregroundStyle(.success)
                    .accessibilityLabel("Right")
                Text(verbatim: mistake.right)
            }
            Text(verbatim: mistake.source)
                .textRole(.caption)
                .foregroundStyle(.tertiary)
        }
        .textRole(.body)
        .padding(.horizontal, 18)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.surface, in: .rect(cornerRadius: Radius.card, style: .continuous))
    }
}

#Preview {
    NavigationStack { RuleView(rule: MockRules.weil) }
        .modelContainer(AlltagStore.preview)
}
