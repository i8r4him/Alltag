//
//  StreakPopover.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 11.11.26.
//

import SwiftData
import SwiftUI

/// The flame in Today's toolbar: the days in a row, opening `StreakPopover`.
///
/// Its own view, with its own query and state, so opening the popover only
/// redraws the button and not the whole of Today mid-animation.
struct StreakButton: View {
    @Query private var sessions: [PracticeSession]
    @State private var isPresented = false

    private var days: Int { Streak.days(activity: sessions.map(\.date)) }

    var body: some View {
        Button {
            isPresented = true
        } label: {
            // Not a Label: toolbars show labels as icons only.
            HStack(spacing: 4) {
                Image(systemName: "flame.fill")
                    .foregroundStyle(.linearGradient(colors: [.yellow, .orange], startPoint: .top, endPoint: .bottom))
                Text(days, format: .number)
                    .monospacedDigit()
            }
        }
        .accessibilityLabel(Text("^[\(days) day](inflect: true) in a row"))
        .popover(isPresented: $isPresented) {
            StreakPopover(days: days, week: Streak.week(activity: sessions.map(\.date)))
                .presentationCompactAdaptation(.popover)
        }
        .sensoryFeedback(.impact(weight: .light), trigger: isPresented) { _, shows in shows }
    }
}

/// What the flame on Today means: the days in a row, the last seven days,
/// and what to do to keep the streak going.
struct StreakPopover: View {
    let days: Int
    let week: [StreakDay]

    private var practisedToday: Bool { week.last?.practised ?? false }

    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 4) {
                Text("^[\(days) day](inflect: true) in a row")
                    .font(.title2.bold())
                Text(message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
            }
            HStack(spacing: 10) {
                ForEach(week) { day in
                    VStack(spacing: 6) {
                        dot(for: day)
                        Text(day.date, format: .dateTime.weekday(.narrow))
                            .font(.caption2.weight(.semibold))
                            .foregroundStyle(day.id == week.last?.id ? .primary : .secondary)
                    }
                }
            }
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(Text("Practised on ^[\(week.filter(\.practised).count) of the last 7 days](inflect: true)"))
        }
        .fontDesign(.rounded)
        .padding(20)
        .frame(width: 300)
        .fixedSize(horizontal: false, vertical: true)
    }

    private var message: LocalizedStringResource {
        if practisedToday {
            "You practised today. See you tomorrow."
        } else if days > 0 {
            "Practise today to keep it going."
        } else {
            "Practise today to start a streak."
        }
    }

    /// A flame for a day with practice, an empty ring for one without.
    @ViewBuilder
    private func dot(for day: StreakDay) -> some View {
        ZStack {
            if day.practised {
                Circle().fill(.orange.opacity(0.2))
                Image(systemName: "flame.fill")
                    .font(.footnote)
                    .foregroundStyle(.linearGradient(colors: [.yellow, .orange], startPoint: .top, endPoint: .bottom))
            } else {
                Circle().strokeBorder(.secondary.opacity(0.4), lineWidth: 1.5)
            }
        }
        .frame(width: 28, height: 28)
    }
}

#Preview {
    let today = Date.now
    let week = (0..<7).reversed().map { offset in
        StreakDay(date: Calendar.current.date(byAdding: .day, value: -offset, to: today) ?? today, practised: offset < 3)
    }
    StreakPopover(days: 3, week: week)
}
