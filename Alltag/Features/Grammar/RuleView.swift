//
//  RuleView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftData
import SwiftUI

/// A grammar rule, taught from a real moment in numbered steps, in Today's
/// look: the sky, clear glass cards, rounded type and the theme's artwork.
/// It ends with the exam, or with "Try it" for a rule that has none yet. A
/// rule that isn't open yet says which rule to solve first.
struct RuleView: View {
    let rule: GrammarRule
    @Environment(\.services) private var services
    @Query private var solved: [SolvedRule]
    @State private var task: RuleModel
    @State private var spoken = 0

    init(rule: GrammarRule) {
        self.rule = rule
        _task = State(initialValue: RuleModel(rule: rule))
    }

    private var isSolved: Bool { solved.contains { $0.ruleID == rule.id } }
    private var blocker: GrammarRule? { GrammarProgress(solved: solved).blocker(of: rule.id) }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                header
                if let blocker {
                    LockedRuleCard(blocker: blocker)
                        .padding(.top, 22)
                } else {
                    steps
                }
            }
            .padding(.horizontal, Spacing.screen)
            .padding(.bottom, 32)
        }
        .scrollEdgeEffectStyle(.soft, for: .all)
        .scrollIndicators(.hidden)
        .fontDesign(.rounded)
        .readableContentMargins()
        .skyBackground()
        .navigationTitle(navigationTitle)
        .navigationBarTitleDisplayMode(.inline)
        .onscreenEntity(GrammarRuleEntity(rule), title: rule.title)
    }

    /// "A1 · Rule 2 of 2": where the rule sits in its level.
    private var navigationTitle: Text {
        guard let place = GrammarProgress.place(of: rule) else { return Text(verbatim: rule.level.title) }
        return Text("\(rule.level.title) · Rule \(place.number) of \(place.count)")
    }

    @ViewBuilder
    private var steps: some View {
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
        (rule.hasExam ? Text("Exam") : Text("Try it"))
            .textRole(.sectionHeader)
            .accessibilityAddTraits(.isHeader)
            .padding(.horizontal, 4)
            .padding(.top, 22)
            .padding(.bottom, 10)
        if rule.hasExam {
            ExamCard(rule: rule, isSolved: isSolved)
        } else {
            WordOrderTask(model: task)
        }
    }

    // MARK: Header

    @ScaledMetric(relativeTo: .title) private var artworkSize: CGFloat = 88

    private var header: some View {
        HStack(alignment: .center, spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                if isSolved {
                    Label {
                        Text("\(rule.level.title) · Solved")
                    } icon: {
                        Image(systemName: "checkmark.circle.fill")
                    }
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.accent)
                } else {
                    Text(verbatim: rule.level.title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.accent)
                }
                Text(verbatim: rule.title)
                    .font(.title.weight(.bold))
                    .fixedSize(horizontal: false, vertical: true)
                    .accessibilityAddTraits(.isHeader)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            ScenarioArtwork(systemImage: rule.systemImage)
                .frame(width: artworkSize, height: artworkSize)
        }
        .padding(.top, 8)
    }

    // MARK: Steps

    private var heardCard: some View {
        Button {
            spoken += 1
            Task { await services.voice.speak(rule.german, rate: .normal) }
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                HStack(spacing: 8) {
                    Label(rule.place, systemImage: rule.systemImage)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.secondary)
                    Spacer()
                    Image(systemName: "speaker.wave.2.fill")
                        .font(.subheadline)
                        .foregroundStyle(.accent)
                        .frame(width: 36, height: 36)
                        .glassEffect(.regular, in: .circle)
                        .accessibilityHidden(true)
                }
                Text(verbatim: rule.german)
                    .font(.title3.weight(.semibold))
                    .foregroundStyle(.primary)
                Text(verbatim: rule.english)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .multilineTextAlignment(.leading)
            .padding(Spacing.cardLarge)
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(.rect(cornerRadius: Radius.card, style: .continuous))
            .glassEffect(.regular.interactive(), in: .rect(cornerRadius: Radius.card, style: .continuous))
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.impact(weight: .medium), trigger: spoken)
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
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(Spacing.cardLarge)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.card, style: .continuous))
    }

    private var ruleCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            // A rule with a picture shows what it means first, and its
            // forms as a tiny table in place of the pattern.
            if let visual = rule.visual {
                RuleScene(visual: visual)
            }
            Text(verbatim: rule.rule)
                .textRole(.body)
            if let visual = rule.visual {
                RuleTable(visual: visual)
            } else {
                PatternBar(slots: rule.pattern)
            }
        }
        .padding(Spacing.cardLarge)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.card, style: .continuous))
    }
}

/// A numbered step title: "① Heard in real life".
private struct RuleStepHeader: View {
    let number: Int
    let title: LocalizedStringResource

    var body: some View {
        HStack(spacing: 8) {
            Text(number, format: .number)
                .font(.subheadline.weight(.bold))
                .foregroundStyle(.accent)
                .frame(width: 30, height: 30)
                .glassEffect(.regular, in: .circle)
                .accessibilityHidden(true)
            Text(title)
                .textRole(.sectionHeader)
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
        .padding(Spacing.cardLarge)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.card, style: .continuous))
    }
}

#Preview {
    NavigationStack { RuleView(rule: MockRules.weil) }
        .modelContainer(AlltagStore.preview)
}
