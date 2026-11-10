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

    /// How much is waiting, e.g. "4 letters".
    var count: LocalizedStringResource {
        switch self {
        case .read: "4 texts"
        case .write: "3 tasks"
        case .listen: "5 clips"
        case .grammar: "2 rules"
        }
    }

    /// What's waiting in this skill (mock content): title and detail.
    var items: [(title: LocalizedStringResource, detail: LocalizedStringResource)] {
        switch self {
        case .read: [("A letter from your landlord", "Service charges · A2 · 3 min"),
                     ("A notice from the Bürgeramt", "Your appointment · A2 · 2 min"),
                     ("A form at the doctor's", "Fill it in · B1 · 4 min")]
        case .write: [("Cancel your appointment", "Email to the dentist · 4 min"),
                      ("Reply to your landlord", "About the repairs · 5 min"),
                      ("Tell work you're sick", "A short message · 2 min")]
        case .listen: [("Platform change in Munich", "Station announcement · 1 min"),
                       ("A voicemail from the doctor", "Your results · 1 min"),
                       ("The weather for the weekend", "Radio · 2 min")]
        case .grammar: [("Verb at the end", "After weil, dass, wenn · 2 min"),
                        ("seit or für?", "Talking about time · 1 min"),
                        ("Dative plural", "drei Jahren · 1 min")]
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
    case carousel, posters, stacks, tabs, circles, banners

    var name: String {
        switch self {
        case .carousel: "Carousel"
        case .posters: "Posters"
        case .stacks: "Stacks"
        case .tabs: "Tabs"
        case .circles: "Circles"
        case .banners: "Banners"
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
    @State private var selected = LearnSkill.read

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Practise")
                .textRole(.sectionHeader)
                .padding(.horizontal, 4)
            switch design {
            case .carousel: carousel
            case .posters: posters
            case .stacks: stacks
            case .tabs: tabs
            case .circles: circles
            case .banners: banners
            }
        }
        .fontDesign(.rounded)
        .sensoryFeedback(.impact(weight: .light), trigger: taps)
    }

    private func open(_ skill: LearnSkill) {
        taps += 1
        onOpen(skill)
    }

    // MARK: Designs

    /// Big square tiles scrolled sideways, like Coming up.
    private var carousel: some View {
        ScrollView(.horizontal) {
            HStack(spacing: Spacing.grid) {
                ForEach(LearnSkill.allCases) { skill in
                    Button { open(skill) } label: {
                        VStack(alignment: .leading, spacing: 0) {
                            HStack(alignment: .top) {
                                Text(skill.count)
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(.accent)
                                Spacer()
                                ScenarioArtwork(systemImage: skill.systemImage, symbolSize: 24, cornerRadius: 12)
                                    .frame(width: 50, height: 50)
                            }
                            Spacer(minLength: 0)
                            Text(skill.title)
                                .font(.title2.weight(.bold))
                            Text(skill.items[0].title)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineLimit(2, reservesSpace: true)
                        }
                        .multilineTextAlignment(.leading)
                        .padding(Spacing.card + 2)
                        .frame(width: 196, height: 196, alignment: .topLeading)
                        .learnSurface()
                    }
                    .buttonStyle(.plain)
                    .accessibilityElement(children: .combine)
                }
            }
        }
        .scrollIndicators(.hidden)
        .scrollClipDisabled()
    }

    /// 2×2 tall cards with the artwork filling the top half.
    private var posters: some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: Spacing.grid),
                            GridItem(.flexible(), spacing: Spacing.grid)],
                  spacing: Spacing.grid) {
            ForEach(LearnSkill.allCases) { skill in
                Button { open(skill) } label: {
                    VStack(alignment: .leading, spacing: 12) {
                        ScenarioArtwork(systemImage: skill.systemImage, symbolSize: 40, cornerRadius: 22)
                            .frame(maxWidth: .infinity)
                            .frame(height: 104)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(skill.title)
                                .font(.title3.weight(.semibold))
                            Text(skill.count)
                                .font(.subheadline)
                                .foregroundStyle(.accent)
                        }
                        .padding(.horizontal, 6)
                        .padding(.bottom, 6)
                    }
                    .padding(10)
                    .learnSurface(radius: 32)
                }
                .buttonStyle(.plain)
                .accessibilityElement(children: .combine)
            }
        }
    }

    /// Like the mistakes deck: each skill is a small stack, its next item on top.
    private var stacks: some View {
        VStack(spacing: 30) {
            ForEach(LearnSkill.allCases) { skill in
                Button { open(skill) } label: {
                    HStack(spacing: 14) {
                        ScenarioArtwork(systemImage: skill.systemImage, symbolSize: 24, cornerRadius: 14)
                            .frame(width: 56, height: 56)
                        VStack(alignment: .leading, spacing: 3) {
                            Text(skill.title)
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.accent)
                            Text(skill.items[0].title)
                                .font(.headline)
                            Text(skill.items[0].detail)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .multilineTextAlignment(.leading)
                    .padding(Spacing.card)
                    .learnSurface(radius: 30)
                    .background(alignment: .bottom) {
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .fill(.white.opacity(0.09))
                            .padding(.horizontal, 16)
                            .offset(y: 10)
                    }
                }
                .buttonStyle(.plain)
                .accessibilityElement(children: .combine)
            }
        }
        .padding(.bottom, 10)
    }

    /// A native picker for the skill, and what's waiting in it below.
    private var tabs: some View {
        VStack(spacing: Spacing.grid) {
            Picker("Skill", selection: $selected) {
                ForEach(LearnSkill.allCases) { skill in
                    Text(skill.title).tag(skill)
                }
            }
            .pickerStyle(.segmented)
            VStack(spacing: 0) {
                ForEach(Array(selected.items.enumerated()), id: \.offset) { index, item in
                    if index > 0 { Divider().padding(.leading, 82) }
                    Button { open(selected) } label: {
                        HStack(spacing: 14) {
                            ScenarioArtwork(systemImage: selected.systemImage, symbolSize: 22, cornerRadius: 12)
                                .frame(width: 52, height: 52)
                            VStack(alignment: .leading, spacing: 3) {
                                Text(item.title)
                                    .font(.headline)
                                Text(item.detail)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            Image(systemName: "chevron.right")
                                .font(.footnote.weight(.semibold))
                                .foregroundStyle(.tertiary)
                        }
                        .multilineTextAlignment(.leading)
                        .padding(Spacing.card)
                        .contentShape(.rect)
                    }
                    .buttonStyle(.plain)
                    .accessibilityElement(children: .combine)
                }
            }
            .learnSurface(radius: Radius.card)
            .animation(.snappy, value: selected)
        }
        .sensoryFeedback(.selection, trigger: selected)
    }

    /// Four round glass buttons, and the next thing for the chosen one.
    private var circles: some View {
        VStack(spacing: Spacing.grid) {
            HStack(spacing: 0) {
                ForEach(LearnSkill.allCases) { skill in
                    Button { selected = skill } label: {
                        VStack(spacing: 8) {
                            Image(systemName: skill.systemImage)
                                .font(.title2)
                                .foregroundStyle(selected == skill ? Color.onAccent : Color.accent)
                                .frame(width: 64, height: 64)
                                .background {
                                    Circle().fill(selected == skill ? Color.accentFill : Color.accent.opacity(0.14))
                                }
                            Text(skill.title)
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(selected == skill ? .primary : .secondary)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.plain)
                    .accessibilityAddTraits(selected == skill ? .isSelected : [])
                }
            }
            Button { open(selected) } label: {
                HStack(alignment: .center, spacing: 16) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(selected.items[0].title)
                            .font(.title3.weight(.semibold))
                        Text(selected.items[0].detail)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
                    ScenarioArtwork(systemImage: selected.systemImage, symbolSize: 32, cornerRadius: 16)
                        .frame(width: 76, height: 76)
                }
                .multilineTextAlignment(.leading)
                .padding(Spacing.cardLarge)
                .learnSurface()
            }
            .buttonStyle(.plain)
            .accessibilityElement(children: .combine)
            .animation(.snappy, value: selected)
        }
        .sensoryFeedback(.selection, trigger: selected)
    }

    /// Full-width cards washed in the theme colour from the left, a big symbol on the right.
    private var banners: some View {
        VStack(spacing: Spacing.grid) {
            ForEach(LearnSkill.allCases) { skill in
                Button { open(skill) } label: {
                    HStack {
                        VStack(alignment: .leading, spacing: 3) {
                            Text(skill.title)
                                .font(.title2.weight(.bold))
                            Text(skill.summary)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
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
                    .frame(height: 104)
                    .background {
                        LinearGradient(colors: [AppTheme.shared.palette.deep.opacity(0.35), Color.accentFill.opacity(0.85)],
                                       startPoint: .leading, endPoint: .trailing)
                    }
                    .background(.surface)
                    .clipShape(.rect(cornerRadius: Radius.card, style: .continuous))
                    .contentShape(.rect(cornerRadius: Radius.card, style: .continuous))
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
