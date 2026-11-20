//
//  LearnScalesDesign.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// "Waage" tips towards whichever side holds more of today's minutes.
struct LearnScalesDesign: View {
    let content: LearnPageContent

    @Environment(\.dynamicTypeSize) private var textSize

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.section) {
            if !content.steps.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    LearnSectionTitle(title: Text("Today's lesson"), note: content.lessonNote)
                    lesson
                }
            }

            VStack(alignment: .leading, spacing: 12) {
                LearnSectionTitle(title: Text("All of Learn"))
                GlassEffectContainer(spacing: Spacing.grid) {
                    VStack(spacing: 8) {
                        ForEach(content.overview.doors) { part in
                            measure(part)
                        }
                    }
                }
            }
        }
    }

    private var lesson: some View {
        let remainingMinutes = DailyLesson.minutesLeft(in: content.steps)
        let finishedMinutes = content.totalMinutes - remainingMinutes
        let balance = Double(remainingMinutes - finishedMinutes) / Double(max(content.totalMinutes, 1))
        let layout = textSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(alignment: .leading, spacing: 16))
            : AnyLayout(HStackLayout(alignment: .top, spacing: 12))
        return VStack(spacing: 12) {
            BalanceBeam(balance: balance)
                .frame(height: 108)
                .accessibilityHidden(true)
            layout {
                pan(isDone: true, minutes: finishedMinutes)
                pan(isDone: false, minutes: remainingMinutes)
            }
            if let next = content.current {
                LessonStartButton(step: next, isFirst: content.doneCount == 0) { content.open($0.target) }
            }
        }
        .padding(Spacing.card)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }

    private func pan(isDone: Bool, minutes: Int) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(minutes) min")
                .font(.title2.weight(.bold))
                .monospacedDigit()
                .foregroundStyle(isDone ? Color.accent : Color.primary)
            (isDone ? Text("Done") : Text("Remaining"))
                .font(.footnote.weight(.medium))
                .foregroundStyle(.secondary)
            ForEach(content.steps.filter { $0.isDone == isDone }) { step in
                weight(step)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(8)
    }

    private func weight(_ step: LessonStep) -> some View {
        let isNext = step.id == content.current?.id
        return Button { content.open(step.target) } label: {
            VStack(alignment: .leading, spacing: 4) {
                step.title.text
                    .font(.subheadline.weight(.semibold))
                if isNext {
                    Text("Next")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.accent)
                }
            }
            .frame(maxWidth: .infinity, minHeight: Spacing.minTouchTarget, alignment: .leading)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .matchedTransitionSource(id: step.target, in: content.zoom)
        .accessibilityElement(children: .combine)
        .accessibilityValue(step.isDone ? Text("Done") : Text(verbatim: ""))
    }

    private func measure(_ part: LearnOverview.Part) -> some View {
        Button { content.openPart(part.kind) } label: {
            HStack(spacing: 12) {
                Image(systemName: part.kind.systemImage)
                    .font(.title3)
                    .frame(width: 44, height: 44)
                    .foregroundStyle(.accent)
                    .background(.controlFill, in: .circle)
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 4) {
                    Text(part.kind.title).font(.headline)
                    PartProgressText(part: part)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                Spacer(minLength: 0)
                if let fraction = part.fraction {
                    Gauge(value: min(max(fraction, 0), 1)) {
                        Text(part.kind.title)
                    }
                    .gaugeStyle(.accessoryCircularCapacity)
                    .tint(.accentFill)
                    .accessibilityHidden(true)
                }
            }
            .padding(12)
            .glassEffect(.regular.interactive(), in: .rect(cornerRadius: Radius.option, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
    }
}

private struct BalanceBeam: View {
    let balance: Double

    var body: some View {
        let accent = Color.accent
        Canvas { context, size in
            let centre = CGPoint(x: size.width / 2, y: 30)
            let arm = min(size.width * 0.26, 120)
            let rise = balance * 16
            let left = CGPoint(x: centre.x - arm, y: centre.y - rise)
            let right = CGPoint(x: centre.x + arm, y: centre.y + rise)

            var stand = Path()
            stand.move(to: CGPoint(x: centre.x - 20, y: size.height - 8))
            stand.addLine(to: centre)
            stand.addLine(to: CGPoint(x: centre.x + 20, y: size.height - 8))
            stand.closeSubpath()
            context.fill(stand, with: .color(accent.opacity(0.2)))
            context.stroke(stand, with: .color(accent.opacity(0.5)), lineWidth: 2)

            var beam = Path()
            beam.move(to: left)
            beam.addLine(to: right)
            context.stroke(beam, with: .color(accent), style: StrokeStyle(lineWidth: 3, lineCap: .round))
            context.fill(Path(ellipseIn: CGRect(x: centre.x - 5, y: centre.y - 5, width: 10, height: 10)),
                         with: .color(accent))
            drawPan(at: left, in: context, colour: accent)
            drawPan(at: right, in: context, colour: .secondary)
        }
    }

    private func drawPan(at hook: CGPoint, in context: GraphicsContext, colour: Color) {
        let rimY = hook.y + 32
        let left = CGPoint(x: hook.x - 28, y: rimY)
        let right = CGPoint(x: hook.x + 28, y: rimY)
        var cords = Path()
        cords.move(to: left)
        cords.addLine(to: hook)
        cords.addLine(to: right)
        context.stroke(cords, with: .color(colour.opacity(0.65)), lineWidth: 1.5)

        var bowl = Path()
        bowl.move(to: left)
        bowl.addQuadCurve(to: right, control: CGPoint(x: hook.x, y: rimY + 32))
        bowl.closeSubpath()
        context.fill(bowl, with: .color(colour.opacity(0.25)))
        context.stroke(bowl, with: .color(colour), lineWidth: 2)
    }
}
