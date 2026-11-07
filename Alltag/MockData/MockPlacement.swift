//
//  MockPlacement.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The prototype's one-question placement test (onboarding step 3).
enum MockPlacement {
    static let question = PlacementQuestion(
        question: "Wie war dein Wochenende?",
        instruction: "How was your weekend? Pick what you'd naturally say.",
        answers: [
            PlacementQuestion.Answer(german: "Gut. Ich war zu Hause.", level: .a2),
            PlacementQuestion.Answer(german: "Schön! Wir sind nach Potsdam gefahren und haben gegrillt.", level: .b1),
            PlacementQuestion.Answer(german: "Entspannt, obwohl ich eigentlich mehr erledigen wollte.", level: .b2)
        ]
    )

    /// Confirmation shown after picking an answer.
    static func confirmation(for level: Level) -> String {
        "Sounds like \(level.rawValue). We'll fine-tune it in your first conversations."
    }
}
