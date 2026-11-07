//
//  ProfileView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftData
import SwiftUI

/// The learner's profile: goal, this week, languages, interests, situations.
struct ProfileView: View {
    var report: ProgressReport = MockProgress.report
    @Environment(AppState.self) private var appState
    @Query private var profiles: [UserProfile]
    @Query private var items: [MemoryItem]
    @Query private var solved: [SolvedRule]

    var body: some View {
        ScrollView {
            if let profile = profiles.first {
                content(profile)
                    .padding(.horizontal, Spacing.screen)
                    .padding(.bottom, 32)
            }
        }
        .readableContentMargins()
        .background(.screenBackground)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Settings", systemImage: "gearshape") { appState.open(.settings) }
            }
        }
    }

    @ViewBuilder
    private func content(_ profile: UserProfile) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            header(profile)
            GoalCard(profile: profile, report: report).padding(.top, 14)

            section("This week")
            HStack(spacing: 8) {
                StatTile(value: Text("\(report.minutesSpoken) min"), label: "spoken")
                StatTile(value: Text(ProfileStats.wordsThisWeek(in: items), format: .number), label: "words met")
                StatTile(value: Text(solved.count, format: .number), label: "rules solved")
            }

            section("Languages")
            VStack(spacing: 0) {
                languageRow(Text("German"), status: Text("Learning · \(profile.level.title)"), highlighted: true)
                Divider().padding(.leading, Spacing.card)
                languageRow(Text(profile.nativeLanguage.title), status: Text("Native"), highlighted: false)
            }
            .background(.surface, in: .rect(cornerRadius: Radius.innerCard, style: .continuous))

            section("What I care about", subtitle: "Shapes your briefings, situations and examples.")
            InterestChips(profile: profile)

            section("Where I can manage")
            situationsRow
        }
    }

    private func header(_ profile: UserProfile) -> some View {
        VStack(spacing: 10) {
            Avatar(name: profile.name, diameter: 88)
            Text(verbatim: profile.name)
                .textRole(.title2)
                .accessibilityAddTraits(.isHeader)
            Text("Learning German since \(profile.learningSince.formatted(.dateTime.month(.wide).year()))")
                .textRole(.bodySmall)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .multilineTextAlignment(.center)
        .padding(.top, 8)
    }

    private func section(_ title: LocalizedStringKey, subtitle: LocalizedStringKey? = nil) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            SectionHeader(title)
            if let subtitle {
                Text(subtitle).textRole(.bodySmall).foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal, 4)
        .padding(.top, 16)
    }

    private func languageRow(_ name: Text, status: Text, highlighted: Bool) -> some View {
        HStack {
            name.textRole(.body)
            Spacer()
            status
                .textRole(.meta)
                .fontWeight(highlighted ? .semibold : .regular)
                .foregroundStyle(highlighted ? AnyShapeStyle(.accent) : AnyShapeStyle(.secondary))
        }
        .padding(.horizontal, Spacing.card)
        .padding(.vertical, 14)
        .accessibilityElement(children: .combine)
    }

    private var situationsRow: some View {
        Button { appState.open(.progress) } label: {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(ProfileStats.situationsSummary(report))
                        .textRole(.body)
                    if let next = report.nextToWorkOn {
                        Text("Next to work on: \(next.name.lowercased())")
                            .textRole(.meta)
                            .foregroundStyle(.secondary)
                    }
                }
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.tertiary)
                    .accessibilityHidden(true)
            }
            .padding(Spacing.card)
            .background(.surface, in: .rect(cornerRadius: Radius.innerCard, style: .continuous))
            .contentShape(.rect)
        }
        .buttonStyle(.card)
        .accessibilityElement(children: .combine)
    }
}

/// "MY GOAL" with the learner's goal and the way to the next level.
private struct GoalCard: View {
    let profile: UserProfile
    let report: ProgressReport

    private var nextLevel: Level? { Level.allCases.drop(while: { $0 != profile.level }).dropFirst().first }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Eyebrow(title: "My goal")
            Text(profile.goal.statement)
                .font(.system(.title3, weight: .semibold))
            if let nextLevel {
                HStack(spacing: 10) {
                    GeometryReader { proxy in
                        ZStack(alignment: .leading) {
                            Capsule().fill(.surfaceSecondary)
                            Capsule().fill(.accentFill).frame(width: proxy.size.width * report.progressToNextLevel)
                        }
                    }
                    .frame(height: 5)
                    // Level code and target are content, not catalog text.
                    Text(verbatim: "\(nextLevel.title) \(report.nextLevelTarget)")
                        .textRole(.meta)
                        .foregroundStyle(.secondary)
                }
                .accessibilityElement(children: .combine)
            }
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            RoundedRectangle(cornerRadius: Radius.card, style: .continuous)
                .fill(.surface)
                .overlay {
                    RadialGradient(colors: [.accentFill.opacity(0.12), .clear], center: .topTrailing, startRadius: 0, endRadius: 240)
                        .clipShape(.rect(cornerRadius: Radius.card, style: .continuous))
                }
        }
    }
}

/// A number with a small label.
private struct StatTile: View {
    let value: Text
    let label: LocalizedStringResource

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            value.textRole(.sectionHeader)
            Text(label).textRole(.caption).foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(14)
        .background(.surface, in: .rect(cornerRadius: Radius.option, style: .continuous))
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
