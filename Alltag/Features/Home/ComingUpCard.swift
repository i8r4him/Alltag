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

    /// Temporary: the tile design being compared.
    @State var design = ComingUpDesign.original

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
                                ComingUpTile(event: event, now: now, design: design)
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

            designSwitcher
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

extension ComingUpCard {
    /// Temporary: ‹ 2 / 6 · Artwork › to step through the tile designs.
    var designSwitcher: some View {
        let all = ComingUpDesign.allCases
        return HStack(spacing: 14) {
            Button { step(-1) } label: { Image(systemName: "chevron.left") }
            Text(verbatim: "\(design.rawValue + 1) / \(all.count) · \(design.name)")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.secondary)
                .frame(minWidth: 150)
            Button { step(1) } label: { Image(systemName: "chevron.right") }
        }
        .font(.footnote.weight(.semibold))
        .buttonStyle(.glass)
        .frame(maxWidth: .infinity)
        .sensoryFeedback(.selection, trigger: design)
    }

    private func step(_ offset: Int) {
        let all = ComingUpDesign.allCases
        withAnimation(.snappy) { design = all[(design.rawValue + offset + all.count) % all.count] }
    }
}

/// Temporary: designs for the tiles' content, to compare on Today.
enum ComingUpDesign: Int, CaseIterable {
    case original, artwork, artworkBand, timeFirst, quiet, cornerArt

    var name: String {
        switch self {
        case .original: "Original"
        case .artwork: "Artwork"
        case .artworkBand: "Artwork band"
        case .timeFirst: "Time first"
        case .quiet: "Quiet"
        case .cornerArt: "Corner art"
        }
    }
}

/// One upcoming event: same size and shape in every design.
private struct ComingUpTile: View {
    let event: CalendarEvent
    let now: Date
    var design = ComingUpDesign.original

    @ScaledMetric(relativeTo: .title3) private var side: CGFloat = 196

    var body: some View {
        Group {
            switch design {
            case .original: original
            case .artwork: artwork
            case .artworkBand: artworkBand
            case .timeFirst: timeFirst
            case .quiet: quiet
            case .cornerArt: cornerArt
            }
        }
        .multilineTextAlignment(.leading)
        .frame(width: side, height: side, alignment: .topLeading)
        .fontDesign(.rounded)
        .accessibilityElement(children: .combine)
        .accessibilityHint("Rehearse this conversation.")
    }

    private var time: String { event.start.formatted(.dateTime.hour().minute()) }
    private var day: String {
        ComingUp.isTomorrow(event, now: now) ? String(localized: "Tomorrow")
            : event.start.formatted(.dateTime.weekday(.wide))
    }

    // MARK: 1 Original

    private var original: some View {
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
                .font(.body.weight(.medium))
                .foregroundStyle(.primary.opacity(0.75))
                .lineLimit(1)
                .padding(.top, 4)
        }
        .padding(20)
        .frame(width: side, height: side, alignment: .topLeading)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }

    // MARK: 2 Artwork (the Focus card's language)

    private var artwork: some View {
        VStack(alignment: .leading, spacing: 0) {
            ScenarioArtwork(systemImage: event.systemImage, symbolSize: 34, cornerRadius: 14)
                .frame(width: 64, height: 64)
            Spacer(minLength: 10)
            Text(verbatim: event.title)
                .font(.title3.weight(.semibold))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            Text("\(day), \(time)")
                .font(.title3)
                .foregroundStyle(.secondary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            Text(ComingUp.startsIn(event, now: now))
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.accent)
                .padding(.top, 6)
        }
        .padding(18)
        .focusSurface(side: side)
    }

    // MARK: 3 Artwork band

    private var artworkBand: some View {
        VStack(alignment: .leading, spacing: 0) {
            ScenarioArtwork(systemImage: event.systemImage, symbolSize: 64, cornerRadius: 0)
                .frame(height: side * 0.48)
            VStack(alignment: .leading, spacing: 2) {
                Text(verbatim: event.title)
                    .font(.title3.weight(.semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                Text("\(day), \(time)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                Text(ComingUp.startsIn(event, now: now))
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.accent)
                    .padding(.top, 4)
            }
            .padding(.horizontal, 18)
            .padding(.top, 2)
        }
        .focusSurface(side: side)
    }

    // MARK: 4 Time first

    private var timeFirst: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(verbatim: day)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.accent)
            Text(verbatim: time)
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
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer(minLength: 4)
            }
        }
        .padding(18)
        .overlay(alignment: .topTrailing) {
            ScenarioArtwork(systemImage: event.systemImage, symbolSize: 26, cornerRadius: 12)
                .frame(width: 46, height: 46)
                .padding(16)
        }
        .focusSurface(side: side)
    }

    // MARK: 5 Quiet

    private var quiet: some View {
        VStack(alignment: .leading, spacing: 0) {
            Image(systemName: event.systemImage)
                .font(.title2)
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(.accent)
                .frame(width: 48, height: 48)
                .background(.accentFill.opacity(0.18), in: .rect(cornerRadius: 14, style: .continuous))
                .accessibilityHidden(true)
            Spacer(minLength: 10)
            Text(ComingUp.startsIn(event, now: now))
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.accent)
            Text(verbatim: event.title)
                .font(.title3.weight(.semibold))
                .lineLimit(1)
                .minimumScaleFactor(0.8)
            Text(ComingUp.detail(for: event, now: now))
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .padding(18)
        .focusSurface(side: side)
    }

    // MARK: 6 Corner art

    private var cornerArt: some View {
        ZStack(alignment: .bottomLeading) {
            ScenarioArtwork(systemImage: event.systemImage, symbolSize: 70, cornerRadius: 0)
                .frame(width: side * 0.7, height: side * 0.62)
                .mask {
                    RadialGradient(colors: [.black, .clear], center: .topTrailing,
                                   startRadius: side * 0.15, endRadius: side * 0.7)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
            VStack(alignment: .leading, spacing: 2) {
                Text(verbatim: event.title)
                    .font(.title3.weight(.semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                Text("\(day), \(time)")
                    .font(.title3)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .padding(18)
        }
        .focusSurface(side: side)
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

    /// "Starts in 14h", "Starts in 3d", or "Starts soon" within the hour.
    static func startsIn(_ event: CalendarEvent, now: Date) -> LocalizedStringResource {
        let hours = Int(event.start.timeIntervalSince(now) / 3_600)
        if hours < 1 { return "Starts soon" }
        if hours < 24 { return "Starts in \(hours)h" }
        return "Starts in \(hours / 24)d"
    }

    /// Tomorrow: "10:00 · 5 min". Later: "Fri 09:12 · 4 min".
    static func detail(for event: CalendarEvent, now: Date, calendar: Calendar = .current) -> LocalizedStringResource {
        let time = isTomorrow(event, now: now, calendar: calendar)
            ? event.start.formatted(.dateTime.hour().minute())
            : event.start.formatted(.dateTime.weekday(.abbreviated).hour().minute())
        return "\(time) · \(event.rehearsalMinutes) min"
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
