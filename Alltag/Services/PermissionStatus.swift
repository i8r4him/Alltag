//
//  PermissionStatus.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// The state of a system permission (Notifications, Speech).
enum PermissionStatus: Equatable, Sendable {
    case notDetermined
    case granted
    case denied
}
