//
//  WriteOptions.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 14.11.26.
//

import SwiftUI

/// Choosing how much time there is and what to write, on the Write screen.
///
/// TEMPORARY (#263): three designs to choose from.
/// 1 a segmented control for the length and a row of glass chips for the kind;
/// 2 two glass menus side by side, the smallest;
/// 3 the lengths with their minutes, and the kinds as tiles (with "My own topic" among them).
struct WriteOptions: View {
    let design: Int
    let level: Level
    @Binding var length: WritingLength
    @Binding var kind: WritingKind?
    /// Where "My own topic" zooms out of, when it is a tile here.
    let ownSource: Namespace.ID
    let onOwn: () -> Void

    var body: some View {
        Group {
            switch design {
            case 1: menus
            case 2: tiles
            default: chips
            }
        }
        .sensoryFeedback(.selection, trigger: length)
        .sensoryFeedback(.selection, trigger: kind)
    }

    // MARK: 1 · Segments and chips

    private var chips: some View {
        VStack(alignment: .leading, spacing: 12) {
            Picker("How much time", selection: $length) {
                ForEach(WritingLength.allCases) { Text($0.title).tag($0) }
            }
            .pickerStyle(.segmented)
            ScrollView(.horizontal) {
                GlassEffectContainer(spacing: 8) {
                    HStack(spacing: 8) {
                        WriteChip(title: "All", systemImage: "square.grid.2x2.fill", isOn: kind == nil) { kind = nil }
                        ForEach(WritingKind.ofTasks) { item in
                            WriteChip(title: item.title, systemImage: item.systemImage, isOn: kind == item) { kind = item }
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .scrollClipDisabled()
        }
    }

    // MARK: 2 · Menus

    private var menus: some View {
        GlassEffectContainer(spacing: 10) {
            HStack(spacing: 10) {
                Menu {
                    Picker("How much time", selection: $length) {
                        ForEach(WritingLength.allCases) { item in
                            Label {
                                Text("\(Text(item.title)) · \(item.minutes(for: level)) min")
                            } icon: {
                                Image(systemName: item.systemImage)
                            }
                            .tag(item)
                        }
                    }
                } label: {
                    menuLabel(Text(length.title), systemImage: length.systemImage)
                }
                Menu {
                    Picker("What to write", selection: $kind) {
                        Label("All kinds", systemImage: "square.grid.2x2.fill").tag(WritingKind?.none)
                        ForEach(WritingKind.ofTasks) { item in
                            Label { Text(item.title) } icon: { Image(systemName: item.systemImage) }
                                .tag(WritingKind?.some(item))
                        }
                    }
                } label: {
                    menuLabel(kind.map { Text($0.title) } ?? Text("All kinds"),
                              systemImage: kind?.systemImage ?? "square.grid.2x2.fill")
                }
            }
        }
    }

    private func menuLabel(_ title: Text, systemImage: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: systemImage)
                .foregroundStyle(.accent)
            title
                .lineLimit(1)
            Spacer(minLength: 4)
            Image(systemName: "chevron.up.chevron.down")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.secondary)
        }
        .font(.subheadline.weight(.semibold))
        .foregroundStyle(.primary)
        .padding(.horizontal, 16)
        .frame(maxWidth: .infinity, minHeight: 48)
        .glassEffect(.regular.interactive(), in: .capsule)
    }

    // MARK: 3 · Tiles

    private var tiles: some View {
        VStack(alignment: .leading, spacing: 12) {
            GlassEffectContainer(spacing: 10) {
                HStack(spacing: 10) {
                    ForEach(WritingLength.allCases) { item in
                        WriteTile(title: Text(item.title), detail: Text("\(item.minutes(for: level)) min"),
                                  systemImage: item.systemImage, isOn: length == item) { length = item }
                    }
                }
            }
            GlassEffectContainer(spacing: 10) {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10), count: 3), spacing: 10) {
                    WriteTile(title: Text("All"), detail: nil, systemImage: "square.grid.2x2.fill", isOn: kind == nil) { kind = nil }
                    ForEach(WritingKind.ofTasks) { item in
                        WriteTile(title: Text(item.title), detail: nil, systemImage: item.systemImage, isOn: kind == item) {
                            kind = item
                        }
                    }
                    WriteTile(title: Text(WritingKind.own.title), detail: nil, systemImage: WritingKind.own.systemImage,
                              isOn: false, action: onOwn)
                        .matchedTransitionSource(id: "own", in: ownSource)
                }
            }
        }
    }
}

/// A glass chip that is filled with the theme colour when it is the choice.
private struct WriteChip: View {
    let title: LocalizedStringResource
    let systemImage: String
    let isOn: Bool
    let action: () -> Void

    var body: some View {
        if isOn {
            button.buttonStyle(.glassProminent)
        } else {
            button.buttonStyle(.glass)
        }
    }

    private var button: some View {
        Button(action: action) {
            Label { Text(title) } icon: { Image(systemName: systemImage) }
                .font(.subheadline.weight(.semibold))
        }
        .buttonBorderShape(.capsule)
        .accessibilityAddTraits(isOn ? .isSelected : [])
    }
}

/// A glass tile with a symbol over its title, filled with the theme colour when it is the choice.
private struct WriteTile: View {
    let title: Text
    let detail: Text?
    let systemImage: String
    let isOn: Bool
    let action: () -> Void

    var body: some View {
        if isOn {
            button.buttonStyle(.glassProminent)
        } else {
            button.buttonStyle(.glass)
        }
    }

    private var button: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: systemImage)
                    .font(.title3)
                title
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                if let detail {
                    detail
                        .font(.footnote)
                        .opacity(0.7)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 60)
        }
        .buttonBorderShape(.roundedRectangle(radius: Radius.card))
        .accessibilityAddTraits(isOn ? .isSelected : [])
    }
}
