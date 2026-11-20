//
//  LearnGreenhouseDesign.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// In "Gewächshaus", a seed becomes a sprout when it is next and blooms once done.
struct LearnGreenhouseDesign: View {
    let content: LearnPageContent

    private let beds = [GridItem(.adaptive(minimum: 136), spacing: Spacing.grid)]

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.section) {
            if !content.steps.isEmpty {
                greenhouse
            }

            VStack(alignment: .leading, spacing: 12) {
                LearnSectionTitle(title: Text(verbatim: "Beete"))
                GlassEffectContainer(spacing: Spacing.grid) {
                    LazyVGrid(columns: beds, spacing: Spacing.grid) {
                        ForEach(content.overview.doors) { part in
                            bed(part)
                        }
                    }
                }
            }
        }
    }

    private var greenhouse: some View {
        VStack(alignment: .leading, spacing: 12) {
            LearnSectionTitle(title: Text("Today's lesson"), note: content.lessonNote)
            VStack(spacing: 16) {
                Image(systemName: "sun.max")
                    .font(.title2)
                    .foregroundStyle(.accent)
                    .accessibilityHidden(true)
                LazyVGrid(columns: beds, alignment: .leading, spacing: 16) {
                    ForEach(content.steps) { step in
                        seedling(step)
                    }
                }
                if let next = content.current {
                    LessonStartButton(step: next, isFirst: content.doneCount == 0) { content.open($0.target) }
                }
            }
            .padding(.horizontal, Spacing.card)
            .padding(.top, 32)
            .padding(.bottom, Spacing.card)
            .glassEffect(.regular, in: GreenhouseFront())
        }
    }

    private func seedling(_ step: LessonStep) -> some View {
        let isNext = content.current?.id == step.id
        let plant = step.isDone ? "camera.macro" : isNext ? "leaf.fill" : "circle.fill"
        return Button { content.open(step.target) } label: {
            VStack(spacing: 4) {
                Image(systemName: plant)
                    .font(step.isDone || isNext ? .largeTitle : .caption2)
                    .foregroundStyle(step.isDone || isNext ? Color.accent : Color.secondary)
                    .frame(height: 40, alignment: .bottom)
                    .accessibilityHidden(true)
                UnevenRoundedRectangle(bottomLeadingRadius: 8, bottomTrailingRadius: 8)
                    .fill(isNext ? AnyShapeStyle(.accentFill) : AnyShapeStyle(.controlFill))
                    .frame(width: 32, height: 12)
                    .accessibilityHidden(true)
                step.title.text
                    .font(.subheadline.weight(.semibold))
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                if step.isDone || isNext {
                    content.status(of: step)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.accent)
                }
            }
            .padding(.vertical, 4)
            .frame(maxWidth: .infinity)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .matchedTransitionSource(id: step.target, in: content.zoom)
        .accessibilityElement(children: .combine)
    }

    private func bed(_ part: LearnOverview.Part) -> some View {
        Button { content.openPart(part.kind) } label: {
            VStack(alignment: .leading, spacing: 8) {
                Label { Text(part.kind.title) } icon: {
                    Image(systemName: part.kind.systemImage)
                        .foregroundStyle(.accent)
                }
                .font(.headline)
                PartProgressText(part: part)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                if let fraction = part.fraction {
                    PartBar(fraction: fraction)
                }
            }
            .padding(Spacing.card)
            .frame(maxWidth: .infinity, alignment: .leading)
            .glassEffect(.regular.interactive(), in: .rect(cornerRadius: Radius.option, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
    }
}

private struct GreenhouseFront: Shape {
    func path(in rect: CGRect) -> Path {
        let eave = rect.minY + 40
        return Path { path in
            path.move(to: CGPoint(x: rect.minX, y: eave))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: eave))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - 20))
            path.addQuadCurve(to: CGPoint(x: rect.maxX - 20, y: rect.maxY),
                              control: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX + 20, y: rect.maxY))
            path.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.maxY - 20),
                              control: CGPoint(x: rect.minX, y: rect.maxY))
            path.closeSubpath()
        }
    }
}
