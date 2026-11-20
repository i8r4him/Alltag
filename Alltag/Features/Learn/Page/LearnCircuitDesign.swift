//
//  LearnCircuitDesign.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// "Schaltkreis" wires the lesson's exercises in parallel. The signal reaches the next chip.
struct LearnCircuitDesign: View {
    let content: LearnPageContent

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.section) {
            if !content.steps.isEmpty {
                VStack(alignment: .leading, spacing: 12) {
                    LearnSectionTitle(title: Text("Today's lesson"), note: content.lessonNote)
                    circuitBoard
                }
            }
            VStack(alignment: .leading, spacing: 12) {
                LearnSectionTitle(title: Text(verbatim: "Messwerte"))
                GlassEffectContainer(spacing: Spacing.grid) {
                    VStack(spacing: 8) {
                        ForEach(content.overview.doors) { part in
                            readout(part)
                        }
                    }
                }
            }
        }
    }

    private var circuitBoard: some View {
        GlassEffectContainer(spacing: 8) {
            VStack(spacing: 12) {
                VStack(spacing: 12) {
                    ForEach(content.steps) { step in
                        chip(step)
                    }
                }
                .background { rails }
                if let next = content.current {
                    LessonStartButton(step: next, isFirst: content.doneCount == 0) { content.open($0.target) }
                        .padding(.horizontal, 12)
                }
            }
            .padding(.vertical, Spacing.card)
        }
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }

    private var rails: some View {
        HStack {
            rail
            Spacer(minLength: 0)
            rail
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }

    private var rail: some View {
        Capsule()
            .fill(.secondary.opacity(0.35))
            .frame(width: 2)
    }

    private func chip(_ step: LessonStep) -> some View {
        let isNext = step.id == content.current?.id
        return HStack(spacing: 0) {
            trace(isPowered: step.isDone || isNext)
            Button { content.open(step.target) } label: {
                HStack(spacing: 8) {
                    LessonStepDot(step: step, isCurrent: isNext, size: 28)
                    VStack(alignment: .leading, spacing: 4) {
                        step.title.text.font(.headline)
                        if step.isDone || isNext {
                            content.status(of: step)
                                .font(.caption.weight(.semibold))
                                .foregroundStyle(.accent)
                        }
                    }
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity, minHeight: Spacing.minTouchTarget, alignment: .leading)
                .glassEffect(.regular.interactive(), in: .rect(cornerRadius: Radius.tile, style: .continuous))
            }
            .buttonStyle(.plain)
            .matchedTransitionSource(id: step.target, in: content.zoom)
            .accessibilityElement(children: .combine)
            trace(isPowered: step.isDone || isNext)
                .scaleEffect(x: -1, y: 1)
        }
        .padding(.horizontal, 9)
    }

    private func trace(isPowered: Bool) -> some View {
        let colour = isPowered ? Color.accent : .secondary.opacity(0.35)
        return Capsule()
            .fill(colour)
            .frame(width: 16, height: 2)
            .overlay(alignment: .leading) {
                Circle().fill(colour).frame(width: 8, height: 8)
            }
            .accessibilityHidden(true)
    }

    private func readout(_ part: LearnOverview.Part) -> some View {
        Button { content.openPart(part.kind) } label: {
            HStack(spacing: 12) {
                Image(systemName: part.kind.systemImage)
                    .foregroundStyle(.accent)
                    .frame(width: 32)
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 4) {
                    Text(part.kind.title).font(.headline)
                    PartProgressText(part: part)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                        .monospacedDigit()
                }
                Spacer(minLength: 0)
                if let fraction = part.fraction {
                    PartBar(fraction: fraction)
                        .frame(width: 56)
                }
            }
            .padding(12)
            .glassEffect(.regular.interactive(), in: .rect(cornerRadius: Radius.option, style: .continuous))
        }
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
    }
}
