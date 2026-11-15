//
//  ReaderDesignSwitcher.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// The ways of showing a tapped word that are being tried. Temporary: the
/// maintainer picks one, and the others and the switcher go before the merge.
enum ReaderWordDesign: Int, CaseIterable {
    /// A glass card above the tab bar; the text scrolls behind it.
    case bottom
    /// A small sheet that can grow; the text stays tappable behind it.
    case sheet
    /// A card right under the paragraph the word is in.
    case underParagraph

    var name: String {
        switch self {
        case .bottom: "Card at the bottom"
        case .sheet: "Small sheet"
        case .underParagraph: "Under the paragraph"
        }
    }
}

/// "‹ 1 / 3 ›" in a glass capsule, with the design's name under it.
struct ReaderDesignSwitcher: View {
    @Binding var design: ReaderWordDesign

    var body: some View {
        VStack(spacing: 6) {
            HStack(spacing: 4) {
                Button { move(by: -1) } label: {
                    Label { Text(verbatim: "Previous design") } icon: { Image(systemName: "chevron.left") }
                        .frame(width: 44, height: 44)
                        .contentShape(.rect)
                }
                Text(verbatim: "\(design.rawValue + 1) / \(ReaderWordDesign.allCases.count)")
                    .font(.subheadline.weight(.semibold).monospacedDigit())
                    .frame(minWidth: 44)
                Button { move(by: 1) } label: {
                    Label { Text(verbatim: "Next design") } icon: { Image(systemName: "chevron.right") }
                        .frame(width: 44, height: 44)
                        .contentShape(.rect)
                }
            }
            .labelStyle(.iconOnly)
            .buttonStyle(.plain)
            .padding(.horizontal, 4)
            .glassEffect(.regular.interactive(), in: .capsule)
            Text(verbatim: design.name)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }

    private func move(by step: Int) {
        let count = ReaderWordDesign.allCases.count
        design = ReaderWordDesign(rawValue: (design.rawValue + step + count) % count) ?? .bottom
    }
}
