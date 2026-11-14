//
//  MistakesCard.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 10.11.26.
//

import SwiftData
import SwiftUI

/// "Fix your mistakes" on Learn: the learner's own mistakes that are due now,
/// the one to fix first on top with the wrong words underlined in coral, and
/// how many there are. When none are due it says when the next one comes
/// back; with no mistakes at all, where they come from.
struct MistakesCard: View {
    let action: () -> Void

    /// Every mistake that can be practised, the one due first on top. Which are due is worked out when drawing.
    @Query(MistakePractice.practisable) private var mistakes: [MemoryItem]
    /// The practice zooms out of the card and back into it.
    @Environment(\.mistakesZoom) private var zoom
    @State private var taps = 0
    // TEMPORARY (#251): the card's design.
    @AppStorage(MistakeDesign.card.key) private var design = 1

    /// The id the card and the practice share for the zoom.
    static let zoomID = "mistakes"

    var body: some View {
        let due = MistakePractice.due(mistakes)
        Group {
            if let first = due.first {
                VStack(spacing: 12) {
                    MistakeDesignSwitcher(.card)
                    source(card(first, count: due.count))
                }
            } else if mistakes.isEmpty {
                empty
            } else {
                StateCard(systemImage: "checkmark.seal", title: Text("All fixed for now"),
                          explanation: MistakeWhen.nextReturn(MistakePractice.nextReturn(mistakes)))
            }
        }
        .fontDesign(.rounded)
        .sensoryFeedback(.impact(weight: .medium), trigger: taps)
    }

    private func start() {
        taps += 1
        action()
    }

    @ViewBuilder
    private func source(_ card: some View) -> some View {
        if let zoom {
            card.matchedTransitionSource(id: Self.zoomID, in: zoom)
        } else {
            card
        }
    }

    @ViewBuilder
    private func card(_ mistake: MemoryItem, count: Int) -> some View {
        switch design {
        case 2:
            hero(mistake, count: count)
        case 3:
            tappable { row(mistake, count: count) }
        default:
            tappable { stack(mistake, count: count) }
        }
    }

    private func tappable(@ViewBuilder label: () -> some View) -> some View {
        Button(action: start, label: label)
            .buttonStyle(.card)
            .accessibilityElement(children: .combine)
            .accessibilityHint("Starts a one-minute exercise on your mistakes.")
    }

    private func quote(_ mistake: MemoryItem) -> some View {
        MistakePractice.quote(said: mistake.mistakeOriginal, correction: mistake.context.isEmpty ? mistake.word : mistake.context)
            .environment(\.locale, Locale(identifier: "de"))
    }

    // MARK: 1 · The stack, with the quote

    private func stack(_ mistake: MemoryItem, count: Int) -> some View {
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
                Text("^[\(count) mistake](inflect: true)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .fixedSize()
            }
            quote(mistake).font(.title2.weight(.semibold))
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
            if count > 1 {
                ZStack(alignment: .bottom) {
                    if count > 2 {
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
        .padding(.bottom, count > 2 ? 20 : count > 1 ? 10 : 0)
    }

    // MARK: 2 · The Focus card's layout, with the big button

    private func hero(_ mistake: MemoryItem, count: Int) -> some View {
        VStack(spacing: 18) {
            HStack(alignment: .center, spacing: 16) {
                VStack(alignment: .leading, spacing: 6) {
                    Text("^[\(count) mistake](inflect: true) to fix")
                        .font(.title3.weight(.semibold))
                    quote(mistake)
                        .font(.title3)
                        .lineLimit(3)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .accessibilityElement(children: .combine)
                ScenarioArtwork(systemImage: "pencil.and.scribble")
                    .frame(width: 88, height: 88)
            }
            Button(action: start) {
                Label("Fix them", systemImage: "wand.and.stars")
            }
            .buttonStyle(.primary)
        }
        .padding(Spacing.cardLarge)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }

    // MARK: 3 · A compact row

    private func row(_ mistake: MemoryItem, count: Int) -> some View {
        HStack(spacing: 14) {
            Text(verbatim: "\(count)")
                .font(.title3.weight(.bold))
                .monospacedDigit()
                .foregroundStyle(.mistake)
                .frame(width: 48, height: 48)
                .background(.mistake.opacity(0.16), in: .circle)
                .accessibilityLabel(Text("^[\(count) mistake](inflect: true)"))
            VStack(alignment: .leading, spacing: 3) {
                quote(mistake)
                    .font(.headline)
                    .lineLimit(1)
                Text("Tap to fix it")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            Spacer(minLength: 0)
            Image(systemName: "chevron.right")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.tertiary)
                .accessibilityHidden(true)
        }
        .multilineTextAlignment(.leading)
        .padding(Spacing.cardLarge)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
        .contentShape(.rect(cornerRadius: Radius.hero, style: .continuous))
    }

    // MARK: No mistakes at all

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
        .accessibilityElement(children: .combine)
    }
}

extension EnvironmentValues {
    /// The namespace the mistakes card and the practice share, so the practice can zoom out of the card.
    @Entry var mistakesZoom: Namespace.ID?
}

/// When a mistake comes back, in words.
enum MistakeWhen {
    /// For the card when nothing is due: when the next one returns, or that all are learned.
    static func nextReturn(_ date: Date?, from now: Date = .now) -> Text {
        guard let date else { return Text("You know them all. New mistakes land here.") }
        return switch ReviewSchedule.days(until: date, from: now) {
        case 0: Text("The next one comes back later today.")
        case 1: Text("The next one comes back tomorrow.")
        case let days: Text("The next one comes back in ^[\(days) day](inflect: true).")
        }
    }

    /// For one answer: where it left the mistake.
    static func outcome(_ outcome: MistakeRoundModel.Outcome, from now: Date = .now) -> Text {
        if !outcome.wasRight { return Text("Comes back next time") }
        if outcome.step.isLearned { return Text("Learned") }
        return switch ReviewSchedule.days(until: outcome.step.nextReview, from: now) {
        case 0: Text("Back later today")
        case 1: Text("Back tomorrow")
        case let days: Text("Back in ^[\(days) day](inflect: true)")
        }
    }
}

#Preview {
    MistakesCard {}
        .padding(Spacing.screen)
        .skyBackground()
        .modelContainer(AlltagStore.preview)
}
