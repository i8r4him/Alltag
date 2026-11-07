//
//  OptionCard.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// A selectable card with a title, optional subtitle and optional symbol,
/// used in onboarding ("A1 · Just starting out") and settings pickers.
///
/// Selected: accent tint background, accent border and a filled check.
struct OptionCard: View {
    let title: LocalizedStringKey
    var subtitle: LocalizedStringKey?
    var systemImage: String?
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                if let systemImage {
                    Image(systemName: systemImage)
                        .font(.title3)
                        .foregroundStyle(isSelected ? .accent : .secondary)
                        .frame(width: 28)
                        .accessibilityHidden(true)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(title).textRole(.cardTitle).foregroundStyle(.primary)
                    if let subtitle {
                        Text(subtitle).textRole(.meta).foregroundStyle(.secondary)
                    }
                }
                .multilineTextAlignment(.leading)
                Spacer(minLength: 8)
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(isSelected ? AnyShapeStyle(.accentFill) : AnyShapeStyle(.clear))
                    .accessibilityHidden(true)
            }
            .padding(.horizontal, Spacing.card)
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, minHeight: 60, alignment: .leading)
            .background(background, in: shape)
            .overlay { shape.strokeBorder(border, lineWidth: 1) }
            .contentShape(shape)
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isSelected ? .isSelected : [])
        .sensoryFeedback(.selection, trigger: isSelected)
        .animation(.easeOut(duration: 0.2), value: isSelected)
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: Radius.option, style: .continuous)
    }

    private var background: some ShapeStyle {
        isSelected ? AnyShapeStyle(.accentFill.opacity(AccentTint.selected)) : AnyShapeStyle(.surface)
    }

    private var border: some ShapeStyle {
        isSelected ? AnyShapeStyle(.accentFill.opacity(AccentTint.selectedBorder)) : AnyShapeStyle(.clear)
    }
}
