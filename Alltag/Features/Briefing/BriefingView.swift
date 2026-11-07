//
//  BriefingView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftData
import SwiftUI

/// The 60-second spoken briefing built from the learner's words.
struct BriefingView: View {
    @State private var model: BriefingModel
    @Query private var items: [MemoryItem]

    init(services: AppServices) {
        _model = State(initialValue: BriefingModel(services: services))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    Eyebrow(title: "Your briefing · 60 sec")
                    Text(verbatim: model.briefing.title)
                        .textRole(.title2)
                        .accessibilityAddTraits(.isHeader)
                }
                .padding(.top, 8)

                player

                Text(transcript)
                    .font(.system(.title3))
                    .lineSpacing(4)
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 4)
                    .textSelection(.enabled)

                wordsCard

                Label("Concept: a new briefing every morning, playable from the Lock Screen and AirPods.",
                      systemImage: "headphones")
                    .textRole(.meta)
                    .foregroundStyle(.tertiary)
                    .padding(.horizontal, 4)
            }
            .padding(.horizontal, Spacing.screen)
            .padding(.bottom, 32)
        }
        .readableContentMargins()
        .background(.screenBackground)
        .navigationBarTitleDisplayMode(.inline)
        .onDisappear { model.stop() }
    }

    private var player: some View {
        HStack(spacing: 16) {
            Button {
                Task { await model.togglePlay() }
            } label: {
                Image(systemName: model.isPlaying ? "pause.fill" : "play.fill")
                    .font(.system(size: 26))
                    .foregroundStyle(.onAccent)
                    .frame(width: 60, height: 60)
                    .background(.accentFill, in: .circle)
            }
            .buttonStyle(.card)
            .accessibilityLabel(model.isPlaying ? Text("Pause briefing") : Text("Play briefing"))
            EqualizerBars(isPlaying: model.isPlaying, height: 40)
        }
        .padding(20)
        .background(.surface, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }

    /// Learning words in amber and semibold.
    private var transcript: AttributedString {
        var text = BriefingModel.highlighted(model.briefing.transcript, words: model.briefing.words)
        for run in text.runs where run.inlinePresentationIntent == .stronglyEmphasized {
            text[run.range].foregroundColor = .accent
        }
        return text
    }

    private var wordsCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Words from your Memory in this briefing")
                .textRole(.meta)
                .foregroundStyle(.secondary)
            FlowLayout(spacing: 6) {
                ForEach(BriefingModel.memoryLabels(for: model.briefing.words, in: items), id: \.self) { word in
                    Text(verbatim: word)
                        .textRole(.bodySmall)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(.surfaceSecondary, in: .rect(cornerRadius: 12, style: .continuous))
                }
            }
        }
        .padding(.horizontal, Spacing.card)
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.surface, in: .rect(cornerRadius: Radius.innerCard, style: .continuous))
    }
}

#Preview {
    NavigationStack { BriefingView(services: .mock()) }
        .modelContainer(AlltagStore.preview)
}
