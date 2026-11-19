//
//  ReadingQuiz.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation
import Observation

/// The three questions after a text, one after the other. A wrong pick lights
/// up the sentence that holds the answer and the learner tries again; only a
/// right answer at the first try counts. All three right at the first try
/// marks the text as read.
@Observable
final class ReadingQuiz {
    let questions: [ReadingQuestion]
    /// The question on screen.
    private(set) var index = 0
    /// The wrong options picked for the question on screen.
    private(set) var wrongPicks: Set<Int> = []
    /// The right option has been picked for the question on screen.
    private(set) var isAnswered = false
    /// Whether each answered question was right at the first try, in order.
    private(set) var firstTries: [Bool] = []
    /// After the last question: the result is on screen.
    private(set) var isFinished = false

    init(questions: [ReadingQuestion]) {
        self.questions = questions
    }

    var current: ReadingQuestion? { questions.indices.contains(index) ? questions[index] : nil }
    var isLastQuestion: Bool { index == questions.count - 1 }
    var score: Int { firstTries.filter { $0 }.count }
    /// Every question right at the first try.
    var isPassed: Bool { isFinished && score == questions.count }

    /// The sentence to light up in the text: after a wrong pick, until the next question.
    var evidence: String? {
        guard !isFinished, !wrongPicks.isEmpty else { return nil }
        return current?.evidence
    }

    /// Picks an option; `true` when it is the right one.
    @discardableResult
    func pick(_ option: Int) -> Bool {
        guard let current, !isAnswered, !isFinished, !wrongPicks.contains(option) else { return false }
        if option == current.answer {
            isAnswered = true
            firstTries.append(wrongPicks.isEmpty)
            return true
        }
        wrongPicks.insert(option)
        return false
    }

    /// The next question, or the result after the last one.
    func next() {
        guard isAnswered else { return }
        if isLastQuestion {
            isFinished = true
        } else {
            index += 1
            wrongPicks = []
            isAnswered = false
        }
    }

    /// From the first question again, after reading the text once more.
    func restart() {
        index = 0
        wrongPicks = []
        isAnswered = false
        firstTries = []
        isFinished = false
    }
}
