//
//  ToolsRow.swift
//  AlltagKeyboard
//
//  Created by Ibrahim Abdullah on 20.11.26.
//

import SwiftUI

/// The row above the numbers: Alltag's orb, and words for the one being typed.
/// The tools (Fix, How do I say …?) take this row in the next steps.
struct ToolsRow: View {
    let model: KeyboardModel

    var body: some View {
        HStack(spacing: 6) {
            KeyboardOrb()
                .frame(width: 26, height: 26)
                .accessibilityHidden(true)
            if model.suggestions.isEmpty {
                Spacer(minLength: 0)
            } else {
                SuggestionBar(words: model.suggestions) { model.choose($0) }
            }
        }
        .padding(.horizontal, 10)
    }
}

/// Up to three words; a tap puts one in place of the word being typed.
private struct SuggestionBar: View {
    let words: [String]
    let choose: (String) -> Void
    @State private var taps = 0

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(words.enumerated()), id: \.element) { index, word in
                if index > 0 {
                    Divider()
                        .frame(height: 20)
                }
                Button {
                    taps += 1
                    choose(word)
                } label: {
                    Text(verbatim: word)
                        .font(.system(size: 17))
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                        .padding(.horizontal, 4)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .contentShape(.rect)
                }
                .buttonStyle(.plain)
            }
        }
        .sensoryFeedback(.impact(weight: .medium), trigger: taps)
    }
}

/// Alltag's companion, small and still: its colours follow the theme chosen in the app.
struct KeyboardOrb: View {
    var body: some View {
        let palette = AppTheme.shared.palette
        Circle()
            .fill(RadialGradient(colors: [palette.light, palette.mid, palette.deep],
                                 center: UnitPoint(x: 0.35, y: 0.3), startRadius: 0, endRadius: 22))
            .shadow(color: palette.rim.opacity(0.55), radius: 6)
    }
}
