//
//  ArticleDropGame.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 16.11.26.
//

import SwiftData
import SwiftUI

/// The game: a noun falls down the sky and the learner taps der, die or das
/// before it lands. The noun then drops over its right article, green or
/// coral, and the next one falls a little faster.
struct ArticleDropGame: View {
    let model: ArticleRoundModel
    @Environment(\.modelContext) private var context
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.accessibilityVoiceOverEnabled) private var voiceOver
    @Environment(\.accessibilityReduceMotion) private var systemReduceMotion
    @Environment(AppState.self) private var appState

    var body: some View {
        VStack(spacing: 16) {
            field
            answers
        }
        .padding(.top, 8)
        .padding(.bottom, 12)
        // The noun lands when its time is up; VoiceOver users get as long as they need.
        .task(id: FallKey(index: model.index, isFalling: model.isFalling && !voiceOver)) {
            guard model.isFalling, !voiceOver else { return }
            try? await Task.sleep(for: .seconds(model.remaining(at: .now)))
            guard !Task.isCancelled else { return }
            withAnimation(landing) { model.land() }
        }
        // A moment to see the answer, longer when it was wrong; then the next noun.
        .task(id: model.hasAnswered ? model.index : -1) {
            guard model.hasAnswered, !voiceOver else { return }
            try? await Task.sleep(for: .seconds(model.isRight == true ? 0.8 : 2))
            guard !Task.isCancelled else { return }
            next()
        }
        .safeAreaInset(edge: .bottom) {
            if voiceOver, model.hasAnswered {
                Button("Continue", action: next)
                    .buttonStyle(.primary)
                    .padding(.bottom, 8)
            }
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active { model.resume(at: .now) } else { model.pause(at: .now) }
        }
        .sensoryFeedback(trigger: model.hasAnswered) { _, answered in
            guard answered else { return nil }
            return model.isRight == true ? .success : .error
        }
    }

    /// The sky the noun falls through.
    private var field: some View {
        GeometryReader { geometry in
            let size = geometry.size
            ZStack {
                Color.clear
                if let noun = model.current {
                    TimelineView(.animation(paused: !model.isFalling)) { timeline in
                        let height = model.hasAnswered ? 1 : model.progress(at: timeline.date)
                        FallingNoun(noun: noun, isRight: model.isRight, points: model.lastPoints)
                            .frame(maxWidth: size.width)
                            .scaleEffect(model.hasAnswered ? 0.85 : 1)
                            .position(x: x(for: noun, width: size.width),
                                      y: Self.nounHeight / 2 + height * max(0, size.height - Self.nounHeight))
                    }
                    .id(model.index)
                    .transition(.opacity)
                }
                if model.phase == .ready { ready }
            }
        }
    }

    /// Before the first noun falls: how to play, and "Go".
    private var ready: some View {
        VStack(spacing: 20) {
            Text("Tap der, die or das before the word lands. Each word falls a little faster.")
                .font(.title3)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
            Button {
                withAnimation(.easeOut(duration: 0.3)) { model.begin(at: .now) }
            } label: {
                Label("Go", systemImage: "play.fill")
            }
            .buttonStyle(.primary)
        }
        .padding(.top, Self.nounHeight)
        .transition(.opacity)
    }

    /// The three articles, side by side.
    private var answers: some View {
        GlassEffectContainer(spacing: Self.answerSpacing) {
            HStack(spacing: Self.answerSpacing) {
                ForEach(Article.allCases) { article in
                    ArticleOption(article: article, state: state(of: article)) { pick(article) }
                }
            }
        }
    }

    private func state(of article: Article) -> ArticleOption.Status {
        guard model.phase == .playing else { return .waiting }
        guard model.hasAnswered, let noun = model.current else { return .open }
        if article == noun.article { return .right }
        return article == model.picked ? .wrong : .dimmed
    }

    /// The middle while it falls; once answered, over its right column.
    private func x(for noun: Noun, width: CGFloat) -> CGFloat {
        guard model.hasAnswered, let column = Article.allCases.firstIndex(of: noun.article) else { return width / 2 }
        let button = (width - Self.answerSpacing * 2) / 3
        return (button + Self.answerSpacing) * CGFloat(column) + button / 2
    }

    private func pick(_ article: Article) {
        guard model.isFalling else { return }
        withAnimation(landing) { model.pick(article, at: .now, in: context) }
    }

    private func next() {
        withAnimation(.easeOut(duration: 0.25)) { model.next(at: .now, in: context) }
    }

    /// The noun drops into its column with a small bounce, or without one when motion is reduced.
    private var landing: Animation {
        appState.reducesMotion(system: systemReduceMotion) ? .easeOut(duration: 0.25) : .spring(duration: 0.45, bounce: 0.25)
    }

    /// The room a falling noun takes, so it starts at the top and lands at the bottom.
    private static let nounHeight: CGFloat = 84
    private static let answerSpacing: CGFloat = 12

    private struct FallKey: Hashable {
        let index: Int
        let isFalling: Bool
    }
}

