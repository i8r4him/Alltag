//
//  FromYourDayList.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// "From your day": short things to do, built from what happened today.
struct FromYourDayList: View {
    let newReadingWords: Int
    let writingMistakes: Int
    let onOpen: (Route) -> Void
    let onPresent: (FullScreenRoute) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader("From your day")
            .padding(.horizontal, 4)

            DaySpotlightList(items: items)
        }
    }

    /// The things to do today, in order.
    private var items: [DayItem] {
        var items = [
            DayItem(title: "60 seconds",
                    subtitle: "Talk about a random topic",
                    systemImage: "timer") { onPresent(.sixtySeconds) },
            DayItem(title: "How did the bakery go?",
                    subtitle: "Debrief: find what you couldn't say",
                    systemImage: "person.wave.2") { onOpen(.debrief) }
        ]
        if newReadingWords > 0 {
            items.append(DayItem(title: "^[\(newReadingWords) new word](inflect: true) from Safari",
                                 subtitle: "Spiegel · Mietpreise in Berlin",
                                 systemImage: "safari") { onOpen(.memory(kind: .fromYourDay)) })
        }
        if writingMistakes > 0 {
            items.append(DayItem(title: "^[\(writingMistakes) writing mistake](inflect: true) to review",
                                 subtitle: "Messages · „seit“ or „für“?",
                                 systemImage: "square.and.pencil") { onPresent(.activity(.mistakes)) })
        }
        return items
    }
}

/// One thing to do in "From your day".
private struct DayItem: Identifiable {
    let id = UUID()
    let title: LocalizedStringResource
    let subtitle: LocalizedStringResource
    let systemImage: String
    let action: () -> Void
}

/// The 60 seconds card first, then a compact list for the remaining actions.
private struct DaySpotlightList: View {
    let items: [DayItem]

    var body: some View {
        VStack(spacing: Spacing.grid) {
            if let first = items.first {
                SixtySecondsCard(action: first.action)
            }
            VStack(spacing: 0) {
                ForEach(Array(items.dropFirst().enumerated()), id: \.element.id) { index, item in
                    if index > 0 { Divider().padding(.leading, 56) }
                    Button(action: item.action) {
                        HStack(spacing: Spacing.grid) {
                            Image(systemName: item.systemImage)
                                .font(.title3)
                                .foregroundStyle(.accent)
                                .frame(width: 34, height: 34)
                                .background(.accent.opacity(AccentTint.selected),
                                            in: .rect(cornerRadius: Radius.tile, style: .continuous))
                                .accessibilityHidden(true)
                            label(item)
                            Spacer(minLength: 0)
                        }
                        .padding(Spacing.card)
                        .contentShape(.rect)
                    }
                    .buttonStyle(.plain)
                    .accessibilityElement(children: .combine)
                }
            }
            .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
        }
        .fontDesign(.rounded)
    }

    private func label(_ item: DayItem, title: Font = .headline) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(item.title)
                .font(title)
                .foregroundStyle(.primary)
            Text(item.subtitle)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .multilineTextAlignment(.leading)
        .fixedSize(horizontal: false, vertical: true)
    }
}

/// "Learning beyond the app": a ticket leading to translating what you read, and what is coming.
struct BeyondRow: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: Spacing.card) {
                Image(systemName: "apps.iphone")
                    .font(.title2)
                    .foregroundStyle(.accent)
                    .frame(width: 58)
                    .accessibilityHidden(true)
                Path { path in
                    path.move(to: .zero)
                    path.addLine(to: CGPoint(x: 0, y: 56))
                }
                .stroke(.separator, style: StrokeStyle(lineWidth: 1, dash: [3, 4]))
                .frame(width: 1, height: 56)
                .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 3) {
                    Text("Learning beyond the app")
                        .font(.headline)
                    Text("Translate what you read · widgets and Siri soon")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .multilineTextAlignment(.leading)
                .fixedSize(horizontal: false, vertical: true)
                Spacer(minLength: 0)
                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.tertiary)
                    .accessibilityHidden(true)
            }
            .padding(.horizontal, Spacing.card)
            .padding(.vertical, Spacing.card)
            .frame(maxWidth: .infinity, minHeight: 90, alignment: .leading)
            .overlay {
                RoundedRectangle(cornerRadius: Radius.innerCard, style: .continuous)
                    .strokeBorder(.separator, style: StrokeStyle(lineWidth: 1, dash: [5, 5]))
            }
            .contentShape(.rect(cornerRadius: Radius.innerCard, style: .continuous))
        }
        .fontDesign(.rounded)
        .buttonStyle(.plain)
        .accessibilityElement(children: .combine)
    }
}

/// Counts behind "From your day", kept out of the views so they can be tested.
enum FromYourDay {
    /// Words picked up from reading in Safari today, for "3 new words from Safari".
    static func newReadingWords(in items: [MemoryItem], on date: Date = .now, calendar: Calendar = .current) -> Int {
        items.filter {
            $0.kind == .fromYourDay && $0.source == .safari && calendar.isDate($0.createdAt, inSameDayAs: date)
        }.count
    }

    /// Mistakes the learner made while writing (in Messages).
    static func writingMistakes(in items: [MemoryItem]) -> Int {
        items.filter { $0.kind == .mistake && $0.source == .messages }.count
    }
}

#Preview {
    VStack(spacing: Spacing.grid) {
        FromYourDayList(newReadingWords: 3, writingMistakes: 1, onOpen: { _ in }, onPresent: { _ in })
        BeyondRow {}
    }
    .padding(Spacing.screen)
    .background(.screenBackground)
}
