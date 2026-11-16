//
//  RuleVisualView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// The picture of a rule: who does something to what, as two pieces of
/// artwork with the verb on an arrow between them. The word the rule changes
/// is in the theme colour.
struct RuleScene: View {
    let visual: RuleVisual
    @ScaledMetric(relativeTo: .title3) private var artworkSize: CGFloat = 76

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            part(visual.from)
            VStack(spacing: 2) {
                Text(verbatim: visual.verb)
                    .font(.subheadline.weight(.semibold))
                Image(systemName: "arrow.right")
                    .font(.title2.weight(.semibold))
            }
            .foregroundStyle(.accent)
            .frame(height: artworkSize)
            part(visual.to)
        }
        .frame(maxWidth: .infinity)
        .environment(\.locale, Locale(identifier: "de"))
        .accessibilityElement()
        .accessibilityLabel(Text(verbatim: visual.sentence))
        .accessibilityValue(Text(verbatim: "\(visual.from.name), \(visual.to.name)"))
    }

    private func part(_ part: RuleVisual.Part) -> some View {
        VStack(spacing: 4) {
            ScenarioArtwork(systemImage: part.systemImage, symbolSize: 38, cornerRadius: 22)
                .frame(width: artworkSize, height: artworkSize)
                .padding(.bottom, 4)
            Text(Self.highlighted(part))
                .font(.headline)
            Text(verbatim: part.role)
                .font(.footnote)
                .foregroundStyle(.secondary)
            Text(verbatim: part.name)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.tertiary)
        }
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
    }

    /// The part's German with the word the rule changes in the theme colour.
    static func highlighted(_ part: RuleVisual.Part) -> AttributedString {
        var text = AttributedString(part.german)
        if let marked = part.marked, let range = text.range(of: marked) {
            text[range].foregroundColor = AppTheme.shared.palette.accent
            text[range].inlinePresentationIntent = .stronglyEmphasized
        }
        return text
    }
}

/// The few forms a rule changes, as a tiny table. The cells that change are
/// in the theme colour.
struct RuleTable: View {
    let visual: RuleVisual

    var body: some View {
        Grid(horizontalSpacing: 6, verticalSpacing: 6) {
            GridRow {
                Color.clear
                    .gridCellUnsizedAxes([.horizontal, .vertical])
                ForEach(visual.columns, id: \.self) { column in
                    Text(verbatim: column)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.secondary)
                }
            }
            .accessibilityHidden(true)
            ForEach(visual.rows, id: \.label) { row in
                GridRow {
                    Text(verbatim: row.label)
                        .font(.footnote.weight(.semibold))
                        .foregroundStyle(.secondary)
                        .gridColumnAlignment(.leading)
                    ForEach(row.cells.indices, id: \.self) { index in
                        cell(row.cells[index], isMarked: row.marked.contains(index))
                    }
                }
                .accessibilityElement(children: .combine)
            }
        }
    }

    private func cell(_ text: String, isMarked: Bool) -> some View {
        Text(verbatim: text)
            .font(.subheadline.weight(isMarked ? .bold : .regular))
            .foregroundStyle(isMarked ? AnyShapeStyle(.accent) : AnyShapeStyle(.primary))
            .multilineTextAlignment(.center)
            .environment(\.locale, Locale(identifier: "de"))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(isMarked ? AnyShapeStyle(.accentFill.opacity(0.18)) : AnyShapeStyle(.fill.tertiary),
                        in: .rect(cornerRadius: 10, style: .continuous))
    }
}

#Preview {
    if let visual = MockRules.accusative.visual {
        VStack(spacing: 16) {
            RuleScene(visual: visual)
            RuleTable(visual: visual)
        }
        .padding(Spacing.cardLarge)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.card, style: .continuous))
        .padding(Spacing.screen)
        .skyBackground()
        .fontDesign(.rounded)
    }
}
