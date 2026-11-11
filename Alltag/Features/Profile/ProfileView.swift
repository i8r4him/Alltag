//
//  ProfileView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftData
import SwiftUI

/// The learner's profile, in Today's design (sky, glass cards): who they are, this week,
/// their goal, languages and interests.
///
/// The goal bar and "Where I can manage" are hidden until they're real
/// (Situations, #178).
struct ProfileView: View {
    @Environment(AppState.self) private var appState
    @Query private var profiles: [UserProfile]
    @Query private var items: [MemoryItem]
    @Query private var solved: [SolvedRule]
    @Query private var sessions: [PracticeSession]

    private var stats: [ProfileStat] {
        [ProfileStat(value: ProfileStats.minutesThisWeek(in: sessions), label: "MINUTES", symbol: "waveform"),
         ProfileStat(value: ProfileStats.wordsThisWeek(in: items), label: "WORDS", symbol: "character.book.closed.fill"),
         ProfileStat(value: solved.count, label: "RULES", symbol: "checkmark.seal.fill")]
    }

    var body: some View {
        ScrollView {
            if let profile = profiles.first {
                VStack(alignment: .leading, spacing: Spacing.section) {
                    ProfileHeader(profile: profile, stats: stats)
                    GoalCard(profile: profile)
                    LearnSection(title: "Languages") {
                        VStack(spacing: 0) {
                            LanguageRow(systemImage: "character.bubble.fill", name: Text("German"),
                                        status: Text("Learning · \(profile.level.title)"), highlighted: true)
                            Divider().padding(.leading, 82)
                            LanguageRow(systemImage: "house.fill", name: Text(profile.nativeLanguage.title),
                                        status: Text("Native"), highlighted: false)
                        }
                        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
                    }
                    LearnSection(title: "What I care about") {
                        Text("Shapes your briefings, situations and examples.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 4)
                        InterestChips(profile: profile)
                    }
                }
                .padding(.horizontal, Spacing.screen)
                .padding(.bottom, 32)
            }
        }
        .fontDesign(.rounded)
        .readableContentMargins()
        .scrollEdgeEffectStyle(.soft, for: .all)
        .skyBackground()
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Settings", systemImage: "gearshape") { appState.open(.settings) }
            }
        }
    }
}

/// One of the three numbers for this week.
private struct ProfileStat: Identifiable {
    let value: Int
    let label: LocalizedStringResource
    let symbol: String
    var id: String { symbol }
}

/// A big number with its word and symbol underneath, like Today's.
private struct BigStat: View {
    let stat: ProfileStat

    var body: some View {
        VStack(spacing: 4) {
            Text(stat.value, format: BigNumber.style(for: stat.value))
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .monospacedDigit()
                .lineLimit(1)
                .minimumScaleFactor(0.6)
            Label { Text(stat.label) } icon: { Image(systemName: stat.symbol) }
                .font(.subheadline.weight(.semibold))
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.accent)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
    }
}

/// "Learning German since November 2026".
private func sinceText(_ profile: UserProfile) -> Text {
    Text("Learning German since \(profile.learningSince.formatted(.dateTime.month(.wide).year()))")
}

/// The avatar and name, centred, then the week as one card split in three.
private struct ProfileHeader: View {
    let profile: UserProfile
    let stats: [ProfileStat]

    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 10) {
                Avatar(name: profile.name, diameter: 88)
                    .overlay { Circle().strokeBorder(.accent.opacity(0.6), lineWidth: 2) }
                Text(verbatim: profile.name)
                    .font(.title.bold())
                    .accessibilityAddTraits(.isHeader)
                sinceText(profile)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .multilineTextAlignment(.center)
            .padding(.top, 12)

            VStack(alignment: .leading, spacing: 14) {
                Label { Text("This week") } icon: { Image(systemName: "calendar") }
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
                HStack(alignment: .top, spacing: 0) {
                    ForEach(Array(stats.enumerated()), id: \.element.id) { index, stat in
                        if index > 0 { Divider().frame(height: 52) }
                        BigStat(stat: stat)
                    }
                }
            }
            .padding(Spacing.cardLarge)
            .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
        }
        .frame(maxWidth: .infinity)
    }
}

/// "MY GOAL" with the learner's goal, on glass.
private struct GoalCard: View {
    let profile: UserProfile

    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Eyebrow(title: "My goal")
                Text(profile.goal.statement)
                    .font(.title3.weight(.semibold))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            ScenarioArtwork(systemImage: "flag.fill", symbolSize: 26, cornerRadius: 16)
                .frame(width: 64, height: 64)
        }
        .padding(Spacing.cardLarge)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }
}

/// A language with how the learner knows it.
private struct LanguageRow: View {
    let systemImage: String
    let name: Text
    let status: Text
    let highlighted: Bool

    var body: some View {
        HStack(spacing: 14) {
            ScenarioArtwork(systemImage: systemImage, symbolSize: 22, cornerRadius: 12)
                .frame(width: 52, height: 52)
            name.font(.headline)
            Spacer()
            status
                .font(.subheadline.weight(highlighted ? .semibold : .regular))
                .foregroundStyle(highlighted ? AnyShapeStyle(.accent) : AnyShapeStyle(.secondary))
        }
        .padding(Spacing.card)
        .accessibilityElement(children: .combine)
    }
}

/// The interest chips, editable here as in onboarding.
private struct InterestChips: View {
    @Bindable var profile: UserProfile

    var body: some View {
        FlowLayout(spacing: 8) {
            ForEach(Interest.allCases) { interest in
                Button {
                    if profile.interests.contains(interest) {
                        profile.interests.remove(interest)
                    } else {
                        profile.interests.insert(interest)
                    }
                } label: {
                    Label { Text(interest.title) } icon: { Image(systemName: interest.systemImage) }
                }
                .buttonStyle(.toggleChip(isOn: profile.interests.contains(interest)))
            }
        }
        .sensoryFeedback(.selection, trigger: profile.interests)
    }
}

/// Numbers for the Profile, kept out of the view so they can be tested.
enum ProfileStats {
    /// Whole minutes spoken in the last seven days.
    static func minutesThisWeek(in sessions: [PracticeSession], now: Date = .now, calendar: Calendar = .current) -> Int {
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: now) ?? now
        return sessions.filter { $0.date > weekAgo }.minutesSpoken
    }

    static func wordsThisWeek(in items: [MemoryItem], now: Date = .now, calendar: Calendar = .current) -> Int {
        let weekAgo = calendar.date(byAdding: .day, value: -7, to: now) ?? now
        return items.filter { $0.createdAt > weekAgo }.count
    }

    /// "**2 confident** · 2 getting there · 2 shaky"
    static func situationsSummary(_ report: ProgressReport) -> AttributedString {
        var confident = AttributedString(String(localized: "\(report.count(.confident)) confident"))
        confident.inlinePresentationIntent = .stronglyEmphasized
        let rest = AttributedString(String(localized: " · \(report.count(.gettingThere)) getting there · \(report.count(.shaky)) shaky"))
        return confident + rest
    }
}

#Preview {
    NavigationStack { ProfileView() }
        .environment(AppState())
        .modelContainer(AlltagStore.preview)
}
