//
//  ReadView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 10.11.26.
//

import SwiftData
import SwiftUI

/// Learn › Read: texts from daily life at the learner's level, written for the
/// app. A text opens in the reader, zooming out of its card; its three
/// questions mark it as read, and it is kept in Your sessions.
struct ReadView: View {
    @Query private var profiles: [UserProfile]
    @Query(filter: #Predicate<SessionRecord> { $0.kindRaw == "reading" }) private var readRecords: [SessionRecord]
    @State private var taps = 0
    /// The text open in the reader, by its id.
    @State private var opened: String?
    @Namespace private var zoom

    private var level: Level { profiles.first?.level ?? .a1 }

    var body: some View {
        let texts = ReadingTexts.texts(at: level)
        let read = ReadingProgress.readIDs(in: readRecords)
        LearnScreen(title: "Read") {
            ReadSections(level: level, texts: texts, read: read, zoom: zoom, onOpen: open)
        }
        .sensoryFeedback(.impact(weight: .medium), trigger: taps)
        .navigationDestination(item: $opened) { id in
            if let text = ReadingTexts.text(id: id) {
                ReaderView(text: text)
                    .navigationTransition(.zoom(sourceID: id, in: zoom))
            }
        }
    }

    private func open(_ text: ReadingText) {
        taps += 1
        opened = text.id
    }
}

#Preview {
    NavigationStack { ReadView() }
        .modelContainer(AlltagStore.preview)
}
