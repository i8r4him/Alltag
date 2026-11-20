//
//  LearnBrowseDesign.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// "Heute & mehr" gives the lesson and the skill catalogue their own views under one native picker.
struct LearnBrowseDesign: View {
    let content: LearnPageContent

    @State private var section: Section = .today
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize

    private enum Section: Hashable {
        case today, skills
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            if content.steps.isEmpty {
                skills
            } else {
                Picker("Learn", selection: $section) {
                    Text("Today").tag(Section.today)
                    Text("Skills").tag(Section.skills)
                }
                .pickerStyle(.segmented)
                .sensoryFeedback(.selection, trigger: section)

                switch section {
                case .today: lesson
                case .skills: skills
                }
            }
        }
    }

    private var lesson: some View {
        VStack(alignment: .leading, spacing: 12) {
            LearnSectionTitle(title: Text("Today's lesson"), note: content.lessonNote)
            LearnDailyStepRows(steps: content.steps, content: content)
                .glassEffect(.regular, in: .rect(cornerRadius: Radius.option, style: .continuous))
            if let next = content.current {
                LessonStartButton(step: next, isFirst: content.doneCount == 0) { content.open($0.target) }
            }
        }
    }

    private var skills: some View {
        let columns = [GridItem(dynamicTypeSize.isAccessibilitySize ? .flexible() : .adaptive(minimum: 144),
                                spacing: Spacing.grid)]
        return GlassEffectContainer(spacing: Spacing.grid) {
            LazyVGrid(columns: columns, spacing: Spacing.grid) {
                ForEach(content.overview.doors) { part in
                    skill(part)
                }
            }
        }
    }

    private func skill(_ part: LearnOverview.Part) -> some View {
        Button { content.openPart(part.kind) } label: {
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Image(systemName: part.kind.systemImage)
                        .font(.title2)
                        .foregroundStyle(.accent)
                    Spacer(minLength: 0)
                    Image(systemName: "chevron.right")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.tertiary)
                }
                .accessibilityHidden(true)

                Text(part.kind.title).font(.headline)
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
