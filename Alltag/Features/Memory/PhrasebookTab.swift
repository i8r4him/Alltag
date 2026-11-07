//
//  PhrasebookTab.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Phrases grouped by the place they are useful in.
struct PhrasebookGroup: Identifiable, Equatable {
    let place: String
    let symbol: String
    let phrases: [Phrase]

    var id: String { place }
    var isNew: Bool { phrases.contains(where: \.isNew) }

    /// Groups phrases by place: groups with new phrases first, then in the
    /// order places were first added. Phrases keep the order they were added in.
    static func groups(from phrases: [Phrase]) -> [PhrasebookGroup] {
        let sorted = phrases.sorted { $0.createdAt < $1.createdAt }
        var order: [String] = []
        var byPlace: [String: [Phrase]] = [:]
        for phrase in sorted {
            if byPlace[phrase.place] == nil { order.append(phrase.place) }
            byPlace[phrase.place, default: []].append(phrase)
        }
        let groups = order.map { place in
            let phrases = byPlace[place] ?? []
            return PhrasebookGroup(place: place, symbol: phrases.first?.placeSymbol ?? "text.bubble", phrases: phrases)
        }
        return groups.filter(\.isNew) + groups.filter { !$0.isNew }
    }
}

/// The Phrasebook tab in Memory.
struct PhrasebookTab: View {
    let phrases: [Phrase]
    let onListen: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Phrases you needed, grouped by where you needed them.")
                .textRole(.bodySmall)
                .foregroundStyle(.secondary)
                .padding(.horizontal, 4)
            ForEach(PhrasebookGroup.groups(from: phrases)) { group in
                GroupCard(group: group, onListen: onListen)
            }
        }
    }
}

private struct GroupCard: View {
    let group: PhrasebookGroup
    let onListen: (String) -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 10) {
                Image(systemName: group.symbol)
                    .font(.system(size: 18))
                    .accessibilityHidden(true)
                Text(verbatim: group.place)
                    .textRole(.cardTitle)
                    .frame(maxWidth: .infinity, alignment: .leading)
                if group.isNew {
                    Text("New")
                        .textRole(.caption)
                        .fontWeight(.semibold)
                        .textCase(.uppercase)
                        .foregroundStyle(.accent)
                }
                Text(group.phrases.count, format: .number)
                    .textRole(.meta)
                    .foregroundStyle(.tertiary)
                    .accessibilityLabel(Text("^[\(group.phrases.count) phrase](inflect: true)"))
            }
            .padding(.horizontal, Spacing.card)
            .padding(.top, 14)
            .padding(.bottom, 6)
            .accessibilityElement(children: .combine)
            .accessibilityAddTraits(.isHeader)

            ForEach(Array(group.phrases.enumerated()), id: \.element.id) { index, phrase in
                if index > 0 { Divider().padding(.leading, Spacing.card) }
                Button { onListen(phrase.german) } label: {
                    HStack(spacing: 12) {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(verbatim: phrase.german).textRole(.body).foregroundStyle(.primary)
                            Text(verbatim: phrase.english).textRole(.meta).foregroundStyle(.secondary)
                        }
                        .multilineTextAlignment(.leading)
                        Spacer(minLength: 8)
                        Image(systemName: "speaker.wave.2")
                            .foregroundStyle(.tertiary)
                            .accessibilityHidden(true)
                    }
                    .padding(.horizontal, Spacing.card)
                    .padding(.vertical, 10)
                    .contentShape(.rect)
                }
                .buttonStyle(.plain)
                .accessibilityElement(children: .combine)
                .accessibilityHint("Plays the phrase.")
            }
            Spacer().frame(height: 6)
        }
        .background(.surface, in: .rect(cornerRadius: Radius.card, style: .continuous))
    }
}
