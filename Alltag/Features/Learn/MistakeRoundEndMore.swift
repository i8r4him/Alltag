//
//  MistakeRoundEndMore.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 14.11.26.
//

import SwiftUI

// MARK: - 4 · Ring

/// How much of the round was fixed, as a ring that fills, with the rest in two pills under it.
struct MistakeEndRing: View {
    let model: MistakeRoundModel
    @State private var fraction = 0.0
    @Environment(\.reducesMotion) private var reduceMotion

    var body: some View {
        VStack(spacing: 22) {
            ZStack {
                Circle().stroke(.surfaceTertiary, lineWidth: 16)
                Circle()
                    .trim(from: 0, to: fraction)
                    .stroke(.accentFill, style: StrokeStyle(lineWidth: 16, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                VStack(spacing: 0) {
                    Text(verbatim: "\(model.fixed.count)/\(model.total)")
                        .font(.system(size: 52, weight: .bold, design: .rounded))
                        .monospacedDigit()
                    Text("fixed")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                }
            }
            .frame(width: 190, height: 190)
            .padding(.top, 12)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(Text("\(model.fixed.count) of \(model.total) fixed"))
            HStack(spacing: 10) {
                if !model.comingBack.isEmpty {
                    pill(Text("\(model.comingBack.count) back next time"),
                         systemImage: "arrow.uturn.backward.circle.fill", style: AnyShapeStyle(.mistake))
                }
                let learned = model.outcomes.filter(\.step.isLearned).count
                if learned > 0 {
                    pill(Text("\(learned) learned"), systemImage: "star.circle.fill", style: AnyShapeStyle(.accent))
                }
            }
            if let next = model.fixed.filter({ !$0.step.isLearned }).map(\.step.nextReview).min() {
                Label { MistakeWhen.nextReturn(next) } icon: { Image(systemName: "calendar") }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .onAppear {
            let target = model.total == 0 ? 0 : Double(model.fixed.count) / Double(model.total)
            withAnimation(reduceMotion ? nil : .easeOut(duration: 0.8).delay(0.15)) { fraction = target }
        }
    }

    private func pill(_ text: Text, systemImage: String, style: AnyShapeStyle) -> some View {
        Label { text } icon: { Image(systemName: systemImage).foregroundStyle(style) }
            .font(.subheadline.weight(.semibold))
            .padding(.horizontal, 14)
            .frame(minHeight: 40)
            .glassEffect(.regular, in: .capsule)
    }
}

// MARK: - 5 · Before and after

/// Every mistake as a card: what was said, the correction under it, and when it comes back.
struct MistakeEndPairs: View {
    let model: MistakeRoundModel

    var body: some View {
        VStack(spacing: Spacing.grid) {
            ForEach(model.outcomes) { outcome in
                VStack(alignment: .leading, spacing: 10) {
                    MistakePractice.quote(said: outcome.question.said, correction: outcome.question.correction)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    Label {
                        Text(verbatim: outcome.question.correction)
                    } icon: {
                        Image(systemName: "arrow.turn.down.right").foregroundStyle(.accent)
                    }
                    .font(.title3.weight(.semibold))
                    Label {
                        MistakeWhen.outcome(outcome)
                    } icon: {
                        Image(systemName: outcome.wasRight ? "checkmark.circle.fill" : "arrow.uturn.backward.circle.fill")
                            .foregroundStyle(outcome.wasRight ? AnyShapeStyle(.success) : AnyShapeStyle(.mistake))
                    }
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 12)
                    .frame(minHeight: 32)
                    .background(.controlFill, in: .capsule)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(Spacing.cardLarge)
                .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
                .environment(\.locale, Locale(identifier: "de"))
                .accessibilityElement(children: .combine)
            }
        }
    }
}

// MARK: - 6 · Timeline

/// When each mistake comes back, soonest first: next time, tomorrow, in a few days, and the learned ones last.
struct MistakeEndTimeline: View {
    let model: MistakeRoundModel

    /// A moment on the line and the mistakes that return then.
    private struct Stop: Identifiable {
        /// 0 next time, then the days until it returns, and the learned ones last.
        let id: Int
        let outcomes: [MistakeRoundModel.Outcome]

        static let learned = Int.max
    }

    private var stops: [Stop] {
        let groups = Dictionary(grouping: model.outcomes) { outcome in
            if !outcome.wasRight { return 0 }
            if outcome.step.isLearned { return Stop.learned }
            return max(ReviewSchedule.days(until: outcome.step.nextReview, from: .now), 1)
        }
        return groups.map { Stop(id: $0.key, outcomes: $0.value) }.sorted { $0.id < $1.id }
    }

    var body: some View {
        let stops = stops
        VStack(alignment: .leading, spacing: 0) {
            ForEach(Array(stops.enumerated()), id: \.element.id) { index, stop in
                HStack(alignment: .top, spacing: 14) {
                    VStack(spacing: 0) {
                        Image(systemName: symbol(for: stop))
                            .font(.title3)
                            .foregroundStyle(stop.id == 0 ? AnyShapeStyle(.mistake) : AnyShapeStyle(.accent))
                            .frame(width: 28, height: 28)
                            .accessibilityHidden(true)
                        if index < stops.count - 1 {
                            Capsule().fill(.surfaceTertiary).frame(width: 3).padding(.vertical, 4)
                        }
                    }
                    VStack(alignment: .leading, spacing: 6) {
                        title(for: stop)
                            .font(.headline)
                            .frame(minHeight: 28)
                        ForEach(stop.outcomes) { outcome in
                            Text(verbatim: outcome.question.correction)
                                .foregroundStyle(.secondary)
                                .environment(\.locale, Locale(identifier: "de"))
                        }
                    }
                    .padding(.bottom, index < stops.count - 1 ? 20 : 0)
                    .accessibilityElement(children: .combine)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.cardLarge)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }

    private func symbol(for stop: Stop) -> String {
        switch stop.id {
        case 0: "arrow.uturn.backward.circle.fill"
        case Stop.learned: "star.circle.fill"
        default: "calendar.circle.fill"
        }
    }

    private func title(for stop: Stop) -> Text {
        switch stop.id {
        case 0: Text("Next time")
        case Stop.learned: Text("Learned")
        case 1: Text("Tomorrow")
        case let days: Text("In ^[\(days) day](inflect: true)")
        }
    }
}
