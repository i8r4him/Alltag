//
//  DailyTime.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// How long the learner wants to practise each day (onboarding step 4).
enum DailyTime: Int, Codable, CaseIterable, Identifiable, Sendable {
    case five = 5
    case ten = 10
    case twenty = 20

    var id: Int { rawValue }
    var minutes: Int { rawValue }
    var title: LocalizedStringResource { "\(rawValue) min" }

    var subtitle: LocalizedStringResource {
        switch self {
        case .five: "A small daily habit"
        case .ten: "Steady progress"
        case .twenty: "Serious about it"
        }
    }

    var systemImage: String {
        switch self {
        case .five: "hourglass.bottomhalf.filled"
        case .ten: "hourglass"
        case .twenty: "hourglass.tophalf.filled"
        }
    }
}

/// When the daily reminder arrives (onboarding step 4).
enum NudgeTime: String, Codable, CaseIterable, Identifiable, Sendable {
    case morning
    case evening

    var id: String { rawValue }

    var title: LocalizedStringResource {
        switch self {
        case .morning: "Morning"
        case .evening: "Evening"
        }
    }
}
