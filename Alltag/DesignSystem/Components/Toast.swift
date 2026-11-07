//
//  Toast.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// A short confirmation shown at the bottom of the screen, e.g. "Saved to Memory".
struct ToastMessage: Equatable, Identifiable {
    let id = UUID()
    let text: LocalizedStringResource
    var systemImage = "checkmark.circle.fill"
}

/// The toast capsule itself. Show it with `.toast(_:)`.
struct ToastView: View {
    let message: ToastMessage

    var body: some View {
        Label {
            Text(message.text)
        } icon: {
            Image(systemName: message.systemImage).foregroundStyle(.success)
        }
        .textRole(.bodySmall)
        .fontWeight(.medium)
        .padding(.horizontal, 18)
        .frame(minHeight: Spacing.minTouchTarget)
        .glassEffect(.regular, in: .capsule)
    }
}

private struct ToastModifier: ViewModifier {
    @Binding var message: ToastMessage?
    var duration: Duration = .seconds(2)
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottom) {
                if let message {
                    ToastView(message: message)
                        .padding(.bottom, 96) // clears the Smart Bar
                        .transition(Motion.modalTransition(reduceMotion: reduceMotion))
                        .task(id: message.id) {
                            AccessibilityNotification.Announcement(String(localized: message.text)).post()
                            try? await Task.sleep(for: duration)
                            self.message = nil
                        }
                }
            }
            .animation(Motion.modal(reduceMotion: reduceMotion), value: message)
            .sensoryFeedback(.success, trigger: message?.id) { _, new in new != nil }
    }
}

extension View {
    /// Shows `message` as a toast and clears it after a short time.
    func toast(_ message: Binding<ToastMessage?>) -> some View {
        modifier(ToastModifier(message: message))
    }
}
