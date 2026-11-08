//
//  ProgressOverviewView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftData
import SwiftUI

/// Progress: level, situations, skills, retention and how the learner learns.
/// (Not `ProgressView`, which is SwiftUI's spinner.)
struct ProgressOverviewView: View {
    var report: ProgressReport = MockProgress.report
    @Environment(AppState.self) private var appState
    @Query private var profiles: [UserProfile]

    private var level: Level { profiles.first?.level ?? .b1 }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                LevelHero(level: level, report: report)
                    .padding(.top, 8)

                section("Where you can manage", subtitle: "Based on your real conversations and rehearsals")
                SituationsCard(situations: report.situations)

                section("Skills")
                SkillsCard(skills: report.skills)

                HStack(alignment: .top, spacing: Spacing.grid) {
                    WordsStuckTile(report: report)
                    SpokenTile(report: report)
                }
                .padding(.top, 2)

                section("Worth your attention")
                attentionCard

                section("How you learn")
                howYouLearnCard
            }
            .padding(.horizontal, Spacing.screen)
            .padding(.bottom, 24)
        }
        .readableContentMargins()
        .background(.screenBackground)
        .navigationTitle("Progress")
        .navigationBarTitleDisplayMode(.large)
    }

    private func section(_ title: LocalizedStringKey, subtitle: LocalizedStringKey? = nil) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            SectionHeader(title)
            if let subtitle {
                Text(subtitle).textRole(.meta).foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 4)
        .padding(.top, 16)
    }

    private var attentionCard: some View {
        VStack(spacing: 0) {
            ForEach(Array(report.attention.enumerated()), id: \.offset) { index, item in
                if index > 0 { Divider().padding(.leading, Spacing.card) }
                Button { appState.present(.activity(.mistakes)) } label: {
                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(verbatim: item.title).textRole(.body).fontWeight(.medium)
                            Text(verbatim: item.reason).textRole(.meta).foregroundStyle(.secondary)
                        }
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        Image(systemName: "chevron.right")
                            .font(.footnote.weight(.semibold))
                            .foregroundStyle(.tertiary)
                            .accessibilityHidden(true)
                    }
                    .padding(.horizontal, Spacing.card)
                    .padding(.vertical, 14)
                    .contentShape(.rect)
                }
                .buttonStyle(.plain)
                .accessibilityElement(children: .combine)
            }
        }
        .background(.surface, in: .rect(cornerRadius: Radius.card, style: .continuous))
    }

    private var howYouLearnCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(report.howYouLearn, id: \.self) { insight in
                Text(Self.insight(insight))
                    .textRole(.bodySmall)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.surface, in: .rect(cornerRadius: Radius.card, style: .continuous))
    }

    /// Markdown insight with the bold parts in the primary colour.
    static func insight(_ markdown: String) -> AttributedString {
        var text = (try? AttributedString(markdown: markdown)) ?? AttributedString(markdown)
        for run in text.runs where run.inlinePresentationIntent?.contains(.stronglyEmphasized) == true {
            text[run.range].foregroundColor = .primary
        }
        return text
    }
}

/// "B1 · 62% of the way to B2" with the A1–C2 track.
private struct LevelHero: View {
    let level: Level
    let report: ProgressReport

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .firstTextBaseline, spacing: 12) {
                Text(verbatim: level.title)
                    .font(.system(size: 56, weight: .bold))
                    .tracking(-2)
                if let next = Level.allCases.drop(while: { $0 != level }).dropFirst().first {
                    Text("\(Int((report.progressToNextLevel * 100).rounded()))% of the way to \(next.title)")
                        .textRole(.bodySmall)
                        .foregroundStyle(.secondary)
                }
            }
            VStack(spacing: 8) {
                GeometryReader { proxy in
                    ZStack(alignment: .leading) {
                        Capsule().fill(.surfaceSecondary)
                        Capsule().fill(.accentFill)
                            .frame(width: proxy.size.width * ProgressReport.trackFraction(level: level,
                                                                                         progressToNext: report.progressToNextLevel))
                    }
                }
                .frame(height: 6)
                HStack {
                    ForEach(Level.allCases) { step in
                        Text(verbatim: step.title)
                            .textRole(.caption)
                            .fontWeight(step == level ? .semibold : .regular)
                            .foregroundStyle(step == level ? AnyShapeStyle(.primary) : AnyShapeStyle(.tertiary))
                        if step != Level.allCases.last { Spacer() }
                    }
                }
            }
            .accessibilityElement()
            .accessibilityLabel("Level track")
            .accessibilityValue(Text(verbatim: level.title))
            Text(verbatim: report.summary)
                .textRole(.bodySmall)
                .foregroundStyle(.secondary)
        }
        .padding(Spacing.cardLarge)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.surface, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }
}

