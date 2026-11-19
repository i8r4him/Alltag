//
//  ReadDoSection.swift
//  Alltag
//
//  Created by Ibrahim Abdullah on 07.11.26.
//

import SwiftUI

/// Read's "Read and do": the level's scenes as a row of cards, each showing
/// the top of the thing as it looks, ticked once done.
struct ReadDoSection: View {
    let level: Level
    let done: Set<String>
    let zoom: Namespace.ID
    let onOpen: (ReadDoScene) -> Void

    @ScaledMetric(relativeTo: .body) private var cardWidth: CGFloat = 220
    @ScaledMetric(relativeTo: .body) private var previewHeight: CGFloat = 190

    var body: some View {
        let scenes = ReadDoScenes.scenes(at: level)
        if !scenes.isEmpty {
            LearnSection(title: "Read and do",
                         note: Text("\(scenes.filter { done.contains($0.id) }.count) of \(scenes.count) done")) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Find the answer in the real thing and tap it.")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 4)
                    cards(scenes)
                }
            }
        }
    }

    private func cards(_ scenes: [ReadDoScene]) -> some View {
        ScrollView(.horizontal) {
            GlassEffectContainer(spacing: 14) {
                HStack(spacing: 14) {
                    ForEach(scenes) { scene in
                        Button { onOpen(scene) } label: {
                            ReadDoCard(scene: scene, isDone: done.contains(scene.id), previewHeight: previewHeight)
                                .frame(width: cardWidth)
                        }
                        .buttonStyle(.plain)
                        .matchedTransitionSource(id: scene.id, in: zoom)
                    }
                }
                .scrollTargetLayout()
            }
        }
        .scrollTargetBehavior(.viewAligned)
        .scrollClipDisabled()
        .scrollIndicators(.hidden)
        .scrollEdgeEffectStyle(.soft, for: .all)
    }
}

/// The top of the thing, fading out, with its name under it.
private struct ReadDoCard: View {
    let scene: ReadDoScene
    let isDone: Bool
    let previewHeight: CGFloat

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            ReadDoSheet(scene: scene)
                .dynamicTypeSize(.small)
                .frame(height: previewHeight, alignment: .top)
                .clipped()
                .mask {
                    LinearGradient(stops: [.init(color: .black, location: 0.7), .init(color: .clear, location: 1)],
                                   startPoint: .top, endPoint: .bottom)
                }
                .allowsHitTesting(false)
                .accessibilityHidden(true)
            HStack(alignment: .top, spacing: 8) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(scene.title)
                        .font(.headline)
                        .lineLimit(2)
                    Text(scene.detail)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
                Spacer(minLength: 0)
                if isDone {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.title3)
                        .foregroundStyle(.accent)
                        .accessibilityLabel(Text("Done"))
                }
            }
            .padding(.horizontal, 6)
        }
        .padding(12)
        .glassEffect(.regular.interactive(), in: .rect(cornerRadius: Radius.card, style: .continuous))
        .contentShape(.rect(cornerRadius: Radius.card, style: .continuous))
        .accessibilityElement(children: .combine)
    }
}
