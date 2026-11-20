//
//  LearnResumeDesign.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// "Weiterlernen" puts the next exercise first and keeps the full plan one tap away.
struct LearnResumeDesign: View {
    let content: LearnPageContent

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.section) {
            if !content.steps.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    LearnSectionTitle(title: Text("Today's lesson"), note: content.lessonNote)
                    if let next = content.current {
                        NextForYouCard(step: next) { content.open(next.target) }
                            .matchedTransitionSource(id: next.target, in: content.zoom)
                    }
                    let otherSteps = content.steps.filter { $0.id != content.current?.id }
                    if !otherSteps.isEmpty {
                        ResumeLessonDetails(steps: otherSteps, content: content)
                    }
                }
            }
            LearnDailyPartRows(content: content)
        }
    }
}

private struct ResumeLessonDetails: View {
    let steps: [LessonStep]
    let content: LearnPageContent

    @State private var isExpanded = false

    var body: some View {
        DisclosureGroup(isExpanded: $isExpanded) {
            LearnDailyStepRows(steps: steps, content: content)
                .padding(.top, 8)
        } label: {
            VStack(alignment: .leading, spacing: 4) {
                Text("Lesson steps").font(.headline)
                Text("\(content.doneCount) of \(content.steps.count) done")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
            .frame(minHeight: Spacing.minTouchTarget, alignment: .leading)
        }
        .tint(.accent)
        .padding(.horizontal, Spacing.card)
        .padding(.vertical, 8)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.option, style: .continuous))
    }
}
