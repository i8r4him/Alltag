//
//  PlaceSheet.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// What's in a place of the level map: what's done, what's left and what's
/// next. Each row opens its rule or situation.
struct PlaceSheet: View {
    let place: TownPlace
    /// `nil` for the station.
    let progress: PlaceProgress?
    let nextLevel: Level?
    let onOpen: (MapStop) -> Void

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                header
                content
            }
            .padding(Spacing.cardLarge)
            .padding(.top, 8)
        }
        .scrollIndicators(.hidden)
        .scrollEdgeEffectStyle(.soft, for: .all)
        .fontDesign(.rounded)
        .presentationDetents([.medium, .large])
    }

    private var header: some View {
        HStack(spacing: 14) {
            PlaceDisc(place: place, fraction: progress.flatMap { $0.isOpen ? $0.fraction : nil },
                      isDim: !(progress?.isOpen ?? false), size: 64)
            VStack(alignment: .leading, spacing: 2) {
                Text(place.name)
                    .font(.title.weight(.bold))
                subtitle
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
        }
        .accessibilityElement(children: .combine)
    }

    @ViewBuilder
    private var subtitle: some View {
        if let progress, progress.isOpen {
            Text("\(Text(place.subject)) · \(progress.doneCount) of \(progress.totalCount)")
        } else {
            Text(place.subject)
        }
    }

    @ViewBuilder
    private var content: some View {
        if let progress, let stops = progress.stops {
            VStack(spacing: 0) {
                ForEach(stops) { stop in
                    if stop.id != stops.first?.id {
                        Divider().padding(.leading, 40)
                    }
                    StopRow(stop: stop, isNext: stop.id == progress.nextStop?.id) { onOpen(stop) }
                }
            }
            .padding(.horizontal, Spacing.card)
            .padding(.vertical, 4)
            .glassEffect(.regular, in: .rect(cornerRadius: Radius.innerCard, style: .continuous))
        } else if progress != nil {
            Text("This place fills up once its texts and tasks are ready. Until then, it doesn't count towards your level.")
                .font(.body)
                .foregroundStyle(.secondary)
        } else if let nextLevel {
            Text("The \(nextLevel.title) test opens when every place in town is full. Pass it, and you're \(nextLevel.title).")
                .font(.body)
                .foregroundStyle(.secondary)
        } else {
            Text("You're at the top level. There's no test left to take.")
                .font(.body)
                .foregroundStyle(.secondary)
        }
    }
}

/// One stop: a tick when done, "Next" on the next one.
private struct StopRow: View {
    let stop: MapStop
    let isNext: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                Image(systemName: stop.isDone ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundStyle(stop.isDone ? AnyShapeStyle(.accentFill) : AnyShapeStyle(.tertiary))
                VStack(alignment: .leading, spacing: 1) {
                    Text(stop.title)
                        .font(.body.weight(.semibold))
                        .foregroundStyle(stop.isDone ? .secondary : .primary)
                    if isNext {
                        Text("Next")
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.accent)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.tertiary)
            }
            .frame(minHeight: Spacing.rowMinHeight)
            .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .accessibilityValue(stop.isDone ? Text("Done") : Text(verbatim: ""))
    }
}
