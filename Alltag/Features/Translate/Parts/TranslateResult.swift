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

/// The translation with a row of glass circles under it: Listen, Slowly,
/// Copy, Share, and the bookmark that saves to Memory and takes it out again.
struct TranslateResultBlock: View {
    let label: LocalizedStringResource
    let text: String
    /// The German that Listen speaks, when the result shown is the English.
    var spoken: String?
    let isSaved: Bool
    let handlers: TranslateResultHandlers

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            TranslateLanguageChip(label: label, isResult: true)
            Text(verbatim: text)
                .font(.title2.weight(.semibold))
                .textSelection(.enabled)
                .frame(maxWidth: .infinity, alignment: .leading)
            HStack(spacing: 10) {
                listen("Listen", systemImage: "speaker.wave.2.fill") { handlers.listen(false) }
                listen("Slowly", systemImage: "tortoise.fill") { handlers.listen(true) }
                circle("Copy", systemImage: "doc.on.doc", action: handlers.copy)
                ShareLink(item: text) { circleLabel("square.and.arrow.up") }
                    .buttonStyle(.plain)
                    .glassEffect(.regular.interactive(), in: .circle)
                    .accessibilityLabel(Text("Share"))
                Spacer(minLength: 0)
                bookmark
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func circle(_ title: LocalizedStringResource, systemImage: String, action: @escaping () -> Void) -> some View {
        Button(action: action) { circleLabel(systemImage) }
            .buttonStyle(.plain)
            .glassEffect(.regular.interactive(), in: .circle)
            .accessibilityLabel(Text(title))
    }

    /// A Listen circle: a spinner stands in for its symbol while the voice is being made.
    private func listen(_ title: LocalizedStringResource, systemImage: String,
                        action: @escaping () -> Void) -> some View {
        Button(action: action) {
            ListenIcon(text: spoken ?? text, systemImage: systemImage)
                .font(.headline)
                .foregroundStyle(.primary)
                .frame(width: 44, height: 44)
        }
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

    private var bookmark: some View {
        Button(action: handlers.toggleSave) {
            Image(systemName: isSaved ? "bookmark.fill" : "bookmark")
                .font(.title3.weight(.semibold))
                .foregroundStyle(.accent)
                .contentTransition(.symbolEffect(.replace))
                .frame(width: 44, height: 44)
        }
        .buttonStyle(.plain)
        .glassEffect(.regular.interactive(), in: .circle)
        .accessibilityLabel(isSaved ? Text("Remove from Memory") : Text("Save to Memory"))
    }
}
