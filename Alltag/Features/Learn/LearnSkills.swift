//
//  LearnSkills.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 10.11.26.
//

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

    /// The next thing waiting in this skill (mock content).
    var next: LocalizedStringResource {
        switch self {
        case .read: "A letter from your landlord"
        case .write: "Cancel your appointment"
        case .listen: "Platform change in Munich"
        case .grammar: "Verb at the end"
        }
    }

    var nextDetail: LocalizedStringResource {
        switch self {
        case .read: "Service charges, explained · A2"
        case .write: "A short email to the dentist"
        case .listen: "A station announcement"
        case .grammar: "2 rules worth a look"
        }
    }

    var minutes: Int {
        switch self {
        case .read: 3
        case .write: 4
        case .listen: 1
        case .grammar: 2
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

/// Temporary: layouts for the skills section, to compare on device.
enum SkillsDesign: Int, CaseIterable {
    case grid, rows, cards

    var name: String {
        switch self {
        case .grid: "Grid"
        case .rows: "Rows"
        case .cards: "Cards"
        }
    }
}

/// Temporary: steps through the skills layouts.
struct SkillsDesignSwitcher: View {
    @Binding var design: SkillsDesign

    var body: some View {
        let all = SkillsDesign.allCases
        HStack(spacing: 14) {
            Button { step(-1) } label: { Image(systemName: "chevron.left") }
            Text(verbatim: "\(design.rawValue + 1) / \(all.count) · \(design.name)")
                .foregroundStyle(.secondary)
                .frame(minWidth: 130)
            Button { step(1) } label: { Image(systemName: "chevron.right") }
        }
        .font(.footnote.weight(.semibold))
        .buttonStyle(.glass)
        .frame(maxWidth: .infinity)
        .sensoryFeedback(.selection, trigger: design)
    }

    private func step(_ offset: Int) {
        let all = SkillsDesign.allCases
        withAnimation(.snappy) { design = all[(design.rawValue + offset + all.count) % all.count] }
    }
}

/// Read, Write, Listen and Grammar in one of the layouts.
struct SkillsSection: View {
    let design: SkillsDesign
    let onOpen: (LearnSkill) -> Void

    @State private var taps = 0

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Practise")
                .textRole(.sectionHeader)
                .padding(.horizontal, 4)
            switch design {
            case .grid: grid
            case .rows: rows
            case .cards: cards
            }
        }
        .fontDesign(.rounded)
        .sensoryFeedback(.impact(weight: .light), trigger: taps)
    }

    private func open(_ skill: LearnSkill) {
        taps += 1
        onOpen(skill)
    }

    /// 2×2 square tiles like Coming up: artwork, title, what it's about.
    private var grid: some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: Spacing.grid),
                            GridItem(.flexible(), spacing: Spacing.grid)],
                  spacing: Spacing.grid) {
            ForEach(LearnSkill.allCases) { skill in
                Button { open(skill) } label: {
                    VStack(alignment: .leading, spacing: 0) {
                        ScenarioArtwork(systemImage: skill.systemImage, symbolSize: 26, cornerRadius: 14)
                            .frame(width: 54, height: 54)
                        Spacer(minLength: 16)
                        Text(skill.title)
                            .font(.title3.weight(.semibold))
                        Text(skill.summary)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(2, reservesSpace: true)
                    }
                    .multilineTextAlignment(.leading)
                    .padding(Spacing.card)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .aspectRatio(1, contentMode: .fit)
                    .learnSurface()
                }
                .buttonStyle(.plain)
                .accessibilityElement(children: .combine)
            }
        }
    }

    /// One card, a row per skill: artwork, title, the next thing, length.
    private var rows: some View {
        VStack(spacing: 0) {
            ForEach(Array(LearnSkill.allCases.enumerated()), id: \.element) { index, skill in
                if index > 0 { Divider().padding(.leading, 84) }
                Button { open(skill) } label: {
                    HStack(spacing: 14) {
                        ScenarioArtwork(systemImage: skill.systemImage, symbolSize: 24, cornerRadius: 13)
                            .frame(width: 54, height: 54)
                        VStack(alignment: .leading, spacing: 3) {
                            Text(skill.title)
                                .font(.headline)
                            Text(skill.next)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        Text("\(skill.minutes) min")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.accent)
                    }
                    .multilineTextAlignment(.leading)
                    .padding(Spacing.card)
                    .contentShape(.rect)
                }
                .buttonStyle(.plain)
                .accessibilityElement(children: .combine)
            }
        }
        .learnSurface()
    }

    /// A small Focus card per skill, showing what's next in it.
    private var cards: some View {
        VStack(spacing: Spacing.grid) {
            ForEach(LearnSkill.allCases) { skill in
                Button { open(skill) } label: {
                    HStack(alignment: .center, spacing: 16) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(skill.title)
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.accent)
                            Text(skill.next)
                                .font(.title3.weight(.semibold))
                            Text(skill.nextDetail)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .fixedSize(horizontal: false, vertical: true)
                        ScenarioArtwork(systemImage: skill.systemImage, symbolSize: 34, cornerRadius: 16)
                            .frame(width: 76, height: 76)
                    }
                    .multilineTextAlignment(.leading)
                    .padding(Spacing.cardLarge)
                    .learnSurface()
                }
                .buttonStyle(.plain)
                .accessibilityElement(children: .combine)
            }
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
