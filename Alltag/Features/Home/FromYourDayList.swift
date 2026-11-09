//
//  FromYourDayList.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// "From your day": short things to do, built from what happened today.
struct FromYourDayList: View {
    let briefingWords: Int
    let newReadingWords: Int
    let writingMistakes: Int
    let onOpen: (Route) -> Void
    let onPresent: (FullScreenRoute) -> Void

    @State private var briefingDesign = BriefingCardDesign.current

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(title: "From your day") {
                Text("Today")
            }
            .padding(.horizontal, 4)

            DaySpotlightList(items: items, briefingDesign: briefingDesign)
            BriefingCardSwitcher(design: $briefingDesign)
        }
    }

    /// The things to do today, in order.
    private var items: [DayItem] {
        var items = [
            DayItem(title: "Your 60-second briefing",
                    subtitle: "Built from \(briefingWords) words you are learning",
                    systemImage: "headphones") { onOpen(.briefing) },
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

/// A featured first action with a compact list for the remaining actions.
private struct DaySpotlightList: View {
    let items: [DayItem]
    let briefingDesign: BriefingCardDesign

    var body: some View {
        VStack(spacing: Spacing.grid) {
            if briefingDesign != .current, let first = items.first {
                BriefingCard(design: briefingDesign, words: MockBriefing.briefing.words, action: first.action)
            } else if let first = items.first {
                Button(action: first.action) {
                    HStack(alignment: .bottom, spacing: Spacing.card) {
                        label(first, title: .title2.weight(.semibold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Image(systemName: first.systemImage)
                            .font(.system(size: 48, weight: .ultraLight))
                            .foregroundStyle(.accent)
                            .frame(width: 76, height: 76)
                            .accessibilityHidden(true)
                    }
                    .padding(Spacing.cardLarge)
                    .frame(maxWidth: .infinity, minHeight: 158, alignment: .bottomLeading)
                    .glassEffect(.regular.tint(Color.accent.opacity(AccentTint.selected)).interactive(),
                                 in: .rect(cornerRadius: Radius.card))
                }
                .buttonStyle(.plain)
                .accessibilityElement(children: .combine)
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
            .background(.surface, in: .rect(cornerRadius: Radius.card, style: .continuous))
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

/// "Learning beyond the app": a ticket leading to the concepts.
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
                    Text("Keyboard, Siri & widgets · concepts")
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
        FromYourDayList(briefingWords: 6, newReadingWords: 3, writingMistakes: 1, onOpen: { _ in }, onPresent: { _ in })
        BeyondRow {}
    }
    .padding(Spacing.screen)
    .background(.screenBackground)
}
