//
//  LevelChooser.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 10.11.26.
//

import SwiftUI

/// Temporary: designs for choosing the level on Grammar, to compare on device.
enum LevelChooserDesign: Int, CaseIterable {
    case circles, chips, cards, bigLevel, path

    var name: String {
        switch self {
        case .circles: "Circles"
        case .chips: "Glass chips"
        case .cards: "Cards"
        case .bigLevel: "Big level"
        case .path: "Path"
        }
    }
}

/// Temporary: steps through the level chooser designs.
struct LevelChooserSwitcher: View {
    @Binding var design: LevelChooserDesign

    var body: some View {
        let all = LevelChooserDesign.allCases
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
        let all = LevelChooserDesign.allCases
        withAnimation(.snappy) { design = all[(design.rawValue + offset + all.count) % all.count] }
    }
}

/// Chooses the level whose rules are shown, in one of the designs.
struct LevelChooser: View {
    let design: LevelChooserDesign
    @Binding var selection: Level
    /// Solved and total rules at a level.
    let counts: (Level) -> (solved: Int, total: Int)

    private let levels = Level.selectable

    var body: some View {
        Group {
            switch design {
            case .circles: circles
            case .chips: chips
            case .cards: cards
            case .bigLevel: bigLevel
            case .path: path
            }
        }
        .sensoryFeedback(.selection, trigger: selection)
    }

    private func select(_ level: Level) {
        withAnimation(.snappy) { selection = level }
    }

    private var summary: some View {
        Text(selection.summary)
            .font(.subheadline)
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity)
    }

    // MARK: Designs

    /// Five round buttons; the chosen one filled in the theme colour.
    private var circles: some View {
        VStack(spacing: 10) {
            HStack(spacing: 0) {
                ForEach(levels) { level in
                    let isOn = level == selection
                    Button { select(level) } label: {
                        Text(verbatim: level.title)
                            .font(.headline)
                            .foregroundStyle(isOn ? Color.onAccent : Color.accent)
                            .frame(width: 54, height: 54)
                            .background(Circle().fill(isOn ? Color.accentFill : Color.accent.opacity(0.14)))
                    }
                    .buttonStyle(.plain)
                    .frame(maxWidth: .infinity)
                    .accessibilityAddTraits(isOn ? .isSelected : [])
                }
            }
            summary
        }
    }

    /// Glass capsules; the chosen one prominent in the theme colour.
    private var chips: some View {
        VStack(spacing: 10) {
            GlassEffectContainer(spacing: 8) {
                HStack(spacing: 8) {
                    ForEach(levels) { level in
                        let isOn = level == selection
                        Group {
                            if isOn {
                                chip(level).buttonStyle(.glassProminent).tint(Color.accentFill)
                            } else {
                                chip(level).buttonStyle(.glass)
                            }
                        }
                        .accessibilityAddTraits(isOn ? .isSelected : [])
                    }
                }
            }
            summary
        }
    }

    private func chip(_ level: Level) -> some View {
        Button { select(level) } label: {
            Text(verbatim: level.title)
                .font(.headline)
                .frame(maxWidth: .infinity, minHeight: 30)
        }
    }

    /// Small cards scrolled sideways: the level big, what it means, solved count.
    private var cards: some View {
        ScrollView(.horizontal) {
            HStack(spacing: Spacing.grid) {
                ForEach(levels) { level in
                    let isOn = level == selection
                    let count = counts(level)
                    Button { select(level) } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(verbatim: level.title)
                                .font(.system(size: 34, weight: .bold, design: .rounded))
                                .foregroundStyle(isOn ? AnyShapeStyle(levelGradient) : AnyShapeStyle(.secondary))
                            Text(level.summary)
                                .font(.subheadline.weight(.semibold))
                                .lineLimit(2, reservesSpace: true)
                            Text("\(count.solved) of \(count.total) solved")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .multilineTextAlignment(.leading)
                        .padding(Spacing.card)
                        .frame(width: 150, alignment: .leading)
                        .learnSurface(radius: 28)
                        .overlay {
                            RoundedRectangle(cornerRadius: 28, style: .continuous)
                                .strokeBorder(Color.accentFill, lineWidth: isOn ? 2 : 0)
                        }
                    }
                    .buttonStyle(.plain)
                    .accessibilityAddTraits(isOn ? .isSelected : [])
                }
            }
        }
        .scrollIndicators(.hidden)
        .scrollClipDisabled()
    }

    /// The level huge in the theme gradient, with arrows to step through.
    private var bigLevel: some View {
        let index = levels.firstIndex(of: selection) ?? 0
        let count = counts(selection)
        return HStack {
            Button { select(levels[max(index - 1, 0)]) } label: {
                Image(systemName: "chevron.left").font(.title3.weight(.semibold)).frame(width: 30, height: 30)
            }
            .buttonStyle(.glass)
            .buttonBorderShape(.circle)
            .disabled(index == 0)
            .accessibilityLabel("Lower level")
            VStack(spacing: 2) {
                Text(verbatim: selection.title)
                    .font(.system(size: 64, weight: .bold, design: .rounded))
                    .foregroundStyle(levelGradient)
                    .contentTransition(.numericText())
                Text(selection.summary)
                    .font(.headline)
                Text("\(count.solved) of \(count.total) solved")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity)
            Button { select(levels[min(index + 1, levels.count - 1)]) } label: {
                Image(systemName: "chevron.right").font(.title3.weight(.semibold)).frame(width: 30, height: 30)
            }
            .buttonStyle(.glass)
            .buttonBorderShape(.circle)
            .disabled(index == levels.count - 1)
            .accessibilityLabel("Higher level")
        }
        .padding(Spacing.card)
        .learnSurface()
    }

    /// A path from A1 to C1: dots on a line, the chosen one large.
    private var path: some View {
        let chosen = levels.firstIndex(of: selection) ?? 0
        return VStack(spacing: 10) {
            HStack(spacing: 0) {
                ForEach(Array(levels.enumerated()), id: \.element) { index, level in
                    let isOn = index == chosen
                    Button { select(level) } label: {
                        VStack(spacing: 8) {
                            Circle()
                                .fill(index <= chosen ? Color.accentFill : Color.surfaceSecondary)
                                .frame(width: isOn ? 26 : 14, height: isOn ? 26 : 14)
                                .overlay {
                                    if isOn { Circle().strokeBorder(.white.opacity(0.8), lineWidth: 3) }
                                }
                                .frame(height: 26)
                            Text(verbatim: level.title)
                                .font(isOn ? .headline : .subheadline.weight(.semibold))
                                .foregroundStyle(isOn ? .primary : .secondary)
                        }
                        .frame(maxWidth: .infinity)
                        .contentShape(.rect)
                    }
                    .buttonStyle(.plain)
                    .accessibilityAddTraits(isOn ? .isSelected : [])
                }
            }
            .background(alignment: .top) {
                GeometryReader { proxy in
                    let step = proxy.size.width / CGFloat(levels.count)
                    Capsule()
                        .fill(Color.accent.opacity(0.2))
                        .frame(width: step * CGFloat(levels.count - 1), height: 4)
                        .offset(x: step / 2, y: 11)
                }
            }
            summary
        }
        .padding(Spacing.card)
        .learnSurface()
    }

    private var levelGradient: LinearGradient {
        LinearGradient(colors: [.accentFill, AppTheme.shared.palette.deep], startPoint: .top, endPoint: .bottom)
    }
}
