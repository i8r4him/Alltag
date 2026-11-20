//
//  EmojiPanel.swift
//  AlltagKeyboard
//
//  Created by Ibrahim Abdullah on 21.11.26.
//

import SwiftUI

/// The emoji, in place of the keys: group by group in a row that scrolls sideways,
/// with the groups, "ABC" and delete underneath, as on Apple's keyboard.
struct EmojiPanel: View {
    let model: KeyboardModel
    /// The group at the left edge.
    @State private var shown: EmojiSection.Kind?
    /// As they were when the panel opened: the row doesn't jump while emoji are chosen.
    @State private var recents = EmojiRecents().list
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.verticalSizeClass) private var verticalSizeClass

    private var sections: [EmojiSection] {
        (recents.isEmpty ? [] : [EmojiSection(kind: .recent, emoji: recents)]) + EmojiCatalog.sections
    }

    private var current: EmojiSection.Kind {
        shown ?? sections.first?.kind ?? .people
    }

    private var rows: [GridItem] {
        Array(repeating: GridItem(.fixed(41), spacing: 2), count: verticalSizeClass == .compact ? 3 : 5)
    }

    var body: some View {
        VStack(spacing: 0) {
            Self.title(of: current)
                .font(.system(size: 13, weight: .semibold))
                .textCase(.uppercase)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 16)
                .frame(height: 24)
            ScrollView(.horizontal) {
                LazyHStack(alignment: .top, spacing: 14) {
                    ForEach(sections) { section in
                        LazyHGrid(rows: rows, spacing: 3) {
                            ForEach(section.emoji, id: \.self) { emoji in
                                Button {
                                    model.insertEmoji(emoji)
                                    EmojiRecents().add(emoji)
                                } label: {
                                    Text(verbatim: emoji)
                                        .font(.system(size: 31))
                                        .frame(width: 41, height: 41)
                                        .contentShape(.rect)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .id(section.kind)
                    }
                }
                .scrollTargetLayout()
                .padding(.horizontal, 8)
            }
            .scrollPosition(id: $shown, anchor: .leading)
            .scrollIndicators(.hidden)
            .scrollEdgeEffectStyle(.soft, for: .all)
            .frame(maxHeight: .infinity)
            bar
                .padding(.horizontal, 6)
                .padding(.bottom, 7)
        }
    }

    /// "ABC" back to the keys, the groups, and delete.
    private var bar: some View {
        HStack(spacing: 0) {
            Button {
                model.closeEmoji()
            } label: {
                Text(verbatim: KeyboardPage.letters.label)
                    .font(.system(size: 17))
                    .frame(width: 48, height: 40)
                    .background(keyFill, in: .rect(cornerRadius: KeyCap.cornerRadius, style: .continuous))
            }
            .accessibilityLabel(Text("Letters"))
            ForEach(sections) { section in
                Button {
                    withAnimation { shown = section.kind }
                } label: {
                    Image(systemName: section.kind.symbol)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(section.kind == current ? Color.primary : Color.secondary)
                        .frame(width: 30, height: 30)
                        .background(Color.primary.opacity(section.kind == current ? 0.12 : 0), in: .circle)
                        .frame(maxWidth: .infinity, minHeight: 40)
                        .contentShape(.rect)
                }
                .accessibilityLabel(Self.title(of: section.kind))
            }
            Button {
                model.deleteFromEmoji()
            } label: {
                Image(systemName: "delete.left")
                    .font(.system(size: 19, weight: .medium))
                    .frame(width: 48, height: 40)
                    .background(keyFill, in: .rect(cornerRadius: KeyCap.cornerRadius, style: .continuous))
            }
            .buttonRepeatBehavior(.enabled)
            .accessibilityLabel(Text("Delete"))
        }
        .buttonStyle(.plain)
    }

    private var keyFill: Color {
        colorScheme == .dark ? .white.opacity(0.162) : .white
    }

    static func title(of kind: EmojiSection.Kind) -> Text {
        switch kind {
        case .recent: Text("Frequently used")
        case .people: Text("Smileys & People")
        case .nature: Text("Animals & Nature")
        case .food: Text("Food & Drink")
        case .activity: Text("Activity")
        case .travel: Text("Travel & Places")
        case .objects: Text("Objects")
        case .symbols: Text("Symbols")
        case .flags: Text("Flags")
        }
    }
}
