//
//  LearnTimeDesign.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// "Nach Zeit" brings exercises that fit the available minutes to the top of today's lesson.
struct LearnTimeDesign: View {
    let content: LearnPageContent

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.section) {
            if !content.steps.isEmpty {
                TimeLesson(content: content)
            }
            LearnDailyPartRows(content: content)
        }
    }
}

private struct TimeLesson: View {
    let content: LearnPageContent

    @State private var availableMinutes = 4

    var body: some View {
        let pending = content.steps.filter { !$0.isDone }
        let fitting = pending.filter { $0.minutes <= availableMinutes }
        let longer = pending.filter { $0.minutes > availableMinutes }
        let completed = content.steps.filter(\.isDone)

        VStack(alignment: .leading, spacing: 12) {
            LearnSectionTitle(title: Text("Today's lesson"), note: content.lessonNote)
            if !pending.isEmpty {
                timePicker
                if fitting.isEmpty {
                    Text("No exercises fit this time")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 4)
                } else {
                    group(Text("Fits your time"), steps: fitting)
                }
                if !longer.isEmpty {
                    group(Text("Longer exercises"), steps: longer)
                }
            }
            if !completed.isEmpty {
                group(Text("Done today"), steps: completed)
            }
        }
    }

    private var timePicker: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Time available")
                .font(.subheadline.weight(.semibold))
                .padding(.horizontal, 4)
                .accessibilityHidden(true)
            Picker("Time available", selection: $availableMinutes) {
                ForEach([2, 4, 6], id: \.self) { minutes in
                    Text("\(minutes) min").tag(minutes)
                }
            }
            .pickerStyle(.segmented)
            .sensoryFeedback(.selection, trigger: availableMinutes)
        }
    }

    private func group(_ title: Text, steps: [LessonStep]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            title
                .font(.subheadline.weight(.semibold))
                .padding(.horizontal, 4)
                .accessibilityAddTraits(.isHeader)
            LearnDailyStepRows(steps: steps, content: content)
                .glassEffect(.regular, in: .rect(cornerRadius: Radius.option, style: .continuous))
            if let next = content.current, steps.contains(where: { $0.id == next.id }) {
                LessonStartButton(step: next, isFirst: content.doneCount == 0, showsMinutes: true) {
                    content.open($0.target)
                }
            }
        }
    }
}
