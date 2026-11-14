//
//  MistakeRoundEnd.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 14.11.26.
//

import SwiftUI

/// The end of a round: what was fixed, what comes back, and when.
///
/// TEMPORARY (#251): three designs to choose from.
/// 1 the numbers, large; 2 two lists, "Fixed" and "Comes back"; 3 every
/// mistake with its steps towards learned.
struct MistakeRoundEnd: View {
    let model: MistakeRoundModel
    /// More mistakes are due: offer another round.
    let hasMore: Bool
    let onAgain: () -> Void
    let onDone: () -> Void
    @AppStorage(MistakeDesign.end.key) private var stored = 1

    private var design: Int { MistakeDesign.end.clamped(stored) }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("\(model.fixed.count) of \(model.total) fixed")
                        .font(.title2.weight(.bold))
                        .accessibilityAddTraits(.isHeader)
                    Group {
                        if model.comingBack.isEmpty {
                            Text("Each one comes back a little later, until you know it.")
                        } else {
                            Text("The ones you missed come back next time.")
                        }
                    }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                }
                .padding(.horizontal, 4)
                .padding(.top, 24)
                MistakeDesignSwitcher(.end)
                switch design {
                case 2: lists
                case 3: steps
                default: numbers
                }
            }
            .padding(.bottom, 16)
        }
        .scrollIndicators(.hidden)
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 12) {
                if hasMore {
                    Button(action: onAgain) { Text("Another round") }
                        .buttonStyle(.primary)
                    Button(action: onDone) {
                        Text("Done").font(.headline).frame(maxWidth: .infinity, minHeight: 34)
                    }
                    .buttonStyle(.glass)
                } else {
                    Button(action: onDone) { Text("Done") }
                        .buttonStyle(.primary)
                }
            }
            .padding(.bottom, 12)
        }
        .sensoryFeedback(.success, trigger: true)
    }

    // MARK: 1 · Numbers

    private var numbers: some View {
        VStack(spacing: 18) {
            ScenarioArtwork(systemImage: model.comingBack.isEmpty ? "checkmark.seal.fill" : "arrow.triangle.2.circlepath")
                .frame(width: 120, height: 120)
                .padding(.top, 8)
            HStack(spacing: Spacing.grid) {
                figure(model.fixed.count, "Fixed", systemImage: "checkmark.circle.fill", style: AnyShapeStyle(.success))
                figure(model.comingBack.count, "Come back", systemImage: "arrow.uturn.backward.circle.fill",
                       style: AnyShapeStyle(.mistake))
                figure(model.outcomes.filter(\.step.isLearned).count, "Learned", systemImage: "star.circle.fill",
                       style: AnyShapeStyle(.accent))
            }
            if let next = model.fixed.filter({ !$0.step.isLearned }).map(\.step.nextReview).min() {
                Label { MistakeWhen.nextReturn(next) } icon: { Image(systemName: "calendar") }
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
    }

    private func figure(_ count: Int, _ title: LocalizedStringResource, systemImage: String, style: AnyShapeStyle) -> some View {
        VStack(spacing: 6) {
            Image(systemName: systemImage)
                .font(.title2)
                .foregroundStyle(style)
                .accessibilityHidden(true)
            Text(verbatim: "\(count)")
                .font(.title.weight(.bold))
                .monospacedDigit()
            Text(title)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .glassEffect(.regular, in: .rect(cornerRadius: 26, style: .continuous))
        .accessibilityElement(children: .combine)
    }

    // MARK: 2 · Two lists

    @ViewBuilder
    private var lists: some View {
        if !model.fixed.isEmpty {
            list("Fixed", systemImage: "checkmark.circle.fill", style: AnyShapeStyle(.success), outcomes: model.fixed)
        }
        if !model.comingBack.isEmpty {
            list("Comes back", systemImage: "arrow.uturn.backward.circle.fill", style: AnyShapeStyle(.mistake),
                 outcomes: model.comingBack)
        }
    }

    private func list(_ title: LocalizedStringResource, systemImage: String, style: AnyShapeStyle,
                      outcomes: [MistakeRoundModel.Outcome]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Label { Text(title) } icon: { Image(systemName: systemImage).foregroundStyle(style) }
                .textRole(.sectionHeader)
                .padding(.horizontal, 4)
            VStack(alignment: .leading, spacing: 0) {
                ForEach(Array(outcomes.enumerated()), id: \.element.id) { index, outcome in
                    if index > 0 { Divider() }
                    VStack(alignment: .leading, spacing: 4) {
                        Text(verbatim: outcome.question.correction)
                            .font(.headline)
                            .environment(\.locale, Locale(identifier: "de"))
                        MistakeWhen.outcome(outcome)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.vertical, 12)
                    .accessibilityElement(children: .combine)
                }
            }
            .padding(.horizontal, Spacing.cardLarge)
            .padding(.vertical, 6)
            .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
        }
    }

    // MARK: 3 · Steps to learned

    private var steps: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(Array(model.outcomes.enumerated()), id: \.element.id) { index, outcome in
                if index > 0 { Divider() }
                VStack(alignment: .leading, spacing: 8) {
                    Text(verbatim: outcome.question.correction)
                        .font(.headline)
                        .environment(\.locale, Locale(identifier: "de"))
                    HStack(spacing: 10) {
                        HStack(spacing: 5) {
                            ForEach(0..<MemoryItem.maxStrength, id: \.self) { step in
                                Capsule()
                                    .fill(step < outcome.step.strength ? AnyShapeStyle(.accentFill) : AnyShapeStyle(.surfaceTertiary))
                                    .frame(width: 22, height: 6)
                            }
                        }
                        .accessibilityElement()
                        .accessibilityLabel(Text("Step \(outcome.step.strength) of \(MemoryItem.maxStrength)"))
                        Spacer(minLength: 0)
                        Label {
                            MistakeWhen.outcome(outcome)
                        } icon: {
                            Image(systemName: outcome.wasRight ? "checkmark.circle.fill" : "arrow.uturn.backward.circle.fill")
                                .foregroundStyle(outcome.wasRight ? AnyShapeStyle(.success) : AnyShapeStyle(.mistake))
                        }
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 14)
                .accessibilityElement(children: .combine)
            }
        }
        .padding(.horizontal, Spacing.cardLarge)
        .padding(.vertical, 6)
        .glassEffect(.regular, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }
}
