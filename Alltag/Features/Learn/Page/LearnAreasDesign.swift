//
//  LearnAreasDesign.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// "Lernbereiche" pairs each skill's progress and full catalogue with its exercise for today.
struct LearnAreasDesign: View {
    let content: LearnPageContent

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            if !content.steps.isEmpty {
                LearnSectionTitle(title: Text("Today's lesson"), note: content.lessonNote)
                if let next = content.current {
                    VStack(alignment: .leading, spacing: 8) {
                        LabeledContent {
                            next.title.text
                                .multilineTextAlignment(.trailing)
                        } label: {
                            Text("Next")
                        }
                        .padding(.horizontal, 4)
                        LessonStartButton(step: next, isFirst: content.doneCount == 0, showsMinutes: true) {
                            content.open($0.target)
                        }
                    }
                }
            } else {
                LearnSectionTitle(title: Text("Skills"))
            }
            GlassEffectContainer(spacing: Spacing.grid) {
                VStack(spacing: Spacing.grid) {
                    ForEach(content.overview.doors) { part in
                        area(part)
                    }
                    if let mistakes = content.steps.first(where: { $0.part == .mistakes }) {
                        LearnDailyStepLink(step: mistakes, content: content)
                            .glassEffect(.regular, in: .rect(cornerRadius: Radius.option, style: .continuous))
                    }
                }
            }
        }
    }

    private func area(_ part: LearnOverview.Part) -> some View {
        let exercise = content.steps.first { partKind(for: $0.part) == part.kind }
        return VStack(spacing: 0) {
            LearnDailyPartLink(part: part, showsBar: true) { content.openPart(part.kind) }
            if let exercise {
                Divider().padding(.horizontal, Spacing.card)
                LearnDailyStepLink(step: exercise, content: content, showsPart: false)
            }
        }
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.option, style: .continuous))
    }

    private func partKind(for lessonPart: LessonPart) -> LearnPart? {
        switch lessonPart {
        case .grammar: .grammar
        case .read: .read
        case .write: .write
        case .words: .words
        case .mistakes: nil
        }
    }
}
