//
//  WriteHeroCard.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 14.11.26.
//

import SwiftUI

/// The task to write now: what it is, who it is to, and the big button. "New task"
/// asks the server for another one at the learner's level, length and kind.
struct WriteHeroCard: View {
    let task: WritingTask
    let length: WritingLength
    let kind: WritingKind?
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
            if let failure {
                Text(failure.message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .transition(.opacity)
            }
            GlassEffectContainer(spacing: 12) {
                VStack(alignment: .leading, spacing: 14) {
                    // Side by side where there is room, the button under the line at large text sizes.
                    ViewThatFits(in: .horizontal) {
                        HStack(spacing: 8) {
                            facts
                            Spacer(minLength: 8)
                            newTaskButton
                        }
                        VStack(alignment: .leading, spacing: 10) {
                            facts
                            newTaskButton
                        }
                    }
                    Button(action: onStart) {
                        Label("Start writing", systemImage: "pencil")
                    }
                    .buttonStyle(.primary)
                }
            }
        }
        .padding(Spacing.cardLarge)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
        .animation(.snappy, value: failure)
        .sensoryFeedback(.impact(weight: .medium), trigger: taps)
    }

    /// Sie or du, the length and the time.
    private var facts: some View {
        HStack(spacing: 8) {
            if !task.recipient.isEmpty { RegisterBadge(register: task.register) }
            Text("\(task.minWords)–\(task.maxWords) words · \(task.minutes) min")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
    }

    /// A small glass capsule, like the app's other secondary buttons.
    private var newTaskButton: some View {
        Button(action: askForNewTask) {
            Label {
                Text("New task")
            } icon: {
                if isLoading {
                    ProgressView().controlSize(.small)
                } else {
                    Image(systemName: "sparkles")
                }
            }
            .font(.subheadline.weight(.semibold))
            .lineLimit(1)
        }
        .buttonStyle(.glass)
        .buttonBorderShape(.capsule)
        .controlSize(.small)
        .disabled(isLoading)
        .accessibilityHint(Text("Writes a new task for your level."))
    }

    private func askForNewTask() {
        taps += 1
        isLoading = true
        failure = nil
        Task {
            defer { isLoading = false }
            do {
                let new = try await service.task(for: task.level, length: length, kind: kind,
                                                 excluding: RecentWritingTasks.titles)
                RecentWritingTasks.add(new.title)
                onNewTask(new)
            } catch {
                failure = CloudFailure(error)
            }
        }
    }
}
