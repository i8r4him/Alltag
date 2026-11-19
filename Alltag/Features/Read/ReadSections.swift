//
//  ReadSections.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Where a text comes from in the learner's day: Read's sections.
enum ReadingSource: CaseIterable {
    case letterbox
    case phone
    case outside
    case home
    case stories

    var title: LocalizedStringResource {
        switch self {
        case .letterbox: "Letters and emails"
        case .phone: "On your phone"
        case .outside: "Out and about"
        case .home: "At home"
        case .stories: "Stories"
        }
    }

    static func of(_ kind: ReadingKind) -> ReadingSource {
        switch kind {
        case .letter, .email: .letterbox
        case .chat, .message, .advert, .article: .phone
        case .notice, .menu, .announcement, .programme: .outside
        case .recipe, .leaflet: .home
        case .story: .stories
        }
    }
}

/// The level's texts in sections by where you meet them, each row ticked
/// once read; the next one to read has a dot.
struct ReadSections: View {
    let level: Level
    let texts: [ReadingText]
    let read: Set<String>
    let zoom: Namespace.ID
    let onOpen: (ReadingText) -> Void

    private var nextID: String? { texts.first { !read.contains($0.id) }?.id }

    var body: some View {
        Group {
            Text("\(level.title) · \(texts.filter { read.contains($0.id) }.count) of \(texts.count) read")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
                .padding(.horizontal, 4)
            sections
        }
    }

    private var sections: some View {
        ForEach(ReadingSource.allCases, id: \.self) { source in
            let inSource = texts.filter { ReadingSource.of($0.kind) == source }
            if !inSource.isEmpty {
                LearnSection(title: source.title, note: newNote(inSource)) {
                    WriteGlassList {
                        ForEach(inSource) { text in
                            LearnRow(systemImage: text.systemImage, title: Text(text.title),
                                     detail: Text(text.detail), action: { onOpen(text) },
                                     trailing: { trailing(for: text) })
                            .matchedTransitionSource(id: text.id, in: zoom)
                        }
                    }
                }
            }
        }
    }

    /// "1 new": the texts of a section not read yet.
    private func newNote(_ texts: [ReadingText]) -> Text? {
        let unread = texts.filter { !read.contains($0.id) }.count
        return unread == 0 ? nil : Text("\(unread) new")
    }

    @ViewBuilder
    private func trailing(for text: ReadingText) -> some View {
        if read.contains(text.id) {
            Image(systemName: "checkmark.circle.fill")
                .font(.title3)
                .foregroundStyle(.accent)
                .accessibilityLabel(Text("Read"))
        } else if text.id == nextID {
            Circle()
                .fill(Color.accentFill)
                .frame(width: 10, height: 10)
                .accessibilityLabel(Text("Next"))
        } else {
            LearnChevron()
        }
    }
}

/// One sample of each new kind of text, from every level, for the maintainer
/// to try before the kinds are written for each level. Temporary: it goes
/// once the kinds are picked.
struct NewKindsSection: View {
    let read: Set<String>
    let zoom: Namespace.ID
    let onOpen: (ReadingText) -> Void

    var body: some View {
        LearnSection(title: "New kinds to try", note: Text("Preview")) {
            WriteGlassList {
                ForEach(ReadingTexts.newKinds) { text in
                    LearnRow(systemImage: text.systemImage, title: Text(text.title),
                             detail: Text("\(text.level.title) · \(text.kind.title)"),
                             action: { onOpen(text) },
                             trailing: { trailing(for: text) })
                    .matchedTransitionSource(id: text.id, in: zoom)
                }
            }
        }
    }

    @ViewBuilder
    private func trailing(for text: ReadingText) -> some View {
        if read.contains(text.id) {
            Image(systemName: "checkmark.circle.fill")
                .font(.title3)
                .foregroundStyle(.accent)
                .accessibilityLabel(Text("Read"))
        } else {
            LearnChevron()
        }
    }
}
