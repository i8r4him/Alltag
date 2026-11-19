//
//  LessonCardDesign.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Design 1, "One card": Today's hero card for the whole lesson. A ring shows
/// how much is done, a row of circles the parts, a line the next step, and the
/// big button starts it or carries on.
struct LessonCardDesign: View {
    let level: Level
    let steps: [LessonStep]
    let zoom: Namespace.ID
    let onOpen: (LessonStep) -> Void

    @ScaledMetric(relativeTo: .title3) private var ringSize: CGFloat = 88

    var body: some View {
        let current = DailyLesson.current(in: steps)
        let done = steps.filter(\.isDone).count
        VStack(spacing: 18) {
            HStack(alignment: .center, spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    eyebrow(done: done, isFinished: current == nil)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.accent)
                    if current == nil {
                        Text("Done for today")
                            .font(.title3.weight(.semibold))
                        Text("A new lesson is ready tomorrow.")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    } else {
                        Text("A bit of everything")
                            .font(.title3.weight(.semibold))
                        Text("About \(DailyLesson.minutesLeft(in: steps)) minutes to go")
                            .font(.title3)
                            .foregroundStyle(.secondary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityElement(children: .combine)
                ring(done: done, current: current)
            }
            parts(current: current)
            if let current {
                VStack(spacing: 12) {
                    nextLine(current)
                    GlassEffectContainer {
                        Button { onOpen(current) } label: {
                            Label {
                                done == 0 ? Text("Start the lesson") : Text("Continue")
                            } icon: {
                                Image(systemName: "play.fill")
                            }
                        }
                        .buttonStyle(.primary)
                    }
                }
            }
        }
        .padding(Spacing.cardLarge)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }

    /// "A2 · 2 of 5 done", or a tick and "Done today".
    @ViewBuilder
    private func eyebrow(done: Int, isFinished: Bool) -> some View {
        if isFinished {
            Label("Done today", systemImage: "checkmark.circle.fill")
        } else {
            Text("\(level.title) · \(done) of \(steps.count) done")
        }
    }

    /// The ring of what's done, with the next part's symbol inside.
    private func ring(done: Int, current: LessonStep?) -> some View {
        ZStack {
            LevelRing(fraction: Double(done) / Double(max(steps.count, 1)), lineWidth: 8)
            Image(systemName: current?.part.systemImage ?? "checkmark")
                .font(.system(size: ringSize * 0.3, weight: .semibold))
                .foregroundStyle(.accent)
                .contentTransition(.symbolEffect(.replace))
        }
        .frame(width: ringSize, height: ringSize)
        .accessibilityHidden(true)
    }

    /// One circle per part, with its name; a tap opens that part straight away.
    private func parts(current: LessonStep?) -> some View {
        HStack(alignment: .top, spacing: 4) {
            ForEach(steps) { step in
                Button { onOpen(step) } label: {
                    VStack(spacing: 6) {
                        LessonStepDot(step: step, isCurrent: step.id == current?.id)
                        Text(step.part.name)
                            .font(.caption2.weight(.semibold))
                            .foregroundStyle(step.id == current?.id ? AnyShapeStyle(.accent) : AnyShapeStyle(.secondary))
                            .lineLimit(1)
                            .minimumScaleFactor(0.8)
                    }
                    .frame(maxWidth: .infinity)
                    .contentShape(.rect)
                }
                .buttonStyle(.tile)
                .matchedTransitionSource(id: step.target, in: zoom)
                .accessibilityElement(children: .combine)
                .accessibilityValue(step.isDone ? Text("Done") : Text(verbatim: ""))
            }
        }
    }

    /// "Next · Der Akkusativ · 4 min".
    private func nextLine(_ step: LessonStep) -> some View {
        HStack(spacing: 6) {
            Text("Next")
                .foregroundStyle(.secondary)
            step.title.text
                .fontWeight(.semibold)
                .lineLimit(1)
            Spacer(minLength: 8)
            Text("\(step.minutes) min")
                .foregroundStyle(.secondary)
                .monospacedDigit()
        }
        .font(.subheadline)
        .accessibilityElement(children: .combine)
    }
}
