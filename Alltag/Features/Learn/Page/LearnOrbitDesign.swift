//
//  LearnOrbitDesign.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Page design 3, "Orbit": today's lesson is a glowing orb with its steps as
/// moons around it, lit once done; a tap on the orb starts the next one. The
/// parts of Learn follow as wide glass banners with their progress.
struct LearnOrbitDesign: View {
    let content: LearnPageContent

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.section) {
            if !content.steps.isEmpty {
                VStack(spacing: 18) {
                    LessonOrbit(content: content)
                    if let current = DailyLesson.current(in: content.steps) {
                        HStack(spacing: 4) {
                            Text("Next:")
                                .foregroundStyle(.secondary)
                            current.title.text
                                .fontWeight(.bold)
                                .lineLimit(1)
                            Text(verbatim: "· \(current.minutes) min")
                                .foregroundStyle(.secondary)
                        }
                        .font(.subheadline.weight(.semibold))
                        .frame(maxWidth: .infinity)
                    }
                }
            }
            VStack(alignment: .leading, spacing: 12) {
                LearnSectionTitle(title: Text("Everything"))
                VStack(spacing: Spacing.grid) {
                    ForEach(content.overview.doors) { part in
                        OrbitBanner(part: part) { content.openPart(part.kind) }
                    }
                }
            }
        }
    }
}

/// The orb and its moons on a dashed orbit.
private struct LessonOrbit: View {
    let content: LearnPageContent

    @ScaledMetric(relativeTo: .title) private var orbSize: CGFloat = 150
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    private let radius: CGFloat = 132
    private let moonSize: CGFloat = 52

    var body: some View {
        let steps = content.steps
        let current = DailyLesson.current(in: steps)
        let done = steps.filter(\.isDone).count
        ZStack {
            Circle()
                .stroke(Color.accentFill.opacity(0.4), style: StrokeStyle(lineWidth: 1.5, dash: [5, 5]))
                .frame(width: radius * 2, height: radius * 2)
            orb(current: current, done: done)
            GlassEffectContainer(spacing: 0) {
                ZStack {
                    ForEach(Array(steps.enumerated()), id: \.element.id) { index, step in
                        moon(step, isCurrent: step.id == current?.id)
                            .offset(offset(of: index, in: steps.count))
                    }
                }
            }
        }
        .frame(height: radius * 2 + moonSize + 24)
        .frame(maxWidth: .infinity)
    }

    private func orb(current: LessonStep?, done: Int) -> some View {
        Button {
            if let current { content.open(current.target) }
        } label: {
            VStack(spacing: 2) {
                Text(verbatim: "Heute")
                    .font(.title2.weight(.heavy))
                Text("\(done) of \(content.steps.count) · \(DailyLesson.minutesLeft(in: content.steps)) min")
                    .font(.subheadline.weight(.bold))
                    .monospacedDigit()
                Group {
                    if current == nil {
                        Text("Done for today")
                    } else {
                        Text("Tap to start")
                    }
                }
                .font(.footnote.weight(.bold))
                .padding(.top, 4)
            }
            .foregroundStyle(.onAccent)
            .frame(width: orbSize, height: orbSize)
            .background {
                Circle()
                    .fill(RadialGradient(colors: [.white.opacity(0.9), .accentFill, AppTheme.shared.palette.deep],
                                         center: UnitPoint(x: 0.35, y: 0.3), startRadius: 0, endRadius: orbSize * 0.7))
                    .shadow(color: Color.accentFill.opacity(0.6), radius: 30)
            }
            .phaseAnimator([false, true]) { view, glows in
                view.scaleEffect(glows && !reduceMotion ? 1.03 : 1)
            } animation: { _ in
                .easeInOut(duration: 2.4)
            }
            .contentShape(.circle)
        }
        .buttonStyle(.tile)
        .disabled(current == nil)
    }

    private func moon(_ step: LessonStep, isCurrent: Bool) -> some View {
        Button { content.open(step.target) } label: {
            Image(systemName: step.isDone ? "checkmark" : step.part.systemImage)
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(step.isDone ? AnyShapeStyle(.onAccent) : AnyShapeStyle(.accent))
                .frame(width: moonSize, height: moonSize)
                .background {
                    if step.isDone {
                        Circle()
                            .fill(.accentFill)
                            .shadow(color: Color.accentFill.opacity(0.6), radius: 10)
                    }
                }
                .overlay {
                    if isCurrent {
                        Circle()
                            .strokeBorder(.accentFill, lineWidth: 2)
                    }
                }
                .glassEffect(step.isDone ? Glass.identity : Glass.regular.interactive(), in: .circle)
                .overlay(alignment: .bottom) {
                    Text(verbatim: step.part.germanName)
                        .font(.caption.weight(.bold))
                        .foregroundStyle(.secondary)
                        .fixedSize()
                        .offset(y: 22)
                }
        }
        .buttonStyle(.plain)
        .matchedTransitionSource(id: step.target, in: content.zoom)
        .accessibilityLabel(step.title.text)
        .accessibilityValue(step.isDone ? Text("Done") : Text(verbatim: ""))
    }

    /// Where a moon sits: spread evenly round the orbit, the first at the top.
    private func offset(of index: Int, in count: Int) -> CGSize {
        let angle = -Double.pi / 2 + Double(index) * 2 * .pi / Double(max(count, 1))
        return CGSize(width: radius * cos(angle), height: radius * sin(angle))
    }
}

/// A part as a wide glass banner: its name, progress and a bar, with its
/// symbol large and faint behind.
private struct OrbitBanner: View {
    let part: LearnOverview.Part
    let onOpen: () -> Void

    var body: some View {
        Button(action: onOpen) {
            VStack(alignment: .leading, spacing: 4) {
                Text(part.kind.title)
                    .font(.title2.weight(.heavy))
                PartProgressText(part: part)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
                if let fraction = part.fraction {
                    PartBar(fraction: fraction)
                        .padding(.top, 10)
                        .padding(.trailing, 60)
                }
            }
            .padding(20)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(alignment: .topTrailing) {
                Image(systemName: part.kind.systemImage)
                    .font(.system(size: 96))
                    .foregroundStyle(Color.primary.opacity(0.08))
                    .offset(x: 8, y: -4)
            }
            .clipShape(.rect(cornerRadius: Radius.hero, style: .continuous))
            .glassEffect(.regular.interactive(), in: .rect(cornerRadius: Radius.hero, style: .continuous))
            .contentShape(.rect(cornerRadius: Radius.hero, style: .continuous))
        }
        .buttonStyle(.card)
        .accessibilityElement(children: .combine)
    }
}
