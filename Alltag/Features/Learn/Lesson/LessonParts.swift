//
//  LessonParts.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

extension LessonTarget: Identifiable {
    var id: Self { self }
}

/// A part of the lesson as a small circle: its symbol, a ring when it's next,
/// filled with a tick once done.
struct LessonStepDot: View {
    let step: LessonStep
    let isCurrent: Bool
    var size: CGFloat = 44

    var body: some View {
        ZStack {
            Circle()
                .fill(step.isDone ? AnyShapeStyle(.accentFill) : AnyShapeStyle(.controlFill))
            if isCurrent {
                Circle()
                    .strokeBorder(.accentFill, lineWidth: 2)
            }
            Image(systemName: step.isDone ? "checkmark" : step.part.systemImage)
                .font(.system(size: size * 0.38, weight: .semibold))
                .foregroundStyle(symbolStyle)
        }
        .frame(width: size, height: size)
        .accessibilityHidden(true)
    }

    private var symbolStyle: AnyShapeStyle {
        if step.isDone { return AnyShapeStyle(.onAccent) }
        return isCurrent ? AnyShapeStyle(.accent) : AnyShapeStyle(.secondary)
    }
}

/// The big button under every design: starts the lesson, or carries on with the next step.
struct LessonStartButton: View {
    let step: LessonStep
    /// Nothing is done yet today.
    let isFirst: Bool
    /// "Start · 4 min" instead of "Start the lesson" or "Continue".
    var showsMinutes = false
    let onOpen: (LessonStep) -> Void

    var body: some View {
        GlassEffectContainer {
            Button { onOpen(step) } label: {
                Label {
                    if showsMinutes {
                        Text("Start · \(step.minutes) min")
                    } else if isFirst {
                        Text("Start the lesson")
                    } else {
                        Text("Continue")
                    }
                } icon: {
                    Image(systemName: "play.fill")
                }
            }
            .buttonStyle(.primary)
        }
    }
}
