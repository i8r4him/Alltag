//
//  KeyCap.swift
//  AlltagKeyboard
//
//  Created by Ibrahim Abdullah on 20.11.26.
//

import SwiftUI
import UIKit

/// The font on Apple's keys: the system font in its compact design (SF Compact).
/// It has no name in SwiftUI, so it is asked for by the design's name; an iOS that
/// doesn't know the name answers with the usual system font.
enum KeyFont {
    private static let compact = UIFontDescriptor.SystemDesign(rawValue: "NSCTFontUIFontDesignCompact")
    private static var fonts: [CGFloat: Font] = [:]

    static func font(size: CGFloat) -> Font {
        if let font = fonts[size] { return font }
        let font = Font(uiFont(size: size))
        fonts[size] = font
        return font
    }

    static func uiFont(size: CGFloat) -> UIFont {
        let system = UIFont.systemFont(ofSize: size, weight: .regular)
        return system.fontDescriptor.withDesign(compact).map { UIFont(descriptor: $0, size: size) } ?? system
    }
}

/// One key as it is drawn, in the look of Apple's keyboard: every key in one colour,
/// flat, the letters a little above the middle. The sizes are measured on Apple's.
/// It takes no touches itself: `KeyTouchSurface` reads them all.
struct KeyCap: View {
    let key: KeyboardKey
    let shift: ShiftState
    let returnKey: ReturnKeyKind
    var returnEnabled = true
    let isPressed: Bool
    /// While the space bar moves the cursor, the letters step back.
    var isDimmed = false
    @Environment(\.colorScheme) private var colorScheme

    static let cornerRadius: CGFloat = 8.5

    var body: some View {
        RoundedRectangle(cornerRadius: Self.cornerRadius, style: .continuous)
            .fill(fill)
            .overlay {
                label
                    .foregroundStyle(ink)
                    .opacity(isDimmed && key != .space ? 0.25 : 1)
            }
            .overlay(alignment: .bottomTrailing) {
                if key == .space {
                    Text(verbatim: "DE")
                        .font(.system(size: 14).width(.compressed))
                        .foregroundStyle(Color.primary.opacity(colorScheme == .dark ? 0.31 : 0.2))
                        .padding(.trailing, 6)
                        .padding(.bottom, 5)
                }
            }
    }

    @ViewBuilder private var label: some View {
        switch key {
        case .character(let text):
            Text(verbatim: shift.isOn ? TypingEngine.capital(text) : text)
                .font(Self.font(for: text, isCapital: shift.isOn))
                .offset(y: -1.5)
        case .shift:
            Image(systemName: shift == .locked ? "capslock.fill" : shift == .once ? "shift.fill" : "shift")
                .font(.system(size: 19, weight: .medium))
        case .delete:
            Image(systemName: isPressed ? "delete.left.fill" : "delete.left")
                .font(.system(size: 19, weight: .medium))
        case .page(let page):
            Text(verbatim: page.label)
                .font(KeyFont.font(size: page == .symbols ? 19 : 17))
                .tracking(page == .symbols ? 0.6 : 0)
        case .globe:
            Image(systemName: "globe")
                .font(.system(size: 19))
        case .emoji:
            Image(systemName: colorScheme == .dark ? "face.smiling.inverse" : "face.smiling")
                .font(.system(size: 19))
        case .space:
            EmptyView()
        case .enter:
            Image(systemName: returnKey.symbol)
                .font(.system(size: 19, weight: .medium))
        }
    }

    /// Capitals are 23 pt on Apple's keys; small letters are drawn a little larger.
    static func font(for text: String, isCapital: Bool) -> Font {
        let isLetter = text.first?.isLetter == true
        return KeyFont.font(size: !isLetter ? 22 : isCapital ? 23 : 25)
    }

    /// Every key has the same colour. A letter shows its bubble when pressed; the other keys darken.
    private var fill: Color {
        let isDark = colorScheme == .dark
        if key == .enter, returnKey != .normal {
            return .accentFill.opacity(isPressed || !returnEnabled ? 0.6 : 1)
        }
        if isPressed, !key.isCharacter {
            return isDark ? .white.opacity(0.32) : Color(white: 0.78)
        }
        return isDark ? .white.opacity(0.162) : .white
    }

    private var ink: Color {
        guard key == .enter else { return .primary }
        if returnKey != .normal { return .onAccent }
        return returnEnabled ? .primary : .primary.opacity(0.22)
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
        case .emoji: Text("Emoji")
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
                    .font(KeyFont.font(size: popup.isAlternates ? 24 : 32))
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
                .fill(colorScheme == .dark ? Color(white: 0.42) : .white)
                .shadow(color: .black.opacity(0.22), radius: 4, y: 1)
        }
        .offset(x: origin.x, y: origin.y)
    }
}
