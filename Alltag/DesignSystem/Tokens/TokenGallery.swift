//
//  TokenGallery.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Shows every design token, for checking them in light and dark mode.
struct TokenGallery: View {
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Spacing.section) {
                Text("Design tokens")
                    .textRole(.largeTitle)

                section("Colours") {
                    LazyVGrid(columns: [GridItem(.adaptive(minimum: 100), spacing: Spacing.grid)], spacing: Spacing.grid) {
                        ForEach(Self.swatches, id: \.name) { swatch in
                            SwatchView(name: swatch.name, color: swatch.color)
                        }
                    }
                }

                section("Text roles") {
                    VStack(alignment: .leading, spacing: 10) {
                        ForEach(TextRole.allCases, id: \.self) { role in
                            Text(String(describing: role))
                                .textRole(role)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                        }
                    }
                }

                section("Accent in use") {
                    AccentSample()
                }

                section("Radii") {
                    HStack(spacing: Spacing.grid) {
                        ForEach(Self.radii, id: \.name) { radius in
                            VStack(spacing: 6) {
                                RoundedRectangle(cornerRadius: radius.value, style: .continuous)
                                    .fill(.surfaceSecondary)
                                    .frame(width: 56, height: 56)
                                Text(radius.name).textRole(.caption).foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .padding(Spacing.screen)
        }
        .scrollIndicators(.hidden)
        .scrollEdgeEffectStyle(.soft, for: .all)
        .background(.screenBackground)
    }

    private func section(_ title: String, @ViewBuilder content: () -> some View) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title).textRole(.sectionHeader)
            content()
        }
    }

    private static let swatches: [(name: String, color: Color)] = [
        ("screenBackground", .screenBackground), ("surface", .surface),
        ("surfaceSecondary", .surfaceSecondary), ("surfaceTertiary", .surfaceTertiary),
        ("resultCard", .resultCard), ("accent", .accent), ("accentFill", .accentFill),
        ("onAccent", .onAccent), ("success", .success), ("mistake", .mistake)
    ]

    private static let radii: [(name: String, value: CGFloat)] = [
        ("hero", Radius.hero), ("card", Radius.card), ("inner", Radius.innerCard),
        ("option", Radius.option), ("tile", Radius.tile)
    ]
}

private struct SwatchView: View {
    let name: String
    let color: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            RoundedRectangle(cornerRadius: Radius.tile, style: .continuous)
                .fill(color)
                .frame(height: 56)
                .overlay {
                    RoundedRectangle(cornerRadius: Radius.tile, style: .continuous)
                        .strokeBorder(.separator, lineWidth: 0.5)
                }
            Text(name).textRole(.caption).foregroundStyle(.secondary)
        }
    }
}

private struct AccentSample: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Today's focus").textRole(.eyebrow).foregroundStyle(.accent)
            Text("Speak German").textRole(.cardTitle)
            HStack(spacing: Spacing.grid) {
                Image(systemName: "waveform")
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(.onAccent)
                    .frame(width: 56, height: 56)
                    .background(.accentFill, in: .circle)
                Label("Right", systemImage: "checkmark.circle.fill").foregroundStyle(.success)
                Label("Fix", systemImage: "xmark.circle.fill").foregroundStyle(.mistake)
            }
            .textRole(.bodySmall)
        }
        .padding(Spacing.cardLarge)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(alignment: .topTrailing) {
            RadialGradient(colors: [.accentFill.opacity(AccentTint.glow), .clear], center: .topTrailing, startRadius: 0, endRadius: 220)
        }
        .background(.surface, in: .rect(cornerRadius: Radius.hero, style: .continuous))
    }
}

#Preview("Light") {
    TokenGallery().preferredColorScheme(.light)
}

#Preview("Dark") {
    TokenGallery().preferredColorScheme(.dark)
}

#Preview("Largest text") {
    TokenGallery().dynamicTypeSize(.accessibility3)
}
