//
//  TranslateResult.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 14.11.26.
//

import SwiftUI

/// What the buttons under a translation do.
struct TranslateResultHandlers {
    let listen: (_ slowly: Bool) -> Void
    let copy: () -> Void
    let toggleSave: () -> Void
}

/// The tones to switch between in the result, when Details shows them as chips.
struct TranslateToneChoice {
    let tones: [TranslationResult.ToneVariant]
    let note: String
    let selection: Binding<TranslationResult.ToneVariant.Tone?>
}

/// The translation with Listen, Slowly, Copy, Share and the bookmark that
/// saves to Memory and takes it out again.
///
/// TEMPORARY (#296): three designs to choose from.
/// 1 a row of glass circles; 2 the bookmark beside the language and a row of
/// labelled glass buttons; 3 one filled Listen button and a menu for the rest.
struct TranslateResultBlock: View {
    let design: Int
    let label: LocalizedStringResource
    let text: String
    let isSaved: Bool
    var tones: TranslateToneChoice?
    let handlers: TranslateResultHandlers

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                TranslateLanguageChip(label: label, isResult: true)
                Spacer()
                if design == 2 { bookmark(inCircle: false) }
            }
            Text(verbatim: text)
                .font(design == 2 ? .title.weight(.semibold) : .title2.weight(.semibold))
                .textSelection(.enabled)
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentTransition(.opacity)
            if let tones { TranslateToneChips(choice: tones) }
            switch design {
            case 2: labelledRow
            case 3: listenAndMenu
            default: circles
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .animation(.easeOut(duration: 0.2), value: text)
    }

    // MARK: 1 · Circles

    private var circles: some View {
        HStack(spacing: 10) {
            circle("Listen", systemImage: "speaker.wave.2.fill") { handlers.listen(false) }
            circle("Slowly", systemImage: "tortoise.fill") { handlers.listen(true) }
            circle("Copy", systemImage: "doc.on.doc", action: handlers.copy)
            ShareLink(item: text) { circleLabel("square.and.arrow.up") }
                .buttonStyle(.plain)
                .glassEffect(.regular.interactive(), in: .circle)
                .accessibilityLabel(Text("Share"))
            Spacer(minLength: 0)
            bookmark(inCircle: true)
        }
    }

    private func circle(_ title: LocalizedStringResource, systemImage: String, action: @escaping () -> Void) -> some View {
        Button(action: action) { circleLabel(systemImage) }
            .buttonStyle(.plain)
            .glassEffect(.regular.interactive(), in: .circle)
            .accessibilityLabel(Text(title))
    }

    private func circleLabel(_ systemImage: String) -> some View {
        Image(systemName: systemImage)
            .font(.headline)
            .foregroundStyle(.primary)
            .frame(width: 44, height: 44)
    }

    // MARK: 2 · Labelled row

    private var labelledRow: some View {
        ScrollView(.horizontal) {
            GlassEffectContainer(spacing: 8) {
                HStack(spacing: 8) {
                    Button("Listen", systemImage: "speaker.wave.2.fill") { handlers.listen(false) }
                    Button("Slowly", systemImage: "tortoise.fill") { handlers.listen(true) }
                    Button("Copy", systemImage: "doc.on.doc", action: handlers.copy)
                    ShareLink(item: text) { Label("Share", systemImage: "square.and.arrow.up") }
                }
                .buttonStyle(.glass)
            }
        }
        .scrollIndicators(.hidden)
        .scrollClipDisabled()
    }

    // MARK: 3 · Listen and a menu

    private var listenAndMenu: some View {
        HStack(spacing: 10) {
            Button("Listen", systemImage: "speaker.wave.2.fill") { handlers.listen(false) }
                .buttonStyle(.primaryCompact)
            Spacer(minLength: 0)
            bookmark(inCircle: true)
            Menu {
                Button("Slowly", systemImage: "tortoise.fill") { handlers.listen(true) }
                Button("Copy", systemImage: "doc.on.doc", action: handlers.copy)
                ShareLink(item: text) { Label("Share", systemImage: "square.and.arrow.up") }
            } label: {
                circleLabel("ellipsis")
            }
            .buttonStyle(.plain)
            .glassEffect(.regular.interactive(), in: .circle)
            .accessibilityLabel(Text("More"))
        }
    }

    // MARK: Bookmark

    @ViewBuilder
    private func bookmark(inCircle: Bool) -> some View {
        let button = Button(action: handlers.toggleSave) {
            Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                .font(.title3.weight(.semibold))
                .foregroundStyle(.accent)
                .contentTransition(.symbolEffect(.replace))
                .frame(width: 44, height: 44)
                .contentShape(.rect)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(isSaved ? Text("Remove from Memory") : Text("Save to Memory"))
        if inCircle {
            button.glassEffect(.regular.interactive(), in: .circle)
        } else {
            button
        }
    }
}

/// Formal, neutral, casual: tap one and the translation above changes to it;
/// tap it again for the first translation.
struct TranslateToneChips: View {
    let choice: TranslateToneChoice

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                ForEach(Array(choice.tones.enumerated()), id: \.offset) { _, variant in
                    let isSelected = choice.selection.wrappedValue == variant.tone
                    Button {
                        choice.selection.wrappedValue = isSelected ? nil : variant.tone
                    } label: {
                        Label { Text(variant.tone.title) } icon: { Image(systemName: variant.tone.systemImage) }
                            .font(.subheadline.weight(.semibold))
                            .foregroundStyle(isSelected ? AnyShapeStyle(.onAccent) : AnyShapeStyle(.primary))
                            .padding(.horizontal, 12)
                            .frame(minHeight: 36)
                            .background(isSelected ? AnyShapeStyle(.accentFill) : AnyShapeStyle(.controlFill), in: .capsule)
                            .contentShape(.capsule)
                    }
                    .buttonStyle(.plain)
                    .accessibilityAddTraits(isSelected ? .isSelected : [])
                }
            }
            if !choice.note.isEmpty {
                Text(verbatim: choice.note)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .sensoryFeedback(.selection, trigger: choice.selection.wrappedValue)
    }
}