/// Situations with three-segment confidence bars.
private struct SituationsCard: View {
    let situations: [ProgressReport.Situation]

    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(situations.enumerated()), id: \.offset) { index, situation in
                if index > 0 { Divider() }
                HStack(spacing: 10) {
                    Text(verbatim: situation.name)
                        .textRole(.bodySmall)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    HStack(spacing: 3) {
                        ForEach(1...3, id: \.self) { segment in
                            Capsule()
                                .fill(fill(segment: segment, confidence: situation.confidence))
                                .frame(width: 20, height: 6)
                        }
                    }
                    Text(label(situation.confidence))
                        .textRole(.caption)
                        .foregroundStyle(situation.confidence == .shaky ? AnyShapeStyle(.mistake) : AnyShapeStyle(.primary))
                        .frame(width: 92, alignment: .trailing)
                }
                .padding(.vertical, 11)
                .accessibilityElement(children: .combine)
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 4)
        .background(.surface, in: .rect(cornerRadius: Radius.card, style: .continuous))
    }

    private func fill(segment: Int, confidence: ProgressReport.Confidence) -> AnyShapeStyle {
        guard segment <= confidence.rawValue else { return AnyShapeStyle(.surfaceSecondary) }
        return confidence == .shaky ? AnyShapeStyle(.mistake) : AnyShapeStyle(.primary.opacity(0.85))
    }

    private func label(_ confidence: ProgressReport.Confidence) -> LocalizedStringResource {
        switch confidence {
        case .confident: "Confident"
        case .gettingThere: "Getting there"
        case .shaky: "Shaky"
        }
    }
}

/// Skill bars with their change over 30 days.
private struct SkillsCard: View {
    let skills: [ProgressReport.Skill]

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(Array(skills.enumerated()), id: \.offset) { _, skill in
                HStack(spacing: 12) {
                    Text(verbatim: skill.name)
                        .textRole(.bodySmall)
                        .frame(width: 90, alignment: .leading)
                    GeometryReader { proxy in
                        ZStack(alignment: .leading) {
                            Capsule().fill(.surfaceSecondary)
                            Capsule().fill(.primary.opacity(0.85)).frame(width: proxy.size.width * skill.value)
                        }
                    }
                    .frame(height: 4)
                    Text(skill.change > 0 ? "+\(skill.change)" : "±0")
                        .textRole(.meta)
                        .foregroundStyle(skill.change > 0 ? AnyShapeStyle(.success) : AnyShapeStyle(.tertiary))
                        .frame(width: 44, alignment: .trailing)
                }
                .padding(.vertical, 12)
                .accessibilityElement(children: .combine)
                .accessibilityValue(Text("\(Int(skill.value * 100)) percent"))
            }
            Text("Change over the last 30 days")
                .textRole(.caption)
                .foregroundStyle(.tertiary)
                .padding(.top, 4)
                .padding(.bottom, 12)
        }
        .padding(.horizontal, 18)
        .padding(.top, 6)
        .background(.surface, in: .rect(cornerRadius: Radius.card, style: .continuous))
    }
}

private struct WordsStuckTile: View {
    let report: ProgressReport

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Words that stuck").textRole(.meta).foregroundStyle(.secondary)
            Text(report.wordsStuck, format: .percent.precision(.fractionLength(0)))
                .textRole(.title2)
            HStack(alignment: .bottom, spacing: 3) {
                ForEach(Array(report.wordsStuckHistory.enumerated()), id: \.offset) { index, value in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(index == report.wordsStuckHistory.count - 1
                              ? AnyShapeStyle(.primary.opacity(0.85)) : AnyShapeStyle(.surfaceTertiary))
                        .frame(height: 36 * value)
                }
            }
            .frame(height: 36, alignment: .bottom)
            .accessibilityHidden(true)
            Text("Still remembered 30 days after you met them")
                .textRole(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(Spacing.card)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(.surface, in: .rect(cornerRadius: Radius.card, style: .continuous))
        .accessibilityElement(children: .combine)
    }
}

private struct SpokenTile: View {
    let report: ProgressReport

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Spoken this month").textRole(.meta).foregroundStyle(.secondary)
            Text("\(report.minutesSpoken) min").textRole(.title2)
            Text(verbatim: report.spokenNote).textRole(.bodySmall).foregroundStyle(.secondary)
            Text("Across ^[\(report.conversations) conversation](inflect: true)")
                .textRole(.caption)
                .foregroundStyle(.tertiary)
        }
        .padding(Spacing.card)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(.surface, in: .rect(cornerRadius: Radius.card, style: .continuous))
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    NavigationStack { ProgressOverviewView() }
        .environment(AppState())
        .modelContainer(AlltagStore.preview)
}
