//
//  MistakesCard.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 10.11.26.
//

import SwiftData
import SwiftUI

/// "Fix your mistakes": the learner's own mistakes as a stack of cards. The
/// one to fix next is on top, with what they said and the wrong words
/// underlined in coral. With nothing to fix, it says so.
struct MistakesCard: View {
    let action: () -> Void

    /// The mistakes that can be practised (saved with what was said), the one due first on top.
    @Query private var mistakes: [MemoryItem]
    @State private var taps = 0

    init(action: @escaping () -> Void) {
        self.action = action
        let mistake = MemoryKind.mistake.rawValue
        let filter = #Predicate<MemoryItem> { $0.kindRaw == mistake && $0.mistakeOriginal != "" }
        let order = [SortDescriptor(\MemoryItem.nextReview), SortDescriptor(\MemoryItem.createdAt, order: .reverse)]
        _mistakes = Query(filter: filter, sort: order)
    }

    var body: some View {
        if let first = mistakes.first {
            Button {
                taps += 1
                action()
            } label: {
                card(first)
            }
            .buttonStyle(.card)
            .fontDesign(.rounded)
            .sensoryFeedback(.impact(weight: .light), trigger: taps)
            .accessibilityElement(children: .combine)
            .accessibilityHint("Starts a one-minute exercise on your mistakes.")
        } else {
            empty
        }
    }

    private func card(_ mistake: MemoryItem) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(alignment: .firstTextBaseline) {
                Label {
                    Text(verbatim: mistake.sourceDetail.isEmpty ? String(localized: mistake.source.title) : mistake.sourceDetail)
                        .lineLimit(1)
                } icon: {
                    Image(systemName: "waveform")
                }
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.accent)
                Spacer(minLength: 8)
                Text("^[\(mistakes.count) mistake](inflect: true)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize()
            }
            MistakePractice.quote(said: mistake.mistakeOriginal, correction: mistake.context.isEmpty ? mistake.word : mistake.context)
                .font(.title2.weight(.semibold))
                .environment(\.locale, Locale(identifier: "de"))
            HStack {
                Text("Tap to fix it")
                Spacer()
                Text(mistake.createdAt, format: .relative(presentation: .named))
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
        .multilineTextAlignment(.leading)
        .padding(Spacing.cardLarge)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
        .contentShape(.rect(cornerRadius: Radius.hero, style: .continuous))
        // The cards waiting underneath.
        .background(alignment: .bottom) {
            if mistakes.count > 1 {
                ZStack(alignment: .bottom) {
                    if mistakes.count > 2 {
                        RoundedRectangle(cornerRadius: Radius.hero, style: .continuous)
                            .fill(.primary.opacity(0.05))
                            .padding(.horizontal, 28)
                            .offset(y: 20)
                    }
                    RoundedRectangle(cornerRadius: Radius.hero, style: .continuous)
                        .fill(.primary.opacity(0.09))
                        .padding(.horizontal, 14)
                        .offset(y: 10)
                }
            }
        }
        .padding(.bottom, mistakes.count > 2 ? 20 : mistakes.count > 1 ? 10 : 0)
    }

    private var empty: some View {
        HStack(spacing: Spacing.grid) {
            Image(systemName: "checkmark.seal.fill")
                .font(.title)
                .foregroundStyle(.accent)
                .accessibilityHidden(true)
            VStack(alignment: .leading, spacing: 3) {
                Text("Nothing to fix")
                    .font(.headline)
                Text("Mistakes from your conversations and 60 seconds land here.")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer(minLength: 0)
        }
        .padding(Spacing.cardLarge)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
        .fontDesign(.rounded)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    MistakesCard {}
        .padding(Spacing.screen)
        .skyBackground()
        .modelContainer(AlltagStore.preview)
}
