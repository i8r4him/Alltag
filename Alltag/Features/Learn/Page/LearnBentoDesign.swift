//
//  LearnBentoDesign.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Page design 10, "Bento": everything at once in one grid of glass tiles of
/// different sizes, like a bento box: the next step large, today's ring and
/// the minutes left small, then the parts, wide or square.
struct LearnBentoDesign: View {
    let content: LearnPageContent

    var body: some View {
        GlassEffectContainer(spacing: 0) {
            Grid(horizontalSpacing: Spacing.grid, verticalSpacing: Spacing.grid) {
                if !content.steps.isEmpty {
                    GridRow {
                        NextTile(content: content)
                            .gridCellColumns(2)
                    }
                    GridRow {
                        todayTile
                        minutesTile
                    }
                }
                GridRow {
                    partTile(.grammar, isWide: true)
                        .gridCellColumns(2)
                }
                GridRow {
                    partTile(.read, isWide: false)
                    partTile(.write, isWide: false)
                }
                GridRow {
                    partTile(.words, isWide: true)
                        .gridCellColumns(2)
                }
            }
        }
    }

    /// Today's steps as a ring, with the count inside and the steps' dots under it.
    private var todayTile: some View {
        VStack(spacing: 10) {
            ZStack {
                LevelRing(fraction: Double(content.doneCount) / Double(max(content.steps.count, 1)), lineWidth: 8)
                Text(verbatim: "\(content.doneCount)/\(content.steps.count)")
                    .font(.system(.title3, design: .rounded, weight: .heavy))
                    .monospacedDigit()
            }
            .frame(width: 78, height: 78)
            HStack(spacing: 4) {
                ForEach(content.steps) { step in
                    Button { content.open(step.target) } label: {
                        LessonStepDot(step: step, isCurrent: step.id == content.current?.id, size: 24)
                    }
                    .buttonStyle(.tile)
                    .accessibilityLabel(step.title.text)
                }
            }
        }
        .frame(maxWidth: .infinity, minHeight: 150)
        .glassEffect(.regular, in: .rect(cornerRadius: 30, style: .continuous))
    }

    /// The minutes still to go, large.
    private var minutesTile: some View {
        VStack(alignment: .leading, spacing: 2) {
            Image(systemName: "timer")
                .font(.title3.weight(.semibold))
                .foregroundStyle(.accent)
            Spacer(minLength: 0)
            Text(verbatim: "\(DailyLesson.minutesLeft(in: content.steps))")
                .font(.system(size: 52, weight: .heavy, design: .rounded))
                .monospacedDigit()
                .contentTransition(.numericText())
            Text("min to go")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
        }
        .padding(18)
        .frame(maxWidth: .infinity, minHeight: 150, alignment: .topLeading)
        .glassEffect(.regular, in: .rect(cornerRadius: 30, style: .continuous))
        .accessibilityElement(children: .combine)
    }

    @ViewBuilder
    private func partTile(_ kind: LearnPart, isWide: Bool) -> some View {
        if let part = content.overview.part(kind) {
            BentoPartTile(part: part, isWide: isWide) { content.openPart(kind) }
        }
    }
}

/// The next step, large: the part and minutes, the title, a taste, the artwork and Start.
private struct NextTile: View {
    let content: LearnPageContent

    var body: some View {
        let step = content.current ?? content.steps.last
        VStack(alignment: .leading, spacing: 14) {
            if let step {
                HStack(alignment: .top, spacing: 14) {
                    VStack(alignment: .leading, spacing: 6) {
                        Group {
                            if content.current == nil {
                                Label("Done for today", systemImage: "checkmark.circle.fill")
                            } else {
                                Text("Next for you · \(step.minutes) min")
                            }
                        }
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.accent)
                        step.title.text
                            .font(.title2.weight(.heavy))
                            .fixedSize(horizontal: false, vertical: true)
                        if let preview = step.preview {
                            Text(verbatim: preview)
                                .font(.subheadline)
                                .foregroundStyle(.secondary)
                                .lineLimit(2)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    ScenarioArtwork(systemImage: step.systemImage, symbolSize: 40, cornerRadius: 22)
                        .frame(width: 84, height: 84)
                }
                if content.current != nil {
                    Button { content.open(step.target) } label: {
                        Label("Start", systemImage: "play.fill")
                    }
                    .buttonStyle(.primary)
                    .matchedTransitionSource(id: step.target, in: content.zoom)
                }
            }
        }
        .padding(Spacing.cardLarge)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }
}

/// A part as a tile: wide with its artwork beside its name and a bar, or square with the ring on top.
private struct BentoPartTile: View {
    let part: LearnOverview.Part
    let isWide: Bool
    let onOpen: () -> Void

    var body: some View {
        Button(action: onOpen) {
            Group {
                if isWide {
                    HStack(spacing: 14) {
                        ScenarioArtwork(systemImage: part.kind.systemImage, symbolSize: 26, cornerRadius: 16)
                            .frame(width: 56, height: 56)
                        VStack(alignment: .leading, spacing: 4) {
                            title
                            PartBar(fraction: part.shownFraction)
                                .padding(.top, 4)
                        }
                    }
                } else {
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(alignment: .top) {
                            Image(systemName: part.kind.systemImage)
                                .font(.title2)
                                .foregroundStyle(.accent)
                            Spacer()
                            LevelRing(fraction: part.shownFraction, lineWidth: 5)
                                .frame(width: 34, height: 34)
                        }
                        Spacer(minLength: 0)
                        title
                    }
                    .frame(minHeight: 120)
                }
            }
            .padding(18)
            .frame(maxWidth: .infinity, alignment: .leading)
            .glassEffect(.regular.interactive(), in: .rect(cornerRadius: 30, style: .continuous))
            .contentShape(.rect(cornerRadius: 30, style: .continuous))
        }
        .buttonStyle(.card)
        .accessibilityElement(children: .combine)
    }

    private var title: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(part.kind.title)
                .font(.title3.weight(.heavy))
            PartProgressText(part: part)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
    }
}
