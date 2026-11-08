//
//  FocusCardDesigns.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 08.11.26.
//

import SwiftUI

/// Temporary: five Focus card designs to swipe through on Today and choose from.
/// Every design uses the same Start talking button.
enum FocusCardDesign: Int, CaseIterable, Identifiable {
    case original
    case tile
    case minimal
    case bubble
    case poster
    case compact

    var id: Self { self }

    var name: String {
        switch self {
        case .original: "Original"
        case .tile: "Tile"
        case .minimal: "Minimal"
        case .bubble: "Speech bubble"
        case .poster: "Poster"
        case .compact: "Compact"
        }
    }
}

/// Swipe sideways between the designs; the name and number show underneath.
struct FocusCardChooser: View {
    let action: () -> Void
    @State private var current: FocusCardDesign? = .original

    var body: some View {
        VStack(spacing: 10) {
            ScrollView(.horizontal) {
                HStack(alignment: .top, spacing: 0) {
                    ForEach(FocusCardDesign.allCases) { design in
                        FocusCardVariant(design: design, action: action)
                            .padding(.horizontal, 2)
                            .containerRelativeFrame(.horizontal)
                            .id(design)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.paging)
            .scrollPosition(id: $current)
            .scrollIndicators(.hidden)
            .scrollClipDisabled()
            .contentMargins(.horizontal, 0, for: .scrollContent)

            let design = current ?? .original
            HStack(spacing: 6) {
                ForEach(FocusCardDesign.allCases) { option in
                    Circle()
                        .fill(option == design ? AnyShapeStyle(.accent) : AnyShapeStyle(.tertiary))
                        .frame(width: 6, height: 6)
                }
            }
            Text(verbatim: "\(design.rawValue + 1) / \(FocusCardDesign.allCases.count) · \(design.name)")
                .font(.footnote.weight(.semibold))
                .foregroundStyle(.secondary)
                .contentTransition(.numericText())
                .animation(.snappy, value: design)
        }
    }
}

/// One design. Texts are the prototype's, not localised yet.
private struct FocusCardVariant: View {
    let design: FocusCardDesign
    let action: () -> Void

    var body: some View {
        switch design {
        case .original: FocusCard(action: action)
        case .tile: tile
        case .minimal: minimal
        case .bubble: bubble
        case .poster: poster
        case .compact: compact
        }
    }

    // MARK: 2 Tile

    private var tile: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(spacing: 12) {
                icon(size: 48, font: .title2)
                VStack(alignment: .leading, spacing: 2) {
                    Text(verbatim: "Today's focus")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.accent)
                    Text(verbatim: "Phone call · 5 min")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
            titleAndReason(.title2)
            StartTalkingButton(action: action)
        }
        .padding(Spacing.cardLarge)
        .frame(maxWidth: .infinity, alignment: .leading)
        .litCard(cornerRadius: Radius.hero)
    }

    // MARK: 3 Minimal

    private var minimal: some View {
        VStack(spacing: 14) {
            Text(verbatim: "TODAY · 5 MIN")
                .font(.caption.weight(.semibold))
                .tracking(1.5)
                .foregroundStyle(.accent)
            Text(verbatim: "Moving an appointment")
                .font(.title.weight(.bold))
                .multilineTextAlignment(.center)
            Text(verbatim: "A phone call at the dentist, with the word order you mixed up yesterday.")
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 8)
            StartTalkingButton(action: action)
                .padding(.top, 6)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }

    // MARK: 4 Speech bubble

    private var bubble: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 8) {
                Text(verbatim: "Hallo! Shall we practise moving an appointment today? It's a short phone call at the dentist.")
                    .font(.title3.weight(.semibold))
                    .fixedSize(horizontal: false, vertical: true)
                Text(verbatim: "Today's focus · 5 min")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.accent)
            }
            .padding(Spacing.cardLarge)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.surface, in: SpeechBubble())
            StartTalkingButton(action: action)
        }
    }

    // MARK: 5 Poster

    private var poster: some View {
        VStack(alignment: .leading, spacing: 0) {
            ZStack(alignment: .bottomLeading) {
                LinearGradient(colors: [Color.accentFill.opacity(0.55), Color.accentFill.opacity(0.08)],
                               startPoint: .topTrailing, endPoint: .bottomLeading)
                Image(systemName: "cross.case.fill")
                    .font(.system(size: 110, weight: .light))
                    .foregroundStyle(.white.opacity(0.18))
                    .rotationEffect(.degrees(-10))
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                    .offset(x: 18, y: 8)
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 4) {
                    Text(verbatim: "TODAY'S FOCUS · 5 MIN")
                        .font(.caption.weight(.semibold))
                        .tracking(1.2)
                        .foregroundStyle(.white.opacity(0.8))
                    Text(verbatim: "Moving an appointment")
                        .font(.title2.weight(.bold))
                        .foregroundStyle(.white)
                }
                .padding(Spacing.cardLarge)
            }
            .frame(height: 170)
            .clipped()

            VStack(alignment: .leading, spacing: 14) {
                Text(verbatim: "A phone call at the dentist. Practises the word order you mixed up yesterday.")
                    .font(.body)
                    .foregroundStyle(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
                StartTalkingButton(action: action)
            }
            .padding(Spacing.cardLarge)
        }
        .background(.surface)
        .clipShape(.rect(cornerRadius: Radius.hero, style: .continuous))
    }

    // MARK: 6 Compact

    private var compact: some View {
        VStack(spacing: 14) {
            HStack(spacing: 12) {
                icon(size: 44, font: .title3)
                VStack(alignment: .leading, spacing: 2) {
                    Text(verbatim: "Moving an appointment")
                        .font(.headline)
                    Text(verbatim: "Today's focus · Phone call")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
                Spacer(minLength: 8)
                Text(verbatim: "5 min")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.accent)
            }
            StartTalkingButton(action: action)
        }
        .padding(Spacing.card)
        .background(.surface, in: .rect(cornerRadius: Radius.card, style: .continuous))
    }

    // MARK: Parts

    private func icon(size: CGFloat, font: Font) -> some View {
        Image(systemName: "cross.case.fill")
            .font(font)
            .symbolRenderingMode(.hierarchical)
            .foregroundStyle(.accent)
            .frame(width: size, height: size)
            .background(.accentFill.opacity(0.2), in: .rect(cornerRadius: 14, style: .continuous))
            .accessibilityHidden(true)
    }

    private func titleAndReason(_ font: Font) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(verbatim: "Moving an appointment")
                .font(font.weight(.bold))
                .fixedSize(horizontal: false, vertical: true)
            Text(verbatim: "Practises the word order you mixed up yesterday.")
                .font(.body)
                .foregroundStyle(.secondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

/// A rounded rectangle with a small tail at the top, pointing up to the companion.
private struct SpeechBubble: Shape {
    func path(in rect: CGRect) -> Path {
        let tail: CGFloat = 12
        let body = CGRect(x: rect.minX, y: rect.minY + tail, width: rect.width, height: rect.height - tail)
        var path = Path(roundedRect: body, cornerRadius: Radius.hero, style: .continuous)
        let mid = rect.midX
        path.move(to: CGPoint(x: mid - 14, y: body.minY))
        path.addLine(to: CGPoint(x: mid, y: rect.minY))
        path.addLine(to: CGPoint(x: mid + 14, y: body.minY))
        path.closeSubpath()
        return path
    }
}

#Preview {
    ScrollView {
        FocusCardChooser {}
            .padding(Spacing.screen)
    }
    .background(.screenBackground)
    .environment(AppState())
}
