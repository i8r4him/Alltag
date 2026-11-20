//
//  LessonStripDesign.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Lesson design 3, "Strip": a row of circles, one per part, where the step to do
/// now opens up into a wide capsule with its name and title. Finishing a step
/// folds it into a tick and opens the next one, so the row walks along the
/// lesson. A big count on the right and the big button finish the card.
struct LessonStripDesign: View {
    let steps: [LessonStep]
    let zoom: Namespace.ID
    let onOpen: (LessonStep) -> Void

    @ScaledMetric(relativeTo: .headline) private var rowHeight: CGFloat = 48

    var body: some View {
        let current = DailyLesson.current(in: steps)
        let done = steps.filter(\.isDone).count
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .center, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    if current == nil {
                        Label("Done today", systemImage: "checkmark.circle.fill")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.accent)
                        Text("Done for today")
                            .font(.title3.weight(.semibold))
                    } else {
                        Text("About \(DailyLesson.minutesLeft(in: steps)) minutes to go")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.accent)
                        Text("One thing from every part")
                            .font(.title3.weight(.semibold))
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityElement(children: .combine)
                Text(verbatim: "\(done)/\(steps.count)")
                    .font(.system(.largeTitle, design: .rounded, weight: .bold))
                    .monospacedDigit()
                    .foregroundStyle(.accent)
                    .contentTransition(.numericText())
                    .accessibilityLabel(Text("\(done) of \(steps.count) done"))
            }
            HStack(spacing: 8) {
                ForEach(steps) { step in
                    Button { onOpen(step) } label: {
                        if step.id == current?.id {
                            openStep(step)
                        } else {
                            LessonStepDot(step: step, isCurrent: false, size: rowHeight)
                        }
                    }
                    .buttonStyle(.tile)
                    .matchedTransitionSource(id: step.target, in: zoom)
                    .accessibilityElement(children: .combine)
                    .accessibilityLabel(Text(step.part.name))
                    .accessibilityValue(step.isDone ? Text("Done") : Text(verbatim: ""))
                }
            }
            if let current {
                LessonStartButton(step: current, isFirst: done == 0, onOpen: onOpen)
            }
        }
        .padding(Spacing.cardLarge)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
        .animation(.smooth, value: current?.id)
    }

    /// The step to do now, opened up: its symbol, part and title in a capsule.
    private func openStep(_ step: LessonStep) -> some View {
        HStack(spacing: 8) {
            Image(systemName: step.part.systemImage)
                .font(.callout.weight(.semibold))
                .foregroundStyle(.onAccent)
                .frame(width: rowHeight - 10, height: rowHeight - 10)
                .background(.accentFill, in: .circle)
            VStack(alignment: .leading, spacing: 0) {
                Text(step.part.name)
                    .font(.caption2.weight(.bold))
                    .foregroundStyle(.accent)
                step.title.text
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(1)
            }
            Spacer(minLength: 0)
        }
        .padding(.leading, 5)
        .padding(.trailing, 12)
        .frame(maxWidth: .infinity, minHeight: rowHeight, maxHeight: rowHeight)
        .background(Color.accentFill.opacity(0.14), in: .capsule)
        .overlay { Capsule().strokeBorder(Color.accentFill.opacity(0.6), lineWidth: 1.5) }
        .contentShape(.capsule)
    }
}
