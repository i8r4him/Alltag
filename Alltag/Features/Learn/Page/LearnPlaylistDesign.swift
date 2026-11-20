//
//  LearnPlaylistDesign.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Page design 7, "Playlist": today's lesson is a mix made for the learner,
/// like a music app's: a cover, a big play button and the steps as tracks
/// with their length, the one playing now marked. The parts of Learn are
/// albums in a grid.
struct LearnPlaylistDesign: View {
    let content: LearnPageContent

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.section) {
            if !content.steps.isEmpty {
                VStack(spacing: 0) {
                    header
                        .padding(Spacing.cardLarge)
                    ForEach(Array(content.steps.enumerated()), id: \.element.id) { index, step in
                        Divider()
                            .padding(.leading, 60)
                        Button { content.open(step.target) } label: { track(step, number: index + 1) }
                            .buttonStyle(.plain)
                            .matchedTransitionSource(id: step.target, in: content.zoom)
                            .accessibilityElement(children: .combine)
                            .accessibilityValue(step.isDone ? Text("Done") : Text(verbatim: ""))
                    }
                }
                .padding(.bottom, 8)
                .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
            }
            VStack(alignment: .leading, spacing: 12) {
                LearnSectionTitle(title: Text("Your albums"))
                GlassEffectContainer(spacing: 0) {
                    LazyVGrid(columns: [GridItem(.flexible(), spacing: Spacing.grid),
                                        GridItem(.flexible(), spacing: Spacing.grid)],
                              spacing: Spacing.grid) {
                        ForEach(content.overview.doors) { part in
                            Album(part: part) { content.openPart(part.kind) }
                        }
                    }
                }
            }
        }
    }

    /// The cover, the mix's name and length, and the play button.
    private var header: some View {
        HStack(alignment: .center, spacing: 16) {
            ScenarioArtwork(systemImage: "music.note.list", symbolSize: 44, cornerRadius: 18)
                .frame(width: 104, height: 104)
                .shadow(color: Color.accentFill.opacity(0.4), radius: 16)
            VStack(alignment: .leading, spacing: 4) {
                Text(verbatim: "Dein Mix für heute")
                    .font(.title3.weight(.heavy))
                Text("^[\(content.steps.count) track](inflect: true) · \(content.totalMinutes) min")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
                if let current = content.current {
                    Button { content.open(current.target) } label: {
                        Image(systemName: "play.fill")
                            .font(.title2)
                            .foregroundStyle(.onAccent)
                            .frame(width: 56, height: 56)
                            .background(.accentFill, in: .circle)
                            .shadow(color: Color.accentFill.opacity(0.5), radius: 12)
                    }
                    .buttonStyle(.tile)
                    .padding(.top, 6)
                    .accessibilityLabel(Text("Start"))
                } else {
                    Label("Done for today", systemImage: "checkmark.circle.fill")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.accent)
                        .padding(.top, 6)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }

    /// A step as a track: its number (a sound wave while it is next, a tick once done), title, part and length.
    private func track(_ step: LessonStep, number: Int) -> some View {
        let isCurrent = step.id == content.current?.id
        return HStack(spacing: 14) {
            Group {
                if step.isDone {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.accent)
                } else if isCurrent {
                    Image(systemName: "waveform")
                        .foregroundStyle(.accent)
                        .symbolEffect(.variableColor.iterative, options: .repeating)
                } else {
                    Text(verbatim: "\(number)")
                        .foregroundStyle(.secondary)
                }
            }
            .font(.headline)
            .frame(width: 30)
            VStack(alignment: .leading, spacing: 2) {
                step.title.text
                    .font(.headline)
                    .foregroundStyle(isCurrent ? AnyShapeStyle(.accent) : AnyShapeStyle(.primary))
                    .lineLimit(1)
                Text(step.part.name)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Text(verbatim: "\(step.minutes):00")
                .font(.subheadline.weight(.semibold))
                .monospacedDigit()
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .opacity(step.isDone ? 0.6 : 1)
        .contentShape(.rect)
    }
}

/// A part as an album: a square cover with its symbol, its name and its progress.
private struct Album: View {
    let part: LearnOverview.Part
    let onOpen: () -> Void

    var body: some View {
        Button(action: onOpen) {
            VStack(alignment: .leading, spacing: 8) {
                ScenarioArtwork(systemImage: part.kind.systemImage, symbolSize: 48, cornerRadius: 22)
                    .aspectRatio(1, contentMode: .fit)
                    .overlay(alignment: .bottomTrailing) {
                        if let fraction = part.fraction {
                            Text(verbatim: "\(Int((fraction * 100).rounded()))%")
                                .font(.caption.weight(.heavy))
                                .monospacedDigit()
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .glassEffect(.regular, in: .capsule)
                                .padding(10)
                        }
                    }
                Text(part.kind.title)
                    .font(.headline)
                PartProgressText(part: part)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }
            .contentShape(.rect)
        }
        .buttonStyle(.tile)
        .accessibilityElement(children: .combine)
    }
}
