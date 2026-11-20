//
//  LearnLoomDesign.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// "Webstuhl" weaves a line for each lesson step. The next thread sits in the shuttle.
struct LearnLoomDesign: View {
    let content: LearnPageContent

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.section) {
            if !content.steps.isEmpty {
                lesson
            }
            VStack(alignment: .leading, spacing: 12) {
                LearnSectionTitle(title: Text(verbatim: "Stoffproben"))
                GlassEffectContainer(spacing: Spacing.grid) {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 136), spacing: Spacing.grid)], spacing: Spacing.grid) {
                        ForEach(Array(content.overview.doors.enumerated()), id: \.element.id) { index, part in
                            swatch(part, offset: index)
                        }
                    }
                }
            }
        }
    }

    private var lesson: some View {
        VStack(alignment: .leading, spacing: 12) {
            LearnSectionTitle(title: Text("Today's lesson"), note: content.lessonNote)
            VStack(spacing: 0) {
                ForEach(Array(content.steps.enumerated()), id: \.element.id) { index, step in
                    thread(step, offset: index)
                }
            }
            .overlay(alignment: .top) { beam }
            .overlay(alignment: .bottom) { beam }
            .glassEffect(.regular, in: .rect(cornerRadius: Radius.option, style: .continuous))
            if let next = content.current {
                LessonStartButton(step: next, isFirst: content.doneCount == 0) { content.open($0.target) }
            }
        }
    }

    private var beam: some View {
        Capsule()
            .fill(.controlFill)
            .frame(height: 4)
            .padding(.horizontal, 8)
            .allowsHitTesting(false)
            .accessibilityHidden(true)
    }

    private func thread(_ step: LessonStep, offset: Int) -> some View {
        let isNext = step.id == content.current?.id
        return Button { content.open(step.target) } label: {
            VStack(alignment: .leading, spacing: 4) {
                step.title.text
                    .font(.headline)
                if isNext || step.isDone {
                    content.status(of: step)
                        .font(.footnote.weight(.medium))
                        .foregroundStyle(.accent)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 12)
            .padding(.trailing, Spacing.card)
            .padding(.leading, 96)
            .frame(minHeight: Spacing.rowMinHeight)
            .overlay(alignment: .leading) {
                threadArt(finished: step.isDone, isNext: isNext, offset: offset)
            }
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .matchedTransitionSource(id: step.target, in: content.zoom)
        .accessibilityElement(children: .combine)
    }

    private func threadArt(finished: Bool, isNext: Bool, offset: Int) -> some View {
        Weave(fraction: finished ? 1 : 0, offset: offset)
            .overlay {
                if isNext {
                    Image(systemName: "arrowtriangle.right.fill")
                        .font(.caption)
                        .foregroundStyle(.onAccent)
                        .frame(width: 48, height: 24)
                        .background(.accentFill, in: .capsule)
                }
            }
            .frame(width: 72)
            .padding(.leading, 12)
            .allowsHitTesting(false)
            .accessibilityHidden(true)
    }

    private func swatch(_ part: LearnOverview.Part, offset: Int) -> some View {
        Button { content.openPart(part.kind) } label: {
            VStack(alignment: .leading, spacing: 4) {
                if let fraction = part.fraction {
                    Weave(fraction: fraction, offset: offset)
                        .frame(height: 32)
                        .accessibilityHidden(true)
                } else {
                    Image(systemName: part.kind.systemImage)
                        .foregroundStyle(.accent)
                        .frame(height: 32)
                        .accessibilityHidden(true)
                }
                Text(part.kind.title)
                    .font(.headline)
                PartProgressText(part: part)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .glassEffect(.regular.interactive(), in: .rect(cornerRadius: Radius.option, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
    }
}

/// Alternating over and under crossings, with the finished cloth filling from the leading edge.
private struct Weave: View {
    let fraction: Double
    let offset: Int

    var body: some View {
        let accent = Color.accent
        Canvas { context, size in
            let pitch: CGFloat = 8
            let columns = Int(size.width / pitch)
            let rows = Int(size.height / pitch)
            let fillWidth = size.width * min(max(fraction, 0), 1)
            for row in 0..<rows {
                for column in 0..<columns {
                    let x = CGFloat(column) * pitch
                    let y = CGFloat(row) * pitch + 1
                    let over = (row + column + offset) % 2 == 0
                    let thread = CGRect(x: x, y: y, width: over ? 7 : 3, height: over ? 3 : 7)
                    let colour = thread.midX <= fillWidth ? accent.opacity(over ? 0.8 : 0.55) : .secondary.opacity(0.25)
                    context.fill(Path(roundedRect: thread, cornerRadius: 1.5), with: .color(colour))
                }
            }
        }
    }
}
