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
    private let title: Text
    private let subtitle: Text?
    private let systemImage: String?
    private let isSelected: Bool
    private let action: () -> Void

    /// For any text: localized resources, or content shown as is (`Text(verbatim:)`).
    init(title: Text, subtitle: Text? = nil, systemImage: String? = nil,
         isSelected: Bool, action: @escaping () -> Void) {
        self.title = title
        self.subtitle = subtitle
        self.systemImage = systemImage
        self.isSelected = isSelected
        self.action = action
    }

    /// For UI text from the String Catalog.
    init(title: LocalizedStringResource, subtitle: LocalizedStringResource? = nil, systemImage: String? = nil,
         isSelected: Bool, action: @escaping () -> Void) {
        self.init(title: Text(title), subtitle: subtitle.map { Text($0) }, systemImage: systemImage,
                  isSelected: isSelected, action: action)
    }

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
                    title.textRole(.cardTitle).foregroundStyle(.primary)
                    if let subtitle {
                        subtitle.textRole(.meta).foregroundStyle(.secondary)
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
