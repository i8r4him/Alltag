//
//  CloudFailure.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// Why a request to Alltag's server didn't work, so a screen can say so plainly.
enum CloudFailure: Equatable {
    /// No internet: no Wi‑Fi and no mobile data, or the connection dropped.
    case offline
    /// The learner hasn't allowed Alltag to use the cloud.
    case cloudOff
    /// The day's quota is used up.
    case dailyLimit
    case other

    init(_ error: any Error) {
        let offline: Set<URLError.Code> = [.notConnectedToInternet, .networkConnectionLost, .timedOut,
                                           .cannotFindHost, .cannotConnectToHost, .dataNotAllowed,
                                           .internationalRoamingOff]
        if let error = error as? URLError, offline.contains(error.code) {
            self = .offline
        } else if let error = error as? RealtimeServiceError {
            switch error {
            case .unavailable, .notConfigured: self = .cloudOff
            case .dailyLimit: self = .dailyLimit
            default: self = .other
            }
        } else {
            self = .other
        }
    }
}