/// The noun on its way down: the word and what it means on a glass capsule.
/// Once answered it shows its article, green when right and coral when not.
private struct FallingNoun: View {
    let noun: Noun
    /// `nil` while it falls.
    let isRight: Bool?
    let points: Int

    var body: some View {
        VStack(spacing: 2) {
            Group {
                if isRight == nil {
                    Text(verbatim: noun.word)
                } else {
                    Text(verbatim: "\(noun.article.rawValue) \(noun.word)")
                }
            }
            .font(.title.weight(.bold))
            .lineLimit(1)
            .minimumScaleFactor(0.5)
            .environment(\.locale, Locale(identifier: "de"))
            Text(verbatim: noun.meaning)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
        .padding(.horizontal, 22)
        .padding(.vertical, 12)
        .background(tint.opacity(0.22), in: .capsule)
        .glassEffect(.regular, in: .capsule)
        .overlay(alignment: .top) {
            if isRight == true, points > 0 {
                Text(verbatim: "+\(points)")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.success)
                    .offset(y: -26)
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.updatesFrequently)
    }

    private var tint: Color {
        switch isRight {
        case true?: .success
        case false?: .mistake
        case nil: .clear
        }
    }
}

/// One of the three answers: a glass square with the article. Green when it
/// is the right one, coral when picked and wrong, faded when neither.
struct ArticleOption: View {
    enum Status { case waiting, open, right, wrong, dimmed }

    let article: Article
    let state: Status
    let action: () -> Void

    @ScaledMetric(relativeTo: .title) private var articleSize: CGFloat = 30
    @ScaledMetric(relativeTo: .title) private var minHeight: CGFloat = 84

    var body: some View {
        Button(action: action) {
            // The article alone decides the centre; the mark sits in the corner.
            Text(verbatim: article.rawValue)
                .font(.system(size: articleSize, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
                .frame(maxWidth: .infinity, minHeight: minHeight)
                .overlay(alignment: .topTrailing) {
                    Group {
                        switch state {
                        case .right: Image(systemName: "checkmark.circle.fill").foregroundStyle(.success)
                        case .wrong: Image(systemName: "xmark.circle.fill").foregroundStyle(.mistake)
                        case .waiting, .open, .dimmed: EmptyView()
                        }
                    }
                    .font(.title3)
                    .padding(10)
                    .transition(.scale.combined(with: .opacity))
                }
                .background(background, in: shape)
                .overlay { shape.strokeBorder(border, lineWidth: 1.5) }
                // Interactive glass answers the touch itself, like the app's buttons.
                .glassEffect(state == .open ? .regular.interactive() : .regular, in: shape)
                .opacity(state == .dimmed || state == .waiting ? 0.45 : 1)
                .contentShape(shape)
        }
        .buttonStyle(.plain)
        // Not `.disabled`, which would dim the right and wrong answers too.
        .allowsHitTesting(state == .open)
        .accessibilityLabel(Text(verbatim: article.rawValue))
        .accessibilityValue(accessibilityValue)
        .animation(.easeOut(duration: 0.25), value: state)
    }

    private var shape: RoundedRectangle { RoundedRectangle(cornerRadius: 26, style: .continuous) }

    private var background: AnyShapeStyle {
        switch state {
        case .right: AnyShapeStyle(.success.opacity(0.22))
        case .wrong: AnyShapeStyle(.mistake.opacity(0.22))
        case .waiting, .open, .dimmed: AnyShapeStyle(.clear)
        }
    }

    private var border: AnyShapeStyle {
        switch state {
        case .right: AnyShapeStyle(.success.opacity(0.6))
        case .wrong: AnyShapeStyle(.mistake.opacity(0.6))
        case .waiting, .open, .dimmed: AnyShapeStyle(.clear)
        }
    }

    private var accessibilityValue: Text {
        switch state {
        case .right: Text("Correct")
        case .wrong: Text("Wrong")
        case .waiting, .open, .dimmed: Text(verbatim: "")
        }
    }
}
