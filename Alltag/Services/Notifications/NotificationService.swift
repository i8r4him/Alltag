//
//  NotificationService.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import Foundation

/// Schedules the daily practice reminder.
protocol NotificationService: AnyObject {
    var authorizationStatus: PermissionStatus { get }
    func requestAuthorization() async -> PermissionStatus
    /// Replaces any existing reminder with one at `time` every day.
    func scheduleDailyNudge(at time: NudgeTime) async throws
    func cancelDailyNudge() async
}

/// Remembers the scheduled reminder without involving the system. The live
/// service uses UserNotifications (#52).
@Observable
final class MockNotificationService: NotificationService {
    private(set) var authorizationStatus: PermissionStatus = .notDetermined
    private(set) var scheduledNudge: NudgeTime?

    func requestAuthorization() async -> PermissionStatus {
        authorizationStatus = .granted
        return authorizationStatus
    }

    func scheduleDailyNudge(at time: NudgeTime) async throws {
        scheduledNudge = time
    }

    func cancelDailyNudge() async {
        scheduledNudge = nil
    }
}
