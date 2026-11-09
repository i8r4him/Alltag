//
//  BriefingCardDesigns.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 09.11.26.
//

import SwiftUI

/// Temporary: designs for the 60-second briefing card, to compare on device.
enum BriefingCardDesign: Int, CaseIterable {
    case current, focus, waveform, words, nowPlaying, poster

    var name: String {
        switch self {
        case .current: "Current"
        case .focus: "Focus"
        case .waveform: "Waveform"
        case .words: "Words"
        case .nowPlaying: "Now playing"
        case .poster: "Poster"
        }
    }
}

/// Temporary: steps through the briefing card designs.
struct BriefingCardSwitcher: View {
    @Binding var design: BriefingCardDesign

    var body: some View {
        let all = BriefingCardDesign.allCases
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
        let all = BriefingCardDesign.allCases
        withAnimation(.snappy) { design = all[(design.rawValue + offset + all.count) % all.count] }
    }
}

/// The briefing card in one of the new designs, all in the Focus card's language.
struct BriefingCard: View {
    let design: BriefingCardDesign
    let words: [String]
    let action: () -> Void

    var body: some View {
        Group {
            switch design {
            case .waveform: waveform
            case .words: wordChips
            case .nowPlaying: nowPlaying
            case .poster: poster
            default: focus
            }
        }
        .fontDesign(.rounded)
        .sensoryFeedback(.impact(weight: .light), trigger: taps)
    }

    @State private var taps = 0

    private func tapped() {
        taps += 1
        action()
    }

    // MARK: Pieces

    private var title: some View {
        Text("Your 60-second briefing")
            .font(.title3.weight(.semibold))
            .fixedSize(horizontal: false, vertical: true)
    }

    private var subtitle: some View {
        Text("Built from ^[\(words.count) word](inflect: true) you are learning.")
            .font(.title3)
            .foregroundStyle(.secondary)
            .fixedSize(horizontal: false, vertical: true)
    }

    private var listenButton: some View {
        Button(action: tapped) {
            Label("Listen · 1 min", systemImage: "play.fill")
                .font(.headline)
                .frame(maxWidth: .infinity, minHeight: 34)
        }
        .buttonStyle(.glassProminent)
        .tint(Color.accentFill)
    }

    private var playCircle: some View {
        Button(action: tapped) {
            Image(systemName: "play.fill")
                .font(.title3)
                .frame(width: 34, height: 34)
        }
        .buttonStyle(.glassProminent)
        .buttonBorderShape(.circle)
        .tint(Color.accentFill)
        .accessibilityLabel("Listen")
    }

    // MARK: Designs

    /// Like the Focus card: text left, artwork right, a Listen button below.
    private var focus: some View {
        VStack(spacing: 18) {
            HStack(alignment: .center, spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    title
                    subtitle
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityElement(children: .combine)
                ScenarioArtwork(systemImage: "headphones")
                    .frame(width: 96, height: 96)
            }
            listenButton
        }
        .padding(Spacing.cardLarge)
        .briefingSurface()
    }

    /// A waveform in the theme colour with a play button and the length.
    private var waveform: some View {
        VStack(alignment: .leading, spacing: 18) {
            VStack(alignment: .leading, spacing: 6) {
                title
                subtitle
            }
            .accessibilityElement(children: .combine)
            HStack(spacing: 14) {
                playCircle
                Waveform()
                    .frame(height: 34)
                    .accessibilityHidden(true)
                Text(verbatim: "1:00")
                    .font(.subheadline.weight(.semibold).monospacedDigit())
                    .foregroundStyle(.secondary)
            }
        }
        .padding(Spacing.cardLarge)
        .frame(maxWidth: .infinity, alignment: .leading)
        .briefingSurface()
    }

