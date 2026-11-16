//
//  SortPage.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Page design 5, "Sort": go through the pile one card at a time and swipe
/// right for a word you know, left for one to learn. At the end only the
/// words to learn go to Memory.
struct SortPage: View {
    let page: CollectionPage

    @State private var index = 0
    @State private var toLearn: [CollectionWord] = []
    @State private var isTurned = false
    @State private var drag: CGFloat = 0
    @State private var didSave = false
    @ScaledMetric(relativeTo: .largeTitle) private var height: CGFloat = 320

    private var isDone: Bool { index >= page.words.count }

    var body: some View {
        ScrollView {
            VStack(spacing: 22) {
                VStack(spacing: 6) {
                    Text(verbatim: page.collection.title)
                        .font(.title2.weight(.bold))
                    Text("Swipe right if you know it, left to learn it.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                }
                if isDone {
                    summary
                } else {
                    pile
                    choices
                }
            }
            .padding(.horizontal, Spacing.screen)
            .padding(.bottom, 24)
        }
        .scrollIndicators(.hidden)
        .scrollEdgeEffectStyle(.soft, for: .all)
        .sensoryFeedback(.impact(weight: .medium), trigger: index)
    }

    private var pile: some View {
        ZStack {
            StackLayers(angles: [-5, 4])
            SortCard(word: page.words[index], isTurned: isTurned, drag: drag)
                .offset(x: drag)
                .rotationEffect(.degrees(Double(drag) / 22))
                .onTapGesture { withAnimation(.smooth(duration: 0.4)) { isTurned.toggle() } }
                .accessibilityAddTraits(.isButton)
                .accessibilityHint(Text("Tap to turn over"))
                .accessibilityAction(named: Text("Learn it")) { sort(knowsIt: false) }
                .accessibilityAction(named: Text("I know it")) { sort(knowsIt: true) }
        }
        .frame(height: height)
        .padding(.horizontal, 8)
        .simultaneousGesture(swipe)
    }

    private var choices: some View {
        VStack(spacing: 12) {
            GlassEffectContainer(spacing: 12) {
                HStack(spacing: 12) {
                    Button { sort(knowsIt: false) } label: {
                        Label("Learn it", systemImage: "arrow.uturn.left")
                            .frame(maxWidth: .infinity, minHeight: 34)
                    }
                    Button { sort(knowsIt: true) } label: {
                        Label("I know it", systemImage: "checkmark")
                            .frame(maxWidth: .infinity, minHeight: 34)
                    }
                }
                .font(.headline)
                .buttonStyle(.glass)
            }
            Text(verbatim: "\(index + 1) / \(page.words.count)")
                .font(.subheadline.weight(.semibold).monospacedDigit())
                .foregroundStyle(.secondary)
        }
    }

    private var summary: some View {
        VStack(spacing: 18) {
            Image(systemName: toLearn.isEmpty ? "star.fill" : "tray.full.fill")
                .font(.system(size: 52))
                .foregroundStyle(.accent)
                .accessibilityHidden(true)
            if toLearn.isEmpty {
                Text("You know them all.")
                    .font(.title3.weight(.semibold))
            } else {
                Text("^[\(toLearn.count) word](inflect: true) to learn")
                    .font(.title3.weight(.semibold))
                FlowLayout(spacing: 6) {
                    ForEach(toLearn) { word in
                        ArticleWord(word: word, font: .subheadline.weight(.medium))
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(.accentFill.opacity(0.16), in: .capsule)
                    }
                }
                Button {
                    page.save(toLearn)
                    didSave = true
                } label: {
                    if didSave {
                        Label("Saved to Memory", systemImage: "checkmark")
                    } else {
                        Label("Save them to Memory", systemImage: "plus")
                    }
                }
                .buttonStyle(.primary)
                .disabled(didSave)
            }
            Button("Start again", systemImage: "arrow.counterclockwise") {
                withAnimation(.snappy) {
                    index = 0
                    toLearn = []
                    didSave = false
                    isTurned = false
                }
            }
            .buttonStyle(.glass)
        }
        .padding(Spacing.cardLarge)
        .frame(maxWidth: .infinity)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }

    private var swipe: some Gesture {
        DragGesture(minimumDistance: 16)
            .onChanged { value in
                guard abs(value.translation.width) > abs(value.translation.height) else { return }
                drag = value.translation.width
            }
            .onEnded { _ in
                if abs(drag) > 90 {
                    sort(knowsIt: drag > 0)
                } else {
                    withAnimation(.snappy) { drag = 0 }
                }
            }
    }

    private func sort(knowsIt: Bool) {
        guard !isDone else { return }
        if !knowsIt { toLearn.append(page.words[index]) }
        withAnimation(.snappy) {
            drag = 0
            isTurned = false
            index += 1
        }
    }
}

/// The card on top: the word on the front, the meaning and sentence on the
/// back. While it's dragged, it says where it's going.
private struct SortCard: View {
    let word: CollectionWord
    let isTurned: Bool
    let drag: CGFloat

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ZStack {
            VStack(spacing: 12) {
                HStack {
                    Spacer()
                    SpeakButton(text: word.displayWord)
                }
                Spacer()
                ArticleWord(word: word, font: .largeTitle.weight(.bold))
                Spacer()
                Text("Tap to turn over")
                    .font(.footnote)
                    .foregroundStyle(.tertiary)
            }
            .opacity(isTurned ? 0 : 1)
            VStack(alignment: .leading, spacing: 12) {
                Text(verbatim: word.meaning)
                    .font(.title2.weight(.bold))
                Text(word.highlightedExample)
                Text(verbatim: word.exampleMeaning)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer(minLength: 0)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .opacity(isTurned ? 1 : 0)
            .rotation3DEffect(.degrees(reduceMotion ? 0 : 180), axis: (x: 0, y: 1, z: 0))
        }
        .padding(Spacing.cardLarge)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.card, style: .continuous))
        .overlay(alignment: drag > 0 ? .topLeading : .topTrailing) {
            if abs(drag) > 30 {
                Group {
                    if drag > 0 {
                        Label("I know it", systemImage: "checkmark")
                    } else {
                        Label("Learn it", systemImage: "arrow.uturn.left")
                    }
                }
                    .font(.headline)
                    .foregroundStyle(.accent)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .glassEffect(.regular, in: .capsule)
                    .padding(16)
            }
        }
        .rotation3DEffect(.degrees(isTurned && !reduceMotion ? 180 : 0), axis: (x: 0, y: 1, z: 0))
        .contentShape(.rect(cornerRadius: Radius.card, style: .continuous))
    }
}
