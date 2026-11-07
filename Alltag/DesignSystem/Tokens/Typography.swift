//
//  Typography.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// The text roles from the design spec.
///
/// Each role keeps the prototype's exact size at the default text size and
/// scales with Dynamic Type relative to the closest system text style.
/// Apply one with `.textRole(_:)`.
enum TextRole: CaseIterable {
    /// 44 bold, onboarding hero.
    case hero
    /// 34 bold, screen titles.
    case largeTitle
    /// 28 bold.
    case title2
    /// 22 bold, section headers.
    case sectionHeader
    /// 23 semibold, the companion's line in a conversation.
    case aiLine
    /// 18 regular, the learner's line in a conversation.
    case userLine
    /// 17 semibold, card titles.
    case cardTitle
    /// 17 regular.
    case body
    /// 15 regular, secondary body text.
    case bodySmall
    /// 13 regular, meta text.
    case meta
    /// 12 regular, captions.
    case caption
    /// 13 semibold uppercase with wide tracking, e.g. "TODAY'S FOCUS".
    case eyebrow

    var size: CGFloat {
        switch self {
        case .hero: 44
        case .largeTitle: 34
        case .title2: 28
        case .sectionHeader: 22
        case .aiLine: 23
        case .userLine: 18
        case .cardTitle, .body: 17
        case .bodySmall: 15
        case .meta, .eyebrow: 13
        case .caption: 12
        }
    }

    var weight: Font.Weight {
        switch self {
        case .hero, .largeTitle, .title2, .sectionHeader: .bold
        case .aiLine, .cardTitle, .eyebrow: .semibold
        case .userLine, .body, .bodySmall, .meta, .caption: .regular
        }
    }

    /// Letter spacing in points at the default size.
    var tracking: CGFloat {
        switch self {
        case .hero: -1.4
        case .largeTitle: -0.9
        case .title2: -0.8
        case .sectionHeader, .aiLine: -0.4
        case .eyebrow: 0.07 * size
        case .userLine, .cardTitle, .body, .bodySmall, .meta, .caption: 0
        }
    }

    /// The system text style this role scales with.
    var textStyle: Font.TextStyle {
        switch self {
        case .hero, .largeTitle: .largeTitle
        case .title2: .title
        case .sectionHeader, .aiLine: .title2
        case .userLine, .body: .body
        case .cardTitle: .headline
        case .bodySmall: .subheadline
        case .meta, .eyebrow: .footnote
        case .caption: .caption
        }
    }

    var isUppercased: Bool { self == .eyebrow }
}

private struct TextRoleModifier: ViewModifier {
    let role: TextRole
    @ScaledMetric private var size: CGFloat

    init(role: TextRole) {
        self.role = role
        _size = ScaledMetric(wrappedValue: role.size, relativeTo: role.textStyle)
    }

    @ViewBuilder
    func body(content: Content) -> some View {
        let styled = content
            .font(.system(size: size, weight: role.weight))
            .tracking(role.tracking * size / role.size)
        // Only set the text case when the role needs it: `.textCase(nil)` would
        // override an outer `.textCase(.uppercase)`.
        if role.isUppercased {
            styled.textCase(.uppercase)
        } else {
            styled
        }
    }
}

extension View {
    /// Styles text with one of the design system's text roles.
    func textRole(_ role: TextRole) -> some View {
        modifier(TextRoleModifier(role: role))
    }
}
