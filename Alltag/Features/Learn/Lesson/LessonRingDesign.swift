//
//  LessonRingDesign.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Design 2, "Big ring": the lesson as one large ring in the middle of the
/// card, a piece for each part that lights up once done, like an activity
/// ring. The next part's symbol and the count sit inside; the next step, the
/// part names and the big button sit under it.
struct LessonRingDesign: View {
    let level: Level
    let steps: [LessonStep]
    let zoom: Namespace.ID
    let onOpen: (LessonStep) -> Void

    @ScaledMetric(relativeTo: .title) private var ringSize: CGFloat = 164

    var body: some View {
        let current = DailyLesson.current(in: steps)
        let done = steps.filter(\.isDone).count
        VStack(spacing: 18) {
            ZStack {
                LessonPartsRing(steps: steps, current: current, lineWidth: 14)
                VStack(spacing: 2) {
                    Image(systemName: current?.part.systemImage ?? "checkmark")
                        .font(.system(size: ringSize * 0.2, weight: .semibold))
                        .foregroundStyle(.accent)
                        .contentTransition(.symbolEffect(.replace))
                    Text(verbatim: "\(done)/\(steps.count)")
                        .font(.system(size: ringSize * 0.16, weight: .bold, design: .rounded))
                        .monospacedDigit()
                        .contentTransition(.numericText())
                }
            }
            .frame(width: ringSize, height: ringSize)
            .padding(.top, 4)
            .accessibilityElement()
            .accessibilityLabel(Text("\(done) of \(steps.count) done"))
            VStack(spacing: 6) {
                if let current {
                    Text("\(level.title) · Next: \(Text(current.part.name))")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.accent)
                    current.title.text
                        .font(.title3.weight(.semibold))
                    Text("About \(DailyLesson.minutesLeft(in: steps)) minutes to go")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                } else {
                    Label("Done today", systemImage: "checkmark.circle.fill")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.accent)
                    Text("Done for today")
                        .font(.title3.weight(.semibold))
                    Text("A new lesson is ready tomorrow.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
            .accessibilityElement(children: .combine)
            partNames(current: current)
            if let current {
                LessonStartButton(step: current, isFirst: done == 0, onOpen: onOpen)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(Spacing.cardLarge)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }

    /// The parts as small chips under the ring; a tap opens one straight away.
    private func partNames(current: LessonStep?) -> some View {
        HStack(spacing: 6) {
            ForEach(steps) { step in
                Button { onOpen(step) } label: {
                    Image(systemName: step.isDone ? "checkmark" : step.part.systemImage)
                        .font(.footnote.weight(.bold))
                        .foregroundStyle(chipStyle(step, current: current))
                        .frame(width: 40, height: 30)
                        .background(step.id == current?.id ? AnyShapeStyle(Color.accentFill.opacity(0.18))
                                                           : AnyShapeStyle(.controlFill), in: .capsule)
                        .frame(minHeight: Spacing.minTouchTarget)
                        .contentShape(.rect)
                }
                .buttonStyle(.tile)
                .matchedTransitionSource(id: step.target, in: zoom)
                .accessibilityLabel(Text(step.part.name))
                .accessibilityValue(step.isDone ? Text("Done") : Text(verbatim: ""))
            }
        }
    }

    private func chipStyle(_ step: LessonStep, current: LessonStep?) -> AnyShapeStyle {
        if step.isDone || step.id == current?.id { return AnyShapeStyle(.accent) }
        return AnyShapeStyle(.secondary)
    }
}

/// A ring cut into one piece per part, with small gaps: a done part is lit,
/// the next one glows faintly, the rest are a dim track.
struct LessonPartsRing: View {
    let steps: [LessonStep]
    let current: LessonStep?
    var lineWidth: CGFloat = 10

    var body: some View {
        let count = max(steps.count, 1)
        let gap = 0.035
        ZStack {
            ForEach(Array(steps.enumerated()), id: \.element.id) { index, step in
                let start = Double(index) / Double(count)
                let end = Double(index + 1) / Double(count)
                Circle()
                    .trim(from: start + gap / 2, to: end - gap / 2)
                    .stroke(colour(for: step), style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                    .rotationEffect(.degrees(-90))
            }
        }
        .padding(lineWidth / 2)
        .animation(.smooth, value: steps.filter(\.isDone).count)
        .accessibilityHidden(true)
    }

    private func colour(for step: LessonStep) -> Color {
        if step.isDone { return .accentFill }
        return step.id == current?.id ? .accentFill.opacity(0.4) : .accentFill.opacity(0.16)
    }
}
