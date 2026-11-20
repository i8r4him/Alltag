//
//  KeyCap.swift
//  AlltagKeyboard
//
//  Created by Ibrahim Abdullah on 20.11.26.
//

import SwiftUI

/// One key as it is drawn. It takes no touches itself: `KeyTouchSurface` reads them all.
struct KeyCap: View {
    let key: KeyboardKey
    let shift: ShiftState
    let returnKey: ReturnKeyKind
    let isPressed: Bool
    /// While the space bar moves the cursor, the letters step back.
    var isDimmed = false
    @Environment(\.colorScheme) private var colorScheme

    static let cornerRadius: CGFloat = 9

    var body: some View {
        RoundedRectangle(cornerRadius: Self.cornerRadius, style: .continuous)
            .fill(fill)
            .shadow(color: .black.opacity(colorScheme == .dark ? 0 : 0.28), radius: 0, y: 1)
            .overlay {
                label
                    .foregroundStyle(ink)
                    .opacity(isDimmed && key != .space ? 0.25 : 1)
            }
    }

    @ViewBuilder private var label: some View {
        switch key {
        case .character(let text):
            Text(verbatim: shift.isOn ? TypingEngine.capital(text) : text)
                .font(.system(size: text.first?.isLetter == true ? 24 : 21))
        case .shift:
            Image(systemName: shift == .locked ? "capslock.fill" : shift == .once ? "shift.fill" : "shift")
                .font(.system(size: 19, weight: .medium))
        case .delete:
            Image(systemName: isPressed ? "delete.left.fill" : "delete.left")
                .font(.system(size: 19, weight: .medium))
        case .page(let page):
            Text(verbatim: page.label)
                .font(.system(size: 16))
        case .globe:
            Image(systemName: "globe")
                .font(.system(size: 19))
        case .space:
            Text(verbatim: "Deutsch")
                .font(.system(size: 15))
                .opacity(0.55)
        case .enter:
            Image(systemName: returnKey.symbol)
                .font(.system(size: 19, weight: .medium))
        }
    }

    /// Letters and the space bar are light keys; the keys that do something are darker,
    /// until Shift is on or return sends, searches or goes on.
    private var fill: Color {
        let isDark = colorScheme == .dark
        switch key {
        case .character, .space:
            if isPressed, key == .space { return isDark ? .white.opacity(0.16) : Color(white: 0.72) }
            return isDark ? .white.opacity(0.3) : .white
        case .shift where shift.isOn:
            return isDark ? .white.opacity(0.88) : .white
        case .enter where returnKey != .normal:
            return .accentFill.opacity(isPressed ? 0.75 : 1)
        case .shift, .delete, .page, .globe, .enter:
            if isPressed { return isDark ? .white.opacity(0.3) : .white }
            return isDark ? .white.opacity(0.13) : Color(red: 0.68, green: 0.70, blue: 0.74)
        }
    }

    private var ink: Color {
        switch key {
        case .shift where shift.isOn: .black
        case .enter where returnKey != .normal: .onAccent
        default: .primary
        }
    }

    /// What VoiceOver calls a key.
    static func name(of key: KeyboardKey, shift: ShiftState) -> Text {
        switch key {
        case .character(let text): Text(verbatim: shift.isOn ? TypingEngine.capital(text) : text)
        case .shift: shift == .locked ? Text("Caps Lock") : Text("Shift")
        case .delete: Text("Delete")
        case .page(.letters): Text("Letters")
        case .page(.symbols): Text("Symbols")
        case .page(.moreSymbols): Text("More symbols")
        case .globe: Text("Next keyboard")
        case .space: Text("Space")
        case .enter: Text("Return")
        }
    }
}

/// The bubble over a pressed key.
struct KeyPopupView: View {
    let popup: KeyPopup
    /// The keyboard's width: the bubble stays inside it.
    let width: CGFloat
    @Environment(\.colorScheme) private var colorScheme

    private var cell: CGSize {
        CGSize(width: popup.isAlternates ? popup.cellWidth : popup.frame.frame.width + 14,
               height: popup.frame.frame.height + 8)
    }

    private var origin: CGPoint {
        let key = popup.frame.frame
        let x = popup.isAlternates
            ? popup.minX(in: width)
            : min(max(key.midX - cell.width / 2, 2), width - cell.width - 2)
        return CGPoint(x: x, y: key.minY - cell.height - 4)
    }

    /// The options from left to right as they are drawn.
    private var drawn: [Int] {
        let all = Array(popup.options.indices)
        return popup.runsLeft(in: width) ? all.reversed() : all
    }

    var body: some View {
        HStack(spacing: 0) {
            ForEach(drawn, id: \.self) { index in
                let isChosen = popup.isAlternates && index == popup.selection
                Text(verbatim: popup.options[index])
                    .font(.system(size: popup.isAlternates ? 24 : 32))
                    .foregroundStyle(isChosen ? Color.onAccent : Color.primary)
                    .frame(width: cell.width, height: cell.height)
                    .background {
                        if isChosen {
                            RoundedRectangle(cornerRadius: KeyCap.cornerRadius, style: .continuous)
                                .fill(Color.accentFill)
                                .padding(3)
                        }
                    }
            }
        }
        .background {
            RoundedRectangle(cornerRadius: KeyCap.cornerRadius + 3, style: .continuous)
                .fill(colorScheme == .dark ? Color(white: 0.4) : .white)
                .shadow(color: .black.opacity(0.3), radius: 6, y: 2)
        }
        .offset(x: origin.x, y: origin.y)
    }
}
