//
//  ReadDoRound.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import Observation

/// The three tasks of a scene, one after the other: the learner taps the line
/// that answers the task. A wrong line turns coral and the learner looks
/// again; after two wrong lines the right one glows. Only a right line at the
/// first try counts, and all three right at the first try marks the scene as done.
@Observable
final class ReadDoRound {
    let scene: ReadDoScene
    /// The task on screen.
    private(set) var index = 0
    /// The wrong lines tapped for the task on screen.
    private(set) var wrongLines: Set<Int> = []
    /// The right line, once tapped.
    private(set) var rightLine: Int?
    /// Whether each done task was right at the first try, in order.
    private(set) var firstTries: [Bool] = []
    /// After the last task: the result is on screen.
    private(set) var isFinished = false

    init(scene: ReadDoScene) {
        self.scene = scene
    }

    var tasks: [ReadDoTask] { scene.tasks }
    var current: ReadDoTask? { tasks.indices.contains(index) ? tasks[index] : nil }
    var isAnswered: Bool { rightLine != nil }
    var isLastTask: Bool { index == tasks.count - 1 }
    var score: Int { firstTries.filter { $0 }.count }
    var isPassed: Bool { isFinished && score == tasks.count }

    /// The right line glows after two wrong ones, so nobody stays stuck.
    var hintLine: Int? {
        guard let current, !isAnswered, wrongLines.count >= 2 else { return nil }
        return scene.lines(answering: current).first?.id
    }

    /// Taps a line; `true` when it answers the task.
    @discardableResult
    func tap(_ line: ReadDoLine) -> Bool {
        guard let current, !isAnswered, !isFinished, line.isTappable, !wrongLines.contains(line.id) else { return false }
        if line.plain.contains(current.answer) {
            rightLine = line.id
            firstTries.append(wrongLines.isEmpty)
            return true
        }
        wrongLines.insert(line.id)
        return false
    }

    /// The next task, or the result after the last one.
    func next() {
        guard isAnswered else { return }
        if isLastTask {
            isFinished = true
        } else {
            index += 1
            wrongLines = []
            rightLine = nil
        }
    }

    func restart() {
        index = 0
        wrongLines = []
        rightLine = nil
        firstTries = []
        isFinished = false
    }
}
