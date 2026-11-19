//
//  LearnPage.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftData
import SwiftUI

/// What the page shows: the lesson, the parts, and how to open things.
struct LearnPageContent {
    let level: Level
    let steps: [LessonStep]
    let overview: LearnOverview
    let zoom: Namespace.ID
    /// Opens a step of the lesson, or one thing in a part.
    let open: (LessonTarget) -> Void
    /// Opens the screen with all of a part.
    let openPart: (LearnPart) -> Void
}

/// Everything on Learn under the "How do I say …?" field and the tools. Learn
/// answers one question, "what do I do now?": Today's lesson (one thing from
/// each part), then the four parts as doors with only their progress. All of
/// a part's content is inside its door, with the same step from the lesson on
/// top as "Next for you".
struct LearnPage: View {
    let level: Level

    @Environment(AppState.self) private var appState
    @Environment(\.services) private var services
    @Query private var solved: [SolvedRule]
    @Query(filter: #Predicate<SessionRecord> { $0.kindRaw == "reading" || $0.kindRaw == "writing" })
    private var sessions: [SessionRecord]
    @Query(filter: #Predicate<MemoryItem> { $0.sourceRaw == "collection" }) private var collectionWords: [MemoryItem]
    @Query(MistakePractice.practisable) private var mistakes: [MemoryItem]
    /// The day the learner practised their mistakes from the lesson.
    @AppStorage("dailyLesson.mistakesDay") private var mistakesDay = ""
    /// A text or a "Read and do" scene, pushed like Read pushes it.
    @State private var reading: LessonTarget?
    /// A chat or a word collection, as a sheet like Write and the collections show them.
    @State private var sheet: LessonTarget?
    @State private var opens = 0
    @Namespace private var zoom

    var body: some View {
        let records = DailyLesson.Records(solvedRules: solved, sessions: sessions, collectionWords: collectionWords,
                                          dueMistakes: MistakePractice.due(mistakes).count,
                                          fixedMistakesToday: mistakesDay == DailyLesson.dayKey())
        let content = LearnPageContent(
            level: level,
            steps: DailyLesson.steps(at: level, records: records),
            overview: LearnOverview.make(at: level, solvedRules: solved, sessions: sessions,
                                         collectionWords: collectionWords),
            zoom: zoom, open: open, openPart: open)
        LearnHubLayout(content: content)
            .fontDesign(.rounded)
            .sensoryFeedback(.impact(weight: .medium), trigger: opens)
            .navigationDestination(item: $reading) { target in
                readingView(for: target)
                    .navigationTransition(.zoom(sourceID: target, in: zoom))
            }
            .sheet(item: $sheet) { target in
                sheetView(for: target)
                    .navigationTransition(.zoom(sourceID: target, in: zoom))
            }
    }

    private func open(_ target: LessonTarget) {
        opens += 1
        switch target {
        case .rule(let id):
            appState.open(.rule(id: id))
        case .text, .scene:
            reading = target
        case .chat, .collection:
            sheet = target
        case .mistakes:
            mistakesDay = DailyLesson.dayKey()
            appState.present(.activity(.mistakes))
        }
    }

    private func open(_ part: LearnPart) {
        opens += 1
        appState.open(part.route)
    }

    @ViewBuilder
    private func readingView(for target: LessonTarget) -> some View {
        switch target {
        case .text(let id):
            if let text = ReadingTexts.text(id: id) { ReaderView(text: text) }
        case .scene(let id):
            if let scene = ReadDoScenes.scene(id: id) { ReadDoView(scene: scene) }
        default:
            EmptyView()
        }
    }

    @ViewBuilder
    private func sheetView(for target: LessonTarget) -> some View {
        switch target {
        case .chat(let id):
            if let chat = WritingContent.chats(at: level).first(where: { $0.id == id }) {
                ChatView(chat: chat, level: level, service: services.writing)
            }
        case .collection(let id):
            if let collection = WordCollections.collection(id: id) { WordCollectionSheet(collection: collection) }
        default:
            EmptyView()
        }
    }
}
