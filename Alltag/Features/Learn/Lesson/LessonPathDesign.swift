//
//  LessonPathDesign.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Design 2, "Path": the lesson as a route on one glass card, like a course's
/// plan for the day. The parts are stops on a line that fills in as they are
/// done; the next stop is larger, shows a taste of it and has its own Start.
struct LessonPathDesign: View {
    let steps: [LessonStep]
    let zoom: Namespace.ID
    let onOpen: (LessonStep) -> Void

    var body: some View {
        let current = DailyLesson.current(in: steps)
        let done = steps.filter(\.isDone).count
        VStack(alignment: .leading, spacing: 14) {
            VStack(alignment: .leading, spacing: 10) {
                HStack(alignment: .firstTextBaseline) {
                    if current == nil {
                        Label("Done for today", systemImage: "checkmark.circle.fill")
                            .foregroundStyle(.accent)
                    } else {
                        Text("\(done) of \(steps.count) done")
                    }
                    Spacer()
                    if current != nil {
                        Text("About \(DailyLesson.minutesLeft(in: steps)) min left")
                            .foregroundStyle(.secondary)
                    }
                }
                .font(.subheadline.weight(.semibold))
                ProgressSegments(total: steps.count, completed: done, height: 4)
            }
            VStack(spacing: 0) {
                ForEach(Array(steps.enumerated()), id: \.element.id) { index, step in
                    PathStop(step: step, isCurrent: step.id == current?.id,
                             isFirst: index == 0, isLast: index == steps.count - 1,
                             isPreviousDone: index > 0 && steps[index - 1].isDone, onOpen: onOpen)
                        .matchedTransitionSource(id: step.target, in: zoom)
                }
            }
        }
        .padding(Spacing.cardLarge)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }
}

/// One stop on the path: a circle on the line, the part, and the step.
private struct PathStop: View {
    let step: LessonStep
    let isCurrent: Bool
    let isFirst: Bool
    let isLast: Bool
    let isPreviousDone: Bool
    let onOpen: (LessonStep) -> Void

    var body: some View {
        if isCurrent {
            row
        } else {
            Button { onOpen(step) } label: { row }
                .buttonStyle(.plain)
                .accessibilityElement(children: .combine)
                .accessibilityValue(step.isDone ? Text("Done") : Text(verbatim: ""))
        }
    }

    private var row: some View {
        HStack(alignment: .top, spacing: 14) {
            VStack(spacing: 0) {
                line(isFirst ? .clear : lineColour(done: isPreviousDone))
                    .frame(height: 10)
                LessonStepDot(step: step, isCurrent: isCurrent, size: isCurrent ? 44 : 36)
                line(isLast ? .clear : lineColour(done: step.isDone))
                    .frame(minHeight: 10, maxHeight: .infinity)
            }
            .frame(width: 44)
            details
                .padding(.top, 10)
                .padding(.bottom, isLast ? 0 : 14)
            if !isCurrent {
                Image(systemName: step.isDone ? "arrow.counterclockwise" : "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.tertiary)
                    .padding(.top, 20)
                    .accessibilityHidden(true)
            }
        }
        .fixedSize(horizontal: false, vertical: true)
        .contentShape(.rect)
    }

    private var details: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                Text(step.part.name)
                    .textCase(.uppercase)
                Text(verbatim: "·")
                Text("\(step.minutes) min")
            }
            .font(.caption.weight(.bold))
            .foregroundStyle(isCurrent ? AnyShapeStyle(.accent) : AnyShapeStyle(.secondary))
            step.title.text
                .font(isCurrent ? Font.title3.weight(.semibold) : Font.headline)
                .foregroundStyle(step.isDone ? HierarchicalShapeStyle.secondary : HierarchicalShapeStyle.primary)
                .fixedSize(horizontal: false, vertical: true)
            if isCurrent {
                if let preview = step.preview {
                    Text(verbatim: preview)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                Button { onOpen(step) } label: {
                    Label("Start", systemImage: "play.fill")
                }
                .buttonStyle(.primaryCompact)
                .padding(.top, 8)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .multilineTextAlignment(.leading)
    }

    private func line(_ colour: Color) -> some View {
        Rectangle()
            .fill(colour)
            .frame(width: 2)
    }

    private func lineColour(done: Bool) -> Color {
        done ? .accentFill : .controlFill
    }
}