    /// The words it's built from, as chips in the theme colour.
    private var wordChips: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    title
                    Text("Built from words you are learning.")
                        .font(.title3)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityElement(children: .combine)
                playCircle
            }
            FlowChips(words: words)
                .accessibilityHidden(true)
        }
        .padding(Spacing.cardLarge)
        .briefingSurface()
    }

    /// A compact player: artwork, title, play, and an empty progress bar.
    private var nowPlaying: some View {
        VStack(spacing: 14) {
            HStack(spacing: 14) {
                ScenarioArtwork(systemImage: "headphones", symbolSize: 30, cornerRadius: 14)
                    .frame(width: 64, height: 64)
                VStack(alignment: .leading, spacing: 3) {
                    Text("Your 60-second briefing")
                        .font(.headline)
                    Text("Built from ^[\(words.count) word](inflect: true) you are learning.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .fixedSize(horizontal: false, vertical: true)
                .accessibilityElement(children: .combine)
                playCircle
            }
            HStack(spacing: 10) {
                Text(verbatim: "0:00")
                Capsule()
                    .fill(.accent.opacity(0.18))
                    .frame(height: 4)
                    .overlay(alignment: .leading) {
                        Capsule().fill(.accent).frame(width: 6, height: 4)
                    }
                Text(verbatim: "1:00")
            }
            .font(.caption.weight(.semibold).monospacedDigit())
            .foregroundStyle(.secondary)
            .accessibilityHidden(true)
        }
        .padding(Spacing.card)
        .briefingSurface()
    }

    /// Big artwork on top, the text and Listen button underneath.
    private var poster: some View {
        VStack(alignment: .leading, spacing: 16) {
            ScenarioArtwork(systemImage: "headphones", symbolSize: 64, cornerRadius: 24)
                .frame(maxWidth: .infinity)
                .frame(height: 130)
            VStack(alignment: .leading, spacing: 6) {
                title
                subtitle
            }
            .accessibilityElement(children: .combine)
            listenButton
        }
        .padding(Spacing.card)
        .briefingSurface()
    }
}

/// A still waveform drawn from fixed bar heights.
private struct Waveform: View {
    private static let heights: [CGFloat] = [
        0.3, 0.55, 0.8, 0.45, 0.95, 0.6, 0.35, 0.7, 1, 0.5, 0.65, 0.3,
        0.85, 0.55, 0.4, 0.75, 0.5, 0.9, 0.45, 0.6, 0.3, 0.7, 0.4, 0.25
    ]

    var body: some View {
        GeometryReader { proxy in
            HStack(alignment: .center, spacing: 3) {
                ForEach(Self.heights.indices, id: \.self) { index in
                    Capsule()
                        .fill(LinearGradient(colors: [.accentFill, AppTheme.shared.palette.deep],
                                             startPoint: .top, endPoint: .bottom))
                        .frame(height: max(4, proxy.size.height * Self.heights[index]))
                }
            }
            .frame(maxHeight: .infinity)
        }
    }
}

/// German words as small chips that wrap onto new lines.
private struct FlowChips: View {
    let words: [String]

    var body: some View {
        ChipFlow(spacing: 8) {
            ForEach(words, id: \.self) { word in
                Text(verbatim: word)
                    .font(.subheadline.weight(.medium))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(.accent.opacity(0.16), in: .capsule)
                    .foregroundStyle(.accent)
            }
        }
    }
}

/// A simple wrapping layout.
private struct ChipFlow: Layout {
    var spacing: CGFloat

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let rows = arrange(width: proposal.width ?? .infinity, subviews: subviews)
        return CGSize(width: proposal.width ?? rows.width, height: rows.height)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        var origin = bounds.origin
        var rowHeight: CGFloat = 0
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if origin.x + size.width > bounds.maxX, origin.x > bounds.minX {
                origin.x = bounds.minX
                origin.y += rowHeight + spacing
                rowHeight = 0
            }
            subview.place(at: origin, proposal: ProposedViewSize(size))
            origin.x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
    }

    private func arrange(width: CGFloat, subviews: Subviews) -> (width: CGFloat, height: CGFloat) {
        var lineWidth: CGFloat = 0, height: CGFloat = 0, rowHeight: CGFloat = 0, widest: CGFloat = 0
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if lineWidth + size.width > width, lineWidth > 0 {
                height += rowHeight + spacing
                lineWidth = 0
                rowHeight = 0
            }
            lineWidth += size.width + spacing
            widest = max(widest, lineWidth - spacing)
            rowHeight = max(rowHeight, size.height)
        }
        return (widest, height + rowHeight)
    }
}

private extension View {
    /// The Focus card's surface: dark, with a thin light edge.
    func briefingSurface() -> some View {
        frame(maxWidth: .infinity)
            .background {
                RoundedRectangle(cornerRadius: Radius.hero, style: .continuous)
                    .fill(.surface)
                    .overlay {
                        RoundedRectangle(cornerRadius: Radius.hero, style: .continuous)
                            .strokeBorder(.white.opacity(0.06), lineWidth: 1)
                    }
            }
    }
}
