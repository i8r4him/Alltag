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

    var systemImage: String {
        switch self {
        case .read: "envelope.open.fill"
        case .write: "square.and.pencil"
        case .listen: "ear.fill"
        case .grammar: "text.badge.checkmark"
        }
    }
}

/// "Practise": a wide glass banner per skill, tinted in the theme colour, with
/// a big symbol on the right.
struct SkillsSection: View {
    let onOpen: (LearnSkill) -> Void

    @State private var taps = 0
    @State private var tint = BannerTint.soft

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
                            SkillBanner(skill: skill, tint: tint.color(for: skill))
                        }
                        .buttonStyle(.plain)
                        .accessibilityElement(children: .combine)
                    }
                }
            }
            BannerTintSwitcher(tint: $tint)
        }
        .fontDesign(.rounded)
        .sensoryFeedback(.impact(weight: .light), trigger: taps)
    }
}

private struct SkillBanner: View {
    let skill: LearnSkill
    let tint: Color?

    @ScaledMetric(relativeTo: .title2) private var height: CGFloat = 104

    var body: some View {
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
        .frame(minHeight: height)
        .glassEffect(.regular.tint(tint), in: RoundedRectangle(cornerRadius: Radius.card, style: .continuous))
        .clipShape(.rect(cornerRadius: Radius.card, style: .continuous))
        .contentShape(.rect(cornerRadius: Radius.card, style: .continuous))
    }
}

/// Temporary: tints for the glass banners, all from the theme, to compare on device.
enum BannerTint: Int, CaseIterable {
    case clear, soft, medium, strong, deep, light, shades

    var name: String {
        switch self {
        case .clear: "Clear glass"
        case .soft: "Soft"
        case .medium: "Medium"
        case .strong: "Strong"
        case .deep: "Deep"
        case .light: "Light"
        case .shades: "Shades"
        }
    }

    /// The tint for `skill`; `nil` is untinted glass.
    func color(for skill: LearnSkill) -> Color? {
        let palette = AppTheme.shared.palette
        switch self {
        case .clear: return nil
        case .soft: return Color.accentFill.opacity(0.25)
        case .medium: return Color.accentFill.opacity(0.45)
        case .strong: return Color.accentFill.opacity(0.7)
        case .deep: return palette.deep.opacity(0.6)
        case .light: return palette.light.opacity(0.35)
        case .shades:
            let shades = [palette.light, palette.rim, palette.mid, palette.deep]
            let index = LearnSkill.allCases.firstIndex(of: skill) ?? 0
            return shades[index].opacity(0.5)
        }
    }
}

/// Temporary: steps through the banner tints.
private struct BannerTintSwitcher: View {
    @Binding var tint: BannerTint

    var body: some View {
        let all = BannerTint.allCases
        HStack(spacing: 14) {
            Button { step(-1) } label: { Image(systemName: "chevron.left") }
            Text(verbatim: "\(tint.rawValue + 1) / \(all.count) · \(tint.name)")
                .foregroundStyle(.secondary)
                .frame(minWidth: 130)
            Button { step(1) } label: { Image(systemName: "chevron.right") }
        }
        .font(.footnote.weight(.semibold))
        .buttonStyle(.glass)
        .frame(maxWidth: .infinity)
        .sensoryFeedback(.selection, trigger: tint)
    }

    private func step(_ offset: Int) {
        let all = BannerTint.allCases
        withAnimation(.snappy) { tint = all[(tint.rawValue + offset + all.count) % all.count] }
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
    SkillsSection { _ in }
        .padding(Spacing.screen)
        .background(.screenBackground)
}
