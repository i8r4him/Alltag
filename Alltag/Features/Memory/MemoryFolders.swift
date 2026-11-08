//
//  MemoryFolders.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 08.11.26.
//

import SwiftUI

/// Three folders above the word list: From your day, Saved and Mistakes, each
/// showing its first words and a count. Tapping one filters the list; tapping
/// it again shows everything.
struct MemoryFolders: View {
    let items: [MemoryItem]
    @Binding var filter: MemoryFilter

    static let folders: [MemoryFilter] = [.fromYourDay, .saved, .mistakes]

    var body: some View {
        HStack(alignment: .top, spacing: Spacing.grid) {
            ForEach(Self.folders) { folder in
                let contents = items.filter { folder.includes($0, at: .now) }
                Button {
                    filter = filter == folder ? .all : folder
                } label: {
                    FolderTile(title: folder.title, words: contents.prefix(3).map(\.displayWord),
                               count: contents.count, isSelected: filter == folder,
                               tint: folder == .mistakes ? .mistake : .accent)
                }
                .buttonStyle(.tile)
                .accessibilityAddTraits(filter == folder ? .isSelected : [])
            }
        }
    }
}

private struct FolderTile: View {
    let title: LocalizedStringResource
    let words: [String]
    let count: Int
    let isSelected: Bool
    let tint: Color

    var body: some View {
        VStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 5) {
                ForEach(0..<3, id: \.self) { index in
                    if index < words.count {
                        Text(verbatim: words[index])
                            .font(.caption2.weight(.medium))
                            .lineLimit(1)
                            .padding(.horizontal, 7)
                            .padding(.vertical, 4)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(tint.opacity(0.14), in: .rect(cornerRadius: 7, style: .continuous))
                    } else {
                        RoundedRectangle(cornerRadius: 7, style: .continuous)
                            .fill(.controlFill)
                            .frame(height: 22)
                    }
                }
            }
            .padding(10)
            .frame(maxWidth: .infinity)
            .aspectRatio(1, contentMode: .fit)
            .background(.surface, in: .rect(cornerRadius: Radius.option, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: Radius.option, style: .continuous)
                    .strokeBorder(tint, lineWidth: isSelected ? 2 : 0)
            }
            .accessibilityHidden(true)

            VStack(spacing: 2) {
                Text(title)
                    .textRole(.body)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                Text("^[\(count) item](inflect: true)")
                    .textRole(.meta)
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .accessibilityElement(children: .combine)
    }
}

#Preview {
    @Previewable @State var filter = MemoryFilter.all
    MemoryFolders(items: MockMemoryItems.make(), filter: $filter)
        .padding(Spacing.screen)
        .background(.screenBackground)
}
