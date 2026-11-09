//
//  DayListExtraDesigns.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Eight additional layouts for comparing the same Today actions.
struct DayListExtraVariant: View {
    let design: DayListDesign
    let items: [DayItem]

    @ViewBuilder var body: some View {
        switch design {
        case .timeline: timeline
        case .spotlight: spotlight
        case .numbered: numbered
        case .ribbons: ribbons
        case .mosaic: mosaic
        case .tickets: tickets
        case .gallery: gallery
        case .compact: compact
        default: EmptyView()
        }
    }

    // MARK: Timeline

    private var timeline: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                Button(action: item.action) {
                    HStack(alignment: .top, spacing: Spacing.grid) {
                        VStack(spacing: 0) {
                            Image(systemName: item.systemImage)
                                .font(.footnote.weight(.semibold))
                                .foregroundStyle(.accent)
                                .frame(width: 36, height: 36)
                                .background(.accent.opacity(AccentTint.selected), in: Circle())
                            Rectangle()
                                .fill(index == items.count - 1 ? .clear : Color.accent.opacity(0.22))
                                .frame(width: 1, height: 36)
                        }
                        .accessibilityHidden(true)
                        label(item)
                            .padding(.top, 2)
                        Spacer(minLength: 0)
                    }
                    .padding(.horizontal, Spacing.card)
                    .contentShape(.rect)
                }
                .buttonStyle(.plain)
                .accessibilityElement(children: .combine)
            }
        }
        .padding(.vertical, Spacing.card)
        .background(.surface, in: .rect(cornerRadius: Radius.card, style: .continuous))
    }

    // MARK: Spotlight

    private var spotlight: some View {
        VStack(spacing: Spacing.grid) {
            if let first = items.first {
                Button(action: first.action) {
                    HStack(alignment: .bottom, spacing: Spacing.card) {
                        label(first, title: .title2.weight(.semibold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Image(systemName: first.systemImage)
                            .font(.system(size: 48, weight: .ultraLight))
                            .foregroundStyle(.accent)
                            .frame(width: 76, height: 76)
                            .accessibilityHidden(true)
                    }
                    .padding(Spacing.cardLarge)
                    .frame(maxWidth: .infinity, minHeight: 158, alignment: .bottomLeading)
                    .background(.accent.opacity(AccentTint.selected),
                                in: .rect(cornerRadius: Radius.card, style: .continuous))
                }
                .buttonStyle(.plain)
                .accessibilityElement(children: .combine)
            }
            VStack(spacing: 0) {
                ForEach(items.dropFirst()) { item in
                    if item.id != items.dropFirst().first?.id { Divider().padding(.leading, 56) }
                    Button(action: item.action) {
                        HStack(spacing: Spacing.grid) {
                            symbol(item, size: 34)
                            label(item)
                            Spacer(minLength: 0)
                        }
                        .padding(Spacing.card)
                        .contentShape(.rect)
                    }
                    .buttonStyle(.plain)
                    .accessibilityElement(children: .combine)
                }
            }
            .background(.surface, in: .rect(cornerRadius: Radius.card, style: .continuous))
        }
    }

    // MARK: Numbered

    private var numbered: some View {
        VStack(spacing: 0) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                Button(action: item.action) {
                    HStack(alignment: .firstTextBaseline, spacing: Spacing.card) {
                        Text(verbatim: String(format: "%02d", index + 1))
                            .font(.title2.weight(.light).monospacedDigit())
                            .foregroundStyle(.accent)
                            .frame(width: 42, alignment: .leading)
                            .accessibilityHidden(true)
                        label(item, title: .headline)
                        Spacer(minLength: 0)
                        Image(systemName: "arrow.up.right")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.tertiary)
                            .accessibilityHidden(true)
                    }
                    .padding(.vertical, Spacing.card)
                    .contentShape(.rect)
                }
                .buttonStyle(.plain)
                .accessibilityElement(children: .combine)
                if index < items.count - 1 { Divider() }
            }
        }
        .padding(.horizontal, Spacing.card)
        .background(.surface, in: .rect(cornerRadius: Radius.card, style: .continuous))
    }

    // MARK: Ribbons

    private var ribbons: some View {
        VStack(spacing: 8) {
            ForEach(items) { item in
                Button(action: item.action) {
                    HStack(spacing: Spacing.grid) {
                        Image(systemName: item.systemImage)
                            .font(.title3)
                            .foregroundStyle(.accent)
                            .frame(width: 36)
                            .accessibilityHidden(true)
                        label(item)
                        Spacer(minLength: 0)
                        Image(systemName: "arrow.right")
                            .font(.footnote.weight(.medium))
                            .foregroundStyle(.secondary)
                            .accessibilityHidden(true)
                    }
                    .padding(.horizontal, Spacing.card)
                    .padding(.vertical, 14)
                    .frame(minHeight: Spacing.rowMinHeight)
                    .background(.surface, in: Capsule())
                    .overlay(alignment: .leading) {
                        Capsule()
                            .fill(.accent)
                            .frame(width: 3)
                            .padding(.vertical, 15)
                            .accessibilityHidden(true)
                    }
                }
                .buttonStyle(.plain)
                .accessibilityElement(children: .combine)
            }
        }
    }

    // MARK: Mosaic

    private var mosaic: some View {
        VStack(spacing: Spacing.grid) {
            if let first = items.first {
                Button(action: first.action) {
                    HStack(spacing: Spacing.card) {
                        symbol(first, size: 60)
                        label(first, title: .title3.weight(.semibold))
                        Spacer(minLength: 0)
                    }
                    .padding(Spacing.card)
                    .frame(maxWidth: .infinity, minHeight: 110, alignment: .leading)
                    .background(.surface, in: .rect(cornerRadius: Radius.card, style: .continuous))
                }
                .buttonStyle(.plain)
                .accessibilityElement(children: .combine)
            }
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: Spacing.grid) {
                ForEach(items.dropFirst()) { item in
                    Button(action: item.action) {
                        VStack(alignment: .leading, spacing: Spacing.grid) {
                            Image(systemName: item.systemImage)
                                .font(.title2)
                                .foregroundStyle(.accent)
                                .accessibilityHidden(true)
                            Spacer(minLength: 0)
                            label(item, subtitle: .caption)
                        }
                        .padding(Spacing.card)
                        .frame(maxWidth: .infinity, minHeight: 138, alignment: .topLeading)
                        .background(.surfaceSecondary, in: .rect(cornerRadius: Radius.innerCard,
                                                                 style: .continuous))
                    }
                    .buttonStyle(.plain)
                    .accessibilityElement(children: .combine)
                }
            }
        }
    }

    // MARK: Tickets

    private var tickets: some View {
        VStack(spacing: Spacing.grid) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                Button(action: item.action) {
                    HStack(spacing: Spacing.card) {
                        VStack(spacing: 6) {
                            Image(systemName: item.systemImage)
                                .font(.title2)
                            Text(verbatim: String(format: "%02d", index + 1))
                                .font(.caption.monospacedDigit())
                        }
                        .foregroundStyle(.accent)
                        .frame(width: 58)
                        .accessibilityHidden(true)
                        Rectangle()
                            .strokeBorder(style: StrokeStyle(lineWidth: 1, dash: [3, 4]))
                            .foregroundStyle(.separator)
                            .frame(width: 1)
                            .accessibilityHidden(true)
                        label(item)
                            .padding(.vertical, Spacing.card)
                        Spacer(minLength: 0)
                    }
                    .padding(.horizontal, Spacing.card)
                    .frame(maxWidth: .infinity, minHeight: 90, alignment: .leading)
                    .background(.surface, in: .rect(cornerRadius: Radius.innerCard, style: .continuous))
                    .overlay {
                        RoundedRectangle(cornerRadius: Radius.innerCard, style: .continuous)
                            .strokeBorder(.separator, style: StrokeStyle(lineWidth: 1, dash: [5, 5]))
                    }
                }
                .buttonStyle(.plain)
                .accessibilityElement(children: .combine)
            }
        }
    }

    // MARK: Gallery

    private var gallery: some View {
        VStack(spacing: Spacing.grid) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                Button(action: item.action) {
                    HStack(spacing: Spacing.card) {
                        if index.isMultiple(of: 2) { galleryArtwork(item) }
                        label(item, title: .title3.weight(.semibold))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        if !index.isMultiple(of: 2) { galleryArtwork(item) }
                    }
                    .padding(Spacing.card)
                    .frame(maxWidth: .infinity, minHeight: 116)
                    .background(.surface, in: .rect(cornerRadius: Radius.card, style: .continuous))
                }
                .buttonStyle(.plain)
                .accessibilityElement(children: .combine)
            }
        }
    }

    // MARK: Compact

    private var compact: some View {
        VStack(spacing: 6) {
            ForEach(items) { item in
                Button(action: item.action) {
                    HStack(spacing: Spacing.grid) {
                        symbol(item, size: Spacing.minTouchTarget)
                        VStack(alignment: .leading, spacing: 1) {
                            Text(item.title)
                                .font(.subheadline.weight(.semibold))
                            Text(item.subtitle)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        .multilineTextAlignment(.leading)
                        Spacer(minLength: 0)
                        Image(systemName: "chevron.right")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.tertiary)
                            .accessibilityHidden(true)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .frame(minHeight: 58)
                    .background(.surface, in: .rect(cornerRadius: Radius.tile, style: .continuous))
                }
                .buttonStyle(.plain)
                .accessibilityElement(children: .combine)
            }
        }
    }

    // MARK: Shared parts

    private func label(_ item: DayItem, title: Font = .headline, subtitle: Font = .subheadline) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(item.title)
                .font(title)
                .foregroundStyle(.primary)
            Text(item.subtitle)
                .font(subtitle)
                .foregroundStyle(.secondary)
        }
        .multilineTextAlignment(.leading)
        .fixedSize(horizontal: false, vertical: true)
    }

    private func symbol(_ item: DayItem, size: CGFloat) -> some View {
        Image(systemName: item.systemImage)
            .font(.title3)
            .foregroundStyle(.accent)
            .frame(width: size, height: size)
            .background(.accent.opacity(AccentTint.selected),
                        in: .rect(cornerRadius: Radius.tile, style: .continuous))
            .accessibilityHidden(true)
    }

    private func galleryArtwork(_ item: DayItem) -> some View {
        ScenarioArtwork(systemImage: item.systemImage, symbolSize: 30, cornerRadius: Radius.innerCard)
            .frame(width: 78, height: 78)
            .accessibilityHidden(true)
    }
}
