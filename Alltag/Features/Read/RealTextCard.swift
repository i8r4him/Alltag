//
//  RealTextCard.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// A text as it looks in real life, for the cards to swipe through: a chat as
/// bubbles on glass, anything printed as a sheet of paper. It shows the
/// beginning and fades out; the reader has the whole text.
struct RealTextCard: View {
    let text: ReadingText
    let isRead: Bool

    private static let german = Locale(identifier: "de_DE")

    var body: some View {
        Group {
            switch text.kind {
            case .chat, .message:
                ChatPreview(text: text)
            default:
                PaperPreview(text: text)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .mask {
            LinearGradient(stops: [.init(color: .black, location: 0.78), .init(color: .clear, location: 1)],
                           startPoint: .top, endPoint: .bottom)
        }
        .overlay(alignment: .topTrailing) {
            if isRead {
                Image(systemName: "checkmark.seal.fill")
                    .font(.title2)
                    .foregroundStyle(.white, Color.accentFill)
                    .padding(14)
                    .accessibilityLabel(Text("Read"))
            }
        }
        .environment(\.locale, Self.german)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text(text.title))
        .accessibilityValue(Text(text.detail))
    }
}

/// A sheet of warm paper with the text printed on it; a menu's prices line up on the right.
private struct PaperPreview: View {
    let text: ReadingText

    /// Paper stays paper in light and dark mode, like the real thing.
    private static let paper = Color(red: 0.96, green: 0.94, blue: 0.89)
    private static let ink = Color(red: 0.16, green: 0.13, blue: 0.09)

    private var lines: [String] {
        text.german.split(separator: "\n").map { $0.trimmingCharacters(in: .whitespaces) }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label { Text(text.kind.title) } icon: { Image(systemName: text.systemImage) }
                .font(.caption.weight(.heavy))
                .textCase(.uppercase)
                .foregroundStyle(AppTheme.shared.palette.deep)
                .environment(\.locale, .current)
            if let title = lines.first {
                Text(verbatim: title)
                    .font(.title2.weight(.heavy))
                    .padding(.bottom, 4)
            }
            ForEach(Array(lines.dropFirst().prefix(9).enumerated()), id: \.offset) { _, line in
                PaperLine(line: line, isMenu: text.kind == .menu)
            }
        }
        .foregroundStyle(Self.ink)
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Self.paper, in: .rect(cornerRadius: Radius.card, style: .continuous))
        .shadow(color: .black.opacity(0.35), radius: 16, y: 10)
    }
}

/// One printed line: "Tomatensuppe mit Brot – 4,50 Euro" as a dish and its price on a menu.
private struct PaperLine: View {
    let line: String
    let isMenu: Bool

    var body: some View {
        let parts = line.components(separatedBy: " – ")
        if isMenu, parts.count == 2 {
            HStack(alignment: .firstTextBaseline) {
                Text(verbatim: parts[0])
                Spacer(minLength: 8)
                Text(verbatim: parts[1])
            }
            .font(.callout.weight(.bold))
            .padding(.vertical, 2)
        } else {
            Text(verbatim: line)
                .font(.callout.weight(.medium))
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

/// A chat as bubbles: "Mia: Hallo!" becomes Mia's name over her bubble. A
/// message without names is one bubble.
private struct ChatPreview: View {
    let text: ReadingText

    private struct Bubble: Identifiable {
        let id: Int
        let name: String?
        let message: String
    }

    private var bubbles: [Bubble] {
        let lines = text.german.split(separator: "\n").map { $0.trimmingCharacters(in: .whitespaces) }
        guard text.kind == .chat else {
            return [Bubble(id: 0, name: nil, message: lines.joined(separator: "\n"))]
        }
        return lines.enumerated().map { index, line in
            let parts = line.split(separator: ":", maxSplits: 1)
            guard parts.count == 2 else { return Bubble(id: index, name: nil, message: line) }
            return Bubble(id: index, name: String(parts[0]), message: parts[1].trimmingCharacters(in: .whitespaces))
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label { Text(text.kind.title) } icon: { Image(systemName: text.systemImage) }
                .font(.caption.weight(.heavy))
                .textCase(.uppercase)
                .foregroundStyle(.accent)
                .environment(\.locale, .current)
            ForEach(bubbles.prefix(6)) { bubble in
                VStack(alignment: .leading, spacing: 3) {
                    if let name = bubble.name {
                        Text(verbatim: name)
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.accent)
                    }
                    Text(verbatim: bubble.message)
                        .font(.callout.weight(.medium))
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.horizontal, 13)
                .padding(.vertical, 9)
                .background(.accent.opacity(AccentTint.selected), in: .rect(cornerRadius: 18, style: .continuous))
                .frame(maxWidth: 280, alignment: .leading)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.card, style: .continuous))
    }
}
