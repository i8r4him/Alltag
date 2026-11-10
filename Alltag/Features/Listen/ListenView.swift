//
//  ListenView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 10.11.26.
//

import SwiftUI

/// Learn › Listen: a clip picked for you from your calendar, the speed, and
/// real situations to listen to. UI only for now, with mock content.
struct ListenView: View {
    @Environment(AppState.self) private var appState
    @State private var taps = 0
    @State private var isSlow = false

    var body: some View {
        LearnScreen(title: "Listen") {
            LearnHeroCard(title: Text(MockListening.picked.title),
                          detail: Text(MockListening.picked.detail),
                          systemImage: MockListening.picked.systemImage,
                          buttonTitle: "Listen · \(MockListening.picked.length)",
                          buttonImage: "play.fill",
                          isProminent: true) {
                taps += 1
                appState.present(.activity(.listen))
            }

            LearnSection(title: "Speed") {
                Picker("Speed", selection: $isSlow) {
                    Label("Normal", systemImage: "hare").tag(false)
                    Label("Slow", systemImage: "tortoise").tag(true)
                }
                .pickerStyle(.segmented)
                .sensoryFeedback(.selection, trigger: isSlow)
            }

            LearnSection(title: "Real situations") {
                LearnList {
                    ForEach(MockListening.clips) { clip in
                        LearnRow(systemImage: clip.systemImage, title: Text(clip.title),
                                 detail: Text(clip.detail), action: tapped) {
                            Label { Text(verbatim: clip.length) } icon: { Image(systemName: "play.fill") }
                                .font(.subheadline.weight(.semibold).monospacedDigit())
                                .foregroundStyle(.accent)
                        }
                    }
                }
            }
        }
        .sensoryFeedback(.impact(weight: .light), trigger: taps)
    }

    /// The other clips come later; for now a tap only gives feedback.
    private func tapped() {
        taps += 1
    }
}

#Preview {
    NavigationStack { ListenView() }
        .environment(AppState())
}
