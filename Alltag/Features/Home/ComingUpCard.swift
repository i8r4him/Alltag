//
//  ComingUpCard.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// "Coming up": upcoming calendar events to rehearse, in a snapping row of tiles.
struct ComingUpCard: View {
    let events: [CalendarEvent]
    var now: Date = .now
    let onSelect: (CalendarEvent) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .firstTextBaseline) {
                Text("Coming up")
                    .textRole(.cardTitle)
                    .accessibilityAddTraits(.isHeader)
                Spacer(minLength: 8)
                Label("Rehearse from your Calendar", systemImage: "calendar")
                    .textRole(.caption)
                    .foregroundStyle(.tertiary)
                    .lineLimit(1)
            }
            .padding(.trailing, 14)

            ScrollView(.horizontal) {
                HStack(spacing: 8) {
                    ForEach(events) { event in
                        Button { onSelect(event) } label: {
                            ComingUpTile(event: event, now: now)
                        }
                        .buttonStyle(.tile)
                    }
                }
                .scrollTargetLayout()
                .padding(.trailing, 14)
            }
            .scrollTargetBehavior(.viewAligned)
            .scrollIndicators(.hidden)
            // Not the screen's readable-width margins (they are inherited).
            .contentMargins(.horizontal, 0, for: .scrollContent)
        }
        .padding(.vertical, 14)
        .padding(.leading, 14)
        .background(.surface, in: .rect(cornerRadius: Radius.card, style: .continuous))
    }
}

private struct ComingUpTile: View {
    let event: CalendarEvent
    let now: Date

    @ScaledMetric(relativeTo: .footnote) private var width: CGFloat = 132
    @ScaledMetric(relativeTo: .footnote) private var height: CGFloat = 96

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .top) {
                Image(systemName: event.systemImage)
                    .font(.system(size: 18))
                    .foregroundStyle(.primary)
                Spacer()
                if ComingUp.isTomorrow(event, now: now) {
                    Text("Tomorrow")
                        .textRole(.caption)
                        .fontWeight(.semibold)
                        .textCase(.uppercase)
                        .foregroundStyle(.accent)
                }
            }
            Spacer(minLength: 8)
            Text(verbatim: event.title)
                .textRole(.bodySmall)
                .fontWeight(.semibold)
                .lineLimit(2)
            Text(ComingUp.detail(for: event, now: now))
                .textRole(.caption)
                .foregroundStyle(.secondary)
                .lineLimit(2)
                .padding(.top, 2)
        }
        .multilineTextAlignment(.leading)
        .padding(.horizontal, 12)
        .padding(.vertical, 11)
        .frame(width: width, alignment: .leading)
        .frame(minHeight: height)
        .background(.surfaceSecondary, in: .rect(cornerRadius: Radius.tile, style: .continuous))
        .accessibilityElement(children: .combine)
        .accessibilityHint("Rehearse this conversation.")
    }
}

/// Labels for Coming up tiles, kept free of views so they can be tested.
enum ComingUp {
    static func isTomorrow(_ event: CalendarEvent, now: Date, calendar: Calendar = .current) -> Bool {
        guard let tomorrow = calendar.date(byAdding: .day, value: 1, to: now) else { return false }
        return calendar.isDate(event.start, inSameDayAs: tomorrow)
    }

    /// Tomorrow: "10:00 · rehearse 5 min". Later: "Fri 9:12 · 4 min".
    static func detail(for event: CalendarEvent, now: Date, calendar: Calendar = .current) -> LocalizedStringResource {
        if isTomorrow(event, now: now, calendar: calendar) {
            let time = event.start.formatted(.dateTime.hour().minute())
            return "\(time) · rehearse \(event.rehearsalMinutes) min"
        }
        let day = event.start.formatted(.dateTime.weekday(.abbreviated).hour().minute())
        return "\(day) · \(event.rehearsalMinutes) min"
    }
}

#Preview {
    ComingUpCard(events: [
        CalendarEvent(id: "a", title: "Dentist", start: .now.addingTimeInterval(86_400),
                      systemImage: "cross.case", scenario: .dentist, rehearsalMinutes: 5),
        CalendarEvent(id: "b", title: "Train to Munich", start: .now.addingTimeInterval(4 * 86_400),
                      systemImage: "tram", scenario: .station)
    ]) { _ in }
        .padding(Spacing.screen)
        .background(.screenBackground)
}
