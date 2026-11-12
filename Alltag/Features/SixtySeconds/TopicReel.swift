//
//  TopicReel.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 12.11.26.
//

import SwiftUI

/// Choosing a topic at random, shown: titles roll past like a reel, fast at
/// first, then slower, until the last one stays.
struct TopicReel: View {
    /// The titles to run through; the last one is the chosen topic.
    let titles: [String]
    let onLanded: () -> Void

    @Environment(\.reducesMotion) private var reduceMotion
    @State private var index = 0
    @State private var hasLanded = false

    var body: some View {
        Text(verbatim: titles.isEmpty ? "" : titles[min(index, titles.count - 1)])
            .font(.system(size: 34, weight: .bold, design: .rounded))
            .multilineTextAlignment(.center)
            .lineLimit(3)
            .minimumScaleFactor(0.7)
            .foregroundStyle(hasLanded ? AnyShapeStyle(.primary) : AnyShapeStyle(.secondary))
            .blur(radius: hasLanded ? 0 : 1.2)
            .scaleEffect(hasLanded ? 1 : 0.94)
            .id(index)
            .transition(.asymmetric(insertion: .move(edge: .bottom).combined(with: .opacity),
                                    removal: .move(edge: .top).combined(with: .opacity)))
            .frame(maxWidth: .infinity, minHeight: 130)
            .clipped()
            .sensoryFeedback(.selection, trigger: index)
            .sensoryFeedback(.success, trigger: hasLanded) { _, landed in landed }
            .accessibilityHidden(!hasLanded)
            .task { await spin() }
    }

    private func spin() async {
        let last = max(titles.count - 1, 0)
        guard !reduceMotion, last > 0 else {
            index = last
            hasLanded = true
            onLanded()
            return
        }
        for step in 1...last {
            // 70 ms between the first titles, close to 400 ms before the last.
            let progress = Double(step) / Double(last)
            let pause = 70 + 330 * progress * progress
            try? await Task.sleep(for: .milliseconds(Int(pause)))
            guard !Task.isCancelled else { return }
            withAnimation(.easeOut(duration: min(pause / 1_000, 0.28))) { index = step }
        }
        try? await Task.sleep(for: .milliseconds(180))
        guard !Task.isCancelled else { return }
        withAnimation(.spring(duration: 0.45, bounce: 0.35)) { hasLanded = true }
        onLanded()
    }
}

#Preview {
    TopicReel(titles: TalkTopics.all.prefix(8).map(\.title)) {}
        .padding()
        .skyBackground()
}
