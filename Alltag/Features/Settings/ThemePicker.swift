//
//  ThemePicker.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 08.11.26.
//

import SwiftUI

/// A row of colour swatches that sets the app's theme and the companion's colour.
struct ThemePicker: View {
    @Bindable private var theme = AppTheme.shared

    var body: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 14) {
                ForEach(CompanionPalette.allCases) { option in
                    Button { theme.palette = option } label: { swatch(option) }
                        .buttonStyle(.plain)
                        .accessibilityLabel(Text(option.title))
                        .accessibilityAddTraits(theme.palette == option ? .isSelected : [])
                }
            }
            .padding(.vertical, 6)
        }
        .scrollIndicators(.hidden)
        .sensoryFeedback(.selection, trigger: theme.palette)
    }

    private func swatch(_ option: CompanionPalette) -> some View {
        let isSelected = theme.palette == option
        return VStack(spacing: 6) {
            Circle()
                .fill(RadialGradient(colors: [option.light, option.mid, option.deep],
                                     center: UnitPoint(x: 0.35, y: 0.3), startRadius: 0, endRadius: 26))
                .overlay(Circle().strokeBorder(option.rim, lineWidth: 1.5))
                .frame(width: 44, height: 44)
                .padding(3)
                .overlay(Circle().strokeBorder(.primary, lineWidth: isSelected ? 2 : 0))
            Text(option.title)
                .font(.caption2)
                .foregroundStyle(isSelected ? .primary : .secondary)
                .lineLimit(1)
                .fixedSize()
        }
    }
}

#Preview {
    List {
        Section("Appearance") { ThemePicker() }
    }
}
