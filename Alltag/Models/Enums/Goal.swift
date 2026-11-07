//
//  Goal.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// Why the learner is learning German (onboarding step 2).
enum Goal: String, Codable, CaseIterable, Identifiable, Sendable {
    case livingHere
    case work
    case partnerAndFamily
    case studies
    case travel

    var id: String { rawValue }

    var title: LocalizedStringResource {
        switch self {
        case .livingHere: "Living here"
        case .work: "Work"
        case .partnerAndFamily: "Partner & family"
        case .studies: "Studies"
        case .travel: "Travel"
        }
    }

    var subtitle: LocalizedStringResource {
        switch self {
        case .livingHere: "Appointments, neighbours, everyday life"
        case .work: "Meetings, emails, colleagues"
        case .partnerAndFamily: "Conversations that matter most"
        case .studies: "Lectures, reading, exams"
        case .travel: "Getting around with confidence"
        }
    }

    /// What the learner is working towards, for the Profile's goal card.
    var statement: LocalizedStringResource {
        switch self {
        case .livingHere: "Feel at home here — appointments, neighbours, work."
        case .work: "Hold my own at work — meetings, emails, small talk."
        case .partnerAndFamily: "Really talk with the people who matter most."
        case .studies: "Follow lectures and write with confidence."
        case .travel: "Get around anywhere without switching to English."
        }
    }

    var systemImage: String {
        switch self {
        case .livingHere: "house"
        case .work: "briefcase"
        case .partnerAndFamily: "heart"
        case .studies: "graduationcap"
        case .travel: "airplane"
        }
    }
}
