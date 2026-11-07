//
//  PermissionsStep.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Step 6: optional permissions that let Alltag learn from the learner's day.
struct PermissionsStep: View {
    @Bindable var model: OnboardingModel
    @Environment(\.services) private var services

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                StepHeader(title: "Learn from your day",
                           subtitle: "Each one is optional. You can change them any time in Settings.")
                VStack(spacing: 10) {
                    PermissionRow(title: "Calendar", subtitle: "Rehearse before appointments and trips",
                                  systemImage: "calendar", tint: Color(uiColor: .systemRed),
                                  isAllowed: model.allowsCalendar) {
                        model.allowsCalendar = await services.calendar.requestAccess() == .granted
                    }
                    PermissionRow(title: "Notifications", subtitle: "A gentle nudge, never more than twice a day",
                                  systemImage: "bell.fill", tint: Color(uiColor: .systemOrange),
                                  isAllowed: model.allowsNotifications) {
                        model.allowsNotifications = await services.notifications.requestAuthorization() == .granted
                    }
                    // The keyboard is added in the Settings app; setup instructions come with
                    // the keyboard extension (#56). Here the learner only opts in.
                    PermissionRow(title: "Alltag Keyboard", subtitle: "Corrections while you type in any app",
                                  systemImage: "keyboard", tint: Color(uiColor: .systemGray),
                                  isAllowed: model.usesKeyboard) {
                        model.usesKeyboard = true
                    }
                }
                Label {
                    Text("Everything you allow is processed on your iPhone. Nothing from your Calendar or keyboard is sent to the cloud.")
                        .textRole(.meta)
                        .foregroundStyle(.secondary)
                } icon: {
                    Image(systemName: "lock.fill")
                        .foregroundStyle(.success)
                }
                .padding(.horizontal, 4)
            }
        }
    }
}

/// A permission with its coloured symbol and an Allow / Allowed pill.
private struct PermissionRow: View {
    let title: LocalizedStringResource
    let subtitle: LocalizedStringResource
    let systemImage: String
    let tint: Color
    let isAllowed: Bool
    let request: () async -> Void

    var body: some View {
        HStack(spacing: 14) {
            SymbolSquare(systemImage: systemImage, tint: tint, foreground: .white, size: 36)
            VStack(alignment: .leading, spacing: 2) {
                Text(title).textRole(.cardTitle)
                Text(subtitle).textRole(.meta).foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Button {
                Task { await request() }
            } label: {
                Text(isAllowed ? "Allowed" : "Allow")
                    .textRole(.meta)
                    .fontWeight(.semibold)
                    .foregroundStyle(isAllowed ? AnyShapeStyle(.success) : AnyShapeStyle(Color(uiColor: .systemBackground)))
                    .padding(.horizontal, 14)
                    .frame(minHeight: 32)
                    .background(isAllowed ? AnyShapeStyle(.success.opacity(0.16)) : AnyShapeStyle(Color(uiColor: .label)),
                                in: .capsule)
                    .frame(minHeight: Spacing.minTouchTarget)
                    .contentShape(.rect)
            }
            .buttonStyle(.plain)
            // Not `.disabled`: that would dim the green "Allowed" pill.
            .allowsHitTesting(!isAllowed)
            .accessibilityRemoveTraits(isAllowed ? .isButton : [])
            .accessibilityLabel(isAllowed ? Text("\(Text(title)) allowed") : Text("Allow \(Text(title))"))
        }
        .padding(.horizontal, Spacing.card)
        .padding(.vertical, 14)
        .background(.surface, in: .rect(cornerRadius: Radius.innerCard, style: .continuous))
        .animation(.easeOut(duration: 0.2), value: isAllowed)
        .sensoryFeedback(.success, trigger: isAllowed) { _, allowed in allowed }
    }
}

#Preview {
    PermissionsStep(model: OnboardingModel())
        .padding(.horizontal, Spacing.onboarding)
        .background(.screenBackground)
}
