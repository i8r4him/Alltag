//
//  MockProgress.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The prototype's Progress screen data.
enum MockProgress {
    typealias Situation = ProgressReport.Situation
    typealias Skill = ProgressReport.Skill

    static let report = ProgressReport(
        progressToNextLevel: 0.62,
        summary: "You follow most everyday conversations and can handle appointments on the phone. "
            + "Next: speaking about opinions and plans.",
        nextLevelTarget: "by summer 2027",
        situations: [
            Situation(name: "At the doctor", confidence: .confident),
            Situation(name: "Shops & cafés", confidence: .confident),
            Situation(name: "Trains & travel", confidence: .gettingThere),
            Situation(name: "Phone calls", confidence: .gettingThere),
            Situation(name: "Landlord & contracts", confidence: .shaky),
            Situation(name: "Sharing opinions", confidence: .shaky)
        ],
        skills: [
            Skill(name: "Listening", value: 0.71, change: 6),
            Skill(name: "Reading", value: 0.78, change: 4),
            Skill(name: "Speaking", value: 0.54, change: 9),
            Skill(name: "Writing", value: 0.49, change: 0)
        ],
        wordsStuck: 0.86,
        wordsStuckHistory: [0.52, 0.58, 0.55, 0.63, 0.70, 0.68, 0.76, 0.86],
        minutesSpoken: 42,
        spokenNote: "Your answers grew from 4 to 9 words on average.",
        conversations: 11,
        attention: [
            ProgressReport.Attention(title: "Verb at the end after „wenn“ & „weil“",
                                     reason: "Came up in 4 of your last 6 conversations"),
            ProgressReport.Attention(title: "„seit“ vs. „für“ with time",
                                     reason: "3 times in Messages this week")
        ],
        howYouLearn: [
            "Most new words come from **reading in Safari** — 70% this month.",
            "You remember words better when you **say them out loud** within a day.",
            "Evenings after 8 pm are your most focused time."
        ]
    )
}
