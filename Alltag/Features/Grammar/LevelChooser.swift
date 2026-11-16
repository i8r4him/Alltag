//
//  LevelChooser.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 10.11.26.
//

import SwiftUI

/// Chooses the level whose rules are shown: small cards scrolled sideways with
/// the level big, what it means and how many rules are solved, on glass.
/// Opens at the chosen level.
struct LevelChooser: View {
    @Binding var selection: Level
    /// Solved and total rules at a level.
    let counts: (Level) -> (solved: Int, total: Int)

    var body: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal) {
                GlassEffectContainer(spacing: Spacing.grid) {
                    HStack(spacing: Spacing.grid) {
                        ForEach(Level.selectable) { level in
                            LevelCard(level: level, count: counts(level), isSelected: level == selection) {
                                // Only the cards animate: the rules below switch at once, so a
                                // level of sixty rows doesn't animate every row.
                                selection = level
                                withAnimation(.snappy) { proxy.scrollTo(level, anchor: .center) }
                            }
                            .id(level)
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .scrollClipDisabled()
            .onAppear { proxy.scrollTo(selection, anchor: .center) }
        }
        .sensoryFeedback(.selection, trigger: selection)
    }
}

private struct LevelCard: View {
    let level: Level
    let count: (solved: Int, total: Int)
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: 4) {
                Text(verbatim: level.title)
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundStyle(isSelected ? AnyShapeStyle(gradient) : AnyShapeStyle(.secondary))
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
            .contentShape(.rect(cornerRadius: 28, style: .continuous))
            .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 28, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .strokeBorder(Color.accentFill, lineWidth: isSelected ? 2 : 0)
            }
            .animation(.snappy, value: isSelected)
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    private var gradient: LinearGradient {
        LinearGradient(colors: [.accentFill, AppTheme.shared.palette.deep], startPoint: .top, endPoint: .bottom)
    }
}
