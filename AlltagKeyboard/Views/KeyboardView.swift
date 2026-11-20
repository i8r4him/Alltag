//
//  KeyboardView.swift
//  AlltagKeyboard
//
//  Created by Ibrahim Abdullah on 20.11.26.
//

import SwiftUI

/// The whole keyboard: the tools row on top, then the numbers row and the keys.
struct KeyboardView: View {
    let model: KeyboardModel
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    /// The keyboard's height; the extension sizes its view with the same numbers.
    static func height(isCompact: Bool) -> CGFloat {
        isCompact ? 214 : 306
    }

    private var isCompact: Bool { verticalSizeClass == .compact }

    var body: some View {
        VStack(spacing: 0) {
            ToolsRow(model: model)
                .frame(height: isCompact ? 34 : 46)
            KeysView(model: model, metrics: isCompact ? .landscape : .portrait)
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
                    KeyCap(key: frame.key, shift: model.shift, returnKey: model.traits.returnKey,
                           isPressed: model.pressed.contains(frame.key), isDimmed: model.movesCursor)
                        .frame(width: frame.frame.width, height: frame.frame.height)
                        .offset(x: frame.frame.minX, y: frame.frame.minY)
                        .accessibilityElement()
                        .accessibilityLabel(KeyCap.name(of: frame.key, shift: model.shift))
                        .accessibilityAddTraits(.isKeyboardKey)
                        .accessibilityAction { model.activate(frame.key) }
                }
                KeyTouchSurface(model: model, geometry: geometry)
                    .accessibilityHidden(true)
                if let popup = model.popup {
                    KeyPopupView(popup: popup, width: proxy.size.width)
                        .allowsHitTesting(false)
                        .accessibilityHidden(true)
                }
            }
        }
    }
}

#Preview("Keyboard") {
    KeyboardView(model: KeyboardModel())
        .frame(height: KeyboardView.height(isCompact: false))
        .background(.gray.opacity(0.3))
}
