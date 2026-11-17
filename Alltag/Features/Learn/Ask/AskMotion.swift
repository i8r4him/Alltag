//
//  AskMotion.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// How "How do I say …?" moves: the answer card settles in under the field,
/// the details unfold, and the X folds it all away while the page below
/// slides up. With Reduce Motion everything is a short fade.
enum AskMotion {
    /// The answer arriving, changing size or going away; Learn animates the
    /// whole page with it so the cards below move instead of jumping.
    static func answer(reduceMotion: Bool) -> Animation {
        reduceMotion ? .easeInOut(duration: 0.2) : .smooth(duration: 0.4)
    }

    /// Opening and closing the details.
    static func details(reduceMotion: Bool) -> Animation {
        reduceMotion ? .easeInOut(duration: 0.2) : .smooth(duration: 0.45)
    }

    /// The answer card: it grows out of the field and settles, and shrinks
    /// back into it when closed.
    static func answerTransition(reduceMotion: Bool) -> AnyTransition {
        guard !reduceMotion else { return .opacity }
        return .asymmetric(
            insertion: .opacity.combined(with: .scale(scale: 0.96, anchor: .top)).combined(with: .offset(y: -8)),
            removal: .opacity.combined(with: .scale(scale: 0.96, anchor: .top))
        )
    }
}

/// What decides the size of what is under the field. Learn animates the page
/// when it changes, also when the change comes from the server.
struct AskLayout: Equatable {
    let showsRegister: Bool
    let hasAnswer: Bool
    let isTranslating: Bool
    let isExplaining: Bool
    let result: TranslationResult?
}

extension AskModel {
    var layout: AskLayout {
        AskLayout(showsRegister: showsRegister, hasAnswer: hasAnswer, isTranslating: translate.isTranslating,
                  isExplaining: translate.isExplaining, result: translate.result)
    }
}
