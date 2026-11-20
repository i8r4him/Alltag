//
//  LearnDailyPageRows.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

struct LearnDailyStepRows: View {
    let steps: [LessonStep]
    let content: LearnPageContent

    var body: some View {
        VStack(spacing: 0) {
            ForEach(Array(steps.enumerated()), id: \.element.id) { index, step in
                if index > 0 { Divider().padding(.leading, 56) }
                LearnDailyStepLink(step: step, content: content)
            }
        }
    }
}

struct LearnDailyStepLink: View {
    let step: LessonStep
    let content: LearnPageContent
    var showsPart = true

    private var isNext: Bool { step.id == content.current?.id }

    var body: some View {
        Button { content.open(step.target) } label: {
            HStack(spacing: 8) {
                LessonStepDot(step: step, isCurrent: isNext, size: 32)
                VStack(alignment: .leading, spacing: 4) {
                    if showsPart {
                        Text(step.part.name)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    step.title.text.font(.subheadline.weight(.semibold))
                    content.stepDetail(step)
                        .font(.footnote)
                        .foregroundStyle(isNext ? Color.accent : Color.secondary)
                }
                Spacer(minLength: 4)
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.tertiary)
                    .accessibilityHidden(true)
            }
            .padding(.horizontal, Spacing.card)
            .padding(.vertical, 8)
            .frame(minHeight: Spacing.minTouchTarget)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .matchedTransitionSource(id: step.target, in: content.zoom)
        .accessibilityElement(children: .combine)
    }
}

extension LearnPageContent {
    func stepDetail(_ step: LessonStep) -> Text {
        if step.isDone { return Text("Done") }
        if step.id == current?.id { return Text("Next · \(step.minutes) min") }
        return Text("\(step.minutes) min")
    }
}

struct LearnDailyPartRows: View {
    let content: LearnPageContent

    var body: some View {
        VStack(spacing: 12) {
            LearnSectionTitle(title: Text("All of Learn"))
            VStack(spacing: 0) {
                ForEach(Array(content.overview.doors.enumerated()), id: \.element.id) { index, part in
                    if index > 0 { Divider().padding(.leading, 56) }
                    LearnDailyPartLink(part: part) { content.openPart(part.kind) }
                }
            }
            .glassEffect(.regular, in: .rect(cornerRadius: Radius.option, style: .continuous))
        }
    }
}

struct LearnDailyPartLink: View {
    let part: LearnOverview.Part
    var showsBar = false
    let onOpen: () -> Void

    var body: some View {
        Button(action: onOpen) {
            HStack(spacing: 8) {
                Image(systemName: part.kind.systemImage)
                    .foregroundStyle(.accent)
                    .frame(width: 32, height: 32)
                    .background(.controlFill, in: .circle)
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 4) {
                    Text(part.kind.title).font(.headline)
                    PartProgressText(part: part)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                    if showsBar, let fraction = part.fraction {
                        PartBar(fraction: fraction)
                    }
                }
                Spacer(minLength: 4)
                Image(systemName: "chevron.right")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.tertiary)
                    .accessibilityHidden(true)
            }
            .padding(.horizontal, Spacing.card)
            .padding(.vertical, 12)
            .frame(minHeight: Spacing.minTouchTarget)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
    }
}
