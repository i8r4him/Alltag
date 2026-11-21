//
//  ToolsRow.swift
//  AlltagKeyboard
//
//  Created by Ibrahim Abdullah on 20.11.26.
//

import SwiftUI

/// The row above the numbers: Alltag's orb and its tools, and words for the one being typed,
/// set like the words over Apple's keyboard. What a tool answers takes the row's place.
struct ToolsRow: View {
    let model: KeyboardModel
    @State private var taps = 0

    var body: some View {
        if model.tools.panel != nil {
            ToolPanel(tools: model.tools)
        } else {
            HStack(spacing: 0) {
                Button {
                    taps += 1
                    model.openSettings()
                } label: {
                    KeyboardOrb()
                        .frame(width: 22, height: 22)
                        .padding(.leading, 12)
                        .padding(.trailing, 8)
                        .frame(maxHeight: .infinity)
                        .contentShape(.rect)
                }
                .buttonStyle(.plain)
                .accessibilityLabel(Text("Keyboard settings"))
                // While words are offered the tools keep to their symbols.
                let isShort = !model.suggestions.isEmpty || model.correction != nil
                HStack(spacing: 6) {
                    ToolChip(title: Text("Fix"), symbol: "text.badge.checkmark", isShort: isShort) {
                        taps += 1
                        Task { await model.tools.fix() }
                    }
                    ToolChip(title: Text("How do I say"), symbol: "translate", isShort: isShort) {
                        taps += 1
                        Task { await model.tools.say() }
                    }
                    ToolChip(title: Text(verbatim: "der · die · das"), symbol: "character.book.closed", isShort: isShort,
                             showsSymbolWithTitle: false) {
                        taps += 1
                        Task { await model.tools.article() }
                    }
                }
                if isShort {
                    SuggestionBar(words: model.suggestions, correction: model.correction,
                                  choose: { model.choose($0) }, keep: { model.keepTyped() })
                        .padding(.leading, 4)
                } else {
                    Spacer(minLength: 0)
                }
            }
            .sensoryFeedback(.impact(weight: .medium), trigger: taps)
        }
    }
}

/// One tool in the row: a pill in the colour of the keys.
private struct ToolChip: View {
    let title: Text
    let symbol: String
    let isShort: Bool
    /// A tool whose name says it all shows its symbol only when there is no room for the name.
    var showsSymbolWithTitle = true
    let action: () -> Void
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                if isShort || showsSymbolWithTitle {
                    Image(systemName: symbol)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(Color.accent)
                }
                if !isShort {
                    title
                        .font(.system(size: 15, weight: .medium))
                        .lineLimit(1)
                }
            }
            .foregroundStyle(.primary)
            .padding(.horizontal, isShort ? 10 : 12)
            .frame(height: 30)
            .background(KeyCap.fill(isDark: colorScheme == .dark), in: .capsule)
            .contentShape(.capsule)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
    }
}

/// Up to three words in three equal parts; a tap puts one in place of the word being typed.
/// A word about to be corrected shows as typed on the left and, marked, as what the space will make of it.
private struct SuggestionBar: View {
    let words: [String]
    var correction: Correction?
    let choose: (String) -> Void
    let keep: () -> Void
    @State private var taps = 0
    @Environment(\.colorScheme) private var colorScheme

    private enum Slot {
        case typed(String)
        case fix(String)
        case word(String)
        case empty
    }

    private var slots: [Slot] {
        var slots: [Slot] = []
        if let correction {
            slots = [.typed(correction.typed), .fix(correction.replacement)]
            if let other = words.first(where: { $0 != correction.replacement && $0 != correction.typed }) {
                slots.append(.word(other))
            }
        } else {
            slots = words.prefix(SuggestionPicker.limit).map { Slot.word($0) }
        }
        return slots + Array(repeating: Slot.empty, count: max(SuggestionPicker.limit - slots.count, 0))
    }

    var body: some View {
        let shown = slots
        HStack(spacing: 0) {
            ForEach(0..<SuggestionPicker.limit, id: \.self) { index in
                if index > 0 {
                    Rectangle()
                        .fill(Color.primary.opacity(words.isEmpty && correction == nil ? 0 : 0.07))
                        .frame(width: 1, height: 23)
                }
                slot(shown[index])
            }
        }
        .sensoryFeedback(.impact(weight: .medium), trigger: taps)
    }

    @ViewBuilder
    private func slot(_ slot: Slot) -> some View {
        switch slot {
        case .typed(let word):
            button(Text(verbatim: "„\(word)“"), isMarked: false) { keep() }
        case .fix(let word):
            button(Text(verbatim: word), isMarked: true) { choose(word) }
        case .word(let word):
            button(Text(verbatim: word), isMarked: false) { choose(word) }
        case .empty:
            Color.clear
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    private func button(_ title: Text, isMarked: Bool, action: @escaping () -> Void) -> some View {
        Button {
            taps += 1
            action()
        } label: {
            title
                .font(.system(size: 17))
                .foregroundStyle(Color.primary.opacity(isMarked ? 1 : colorScheme == .dark ? 0.6 : 0.68))
                .lineLimit(1)
                .minimumScaleFactor(0.7)
                .padding(.horizontal, isMarked ? 8 : 4)
                .frame(height: 28)
                .background(Color.primary.opacity(isMarked ? 0.1 : 0), in: .rect(cornerRadius: 8, style: .continuous))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(.rect)
        }
        .buttonStyle(.plain)
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
