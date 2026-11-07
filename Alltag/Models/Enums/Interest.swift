//
//  Interest.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// Topics the learner cares about (onboarding step 5 and Profile).
enum Interest: String, Codable, CaseIterable, Identifiable, Sendable {
    case housing
    case work
    case football
    case cooking
    case politics
    case travel
    case music
    case health

    var id: String { rawValue }

    var title: LocalizedStringResource {
        switch self {
        case .housing: "Housing"
        case .work: "Work"
        case .football: "Football"
        case .cooking: "Cooking"
        case .politics: "Politics"
        case .travel: "Travel"
        case .music: "Music"
        case .health: "Health"
        }
    }

    var systemImage: String {
        switch self {
        case .housing: "house"
        case .work: "briefcase"
        case .football: "soccerball"
        case .cooking: "fork.knife"
        case .politics: "building.columns"
        case .travel: "airplane"
        case .music: "music.note"
        case .health: "heart"
        }
    }

    /// Interests pre-selected in the prototype.
    static let defaultSelection: Set<Interest> = [.housing, .work, .cooking, .travel, .health]
}
