//
//  ArticleRoundView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 13.11.26.
//

import SwiftData
import SwiftUI

/// A round of der, die, das, full screen like an activity: a noun, three
/// answers, the right article with its plural, and a summary at the end.
struct ArticleRoundView: View {
    var level: Level = .a1
    @Environment(\.services) private var services
    @Environment(AppState.self) private var appState
    @State private var model: ArticleRoundModel?

    var body: some View {
        NavigationStack {
            Group {
                if let model {
                    ArticleRoundContent(model: model, onDone: { appState.dismissFullScreen() })
                } else {
                    Color.clear
                }
            }
            .padding(.horizontal, Spacing.onboarding)
            .readableWidth(Spacing.focusedWidth)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .fontDesign(.rounded)
            .skyBackground()
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close", systemImage: "xmark") { appState.dismissFullScreen() }
                }
                ToolbarItem(placement: .principal) {
                    if let model, model.phase == .playing {
                        ProgressSegments(total: model.total, completed: model.index + (model.hasPicked ? 1 : 0), height: 4)
                            .frame(width: 220)
                    }
                }
            }
        }
        .onAppear {
            if model == nil {
                let model = ArticleRoundModel(services: services, level: level)
                model.start()
                self.model = model
            }
        }
        .onDisappear { model?.stop() }
    }
}

private struct ArticleRoundContent: View {
    let model: ArticleRoundModel
    let onDone: () -> Void

    var body: some View {
        Group {
            switch model.phase {
            case .loading: loading
            case .failed: failed
            case .playing:
                if model.current != nil {
                    ArticleQuestion(model: model)
                        .id(model.index)
                        .transition(.opacity)
                }
            case .done: ArticleRoundDone(model: model, onDone: onDone)
            }
        }
        .animation(.easeOut(duration: 0.3), value: model.phase)
    }

    private var loading: some View {
        VStack(spacing: 14) {
            ProgressView()
                .controlSize(.large)
            Text("Picking ten nouns for your level…")
                .font(.title3)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var failed: some View {
        VStack(spacing: 0) {
            Spacer()
            Image(systemName: "wifi.exclamationmark")
                .font(.system(size: 44, weight: .light))
                .foregroundStyle(.secondary)
                .accessibilityHidden(true)
            Text("The nouns didn't arrive")
                .textRole(.title2)
                .padding(.top, 16)
            Text("Check your connection, and that Alltag may use the cloud in Settings.")
                .font(.title3)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.top, 6)
            Spacer()
            Button { model.start() } label: {
                Label("Try again", systemImage: "arrow.clockwise")
            }
            .buttonStyle(.primary)
            .padding(.bottom, 12)
        }
    }
}

/// The noun, the three articles, and what the right one is once picked.
private struct ArticleQuestion: View {
    let model: ArticleRoundModel
    @Environment(\.modelContext) private var context
    @Environment(\.dynamicTypeSize) private var dynamicTypeSize
    /// Large, and larger still with the learner's text size.
    @ScaledMetric(relativeTo: .largeTitle) private var nounSize: CGFloat = 44

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {
                if let noun = model.current {
                    header(for: noun)
                    answers(for: noun)
                    if model.hasPicked {
                        ArticleAnswerCard(noun: noun, isRight: model.isRight == true)
                            .transition(.opacity)
                        if model.saveFailed {
                            Button { model.retrySave(in: context) } label: {
                                Label("Couldn’t keep this mistake. Try again", systemImage: "arrow.clockwise")
                                    .font(.subheadline.weight(.semibold))
                            }
                            .buttonStyle(.glass)
                            .tint(.mistake)
                        }
                    }
                }
            }
            .padding(.bottom, 16)
            .animation(.easeOut(duration: 0.25), value: model.hasPicked)
        }
        .scrollEdgeEffectStyle(.soft, for: .all)
        .scrollIndicators(.hidden)
        .safeAreaInset(edge: .bottom) {
            if model.hasPicked {
                Button { model.next(in: context) } label: { Text("Continue") }
                    .buttonStyle(.primary)
                    .padding(.bottom, 8)
                    .transition(.opacity)
            }
        }
        .sensoryFeedback(trigger: model.picked) { _, picked in
            guard picked != nil else { return nil }
            return model.isRight == true ? .success : .error
        }
    }

    /// The noun, large, with what it means.
    private func header(for noun: Noun) -> some View {
        VStack(spacing: 8) {
            Eyebrow(title: "DER, DIE OR DAS?")
            Text(verbatim: noun.word)
                .font(.system(size: nounSize, weight: .bold, design: .rounded))
                .minimumScaleFactor(0.6)
                .lineLimit(1)
                .environment(\.locale, Locale(identifier: "de"))
                .accessibilityAddTraits(.isHeader)
            Text(verbatim: noun.meaning)
                .font(.title3)
                .foregroundStyle(.secondary)
        }
        .multilineTextAlignment(.center)
        .padding(.top, 36)
    }

    /// The three articles side by side, or one under the other at the accessibility text sizes.
    private func answers(for noun: Noun) -> some View {
        let layout = dynamicTypeSize.isAccessibilitySize
            ? AnyLayout(VStackLayout(spacing: 12)) : AnyLayout(HStackLayout(spacing: 12))
        return GlassEffectContainer(spacing: 12) {
            layout {
                ForEach(Article.allCases) { article in
                    ArticleOption(article: article, state: state(of: article, for: noun)) {
                        model.pick(article, in: context)
                    }
                }
            }
        }
    }

    private func state(of article: Article, for noun: Noun) -> ArticleOption.Status {
        guard let picked = model.picked else { return .open }
        if article == noun.article { return .right }
        return article == picked ? .wrong : .dimmed
    }
}

