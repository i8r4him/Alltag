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

    /// Temporary: the design being compared.
    @State private var design = DayListDesign.original

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            SectionHeader(title: "From your day") {
                Text("Today")
            }
            .padding(.horizontal, 4)

            switch design {
            case .original: original
            default: DayListVariant(design: design, items: items)
            }

            DayListSwitcher(design: $design)
                .padding(.top, 4)
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

    private var original: some View {
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

/// One thing to do in "From your day".
struct DayItem: Identifiable {
    let id = UUID()
    let title: LocalizedStringResource
    let subtitle: LocalizedStringResource
    let systemImage: String
    let action: () -> Void
}

/// Temporary: designs for "From your day", to compare.
enum DayListDesign: Int, CaseIterable {
    case original, artworkList, cards, grid, carousel, minimal
    case timeline, spotlight, numbered, ribbons, mosaic, tickets, gallery, compact

    var name: String {
        switch self {
        case .original: "Original"
        case .artworkList: "Artwork list"
        case .cards: "Cards"
        case .grid: "Grid"
        case .carousel: "Carousel"
        case .minimal: "Minimal"
        case .timeline: "Timeline"
        case .spotlight: "Spotlight"
        case .numbered: "Numbered"
        case .ribbons: "Ribbons"
        case .mosaic: "Mosaic"
        case .tickets: "Tickets"
        case .gallery: "Gallery"
        case .compact: "Compact"
        }
    }
}

/// Temporary design picker for the Today list.
private struct DayListSwitcher: View {
    @Binding var design: DayListDesign

    var body: some View {
        let all = DayListDesign.allCases
        HStack(spacing: 14) {
            Button { step(-1) } label: { Image(systemName: "chevron.left") }
            Text(verbatim: "\(design.rawValue + 1) / \(all.count) · \(design.name)")
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
        let all = DayListDesign.allCases
        withAnimation(.snappy) { design = all[(design.rawValue + offset + all.count) % all.count] }
    }
}

/// The five new designs, in the Focus card's language.
private struct DayListVariant: View {
    let design: DayListDesign
    let items: [DayItem]

    var body: some View {
        Group {
            switch design {
            case .artworkList: artworkList
            case .cards: cards
            case .grid: grid
            case .carousel: carousel
            case .minimal: minimal
            case .timeline, .spotlight, .numbered, .ribbons, .mosaic, .tickets, .gallery, .compact:
                DayListExtraVariant(design: design, items: items)
            case .original: EmptyView()
            }
        }
        .fontDesign(.rounded)
    }

    // MARK: Artwork list

    private var artworkList: some View {
        VStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                if index > 0 { Divider().padding(.leading, 76) }
                Button(action: item.action) {
                    HStack(spacing: 14) {
                        ScenarioArtwork(systemImage: item.systemImage, symbolSize: 22, cornerRadius: 12)
                            .frame(width: 46, height: 46)
                        texts(item, title: .headline, subtitle: .subheadline)
                        Spacer(minLength: 8)
                        chevron
                    }
                    .padding(.horizontal, Spacing.card)
                    .padding(.vertical, 12)
                    .contentShape(.rect)
                }
                .buttonStyle(.plain)
            }
        }
        .surfaceCard(radius: Radius.hero)
    }

    // MARK: Cards

    private var cards: some View {
        VStack(spacing: 10) {
            ForEach(items) { item in
                Button(action: item.action) {
                    HStack(spacing: 14) {
                        texts(item, title: .title3.weight(.semibold), subtitle: .body)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        ScenarioArtwork(systemImage: item.systemImage, symbolSize: 28, cornerRadius: 14)
                            .frame(width: 58, height: 58)
                    }
                    .padding(Spacing.card)
                    .surfaceCard(radius: Radius.card)
                }
                .buttonStyle(.card)
            }
        }
    }

    // MARK: Grid

    private var grid: some View {
        LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
            ForEach(items) { item in
                Button(action: item.action) {
                    VStack(alignment: .leading, spacing: 0) {
                        ScenarioArtwork(systemImage: item.systemImage, symbolSize: 22, cornerRadius: 12)
                            .frame(width: 44, height: 44)
                        Spacer(minLength: 12)
                        texts(item, title: .headline, subtitle: .footnote)
                    }
                    .padding(14)
                    .frame(maxWidth: .infinity, minHeight: 150, alignment: .topLeading)
                    .surfaceCard(radius: Radius.card)
                }
                .buttonStyle(.card)
            }
        }
    }

    // MARK: Carousel

    private var carousel: some View {
        ScrollView(.horizontal) {
            HStack(spacing: Spacing.grid) {
                ForEach(items) { item in
                    Button(action: item.action) {
                        VStack(alignment: .leading, spacing: 0) {
                            Spacer(minLength: 0)
                            texts(item, title: .title3.weight(.semibold), subtitle: .subheadline)
                        }
                        .padding(18)
                        .frame(width: 196, height: 196, alignment: .topLeading)
                        .overlay(alignment: .topTrailing) {
                            ScenarioArtwork(systemImage: item.systemImage, symbolSize: 26, cornerRadius: 12)
                                .frame(width: 46, height: 46)
                                .padding(16)
                        }
                        .surfaceCard(radius: Radius.hero)
                    }
                    .buttonStyle(.card)
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
        .scrollIndicators(.hidden)
        .scrollClipDisabled()
        .contentMargins(.horizontal, 0, for: .scrollContent)
    }

    // MARK: Minimal

    private var minimal: some View {
        VStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                if index > 0 { Divider().padding(.leading, 52) }
                Button(action: item.action) {
                    HStack(spacing: 14) {
                        Image(systemName: item.systemImage)
                            .font(.title3)
                            .symbolRenderingMode(.hierarchical)
                            .foregroundStyle(.accent)
                            .frame(width: 38)
                            .accessibilityHidden(true)
                        texts(item, title: .headline, subtitle: .subheadline)
                        Spacer(minLength: 8)
                        chevron
                    }
                    .padding(.vertical, 14)
                    .padding(.horizontal, 4)
                    .contentShape(.rect)
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: Parts

    private func texts(_ item: DayItem, title: Font, subtitle: Font) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(item.title)
                .font(title)
                .foregroundStyle(.primary)
            Text(item.subtitle)
                .font(subtitle)
                .foregroundStyle(.secondary)
        }
        .multilineTextAlignment(.leading)
        .fixedSize(horizontal: false, vertical: true)
    }

    private var chevron: some View {
        Image(systemName: "chevron.right")
            .font(.footnote.weight(.semibold))
            .foregroundStyle(.tertiary)
            .accessibilityHidden(true)
    }
}

private extension View {
    /// The Focus card's surface: dark, with a thin light edge.
    func surfaceCard(radius: CGFloat) -> some View {
        background {
            RoundedRectangle(cornerRadius: radius, style: .continuous)
                .fill(.surface)
                .overlay {
                    RoundedRectangle(cornerRadius: radius, style: .continuous)
                        .strokeBorder(.white.opacity(0.06), lineWidth: 1)
                }
        }
        .clipShape(.rect(cornerRadius: radius, style: .continuous))
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
