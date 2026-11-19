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
/// questions mark it as read, and it is kept in Your sessions. Under them,
/// "Read and do" (tap the answer in the real thing) and "Read from the web"
/// (any German article, shared or pasted).
struct ReadView: View {
    @Query private var profiles: [UserProfile]
    @Query(filter: #Predicate<SessionRecord> { $0.kindRaw == "reading" }) private var readRecords: [SessionRecord]
    @State private var taps = 0
    /// The text open in the reader, by its id.
    @State private var opened: String?
    /// The "Read and do" scene open, by its id.
    @State private var openedScene: String?
    /// The article from the web open.
    @State private var openedWeb: WebSource?
    /// Links shared to Alltag from the share sheet, read from the App Group.
    @State private var shared: [URL] = []
    @Environment(\.scenePhase) private var scenePhase
    @Namespace private var zoom

    private var level: Level { profiles.first?.level ?? .a1 }

    var body: some View {
        let texts = ReadingTexts.texts(at: level)
        let read = ReadingProgress.readIDs(in: readRecords)
        LearnScreen(title: "Read") {
            if let step = DailyLesson.step(.read, at: level, records: .init(sessions: readRecords)) {
                NextForYouCard(step: step) { open(step.target) }
            }
            ReadTextsSection(level: level, texts: texts, read: read, zoom: zoom, onOpen: open)
            ReadDoSection(level: level, done: read, zoom: zoom, onOpen: open)
            WebReadingSection(level: level, saved: WebArticles.saved(in: readRecords), shared: shared, onOpen: open)
        }
        .onAppear(perform: refreshShared)
        .onChange(of: scenePhase) { _, phase in
            if phase == .active { refreshShared() }
        }
        .sensoryFeedback(.impact(weight: .medium), trigger: taps)
        .navigationDestination(item: $opened) { id in
            if let text = ReadingTexts.text(id: id) {
                ReaderView(text: text)
                    .navigationTransition(.zoom(sourceID: id, in: zoom))
            }
        }
        .navigationDestination(item: $openedWeb) { source in
            WebArticleView(source: source, level: level)
        }
        .navigationDestination(item: $openedScene) { id in
            if let scene = ReadDoScenes.scene(id: id) {
                ReadDoView(scene: scene)
                    .navigationTransition(.zoom(sourceID: id, in: zoom))
            }
        }
    }

    private func open(_ text: ReadingText) {
        taps += 1
        opened = text.id
    }

    private func open(_ source: WebSource) {
        taps += 1
        openedWeb = source
    }

    private func refreshShared() {
        shared = WebArticles.shared(skipping: WebArticles.saved(in: readRecords))
    }

    /// Today's lesson's text or "Read and do" scene, from "Next for you".
    private func open(_ target: LessonTarget) {
        switch target {
        case .text(let id): if let text = ReadingTexts.text(id: id) { open(text) }
        case .scene(let id): if let scene = ReadDoScenes.scene(id: id) { open(scene) }
        default: break
        }
    }

    private func open(_ scene: ReadDoScene) {
        taps += 1
        openedScene = scene.id
    }
}

#Preview {
    NavigationStack { ReadView() }
        .modelContainer(AlltagStore.preview)
}
