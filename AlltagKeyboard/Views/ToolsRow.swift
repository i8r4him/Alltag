//
//  ToolsRow.swift
//  AlltagKeyboard
//
//  Created by Ibrahim Abdullah on 20.11.26.
//

import SwiftUI

/// The row above the numbers: Alltag's orb, and words for the one being typed,
/// set like the words over Apple's keyboard.
/// The tools (Fix, How do I say …?) take this row in the next steps.
struct ToolsRow: View {
    let model: KeyboardModel

    var body: some View {
        HStack(spacing: 0) {
            KeyboardOrb()
                .frame(width: 22, height: 22)
                .padding(.leading, 12)
                .padding(.trailing, 6)
                .accessibilityHidden(true)
            SuggestionBar(words: model.suggestions) { model.choose($0) }
        }
    }
}

/// Up to three words in three equal parts; a tap puts one in place of the word being typed.
private struct SuggestionBar: View {
    let words: [String]
    let choose: (String) -> Void
    @State private var taps = 0
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<SuggestionPicker.limit, id: \.self) { index in
                if index > 0 {
                    Rectangle()
                        .fill(Color.primary.opacity(words.isEmpty ? 0 : 0.07))
                        .frame(width: 1, height: 23)
                }
                slot(index < words.count ? words[index] : nil)
            }
        }
        .sensoryFeedback(.impact(weight: .medium), trigger: taps)
    }

    @ViewBuilder
    private func slot(_ word: String?) -> some View {
        if let word {
            Button {
                taps += 1
                choose(word)
            } label: {
                Text(verbatim: word)
                    .font(.system(size: 17))
                    .foregroundStyle(Color.primary.opacity(colorScheme == .dark ? 0.6 : 0.68))
                    .lineLimit(1)
                    .minimumScaleFactor(0.7)
                    .padding(.horizontal, 4)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(.rect)
            }
            .buttonStyle(.plain)
        } else {
            Color.clear
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

/// Alltag's companion, small and still: its colours follow the theme chosen in the app.
struct KeyboardOrb: View {
    var body: some View {
        let palette = AppTheme.shared.palette
        Circle()
            .fill(RadialGradient(colors: [palette.light, palette.mid, palette.deep],
                                 center: UnitPoint(x: 0.35, y: 0.3), startRadius: 0, endRadius: 18))
    }
}
