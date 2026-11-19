//
//  ReadDoView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftData
import SwiftUI

/// Learn › Read › Read and do: the thing drawn as it looks, and a task on
/// glass at the bottom. The learner taps the line that answers it; three
/// right at the first try keep the scene in Your sessions as done.
struct ReadDoView: View {
    @State private var round: ReadDoRound
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @State private var notice: ToastMessage?

    init(scene: ReadDoScene) {
        _round = State(initialValue: ReadDoRound(scene: scene))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.section) {
                header
                ReadDoSheet(scene: round.scene, status: status, onTap: tap)
            }
            .padding(.horizontal, Spacing.screen)
            .padding(.top, 8)
            .padding(.bottom, 24)
        }
        .scrollIndicators(.hidden)
        .scrollEdgeEffectStyle(.soft, for: .all)
        .fontDesign(.rounded)
        .readableContentMargins()
        .skyBackground()
        .navigationTitle(Text(round.scene.title))
        .toolbarTitleDisplayMode(.inline)
        .safeAreaInset(edge: .bottom) { taskCard }
        .sensoryFeedback(.success, trigger: round.rightLine) { _, line in line != nil }
        .sensoryFeedback(.error, trigger: round.wrongLines.count) { old, new in new > old }
        .animation(.easeOut(duration: 0.25), value: round.index)
        .animation(.easeOut(duration: 0.25), value: round.isFinished)
        .toast($notice)
    }

    private var header: some View {
        Label {
            Text("\(Text(round.scene.kind.title)) · \(round.scene.level.title)")
        } icon: {
            Image(systemName: round.scene.systemImage)
        }
        .font(.footnote.weight(.heavy))
        .textCase(.uppercase)
        .foregroundStyle(.accent)
    }

    private func status(of line: ReadDoLine) -> ReadDoSheet.LineStatus {
        if round.rightLine == line.id { return .right }
        if round.wrongLines.contains(line.id) { return .wrong }
        if round.hintLine == line.id { return .hint }
        return .open
    }

    private func tap(_ line: ReadDoLine) {
        round.tap(line)
    }

    private func next() {
        round.next()
        guard round.isPassed else { return }
        do {
            try ReadingProgress.markDone(round.scene, in: context)
        } catch {
            notice = ToastMessage(text: "Couldn’t save it. Try again.", systemImage: "exclamationmark.triangle")
        }
    }

    private var taskCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            if round.isFinished {
                ReadDoResult(round: round, onDone: { dismiss() })
            } else if let task = round.current {
                taskView(task)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
        .padding(.horizontal, Spacing.screen)
        .padding(.bottom, 8)
    }

    private func taskView(_ task: ReadDoTask) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("Task \(round.index + 1) of \(round.tasks.count)")
                    .font(.footnote.weight(.heavy))
                    .textCase(.uppercase)
                    .foregroundStyle(.accent)
                Spacer()
                TaskPips(count: round.tasks.count, done: round.firstTries.count)
            }
            Text(verbatim: task.prompt)
                .font(.title3.weight(.bold))
                .fixedSize(horizontal: false, vertical: true)
            if round.isAnswered {
                let title: LocalizedStringKey = round.isLastTask ? "See the result" : "Next task"
                Button(action: next) { Text(title) }
                    .buttonStyle(.primary)
            } else {
                Label { Text(hint) } icon: { Image(systemName: "hand.tap.fill") }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .id(round.index)
        .transition(.opacity.combined(with: .move(edge: .trailing)))
    }

    private var hint: LocalizedStringResource {
        if round.hintLine != nil { return "The answer is glowing. Tap it." }
        if !round.wrongLines.isEmpty { return "Not that one. Look again." }
        return "Tap the answer in it."
    }
}

/// A short bar per task, lit once it is done.
private struct TaskPips: View {
    let count: Int
    let done: Int

    var body: some View {
        HStack(spacing: 5) {
            ForEach(0..<count, id: \.self) { index in
                Capsule()
                    .fill(index < done ? Color.accentFill : Color.primary.opacity(0.18))
                    .frame(width: 22, height: 5)
            }
        }
        .accessibilityHidden(true)
    }
}

/// After the last task: done, or once more.
private struct ReadDoResult: View {
    let round: ReadDoRound
    let onDone: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: round.isPassed ? "checkmark.seal.fill" : "arrow.counterclockwise.circle.fill")
                .font(.system(size: 44))
                .foregroundStyle(.accent)
                .symbolEffect(.bounce, value: round.isFinished)
                .accessibilityHidden(true)
            VStack(spacing: 4) {
                if round.isPassed {
                    Text("All three right")
                        .font(.title3.weight(.bold))
                    Text("Done. It’s kept in Your sessions.")
                        .foregroundStyle(.secondary)
                } else {
                    Text("\(round.score) of \(round.tasks.count) right at the first try")
                        .font(.title3.weight(.bold))
                    Text("Look at it once more, then try again.")
                        .foregroundStyle(.secondary)
                }
            }
            .multilineTextAlignment(.center)
            .accessibilityElement(children: .combine)
            if round.isPassed {
                Button(action: onDone) { Text("Done") }
                    .buttonStyle(.primary)
            } else {
                Button { round.restart() } label: { Text("Try again") }
                    .buttonStyle(.primary)
            }
        }
        .frame(maxWidth: .infinity)
        .transition(.opacity.combined(with: .scale(scale: 0.95)))
    }
}

#Preview {
    NavigationStack { ReadDoView(scene: ReadDoScenes.a1Bakery) }
        .modelContainer(AlltagStore.preview)
}
