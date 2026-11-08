//
//  ComingUpCard.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// "Coming up": upcoming calendar events to rehearse, as large tiles in a snapping row.
struct ComingUpCard: View {
    let events: [CalendarEvent]
    var now: Date = .now
    let onShowAll: () -> Void
    let onSelect: (CalendarEvent) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button(action: onShowAll) {
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 6) {
                        Text("Coming up")
                            .textRole(.sectionHeader)
                        Image(systemName: "chevron.right")
                            .font(.title3.weight(.semibold))
                            .foregroundStyle(.secondary)
                    }
                }
                .contentShape(.rect)
            }
            .buttonStyle(.plain)
            .accessibilityAddTraits(.isHeader)
            .accessibilityHint("Shows everything coming up.")

            ScrollView(.horizontal) {
                // One container: the tiles' glass is rendered together.
                // Spacing 0, so neighbouring tiles never melt into each other.
                GlassEffectContainer(spacing: 0) {
                    LazyHStack(spacing: Spacing.grid) {
                        ForEach(events) { event in
                            Button { onSelect(event) } label: {
                                ComingUpTile(event: event, now: now)
                            }
                            .buttonStyle(.card)
                        }
                    }
                    .scrollTargetLayout()
                }
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollIndicators(.hidden)
            .scrollClipDisabled()
            // Not the screen's readable-width margins (they are inherited).
            .contentMargins(.horizontal, 0, for: .scrollContent)
        }
        .fontDesign(.rounded)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

/// One upcoming event: the day and a big time, the scenario's artwork in the
/// corner, then the event and how long rehearsing takes.
private struct ComingUpTile: View {
    let event: CalendarEvent
    let now: Date

    @ScaledMetric(relativeTo: .title3) private var side: CGFloat = 196

    /// The gap between the artwork and the tile's corner.
    private static let artworkInset: CGFloat = 16

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(verbatim: ComingUp.day(of: event, now: now))
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.accent)
            Text(event.start, format: .dateTime.hour().minute())
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .monospacedDigit()
            Spacer(minLength: 8)
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(verbatim: event.title)
                        .font(.title3.weight(.semibold))
                        .lineLimit(2)
                        .minimumScaleFactor(0.8)
                    Text("Rehearse \(event.rehearsalMinutes) min")
                        .font(.default)
                        .foregroundStyle(.secondary)
                }
                Spacer(minLength: 4)
            }
        }
        .padding(18)
        .overlay(alignment: .topTrailing) {
            ScenarioArtwork(systemImage: event.systemImage, symbolSize: 26, cornerRadius: 12,
                            topTrailingRadius: Radius.hero - Self.artworkInset)
                .frame(width: 46, height: 46)
                .padding(Self.artworkInset)
        }
        .focusSurface(side: side)
        .multilineTextAlignment(.leading)
        .fontDesign(.rounded)
        .accessibilityElement(children: .combine)
        .accessibilityHint("Rehearse this conversation.")
    }
}

private extension View {
    /// The Focus card's surface: dark, with a thin light edge.
    func focusSurface(side: CGFloat) -> some View {
        frame(width: side, height: side, alignment: .topLeading)
            .background {
                RoundedRectangle(cornerRadius: Radius.hero, style: .continuous)
                    .fill(.surface)
                    .overlay {
                        RoundedRectangle(cornerRadius: Radius.hero, style: .continuous)
                            .strokeBorder(.white.opacity(0.06), lineWidth: 1)
                    }
            }
            .clipShape(.rect(cornerRadius: Radius.hero, style: .continuous))
    }
}

/// Labels for Coming up tiles, kept free of views so they can be tested.
enum ComingUp {
    static func isTomorrow(_ event: CalendarEvent, now: Date, calendar: Calendar = .current) -> Bool {
        guard let tomorrow = calendar.date(byAdding: .day, value: 1, to: now) else { return false }
        return calendar.isDate(event.start, inSameDayAs: tomorrow)
    }

    /// Events grouped by the day they start on, earliest first.
    static func days(_ events: [CalendarEvent], calendar: Calendar = .current) -> [(day: Date, events: [CalendarEvent])] {
        Dictionary(grouping: events.sorted { $0.start < $1.start }) { calendar.startOfDay(for: $0.start) }
            .map { (day: $0.key, events: $0.value) }
            .sorted { $0.day < $1.day }
    }

    /// "Tomorrow", or the weekday: "Friday".
    static func day(of event: CalendarEvent, now: Date, calendar: Calendar = .current) -> String {
        isTomorrow(event, now: now, calendar: calendar)
            ? String(localized: "Tomorrow")
            : event.start.formatted(.dateTime.weekday(.wide))
    }
}

#Preview {
    ComingUpCard(events: [
        CalendarEvent(id: "a", title: "Dentist", start: .now.addingTimeInterval(86_400),
                      systemImage: "cross.case", scenario: .dentist, rehearsalMinutes: 5),
        CalendarEvent(id: "b", title: "Train to Munich", start: .now.addingTimeInterval(4 * 86_400),
                      systemImage: "tram", scenario: .station)
    ], onShowAll: {}, onSelect: { _ in })
        .padding(Spacing.screen)
        .background(.screenBackground)
}
