//
//  Headers.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Small uppercase label above a title, e.g. "TODAY'S FOCUS".
struct Eyebrow: View {
    enum Tone { case accent, mistake, secondary }

    let title: LocalizedStringKey
    var tone: Tone = .accent

    var body: some View {
        Text(title)
            .textRole(.eyebrow)
            .foregroundStyle(color)
            .accessibilityAddTraits(.isHeader)
    }

    private var color: Color {
        switch tone {
        case .accent: .accent
        case .mistake: .mistake
        case .secondary: .secondary
        }
    }
}

/// A section title, with an optional trailing accessory such as a
/// "Rehearse from your Calendar" label or a "See all" button.
///
/// `.large` is the bold section header ("Coming up"); `.grouped` is the small
/// uppercase label above a grouped list ("LEARNING").
struct SectionHeader<Accessory: View>: View {
    enum Style { case large, grouped }

    let title: LocalizedStringKey
    var style: Style = .large
    @ViewBuilder var accessory: () -> Accessory

    var body: some View {
        // Side by side when it fits, stacked at large text sizes.
        ViewThatFits(in: .horizontal) {
            HStack(alignment: .firstTextBaseline) {
                titleText.fixedSize()
                Spacer(minLength: 8)
                accessoryView.fixedSize()
            }
            VStack(alignment: .leading, spacing: 4) {
                titleText
                accessoryView
            }
        }
        .padding(.horizontal, style == .grouped ? Spacing.card : 0)
    }

    private var titleText: some View {
        Text(title)
            .textRole(style == .large ? .sectionHeader : .caption)
            .textCase(style == .grouped ? .uppercase : nil)
            .foregroundStyle(style == .large ? .primary : .secondary)
            .accessibilityAddTraits(.isHeader)
    }

    private var accessoryView: some View {
        accessory()
            .textRole(.caption)
            .foregroundStyle(.secondary)
    }
}

extension SectionHeader where Accessory == EmptyView {
    init(_ title: LocalizedStringKey, style: Style = .large) {
        self.init(title: title, style: style) { EmptyView() }
    }
}
