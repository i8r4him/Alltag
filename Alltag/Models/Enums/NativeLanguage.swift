//
//  NativeLanguage.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The learner's native language (onboarding step 1).
enum NativeLanguage: String, Codable, CaseIterable, Identifiable, Sendable {
    case english
    case arabic
    case turkish
    case spanish
    case ukrainian
    case other

    var id: String { rawValue }

    var title: LocalizedStringResource {
        switch self {
        case .english: "English"
        case .arabic: "Arabic"
        case .turkish: "Turkish"
        case .spanish: "Spanish"
        case .ukrainian: "Ukrainian"
        case .other: "Other"
        }
    }
}
