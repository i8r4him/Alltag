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
            .scrollTargetBehavior(.viewAligned)
            .scrollIndicators(.hidden)
            .scrollClipDisabled()
            // Not the screen's readable-width margins (they are inherited).
            .contentMargins(.horizontal, 0, for: .scrollContent)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

/// Calendar → the place, when it starts, the event and the rehearsal.
private struct ComingUpTile: View {
    let event: CalendarEvent
    let now: Date

    @ScaledMetric(relativeTo: .title3) private var side: CGFloat = 196

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image(systemName: event.systemImage)
                .font(.system(size: 30))
                .foregroundStyle(.primary)
                .accessibilityHidden(true)

            Spacer(minLength: 16)

            Text(ComingUp.startsIn(event, now: now))
                .textRole(.meta)
                .fontWeight(.semibold)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .overlay(Capsule().strokeBorder(.white.opacity(0.18), lineWidth: 1))
                .padding(.bottom, 10)

            Text(verbatim: event.title)
                .textRole(.sectionHeader)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            Text(ComingUp.detail(for: event, now: now))
                .textRole(.bodySmall)
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
                .padding(.top, 2)
        }
        .multilineTextAlignment(.leading)
        .padding(20)
        .frame(width: side, height: side, alignment: .topLeading)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.card, style: .continuous))
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

    /// Events grouped by the day they start on, earliest first.
    static func days(_ events: [CalendarEvent], calendar: Calendar = .current) -> [(day: Date, events: [CalendarEvent])] {
        Dictionary(grouping: events.sorted { $0.start < $1.start }) { calendar.startOfDay(for: $0.start) }
            .map { (day: $0.key, events: $0.value) }
            .sorted { $0.day < $1.day }
    }

    /// "Starts in 14h", "Starts in 3d", or "Starts soon" within the hour.
    static func startsIn(_ event: CalendarEvent, now: Date) -> LocalizedStringResource {
        let hours = Int(event.start.timeIntervalSince(now) / 3_600)
        if hours < 1 { return "Starts soon" }
        if hours < 24 { return "Starts in \(hours)h" }
        return "Starts in \(hours / 24)d"
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
    ], onShowAll: {}, onSelect: { _ in })
        .padding(Spacing.screen)
        .background(.screenBackground)
}
