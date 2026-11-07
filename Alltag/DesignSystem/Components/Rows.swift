//
//  Rows.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// An SF Symbol in a rounded square, used at the start of rows.
struct SymbolSquare: View {
    let systemImage: String
    var tint: Color = .controlFill
    var foreground: Color = .primary
    var size: CGFloat = 30

    var body: some View {
        Image(systemName: systemImage)
            .font(.system(size: size * 0.5, weight: .semibold))
            .foregroundStyle(foreground)
            .frame(width: size, height: size)
            .background(tint, in: .rect(cornerRadius: size * 0.27, style: .continuous))
            .accessibilityHidden(true)
    }
}

/// A list row: symbol, title, optional subtitle, optional value and chevron.
/// Use it as the label of a `Button` or `NavigationLink`, or inside a `Form`.
struct CardRow: View {
    let title: LocalizedStringKey
    var subtitle: LocalizedStringKey?
    var systemImage: String?
    var symbolTint: Color = .controlFill
    var symbolForeground: Color = .primary
    var value: LocalizedStringKey?
    var showsChevron = true

    var body: some View {
        HStack(spacing: 12) {
            if let systemImage {
                SymbolSquare(systemImage: systemImage, tint: symbolTint, foreground: symbolForeground)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(title).textRole(.body)
                if let subtitle {
                    Text(subtitle).textRole(.meta).foregroundStyle(.secondary)
                }
            }
            Spacer(minLength: 8)
            if let value {
                Text(value).textRole(.bodySmall).foregroundStyle(.secondary)
            }
            if showsChevron {
                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.tertiary)
                    .accessibilityHidden(true)
            }
        }
        .frame(minHeight: Spacing.rowMinHeight)
        .contentShape(.rect)
        .accessibilityElement(children: .combine)
    }
}

/// A row with a symbol, title, optional subtitle and a toggle, for Settings.
struct ToggleRow: View {
    let title: LocalizedStringKey
    var subtitle: LocalizedStringKey?
    let systemImage: String
    var symbolTint: Color = .controlFill
    var symbolForeground: Color = .primary
    @Binding var isOn: Bool

    var body: some View {
        Toggle(isOn: $isOn) {
            HStack(spacing: 12) {
                SymbolSquare(systemImage: systemImage, tint: symbolTint, foreground: symbolForeground)
                VStack(alignment: .leading, spacing: 2) {
                    Text(title).textRole(.body)
                    if let subtitle {
                        Text(subtitle).textRole(.meta).foregroundStyle(.secondary)
                    }
                }
            }
        }
        .tint(.success)
        .frame(minHeight: Spacing.rowMinHeight)
    }
}
