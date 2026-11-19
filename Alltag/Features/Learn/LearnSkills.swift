//
//  LearnSkills.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 10.11.26.
//

import SwiftData
import SwiftUI

/// The four things to practise on Learn, apart from speaking (that's on Today).
enum LearnSkill: CaseIterable, Identifiable {
    case read, write, listen, grammar

    var id: Self { self }

    var title: LocalizedStringResource {
        switch self {
        case .read: "Read"
        case .write: "Write"
        case .listen: "Listen"
        case .grammar: "Grammar"
        }
    }

    /// What it's about, in a few words.
    var summary: LocalizedStringResource {
        switch self {
        case .read: "Letters, notices and forms"
        case .write: "Messages and emails"
        case .listen: "Announcements and calls"
        case .grammar: "Rules you get wrong"
        }
    }

    var systemImage: String {
        switch self {
        case .read: "envelope.open.fill"
        case .write: "square.and.pencil"
        case .listen: "ear.fill"
        case .grammar: "text.badge.checkmark"
        }
    }
}

/// "Practise": a wide clear-glass banner per skill, with a big symbol on the
/// right and the learner's real progress under its name.
struct SkillsSection: View {
    /// The learner's level, from their profile.
    let level: Level
    let onOpen: (LearnSkill) -> Void

    @Query private var solved: [SolvedRule]
    @Query(filter: #Predicate<MemoryItem> { $0.sourceRaw == "read" }) private var readWords: [MemoryItem]
    @Query(filter: #Predicate<SessionRecord> { $0.kindRaw == "writing" }) private var written: [SessionRecord]
    @State private var taps = 0

    private func progress(of skill: LearnSkill) -> SkillProgress {
        switch skill {
        case .grammar:
            .grammar(solvedRuleIDs: Set(solved.map(\.ruleID)), level: GrammarProgress.initialLevel(for: level))
        case .read: .reading(readWords)
        case .write: .writing(written)
        case .listen: .comingSoon
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Practise")
                .textRole(.sectionHeader)
                .padding(.horizontal, 4)
            GlassEffectContainer(spacing: 0) {
                VStack(spacing: Spacing.grid) {
                    ForEach(LearnSkill.allCases) { skill in
                        Button {
                            taps += 1
                            onOpen(skill)
                        } label: {
                            SkillBanner(skill: skill, progress: progress(of: skill))
                        }
                        .buttonStyle(.plain)
                        .accessibilityElement(children: .combine)
                    }
                }
            }
        }
        .fontDesign(.rounded)
        .sensoryFeedback(.impact(weight: .light), trigger: taps)
    }
}

private struct SkillBanner: View {
    let skill: LearnSkill
    let progress: SkillProgress

    @ScaledMetric(relativeTo: .title2) private var height: CGFloat = 104

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text(skill.title)
                    .font(.title2.weight(.bold))
                Text(skill.summary)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                SkillProgressLine(progress: progress)
                    .padding(.top, 6)
            }
            Spacer(minLength: 8)
            Image(systemName: skill.systemImage)
                .font(.system(size: 52, weight: .light))
                .foregroundStyle(.white.opacity(0.85))
                .rotationEffect(.degrees(-8))
                .offset(x: 10)
                .accessibilityHidden(true)
        }
        .multilineTextAlignment(.leading)
        .padding(.horizontal, Spacing.cardLarge)
        .frame(minHeight: height)
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: Radius.card, style: .continuous))
        .clipShape(.rect(cornerRadius: Radius.card, style: .continuous))
        .contentShape(.rect(cornerRadius: Radius.card, style: .continuous))
    }
}

/// "12 of 20 solved · A2" with a short bar, "5 words saved", "3 texts written", or "Coming soon".
private struct SkillProgressLine: View {
    let progress: SkillProgress

    var body: some View {
        HStack(spacing: 8) {
            if let fraction = progress.fraction {
                ProgressView(value: fraction)
                    .tint(.accent)
                    .frame(width: 56)
            }
            label
                .font(.footnote.weight(.semibold))
            if case let .rules(_, _, level) = progress {
                CollectionLevelBadge(level: level)
            }
        }
    }

    @ViewBuilder private var label: some View {
        switch progress {
        case let .rules(solved, total, _):
            Text("\(solved) of \(total) solved")
                .foregroundStyle(.accent)
        case let .savedWords(saved) where saved > 0:
            Text("^[\(saved) word](inflect: true) saved")
                .foregroundStyle(.accent)
        case .savedWords:
            Text("No words saved yet")
                .foregroundStyle(.secondary)
        case let .written(count) where count > 0:
            Text("^[\(count) text](inflect: true) written")
                .foregroundStyle(.accent)
        case .written:
            Text("Nothing written yet")
                .foregroundStyle(.secondary)
        case .comingSoon:
            Text("Coming soon")
                .foregroundStyle(.secondary)
        }
    }
}

extension View {
    /// The Focus card's surface: dark, with a thin light edge.
    func learnSurface(radius: CGFloat = Radius.hero) -> some View {
        frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: radius, style: .continuous)
                    .fill(.surface)
                    .overlay {
                        RoundedRectangle(cornerRadius: radius, style: .continuous)
                            .strokeBorder(.white.opacity(0.06), lineWidth: 1)
                    }
            }
            .contentShape(.rect(cornerRadius: radius, style: .continuous))
    }
}

#Preview {
    SkillsSection(level: .a2) { _ in }
        .modelContainer(AlltagStore.preview)
        .padding(Spacing.screen)
        .background(.screenBackground)
}
