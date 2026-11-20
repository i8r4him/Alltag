//
//  LearnStageDesign.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// In "Bühne", the next exercise is in the spotlight and the other scenes are in the wings.
struct LearnStageDesign: View {
    let content: LearnPageContent

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.section) {
            if !content.steps.isEmpty {
                VStack(spacing: 12) {
                    LearnSectionTitle(title: Text("Today's lesson"), note: content.lessonNote)
                    proscenium
                    if let next = content.current {
                        LessonStartButton(step: next, isFirst: content.doneCount == 0) { content.open($0.target) }
                    }
                    ForEach(content.steps.filter { $0.id != content.current?.id }) { step in
                        sceneInWings(step)
                    }
                }
            }

            VStack(alignment: .leading, spacing: 12) {
                LearnSectionTitle(title: Text(verbatim: "Programm"))
                VStack(spacing: 0) {
                    ForEach(Array(content.overview.doors.enumerated()), id: \.element.id) { index, part in
                        if index > 0 { Divider() }
                        programmeEntry(part)
                    }
                }
                .padding(.horizontal, Spacing.card)
                .glassEffect(.regular, in: .rect(cornerRadius: Radius.option, style: .continuous))
            }
        }
    }

    private var proscenium: some View {
        Group {
            if let next = content.current {
                Button { content.open(next.target) } label: {
                    VStack(spacing: 8) {
                        ScenarioArtwork(systemImage: next.systemImage, symbolSize: 68)
                            .frame(width: 112, height: 100)
                        Text("Next")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.accent)
                        next.title.text
                            .font(.title2.weight(.bold))
                    }
                    .padding(.horizontal, 40)
                    .padding(.vertical, 20)
                    .frame(maxWidth: .infinity)
                    .contentShape(.rect)
                }
                .buttonStyle(.plain)
                .matchedTransitionSource(id: next.target, in: content.zoom)
                .accessibilityElement(children: .combine)
            } else {
                Image(systemName: "hands.clap")
                    .font(.largeTitle)
                    .foregroundStyle(.accent)
                    .frame(maxWidth: .infinity, minHeight: 140)
                    .accessibilityHidden(true)
            }
        }
        .multilineTextAlignment(.center)
        .background { curtains }
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }

    private var curtains: some View {
        HStack(spacing: 0) {
            curtain
            Spacer(minLength: 0)
            curtain.scaleEffect(x: -1, y: 1)
        }
        .clipShape(.rect(cornerRadius: Radius.hero, style: .continuous))
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    private var curtain: some View {
        StageCurtain()
            .fill(.linearGradient(
                colors: [Color.accent.opacity(0.55), Color.accentFill.opacity(0.32), Color.accent.opacity(0.55)],
                startPoint: .leading, endPoint: .trailing
            ))
            .frame(width: 52)
    }

    private func sceneInWings(_ step: LessonStep) -> some View {
        Button { content.open(step.target) } label: {
            HStack(spacing: 8) {
                LessonStepDot(step: step, isCurrent: false, size: 28)
                step.title.text
                    .font(.subheadline.weight(.semibold))
                Spacer(minLength: 4)
                if step.isDone {
                    Text("Done")
                        .font(.footnote.weight(.medium))
                        .foregroundStyle(.accent)
                }
            }
            .padding(.horizontal, Spacing.card)
            .padding(.vertical, 4)
            .frame(minHeight: Spacing.minTouchTarget)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .matchedTransitionSource(id: step.target, in: content.zoom)
        .accessibilityElement(children: .combine)
    }

    private func programmeEntry(_ part: LearnOverview.Part) -> some View {
        Button { content.openPart(part.kind) } label: {
            ViewThatFits(in: .horizontal) {
                HStack(alignment: .firstTextBaseline, spacing: 8) {
                    Text(part.kind.title).font(.headline)
                    Spacer(minLength: 8)
                    progress(part)
                }
                VStack(alignment: .leading, spacing: 4) {
                    Text(part.kind.title).font(.headline)
                    progress(part)
                }
            }
            .padding(.vertical, 12)
            .frame(maxWidth: .infinity, minHeight: Spacing.minTouchTarget, alignment: .leading)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
    }

    private func progress(_ part: LearnOverview.Part) -> some View {
        PartProgressText(part: part)
            .font(.subheadline)
            .foregroundStyle(.secondary)
    }
}

private struct StageCurtain: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: rect.origin)
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
            path.addQuadCurve(to: CGPoint(x: rect.midX, y: rect.midY),
                              control: CGPoint(x: rect.maxX, y: rect.height * 0.3))
            path.addQuadCurve(to: CGPoint(x: rect.width * 0.8, y: rect.maxY),
                              control: CGPoint(x: rect.minX, y: rect.height * 0.7))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.closeSubpath()
        }
    }
}
