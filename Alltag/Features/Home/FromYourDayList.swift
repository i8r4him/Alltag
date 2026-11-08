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

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(title: "From your day") {
                Text("Today")
            }
            .padding(.horizontal, 4)

            VStack(spacing: 0) {
                DayRow(title: "Your 60-second briefing",
                       subtitle: "Built from \(briefingWords) words you are learning",
                       systemImage: "headphones", tint: .accent) {
                    onOpen(.briefing)
                }
                Divider().padding(.leading, 68)
                DayRow(title: "How did the bakery go?",
                       subtitle: "Debrief: find what you couldn't say",
                       systemImage: "person.wave.2") {
                    onOpen(.debrief)
                }
                if newReadingWords > 0 {
                    Divider().padding(.leading, 68)
                    DayRow(title: "^[\(newReadingWords) new word](inflect: true) from Safari",
                           subtitle: "Spiegel · Mietpreise in Berlin",
                           systemImage: "safari") {
                        onOpen(.memory(kind: .fromYourDay))
                    }
                }
                if writingMistakes > 0 {
                    Divider().padding(.leading, 68)
                    DayRow(title: "^[\(writingMistakes) writing mistake](inflect: true) to review",
                           subtitle: "Messages · „seit“ or „für“?",
                           systemImage: "square.and.pencil", tint: .mistake) {
                        onPresent(.activity(.mistakes))
                    }
                }
            }
            .background(.surface, in: .rect(cornerRadius: Radius.card, style: .continuous))
            .clipShape(.rect(cornerRadius: Radius.card, style: .continuous))
        }
    }
}

/// A row in "From your day": coloured symbol, title, subtitle, chevron.
private struct DayRow: View {
    let title: LocalizedStringResource
    let subtitle: LocalizedStringResource
    let systemImage: String
    var tint: Color = .primary
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: systemImage)
                    .font(.system(size: 19))
                    .foregroundStyle(tint)
                    .frame(width: 40, height: 40)
                    .background(.surfaceSecondary, in: .rect(cornerRadius: 12, style: .continuous))
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .textRole(.bodySmall)
                        .fontWeight(.medium)
                    Text(subtitle)
                        .textRole(.meta)
                        .foregroundStyle(.secondary)
                }
                .multilineTextAlignment(.leading)
                Spacer(minLength: 8)
                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.tertiary)
                    .accessibilityHidden(true)
            }
            .padding(.horizontal, Spacing.card)
            .padding(.vertical, 14)
            .frame(minHeight: Spacing.rowMinHeight)
            .contentShape(.rect)
        }
        .buttonStyle(RowButtonStyle())
        .accessibilityElement(children: .combine)
    }
}

/// Highlights a list row while pressed, like a native list.
private struct RowButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(configuration.isPressed ? AnyShapeStyle(.surfaceSecondary) : AnyShapeStyle(.clear))
    }
}

/// "Learning beyond the app": an outlined row leading to the concepts.
struct BeyondRow: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: "apps.iphone")
                    .font(.system(size: 19))
                    .foregroundStyle(.secondary)
                    .frame(width: 40, height: 40)
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 2) {
                    Text("Learning beyond the app")
                        .textRole(.bodySmall)
                        .fontWeight(.medium)
                    Text("Keyboard, Siri & widgets · concepts")
                        .textRole(.meta)
                        .foregroundStyle(.secondary)
                }
                .multilineTextAlignment(.leading)
                Spacer(minLength: 8)
                Image(systemName: "chevron.right")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.tertiary)
                    .accessibilityHidden(true)
            }
            .padding(.horizontal, Spacing.card)
            .padding(.vertical, 12)
            .overlay {
                RoundedRectangle(cornerRadius: Radius.card, style: .continuous)
                    .strokeBorder(.separator, lineWidth: 0.5)
            }
            .contentShape(.rect(cornerRadius: Radius.card, style: .continuous))
        }
        .buttonStyle(.card)
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
