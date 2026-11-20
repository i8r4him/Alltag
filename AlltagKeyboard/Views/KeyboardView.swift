//
//  KeyboardView.swift
//  AlltagKeyboard
//
//  Created by Ibrahim Abdullah on 20.11.26.
//

import SwiftUI

/// The whole keyboard: the tools row on top, then the numbers row and the keys.
/// The emoji take the place of all of it.
struct KeyboardView: View {
    let model: KeyboardModel
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    /// The keyboard's height; the extension sizes its view with the same numbers.
    static func height(isCompact: Bool) -> CGFloat {
        isCompact ? 214 : 307
    }

    static func toolsHeight(isCompact: Bool) -> CGFloat {
        isCompact ? 30 : 36
    }

    private var isCompact: Bool { verticalSizeClass == .compact }

    var body: some View {
        if model.showsEmoji {
            EmojiPanel(model: model)
        } else {
            VStack(spacing: 0) {
                ToolsRow(model: model)
                    .frame(height: Self.toolsHeight(isCompact: isCompact))
                KeysView(model: model, metrics: isCompact ? .landscape : .portrait)
            }
        }
    }
}

/// The numbers row and the keys, drawn from the same frames the touches are read with.
struct KeysView: View {
    let model: KeyboardModel
    let metrics: KeyboardMetrics

    var body: some View {
        GeometryReader { proxy in
            let geometry = KeyboardGeometry(rows: model.rows, size: proxy.size, metrics: metrics)
            ZStack(alignment: .topLeading) {
                ForEach(geometry.frames) { frame in
                    KeyView(model: model, frame: frame)
                }
                KeyTouchSurface(model: model, geometry: geometry)
                    .accessibilityHidden(true)
                KeyPopupLayer(model: model, width: proxy.size.width)
            }
        }
    }
}

/// One key in its place. It reads only what this key shows, so a key press
/// redraws that key and not the keyboard.
private struct KeyView: View {
    let model: KeyboardModel
    let frame: KeyFrame

    /// Only the letters and Shift itself change with Shift.
    private var shift: ShiftState {
        switch frame.key {
        case .shift: model.shift
        case .character(let text) where TypingEngine.capital(text) != text: model.shift
        default: .off
        }
    }

    var body: some View {
        let isEnter = frame.key == .enter
        KeyCap(key: frame.key, shift: shift,
               returnKey: isEnter ? model.traits.returnKey : .normal,
               returnEnabled: isEnter ? model.traits.returnEnabled : true,
               isPressed: model.state(of: frame.key).isPressed, isDimmed: model.movesCursor)
            .frame(width: frame.frame.width, height: frame.frame.height)
            .offset(x: frame.frame.minX, y: frame.frame.minY)
            .accessibilityElement()
            .accessibilityLabel(KeyCap.name(of: frame.key, shift: shift))
            .accessibilityAddTraits(.isKeyboardKey)
            .accessibilityAction { model.activate(frame.key) }
    }
}

/// The bubble over the pressed key, apart from the keys so it redraws alone.
private struct KeyPopupLayer: View {
    let model: KeyboardModel
    let width: CGFloat

    var body: some View {
        if let popup = model.popup {
            KeyPopupView(popup: popup, width: width)
                .allowsHitTesting(false)
                .accessibilityHidden(true)
        }
    }
}

#Preview("Keyboard") {
    KeyboardView(model: KeyboardModel())
        .frame(height: KeyboardView.height(isCompact: false))
        .background(.gray.opacity(0.3))
}