/// One of the three answers: a glass square with the article. Green when it
/// is the right one, coral when picked and wrong, faded when neither.
private struct ArticleOption: View {
    enum Status { case open, right, wrong, dimmed }

    let article: Article
    let state: Status
    let action: () -> Void

    @ScaledMetric(relativeTo: .title) private var articleSize: CGFloat = 30
    @ScaledMetric(relativeTo: .title) private var minHeight: CGFloat = 104

    var body: some View {
        Button(action: action) {
            // The article alone decides the centre; the mark sits in the corner.
            Text(verbatim: article.rawValue)
                .font(.system(size: articleSize, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity, minHeight: minHeight)
                .overlay(alignment: .topTrailing) {
                    Group {
                        switch state {
                        case .right: Image(systemName: "checkmark.circle.fill").foregroundStyle(.success)
                        case .wrong: Image(systemName: "xmark.circle.fill").foregroundStyle(.mistake)
                        case .open, .dimmed: EmptyView()
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
            .opacity(state == .dimmed ? 0.45 : 1)
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
        case .open, .dimmed: AnyShapeStyle(.clear)
        }
    }

    private var border: AnyShapeStyle {
        switch state {
        case .right: AnyShapeStyle(.success.opacity(0.6))
        case .wrong: AnyShapeStyle(.mistake.opacity(0.6))
        case .open, .dimmed: AnyShapeStyle(.clear)
        }
    }

    private var accessibilityValue: Text {
        switch state {
        case .right: Text("Correct")
        case .wrong: Text("Wrong")
        case .open, .dimmed: Text(verbatim: "")
        }
    }
}

/// After the answer: the noun with its article, the plural, an example, and
/// whether it was kept for Fix your mistakes.
private struct ArticleAnswerCard: View {
    let noun: Noun
    let isRight: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label {
                if isRight { Text("Right") } else { Text("Added to Fix your mistakes") }
            } icon: {
                Image(systemName: isRight ? "checkmark.circle.fill" : "bookmark.fill")
            }
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(isRight ? Color.success : Color.mistake)
            ArticleNounDetail(noun: noun)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(Spacing.cardLarge)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }
}

/// The end of the round, laid out like the end of 60 seconds: what happened
/// at the top, the nouns that went wrong on one glass card, and the big
/// button for what comes next.
private struct ArticleRoundDone: View {
    let model: ArticleRoundModel
    let onDone: () -> Void
    @Environment(AppState.self) private var appState

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(model.rightFirstTime) of \(model.asked) right first time")
                        .font(.title2.weight(.bold))
                        .accessibilityAddTraits(.isHeader)
                    Group {
                        if model.missed.isEmpty {
                            Text("Every article right. Another round brings new nouns.")
                        } else {
                            Text("These are saved to Fix your mistakes and come first next time.")
                        }
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 4)
                .padding(.top, 24)

                if model.missed.isEmpty {
                    ScenarioArtwork(systemImage: "checkmark.seal.fill")
                        .frame(width: 120, height: 120)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 24)
                } else {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(Array(model.missed.enumerated()), id: \.element.id) { index, noun in
                            if index > 0 { Divider() }
                            MissedNounRow(noun: noun)
                        }
                    }
                    .padding(.horizontal, Spacing.cardLarge)
                    .padding(.vertical, 6)
                    .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
                }
            }
        }
        .scrollEdgeEffectStyle(.soft, for: .all)
        .scrollIndicators(.hidden)
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 12) {
                if model.missed.isEmpty {
                    Button { model.start() } label: { Text("Another round") }
                        .buttonStyle(.primary)
                    Button(action: onDone) { secondaryLabel("Done") }
                        .buttonStyle(.glass)
                } else {
                    Button { appState.present(.activity(.mistakes)) } label: { Text("Practise your mistakes") }
                        .buttonStyle(.primary)
                    Button { model.start() } label: { secondaryLabel("Another round") }
                        .buttonStyle(.glass)
                }
            }
            .padding(.bottom, 12)
        }
        .sensoryFeedback(.success, trigger: true)
    }

    /// The quieter button under the big one, as on 60 seconds.
    private func secondaryLabel(_ title: LocalizedStringResource) -> some View {
        Text(title)
            .font(.headline)
            .frame(maxWidth: .infinity, minHeight: 34)
    }
}

/// A noun that went wrong: the right article in the theme colour, and what it means.
private struct MissedNounRow: View {
    let noun: Noun

    var body: some View {
        HStack(alignment: .firstTextBaseline, spacing: 12) {
            Text(verbatim: "\(noun.article.rawValue) \(noun.word)")
                .font(.title3.weight(.semibold))
                .environment(\.locale, Locale(identifier: "de"))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(verbatim: noun.meaning)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.trailing)
        }
        .padding(.vertical, 14)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    ArticleRoundView()
        .environment(AppState())
        .modelContainer(AlltagStore.preview)
}
