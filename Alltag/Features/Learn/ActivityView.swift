//
//  ActivityView.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// A full-screen multiple-choice activity.
struct ActivityView: View {
    let activity: Activity
    @Environment(\.services) private var services
    @State private var model: ActivityModel?

    var body: some View {
        Group {
            if let model {
                ActivityContent(model: model)
            } else {
                Color.clear
            }
        }
        .background(.screenBackground)
        .onAppear {
            if model == nil { model = ActivityModel(activity: activity, services: services) }
        }
    }
}

private struct ActivityContent: View {
    let model: ActivityModel
    @Environment(AppState.self) private var appState

    var body: some View {
        NavigationStack {
            Group {
                if model.isDone {
                    DoneView(title: model.doneTitle,
                             onMore: {
                                 appState.dismissFullScreen()
                                 appState.show(.learn)
                             },
                             onHome: {
                                 appState.dismissFullScreen()
                                 appState.popToRoot()
                             })
                } else {
                    QuestionView(model: model)
                        .id(model.index)
                        .transition(.opacity)
                }
            }
            .padding(.horizontal, Spacing.onboarding)
            .readableWidth(Spacing.focusedWidth)
            .frame(maxHeight: .infinity, alignment: .top)
            .background(.screenBackground)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close", systemImage: "xmark") {
                        model.stopAudio()
                        appState.dismissFullScreen()
                    }
                }
                ToolbarItem(placement: .principal) {
                    HStack(spacing: 4) {
                        ForEach(0..<model.total, id: \.self) { segment in
                            Capsule()
                                .fill(model.isSegmentFilled(segment) ? AnyShapeStyle(.accentFill) : AnyShapeStyle(.surfaceTertiary))
                                .frame(height: 4)
                        }
                    }
                    .frame(width: 220)
                    .animation(.easeOut(duration: 0.3), value: model.hasPicked)
                    .accessibilityElement()
                    .accessibilityLabel("Progress")
                    .accessibilityValue(Text("\(model.index + 1) of \(model.total)"))
                }
            }
            .animation(.easeOut(duration: 0.3), value: model.isDone)
        }
    }
}

/// One question: eyebrow and title, optional audio, quote, question, options, explanation.
private struct QuestionView: View {
    let model: ActivityModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 6) {
                    Eyebrow(verbatim: model.activity.label,
                            tone: model.activity.tone == .mistake ? .mistake : .accent)
                    Text(verbatim: model.activity.title)
                        .textRole(.title2)
                        .accessibilityAddTraits(.isHeader)
                }

                if model.activity.audio != nil {
                    AudioCard(isPlaying: model.isPlaying) { Task { await model.toggleAudio() } }
                }

                if let quote = model.question.quote {
                    VStack(alignment: .leading, spacing: 8) {
                        if let context = model.question.context {
                            Text(verbatim: context).textRole(.meta).foregroundStyle(.secondary)
                        }
                        Text(verbatim: quote)
                            .font(.system(.title3, weight: .medium))
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 18)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(.surface, in: .rect(cornerRadius: Radius.card, style: .continuous))
                }

                Text(verbatim: model.question.question)
                    .textRole(.cardTitle)

                VStack(spacing: 10) {
                    ForEach(model.question.options.indices, id: \.self) { option in
                        OptionButton(text: model.question.options[option], state: model.state(ofOption: option)) {
                            model.pick(option)
                        }
                    }
                }

                if model.hasPicked {
                    Text(verbatim: model.question.explanation)
                        .textRole(.bodySmall)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 16)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(.surface, in: .rect(cornerRadius: Radius.innerCard, style: .continuous))
                        .transition(.opacity)
                }
            }
            .padding(.top, 12)
            .padding(.bottom, 16)
            .animation(.easeOut(duration: 0.25), value: model.hasPicked)
        }
        .safeAreaInset(edge: .bottom) {
            if model.hasPicked {
                Button { model.next() } label: { Text("Continue") }
                    .buttonStyle(.primary)
                    .padding(.bottom, 8)
                    .transition(.opacity)
            }
        }
        .sensoryFeedback(trigger: model.picked) { _, picked in
            guard let picked else { return nil }
            return picked == model.question.correctIndex ? .success : .error
        }
    }
}

/// An answer: green with a check when right, coral with a cross when picked
/// and wrong, faded when neither.
private struct OptionButton: View {
    let text: String
    let state: ActivityModel.OptionState
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Text(verbatim: text)
                    .textRole(.body)
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.leading)
                    .frame(maxWidth: .infinity, alignment: .leading)
                switch state {
                case .right:
                    Image(systemName: "checkmark.circle.fill").foregroundStyle(.success)
                case .wrong:
                    Image(systemName: "xmark.circle.fill").foregroundStyle(.mistake)
                case .open, .dimmed:
                    EmptyView()
                }
            }
            .font(.title3)
            .padding(.horizontal, 18)
            .padding(.vertical, 14)
            .frame(minHeight: 56)
            .background(background, in: shape)
            .overlay { shape.strokeBorder(border, lineWidth: 1) }
            .opacity(state == .dimmed ? 0.45 : 1)
            .contentShape(shape)
        }
        .buttonStyle(.plain)
        // Not `.disabled`, which would dim the right and wrong answers too.
        .allowsHitTesting(state == .open)
        .accessibilityValue(accessibilityValue)
        .animation(.easeOut(duration: 0.25), value: state)
    }

    private var shape: RoundedRectangle { RoundedRectangle(cornerRadius: Radius.option, style: .continuous) }

    private var background: AnyShapeStyle {
        switch state {
        case .right: AnyShapeStyle(.success.opacity(0.14))
        case .wrong: AnyShapeStyle(.mistake.opacity(0.14))
        case .open, .dimmed: AnyShapeStyle(.surface)
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

/// Play button and equalizer for listening activities.
private struct AudioCard: View {
    let isPlaying: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                    .font(.system(size: 24))
                    .foregroundStyle(.onAccent)
                    .frame(width: 56, height: 56)
                    .background(.accentFill, in: .circle)
                EqualizerBars(isPlaying: isPlaying)
            }
            .padding(20)
            .background(.surface, in: .rect(cornerRadius: Radius.card, style: .continuous))
        }
        .buttonStyle(.card)
        .accessibilityLabel(isPlaying ? Text("Pause announcement") : Text("Play announcement"))
    }
}

/// The end of an activity.
private struct DoneView: View {
    let title: LocalizedStringResource
    let onMore: () -> Void
    let onHome: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Spacer()
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 48))
                .foregroundStyle(.success)
                .accessibilityHidden(true)
            Text(title)
                .textRole(.title2)
                .accessibilityAddTraits(.isHeader)
            Text("We'll bring these back at the right moment — first tomorrow, then further apart as they stick.")
                .textRole(.body)
                .foregroundStyle(.secondary)
            Spacer()
            VStack(spacing: 8) {
                Button(action: onMore) { Text("More to learn") }
                    .buttonStyle(.primary)
                Button(action: onHome) { Text("Back home").frame(maxWidth: .infinity) }
                    .buttonStyle(.bordered)
                    .buttonBorderShape(.capsule)
                    .controlSize(.extraLarge)
                    .tint(.primary)
            }
            .padding(.bottom, 8)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .sensoryFeedback(.success, trigger: true)
    }
}

#Preview {
    ActivityView(activity: MockActivities.mistakes)
        .environment(AppState())
}
