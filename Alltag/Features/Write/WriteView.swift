//
//  WriteView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 10.11.26.
//

import SwiftData
import SwiftUI

/// Learn › Write: the learner says how much time they have and what they want to
/// write; the task of the day follows, with a new one on request, the written set
/// for the level, and their own topic. A task opens the writing screen, which
/// zooms out of the card or row it was tapped on.
struct WriteView: View {
    var level: Level = .a1
    @Environment(\.services) private var services
    @AppStorage(WritingLength.key) private var lengthRaw = WritingLength.standard.rawValue
    @AppStorage(WritingKind.key) private var kindRaw = ""
    @AppStorage(WritingDesignSwitcher.optionsKey) private var design = 0
    @State private var open: WritingTask?
    /// A task the server wrote for this visit; it takes the hero card's place.
    @State private var newTask: WritingTask?
    @Namespace private var transition

    private var length: WritingLength { WritingLength(rawValue: lengthRaw) ?? .standard }
    /// Nil for every kind.
    private var kind: WritingKind? { WritingKind.ofTasks.first { $0.rawValue == kindRaw } }
    private var picked: WritingTask { newTask ?? WritingTasks.picked(for: level, kind: kind).sized(length) }
    private var others: [WritingTask] {
        WritingTasks.tasks(for: level, kind: kind).filter { $0.id != picked.id }.map { $0.sized(length) }
    }
    private var own: WritingTask { .own(level: level, length: length) }

    var body: some View {
        LearnScreen(title: "Write") {
            WriteOptions(design: design, level: level,
                         length: Binding { length } set: { lengthRaw = $0.rawValue },
                         kind: Binding { kind } set: { kindRaw = $0?.rawValue ?? "" },
                         ownSource: transition, onOwn: { open = own })

            WriteHeroCard(task: picked, length: length, kind: kind, service: services.writing,
                          onStart: { open = picked }, onNewTask: { newTask = $0 })
                .matchedTransitionSource(id: picked.id, in: transition)

            // The tiles (design 3) have their own "My own topic".
            if design != 2 {
                LearnList {
                    LearnRow(systemImage: own.systemImage, title: Text(WritingKind.own.title),
                             detail: Text("Write what you like and get it corrected"), action: { open = own })
                }
                .matchedTransitionSource(id: own.id, in: transition)
            }

            if !others.isEmpty {
                LearnSection(title: "From daily life", note: Text("Tasks for \(level.title)")) {
                    LearnList {
                        ForEach(others) { task in
                            LearnRow(systemImage: task.systemImage, title: Text(verbatim: task.title),
                                     detail: WriteView.detail(of: task), action: { open = task },
                                     trailing: { if task.kind != .day { RegisterBadge(register: task.register) } })
                            .matchedTransitionSource(id: task.id, in: transition)
                        }
                    }
                }
            }
        }
        .toolbar {
            // TEMPORARY (#263): the designs for choosing the length and the kind.
            ToolbarItem(placement: .topBarTrailing) { WritingDesignSwitcher(key: WritingDesignSwitcher.optionsKey) }
        }
        .fullScreenCover(item: $open) { task in
            WritingSessionView(task: task, service: services.writing)
                .navigationTransition(.zoom(sourceID: task.id, in: transition))
        }
        // A task the server wrote was for the old choice.
        .onChange(of: lengthRaw) { _, _ in newTask = nil }
        .onChange(of: kindRaw) { _, _ in newTask = nil }
        .animation(.snappy, value: lengthRaw)
        .animation(.snappy, value: kindRaw)
        .sensoryFeedback(.impact(weight: .medium), trigger: open) { _, task in task != nil }
    }

    /// Who it is to (or that it is the learner's own), and how long it takes.
    static func detail(of task: WritingTask) -> Text {
        let who = task.recipient.isEmpty ? Text(task.kind.title) : Text(verbatim: task.recipient)
        return Text("\(who) · \(task.minutes) min")
    }
}

/// The titles of the tasks the server wrote lately, so it doesn't write the same again.
enum RecentWritingTasks {
    private static let key = "write.recentTasks"

    static var titles: [String] { UserDefaults.standard.stringArray(forKey: key) ?? [] }

    static func add(_ title: String) {
        UserDefaults.standard.set(Array((titles + [title]).suffix(20)), forKey: key)
    }
}

extension CloudFailure {
    /// One line for a small place, such as under a card.
    var message: LocalizedStringResource {
        switch self {
        case .offline: "You’re offline. A new task needs the internet."
        case .cloudOff: "Turn on “Talk and get corrections online” in Settings for new tasks."
        case .dailyLimit: "That’s all the new tasks for today. Try again tomorrow."
        case .other: "Couldn’t write a new task. Try again in a moment."
        }
    }
}

/// "Sie" or "du": how formal the text is.
struct RegisterBadge: View {
    let register: WritingTask.Register

    var body: some View {
        Text(verbatim: register == .formal ? "Sie" : "du")
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(register == .formal ? Color.accent : Color.secondary)
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .background(register == .formal ? Color.accent.opacity(0.14) : Color.secondary.opacity(0.14), in: .capsule)
            .accessibilityLabel(register == .formal ? Text("Formal") : Text("Informal"))
    }
}

#Preview {
    NavigationStack { WriteView(level: .a2) }
        .environment(AppState())
        .modelContainer(AlltagStore.preview)
}
