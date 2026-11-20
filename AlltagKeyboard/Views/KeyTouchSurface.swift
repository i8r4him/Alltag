//
//  KeyTouchSurface.swift
//  AlltagKeyboard
//
//  Created by Ibrahim Abdullah on 20.11.26.
//

import SwiftUI
import UIKit

/// One clear layer over all keys that reads every finger itself.
///
/// SwiftUI buttons type on finger up, one at a time; a keyboard has to follow
/// several fingers at once and decide which key a touch in a gap means.
struct KeyTouchSurface: UIViewRepresentable {
    let model: KeyboardModel
    let geometry: KeyboardGeometry

    func makeUIView(context: Context) -> KeyTouchView {
        KeyTouchView()
    }

    func updateUIView(_ view: KeyTouchView, context: Context) {
        view.model = model
        view.geometry = geometry
    }
}

final class KeyTouchView: UIView {
    weak var model: KeyboardModel?
    var geometry = KeyboardGeometry(rows: [], size: .zero)

    override init(frame: CGRect) {
        super.init(frame: frame)
        isMultipleTouchEnabled = true
        isExclusiveTouch = false
        backgroundColor = .clear
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            model?.touchDown(touch.hash, at: touch.location(in: self), in: geometry)
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            model?.touchMoved(touch.hash, to: touch.location(in: self), in: geometry)
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            model?.touchUp(touch.hash)
        }
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            model?.touchCancelled(touch.hash)
        }
    }
}
