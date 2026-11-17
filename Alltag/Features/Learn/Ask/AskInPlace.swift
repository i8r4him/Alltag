//
//  AskInPlace.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 14.11.26.
//

import SwiftData
import SwiftUI

/// "How do I say …?" on Learn: type the question in the field and get the
/// German answer there, without leaving the page. The server is asked when
/// the learner sends (Return or the arrow), never while they type. The
/// answer card grows under the field and pushes Learn down; the details
/// open under it, in place.
///
/// Learn owns the model and the focus: while the field is focused the rest
/// of the page steps back (`fieldFocusBackdrop`), and Learn animates the page
/// when the answer changes size (`AskModel.layout`), so the cards below move
/// instead of jumping.
struct AskInPlace: View {
    let model: AskModel?
    var isFocused: FocusState<Bool>.Binding

    var body: some View {
        Group {
            if let model {
                AskContent(model: model, isFocused: isFocused)
            } else {
                // The field's place, until the model is there.
                Color.clear.frame(height: 60)
            }
        }
        .fontDesign(.rounded)
    }
}

private struct AskContent: View {
    let model: AskModel
    var isFocused: FocusState<Bool>.Binding
    @State private var showsDetails = false
    /// Counts the taps that open or start something, for the medium haptic.
    @State private var taps = 0
    @Environment(\.reducesMotion) private var reduceMotion

    private var text: Binding<String> { Binding { model.text } set: { model.text = $0 } }

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.grid) {
            AskField(text: text, isFocused: isFocused, canSend: model.canSend, onSend: send, onClear: clear)
                .fieldFocusEffect(isActive: isFocused.wrappedValue)
            if model.showsRegister {
                AskRegisterChoice(selection: model.register) { register in
                    withAnimation(AskMotion.answer(reduceMotion: reduceMotion)) { _ = model.choose(register) }
                }
                .transition(.opacity)
            }
            if model.hasAnswer {
                AskAnswer(model: model, showsDetails: showsDetails)
                    .transition(AskMotion.answerTransition(reduceMotion: reduceMotion))
                if model.translate.result != nil {
                    AskDetailsButton(showsDetails: showsDetails) {
                        taps += 1
                        withAnimation(AskMotion.details(reduceMotion: reduceMotion)) { showsDetails.toggle() }
                    }
                    .transition(.opacity)
                }
            }
        }
        .onChange(of: model.text) { _, _ in
            model.textChanged()
            showsDetails = false
        }
        .onChange(of: isFocused.wrappedValue) { _, focused in if focused { taps += 1 } }
        .sensoryFeedback(.impact(weight: .medium), trigger: taps)
        .sensoryFeedback(.impact(weight: .medium), trigger: model.sent)
    }

    private func send() {
        guard model.send() != nil else { return }
        isFocused.wrappedValue = false
    }

    /// The X. With an answer on show it closes everything, keyboard too; while
    /// still typing it only empties the field.
    private func clear() {
        let closes = model.hasAnswer
        withAnimation(AskMotion.answer(reduceMotion: reduceMotion)) {
            showsDetails = false
            model.clear()
        }
        isFocused.wrappedValue = !closes
    }
}

/// Opens and closes the details: the chevron turns instead of swapping.
private struct AskDetailsButton: View {
    let showsDetails: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label {
                showsDetails ? Text("Hide the details") : Text("Word by word, tone and examples")
            } icon: {
                Image(systemName: "chevron.down")
                    .rotationEffect(.degrees(showsDetails ? -180 : 0))
            }
            .font(.subheadline.weight(.semibold))
            .frame(maxWidth: .infinity, minHeight: 30)
        }
        .buttonStyle(.glass)
    }
}

/// The "How do I say …?" field: a glass capsule to type in, with a clear
/// button and the arrow that sends once there is something to send.
struct AskField: View {
    @Binding var text: String
    var isFocused: FocusState<Bool>.Binding
    let canSend: Bool
    let onSend: () -> Void
    let onClear: () -> Void

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: LearnTool.howToSay.systemImage)
                .font(.title3)
                .foregroundStyle(.accent)
                .accessibilityHidden(true)
            TextField("How do I say …?", text: $text)
                .font(.title3)
                .focused(isFocused)
                .submitLabel(.send)
                .onSubmit(onSend)
            if !text.isEmpty {
                Button("Clear", systemImage: "xmark.circle.fill", action: onClear)
                    .labelStyle(.iconOnly)
                    .font(.title3)
                    .foregroundStyle(.secondary)
                    .frame(width: 32, height: 44)
                    .contentShape(.rect)
                    .buttonStyle(.plain)
                Button("Say it in German", systemImage: "arrow.up", action: onSend)
                    .labelStyle(.iconOnly)
                    .font(.headline.weight(.bold))
                    .foregroundStyle(canSend ? AnyShapeStyle(.onAccent) : AnyShapeStyle(.tertiary))
                    .frame(width: 40, height: 40)
                    .background(canSend ? AnyShapeStyle(.accentFill) : AnyShapeStyle(.controlFill), in: .circle)
                    .buttonStyle(.plain)
                    .disabled(!canSend)
            }
        }
        .padding(.leading, 20)
        .padding(.trailing, text.isEmpty ? 20 : 10)
        .frame(height: 60)
        .glassEffect(.regular.interactive(), in: .capsule)
        .animation(.easeOut(duration: 0.2), value: text.isEmpty)
    }
}

/// What comes back for the question: the wait in the shape of the answer,
/// the German with Listen, Slowly, Copy, Share and the bookmark, or a state
/// card saying why there is none; with the details under it when asked for.
struct AskAnswer: View {
    let model: AskModel
    let showsDetails: Bool
    @Environment(\.modelContext) private var context
    @Query private var saved: [SavedTranslation]

    private var translate: TranslateModel { model.translate }

    var body: some View {
        VStack(alignment: .leading, spacing: Spacing.grid) {
            if let failure = translate.failure {
                CloudFailureCard(failure: failure, failedTitle: Text("Couldn’t translate it")) { model.send() }
            } else if translate.missingLanguages != nil || model.foundNothing {
                StateCard(systemImage: "questionmark", title: Text("No answer for that"),
                          explanation: Text("Try it in other words, or a shorter sentence."))
            } else if let answer = translate.resultText {
                card {
                    TranslateResultBlock(label: translate.resultLabel, text: answer,
                                         isSaved: translate.isSaved(in: saved), handlers: handlers)
                }
                if showsDetails, let result = translate.result {
                    // Each part unfolds in turn as it appears.
                    TranslateDetails(result: result, unfolds: true) { german in
                        Task { await translate.listen(to: german) }
                    }
                    .padding(.top, 10)
                    .transition(.opacity)
                    if translate.isExplaining || translate.isTranslating {
                        TranslateLoadingDetails(pending: TranslateSection.allCases.filter { $0.isEmpty(in: result) })
                            .transition(.opacity)
                    }
                }
            } else {
                card { TranslateLoadingResult(label: translate.resultLabel) }
            }
        }
        .fontDesign(.rounded)
    }

    private func card(@ViewBuilder content: () -> some View) -> some View {
        content()
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(Spacing.cardLarge)
            .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }

    private var handlers: TranslateResultHandlers {
        TranslateResultHandlers { slowly in
            Task { await translate.listen(slowly: slowly) }
        } copy: {
            UIPasteboard.general.string = translate.resultText
        } toggleSave: {
            translate.toggleSave(in: context)
        }
    }
}
