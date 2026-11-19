//
//  LearnPage.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftData
import SwiftUI

/// The page designs to pick from, behind the temporary switcher.
enum LearnPageDesign: Int, CaseIterable {
    case hub, nextUp, shelves, list

    /// The design's working name, only for talking about it while one is picked.
    var name: String {
        switch self {
        case .hub: "Hub"
        case .nextUp: "Next up"
        case .shelves: "Shelves"
        case .list: "List"
        }
    }
}

/// What a page design needs: the lesson, the parts, and how to open things.
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

/// Everything on Learn under the "How do I say …?" field and the tools:
/// Today's lesson, then the parts (Grammar, Read, Write, Words, Listen). It
/// reads the learner's progress once and opens what the designs tap, so every
/// design opens the same screens the same way.
///
/// Four page designs sit behind a temporary "‹ n / 4 ›" switcher until the
/// maintainer picks one.
struct LearnPage: View {
    let level: Level
    @Binding var notice: ToastMessage?

    @Environment(AppState.self) private var appState
    @Environment(\.services) private var services
    @Query private var solved: [SolvedRule]
    @Query(filter: #Predicate<SessionRecord> { $0.kindRaw == "reading" || $0.kindRaw == "writing" })
    private var sessions: [SessionRecord]
    @Query(filter: #Predicate<MemoryItem> { $0.sourceRaw == "collection" }) private var collectionWords: [MemoryItem]
    @Query(MistakePractice.practisable) private var mistakes: [MemoryItem]
    @AppStorage("learnPage.design") private var design = 0
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
        VStack(alignment: .leading, spacing: 12) {
            LearnPageSwitcher(design: $design)
                .frame(maxWidth: .infinity, alignment: .trailing)
            switch LearnPageDesign(rawValue: design) ?? .hub {
            case .hub: LearnHubLayout(content: content, notice: $notice)
            case .nextUp: LearnNextUpLayout(content: content)
            case .shelves: LearnShelvesLayout(content: content)
            case .list: LearnListLayout(content: content)
            }
        }
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

/// The temporary "Hub ‹ 1 / 4 ›" switcher between the page designs; it goes
/// once the maintainer has picked one.
private struct LearnPageSwitcher: View {
    @Binding var design: Int

    private var count: Int { LearnPageDesign.allCases.count }
    private var current: LearnPageDesign { LearnPageDesign(rawValue: design) ?? .hub }

    var body: some View {
        HStack(spacing: 0) {
            Button { step(by: -1) } label: {
                Image(systemName: "chevron.left")
                    .frame(width: 36, height: 36)
                    .contentShape(.rect)
            }
            .accessibilityLabel(Text("Previous design"))
            Text(verbatim: "\(current.name) · \(current.rawValue + 1) / \(count)")
                .monospacedDigit()
            Button { step(by: 1) } label: {
                Image(systemName: "chevron.right")
                    .frame(width: 36, height: 36)
                    .contentShape(.rect)
            }
            .accessibilityLabel(Text("Next design"))
        }
        .buttonStyle(.plain)
        .font(.subheadline.weight(.semibold))
        .padding(.horizontal, 4)
        .glassEffect(.regular.interactive(), in: .capsule)
        .sensoryFeedback(.selection, trigger: design)
    }

    private func step(by offset: Int) {
        withAnimation(.smooth) {
            design = (current.rawValue + offset + count) % count
        }
    }
}
