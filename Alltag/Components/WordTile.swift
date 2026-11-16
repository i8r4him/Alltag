//
//  WordTile.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// A word or chunk of a German sentence, styled by its grammatical role.
struct WordTile: View {
    enum Style: Equatable {
        /// Plain word.
        case plain
        /// The word that triggers the rule: outlined in amber.
        case key
        /// The verb or the part that moves: amber tint.
        case highlighted
        /// A tile placed in the answer of a word-order task.
        case placed
    }

    let text: String
    var style: Style = .plain

    init(_ text: String, style: Style = .plain) {
        self.text = text
        self.style = style
    }

    init(_ tile: GrammarRule.Tile) {
        self.init(tile.text, style: Self.style(for: tile.role))
    }

    static func style(for role: GrammarRule.Tile.Role) -> Style {
        switch role {
        case .plain: .plain
        case .key: .key
        case .verb, .end: .highlighted
        }
    }

    var body: some View {
        Text(verbatim: text)
            .textRole(.body)
            .fontWeight(style == .key || style == .highlighted ? .semibold : .regular)
            .foregroundStyle(style == .highlighted ? AnyShapeStyle(.accent) : AnyShapeStyle(.primary))
            .padding(.horizontal, 11)
            .padding(.vertical, 8)
            .background(background, in: .rect(cornerRadius: 10, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .strokeBorder(style == .key ? AnyShapeStyle(.accentFill.opacity(0.5)) : AnyShapeStyle(.clear), lineWidth: 1)
            }
    }

    private var background: AnyShapeStyle {
        switch style {
        // System fills see through the glass card in both modes.
        case .plain: AnyShapeStyle(.fill.tertiary)
        case .key: AnyShapeStyle(.fill.tertiary)
        case .highlighted: AnyShapeStyle(.accentFill.opacity(0.18))
        case .placed: AnyShapeStyle(.fill.secondary)
        }
    }
}

#Preview {
    FlowLayout(spacing: 6) {
        ForEach(MockRules.verbSecond.tiles, id: \.text) { WordTile($0) }
        WordTile("placed", style: .placed)
    }
    .padding()
    .background(.surface)
}
