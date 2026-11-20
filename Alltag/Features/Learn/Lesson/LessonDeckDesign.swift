//
//  LessonDeckDesign.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Lesson design 5, "Cards": one tall glass card per part, side by side, swiped like
/// a story. Each card shows a taste of the real thing (the rule's line, the
/// text's first line, the friend's last message, the first words); the row
/// opens on the next step and moves on by itself once one is done.
struct LessonDeckDesign: View {
    let steps: [LessonStep]
    let zoom: Namespace.ID
    let onOpen: (LessonStep) -> Void

    @State private var position: LessonPart?

    var body: some View {
        let current = DailyLesson.current(in: steps)
        VStack(spacing: 14) {
            ScrollView(.horizontal) {
                GlassEffectContainer(spacing: 0) {
                    HStack(alignment: .top, spacing: Spacing.grid) {
                        ForEach(Array(steps.enumerated()), id: \.element.id) { index, step in
                            DeckCard(step: step, number: index + 1, count: steps.count,
                                     isCurrent: step.id == current?.id, onOpen: onOpen)
                                .containerRelativeFrame(.horizontal) { width, _ in width * 0.84 }
                                .matchedTransitionSource(id: step.target, in: zoom)
                                .id(step.id)
                        }
                    }
                    .fixedSize(horizontal: false, vertical: true)
                    .scrollTargetLayout()
                }
            }
            .scrollPosition(id: $position, anchor: .center)
            .scrollTargetBehavior(.viewAligned)
            .scrollIndicators(.hidden)
            .scrollEdgeEffectStyle(.soft, for: .all)
            .scrollClipDisabled()
            .contentMargins(.horizontal, Spacing.screen, for: .scrollContent)
            .padding(.horizontal, -Spacing.screen)
            ProgressSegments(total: steps.count, completed: steps.filter(\.isDone).count, height: 4)
                .padding(.horizontal, 40)
        }
        .onAppear { position = current?.id ?? steps.last?.id }
        .onChange(of: current?.id) { _, next in
            withAnimation(.smooth) { position = next ?? steps.last?.id }
        }
    }
}

/// One part of the lesson as a card: the part and its place, the artwork, the
/// step, a taste of it, and Start (or a tick once it's done).
private struct DeckCard: View {
    let step: LessonStep
    let number: Int
    let count: Int
    let isCurrent: Bool
    let onOpen: (LessonStep) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .firstTextBaseline) {
                Text(step.part.name)
                    .foregroundStyle(.accent)
                Spacer()
                Text(verbatim: "\(number) / \(count)")
                    .foregroundStyle(.secondary)
                    .monospacedDigit()
            }
            .font(.subheadline.weight(.semibold))
            ScenarioArtwork(systemImage: step.systemImage, symbolSize: 34, cornerRadius: 16)
                .frame(width: 64, height: 64)
                .padding(.top, 16)
            step.title.text
                .font(.title2.weight(.bold))
                .lineLimit(3)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 12)
            if let preview = step.preview {
                Text(verbatim: preview)
                    .font(.callout)
                    .foregroundStyle(.secondary)
                    .lineLimit(3)
                    .padding(12)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.controlFill, in: .rect(cornerRadius: Radius.tile, style: .continuous))
                    .padding(.top, 12)
            }
            Spacer(minLength: 18)
            footer
        }
        .padding(Spacing.cardLarge)
        .frame(maxHeight: .infinity, alignment: .top)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
        .opacity(step.isDone && !isCurrent ? 0.8 : 1)
    }

    @ViewBuilder private var footer: some View {
        if step.isDone {
            HStack {
                Label("Done", systemImage: "checkmark.circle.fill")
                    .foregroundStyle(.accent)
                Spacer()
                Button("Do it again") { onOpen(step) }
                    .foregroundStyle(.secondary)
            }
            .font(.subheadline.weight(.semibold))
            .buttonStyle(.plain)
            .frame(minHeight: Spacing.minTouchTarget)
        } else {
            Button { onOpen(step) } label: {
                Label("Start · \(step.minutes) min", systemImage: "play.fill")
            }
            .buttonStyle(.primaryCompact)
        }
    }
}
