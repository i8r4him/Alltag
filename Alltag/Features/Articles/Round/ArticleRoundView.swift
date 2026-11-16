//
//  ArticleRoundView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 13.11.26.
//

import SwiftData
import SwiftUI

/// A round of der, die, das, full screen like an activity: nouns fall and
/// the learner taps their article before they land (`ArticleDropGame`), with
/// the score and the nouns that went wrong at the end.
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
                        ProgressSegments(total: model.total, completed: model.index + (model.hasAnswered ? 1 : 0), height: 4)
                            .frame(width: 200)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    if let model, model.phase == .playing {
                        Text(model.score, format: .number)
                            .font(.headline.monospacedDigit())
                            .contentTransition(.numericText(value: Double(model.score)))
                            .padding(.horizontal, 6)
                            .accessibilityLabel(Text("Score"))
                            .accessibilityValue(Text(model.score, format: .number))
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
            case .ready, .playing: ArticleDropGame(model: model)
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

/// The end of the round, laid out like the end of 60 seconds: the score and
/// what happened at the top, the nouns that went wrong on one glass card, and
/// the big button for what comes next.
private struct ArticleRoundDone: View {
    let model: ArticleRoundModel
    let onDone: () -> Void
    @Environment(AppState.self) private var appState

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 4) {
                    score
                    Text("\(model.rightFirstTime) of \(model.asked) right first time")
                        .font(.title2.weight(.bold))
                        .accessibilityAddTraits(.isHeader)
                    Group {
                        if model.missed.isEmpty {
                            Text("Every article right. Another round brings new nouns.")
                        } else if model.savedMistakes > 0 {
                            Text("These come first next time. The wrong articles are saved to Fix your mistakes.")
                        } else {
                            Text("These landed before you picked. They come first next time.")
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
                if model.savedMistakes == 0 {
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

    /// The points, and the best score: a new one is celebrated.
    private var score: some View {
        VStack(alignment: .leading, spacing: 2) {
            if model.isNewBest {
                Eyebrow(title: "New best")
            } else if model.best > 0 {
                Eyebrow(title: "Best \(model.best)", tone: .secondary)
            }
            Text("\(model.score) points")
                .font(.largeTitle.weight(.bold))
                .contentTransition(.numericText())
        }
        .padding(.bottom, 6)
        .accessibilityElement(children: .combine)
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
