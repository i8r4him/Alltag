//
//  LearnPlanDesign.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// "Tagesplan" shows the whole lesson in order, with enough detail to know what each exercise involves.
struct LearnPlanDesign: View {
    let content: LearnPageContent

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.section) {
            if !content.steps.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    LearnSectionTitle(title: Text("Today's lesson"), note: content.lessonNote)
                    ProgressView(value: Double(content.doneCount), total: Double(content.steps.count)) {
                        Text("\(content.doneCount) of \(content.steps.count) done")
                            .font(.subheadline.weight(.medium))
                    }
                    .tint(.accentFill)
                    .padding(.horizontal, 4)
                    if let next = content.current {
                        LessonStartButton(step: next, isFirst: content.doneCount == 0) { content.open($0.target) }
                    }
                    GlassEffectContainer(spacing: 12) {
                        VStack(spacing: 12) {
                            ForEach(content.steps) { step in
                                plannedStep(step)
                            }
                        }
                    }
                }
            }
            LearnDailyPartRows(content: content)
        }
    }

    private func plannedStep(_ step: LessonStep) -> some View {
        let isNext = step.id == content.current?.id
        return Button { content.open(step.target) } label: {
            HStack(alignment: .top, spacing: 12) {
                LessonStepDot(step: step, isCurrent: isNext, size: 36)
                VStack(alignment: .leading, spacing: 4) {
                    Text(step.part.name)
                        .font(.footnote.weight(.medium))
                        .foregroundStyle(.secondary)
                    step.title.text.font(.headline)
                    if let preview = step.preview, !step.isDone {
                        Text(verbatim: preview)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }
                    content.stepDetail(step)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(isNext ? Color.accent : Color.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.tertiary)
                    .padding(.top, 4)
                    .accessibilityHidden(true)
            }
            .padding(Spacing.card)
            .glassEffect(.regular.interactive(), in: .rect(cornerRadius: Radius.option, style: .continuous))
        }
        .buttonStyle(.plain)
        .matchedTransitionSource(id: step.target, in: content.zoom)
        .accessibilityElement(children: .combine)
    }
}
