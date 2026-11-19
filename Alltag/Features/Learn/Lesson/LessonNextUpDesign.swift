//
//  LessonNextUpDesign.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Design 3, "Next up": the card is about the step to do now, like Today's
/// Focus card: which step of the lesson it is, its real title and a taste of
/// it, its artwork, then a bar with one piece per part and the big button.
struct LessonNextUpDesign: View {
    let steps: [LessonStep]
    let zoom: Namespace.ID
    let onOpen: (LessonStep) -> Void

    @ScaledMetric(relativeTo: .title3) private var artworkSize: CGFloat = 96

    var body: some View {
        let current = DailyLesson.current(in: steps)
        VStack(spacing: 18) {
            HStack(alignment: .center, spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    if let current {
                        let number = (steps.firstIndex { $0.id == current.id } ?? 0) + 1
                        Text("Step \(number) of \(steps.count) · \(Text(current.part.name))")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.accent)
                        current.title.text
                            .font(.title2.weight(.bold))
                            .fixedSize(horizontal: false, vertical: true)
                        if let preview = current.preview {
                            Text(verbatim: preview)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                        }
                    } else {
                        Label("Done today", systemImage: "checkmark.circle.fill")
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(.accent)
                        Text("Done for today")
                            .font(.title2.weight(.bold))
                        Text("A new lesson is ready tomorrow.")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityElement(children: .combine)
                ScenarioArtwork(systemImage: current?.systemImage ?? "checkmark.seal.fill")
                    .frame(width: artworkSize, height: artworkSize)
            }
            partsBar(current: current)
            if let current {
                LessonStartButton(step: current, isFirst: false, showsMinutes: true, onOpen: onOpen)
            }
        }
        .padding(Spacing.cardLarge)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
        .animation(.smooth, value: current?.id)
    }

    /// One piece of bar per part with its symbol under it; a tap opens that part.
    private func partsBar(current: LessonStep?) -> some View {
        HStack(alignment: .top, spacing: 6) {
            ForEach(steps) { step in
                let isCurrent = step.id == current?.id
                Button { onOpen(step) } label: {
                    VStack(spacing: 8) {
                        Capsule()
                            .fill(step.isDone ? AnyShapeStyle(.accentFill)
                                              : AnyShapeStyle(isCurrent ? Color.accentFill.opacity(0.4) : Color.controlFill))
                            .frame(height: 6)
                        Image(systemName: step.isDone ? "checkmark" : step.part.systemImage)
                            .font(.caption.weight(.bold))
                            .foregroundStyle(step.isDone || isCurrent ? AnyShapeStyle(.accent) : AnyShapeStyle(.tertiary))
                    }
                    .frame(maxWidth: .infinity, minHeight: Spacing.minTouchTarget, alignment: .top)
                    .contentShape(.rect)
                }
                .buttonStyle(.tile)
                .matchedTransitionSource(id: step.target, in: zoom)
                .accessibilityLabel(Text(step.part.name))
                .accessibilityValue(step.isDone ? Text("Done") : Text(verbatim: ""))
            }
        }
    }
}
