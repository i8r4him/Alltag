//
//  LiveProblemView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 11.11.26.
//

import SwiftUI

/// Why a conversation that needs the live voice can't start.
enum LiveProblem: Equatable {
    /// Today's live conversations are used up.
    case limit
    case offline
    case microphone
    /// Everyone together has used up the day's conversations.
    case busy
    case unavailable

    init(_ error: any Error) {
        if error is URLError {
            self = .offline
            return
        }
        self = switch error as? RealtimeServiceError {
        case .dailyLimit: .limit
        case .microphoneDenied: .microphone
        case .busy: .busy
        default: .unavailable
        }
    }

    var systemImage: String {
        switch self {
        case .limit: "moon.zzz.fill"
        case .offline: "wifi.slash"
        case .microphone: "mic.slash.fill"
        case .busy: "person.3.fill"
        case .unavailable: "waveform.slash"
        }
    }

    var title: LocalizedStringResource {
        switch self {
        case .limit: "That's all for today"
        case .offline: "No internet"
        case .microphone: "Alltag can't hear you"
        case .busy: "The companion is busy"
        case .unavailable: "The companion can't talk right now"
        }
    }

    var explanation: LocalizedStringResource {
        switch self {
        case .limit: "You've used today's live conversations. You can talk again tomorrow."
        case .offline: "The companion needs the internet to talk. Check your connection and try again."
        case .microphone: "Allow the microphone in Settings to talk with the companion."
        case .busy: "A lot of people are talking right now. Try again in a little while."
        case .unavailable: "Something went wrong on our side. Try again in a moment."
        }
    }

    /// What still works meanwhile.
    var tip: LocalizedStringResource? {
        switch self {
        case .limit, .busy: "Everything in Learn still works, as often as you like."
        case .offline: "60 seconds on Today works without the internet."
        case .microphone, .unavailable: nil
        }
    }
}

/// Shown in place of a conversation that needs the live voice and can't
/// start: what happened, what still works, and a way on.
struct LiveProblemView: View {
    let problem: LiveProblem
    let onRetry: () -> Void
    let onDone: () -> Void

    @Environment(\.openURL) private var openURL

    var body: some View {
        VStack(spacing: 0) {
            ContentUnavailableView {
                Label {
                    Text(problem.title)
                } icon: {
                    Image(systemName: problem.systemImage)
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(.accent)
                }
            } description: {
                Text(problem.explanation)
            }

            VStack(spacing: 12) {
                if let tip = problem.tip {
                    Label { Text(tip) } icon: { Image(systemName: "lightbulb.fill") }
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(Spacing.card)
                        .glassEffect(.regular, in: .rect(cornerRadius: Radius.card, style: .continuous))
                }
                switch problem {
                case .limit:
                    Button(action: onDone) { Text("Done") }
                        .buttonStyle(.primary)
                case .microphone:
                    Button {
                        if let url = URL(string: UIApplication.openSettingsURLString) { openURL(url) }
                    } label: {
                        Label("Open Settings", systemImage: "gear")
                    }
                    .buttonStyle(.primary)
                    doneButton
                case .offline, .busy, .unavailable:
                    Button(action: onRetry) { Label("Try again", systemImage: "arrow.clockwise") }
                        .buttonStyle(.primary)
                    doneButton
                }
            }
            .padding(.horizontal, 22)
            .padding(.bottom, 12)
        }
    }

    private var doneButton: some View {
        Button(action: onDone) {
            Text("Done")
                .font(.headline)
                .frame(maxWidth: .infinity, minHeight: 34)
        }
        .buttonStyle(.glass)
    }
}

/// The short notice when the live voice can't start or stops.
enum LiveVoiceNotice {
    static func text(for reason: RealtimeServiceError?, freeTalk: Bool) -> LocalizedStringResource {
        // Free talk has no script, so the companion can only be tried again.
        if freeTalk { return "I can't talk right now. Tap me to try again." }
        switch reason {
        case .dailyLimit: return "You've reached your live voice limit for today. Keep practising on your iPhone."
        case .busy: return "Live voice is busy right now. You can keep practising on your iPhone."
        default: return "Live voice is unavailable. You can keep practising on your iPhone."
        }
    }
}

#Preview {
    LiveProblemView(problem: .offline, onRetry: {}, onDone: {})
        .skyBackground()
}
