//
//  WriteView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 10.11.26.
//

import SwiftData
import SwiftUI

/// Learn › Write: today's task for the learner's level, a new one on request,
/// and the written set for that level. A task opens the writing screen, which
/// zooms out of the card or row it was tapped on.
struct WriteView: View {
    var level: Level = .a1
    @Environment(\.services) private var services
    @State private var open: WritingTask?
    /// A task the server wrote for this visit; it takes the hero card's place.
    @State private var newTask: WritingTask?
    @Namespace private var transition

    private var picked: WritingTask { newTask ?? WritingTasks.picked(for: level) }
    private var others: [WritingTask] { WritingTasks.tasks(for: level).filter { $0.id != picked.id } }

    var body: some View {
        LearnScreen(title: "Write") {
            WriteHeroCard(task: picked, service: services.writing, onStart: { open = picked }, onNewTask: { newTask = $0 })
                .matchedTransitionSource(id: picked.id, in: transition)

            LearnSection(title: "From daily life", note: Text("Tasks for \(level.title). Each one says who it is to and what to say.")) {
                LearnList {
                    ForEach(others) { task in
                        LearnRow(systemImage: task.systemImage, title: Text(verbatim: task.title),
                                 detail: Text("\(Text(verbatim: task.recipient)) · \(task.minutes) min"), action: { open = task },
                                 trailing: { RegisterBadge(register: task.register) })
                        .matchedTransitionSource(id: task.id, in: transition)
                    }
                }
            }
        }
        .fullScreenCover(item: $open) { task in
            WritingSessionView(task: task, service: services.writing)
                .navigationTransition(.zoom(sourceID: task.id, in: transition))
        }
        .sensoryFeedback(.impact(weight: .medium), trigger: open) { _, task in task != nil }
    }
}

/// The task to write now: what it is, who it is to, and the big button. "New task"
/// asks the server for another one at the learner's level.
private struct WriteHeroCard: View {
    let task: WritingTask
    let service: any WritingService
    let onStart: () -> Void
    let onNewTask: (WritingTask) -> Void

    @State private var isLoading = false
    @State private var failure: CloudFailure?
    @State private var taps = 0
    @ScaledMetric(relativeTo: .title3) private var artworkSize: CGFloat = 80

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .top, spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    Label(task.isGenerated ? "New for you" : "Picked for today",
                          systemImage: task.isGenerated ? "sparkles" : "calendar")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.accent)
                    Text(verbatim: task.title)
                        .font(.title3.weight(.semibold))
                    Text(verbatim: task.situation)
                        .foregroundStyle(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityElement(children: .combine)
                ScenarioArtwork(systemImage: task.systemImage, symbolSize: 34)
                    .frame(width: artworkSize, height: artworkSize)
            }
            HStack(spacing: 8) {
                RegisterBadge(register: task.register)
                Text("\(task.minWords)–\(task.maxWords) words · \(task.minutes) min")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            if let failure {
                Text(failure.message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .transition(.opacity)
            }
            GlassEffectContainer(spacing: 12) {
                HStack(spacing: 12) {
                    Button(action: onStart) {
                        Label("Start writing", systemImage: "pencil")
                    }
                    .buttonStyle(.primary)
                    Button(action: askForNewTask) {
                        Group {
                            if isLoading {
                                ProgressView()
                            } else {
                                Image(systemName: "sparkles")
                            }
                        }
                        .font(.title3.weight(.semibold))
                        .frame(width: 56, height: 56)
                    }
                    .buttonStyle(.glass)
                    .buttonBorderShape(.circle)
                    .disabled(isLoading)
                    .accessibilityLabel(Text("New task"))
                    .accessibilityHint(Text("Writes a new task for your level."))
                }
            }
        }
        .padding(Spacing.cardLarge)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
        .animation(.snappy, value: failure)
        .sensoryFeedback(.impact(weight: .medium), trigger: taps)
    }

    private func askForNewTask() {
        taps += 1
        isLoading = true
        failure = nil
        Task {
            defer { isLoading = false }
            do {
                let new = try await service.task(for: task.level, excluding: RecentWritingTasks.titles)
                RecentWritingTasks.add(new.title)
                onNewTask(new)
            } catch {
                failure = CloudFailure(error)
            }
        }
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
