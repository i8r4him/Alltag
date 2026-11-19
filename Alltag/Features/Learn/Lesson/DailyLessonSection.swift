//
//  DailyLessonSection.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftData
import SwiftUI

extension LessonTarget: Identifiable {
    var id: Self { self }
}

/// "Today's lesson" at the top of Learn: one thing from each part, played one
/// after another. Each step opens the exercise Learn already has; when the
/// learner comes back having finished it, the lesson has moved on to the next.
///
/// Three designs sit behind a temporary "‹ n / 3 ›" switcher until the
/// maintainer picks one. The section reads its own data, so finishing a step
/// redraws the lesson, not all of Learn.
struct DailyLessonSection: View {
    /// The learner's level, from their profile.
    let level: Level

    @Environment(AppState.self) private var appState
    @Environment(\.services) private var services
    @Query private var solved: [SolvedRule]
    @Query(filter: #Predicate<SessionRecord> { $0.kindRaw == "reading" || $0.kindRaw == "writing" })
    private var sessions: [SessionRecord]
    @Query(filter: #Predicate<MemoryItem> { $0.sourceRaw == "collection" }) private var collectionWords: [MemoryItem]
    @Query(MistakePractice.practisable) private var mistakes: [MemoryItem]
    /// Which of the three designs is shown, while one is picked.
    @AppStorage("dailyLesson.design") private var design = 0
    /// The day the learner practised their mistakes from the lesson.
    @AppStorage("dailyLesson.mistakesDay") private var mistakesDay = ""
    /// A text or a "Read and do" scene, pushed like Read pushes it.
    @State private var reading: LessonTarget?
    /// A chat or a word collection, as a sheet like Write and the collections show them.
    @State private var sheet: LessonTarget?
    @State private var opens = 0
    @Namespace private var zoom

    private var records: DailyLesson.Records {
        DailyLesson.Records(solvedRules: solved, sessions: sessions, collectionWords: collectionWords,
                            dueMistakes: MistakePractice.due(mistakes).count,
                            fixedMistakesToday: mistakesDay == DailyLesson.dayKey())
    }

    var body: some View {
        let steps = DailyLesson.steps(at: level, records: records)
        if !steps.isEmpty {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Today’s lesson")
                        .textRole(.sectionHeader)
                    Spacer()
                    LessonDesignSwitcher(design: $design, count: 3)
                }
                .padding(.horizontal, 4)
                switch design {
                case 1: LessonPathDesign(steps: steps, zoom: zoom, onOpen: open)
                case 2: LessonDeckDesign(steps: steps, zoom: zoom, onOpen: open)
                default: LessonCardDesign(level: level, steps: steps, zoom: zoom, onOpen: open)
                }
            }
            .fontDesign(.rounded)
            .animation(.smooth, value: design)
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
    }

    private func open(_ step: LessonStep) {
        opens += 1
        switch step.target {
        case .rule(let id):
            appState.open(.rule(id: id))
        case .text, .scene:
            reading = step.target
        case .chat, .collection:
            sheet = step.target
        case .mistakes:
            mistakesDay = DailyLesson.dayKey()
            appState.present(.activity(.mistakes))
        }
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

/// The temporary "‹ 1 / 3 ›" switcher between the lesson's designs; it goes
/// once the maintainer has picked one.
private struct LessonDesignSwitcher: View {
    @Binding var design: Int
    let count: Int

    var body: some View {
        HStack(spacing: 0) {
            Button { step(by: -1) } label: {
                Image(systemName: "chevron.left")
                    .frame(width: 36, height: 36)
                    .contentShape(.rect)
            }
            .accessibilityLabel(Text("Previous design"))
            Text(verbatim: "\(design + 1) / \(count)")
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
        design = (design + offset + count) % count
    }
}

/// A part of the lesson as a small circle: its symbol, a ring when it's next,
/// filled with a tick once done.
struct LessonStepDot: View {
    let step: LessonStep
    let isCurrent: Bool
    var size: CGFloat = 44

    var body: some View {
        ZStack {
            Circle()
                .fill(step.isDone ? AnyShapeStyle(.accentFill) : AnyShapeStyle(.controlFill))
            if isCurrent {
                Circle()
                    .strokeBorder(.accentFill, lineWidth: 2)
            }
            Image(systemName: step.isDone ? "checkmark" : step.part.systemImage)
                .font(.system(size: size * 0.38, weight: .semibold))
                .foregroundStyle(symbolStyle)
        }
        .frame(width: size, height: size)
        .accessibilityHidden(true)
    }

    private var symbolStyle: AnyShapeStyle {
        if step.isDone { return AnyShapeStyle(.onAccent) }
        return isCurrent ? AnyShapeStyle(.accent) : AnyShapeStyle(.secondary)
    }
}
